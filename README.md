# **Monero Discourse Subscriptions** Plugin

This plugin enables you to give your users access to private Discourse groups and categories for Monero payments.

## Installation for Development

### install
 
Follow this [GUIDE](https://meta.discourse.org/t/beginners-guide-to-install-discourse-for-development-using-docker/102009) to install discourse for development

### **starting the server**

Run these scripts with the cloned discourse repo as the working directory.
#### **In one terminal:**
``` bash
d/rails s
```
#### **And in a separate terminal:**
``` bash
d/ember-cli
```
Afterwards you can access the development instance in your browser at: [http:localhost:4200](http:localhost:4200)

## Installation in Production

Follow this [GUIDE](https://meta.discourse.org/t/install-plugins-in-discourse/19157) to install the plugin in your discourse production instance.
If you have not installed Discourse yet, follow this [GUIDE](https://github.com/discourse/discourse/blob/main/docs/INSTALL-cloud.md). It can be done very quickly! 