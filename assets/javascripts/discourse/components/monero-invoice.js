import Component from "@ember/component";
import { cancel, later, next } from '@ember/runloop';
import showModal from 'discourse/lib/show-modal';


export default Component.extend({
  poller: null,
  minutesLeft: null,
  didInsertElement(){
      this.sendAction("planClick", this.selectedPlanId);
      next(this, function(){
        this.poller = this.pollTimeLeft();
      });
},
willDestroyElement() {
  cancel(this.poller);
},
pollTimeLeft(){
  return later(this,function(){
    if(this.invoice){
      this.set('minutesLeft',moment.duration(moment(this.invoice.amount_date).utc().valueOf() - moment().subtract(30, 'minutes').utc().valueOf()).humanize());
      if(moment.duration(moment(this.invoice.amount_date).utc().valueOf() - moment().subtract(30, 'minutes').utc().valueOf()).as('milliseconds') <= 0){
        this.refreshInvoice(this.invoice.monero_plan_id);

      }
    }
      this.poller = this.pollTimeLeft();
  },1000);
},
  actions: {
    refreshInvoice(){
      this.refreshInvoice(this.invoice.monero_plan_id);
    },
    showInvoice(invoice) {
      let duration = 0;
      for (const x of this.plans) {
        if(x.id === Number(this.selectedPlanId)){
          duration = x.duration;
        }
      }
      showModal('show-monero-invoice', {
        model: {payments: invoice.monero_payments, product_name: this.product_name, duration}
      });
    },
  },
});