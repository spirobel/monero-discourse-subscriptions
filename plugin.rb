# frozen_string_literal: true

# name: monero-discourse-subscriptions
# about: This plugin enables you to give your users access to private Discourse groups and categories for Monero payments.
# version: 0.0.1
# authors: Discourse
# url: https://github.com/spirobel/monero-discourse-subscriptions
# required_version: 2.7.0

enabled_site_setting :monero_discourse_subscriptions_enabled


register_asset "stylesheets/common/layout.scss"
register_asset "stylesheets/mobile/main.scss"






after_initialize do
  module ::MoneroDiscourseSubscriptions
    class Engine < ::Rails::Engine
      engine_name 'monero-discourse-subscriptions'
      isolate_namespace MoneroDiscourseSubscriptions
    end
  end

  require_relative "app/controllers/monero_subscriptions/wallet_controller.rb"
  require_relative "app/controllers/monero_subscriptions/product_controller.rb"
  require_relative "app/models/monero_subscriptions/monero_product.rb"
  require_relative "app/models/monero_subscriptions/monero_wallet.rb"
  MoneroDiscourseSubscriptions::Engine.routes.draw do
    get '/wallets' => 'wallet#index', constraints: AdminConstraint.new
    post '/wallets' => 'wallet#create', constraints: AdminConstraint.new
    get '/wallets/:id' => 'wallets#show', constraints: AdminConstraint.new
    patch '/wallets/:id' => 'wallet#update', constraints: AdminConstraint.new
    delete '/wallets/:id' => 'wallet#delete', constraints: AdminConstraint.new

    get '/products' => 'product#index', constraints: AdminConstraint.new
    post '/products' => 'product#create', constraints: AdminConstraint.new
    get '/products/:id' => 'product#show', constraints: AdminConstraint.new
    patch '/products/:id' => 'product#update', constraints: AdminConstraint.new
    delete '/products/:id' => 'product#delete', constraints: AdminConstraint.new
  end

  add_admin_route 'monero_discourse_subscriptions.admin_navigation', 'monero-discourse-subscriptions.products'
  Discourse::Application.routes.append do
    get '/admin/plugins/monero-discourse-subscriptions' => 'admin/plugins#index', constraints: AdminConstraint.new
    get '/admin/plugins/monero-discourse-subscriptions/products' => 'admin/plugins#index', constraints: AdminConstraint.new
    get '/admin/plugins/monero-discourse-subscriptions/wallets' => 'admin/plugins#index', constraints: AdminConstraint.new
    mount ::MoneroDiscourseSubscriptions::Engine, at: "/monero",  defaults: {format: "json"}

  
  end

end
