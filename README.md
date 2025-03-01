# JJsBotMacroPublicVer
Automatically does jumping jacks for you.

Prerequisites:
https://www.autohotkey.com **AHK V2**


**CODE**
url := "https://raw.githubusercontent.com/cvalsz/JJsBotMacroPublicVer/refs/heads/main/AHK%20v2%20JJsBotPublicVer.ahk"
tempFile := A_Temp "\temp_script.ahk"

UrlDownloadToFile, %url%, %tempFile%

Run, %tempFile%

FileDelete, %tempFile%
