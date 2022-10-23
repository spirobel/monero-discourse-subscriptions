# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'json'
require 'securerandom'


module ::Jobs
    class MakeSureWalletsAreSynced < ::Jobs::Scheduled
      every 10.seconds
  
      def execute(args)
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
        wallets_sql = ::MoneroWallet.all.to_a
        if wallets_sql.empty?
             return
        end
        wallets_sql.each { |wallet_sql, k|
            syncing = false
            unless wallets.empty?
            wallets.each { |k, wallet|
                if wallet["path"].include? wallet_sql[:primaryAddress]
                    if wallet.key?(:current_sync_height)
                        syncing = true
                    end
                end
            }
             end
            if (!syncing && wallet_sql.shouldSync)
                root_directory ||= File.join(Rails.root, "public", "backups")

                base_directory = File.join(root_directory, "wallets")
                wallet_base_path = base_directory +"/"+ wallet_sql[:primaryAddress]

                network = "mainnet"
                if wallet_sql[:stagenet]
                  network = "stagenet"
                end

                callbackSecret = SecureRandom.urlsafe_base64(20)
                w = MoneroWallet.find_by_id(wallet_sql[:id])
                w.update(callbackSecret: callbackSecret)
                uri = URI.parse("http://localhost:3001/v1/wallet/sync")
                request = Net::HTTP::Post.new(uri)
                request.content_type = "application/json"
                request["Accept"] = "application/json"
                request.body = JSON.dump({
                  "path" => wallet_base_path,
                  "networkType" => network,
                  "serverUri" => wallet_sql[:serverUri],
                  "callback" => Discourse.base_url + "/monero/callback/" + callbackSecret
                })
                
                req_options = {
                  use_ssl: uri.scheme == "https",
                }
                
                response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
                  http.request(request)
                end
                puts response.body
                if response.body.include? "Wallet does not exist at path"
                  uri = URI.parse("http://localhost:3001/v1/wallet/initialize")
                  request = Net::HTTP::Post.new(uri)
                  request.content_type = "application/json"
                  request["Accept"] = "application/json"
                  request.body = JSON.dump({
                    "path" => wallet_base_path,
                    "networkType" => network,
                    "primaryAddress" => wallet_sql[:primaryAddress],
                    "privateViewKey" => wallet_sql[:privateViewKey],
                    "restoreHeight" => wallet_sql[:restoreHeight].to_i
                  })
                  
                  req_options = {
                    use_ssl: uri.scheme == "https",
                  }
                  
                  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
                    http.request(request)
                  end
                end
            end
        }
      end
    end
  end