# frozen_string_literal: true
module MoneroDiscourseSubscriptions
  module Admin
    class WalletController < ::Admin::AdminController
      def index
        wallets = MoneroWallet.all
        render_json_dump wallets
      end

      def create
        params.permit(      
          :primaryAddress,
          :privateViewKey,
          :restoreHeight,
          :stagenet,
          :name,
          :serverUri,
          :callback)
          render_json_dump MoneroWallet.create(params)
      end
      def update
        params.require(:id).permit(      
          :primaryAddress,
          :privateViewKey,
          :restoreHeight,
          :stagenet,
          :name,
          :serverUri,
          :callback)
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
  
    end
  end
end