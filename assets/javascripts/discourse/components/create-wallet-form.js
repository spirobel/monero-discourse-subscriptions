import Component from "@ember/component";

export default Component.extend({
  primaryAddress: "your wallets primary Address",
  privateViewKey: "your wallets private Viewkey",
  serverUri: "node address and port",
  restoreHeight: 0,
  stagenet: false,
  name: "monerochan's stash",

  actions: {
    createNewWallet() {
      const createParams = {
        primaryAddress: this.primaryAddress,
        privateViewKey: this.privateViewKey,
        restoreHeight: this.restoreHeight,
        stagenet: this.stagenet,
        name: this.name,
        serverUri: this.serverUri,
      };

      this.create(createParams);
    },
    cancelCreateWallet() {
      this.cancel();
    },
  },
});