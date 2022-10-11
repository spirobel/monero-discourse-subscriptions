import Component from "@ember/component";
import discourseComputed from "discourse-common/utils/decorators";

export default Component.extend({
  classNames: ["admin-product"],
  @discourseComputed("wallets","product.monero_wallet_id")
  walletName(wallets,monero_wallet_id){
    if(!wallets){return ""}
    for (let w of wallets) {
      if(w.id === monero_wallet_id){
        return w.name;
      }
     }
  },
  @discourseComputed("groups","product.group_id")
  groupName(groups,group_id){
    if(!groups){return ""}
    for (let g of groups) {
      if(g.id === group_id){
        return g.name;
      }
     }
  },
});