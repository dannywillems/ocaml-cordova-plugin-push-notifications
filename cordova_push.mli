(* -------------------------------------------------------------------------- *)
module Init_options : sig

  module Android : sig
    type t

    val create :
      ?icon:string                                    ->
      ?icon_color:string                              ->
      ?sound:(bool [@js.default true])                ->
      ?vibrate:(bool [@js.default true])              ->
      ?clear_notifications:(bool [@js.default true])  ->
      ?force_show:(bool [@js.default false])          ->
      ?topics:(string array [@js.default [||]])       ->
      sender_ID:string                                ->
      unit                                            ->
      t
    [@@js.builder]
  end

  module Ios : sig
    type t

    val create     :
      ?alert:(bool [@js.default false])               ->
      ?badge:(bool [@js.default false])               ->
      ?sound:(bool [@js.default false])               ->
      ?clear_badge:(bool [@js.default false])         ->
      ?categories:(string array [@js.default [||]])   ->
      unit                                            ->
      t
    [@@js.builder]
  end

  type t

  val create :
    ?android:Android.t ->
    ?ios:Ios.t         ->
    unit               ->
    t
    [@@js.builder]
end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
(* ------------------------------- *)
(* Objects for on notification *)

module Additional_data : sig
  type t

  val foreground      : t -> bool
  val cold_start      : t -> bool
end

module Data_notification : sig
    type t

    val message         : t -> string
    val title           : t -> string
    val count           : t -> string
    val sound           : t -> string
    val image           : t -> string
    val launch_args     : t -> string
    val additional_data : t -> Additional_data.t
  end
(* ------------------------------- *)

(* ------------------------------- *)
(* Object for on registration. *)

module Data_registration : sig
  type t

  val registration_id : t -> int
end

(* ------------------------------- *)

type t

[@@@js.stop]
val on_registration : t -> (Data_registration.t -> unit) -> unit
val on_notification : t -> (Data_notification.t -> unit) -> unit
[@@@js.start]

[@@@js.implem
  val on_registration_internal :
    t ->
    string ->
    (Data_registration.t -> unit) ->
    unit
  [@@js.call "on"]

  val on_notification_internal :
    t ->
    string ->
    (Data_notification.t -> unit) ->
    unit
  [@@js.call "on"]

  let on_registration t f = on_registration_internal t "registration" f
  let on_notification t f = on_notification_internal t "notification" f
]

val unregister :
  t               ->
  (unit -> unit)  ->
  (unit -> unit)  ->
  string array    ->
  unit
[@@js.call]

(* iOS only *)
val set_application_icon_badge_number :
  t               ->
  (unit -> unit)  ->
  (unit -> unit)  ->
  int             ->
  unit
[@@js.call]

(* iOS only *)
val get_application_icon_badge_number :
  t               ->
  (int -> unit)   ->
  (unit -> unit)  ->
  unit
[@@js.call]

(* iOS only *)
val finish :
  t               ->
  (unit -> unit)  ->
  (unit -> unit)  ->
  string          ->
  unit
[@@js.call]
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
val init :
  Init_options.t ->
  t
[@@js.global "PushNotification.init"]

module Data_permission : sig
  type t

  val is_enabled : t -> bool
end

val has_permission   : (Data_permission.t -> unit) -> unit
[@@js.global "PushNotification.hasPermission"]
(* -------------------------------------------------------------------------- *)
