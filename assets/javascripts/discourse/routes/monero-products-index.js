import Route from "@ember/routing/route";
import MoneroProduct from "../models/monero-product";

export default Route.extend({
  model() {
    return MoneroProduct.findAll();
  },
});