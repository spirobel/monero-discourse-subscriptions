# **Monero Discourse Subscriptions** Plugin

This plugin enables you to give your users access to private Discourse groups and categories for Monero payments.

## Installation for Development

### install
 
Follow this [GUIDE](https://meta.discourse.org/t/beginners-guide-to-install-discourse-for-development-using-docker/102009) to install discourse for development.
Be sure to migrate the database after symlinking the plugin:
``` bash
d/rails db:migrate
```
Also make sure the runit file for the monerochan merchant rpc is installed by running the install script to be found in the docker_scripts folder:
``` bash
./docker_scripts/install_monero_runit
```
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

Your app.yml has a section that looks like this:
``` yaml
## Any custom commands to run after building
run:
  - exec: echo "Beginning of custom commands"
  ## If you want to set the 'From' email address for your first registration, uncomment and change:
  ## After getting the first signup email, re-comment the line. It only needs to run once.
  #- exec: rails r "SiteSetting.notification_email='info@unconfigured.discourse.org'"
  - exec: echo "End of custom commands"

```
Add the section from `wallet-service/monerochan-merchant-rpc.yml` in there:
``` yaml
 - file:
     path: /etc/service/monerochan_merchant_rpc/run
     chmod: "+x"
     contents: |
        #!/bin/sh
        exec 2>&1
        exec /src/plugins/monero-discourse-subscriptions/wallet-service/monerochan-merchant-rpc
```
This needs to be done so the monerochan-merchant-rpc runs in the background. It deals with the payments, invoices, wallets etc. You can read more about it [HERE](https://github.com/spirobel/monerochan-merchant-rpc)! You can use it to easily integrate monero into you own apps and services!

the plugin section of your app.yaml should look somewhat like this (depending on which other plugins you have installed)

``` yaml
## Plugins go here
## see https://meta.discourse.org/t/19157 for details
hooks:
  after_code:
    - exec:
        cd: $home/plugins
        cmd:
          - git clone https://github.com/discourse/docker_manager.git
          - git clone https://github.com/spirobel/monero-discourse-subscriptions
```

## tips
It is advised to turn off syncing of the wallets during Discourse updates (to make sure the current sync state is saved.)