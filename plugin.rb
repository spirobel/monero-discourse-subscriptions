# frozen_string_literal: true

# name: monero-discourse-subscriptions
# about: This plugin enables you to give your users access to private Discourse groups and categories for Monero payments.
# version: 0.0.1
# authors: Discourse
# url: https://github.com/spirobel/monero-discourse-subscriptions
# required_version: 2.7.0

enabled_site_setting :monero_discourse_subscriptions_enabled

after_initialize do
  add_admin_route 'monero_discourse_subscriptions.admin_navigation', 'monero-discourse-subscriptions.products'
  Discourse::Application.routes.append do
    get '/admin/plugins/monero-discourse-subscriptions' => 'admin/plugins#index', constraints: AdminConstraint.new
    get '/admin/plugins/monero-discourse-subscriptions/products' => 'admin/plugins#index', constraints: AdminConstraint.new
    get '/admin/plugins/monero-discourse-subscriptions/wallets' => 'admin/plugins#index', constraints: AdminConstraint.new

    get '/admin/plugins/monero-discourse-subscriptions/wallets-json' => 'wallet/plugins#index', constraints: AdminConstraint.new
    post '/admin/plugins/monero-discourse-subscriptions/wallets' => 'wallet/plugins#create', constraints: AdminConstraint.new
    get '/admin/plugins/monero-discourse-subscriptions/wallets/:id' => 'wallet/plugins#show', constraints: AdminConstraint.new
    patch '/admin/plugins/monero-discourse-subscriptions/wallets/:id' => 'wallet/plugins#update', constraints: AdminConstraint.new
    delete '/admin/plugins/monero-discourse-subscriptions/wallets/:id' => 'wallet/plugins#delete', constraints: AdminConstraint.new

  end
end
