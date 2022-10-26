import Helper from "@ember/component/helper";

export default Helper.helper(function (params) {
  let f = moment(params[0]).format("D.M.Y, h:mm a");
  return f;
});