import Component from "@ember/component";
import Group from "discourse/models/group";
export default Component.extend({
  name: "Monerochan's cookies",
  description: "write a short description of your product",
  active: true,
  position: 0,
  group: null,
  monero_wallet: null,
  didInsertElement(){
    let that = this;
    Group.findAll().then(data=>{
        that.set('groups', data);
        that.set('monero_wallet',this.wallets[0].id);
    });
},
  actions: {
    createNewProduct() {
      const createParams = {
        name: this.name,
        description: this.description,
        active: this.active,
        position: this.position,
        group: this.group,
        monero_wallet: this.monero_wallet,
      };

      this.create(createParams);
    },
    cancelCreateProduct() {
      this.cancel();
    },
  },
});