# frozen_string_literal: true

module MoneroDiscourseSubscriptions
    class WalletController < ::ApplicationController
      def index
        wallets = ::MoneroWallet.all.to_a
        render_json_dump wallets
      end

      def create
          render_json_dump MoneroWallet.create(wallet_create_params)
      end
      def update
        wallet = MoneroWallet.find_by_id(wallet_update_params[:id])
        render_json_dump wallet.update(wallet_update_params)
      end
      def delete
        params.require(:id)
        wallet = MoneroWallet.find_by_id(params[:id])
        render_json_dump wallet.destroy
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