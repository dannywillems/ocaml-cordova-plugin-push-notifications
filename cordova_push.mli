(* -------------------------------------------------------------------------- *)
type event
val event_to_js_str : event -> string
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
type init_android_options = private Ojs.t

val create_init_android_options :
  sender_id:string                                ->
  ?icon:string                                    ->
  ?icon_color:string                              ->
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
type init_ios_options = private Ojs.t

val create_init_ios_options     :
  ?alert:(bool [@js.default false])               ->
  ?badge:(bool [@js.default false])               ->
  ?sound:(bool [@js.default false])               ->
  ?clear_badge:(bool [@js.default false])         ->
  ?categories:(string array [@js.default [||]])   ->
  unit                                            ->
  init_ios_options
  [@@js.builder]
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
type init_options = private Ojs.t

val create_init_options :
  ?android:init_android_options ->
  ?ios:init_ios_options         ->
  unit                          ->
  init_options
  [@@js.builder]
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)

(* ------------------------------- *)
(* Objects for on notification *)
class additional_data : Ojs.t ->
  object
    inherit Ojs.obj
    method foreground              : bool
    method cold_start              : bool
  end

class data_notification : Ojs.t ->
  object
    inherit Ojs.obj
    method message                  : string
    method title                    : string
    method count                    : string
    method sound                    : string
    method image                    : string
    method launch_args              : string
    method additional_data          : additional_data
  end
(* ------------------------------- *)

(* ------------------------------- *)
(* Object for on registration. *)
class data_registration : Ojs.t ->
  object
    inherit Ojs.obj

    method registration_id : int
  end
(* ------------------------------- *)

type push = private Ojs.t

[@@@js.stop]
val on_registration : push -> (data_registration -> unit) -> unit
val on_notification : push -> (data_notification -> unit) -> unit
[@@@js.start]

[@@@js.implem
  val on_registration_internal :
    push ->
    string ->
    (data_registration -> unit) ->
    unit
  [@@js.call "on"]

  val on_notification_internal :
    push ->
    string ->
    (data_notification -> unit) ->
    unit
  [@@js.call "on"]

  let on_registration t f = on_registration_internal t "registration" f
  let on_notification t f = on_notification_internal t "notification" f
]

val unregister :
  push            ->
  (unit -> unit)  ->
  (unit -> unit)  ->
  string array    ->
  unit
[@@js.call]

(* iOS only *)
val set_application_icon_badge_number :
  push            ->
  (unit -> unit)  ->
  (unit -> unit)  ->
  int             ->
  unit
[@@js.call]

(* iOS only *)
val get_application_icon_badge_number :
  push            ->
  (int -> unit)   ->
  (unit -> unit)  ->
  unit
[@@js.call]

(* iOS only *)
val finish :
  push            ->
  (unit -> unit)  ->
  (unit -> unit)  ->
  string          ->
  unit
[@@js.call]
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class push_notification : Ojs.t ->
  object
    inherit Ojs.obj
    method init             : init_options -> push
    (* DEPRECATED
    method has_permission   : (data_permissions -> unit) -> unit
    *)
  end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
val push_notification : unit -> push_notification
[@@js.get "PushNotification"]
(* -------------------------------------------------------------------------- *)
