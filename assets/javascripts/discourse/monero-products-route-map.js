export default function () {
    this.route("monero-products", { path: "/monero/products" }, function () {
      this.route("show", { path: "/:products-id" });
    });
  }
