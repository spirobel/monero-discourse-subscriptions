import Component from "@ember/component";
import discourseComputed from "discourse-common/utils/decorators";

export default Component.extend({
    actions: {
        planClick(id){
          this.planClick(id);
        }
      },
  @discourseComputed("selectedPlanId")
  selectedClass(planId) {
    return Number(planId) === this.plan.id ? "btn-monero-discourse-subscriptions-subscribe btn-primary" : "btn-monero-discourse-subscriptions-subscribe";
  },
});