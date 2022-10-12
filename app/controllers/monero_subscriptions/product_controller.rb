# frozen_string_literal: true

module MoneroDiscourseSubscriptions
    class ProductController < ::ApplicationController
      def index
        products = ::MoneroProduct.all.to_a
        render_json_dump products
      end

      def create
          group = Group.find_by_id(create_product_params[:group])
          monero_wallet = MoneroWallet.find_by_id(create_product_params[:monero_wallet])
          render_json_dump MoneroProduct.create(group: group,
             monero_wallet: monero_wallet,
              name: create_product_params[:name],
              description: create_product_params[:description],
              active: create_product_params[:active],
              position: create_product_params[:position],
              )
      end
      def update
        group = Group.find_by_id(update_product_params[:group])
        monero_wallet = MoneroWallet.find_by_id(update_product_params[:monero_wallet])
        product = MoneroProduct.find_by_id(update_product_params[:id])
        render_json_dump product.update(group: group,
          monero_wallet: monero_wallet,
           name: update_product_params[:name],
           description: update_product_params[:description],
           active: update_product_params[:active],
           position: update_product_params[:position],
           )
      end
      def delete
        params.require(:id)
        product = MoneroProduct.find_by_id(params[:id])
        render_json_dump product.destroy
      end
      
      def create_product_params
        params.permit(      
          :name,
          :description,
          :active,
          :position,
          :group,
          :monero_wallet)
      end
      def update_product_params
        params.permit( 
          :id,     
          :name,
          :description,
          :active,
          :position,
          :group,
          :monero_wallet)
      end
    end
end