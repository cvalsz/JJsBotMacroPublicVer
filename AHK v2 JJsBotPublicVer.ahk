; Function to reverse a string manually
ReverseString(str)
{
    reversed := ""
    Loop, Parse, str
    {
        reversed := A_LoopField . reversed
    }
    return reversed
}

; Function to convert number to word
Number2Name(Number)
{
    static OnesArray := ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    static TeensArray := ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
    static TensArray := ["twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]
    static ThousandsArray := ["thousand", "million", "billion"]

    StringReplace, Number, Number, `,, , All  ; Remove commas
    if Number is not digit
        return "Invalid number"

    if (Number > 10**12-1)
        return "Number too large"

    String := "" 
    NumPeriods := Ceil(StrLen(Number) / 3)

    Loop, %NumPeriods%
    {
        Multiplier := 10**(3 * (NumPeriods - A_Index))
        Period := Floor(Number / Multiplier)
        Hundreds := Floor(Period / 100)
        Tens := Floor((Period - Hundreds * 100) / 10)
        Ones := Period - Hundreds * 100 - Tens * 10

        if Hundreds
            String .= OnesArray[Hundreds] . " hundred "

        if (Tens > 1)
        {
            String .= TensArray[Tens - 1]
            if Ones
                String .= "-" . OnesArray[Ones] . " "
        }
        else if Tens
            String .= TeensArray[Period - Hundreds * 100 - 9] . " "
        else if Ones
            String .= OnesArray[Ones] . " "

        if (Period && A_Index < NumPeriods)
            String .= ThousandsArray[NumPeriods - A_Index] . " "

        Number -= Period * Multiplier
    }

    return Trim(String)
}

; Capitalizes the first letter of a word
CapitalizeFirstLetter(word)
{
    StringUpper, first, % SubStr(word, 1, 1)
    rest := SubStr(word, 2)
    return first . rest
}

; GUI Creation and Button Actions
Gui, New, , Select Jack Type
Gui, Add, Button, gSetJackType vJumpingJacks, Jumping Jacks
Gui, Add, Button, gSetJackType vHellJacks, Hell Jacks
Gui, Add, Button, gSetJackType vGrammarJacks, Grammar Jacks
Gui, Add, Button, gSetJackType vDeathJacks, Death Jacks

; Add text with "Made by cvalsz"
Gui, Add, Text,, Made by cvalsz
Gui, Show
return

SetJackType:
GuiControlGet, jacksType, , %A_GuiControl%
Gui, Destroy  ; Close GUI after selecting

; Ask for chat prefix
InputBox, chatPrefix, Chat Prefix, What is the chat prefix?
if (chatPrefix = "")
    return

; Ask for host address
InputBox, addressedAs, Host Address, What is the host addressed as?
if (addressedAs = "")
    return

; Ask for the number of Jacks and starting number
InputBox, numJacks, How many Jacks?, How many Jacks do you want to send?
if (numJacks = "")
    return

InputBox, startNumber, Starting Number, What number do you start at?
if (startNumber = "")
    return

; Delay time settings
if (jacksType = "Jumping Jacks")
{
    InputBox, jackDelay, Delay Time, How many seconds per Jack? (e.g., 2 seconds)
    delayTime := jackDelay * 1000
}
else if (jacksType = "Hell Jacks" or jacksType = "Death Jacks")
{
    InputBox, letterDelay, Letter Delay, How many seconds per letter? (e.g., 1 second)
    letterDelay := letterDelay * 1000
    InputBox, jackDelay, Jack Delay, How many seconds for Jack? (e.g., 2 seconds)
    jackDelay := jackDelay * 1000
}
else
{
    delayTime := 2000  ; Default for Grammar Jacks
}

MsgBox, Press F1 to start the Jacks.
return

; When F1 is pressed, the jacks begin
F1::
Sleep, 3000  ; Wait before starting

Loop, % numJacks
{
    number := startNumber + A_Index - 1
    word := Number2Name(number)

    ; Determine case format
    if (jacksType = "Grammar Jacks")
    {
        word := CapitalizeFirstLetter(word) . "."  ; Capitalize first letter, add period
    }
    else
    {
        StringUpper, word, word  ; Make all uppercase for other jacks
    }

    ; Determine correct prefix format
    if (chatPrefix = "-")
        messagePrefix := "-" . word  ; Keep the dash
    else
        messagePrefix := chatPrefix . " " . word  ; Normal prefix with space

    Sleep, 300  ; 25% slower typing speed

    if (jacksType = "Jumping Jacks")
    {
        Send, % messagePrefix
        Send, {Enter}
        Sleep, 100  ; Small delay before pressing space
        Send, {Space}  ; Press Space after Enter
        Sleep, delayTime
    }
    else if (jacksType = "Hell Jacks")
    {
        Loop, Parse, word
        {
            letter := A_LoopField
            StringUpper, letter, letter
            Send, % chatPrefix " " letter
            Send, {Enter}
            Sleep, 100  ; Small delay before pressing space
            Send, {Space}  ; Press Space after Enter for each letter
            Sleep, letterDelay
        }
        Send, % chatPrefix " " word
        Send, {Enter}
        Sleep, 100  ; Small delay before pressing space
        Send, {Space}  ; Press Space after Enter
        Sleep, jackDelay
    }
    else if (jacksType = "Grammar Jacks")
    {
        Send, % chatPrefix " " word
        Send, {Enter}
        Sleep, 100  ; Small delay before pressing space
        Send, {Space}  ; Press Space after Enter
        Sleep, delayTime
    }
    else if (jacksType = "Death Jacks")
    {
        ReverseWord := ReverseString(word)
        Loop, Parse, ReverseWord
        {
            letter := A_LoopField
            StringUpper, letter, letter
            Send, % chatPrefix " " letter
            Send, {Enter}
            Sleep, 100  ; Small delay before pressing space
            Send, {Space}  ; Press Space after Enter for each letter
            Sleep, letterDelay
        }
        Send, % chatPrefix " " ReverseWord
        Send, {Enter}
        Sleep, 100  ; Small delay before pressing space
        Send, {Space}  ; Press Space after Enter
        Sleep, jackDelay
    }
}

Send, % chatPrefix " Done, " addressedAs
Send, {Enter}
Sleep, 100  ; Small delay before pressing space
Send, {Space}  ; Final jump

Sleep, 2000  ; Wait 2 seconds before showing the final GUI

; Show "Task done" GUI
Gui, New, , Task Completed
Gui, Add, Text,, Task done.
Gui, Add, Button, gExitScript, OK
Gui, Add, Text,, Made by cvalsz  ; Add "Made by cvalsz" at the bottom of the final message
Gui, Show
return

ExitScript:
Gui, Destroy
ExitApp
