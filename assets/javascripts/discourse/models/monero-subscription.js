import { ajax } from "discourse/lib/ajax";
import EmberObject from "@ember/object";

const MoneroSubscription = EmberObject.extend({});

MoneroSubscription.reopenClass({
  findAll() {
    return ajax("/monero/mysubscriptions", { method: "get" }).then((result) => {
      if (result === null) {
        return { unconfigured: true };
      }
      return result.map((product) => MoneroSubscription.create(product));
    });
  },

});

export default MoneroSubscription;
