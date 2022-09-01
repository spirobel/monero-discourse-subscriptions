# frozen_string_literal: true

# name: monero-discourse-subscriptions
# about: TODO
# version: 0.0.1
# authors: Discourse
# url: TODO
# required_version: 2.7.0

enabled_site_setting :monero_discourse_subscriptions_enabled

after_initialize do
    module ::MoneroDiscourseSubscriptions
        PLUGIN_NAME ||= "monero_discourse_subscription"
    
        class Engine < ::Rails::Engine
          engine_name PLUGIN_NAME
          isolate_namespace MoneroDiscourseSubscriptions
        end
    
        class Error < StandardError; end
      end
    puts "plugin test"
end
