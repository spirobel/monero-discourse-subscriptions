import { withPluginApi } from "discourse/lib/plugin-api";
import I18n from "I18n";

export default {
  name: "setup-monero-subscriptions",
  initialize(container) {
    withPluginApi("0.8.11", (api) => {
        console.log("hi bro")
        api.addNavigationBarItem({
          name: "monero-subscribe",
          displayName: I18n.t("monero_discourse_subscriptions.navigation.subscribe"),
          href: "/s",
        });
      

      const user = api.getCurrentUser();
      if (user) {
        api.addQuickAccessProfileItem({
          icon: "far-credit-card",
          href: `/u/${user.username}/billing/subscriptions`,
          content: "Billing",
        });
      }
    });
  },
};