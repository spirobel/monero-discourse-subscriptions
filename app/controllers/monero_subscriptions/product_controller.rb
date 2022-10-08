# frozen_string_literal: true

module MoneroDiscourseSubscriptions
    class ProductController < ::ApplicationController
      def index
        products = ::MoneroProduct.all.to_a
        render_json_dump products
      end

      def create
        params.permit(      
          :name,
          :description,
          :restoreHeight,
          :active,
          :position,
          :group,
          :monero_wallet)
          render_json_dump MoneroProduct.create(params)
      end
      def update
        params.require(:id).permit(      
          :name,
          :description,
          :restoreHeight,
          :active,
          :position,
          :group,
          :monero_wallet)
        product = MoneroProduct.find_by(params[:id])
        render_json_dump product.update(params)
      end
      def delete
        params.require(:id)
        product = MoneroProduct.find_by(params[:id])
        render_json_dump product.destroy
      end
      def show
        params.require(:id)
        product = MoneroProduct.find_by(params[:id])
        render_json_dump product
      end
  
    end
end