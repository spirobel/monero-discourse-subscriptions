import Component from "@ember/component";
import AdminWallet from "../models/admin-wallet";
import discourseComputed from "discourse-common/utils/decorators";
import { isEmpty } from "@ember/utils";
import AdminMoneroProduct from "../models/admin-monero-product";
import { popupAjaxError } from "discourse/lib/ajax-error";
export default Component.extend({
    wallets: null,
    didInsertElement(){
        let that = this;
        AdminWallet.findAll().then(data=>{
            that.set('wallets', data);
        });
    },

    actions: {
          openProductCreateForm() {
            this.set("creating", true);
          },
          closeProductCreateForm() {
            this.set("creating", false);
          },
          createNewProduct(params) {
            AdminMoneroProduct.save(params)
              .then(() => {
                this.send("closeProductCreateForm");
                this.send("reloadModel");
              })
              .catch(popupAjaxError);
          },

    },
    @discourseComputed("wallets")
    disableNewProduct(wallets){
      return isEmpty(wallets);
    },
});