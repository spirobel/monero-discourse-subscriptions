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
  noProducts(model) {
    return isEmpty(model);
  },
});