import Component from "@ember/component";
export default Component.extend({
  name: "Monerochan's cookies",
  description: "write a short description of your product",
  active: true,
  position: 0,
  group: null,
  monero_wallet: null,
  didInsertElement(){
    this.set('monero_wallet',this.wallets[0].id);

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
      this.cancel();
    },
    cancelCreateProduct() {
      this.cancel();
    },
  },
});