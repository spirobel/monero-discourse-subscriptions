import Helper from "@ember/component/helper";

export default Helper.helper(function (params) {


  return params[0] / 1000000000000;
});