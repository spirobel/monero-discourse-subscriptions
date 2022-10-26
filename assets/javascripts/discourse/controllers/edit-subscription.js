import ModalFunctionality from "discourse/mixins/modal-functionality";
import Controller from "@ember/controller";


export default Controller.extend(ModalFunctionality, {
  title: 'monero_discourse_subscriptions.admin.subscriptions.operations.edit_subscription.modal_title',
  actions: {


    editSubscription(){
        this.get('model.editSubscription')({ id: this.model.subscription.id,
          begin_date: this.model.begin_date.unix(),
          end: this.model.end.unix(),

          });
        this.send('closeModal');
    },

  },

});