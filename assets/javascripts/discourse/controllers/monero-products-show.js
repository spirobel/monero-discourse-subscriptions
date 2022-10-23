import Controller from "@ember/controller";
import discourseComputed from "discourse-common/utils/decorators";
import User from "discourse/models/user";

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

});