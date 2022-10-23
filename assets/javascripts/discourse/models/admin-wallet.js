import { ajax } from "discourse/lib/ajax";
import EmberObject from "@ember/object";

const AdminWallet = EmberObject.extend({});
AdminWallet.reopenClass({
    destroy(id) {
    return ajax(`/monero/wallets/${id}`, { method: "delete" });
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

  update(id, serverUri) {
    const data = {
        serverUri,
    };

    return ajax(`/monero/wallets/${id}`, {
      method: "patch",
      data,
    });
  },
  toggleSync(id) {
    const data = {
        toggleSync: true
    };

    return ajax(`/monero/wallets/${id}`, {
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
});

export default AdminWallet;
