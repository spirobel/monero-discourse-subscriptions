import Component from "@ember/component";
import AdminMoneroProduct from "../models/admin-monero-product";


export default Component.extend({
  products: null,
    didInsertElement(){
        let that = this;
        AdminMoneroProduct.findAll().then(data=>{
            that.set('products', data);
        });
    },
});