import Component from "@ember/component";
import AdminMoneroProduct from "../models/admin-monero-product";
import discourseComputed from "discourse-common/utils/decorators";
import { inject as service } from "@ember/service";
import { isEmpty } from "@ember/utils";



export default Component.extend({
    products: null,
    router: service(),

    didInsertElement(){
        let that = this;
        AdminMoneroProduct.findAll().then(data=>{
            that.set('products', data);
        });
    },
    actions: {
        backward(){
            this.router.transitionTo({queryParams: {
                recipient: this.recipient,
                page: Number(this.page)-1
            }});
            this.reloadModel();
        },
        forward(){
            this.router.transitionTo({queryParams: {
                recipient: this.recipient,
                page: Number(this.page)+1
            }});
            this.reloadModel();
        },
        onChangeRecipient(usernames) {
            let username = usernames.get("firstObject");
            this.set("recipient", username);
           if(username){
                this.router.transitionTo({queryParams: {
                    recipient: username,
                    page: this.page
                }});
                this.reloadModel();
            }

          }
    },
    @discourseComputed("page")
    pageZero(page){
      return Number(page) === 0;
    },
    @discourseComputed("model")
    noMoreForward(model){
      return isEmpty(model);
    },
});