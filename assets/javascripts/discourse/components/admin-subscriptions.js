import Component from "@ember/component";
import AdminMoneroProduct from "../models/admin-monero-product";
import discourseComputed from "discourse-common/utils/decorators";
import { inject as service } from "@ember/service";
import { isEmpty } from "@ember/utils";
import { later} from '@ember/runloop';
import showModal from 'discourse/lib/show-modal';




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
            if(this.recipient && username === undefined){
                later(this,function(){
                    if(!this.recipient){
                        this.router.transitionTo({queryParams: {
                            recipient: null,
                            page: 0
                        }});
                        this.reloadModel();
                    }
                },100);
            }
            this.set("recipient", username);
           if(username){
                this.router.transitionTo({queryParams: {
                    recipient: username,
                    page: 0
                }});
                this.reloadModel();
            }

          },
          showInvoice(subscription) {
            showModal('show-monero-invoice', {
              model: {payments: subscription.monero_payments, product_name: subscription.product_name, duration: subscription.duration}
            });
          },
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