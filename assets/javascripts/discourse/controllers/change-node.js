import ModalFunctionality from "discourse/mixins/modal-functionality";
import Controller from "@ember/controller";

export default Controller.extend(ModalFunctionality, {
  title: 'monero_discourse_subscriptions.admin.wallets.operations.change_node.modal_title',
  actions: {


    changeNode(){
        this.get('model.newNode')(this.serverUri);
        this.send('closeModal');
    },

  }
});