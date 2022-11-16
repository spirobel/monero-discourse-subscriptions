import Component from "@ember/component";
export default Component.extend({
  didInsertElement(){
      this.sendAction("planClick", this.selectedPlanId);

},
  actions: {

  },
});