import Component from "@ember/component";
import discourseComputed from "discourse-common/utils/decorators";

export default Component.extend({
    actions: {
        planClick(id){
          this.planClick(id);
        }
      },
  @discourseComputed("selectedPlanId")
  selected(selectedPlanId){
    return this.plan.id == selectedPlanId;
  },
});