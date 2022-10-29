# frozen_string_literal: true

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
          end
        }
      end
    end
  end