# frozen_string_literal: true

# name: monero-discourse-subscriptions
# about: This plugin enables you to give your users access to private Discourse groups and categories for Monero payments.
# version: 0.0.1
# authors: Discourse
# url: https://github.com/spirobel/monero-discourse-subscriptions
# required_version: 2.7.0

enabled_site_setting :monero_discourse_subscriptions_enabled


register_asset "stylesheets/common/layout.scss"
register_asset "stylesheets/desktop/main.scss", :desktop
register_asset "stylesheets/mobile/main.scss" , :mobile
register_svg_icon "gift" if respond_to?(:register_svg_icon)
register_svg_icon "far-credit-card" if respond_to?(:register_svg_icon)







after_initialize do
  module ::MoneroDiscourseSubscriptions
    class Engine < ::Rails::Engine
      engine_name 'monero-discourse-subscriptions'
      isolate_namespace MoneroDiscourseSubscriptions
    end
  end
  require_relative "app/controllers/monero_subscriptions/wallet_controller.rb"
  require_relative "app/controllers/monero_subscriptions/product_controller.rb"
  require_relative "app/controllers/monero_subscriptions/subscription_controller.rb"
  require_relative "app/controllers/monero_subscriptions/invoice_controller.rb"
  require_relative "app/controllers/monero_subscriptions/admin_controller.rb"

  require_relative "app/models/monero_subscriptions/monero_plan.rb"
  require_relative "app/models/monero_subscriptions/monero_product.rb"
  require_relative "app/models/monero_subscriptions/monero_wallet.rb"
  require_relative "app/models/monero_subscriptions/monero_subscription.rb"
  require_relative "app/models/monero_subscriptions/monero_invoice.rb"
  require_relative "app/models/monero_subscriptions/monero_payment.rb"



  require_relative "app/jobs/scheduled/make_sure_wallets_are_synced.rb"
  require_relative "app/jobs/scheduled/make_sure_subscribers_are_in_groups.rb"

  MoneroDiscourseSubscriptions::Engine.routes.draw do
    get '/wallets' => 'wallet#index', constraints: AdminConstraint.new
    get '/walletstatus' => 'wallet#status', constraints: AdminConstraint.new
    post '/wallets' => 'wallet#create', constraints: AdminConstraint.new
    patch '/wallets/:id' => 'wallet#update', constraints: AdminConstraint.new
    delete '/wallets/:id' => 'wallet#delete', constraints: AdminConstraint.new

    get '/products' => 'product#index'
    get '/products/:id' => 'product#show'
    post '/products' => 'product#create', constraints: AdminConstraint.new
    patch '/products/:id' => 'product#update', constraints: AdminConstraint.new
    patch '/products_plans/' => 'product#update_plans', constraints: AdminConstraint.new
    delete '/products/:id' => 'product#delete', constraints: AdminConstraint.new

    get '/mysubscriptions' => 'subscription#mysubscriptions'
    get '/subscriptions' => 'subscription#index', constraints: AdminConstraint.new
    get '/subscriptions/:id' => 'subscription#show', constraints: AdminConstraint.new
    post '/subscriptions' => 'subscription#create', constraints: AdminConstraint.new
    patch '/subscriptions/:id' => 'subscription#update', constraints: AdminConstraint.new
    delete '/subscriptions/:id' => 'subscription#delete', constraints: AdminConstraint.new
    
    get '/myinvoice/:plan_id' => 'invoice#myinvoice'
    post '/callback/:callback_secret' => 'invoice#callback'

  end

  add_admin_route 'monero_discourse_subscriptions.admin_navigation', 'monero-discourse-subscriptions.products'
  Discourse::Application.routes.append do
    get '/admin/plugins/monero-discourse-subscriptions' => 'admin/plugins#index', constraints: AdminConstraint.new
    get '/admin/plugins/monero-discourse-subscriptions/products' => 'admin/plugins#index', constraints: AdminConstraint.new
    get '/admin/plugins/monero-discourse-subscriptions/wallets' => 'admin/plugins#index', constraints: AdminConstraint.new
    get '/admin/plugins/monero-discourse-subscriptions/subscriptions' => 'admin/plugins#index', constraints: AdminConstraint.new
    get 'u/:username/monero/subscriptions' => 'users#show', constraints: { username: USERNAME_ROUTE_FORMAT }

    mount ::MoneroDiscourseSubscriptions::Engine, at: "/monero"

  
  end

end
