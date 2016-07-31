# Chesko Papyrus Shared Libraries
Shared code and libraries I use for many different mods for Skyrim.

##Common Array Helper
`CommonArrayHelper.psc` contains many functions that make interacting with
arrays easier. It is non-exhaustive and primarily contains on the types I've
needed in my own projects. Feel free to fork this project or modify the
code to add your own functions if the one that you need isn't available.

All of the functions are global, so to use this library in your project, just
`import CommonArrayHelper`.

##Fallback Events

####[Fallback Event API Reference](https://github.com/chesko256/CheskoPapyrusShared/wiki/Fallback-Event-API-Reference)

The **Fallback Event library** allows you to register for custom events. If SKSE
is available on the user's system, by default, it will use the SKSE ModEvent
system. If SKSE isn't available, it will "fall back" to using a vanilla-only
custom event implementation. You can also bypass the default behavior and elect
to only use the Fallback Event system ([see note](https://github.com/chesko256/CheskoPapyrusShared#note-disabling-skse-mod-events)).

This library is handy for creating or retrofitting mods that rely on Mod Events
to work on console platforms, or on PCs that do not have SKSE installed, while
preserving most important functionality.

Fallback Events use an SKSE Mod Event-like syntax and retains many of the
features of SKSE Mod Events. If you are currently using Mod Events, converting
them to use the Fallback Event library should not take a large amount of effort.

Fallback Events require some additional objects in the Creation Kit in order to
set them up, as well as some additional code. These steps are detailed below.

###Getting Started
Start by downloading and adding the following files from this repository into
your project:
```
CommonArrayHelper.psc / .pex
FallbackEventEmitter.psc / .pex
FallbackEventHandler.psc / .pex
FallbackEventReceiverForm.psc / .pex
FallbackEventReceiverAlias.psc / .pex
FallbackEventReceiverActiveMagicEffect.psc / .pex
```

###Event Emitter
The **Fallback Event Emitter** takes care of event registration, as well as
sending the event to recipients.

You must create **one Quest per custom Event** and attach `FallbackEventEmitter`
to each one. You can then interact with it in your code much like you would
use `ModEvent`.

To register for the custom event, we must reference the Quest that serves
as our emitter. We must call the right function depending
on the type of the registrar. You can register **Forms**, **Aliases**, and
**ActiveMagicEffects**. If your object is not one of these types, see if it can
be cast to it. For instance, ReferenceAliases can be cast to Alias.

As an example, we will register a wagon to myCoolEvent. You'll notice that
unlike Mod Events, we must pass a third parameter, which is the object being
registered. Otherwise, this should look fairly familar to SKSE Mod Event users.

We'll define the custom event below as well. myCoolEvent has 3 parameters. When
the event is sent (either by SKSE Mod Event or by Fallback Event),
myCoolEventCallback will be called.

```
scriptname myWagonScript extends ObjectReference

Quest property MyEventEmitter auto

function foo()
  ; Register for the custom event.
  FallbackEventEmitter emitter = MyEventEmitter as FallbackEventEmitter
  emitter.RegisterFormForModEventWithFallback("myCoolEvent", "myCoolEventCallback", self as Form)
endFunction

Event myCoolEventCallback(bool someBool, string someString, int someInt, int anotherInt)
  ; do something cool here!
endEvent
```

###Event Handler
There is some final plumbing that we must do in order for a Fallback Event
to be successfully sent. The first is that we must create a **Fallback Event Handler**
object.

1. Open the Creation Kit and open your plug-in.
2. Navigate to Activators in the Object Window.
3. Duplicate xMarkerActivator. Rename the duplicate something memorable.
4. Attach the `FallbackEventHandler` script to the object.
5. In all of your Fallback Event Emitter quests, open the properties of the `FallbackEventEmitter` and fill the `FallbackEventHandleMarker` property with the activator you just created.
6. Make sure to fill the PlayerRef property of the Event Emitter while you're there, too.

###Event Receiver
Lastly, you must attach a **Fallback Event Receiver** to the object that
registered for an event.

You should ***NOT*** use the included `FallbackEventReceiver*` scripts, you should
create a new script and extend it.

In this script, we must "unpack" the data received by the event ourselves
and pass it to the event. This is much less convenient than using Mod Events,
I know, but, that's the price you pay for not having SKSE.

Data is stored in the received arrays in the order they were pushed. In this
example, 42 would be in pushedInts index 0, and 17 would be in pushedInts index
1.

You should extend a Receiver script and override its `RaiseEvent` function,
with the function signature exactly as shown below.

```
scriptname myWagonEventReceiver extends FallbackEventReceiverForm

function RaiseEvent(String asEventName, Bool[] pushedBools, Int[] pushedInts, Float[] pushedFloats, Form[] pushedForms, String[] pushedStrings)
  if asEventName == "myCoolEvent"
    bool firstParam = pushedBools[0]
    string secondParam = pushedStrings[0]
    int thirdParam = pushedInts[0]
    int fourthParam = pushedInts[1]
    (self as myWagonScript).myCoolEventCallback(firstParam, secondParam, thirdParam, fourthParam)
  endif
endFunction
```

Or, we could write it more concisely as:

```
scriptname myWagonEventReceiver extends FallbackEventReceiverForm

function RaiseEvent(String asEventName, Bool[] pushedBools, Int[] pushedInts, Float[] pushedFloats, Form[] pushedForms, String[] pushedStrings)
  if asEventName == "myCoolEvent"
    (self as myWagonScript).myCoolEventCallback(pushedBools[0], pushedStrings[0], pushedInts[0], pushedInts[1])
  endif
endFunction
```

Once this script is compiled and attached to the object, this object can now
receive Fallback Events.

If you have more than one kind of event that this object could potentially
receive, just add it to the list in the `RaiseEvent` function, like so:

```
scriptname myWagonEventReceiver extends FallbackEventReceiverForm

function RaiseEvent(String asEventName, Bool[] pushedBools, Int[] pushedInts, Float[] pushedFloats, Form[] pushedForms, String[] pushedStrings)
  if asEventName == "myCoolEvent"
    (self as myWagonScript).myCoolEventCallback(pushedBools[0], pushedStrings[0], pushedInts[0], pushedInts[1])
  elseif asEventName == "someOtherEvent"
    ;...and so on
  endif
endFunction
```

***Tip: You must have a different Quest for EACH unique event (with a
Fallback Event Emitter script attached to each one), but only need one kind of
Handler object for all events. You also only need one receiver script on objects
 that receive events, just check the event name and call the appropriate event
 like a function. To summarize: One Quest per Event, one handler, one receiver
 script per type of receiver.***

###Sending the Event
To send the event, we again must reference the emitter and then create a handle
to the event, push data to it, and send it, just like a normal SKSE Mod Event.

```
scriptname someOtherScript extends ObjectReference

Quest property MyEventEmitter auto

function bar()
  ; Send myCoolEvent using SKSE ModEvent OR Fallback Event, depending on
  ; if the user has SKSE or not.

  FallbackEventEmitter emitter = MyEventEmitter as FallbackEventEmitter
  int handle = emitter.Create("myCoolEvent")
  if handle
    emitter.PushBool(handle, true)
    emitter.PushString(handle, "eat at joe's")
    emitter.PushInt(handle, 42)
    emitter.PushInt(handle, 17)
    emitter.Send(handle)
  endif
endFunction
```

This would send a custom event to anyone registered to myCoolEvent using
an SKSE Mod Event (if the user has SKSE installed), or a Fallback Event if
they don't.

###Note: Disabling SKSE Mod Events
If for some reason you would like to only send the event using a Fallback Event,
set the `UseSKSEModEvents` property on the Event Emitter to `false` in the CK
or via code (BEFORE the event is registered to or an event handle is
`Create()`ed!). Doing it in the CK is the safest. This will prevent the library
from trying to use an SKSE Mod Event, even if the user has SKSE installed.

###Note: Example Implementation
Frostfall has already successfully implemented Fallback Events in some of its
code as it begins aligning itself towards becoming console-compatible. You can
see an example by looking at [_Frost_ClimateSystem](https://github.com/chesko256/Campfire/blob/NewExposureSystem/Scripts/Source/_Frost_ClimateSystem.psc),
which registers for an event `OnTamrielRegionChange`, and [_Frost_RegionDetectScript](https://github.com/chesko256/Campfire/blob/NewExposureSystem/Scripts/Source/_Frost_RegionDetectScript.psc),
which pushes some data and sends the event. [_Frost_FallbackReceiverClimateSystem](https://github.com/chesko256/Campfire/blob/NewExposureSystem/Scripts/Source/_Frost_FallbackReceiverClimateSystem.psc) receives the event and
calls the appropriate event method. `GetEventEmitter_OnTamrielRegionChange()`
is an abstraction to get the Event Emitter implemented on [FrostUtil](https://github.com/chesko256/Campfire/blob/NewExposureSystem/Scripts/Source/FrostUtil.psc) and is strictly
for my own convenience.

###Pros

* Fallback Events work even if the user doesn't have SKSE installed.
* They will (presumably) work on consoles.
* Using them (sending, creating, pushing data, etc) in code feels familiar to
using Mod Events.
* Like Mod Events, they don't have to be unregistered for. When the registered
object no longer exists, it will be automatically unregistered.

###Cons

* The performance of a Fallback Event **will be slower (possibly much slower)**
than a Mod Event. `Send()` returns immediately. However, once `Send()` is
called, each registered receiver is called one by one instead of simultaneously
by the event handler. The event handler can't call the next receiver's event
until the one that it's currently on finishes running. For instance, if refA,
refB, and refC are all registered to receive the myCoolEvent event,
refA.myCoolEvent() must execute completely before refB.myCoolEvent is called.
This means that the event handler might require significant time to call the
event block on each receiver if each receiver takes a long time to execute. This
makes fallback events somewhat unsuitable for long-running event code or events
with many receivers. Try to return quickly from your custom events in order to
speed up execution time.
* There is more to set up; it isn't a purely code-based solution.
* You have to write more code (manually unpacking data for the receiver, etc).
* Unlike Mod Events, which take an arbitrary number of parameters pushed to
the event, Fallback Events can only take 32 of each type (32 bools, 32 ints, etc).
