import Controller from "@ember/controller";

export default Controller.extend({
    queryParams: ['selectedPlanId'],
    selectedPlanId: null,
    actions: {
        planClick(id){
            this.set('selectedPlanId', id);
        }
    }

});