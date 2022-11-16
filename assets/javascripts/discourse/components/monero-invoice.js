import Component from "@ember/component";
export default Component.extend({
  didInsertElement(){
    if(this.selectedPlanId){
      this.sendAction("planClick", this.selectedPlanId);

    }
},
  actions: {

  },
});