scriptname CommonArrayHelper hidden
{Global array helper functions.}

int function GetVersion() global
	return 2
endFunction

bool function ArrayAddForm(Form[] akArray, Form akValue) global
	;Adds a form to the first available non-None element in the array.
	;		false		=		Error (array full)
	;		true		=		Success

	int i = 0
	while i < akArray.Length
		if IsNone(akArray[i])
			akArray[i] = akValue
			return true
		else
			i += 1
		endif
	endWhile
	return false
endFunction

bool function ArrayAddAlias(Alias[] akArray, Alias akValue) global
	;Adds a form to the first available non-None element in the array.
	;		false		=		Error (array full)
	;		true		=		Success

	int i = 0
	while i < akArray.Length
		if akArray[i] == None
			akArray[i] = akValue
			return true
		else
			i += 1
		endif
	endWhile
	return false
endFunction

bool function ArrayAddActiveMagicEffect(ActiveMagicEffect[] akArray, ActiveMagicEffect akValue) global
	;Adds a form to the first available non-None element in the array.
	;		false		=		Error (array full)
	;		true		=		Success

	int i = 0
	while i < akArray.Length
		if akArray[i] == None
			akArray[i] = akValue
			return true
		else
			i += 1
		endif
	endWhile
	return false
endFunction

bool function ArrayAddArmor(Armor[] akArray, Armor akValue) global
	;Adds a form to the first available non-None element in the array.
	;		false		=		Error (array full)
	;		true		=		Success

	int i = 0
	while i < akArray.Length
		if IsNone(akArray[i])
			akArray[i] = akValue
			return true
		else
			i += 1
		endif
	endWhile
	return false
endFunction

bool function ArrayAddActivator(Activator[] akArray, Activator akValue) global
	;Adds a form to the first available non-None element in the array.
	;		false		=		Error (array full)
	;		true		=		Success

	int i = 0
	while i < akArray.Length
		if IsNone(akArray[i])
			akArray[i] = akValue
			return true
		else
			i += 1
		endif
	endWhile
	return false
endFunction

bool function ArrayAddRef(ObjectReference[] akArray, ObjectReference akValue) global
    int index = akArray.Find(None)
    if index >= 0
        akArray[index] = akValue
        return true
    else
    	return false
    endif
endFunction

bool function ArrayAddBool(Bool[] abArray, Bool abValue, int aiIndex) global
	;Adds a bool to the given array index.
	;		false		=		Error (array full)
	;		true		=		Success

	if aiIndex < abArray.Length
		abArray[aiIndex] = abValue
		return true
	else
		return false
	endif
endFunction

bool function ArrayAddInt(int[] aiArray, int aiValue, int aiInsertAtValue = 0) global
	;Adds an int to the first element with an instance of the supplied value.
	;		false		=		Error (array full, value not found)
	;		true		=		Success

	int i = 0
	while i < aiArray.Length
		if aiArray[i] == aiInsertAtValue
			aiArray[i] = aiValue
			return true
		else
			i += 1
		endif
	endWhile
	return false
endFunction

bool function ArrayAddFloat(float[] afArray, float afValue, float afInsertAtValue = 0.0) global
	;Adds an int to the first element with an instance of the supplied value.
	;		false		=		Error (array full, value not found)
	;		true		=		Success

	int i = 0
	while i < afArray.Length
		if afArray[i] == afInsertAtValue
			afArray[i] = afValue
			return true
		else
			i += 1
		endif
	endWhile
	return false
endFunction

bool function ArrayAddString(String[] asArray, String asValue) global
	;Adds a form to the first available non-None element in the array.
	;		false		=		Error (array full)
	;		true		=		Success

	int i = 0
	while i < asArray.Length
		if asArray[i] != ""
			asArray[i] = asValue
			return true
		else
			i += 1
		endif
	endWhile
	return false
endFunction

bool function ArrayRemoveForm(Form[] akArray, Form akValue, bool abSort = false) global
    ;Removes a form from the array, if found. Sorts the array using ArraySort() if bSort is true.
    ;       false       =       Error (string not found)
    ;       true        =       Success

    int i = 0
    while i < akArray.Length
        if akArray[i] == akValue
            akArray[i] = None
            if abSort == true
                ArraySortForm(akArray)
            endif
            return true
        else
            i += 1
        endif
    endWhile

    return false

endFunction

bool function ArrayRemoveArmor(Armor[] akArray, Armor akValue, bool abSort = false) global
    ;Removes a form from the array, if found. Sorts the array using ArraySort() if bSort is true.
    ;       false       =       Error (string not found)
    ;       true        =       Success

    int i = 0
    while i < akArray.Length
        if akArray[i] == akValue
            akArray[i] = None
            if abSort == true
                ArraySortArmor(akArray)
            endif
            return true
        else
            i += 1
        endif
    endWhile

    return false

endFunction

bool function ArrayRemoveMessage(Message[] akArray, Message akValue, bool abSort = false) global
    ;Removes a form from the array, if found. Sorts the array using ArraySort() if bSort is true.
    ;       false       =       Error (string not found)
    ;       true        =       Success

    int i = 0
    while i < akArray.Length
        if akArray[i] == akValue
            akArray[i] = None
            if abSort == true
                ArraySortMessage(akArray)
            endif
            return true
        else
            i += 1
        endif
    endWhile

    return false

endFunction

bool function ArrayRemoveFormList(FormList[] akArray, FormList akValue, bool abSort = false) global
    ;Removes a form from the array, if found. Sorts the array using ArraySort() if bSort is true.
    ;       false       =       Error (string not found)
    ;       true        =       Success

    int i = 0
    while i < akArray.Length
        if akArray[i] == akValue
            akArray[i] = None
            if abSort == true
                ArraySortFormList(akArray)
            endif
            return true
        else
            i += 1
        endif
    endWhile

    return false

endFunction

bool function ArraySortForm(Form[] akArray, int i = 0) global
	;Removes blank elements by shifting all elements down.
	;		   false		=			   No sorting required
	;		   true			=			   Success

	 bool bFirstNoneFound = false
	 int iFirstNonePos = i
	 while i < akArray.Length
		  if IsNone(akArray[i])
		  	   akArray[i] = none
			   if bFirstNoneFound == false
					bFirstNoneFound = true
					iFirstNonePos = i
					i += 1
			   else
					i += 1
			   endif
		  else
			   if bFirstNoneFound == true
			   ;check to see if it's a couple of blank entries in a row
					if !(IsNone(akArray[i]))
						 akArray[iFirstNonePos] = akArray[i]
						 akArray[i] = none

						 ;Call this function recursively until it returns
						 ArraySortForm(akArray, iFirstNonePos + 1)
						 return true
					else
						 i += 1
					endif
			   else
					i += 1
			   endif
		  endif
	 endWhile
	 return false
endFunction

bool function ArraySortArmor(Armor[] akArray, int i = 0) global
	;Removes blank elements by shifting all elements down.
	;		   false		=			   No sorting required
	;		   true			=			   Success

	 bool bFirstNoneFound = false
	 int iFirstNonePos = i
	 while i < akArray.Length
		  if IsNone(akArray[i])
		  	   akArray[i] = none
			   if bFirstNoneFound == false
					bFirstNoneFound = true
					iFirstNonePos = i
					i += 1
			   else
					i += 1
			   endif
		  else
			   if bFirstNoneFound == true
			   ;check to see if it's a couple of blank entries in a row
					if !(IsNone(akArray[i]))
						 akArray[iFirstNonePos] = akArray[i]
						 akArray[i] = none

						 ;Call this function recursively until it returns
						 ArraySortArmor(akArray, iFirstNonePos + 1)
						 return true
					else
						 i += 1
					endif
			   else
					i += 1
			   endif
		  endif
	 endWhile
	 return false
endFunction

bool function ArraySortActivator(Activator[] akArray, int i = 0) global
	;Removes blank elements by shifting all elements down.
	;		   false		=			   No sorting required
	;		   true			=			   Success

	 bool bFirstNoneFound = false
	 int iFirstNonePos = i
	 while i < akArray.Length
		  if IsNone(akArray[i])
		  	   akArray[i] = none
			   if bFirstNoneFound == false
					bFirstNoneFound = true
					iFirstNonePos = i
					i += 1
			   else
					i += 1
			   endif
		  else
			   if bFirstNoneFound == true
			   ;check to see if it's a couple of blank entries in a row
					if !(IsNone(akArray[i]))
						 akArray[iFirstNonePos] = akArray[i]
						 akArray[i] = none

						 ;Call this function recursively until it returns
						 ArraySortActivator(akArray, iFirstNonePos + 1)
						 return true
					else
						 i += 1
					endif
			   else
					i += 1
			   endif
		  endif
	 endWhile
	 return false
endFunction

bool function ArraySortMessage(Message[] akArray, int i = 0) global
	;Removes blank elements by shifting all elements down.
	;		   false		=			   No sorting required
	;		   true			=			   Success

	 bool bFirstNoneFound = false
	 int iFirstNonePos = i
	 while i < akArray.Length
		  if IsNone(akArray[i])
		  	   akArray[i] = none
			   if bFirstNoneFound == false
					bFirstNoneFound = true
					iFirstNonePos = i
					i += 1
			   else
					i += 1
			   endif
		  else
			   if bFirstNoneFound == true
			   ;check to see if it's a couple of blank entries in a row
					if !(IsNone(akArray[i]))
						 akArray[iFirstNonePos] = akArray[i]
						 akArray[i] = none

						 ;Call this function recursively until it returns
						 ArraySortMessage(akArray, iFirstNonePos + 1)
						 return true
					else
						 i += 1
					endif
			   else
					i += 1
			   endif
		  endif
	 endWhile
	 return false
endFunction

bool function ArraySortFormList(FormList[] akArray, int i = 0) global
	;Removes blank elements by shifting all elements down.
	;		   false		=			   No sorting required
	;		   true			=			   Success

	 bool bFirstNoneFound = false
	 int iFirstNonePos = i
	 while i < akArray.Length
		  if IsNone(akArray[i])
		  	   akArray[i] = none
			   if bFirstNoneFound == false
					bFirstNoneFound = true
					iFirstNonePos = i
					i += 1
			   else
					i += 1
			   endif
		  else
			   if bFirstNoneFound == true
			   ;check to see if it's a couple of blank entries in a row
					if !(IsNone(akArray[i]))
						 akArray[iFirstNonePos] = akArray[i]
						 akArray[i] = none

						 ;Call this function recursively until it returns
						 ArraySortFormList(akArray, iFirstNonePos + 1)
						 return true
					else
						 i += 1
					endif
			   else
					i += 1
			   endif
		  endif
	 endWhile
	 return false
endFunction

int function ArrayCountForm(Form[] akArray) global
	;Counts the number of indices in this array that do not have a "none" type.
	;		int myCount = number of indicies that are not "none"

	int i = 0
	int myCount = 0
	while i < akArray.Length
		if !(IsNone(akArray[i]))
			myCount += 1
			i += 1
		else
			i += 1
		endif
	endWhile
	return myCount
endFunction

int function ArrayCountAlias(Alias[] akArray) global
	;Counts the number of indices in this array that do not have a "none" type.
	;		int myCount = number of indicies that are not "none"

	int i = 0
	int myCount = 0
	while i < akArray.Length
		if akArray[i] != None
			myCount += 1
			i += 1
		else
			i += 1
		endif
	endWhile
	return myCount
endFunction

int function ArrayCountActiveMagicEffect(ActiveMagicEffect[] akArray) global
	;Counts the number of indices in this array that do not have a "none" type.
	;		int myCount = number of indicies that are not "none"

	int i = 0
	int myCount = 0
	while i < akArray.Length
		if akArray[i] != None
			myCount += 1
			i += 1
		else
			i += 1
		endif
	endWhile
	return myCount
endFunction

int function ArrayCountArmor(Armor[] akArray) global
	;Counts the number of indices in this array that do not have a "none" type.
	;		int myCount = number of indicies that are not "none"

	int i = 0
	int myCount = 0
	while i < akArray.Length
		if !(IsNone(akArray[i]))
			myCount += 1
			i += 1
		else
			i += 1
		endif
	endWhile
	return myCount
endFunction

int function ArrayCountActivator(Activator[] akArray) global
	;Counts the number of indices in this array that do not have a "none" type.
	;		int myCount = number of indicies that are not "none"

	int i = 0
	int myCount = 0
	while i < akArray.Length
		if !(IsNone(akArray[i]))
			myCount += 1
			i += 1
		else
			i += 1
		endif
	endWhile
	return myCount
endFunction

int function ArrayCountRef(ObjectReference[] akArray) global
	;Counts the number of indices in this array that do not have a "none" type.
	;		int myCount = number of indicies that are not "none"

	int i = 0
	int myCount = 0
	while i < akArray.Length
		if akArray[i] != None
			myCount += 1
			i += 1
		else
			i += 1
		endif
	endWhile
	return myCount
endFunction


bool function IsNone(Form akForm) global
	; Array elements that contain forms from unloaded mods
	; will fail '== None' checks because they are
	; 'Form<None>' objects. Check FormID as well.
	int i = 0
	if akForm
		i = akForm.GetFormID()
		if i == 0
			return true
		else
			return false
		endif
	else
		return true
	endif
endFunction
