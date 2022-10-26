import ModalFunctionality from "discourse/mixins/modal-functionality";
import Controller from "@ember/controller";
import discourseComputed from "discourse-common/utils/decorators";
import I18n from "I18n";


export default Controller.extend(ModalFunctionality, {
  title: 'monero_discourse_subscriptions.admin.subscriptions.operations.create_subscription.modal_title',
  actions: {


    createNewSubscription(){
        this.get('model.createNewSubscription')({
          buyer: this.model.subscription.buyer,
          recipient: this.model.subscription.recipient,

          monero_plan_id: this.model.subscription.monero_plan_id
          });
        this.send('closeModal');
    },
    onChangeBuyer(usernames) {
      this.set("model.subscription.buyer", usernames.get("firstObject"));
    },
    onChangeRecipient(usernames) {
    this.set("model.subscription.recipient", usernames.get("firstObject"));
  }
  },
  @discourseComputed("model.product_id","model.products")
  moneroPlans(product_id,products){

    const makeDurationDisplay = function(plan){
      if(plan.duration === 86400)
      {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.daily");}
        if(plan.duration === 604800)
        {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.weekly");}
          if(plan.duration === 2678400)
          {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.monthly");}
            if(plan.duration === 31536000)
            {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.yearly");}
            if(plan.duration === 99999999)
            {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.lifetime");}
    };


    for (let product of products) {
      if(product.id === product_id){
        let new_monero_plans = [];
        for(let old_plan of product.monero_plans){
          let new_plan = Object.assign({}, old_plan);
          new_plan.durationDisplay = makeDurationDisplay(old_plan);
          new_monero_plans.push(new_plan);
        }
        new_monero_plans.sort((a,b)=> {
          return  a.duration - b.duration;
        });
        return new_monero_plans;
      }
     }
    return [];
  },
});