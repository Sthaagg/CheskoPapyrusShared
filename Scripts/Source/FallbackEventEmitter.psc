scriptname FallbackEventEmitter extends Quest
{Allows registration and emitting of mod event using SKSE or in SKSE-less fallback mode.}

import CommonArrayHelper

Activator property FallbackEventHandleMarker auto
{Link to your event handler marker object. See the CheskoPapyrusShared readme for more info.}

bool property UseSKSEModEvents = true auto
{If false, events from this emitter will only be registered / sent via Fallback Events.}

int property SKSE_MIN_VERSION = 10700 auto hidden ; Version that ModEvent was introduced

Form[] registeredForms
Alias[] registeredAliases
ActiveMagicEffect[] registeredActiveMagicEffects
Form[] handles

Event OnInit()
  registeredForms = new Form[128]
  registeredAliases = new Alias[128]
  registeredActiveMagicEffects = new ActiveMagicEffect[128]
  handles = new Form[128]
EndEvent

int function Create(string asEventName)
  if IsSKSELoaded()
    return ModEvent.Create(asEventName)
  else
    ObjectReference handle = Game.GetPlayer().PlaceAtMe(FallbackEventHandleMarker)
    (handle as FallbackEventHandler).sender = self
    (handle as FallbackEventHandler).eventName = asEventName
    ArrayAddForm(handles, handle as Form)
    return handles.Find(handle as Form) + 1
  endif
endFunction

bool function Send(int handle)
  if IsSKSELoaded()
    debug.trace("Sending the event via SKSE.")
    return ModEvent.Send(handle)
  else
    debug.trace("Sending the event via fallback.")
    return (handles[handle - 1] as FallbackEventHandler).Send(registeredForms, registeredAliases, registeredActiveMagicEffects)
  endif
endFunction

function Release(FallbackEventHandler akHandler)
  if akHandler
    ArrayRemoveForm(handles, akHandler)
  endif
endFunction

function RegisterFormForModEventWithFallback(string asEventName, string asCallbackName, Form akReceiver)
  debug.trace("Registering " + akReceiver + " for event " + asEventName)
  if IsSKSELoaded()
    akReceiver.RegisterForModEvent(asEventName, asCallbackName)
  else
    FallbackEventReceiverForm receiver = akReceiver as FallbackEventReceiverForm
    if receiver
      int idx = registeredForms.Find(akReceiver)
      if idx == -1
        ArrayAddForm(registeredForms, akReceiver)
      endif
    endif
  endif
endFunction

function RegisterAliasForModEventWithFallback(string asEventName, string asCallbackName, Alias akReceiver)
  if IsSKSELoaded()
    akReceiver.RegisterForModEvent(asEventName, asCallbackName)
  else
    FallbackEventReceiverAlias receiver = akReceiver as FallbackEventReceiverAlias
    if receiver
      int idx = registeredAliases.Find(akReceiver)
      if idx == -1
        ArrayAddAlias(registeredAliases, akReceiver)
      endif
    endif
  endif
endFunction

function RegisterActiveMagicEffectForModEventWithFallback(string asEventName, string asCallbackname, ActiveMagicEffect akReceiver)
  if IsSKSELoaded()
    akReceiver.RegisterForModEvent(asEventName, asCallbackName)
  else
    FallbackEventReceiverActiveMagicEffect receiver = akReceiver as FallbackEventReceiverActiveMagicEffect
    if receiver
      int idx = registeredActiveMagicEffects.Find(akReceiver)
      if idx == -1
        ArrayAddActiveMagicEffect(registeredActiveMagicEffects, akReceiver)
      endif
    endif
  endif
endFunction

function PushBool(int handle, bool value)
  if IsSKSELoaded()
    ModEvent.PushBool(handle, value)
  else
    FallbackEventHandler handleref = handles[handle - 1] as FallbackEventHandler
    if handleref
      int i = 0
      while i < 10 && !handleref.IsInitialized()
        Utility.Wait(0.1)
        i += 1
      endWhile
      handleref.PushBool(value)
    endif
  endif
endFunction

function PushInt(int handle, int value)
  if IsSKSELoaded()
    ModEvent.PushInt(handle, value)
  else
    FallbackEventHandler handleref = handles[handle - 1] as FallbackEventHandler
    if handleref
      int i = 0
      while i < 10 && !handleref.IsInitialized()
        Utility.Wait(0.1)
        i += 1
      endWhile
      handleref.PushInt(value)
    endif
  endif
endFunction

function PushFloat(int handle, float value)
  if IsSKSELoaded()
    ModEvent.PushFloat(handle, value)
  else
    FallbackEventHandler handleref = handles[handle - 1] as FallbackEventHandler
    if handleref
      int i = 0
      while i < 10 && !handleref.IsInitialized()
        Utility.Wait(0.1)
        i += 1
      endWhile
      handleref.PushFloat(value)
    endif
  endif
endFunction

function PushString(int handle, string value)
  if IsSKSELoaded()
    ModEvent.PushString(handle, value)
  else
    FallbackEventHandler handleref = handles[handle - 1] as FallbackEventHandler
    if handleref
      int i = 0
      while i < 10 && !handleref.IsInitialized()
        Utility.Wait(0.1)
        i += 1
      endWhile
      handleref.PushString(value)
    endif
  endif
endFunction

function PushForm(int handle, form value)
  if IsSKSELoaded()
    ModEvent.PushForm(handle, value)
  else
    FallbackEventHandler handleref = handles[handle - 1] as FallbackEventHandler
    if handleref
      int i = 0
      while i < 10 && !handleref.IsInitialized()
        Utility.Wait(0.1)
        i += 1
      endWhile
      handleref.PushForm(value)
    endif
  endif
endFunction

bool function IsSKSELoaded()
  ; For testing, force it to fail.
  return false
	bool skse_loaded = SKSE.GetVersion()
  if skse_loaded
		int skse_version = (SKSE.GetVersion() * 10000) + (SKSE.GetVersionMinor() * 100) + SKSE.GetVersionBeta()
		if skse_version >= SKSE_MIN_VERSION
      return true
    else
      return false
    endif
  else
    return false
  endif
endFunction
