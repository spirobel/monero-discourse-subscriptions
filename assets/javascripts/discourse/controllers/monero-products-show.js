import Controller from "@ember/controller";
import discourseComputed from "discourse-common/utils/decorators";
import MoneroInvoice from "../models/monero-invoice";
import User from "discourse/models/user";
import { isEmpty } from "@ember/utils";

export default Controller.extend({
    queryParams: ['selectedPlanId'],
    selectedPlanId: null,
    invoice: null,
    error: null,
    actions: {
        planClick(planid){
            this.set('selectedPlanId', planid);
            let that = this;

            let found = function(data){
              that.set('invoice', data);
            };
            let notfound = function(error){
              that.set('invoice_error', error.jqXHR.responseJSON.errors[0]);
            };
            MoneroInvoice.findMyInvoice(planid).then(found).catch(notfound);
        }
    },
    @discourseComputed()
    isLoggedIn() {
      return User.current();
    },
    @discourseComputed("model.monero_plans")
    active_plans(plan) {
      return plan.filter(p=>p.active);
    },
    @discourseComputed("active_plans")
    noPlans(active_plans) {
      return isEmpty(active_plans);
    },

});