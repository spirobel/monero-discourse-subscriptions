import { ajax } from "discourse/lib/ajax";
import EmberObject from "@ember/object";

const AdminMoneroProduct = EmberObject.extend({


  destroy() {
    return ajax(`/monero/products/${this.id}`, { method: "delete" });
  },

  save() {
    const data = {
      name: this.name,
      description: this.description,
      active: this.active,
      position: this.position,
      group: this.group,
      monero_wallet: this.monero_wallet
    };

    return ajax("/monero/products", {
      method: "post",
      data,
    }).then((product) => AdminMoneroProduct.create(product));
  },

  update() {
    const data = {
      name: this.name,
      description: this.description,
      active: this.active,
      position: this.position,
      group: this.group,
      monero_wallet: this.monero_wallet
    };

    return ajax(`/monero/products/${this.id}`, {
      method: "patch",
      data,
    });
  },
});

AdminMoneroProduct.reopenClass({
  findAll() {
    return ajax("/monero/products", { method: "get" }).then((result) => {
      if (result === null) {
        return { unconfigured: true };
      }
      return result.map((product) => AdminMoneroProduct.create(product));
    });
  },

  find(id) {
    return ajax(`/monero/products/${id}`, {
      method: "get",
    }).then((product) => AdminMoneroProduct.create(product));
  },
});

export default AdminMoneroProduct;
