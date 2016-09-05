# ocaml-cordova-plugin-push

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
opam install cordova-plugin-push
```

* You can also pin the repository with
```Shell
opam pin add cordova-plugin-push https://github.com/dannywillems/ocaml-cordova-plugin-push.git
```

To compile your project, use
```Shell
ocamlfind ocamlc -c -o [output_file] -package gen_js_api -package cordova-plugin-push [...] -linkpkg [other arguments]
```

Don't forget to install phonegap-plugin-push with
```Shell
cordova plugin add phonegap-plugin-push
```

## How to use?

See the official documentation
[phonegap-plugin-push](https://github.com/phonegap/phonegap-plugin-push)
