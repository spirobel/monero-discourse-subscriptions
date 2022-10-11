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
  editProduct(product){
      showModal('edit-product', {
          model: {
            product,
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
    console.log("add plans ", product)
  }
  }
});
