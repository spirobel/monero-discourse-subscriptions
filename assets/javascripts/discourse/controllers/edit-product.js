import ModalFunctionality from "discourse/mixins/modal-functionality";
import Controller from "@ember/controller";

export default Controller.extend(ModalFunctionality, {
  title: 'monero_discourse_subscriptions.admin.products.operations.edit_product.modal_title',
  actions: {


    editProduct(){

        this.get('model.editProduct')({...this.model.product,
          group: this.model.product.group_id,
          monero_wallet: this.model.product.monero_wallet_id
          });
        this.send('closeModal');
    },

  }
});