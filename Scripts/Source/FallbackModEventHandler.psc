scriptname FallbackModEventHandler extends ObjectReference

import CommonArrayHelper

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
  ArrayAddBool(pushedBools, value)
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

function Send()

endFunction
