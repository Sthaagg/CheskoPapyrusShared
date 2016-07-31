scriptname FallbackEventHandler extends ObjectReference

import CommonArrayHelper

FallbackEventEmitter property sender auto hidden
string property eventName auto hidden
Form[] receiverForms
Alias[] receiverAliases
ActiveMagicEffect[] receiverEffects

int pushedBoolCount = 0
int pushedIntCount = 0
int pushedFloatCount = 0
int pushedStringCount = 0
int pushedFormCount = 0
int MAX_COUNT = 32
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
  WaitForInitialization()
  if pushedBoolCount < MAX_COUNT
    pushedBools[pushedBoolCount] = value
    pushedBoolCount += 1
  endif
endFunction

function PushInt(int value)
  WaitForInitialization()
  if pushedIntCount < MAX_COUNT
    pushedInts[pushedIntCount] = value
    pushedIntCount += 1
  endif
endFunction

function PushFloat(float value)
  WaitForInitialization()
  if pushedFloatCount < MAX_COUNT
    pushedFloats[pushedFloatCount] = value
    pushedFloatCount += 1
  endif
endFunction

function PushString(string value)
  WaitForInitialization()
  if pushedStringCount < MAX_COUNT
    pushedStrings[pushedStringCount] = value
    pushedStringCount += 1
  endif
endFunction

function PushForm(form value)
  WaitForInitialization()
  if pushedFormCount < MAX_COUNT
    pushedForms[pushedFormCount] = value
    pushedFormCount += 1
  endif
endFunction

bool function Send(Form[] afRegisteredForms, Alias[] afRegisteredAliases, ActiveMagicEffect[] afRegisteredActiveMagicEffects)
  receiverForms = afRegisteredForms
  receiverAliases = afRegisteredAliases
  receiverEffects = afRegisteredActiveMagicEffects
  RegisterForSingleUpdate(0.01)
  return true
endFunction

Event OnUpdate()
  int i = 0
  int registered_form_count = ArrayCountForm(receiverForms)
  while i < registered_form_count
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
EndEvent

function Dispose()
  pushedBools = new Bool[1]
  pushedInts = new Int[1]
  pushedFloats = new Float[1]
  pushedStrings = new String[1]
  pushedForms = new Form[1]
  receiverForms = new Form[1]
  receiverAliases = new Alias[1]
  receiverEffects = new ActiveMagicEffect[1]
  sender = None
  eventName = ""
  self.Disable()
  self.Delete()
endFunction

function WaitForInitialization()
  int i = 0
  while i < 20 && !initialized
    Utility.Wait(0.1)
    i += 1
  endWhile
endFunction
