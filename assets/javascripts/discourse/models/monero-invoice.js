import { ajax } from "discourse/lib/ajax";
import EmberObject from "@ember/object";

const MoneroInvoice = EmberObject.extend({});

MoneroInvoice.reopenClass({
  findMyInvoice(planid) {
    return ajax(`/monero/myinvoice/${planid}`, {
      method: "get",
    }).then((product) => MoneroInvoice.create(product));
  },

});

export default MoneroInvoice;
