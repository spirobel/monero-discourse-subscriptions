module MoneroDiscourseSubscriptions
    class SubscriptionController < ::ApplicationController
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
            begin_date = DateTime.current
            end_date = DateTime.current + monero_plan[:duration].seconds
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
                render :json => subscriptions.to_json( :include => [:buyer, :recipient],:methods => [:buyer_name, :recipient_name, :product_name, :duration] )
            else

                subscriptions = MoneroSubscription.order(created_at: :desc).limit(10).offset(page * 10)
                render :json => subscriptions.to_json( :include => [:buyer, :recipient],:methods => [:buyer_name, :recipient_name, :product_name, :duration] )
            end
        end
        
        def delete
            params.require(:id)
            subscription = MoneroSubscription.find_by_id(params[:id])
            render_json_dump subscription.destroy
        end
          
        def update
            subscription = MoneroSubscription.find_by_id(params[:id])
            render_json_dump subscription.update(begin_date: Time.at(params[:begin_date].to_i),
                                                            end: Time.at(params[:end].to_i))
        end

    end
end