require 'net/http'
require 'uri'
require 'json'

module MoneroDiscourseSubscriptions
    class InvoiceController < ::ApplicationController
        requires_login
      
        def myinvoice
            plan = MoneroPlan.find_by_id(params[:plan_id])
            if plan.nil?
                render_json_error "plan does not exist"
                return
            end
            invoice = MoneroInvoice.where(recipient: current_user, monero_plan: plan).first
            if invoice.nil?
                invoice = MoneroInvoice.create(recipient: current_user, buyer: current_user, monero_plan: plan)
            end
            amount_old = true
            unless invoice.amount_date.nil?
                amount_old = invoice.amount_date > (DateTime.current - 30.minutes)
            end
            if (invoice.amount.nil? || amount_old || params[:refresh])
                synced = false
                uri = URI.parse("http://localhost:3001/v1/wallets/status")
                request = Net::HTTP::Get.new(uri)
                request["Accept"] = "application/json"
        
                req_options = {
                  use_ssl: uri.scheme == "https",
                }
        
                response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
                  http.request(request)
                end
        
                wallets = JSON.parse(response.body)
                wallets.each { |k, wallet|
                    if wallet["path"].include? plan.monero_product.monero_wallet[:primaryAddress]
                        if wallet.key?(:percentDone)
                            synced = true if wallet[:percentDone] == 1
                        end
                    end
                }
                unless synced
                    render_json_error "Please retry in a minute. We need to wait for sync to catch up. If this persists, please reach out via email! "
                    return
                end
                root_directory ||= File.join(Rails.root, "public", "backups")

                base_directory = File.join(root_directory, "wallets")
                wallet_base_path = base_directory +"/"+ plan.monero_product.monero_wallet[:primaryAddress]
                #or missing amount
                invoice_fiat_amount = plan[:amount].to_f
                if invoice[:missing_amount]
                    invoice_fiat_amount = invoice[:missing_amount].to_f
                end
                #update the invoice with the stuff that comes out of this
                invoice_request_json = makeinvoicerequest(wallet_base_path,
                     invoice[:id], invoice_fiat_amount, plan[:currency])
                    
                invoice = invoice.update(address: invoice_request_json["address"],
                    amount: invoice_request_json["amount"],
                    display_amount: invoice_request_json["display_amount"],
                    payment_uri: invoice_request_json["payment_uri"],
                    payment_uri_qrcode: invoice_request_json["payment_uri_qrcode"],
                    amount_date: DateTime.current)
            end
            render_json_dump invoice

        end

        #"/monero/callback/" + callbackSecret
        #check if fullfils amount if not calcuclate missing amount in usd and send pm to recheck
        def callback
            
            wallet =  MoneroWallet.where(callbackSecret: params[:callback_secret]).first
            if wallet
                transactions = JSON.parse(request.raw_post)
                transactions.each { |k, transaction|

                   #[ this is what a typical object in the array looks like
                   #     {
                   #       "payment_id": 0,
                   #       "amount": "string",
                   #       "tx_hash": "string",
                   #       "height": 0,
                   #       "confirmations": 0, <--- updated as new blocks come in
                   #       "isConfirmed": true <--- updated as new blocks come in
                   #     }
                   #   ]

                    transaction_sql = MoneroPayment.where(payment_id: transaction[:payment_id]).first
                    unless transaction_sql
                        transaction_sql = MoneroPayment.create(payment_id: transaction[:payment_id],
                            amount: transaction[:amount],
                            height: transaction[:height],
                            tx_hash: transaction[:tx_hash],
                            confirmations: transaction[:confirmations],
                            isConfirmed: transaction[:isConfirmed])
                    end
                    if transaction_sql[:confirmations] < transaction[:confirmations]
                        transaction_sql.update(confirmations: transaction[:confirmations])
                    end

                    if transaction[:isConfirmed]
                        transaction_sql.update(isConfirmed: transaction[:isConfirmed])

                    end
                    invoice = MoneroInvoice.find_by_id(transaction[:payment_id])
                    if(invoice && !invoice[:paid] && transaction[:isConfirmed])
                        # 1. convert invoice and transaction amount to bignumber
                        invoice_amount = invoice[:amount].to_i 
                        transaction_amount = transaction[:amount].to_i

                        # 2. check if the amount is old
                        amount_old = true 
                        unless invoice.amount_date.nil?
                            amount_old = invoice.amount_date > (DateTime.current - 30.minutes)
                        end

                        # 3. check if the amount is paid or not
                        if (invoice_amount <= transaction_amount && !amount_old) # paid
                            paidCondition(invoice)
                        else 
                            converted_invoice_amount = convertAmount(invoice.monero_plan[:currency], invoice[:amount])
                            converted_transaction_amount = convertAmount(invoice.monero_plan[:currency], transaction[:amount])
                            
                            if converted_invoice_amount <= converted_transaction_amount  # paid : we also accept if the amount is bigger or equal the invoice (in fiat) at the time the transaction was received.
                                paidCondition(invoice)
                            else # not_paid : calculate the missing amount, send pm and make new invoice 
                                missing_amount = invoice_amount - transaction_amount
                                missing_amount_converted = convertAmount(invoice.monero_plan[:currency], missing_amount)
                                root_directory ||= File.join(Rails.root, "public", "backups")

                                base_directory = File.join(root_directory, "wallets")
                                wallet_base_path = base_directory +"/"+ invoice.monero_plan.monero_product.monero_wallet[:primaryAddress]
                                invoice_request_json = makeinvoicerequest(wallet_base_path,
                                    invoice[:id], missing_amount_converted, invoice.monero_plan[:currency])

                                invoice.update(address: invoice_request_json["address"],
                                    amount: invoice_request_json["amount"],
                                    display_amount: invoice_request_json["display_amount"],
                                    payment_uri: invoice_request_json["payment_uri"],
                                    payment_uri_qrcode: invoice_request_json["payment_uri_qrcode"],
                                    missing_amount: missing_amount_converted.to_s,
                                    amount_date: DateTime.current)
                                #TODO send pm
                            end
                        end
                    end                    
                 }
            end
        end
        private
        def makeinvoicerequest(path, payment_id, amount, currency)
            uri = URI.parse("http://localhost:3001/v1/make/invoice")
            request = Net::HTTP::Post.new(uri)
            request.content_type = "application/json"
            request["Accept"] = "application/json"
            request.body = JSON.dump({
                "path" => path,
                "payment_id" => payment_id,
                "amount" => amount,
                "currency" => currency
            })

            req_options = {
                use_ssl: uri.scheme == "https",
            }

            response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
                http.request(request)
            end

            return JSON.parse(response.body)
            # response typically looks like: {
            #       "address": "5F6eAUGSaWAQX1CydtFfPk96uHEFxSxvD9AYBy7dwnYt9cXqKDjix9rS9AWZ5GnH4B1Z7yHr3B2UH2updNw5ZNJEMQZ4hUuBBeAEYH6koo",
            #       "address_qrcode": "data:image/png;base64,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",
            #       "amount": "77220070000",
            #       "display_amount": "0.07722007",
            #       "payment_uri": "monero:5F6eAUGSaWAQX1CydtFfPk96uHEFxSxvD9AYBy7dwnYt9cXqKDjix9rS9AWZ5GnH4B1Z7yHr3B2UH2updNw5ZNJEMQZ4hUuBBeAEYH6koo?tx_amount=0.07722007",
            #       "payment_uri_qrcode": "data:image/png;base64,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"
            #   }

        end

        def convertAmount(currency, amount)
            uri = URI.parse("http://localhost:3001/v1/convert/amount")
            request = Net::HTTP::Post.new(uri)
            request.content_type = "application/json"
            request["Accept"] = "application/json"
            request.body = JSON.dump({
                "amount" => amount,
                "currency" => currency
            })

            req_options = {
            use_ssl: uri.scheme == "https",
            }

            response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
                http.request(request)
            end
            return JSON.parse(response.body)["amount"].to_f
        end

        def paidCondition(invoice)

            buyer = User.find_by_username(invoice[:buyer])
            recipient = User.find_by_username(invoice[:recipient])
            monero_plan = MoneroPlan.find_by_id(invoice[:monero_plan_id])
            currency = monero_plan[:currency]
            amount = monero_plan[:amount]

            last_ending = monero_plan.monero_product.monero_subscriptions.where(recipient: recipient, ended: false).order(end: :desc).first
            begin_date = DateTime.current
            unless last_ending.nil?
                begin_date = last_ending.end - 10.seconds
            end
            end_date = begin_date + monero_plan[:duration].seconds
            if monero_plan[:duration] == 99999999
                end_date = DateTime.current + 100.years
            end

            subscription = MoneroSubscription.create(buyer: buyer, recipient: recipient,
            end: end_date, begin_date: begin_date, ended: false, monero_plan: monero_plan, amount: amount, currency: currency)

            invoice.update(paid: true)
             #TODO send pm

        end
     

    end
end