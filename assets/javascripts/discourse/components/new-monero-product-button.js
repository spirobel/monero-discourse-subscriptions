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
            console.log(that.wallets)
        });
    },
    @discourseComputed("wallets")
    disableNewProduct(wallets){
      return isEmpty(wallets);
    },
});