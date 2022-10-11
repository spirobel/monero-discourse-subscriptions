export default {
    resource: "admin.adminPlugins",
    path: "/plugins",

    map() {
      this.route("monero-discourse-subscriptions", function () {
        this.route("products");

        this.route("subscriptions");
        this.route("wallets");


      });
    },
  };