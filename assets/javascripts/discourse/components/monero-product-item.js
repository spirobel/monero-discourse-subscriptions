import Component from "@ember/component";
import discourseComputed from "discourse-common/utils/decorators";

export default Component.extend({
  classNames: ["monero-product"],
  @discourseComputed("product.end_date")
  endDateFormated(end_date){
    console.log("TODO format endate with moment", end_date);
    return end_date;
  },

});