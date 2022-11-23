import Component from "@ember/component";
import MoneroSubscription from "../models/monero-subscription";
import discourseComputed from "discourse-common/utils/decorators";
import { isEmpty } from "@ember/utils";
import showModal from 'discourse/lib/show-modal';


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
            showModal('show-monero-invoice', {
              model: {payments: subscription.monero_payments, product_name: subscription.product_name, duration: subscription.duration}
            });
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