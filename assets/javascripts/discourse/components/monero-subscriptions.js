import Component from "@ember/component";
import MoneroSubscription from "../models/monero-subscription";
import discourseComputed from "discourse-common/utils/decorators";
import { isEmpty } from "@ember/utils";

export default Component.extend({
    subscriptions: null,
    didInsertElement(){
        let that = this;
        MoneroSubscription.findAll().then(data=>{
            that.set('subscriptions', data);
        });
    },

    actions: {
          showInvoice(subscription) {
            console.log("showInvoice", subscription)
          },
    },
    @discourseComputed("subscriptions")
    currentlyNoSubscriptions(subscriptions){
      return isEmpty(subscriptions);
    },
});