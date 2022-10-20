# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'json'

module MoneroDiscourseSubscriptions
    class WalletController < ::ApplicationController
      def index
        wallets = ::MoneroWallet.all.to_a
        render_json_dump wallets
      end

      def create
        network = "mainnet"
        if wallet_create_params[:stagenet]
          network = "stagenet"
        end
        root_directory ||= File.join(Rails.root, "public", "backups")

        base_directory = File.join(root_directory, "wallets")
        FileUtils.mkdir_p(base_directory) unless Dir.exist?(base_directory)

        uri = URI.parse("http://localhost:3001/v1/wallet/initialize")
        request = Net::HTTP::Post.new(uri)
        request.content_type = "application/json"
        request["Accept"] = "application/json"
        request.body = JSON.dump({
          "path" => base_directory +"/"+ wallet_create_params[:primaryAddress],
          "networkType" => network,
          "primaryAddress" => wallet_create_params[:primaryAddress],
          "privateViewKey" => wallet_create_params[:privateViewKey],
          "restoreHeight" => wallet_create_params[:restoreHeight].to_i
        })
        
        req_options = {
          use_ssl: uri.scheme == "https",
        }
        
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
        

        if response.kind_of? Net::HTTPSuccess
          render_json_dump MoneroWallet.create(wallet_create_params)
        else
          error = JSON.parse(response.body)
          render_json_error error["message"]
        end

      end
      def update
        wallet = MoneroWallet.find_by_id(wallet_update_params[:id])
        render_json_dump wallet.update(wallet_update_params)
      end
      def delete
        params.require(:id)
        wallet = MoneroWallet.find_by_id(params[:id])
        if MoneroProduct.where(monero_wallet_id: wallet.id).exists?
          render_json_error "There is a product that uses this wallet. Delete it first!"
        else
          root_directory ||= File.join(Rails.root, "public", "backups")

          base_directory = File.join(root_directory, "wallets")
          wallet_base_path = base_directory +"/"+ wallet[:primaryAddress]
          FileUtils.rm_f([wallet_base_path, wallet_base_path + ".address.txt", wallet_base_path + ".keys"])
          render_json_dump wallet.destroy
        end
      end
      def wallet_create_params
        params.permit(      
          :primaryAddress,
          :privateViewKey,
          :restoreHeight,
          :stagenet,
          :name,
          :serverUri,
          )
      end

      def wallet_update_params
        params.permit(:serverUri, :id)
      end
  
    end
end