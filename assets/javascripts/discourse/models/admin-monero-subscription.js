import { ajax } from "discourse/lib/ajax";
import EmberObject from "@ember/object";

const AdminMoneroSubscription = EmberObject.extend({});
AdminMoneroSubscription.reopenClass({
    destroy(id) {
    return ajax(`/monero/subscriptions/${id}`, { method: "delete" });
  },

  save(params) {
    const data = {
      buyer: params.buyer,
      recipient: params.recipient,
      monero_plan_id: params.monero_plan_id,
    };

    return ajax("/monero/subscriptions", {
      method: "post",
      data,
    }).then((wallet) => AdminMoneroSubscription.create(wallet));
  },

  update(subscriptionParams) {
    const data = {
        begin_date: subscriptionParams.begin_date,
        end: subscriptionParams.end,
    };

    return ajax(`/monero/subscriptions/${subscriptionParams.id}`, {
      method: "patch",
      data,
    });
  },

});

AdminMoneroSubscription.reopenClass({
  findAll() {
    return ajax("/monero/subscriptions", { method: "get" }).then((result) => {
      if (result === null) {
        return { unconfigured: true };
      }
      return result.map((subscription) => AdminMoneroSubscription.create(subscription));
    });
  },
});

export default AdminMoneroSubscription;
