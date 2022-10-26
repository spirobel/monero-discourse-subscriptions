import Controller from "@ember/controller";


export default Controller.extend({
  queryParams: ['page','recipient'],
  page: null,
  recipient: null
});
