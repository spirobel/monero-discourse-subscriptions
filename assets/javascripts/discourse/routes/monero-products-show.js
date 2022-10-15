import Route from "@ember/routing/route";
import MoneroProduct from "../models/monero-product";

export default Route.extend({
  model(params) {
    const product_id = params["products-id"];
    return MoneroProduct.find(product_id);
  },
});