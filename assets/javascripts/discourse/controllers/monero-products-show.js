import Controller from "@ember/controller";
import discourseComputed from "discourse-common/utils/decorators";
import User from "discourse/models/user";
import { isEmpty } from "@ember/utils";

export default Controller.extend({
    queryParams: ['selectedPlanId'],
    selectedPlanId: null,
    actions: {
        planClick(id){
            this.set('selectedPlanId', id);
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