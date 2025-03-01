# JJsBotMacroPublicVer
Automatically does jumping jacks for you.

Prerequisites:
https://www.autohotkey.com **AHK V2**

## INSTALLATION

First, get the AutoHotKey V2. You can find the link above in the prerequisites area. Then, create a .txt file, paste the code below in, and save it as JJBot.ahk and run it.

**CODE**
url := "https://raw.githubusercontent.com/cvalsz/JJsBotMacroPublicVer/refs/heads/main/AHK%20v2%20JJsBotPublicVer.ahk"
tempFile := A_Temp "\temp_script.ahk"

UrlDownloadToFile, %url%, %tempFile%

Run, %tempFile%

FileDelete, %tempFile%
