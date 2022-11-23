import { ajax } from "discourse/lib/ajax";
import EmberObject from "@ember/object";

const MoneroSubscription = EmberObject.extend({});

MoneroSubscription.reopenClass({
  findAll() {
    return ajax("/monero/mysubscriptions", { method: "get" }).then((result) => {
 return result;
    });
  },

});

export default MoneroSubscription;
