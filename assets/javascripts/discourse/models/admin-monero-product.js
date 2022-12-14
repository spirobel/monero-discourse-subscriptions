import { ajax } from "discourse/lib/ajax";
import EmberObject from "@ember/object";

const AdminMoneroProduct = EmberObject.extend({});
  AdminMoneroProduct.reopenClass({

  destroy(id) {
    return ajax(`/monero/products/${id}`, { method: "delete" });
  },

  save(params) {
    const data = {
      name: params.name,
      description: params.description,
      active: params.active,
      position: params.position,
      group: params.group,
      monero_wallet: params.monero_wallet
    };

    return ajax("/monero/products", {
      method: "post",
      data,
    }).then((product) => AdminMoneroProduct.create(product));
  },

  update(params) {
    const data = {
      name: params.name,
      description: params.description,
      active: params.active,
      position: params.position,
      group: params.group,
      monero_wallet: params.monero_wallet
    };

    return ajax(`/monero/products/${params.id}`, {
      method: "patch",
      data,
    });
  },
  updatePlans(plansParams) {
    let plans = [];
    for (let plan of plansParams) {
      plans.push({
        currency: plan.currency,
        amount: plan.amount,
        active: plan.active,
        repurchaseable: plan.repurchaseable,
        position: plan.position,
        id: plan.id,
      });
     }
     const data = {plans};
    return ajax(`/monero/products_plans/`, {
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

});

export default AdminMoneroProduct;
