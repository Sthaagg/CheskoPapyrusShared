scriptname FallbackEventHandler extends ObjectReference

import CommonArrayHelper

FallbackEventSender property sender auto hidden
string property eventName auto hidden
Form[] receiverForms
Alias[] receiverAliases
ActiveMagicEffect[] receiverEffects

int pushedBoolCount = 0
Bool[] pushedBools
Int[] pushedInts
Float[] pushedFloats
String[] pushedStrings
Form[] pushedForms

bool initialized = false

Event OnInit()
  pushedBools = new bool[32]
  pushedInts = new int[32]
  pushedFloats = new float[32]
  pushedStrings = new string[32]
  pushedForms = new form[32]
  initialized = true
endEvent

bool function IsInitialized()
  if initialized
    return true
  else
    return false
  endif
endFunction

function PushBool(bool value)
  ArrayAddBool(pushedBools, value, pushedBoolCount)
  pushedBoolCount += 1
endFunction

function PushInt(int value)
  ArrayAddInt(pushedInts, value)
endFunction

function PushFloat(float value)
  ArrayAddFloat(pushedFloats, value)
endFunction

function PushString(string value)
  ArrayAddString(pushedStrings, value)
endFunction

function PushForm(form value)
  ArrayAddForm(pushedForms, value)
endFunction

bool function Send(Form[] afRegisteredForms, Alias[] afRegisteredAliases, ActiveMagicEffect[] afRegisteredActiveMagicEffects)
  receiverForms = afRegisteredForms
  receiverAliases = afRegisteredAliases
  receiverEffects = afRegisteredActiveMagicEffects
  RegisterForSingleUpdate(0.01)
  debug.trace(" <<<< Returning from Fallback Event Send.")
  return true
endFunction

Event OnUpdate()
  debug.trace(" |||| Starting Send.")

  int i = 0
  int registered_form_count = ArrayCountForm(receiverForms)
  debug.trace("Registered fallback event forms: " + receiverForms)
  while i < registered_form_count
    debug.trace("calling event on " + receiverForms[i] as FallbackEventReceiverForm)
    (receiverForms[i] as FallbackEventReceiverForm).RaiseEvent(eventName, pushedBools, pushedInts, pushedFloats, pushedForms, pushedStrings)
    i += 1
  endWhile

  i = 0
  int registered_alias_count = ArrayCountAlias(receiverAliases)
  while i < registered_alias_count
    (receiverAliases[i] as FallbackEventReceiverAlias).RaiseEvent(eventName, pushedBools, pushedInts, pushedFloats, pushedForms, pushedStrings)
    i += 1
  endWhile

  i = 0
  int registered_effect_count = ArrayCountActiveMagicEffect(receiverEffects)
  while i < registered_effect_count
    (receiverEffects[i] as FallbackEventReceiverActiveMagicEffect).RaiseEvent(eventName, pushedBools, pushedInts, pushedFloats, pushedForms, pushedStrings)
    i += 1
  endWhile

  sender.Release(self)
  Dispose()

  debug.trace(" |||| Ending Send.")
EndEvent

function Dispose()
  pushedBools = new Bool[32]
  pushedInts = new Int[32]
  pushedFloats = new Float[32]
  pushedStrings = new String[32]
  pushedForms = new Form[32]
  sender = None
  eventName = ""
  self.Disable()
  self.Delete()
endFunction
