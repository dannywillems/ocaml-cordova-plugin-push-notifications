(* ----------------------------------------------------- *)
(* ---------- Option to get a registration ID ---------- *)

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
      (* For GCM *)
      ?sender_ID:string                               ->
      ?gcm_sandbox:(bool [@js.default false])         ->
      ?topics:(string array [@js.default [||]])       ->
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

(* ---------- Option to get a registration ID ---------- *)
(* ----------------------------------------------------- *)

(* ------------------------------------------------- *)
(* ---------- Objects for on notification ---------- *)

module Additional_data : sig
  type t

  val foreground      : t -> bool
  val cold_start      : t -> bool
  val inline_reply    : t -> string (* If payload "inline reply" is used *)
  val not_id          : t -> string (* if payload "notId" is used *)

  (** The following section defines functions to get data sent to FCM server in
      the payload 'data'.
   *)
  [@@@js.stop]
  (** [get data key] returns the value of [data.key] as an [Ojs.t] type. *)
  val get                 : t -> string -> Ojs.t

  (** [get_opt data key] returns the value of [data.key] as an [Ojs.t] option.
      If [key] is not an attribute of [data], it returns [None].
   *)
  val get_opt             : t -> string -> Ojs.t option

  (** [get_string data key] returns the value of [data.key] as a string *)
  val get_string          : t -> string -> string

  (** [get_string_opt data key] returns the value of [data.key] as a string
      option. If [key] is not an attribute of [data], it returns [None].
   *)
  val get_string_opt      : t -> string -> string option

  (** [get_int data key] returns the value of [data.key] as an integer *)
  val get_int             : t -> string -> int

  (** [get_int_opt data key] returns the value of [data.key] as an int option.
      If [key] is not an attribute of [data], it returns [None].
   *)
  val get_int_opt         : t -> string -> int option

  (** [get_bool data key] returns the value of [data.key] as a boolean *)
  val get_bool            : t -> string -> bool

  (** [get_bool_opt data key] returns the value of [data.key] as a bool
      option. If [key] is not an attribute of [data], it returns [None].
   *)
  val get_bool_opt        : t -> string -> bool option

  (** [get_int64 data key] returns the value of [data.key] as an int64 type *)
  val get_int64           : t -> string -> int64

  (** [get_int64_opt data key] returns the value of [data.key] as an int64
      option. If [key] is not an attribute of [data], it returns [None].
   *)
  val get_int64_opt       : t -> string -> int64 option

  (** [get_float data key] returns the value of [data.key] as a float type *)
  val get_float           : t -> string -> float

  (** [get_float_opt data key] returns the value of [data.key] as a float
      option. If [key] is not an attribute of [data], it returns [None].
   *)
  val get_float_opt       : t -> string -> float option
  [@@@js.start]

  [@@@js.implem
    let get data key        = Ojs.get data key

    let get_opt data key    = Ojs.option_of_js (fun x -> x) data

    let get_string data key = Ojs.string_of_js (get data key)

    let get_string_opt data key =
      Ojs.option_of_js Ojs.string_of_js (get data key)

    let get_int data key    = Ojs.int_of_js (get data key)

    let get_int_opt data key     =
      Ojs.option_of_js Ojs.int_of_js (get data key)

    let get_bool data key   = Ojs.bool_of_js (get data key)

    let get_bool_opt data key    =
      Ojs.option_of_js Ojs.bool_of_js (get data key)

    let get_int64 data key  = Int64.of_string (get_string data key)

    let get_int64_opt data key   =
      Ojs.option_of_js
        (fun v -> Int64.of_string (Ojs.string_of_js v))
        (get data key)

    let get_float data key  = Ojs.float_of_js (get data key)

    let get_float_opt data key   =
      Ojs.option_of_js Ojs.float_of_js (get data key)
  ]
end

module Data_notification : sig
    type t

    val message         : t -> string
    val title           : t -> string
    val count           : t -> string option (* FIXME: Sometimes null, why? *)
    val sound           : t -> string option (* FIXME: Sometimes null, why? *)
    val image           : t -> string option (* FIXME: Sometimes null, why? *)
    val launch_args     : t -> string option (* FIXME: Sometimes null, why? *)
    val additional_data : t -> Additional_data.t
  end

(* ---------- Objects for on notification ---------- *)
(* ------------------------------------------------- *)

(* ------------------------------------------------- *)
(* ---------- Object for on registration. ---------- *)

module Data_registration : sig
  type t

  val registration_id : t -> string
end

(* ---------- Object for on registration. ---------- *)
(* ------------------------------------------------- *)

(* --------------------------- *)
(* ---------- Error ---------- *)

module Error : sig
  type t

  val message : t -> string
end

(* ---------- Error ---------- *)
(* --------------------------- *)

(* ------------------------------ *)
(* ---------- On event ---------- *)

type t

[@@@js.stop]
val on_registration : t -> (Data_registration.t -> unit)  -> unit
val on_notification : t -> (Data_notification.t -> unit)  -> unit
val on_error        : t -> (Error.t -> unit)              -> unit
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

  val on_error_internal :
    t ->
    string ->
    (Error.t -> unit) ->
    unit
  [@@js.call "on"]

  let on_registration t f = on_registration_internal t "registration" f
  let on_notification t f = on_notification_internal t "notification" f
  let on_error        t f = on_error_internal t "error" f
]

(* ---------- On event ---------- *)
(* ------------------------------ *)

(* ------------------------------- *)
(* ---------- Off event ---------- *)
(* !! You need to give the same function you sent to the corresponding on
 * function ! See the document of the orignal plugin
 *)

[@@@js.stop]
val off_registration : t -> (Data_registration.t -> unit)  -> unit
val off_notification : t -> (Data_notification.t -> unit)  -> unit
val off_error        : t -> (Error.t -> unit)              -> unit
[@@@js.start]

[@@@js.implem
  val off_registration_internal :
    t ->
    string ->
    (Data_registration.t -> unit) ->
    unit
  [@@js.call "off"]

  val off_notification_internal :
    t ->
    string ->
    (Data_notification.t -> unit) ->
    unit
  [@@js.call "off"]

  val off_error_internal :
    t ->
    string ->
    (Error.t -> unit) ->
    unit
  [@@js.call "off"]

  let off_registration t f = off_registration_internal t "registration" f
  let off_notification t f = off_notification_internal t "notification" f
  let off_error        t f = off_error_internal t "error" f
]

(* ---------- Off event ---------- *)
(* ------------------------------- *)

(* -------------------------------------- *)
(* ---------- Unregister an ID ---------- *)

val unregister :
  t               ->
  (unit -> unit)  ->
  (unit -> unit)  ->
  string array    ->
  unit
[@@js.call]

(* ---------- Unregister an ID ---------- *)
(* -------------------------------------- *)

(* ------------------------------------- *)
(* ---------- Other functions ---------- *)
(* See the official documentation for the description *)

(* iOS & Android only *)
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

val clear_all_notifications :
  t               ->
  (unit -> unit)  ->
  (unit -> unit)  ->
  unit
[@@js.call]
(* ---------- Other functions ---------- *)
(* ------------------------------------- *)

(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
(* Main function for initialization and to check permission *)

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

(* Main function for initialization and to check permission *)
(* -------------------------------------------------------------------------- *)
