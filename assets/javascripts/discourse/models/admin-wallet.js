import { ajax } from "discourse/lib/ajax";
import EmberObject from "@ember/object";

const AdminWallet = EmberObject.extend({});
AdminWallet.reopenClass({
    destroy() {
    return ajax(`/monero/wallets/${this.id}`, { method: "delete" });
  },

  save(params) {
    const data = {
      primaryAddress: params.primaryAddress,
      privateViewKey: params.privateViewKey,
      restoreHeight: params.restoreHeight,
      stagenet: params.stagenet,
      name: params.name,
      serverUri: params.serverUri,
    };

    return ajax("/monero/wallets", {
      method: "post",
      data,
    }).then((wallet) => AdminWallet.create(wallet));
  },

  update() {
    const data = {
        primaryAddress: this.primaryAddress,
        privateViewKey: this.privateViewKey,
        restoreHeight: this.restoreHeight,
        stagenet: this.stagenet,
        name: this.name,
        serverUri: this.serverUri,
    };

    return ajax(`/monero/wallets/${this.id}`, {
      method: "patch",
      data,
    });
  },
});

AdminWallet.reopenClass({
  findAll() {
    return ajax("/monero/wallets", { method: "get" }).then((result) => {
      if (result === null) {
        return { unconfigured: true };
      }
      return result.map((wallet) => AdminWallet.create(wallet));
    });
  },

  find(id) {
    return ajax(`/monero/wallets/${id}`, {
      method: "get",
    }).then((wallet) => AdminWallet.create(wallet));
  },
});

export default AdminWallet;
