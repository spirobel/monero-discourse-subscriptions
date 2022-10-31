import { withPluginApi } from "discourse/lib/plugin-api";
import I18n from "I18n";

export default {
  name: "setup-monero-subscriptions",
  initialize(container) {
    withPluginApi("0.8.11", (api) => {
        api.addNavigationBarItem({
          name: "monero-subscribe",
          displayName: I18n.t("monero_discourse_subscriptions.navigation.subscribe"),
          href: "/monero/products",
        });

      const user = api.getCurrentUser();
      if (user) {
        api.addQuickAccessProfileItem({
          icon: "gift",
          href: `/u/${user.username}/monero/subscriptions`,
          content: I18n.t("monero_discourse_subscriptions.navigation.monero_subscriptions"),
        });
      }
    });
  },
};