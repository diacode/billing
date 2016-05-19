# Billing

Diacode's invoicing application with time tracking services integration.

**Important note:** Right now the project is in development so most of the features are not supposed to work yet.

## Configuration file (billing.yml)

The file `config/billing.yml` contains all the settings used by the app. There are three main sections in these settings:

### Time tracking

* `provider`: Right now it only supports `toggl`. Harvest integration will eventually supported.
* `api_key`: Key to authenticate the app with your time tracking service. 

### Notifications 

You can configure your notifications to address either **Slack** or **Hipchat**. At this moment it isn't possible to notify to more than one provider. 

#### Common provider settings

* `enabled`: Whether you want to notify new bank records or not. This setting is `true` by default.
* `provider`: Only admits `slack` or `hipchat`.
* `username`: Name of the user to display sending the notification.

#### Slack specific settings

* `webhook_url`: Url of the channel's incoming webook where notifications will be sent. **Only for slack**.
* `emoji`: Slack emoji to display attached to notification. See the [emoji cheatsheet](http://www.emoji-cheat-sheet.com/) for choices.

#### HipChat specific settings

* `token`: HipChat's API token
* `room`: Name of the room you will send notifications.

### Bank Account

Settings required to access your bank records.

* `entity`: The name of your bank. This part of the app relies on [bankscrap gem](https://github.com/bankscrap/bankscrap), check out the list of supported banks there.
* `username`: Name of the bank user.
* `password`: Password of the bank user.
* `birthday`: Birth day of the user in `dd/mm/yyyy` format. Only needed for `ing`.

It's basically the payment information (bank account details) and the company info (billing address). Please take a look, its almost self explanatory.

### Invoice

* `last_legacy_id`: The ID or code of the last invoice you have emitted. It will help the app to calculate the app's first one.
* `company_info`: The details of the company to be attached to invoice PDFs.
* `payment_info`: The payment details to be attached to your invoice PDFs. Otherwise your customers can't pay you :P 

## Deploy

Since these days there are many ways of deploying applications we haven't made any assumptions to keep it as generic as possible. The project is prepared to work out of the box in development environment. It's up to you forking it and making the necessary changes to suit your setup.
