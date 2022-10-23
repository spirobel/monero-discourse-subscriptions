import Route from "@ember/routing/route";
import AdminWallet from "../models/admin-wallet";
import bootbox from "bootbox";
import I18n from "I18n";
import showModal from 'discourse/lib/show-modal';


export default Route.extend({
    model(){
        return AdminWallet.findAll();
    },
    actions: {
        reloadModel() {
            this.refresh();
          },
        destroyWallet(id){
            bootbox.confirm(
                I18n.t("monero_discourse_subscriptions.admin.wallets.operations.destroy.confirm"),
                I18n.t("no_value"),
                I18n.t("yes_value"),
                (confirmed) => {
                  if (confirmed) {
                    AdminWallet
                      .destroy(id)
                      .then(() => {
                        this.refresh();
                      })
                      .catch((data) =>
                        bootbox.alert(data.jqXHR.responseJSON.errors.join("\n"))
                      );
                  }
                }
              );
        },
        changeNode(id){
            showModal('change-node', {
                model: {
                  newNode: (serverUri) => {
                    AdminWallet.update(id, serverUri).then(()=>{
                        this.refresh();
                    })
                    .catch((data) =>
                    bootbox.alert(data.jqXHR.responseJSON.errors.join("\n"))
                  );
                  },
                }
              });
        },
        toggleSync(id){
          AdminWallet.toggleSync(id).then(() => {
            this.refresh();
          })
          .catch((data) =>
            bootbox.alert(data.jqXHR.responseJSON.errors.join("\n"))
          );
        }
    }
});