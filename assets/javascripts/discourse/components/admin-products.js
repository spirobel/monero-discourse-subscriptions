import Component from "@ember/component";
import AdminWallet from "../models/admin-wallet";
import discourseComputed from "discourse-common/utils/decorators";
import { isEmpty } from "@ember/utils";

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
    },
    @discourseComputed("wallets")
    disableNewProduct(wallets){
      return isEmpty(wallets);
    },
});