import Button from "discourse/components/d-button";

export default Button.extend({
  selected: false,

  init() {
    this._super(...arguments);
    this.classNameBindings = this.classNameBindings.concat(
      "selected:btn-primary"
    );
  },
});
