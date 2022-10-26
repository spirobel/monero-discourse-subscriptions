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
            end_date = DateTime.current + monero_plan[:duration]

            subscription = MoneroSubscription.create(buyer: buyer, recipient: recipient,
            end: end_date, ended: false, monero_plan: monero_plan, amount: amount, currency: currency)
            render_json_dump subscription
            
        end
        def index
            page = params[:page].to_i || 0
            subscriptions = MoneroSubscription.order(created_at: :desc).limit(1).offset(page * 1)
            render :json => subscriptions.to_json( :include => [:buyer, :recipient],:methods => [:buyer_name, :recipient_name, :product_name, :duration] )

        end
    end
end