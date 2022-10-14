import ModalFunctionality from "discourse/mixins/modal-functionality";
import Controller from "@ember/controller";

export default Controller.extend(ModalFunctionality, {
  title: 'monero_discourse_subscriptions.admin.products.operations.add_plans.modal_title',
  currencies: [
    { id: "AUD", name: "AUD" },
    { id: "CAD", name: "CAD" },
    { id: "EUR", name: "EUR" },
    { id: "GBP", name: "GBP" },
    { id: "USD", name: "USD" },
    { id: "INR", name: "INR" },
    { id: "BRL", name: "BRL" },
    { id: "DKK", name: "DKK" },
    { id: "SGD", name: "SGD" },
    { id: "XMR", name: "XMR" },
    { id: "BTC", name: "BTC" },
  ],
  actions: {


    updatePlans(){
        this.get('model.updatePlans')(this.model.product.monero_plans);
        this.send('closeModal');
    },

  }
});