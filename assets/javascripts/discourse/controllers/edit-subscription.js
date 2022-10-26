import ModalFunctionality from "discourse/mixins/modal-functionality";
import Controller from "@ember/controller";


export default Controller.extend(ModalFunctionality, {
  title: 'monero_discourse_subscriptions.admin.subscriptions.operations.edit_subscription.modal_title',
  actions: {


    editSubscription(){
      console.log(this, this.model, this.begin_date)
        this.get('model.editSubscription')({ id: this.model.subscription.id,
          begin_date: this.begin_date.unix(),
          end: this.end.unix(),

          });
        this.send('closeModal');
    },

  },

});