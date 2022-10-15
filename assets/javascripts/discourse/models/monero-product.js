import { ajax } from "discourse/lib/ajax";
import EmberObject from "@ember/object";

const MoneroProduct = EmberObject.extend({});

MoneroProduct.reopenClass({
  findAll() {
    return ajax("/monero/products", { method: "get" }).then((result) => {
      if (result === null) {
        return { unconfigured: true };
      }
      return result.map((product) => MoneroProduct.create(product));
    });
  },
  find(id) {
    return ajax(`/monero/products/${id}`, {
      method: "get",
    }).then((product) => MoneroProduct.create(product));
  },

});

export default MoneroProduct;
