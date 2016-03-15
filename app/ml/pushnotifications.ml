(* -------------------------------------------------------------------------- *)
type event =
  | Notification
  | Registration
  | Error

let event_to_js_str e = match e with
  | Notification  -> Js.string "notification"
  | Registration  -> Js.string "registration"
  | Error         -> Js.string "error"
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

let create_init_android_options
  sender_id
  ?(icon=None)
  ?(icon_color=None)
  ?(sound=true)
  ?(vibrate=true)
  ?(clear_notifications=true)
  ?(force_show=true)
  ?(topics=[||]) () =
  object%js
    val senderId            = Js.string sender_id
    val icon                = match icon with
    | None    -> Js.null
    | Some x  -> Js.some (Js.string x)
    val iconColor           = match icon_color with
    | None    -> Js.null
    | Some x  -> Js.some (Js.string x)
    val sound               = Js.bool sound
    val vibrate             = Js.bool vibrate
    val clearNotifications  = Js.bool clear_notifications
    val forceShow           = Js.bool force_show
    val topics              = Js.array (Array.map (fun x -> Js.string x) topics)
  end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
type init_ios_options =
  <
    alert                 : bool Js.t Js.readonly_prop ;
    badge                 : bool Js.t Js.readonly_prop ;
    sound                 : bool Js.t Js.readonly_prop ;
    clearBadge            : bool Js.t Js.readonly_prop ;
  > Js.t

let create_init_ios_options
  ?(alert=false)
  ?(badge=false)
  ?(sound=false)
  ?(clear_badge=false) () =
  object%js
    val alert       = Js.bool alert
    val badge       = Js.bool badge
    val sound       = Js.bool sound
    val clearBadge  = Js.bool clear_badge
  end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
type init_options =
  <
    android       : init_android_options Js.readonly_prop ;
    ios           : init_ios_options Js.readonly_prop
  > Js.t

type data_permissions =
  <
    isEnabled     : bool Js.t Js.readonly_prop
  > Js.t
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
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
    method on                             : Js.js_string Js.t ->
                                            (unit -> unit)    ->
                                            unit Js.meth
    method off                            : Js.js_string Js.t ->
                                            (unit -> unit)    ->
                                            unit Js.meth
    *)
    method unregister                     : (unit -> unit) ->
                                            (unit -> unit) ->
                                            Js.js_string Js.t Js.js_array Js.t ->
                                            unit Js.meth
    method setApplicationIconBadgeNumber  : (unit -> unit)  ->
                                            (unit -> unit)  ->
                                            int             ->
                                            unit Js.meth
    method getApplicationIconBadgeNumber  : (int -> unit)   ->
                                            (unit -> unit)  ->
                                            unit Js.meth

    method finish                         : (unit -> unit)      ->
                                            (unit -> unit)      ->
                                            Js.js_string Js.t   ->
                                            unit Js.meth
  end
(* -------------------------------------------------------------------------- *)


