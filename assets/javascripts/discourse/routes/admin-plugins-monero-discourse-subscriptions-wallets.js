import Route from "@ember/routing/route";
import AdminWallet from "../models/admin-wallet";

export default Route.extend({
    model(){
        return AdminWallet.findAll();
    },
    actions: {
        reloadModel() {
            this.refresh();
          },
    }
});