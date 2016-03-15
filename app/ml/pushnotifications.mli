(* -------------------------------------------------------------------------- *)
type event
val event_to_js_str : event -> Js.js_string Js.t
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
type init_android_options =
  <
    senderId              : Js.js_string Js.t Js.readonly_prop ;
    icon                  : Js.js_string Js.t Js.opt Js.readonly_prop ;
    iconColor             : Js.js_string Js.t Js.opt Js.readonly_prop ;
    sound                 : bool Js.t Js.readonly_prop ;
    vibrate               : bool Js.t Js.readonly_prop ;
    clearNotifications    : bool Js.t Js.readonly_prop ;
    forceShow             : bool Js.t Js.readonly_prop ;
    topics                : Js.js_string Js.t Js.js_array Js.t Js.readonly_prop
  > Js.t

val create_init_android_options : string                    ->
                                  ?icon:string option       ->
                                  ?icon_color:string option ->
                                  ?sound:bool               ->
                                  ?vibrate:bool             ->
                                  ?clear_notifications:bool ->
                                  ?force_show:bool          ->
                                  ?topics:string array      ->
                                  unit                      ->
                                  init_android_options
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
type init_ios_options =
  <
    alert                 : bool Js.t Js.readonly_prop ;
    badge                 : bool Js.t Js.readonly_prop ;
    sound                 : bool Js.t Js.readonly_prop ;
    clearBadge            : bool Js.t Js.readonly_prop ;
  > Js.t

val create_init_ios_options     : ?alert:bool ->
                                  ?badge:bool ->
                                  ?sound:bool ->
                                  ?clear_badge:bool ->
                                  unit ->
                                  init_ios_options
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
type init_options =
  <
    android       : init_android_options Js.readonly_prop ;
    ios           : init_ios_options Js.readonly_prop
  > Js.t
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
type data_permissions =
  <
    isEnabled     : bool Js.t Js.readonly_prop
  > Js.t

class type push_notifications =
  object
    method init             : init_options -> unit Js.meth
    method hasPermission    : (data_permissions -> unit) -> unit Js.meth
  end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
(* Received data from the push notifications
 * TODO: Create an high level abstraction with only ocaml types *)
type additional_data =
  <
    foreground              : bool Js.t Js.readonly_prop ;
    coldStart               : bool Js.t Js.readonly_prop
  > Js.t

type data_push =
  <
    message                 : Js.js_string Js.t Js.readonly_prop ;
    title                   : Js.js_string Js.t Js.readonly_prop ;
    count                   : Js.js_string Js.t Js.readonly_prop ;
    sound                   : Js.js_string Js.t Js.readonly_prop ;
    image                   : Js.js_string Js.t Js.readonly_prop ;
    additionalData          : additional_data Js.readonly_prop ;
  > Js.t

class type push               =
  object
    (* How to implement the callback ? It's different if the first argument is
     * notification or error. *)
    (*
    method on               : Js.js_string Js.t ->
                              (unit -> unit)    ->
                              unit Js.meth
    method off              : Js.js_string Js.t ->
                              (unit -> unit)    ->
                              unit Js.meth
    *)
    method unregister       : (unit -> unit) ->
                              (unit -> unit) ->
                              Js.js_string Js.t Js.js_array Js.t ->
                              unit Js.meth
    method setApplicationIconBadgeNumber :  (unit -> unit)  ->
                                            (unit -> unit)  ->
                                            int             ->
                                            unit Js.meth
    method getApplicationIconBadgeNumber :  (int -> unit)   ->
                                            (unit -> unit)  ->
                                            unit Js.meth

    method finish           : (unit -> unit)      ->
                              (unit -> unit)      ->
                              Js.js_string Js.t   ->
                              unit Js.meth
  end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
val push : unit -> push Js.t
val push_notifications : unit -> push_notifications Js.t
(* -------------------------------------------------------------------------- *)
