# ocaml-cordova-plugin-push

[![LGPL-v3 licensed](https://img.shields.io/badge/license-LGPLv3-blue.svg)](https://raw.githubusercontent.com/dannywillems/ocaml-cordova-plugin-fcm/master/LICENSE)
[![Build Status](https://travis-ci.org/dannywillems/ocaml-cordova-plugin-push.svg?branch=master)](https://travis-ci.org/dannywillems/ocaml-cordova-plugin-push)

Binding to
[phonegap-plugin-push](https://github.com/phonegap/phonegap-plugin-push)

## What does phonegap-plugin-push do?

```
Register and receive push notifications
```

Source: [phonegap-plugin-push](https://github.com/phonegap/phonegap-plugin-push)

## How to install and compile your project by using this plugin?

Don't forget to switch to a compiler **>= 4.03.0**.
```Shell
opam switch 4.03.0
```

* This binding is available in opam
```Shell
opam install cordova-plugin-push-notifications
```

* You can also pin the repository with
```Shell
opam pin add cordova-plugin-push-notifications https://github.com/dannywillems/ocaml-cordova-plugin-push.git
```

To compile your project, use
```Shell
ocamlfind ocamlc -c -o [output_file] -package gen_js_api -package cordova-plugin-push-notifications [...] -linkpkg [other arguments]
```

Don't forget to install phonegap-plugin-push with
```Shell
cordova plugin add phonegap-plugin-push
```

## How to use?

See the official documentation
[phonegap-plugin-push](https://github.com/phonegap/phonegap-plugin-push)

As other binding to Cordova plugins, the OCaml interface is very close to the
JavaScript interface. Instead of creating a new type in the top-level, objects
type like Android options or iOS options are encapsulated in a submodule
`Android` (and `Ios`) in the module `Options`. Each submodule has a type `t`
representing the object for the options and a function `create` to create the
option object.

In addition to standard payloads (= information sent by the push notification
server) like title and message you can get back any additional data you sent to
the push notification server.

All additional data are encapsulated in the attribute `additional_data` (which
is of type `Additional_data.t`) of the notification data (of type
`Data_notification.t`, passed in the callback
`on_notification`).

The binding allows you to get some *official* additional data like the foreground
(with `Additional_data.foreground additional_data_value`) or the notification ID
(with `Additional_data.not_id additional_data_value`). If you want to get some
*unofficial* payload you created, you can use `Additional_data.get
additional_data_value payload_as_string` which returns a `Ojs.t` object (see
[gen_js_api](https://github.com/lexifi/gen_js_api)).


## Push notification server in OCaml

In [ocsigen-start](https://github.com/ocsigen/ocsigen-start), the module
`Os_push_notifications` provides a simple interface to GCM (Google Cloud
Messaging) to create a push notification server and send notification to
devices.
