import Controller from "@ember/controller";
import discourseComputed from "discourse-common/utils/decorators";
import User from "discourse/models/user";
import { isEmpty } from "@ember/utils";


export default Controller.extend({
  @discourseComputed()
  isLoggedIn() {
    return User.current();
  },
  @discourseComputed("model")
  active_products(model) {
    return model.filter(p=>p.active);
  },
  @discourseComputed("active_products")
  noProducts(active_products) {
    return isEmpty(active_products);
  },
});