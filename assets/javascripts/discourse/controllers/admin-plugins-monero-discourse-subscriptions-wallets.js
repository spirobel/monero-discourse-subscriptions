import Controller from "@ember/controller";
import AdminWallet from "../models/admin-wallet";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default Controller.extend({
  creating: null,
  actions: {
    openWalletCreateForm() {
      this.set("creating", true);
    },
    closeWalletCreateForm() {
      this.set("creating", false);
    },
    createNewWallet(params) {
      AdminWallet.save(params)
        .then(() => {
          this.send("closeWalletCreateForm");
          this.send("reloadModel");
        })
        .catch(popupAjaxError);
    },
  },
});
