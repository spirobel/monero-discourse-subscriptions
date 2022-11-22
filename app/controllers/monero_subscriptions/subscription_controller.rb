module MoneroDiscourseSubscriptions
    class SubscriptionController < ::ApplicationController
        requires_login
        
        def create
            if params[:buyer].nil?
                render_json_error "please select a buyer" 
                return
            end
            if params[:recipient].nil?
                render_json_error "please select a recipient"
                return
            end
            if params[:monero_plan_id].nil?
                render_json_error "please select a plan"
                return
            end
            buyer = User.find_by_username(params[:buyer])
            recipient = User.find_by_username(params[:recipient])
            monero_plan = MoneroPlan.find_by_id(params[:monero_plan_id])
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
            render_json_dump subscription
            
        end
        def index
            page = params[:page].to_i || 0
            if params[:recipient] && !params[:recipient].empty?
                recipient = User.find_by_username(params[:recipient])
                subscriptions = MoneroSubscription.where(recipient: recipient).order(created_at: :desc).limit(10).offset(page * 10)
                render :json => subscriptions.to_json( :include => [:monero_payments],:methods => [:buyer_name, :recipient_name, :product_name, :duration, :invoice] )
            else

                subscriptions = MoneroSubscription.order(created_at: :desc).limit(10).offset(page * 10)
                render :json => subscriptions.to_json( :include => [:monero_payments],:methods => [:buyer_name, :recipient_name, :product_name, :duration, :invoice] )
            end
        end

        def mysubscriptions
            subscriptions = MoneroSubscription.where(recipient: current_user).order(created_at: :desc)
            open_invoices =  MoneroInvoice.joins(:monero_payments).where(paid: false, recipient: current_user).to_json( :include => [:monero_payments])
            subs_json = subscriptions.to_json( :include => [:monero_payments],:methods => [:buyer_name, :recipient_name, :product_name, :duration, :invoice] )
            render :json => JSON.dump({open_invoices:JSON.parse(open_invoices), subscriptions:(JSON.parse(subs_json))})
        end
        
        def delete
            params.require(:id)
            subscription = MoneroSubscription.find_by_id(params[:id])
            render_json_dump subscription.destroy
        end
          
        def update
            if Time.at(params[:begin_date].to_i) >= Time.at(params[:end].to_i)
                render_json_error "please make sure the subscription ends after it begins"
                return
            end
            subscription = MoneroSubscription.find_by_id(params[:id])
            up = subscription.update(begin_date: Time.at(params[:begin_date].to_i),
                                                            end: Time.at(params[:end].to_i))
            if up # the following makes sure the user is removed from the group 
                  # in case begin_date is moved to the future and the user is currently not subscribed
                group = subscription.monero_plan.monero_product.group
                user = subscription.recipient

                us = MoneroSubscription.where(ended: false,
                     recipient: subscription[:recipient], 
                    ).to_a
                user_currently_subscribed = false
                us.each { |s, k|

                  if (DateTime.current >= s[:begin_date] && # currently running  
                       DateTime.current <= s[:end] && 
                        s[:monero_plan][:monero_product][:group] == group) # same group

                    user_currently_subscribed = true
                  end
                }
                if (DateTime.current < subscription[:begin_date] && # not yet begun
                    !user_currently_subscribed)

                    group.remove(user)
                end
            end 

            # the make_sure_subscribers_are_in_groups will take care of adding the user to the group
            render_json_dump up                                                
        end

    end
end