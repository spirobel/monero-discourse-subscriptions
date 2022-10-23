import Component from "@ember/component";
import discourseComputed from "discourse-common/utils/decorators";


export default Component.extend({
  classNames: ["wallet"],
  @discourseComputed("walletstatus", "wallet.primaryAddress")
  ws(walletstatus,primaryAddress){
    let key = "/src/public/backups/wallets/"+primaryAddress;
    if(walletstatus){
      return walletstatus[key];
    } else {
      return {};
    }

  },
  @discourseComputed("ws.percentDone")
  percentDone(num){
    if(num){
      return (Math.round(num*100)/100)*100;
    } else {
      return null;
    }
  },

});