import { ajax } from "discourse/lib/ajax";
import EmberObject from "@ember/object";

const AdminWallet = EmberObject.extend({

  destroy() {
    return ajax(`/monero/wallets/${this.id}`, { method: "delete" });
  },

  save() {
    const data = {
      primaryAddress: this.primaryAddress,
      privateViewKey: this.privateViewKey,
      restoreHeight: this.restoreHeight,
      stagenet: this.stagenet,
      name: this.name,
      serverUri: this.serverUri,
      callback: this.callback
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
        callback: this.callback
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
