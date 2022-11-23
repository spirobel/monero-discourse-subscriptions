# frozen_string_literal: true
def sendpm(title,message, target_user_id)
  target = User.find_by_id(target_user_id)
  pm = {}
  pm['title'] = title
  pm['raw'] = message
  pm['target_usernames'] = Array(target.username)
  pm = pm.symbolize_keys
  sender = Discourse.system_user
  pm = pm.merge(archetype: Archetype.private_message)
  PostCreator.new(sender, pm).create
end

module ::Jobs
    class MakeSureSubscribersAreInGroups < ::Jobs::Scheduled
      every 10.seconds
  
      def execute(args)
        subscriptions = MoneroSubscription.where(ended: false).to_a
        subscriptions.each { |subscription, k|
          group = subscription.monero_plan.monero_product.group
          user = subscription.recipient

          if (DateTime.current >= subscription[:begin_date] && # currently running  
               DateTime.current <= subscription[:end])
            group.add(user)
          elsif DateTime.current > subscription[:end] # subscription ended
            group.remove(user)
            subscription.update(ended: true)

            sendpm("Subscription ended! Your subscription for " + subscription.monero_plan.monero_product.name.to_s + " has just ended!",
              "Subscription ended! Your subscription for " + subscription.monero_plan.monero_product.name.to_s + " has just ended! You are now no longer member of the " + subscription.monero_plan.monero_product.group.name.to_s + " group until you prolong your subscription. [click here to prolong!](/monero/products/" + subscription.monero_plan.monero_product_id.to_s + "?selectedPlanId=" + subscription.monero_plan_id.to_s + ")",
              user.id)
          end
        }
      end
    end
  end