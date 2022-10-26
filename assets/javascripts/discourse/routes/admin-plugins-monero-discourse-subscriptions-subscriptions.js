import Route from "@ember/routing/route";
import AdminMoneroSubscription from "../models/admin-monero-subscription";
import showModal from 'discourse/lib/show-modal';
import I18n from "I18n";
import bootbox from "bootbox";

export default Route.extend({
  model(params) {
    return AdminMoneroSubscription.findAll(params);
  },
  actions:{
    reloadModel() {
      this.refresh();
    },
    destroySubscription(id){
      bootbox.confirm(
          I18n.t("monero_discourse_subscriptions.admin.products.operations.destroy.confirm"),
          I18n.t("no_value"),
          I18n.t("yes_value"),
          (confirmed) => {
            if (confirmed) {
              AdminMoneroSubscription
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
  editSubscription(subscription){
      showModal('edit-subscription', {
          model: {
            begin_date: moment(subscription.begin_date),
            end: moment(subscription.end),
            subscription:Object.assign({}, subscription)
            ,
            editSubscription: (subscriptionParams) => {
              AdminMoneroSubscription.update(subscriptionParams).then(()=>{
                  this.refresh();
              })
              .catch((data) =>
              bootbox.alert(data.jqXHR.responseJSON.errors.join("\n"))
            );
            },
          }
        });
  },
  createNewSubscription(products){
    showModal('create-subscription', {
        model: {
          products,
          subscription:Object.assign({}, )
          ,
          createNewSubscription: (subscriptionParams) => {
            AdminMoneroSubscription.save(subscriptionParams).then(()=>{
                this.refresh();
            })
            .catch((data) =>
            bootbox.alert(data.jqXHR.responseJSON.errors.join("\n"))
          );
          },
        }
      });
  },
  }
});
