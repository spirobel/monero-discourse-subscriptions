# frozen_string_literal: true

module MoneroDiscourseSubscriptions
    class ProductController < ::ApplicationController
      def index
        products = MoneroProduct.includes(:monero_plans).to_a 
        products.each {|product|
          last_ending = product.monero_subscriptions.where(recipient: current_user, ended: false).order(end: :desc).first
          product.subscribed= false
          if last_ending
            product.subscribed= true
            product.end_date = last_ending.end
          end

        } 
        render :json => products.to_json( :include => [:monero_plans], :methods => [:subscribed, :stagenet, :end_date] )
      end

      
      def show
        params.require(:id)
        product = MoneroProduct.includes(:monero_plans).find_by_id(params[:id])
        product.subscribed= false
        last_ending = product.monero_subscriptions.where(recipient: current_user, ended: false).order(end: :desc).first
        product.subscribed= false
        if last_ending
          product.subscribed= true
          product.end_date = last_ending.end
        end

        render :json => product.to_json( :include => [:monero_plans],:methods => [:subscribed, :stagenet, :end_date]  )
      end

      def create
          group = Group.find_by_id(create_product_params[:group])
          other_product = MoneroProduct.where(group: group).first
          if other_product
            render_json_error 'The product called "'+ other_product[:name] + '" already manages this group. Please select a different one!'
            return
          end
          monero_wallet = MoneroWallet.find_by_id(create_product_params[:monero_wallet])
          product = MoneroProduct.create(group: group,
            monero_wallet: monero_wallet,
             name: create_product_params[:name],
             description: create_product_params[:description],
             active: create_product_params[:active],
             position: create_product_params[:position],
             )
             product.monero_plans.create([
              { currency: 'usd', amount: '0',duration:86400, active: false, repurchaseable: true, position: 0 }, #daily
              { currency: 'usd', amount: '0',duration:604800, active: false, repurchaseable: true, position: 1 }, #weekly
              { currency: 'usd', amount: '0',duration:2678400, active: false, repurchaseable: true, position: 2 }, #monthly
              { currency: 'usd', amount: '0',duration:31536000, active: false, repurchaseable: true, position: 3 }, #yearly
              { currency: 'usd', amount: '0',duration:99999999, active: false, repurchaseable: true, position: 4 }, #lifetime
             ])

          render_json_dump product
      end
      def update_plans
        plans = []
        update_plans_params[:plans].each { |k, plan|
          p = MoneroPlan.find_by_id(plan[:id])
          plans.append(p.update(
            currency: plan[:currency],
            amount: plan[:amount],
            active: plan[:active],
            repurchaseable: plan[:repurchaseable],
            position: plan[:position],
            ))
          }
        render_json_dump plans
      end
      def update
        group = Group.find_by_id(update_product_params[:group])
        other_product = MoneroProduct.where(group: group).first
        if other_product
          render_json_error 'The product called "'+ other_product[:name] + '" already manages this group. Please select a different one!'
          return
        end
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
        subscriptions = product.monero_subscriptions.empty?
        unless subscriptions
          render_json_error "This product can't be deleted because it has subscriptions from users. Make it inactive instead of deleting it."
          return
        end
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
      def update_plans_params
        params.permit(:plans => [:currency, :amount,:active, :repurchaseable, :position, :id])
      end
    end
end