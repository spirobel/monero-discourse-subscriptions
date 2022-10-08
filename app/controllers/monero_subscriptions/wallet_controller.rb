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
        params.require(:id).permit(      
          :primaryAddress,
          :privateViewKey,
          :restoreHeight,
          :stagenet,
          :name,
          :serverUri,
         )
        wallet = MoneroWallet.find_by(params[:id])
        render_json_dump wallet.update(params)
      end
      def delete
        params.require(:id)
        wallet = MoneroWallet.find_by(params[:id])
        render_json_dump wallet.destroy
      end
      def show
        params.require(:id)
        wallet = MoneroWallet.find_by(params[:id])
        render_json_dump wallet
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
  
    end
end