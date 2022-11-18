import Component from "@ember/component";
import discourseComputed from "discourse-common/utils/decorators";

export default Component.extend({
  didInsertElement(){
      this.sendAction("planClick", this.selectedPlanId);

},
  actions: {
    refreshInvoice(invoice){
      console.log(invoice)
    }
  },
  @discourseComputed("invoice.amount_date")
  minutesLeft(date){
    return moment.duration(moment(date).utc().valueOf() - moment().subtract(30, 'minutes').utc().valueOf()).humanize() ;
  },
});