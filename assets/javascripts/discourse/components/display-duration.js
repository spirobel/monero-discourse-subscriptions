import Component from "@ember/component";
import discourseComputed from "discourse-common/utils/decorators";
import I18n from "I18n";

export default Component.extend({



@discourseComputed("duration")
durationName(duration){
  if(duration === 86400)
  {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.daily");}
    if(duration === 604800)
    {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.weekly");}
      if(duration === 2678400)
      {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.monthly");}
        if(duration === 31536000)
        {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.yearly");}
        if(duration === 99999999)
        {return I18n.t("monero_discourse_subscriptions.admin.products.plans_table.lifetime");}
},
});