(* -------------------------------------------------------------------------- *)
type event
val event_to_js_str : event -> string
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class init_android_options : Ojs.t ->
  object
    inherit Ojs.obj
    method sender_id             : string
    method icon                  : string option
    method icon_color            : string option
    method sound                 : bool
    method vibrate               : bool
    method clear_notifications   : bool
    method force_show            : bool
    method topics                : string array
  end

val create_init_android_options :
  sender_id:string                                ->
  ?icon:string option                             ->
  ?icon_color:string option                       ->
  ?sound:(bool [@js.default true])                ->
  ?vibrate:(bool [@js.default true])              ->
  ?clear_notifications:(bool [@js.default true])  ->
  ?force_show:(bool [@js.default false])          ->
  ?topics:(string array [@js.default [||]])       ->
  unit                                            ->
  init_android_options
  [@@js.builder]
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class init_ios_options : Ojs.t ->
  object
    inherit Ojs.obj
    method alert                 : bool
    method badge                 : bool
    method sound                 : bool
    method clear_badge           : bool
  end

val create_init_ios_options     :
  ?alert:(bool [@js.default false])       ->
  ?badge:(bool [@js.default false])       ->
  ?sound:(bool [@js.default false])       ->
  ?clear_badge:(bool [@js.default false]) ->
  unit                                    ->
  init_ios_options
  [@@js.builder]
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class init_options : Ojs.t ->
  object
    inherit Ojs.obj
    method android       : init_android_options
    method ios           : init_ios_options
  end

val create_init_options :
  ?android:init_android_options ->
  ?ios:init_ios_options         ->
  unit                          ->
  init_options
  [@@js.builder]
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class data_permissions : Ojs.t ->
  object
    inherit Ojs.obj
    method is_enabled     : bool
  end

class push_notifications : Ojs.t ->
  object
    inherit Ojs.obj
    method init             : init_options -> unit
    method has_permission   : (data_permissions -> unit) -> unit
  end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class additional_data : Ojs.t ->
  object
    inherit Ojs.obj
    method foreground              : bool
    method cold_start              : bool
  end

class data_push : Ojs.t ->
  object
    inherit Ojs.obj
    method message                 : string
    method title                   : string
    method count                   : string
    method sound                   : string
    method image                   : string
    method additional_data          : additional_data
  end

class push : Ojs.t ->
  object
    inherit Ojs.obj
    (* How to implement the callback ? It's different if the first argument is
     * notification or error. *)
    (*
    method on               : string ->
                              (unit -> unit)    ->
                              unit Js.meth
    method off              : string ->
                              (unit -> unit)    ->
                              unit Js.meth
    *)
    method unregister                         : (unit -> unit) ->
                                                (unit -> unit) ->
                                                string array ->
                                                unit
    method set_application_icon_badge_number  : (unit -> unit)  ->
                                                (unit -> unit)  ->
                                                int             ->
                                                unit
    method get_application_icon_badge_number  : (int -> unit)  ->
                                                (unit -> unit)  ->
                                                unit
    [@@js.call]

    method finish                             : (unit -> unit)      ->
                                                (unit -> unit)      ->
                                                string   ->
                                                unit
  end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
val push : unit -> push
val push_notifications : unit -> push_notifications
(* -------------------------------------------------------------------------- *)
