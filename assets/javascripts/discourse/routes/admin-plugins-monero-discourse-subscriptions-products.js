import Route from "@ember/routing/route";
import AdminMoneroProduct from "../models/admin-monero-product";
import showModal from 'discourse/lib/show-modal';
import I18n from "I18n";
import bootbox from "bootbox";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default Route.extend({
  model() {
    return AdminMoneroProduct.findAll();
  },
  actions:{
    reloadModel() {
      this.refresh();
    },
    destroyProduct(id){
      bootbox.confirm(
          I18n.t("monero_discourse_subscriptions.admin.products.operations.destroy.confirm"),
          I18n.t("no_value"),
          I18n.t("yes_value"),
          (confirmed) => {
            if (confirmed) {
              AdminMoneroProduct
                .destroy(id)
                .then(() => {
                  this.refresh();
                })
                .catch((data) =>
                  bootbox.alert(data.jqXHR.responseJSON.errors.join("\n"))
                );
            }
          }
        );
  },
  editProduct(product,wallets, groups){
      showModal('edit-product', {
          model: {
            wallets,
            groups,
            product:Object.assign({}, product)
            ,
            editProduct: (productParams) => {
                AdminMoneroProduct.update(productParams).then(()=>{
                  this.refresh();
              })
              .catch((data) =>
              bootbox.alert(data.jqXHR.responseJSON.errors.join("\n"))
            );
            },
          }
        });
  },
  createNewProduct(params) {
    AdminMoneroProduct.save(params)
      .then(() => {
        this.send("reloadModel");
      })
      .catch(popupAjaxError);
  },
  addPlansToProduct(product){

    let new_product = Object.assign({}, product);



      const makeDurationDisplay = function(plan){
        if(plan.duration === 86400)
        {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.daily");}
          if(plan.duration === 604800)
          {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.weekly");}
            if(plan.duration === 2678400)
            {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.monthly");}
              if(plan.duration === 31536000)
              {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.yearly");}
      };
      new_product.monero_plans = [];
      for(let old_plan of product.monero_plans){
        let new_plan = Object.assign({}, old_plan);

        new_plan.durationDisplay = makeDurationDisplay(old_plan);
        new_product.monero_plans.push(new_plan);
      }
      new_product.monero_plans.sort((a,b)=> {
        return  a.duration - b.duration;
      });

    showModal('add-plans', {
      model: {
        product:new_product,
        updatePlans: (plansParams) => {
            AdminMoneroProduct.updatePlans(plansParams).then(()=>{
              this.refresh();
          })
          .catch((data) =>
          bootbox.alert(data.jqXHR.responseJSON.errors.join("\n"))
        );
        },
      }
    });
  }
  }
});
