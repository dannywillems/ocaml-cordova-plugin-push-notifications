#!/bin/bash -
#===============================================================================
#
#          FILE: .travis-ci.sh
#
#         USAGE: ./.travis-ci.sh
#
#   DESCRIPTION: Generate the ml file and compile
#
#        AUTHOR: Danny Willems <contact@danny-willems.be>
#       CREATED: 04/06/2016 11:26
#      REVISION: 1.0
#===============================================================================

set -o nounset                              # Treat unset variables as an error

URL=https://github.com/dannywillems/ocaml-cordova-plugin-push.git
PLUGIN_PIN=cordova-plugin-push

opam install -y ocamlfind ppx_tools js_of_ocaml gen_js_api

# Test for make and make clean
make && make clean

# Test for make install and make remove
make install && make remove && make clean

# Test for the pin and -package
opam pin add ${PLUGIN_PIN} ${URL} -y
