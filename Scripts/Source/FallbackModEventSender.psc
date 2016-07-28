scriptname ModEventWithFallbackSender extends Quest

import CommonArrayHelper

Activator property FallbackModEventHandleMarker auto

FallbackModEventReceiver[] registeredForms
ObjectReference[] handles

int function Create(string asEventName)
  if isSKSELoaded
    return ModEvent.Create(asEventName)
  else
    ObjectReference handle = Game.GetPlayer().PlaceAtMe(FallbackModEventHandleMarker)
    ArrayAddForm(handles, handle)
    return handles.Find(handle) + 1
  endif
endFunction

bool function Send(int handle)
  if isSKSELoaded
    ModEvent.Send(handle)
  else
    
  endif
endFunction

function RegisterForModEventWithFallback(string asEventName, string asCallbackName, Form asReceiver)
  if isSKSELoaded
    asReceiver.RegisterForModEvent(asEventName, asCallbackName)
  else
    FallbackModEventReceiver receiver = asReceiver as FallbackModEventReceiver
    if receiver
      ArrayAddForm(registeredForms, receiver)
    endif
  endif
endFunction

function PushBool(int handle, bool value)
  if isSKSELoaded
    ModEvent.PushBool(handle, value)
  else
    ObjectReference handleref = handles[handle - 1]
    if handleref
      (handleref as FallbackModEventHandler).PushBool(value)
    endif
  endif
endFunction

function PushInt(int handle, int value)
  if isSKSELoaded
    ModEvent.PushInt(handle, value)
  else
    ObjectReference handleref = handles[handle - 1]
    if handleref
      (handleref as FallbackModEventHandler).PushInt(value)
    endif
  endif
endFunction

function PushFloat(int handle, float value)
  if isSKSELoaded
    ModEvent.PushFloat(handle, value)
  else
    ObjectReference handleref = handles[handle - 1]
    if handleref
      (handleref as FallbackModEventHandler).PushFloat(value)
    endif
  endif
endFunction

function PushString(int handle, string value)
  if isSKSELoaded
    ModEvent.PushString(handle, value)
  else
    ObjectReference handleref = handles[handle - 1]
    if handleref
      (handleref as FallbackModEventHandler).PushString(value)
    endif
  endif
endFunction

function PushForm(int handle, form value)
  if isSKSELoaded
    ModEvent.PushForm(handle, value)
  else
    ObjectReference handleref = handles[handle - 1]
    if handleref
      (handleref as FallbackModEventHandler).PushForm(value)
    endif
  endif
endFunction
