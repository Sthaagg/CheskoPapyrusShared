scriptname ModEventWithFallbackSender extends Quest

ModEventWithFallbackReciver[] registeredReceivers

Event OnInit()
    registeredForms = new Form[128]
endEvent

function RegisterForModEventWithFallback(string asEventName, string asCallbackName, Form asReceiver)
    if isSKSEInstalled
        asReceiver.RegisterForModEvent(asEventName, asCallbackName)
    else
        RegisterForFallbackEvent(asReceiver)
    endif
endFunction

bool function RegisterForFallbackEvent(Form asReceiver)
    ModEventWithFallbackReciver receiver = asReceiver as ModEventWithFallbackReciver
    if receiver
        ArrayAddForm(registeredReceivers, receiver)
        return true
    else
        return false
    endif
endFunction



dispatcher uses Event OnBeginState() to send events
passes arrays of strings, floats, forms, and bools which last until the next call
emits these arrays to the receivers
receivers call real events with correct signature
