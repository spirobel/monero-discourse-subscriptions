
import Component from "@ember/component";
import { cancel, later, next } from '@ember/runloop';
import { ajax } from "discourse/lib/ajax";

export default Component.extend({
   poller: null,
   didInsertElement() {
     next(this, function(){
       this.poller = this.pollWallets();
     });
   },
   willDestroyElement() {
     cancel(this.poller);
   },
   pollWallets(){
     return later(this,function(){
       ajax('/monero/walletstatus', { type: "GET" }).then(function(a){
        this.set('walletstatus',a);
         this.poller = this.pollWallets();
       }.bind(this));
     },1000);

   }

});