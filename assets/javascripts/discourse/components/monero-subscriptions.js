import Component from "@ember/component";
import MoneroSubscription from "../models/monero-subscription";
import discourseComputed from "discourse-common/utils/decorators";
import { isEmpty } from "@ember/utils";

export default Component.extend({
    subscriptions: null,
    open_invoices: null,
    didInsertElement(){
        let that = this;
        MoneroSubscription.findAll().then(data=>{
            that.set('subscriptions', data.subscriptions);
            that.set('open_invoices', data.open_invoices);
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
    @discourseComputed("open_invoices")
    currentlyNoOpenInvoices(open_invoices){
      return isEmpty(open_invoices);
    },
});