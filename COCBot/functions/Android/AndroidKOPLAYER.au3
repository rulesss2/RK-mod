; #FUNCTION# ====================================================================================================================
; Name ..........: OpenKOPLAYER
; Description ...: Opens new KOPLAYER instance
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (2016-04)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenKOPLAYER($bRestart = False)

   Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdPar

   SetLog("Starting " & $Android & " and Clash Of Clans", $COLOR_GREEN)

   If Not InitAndroid() Then Return

   $launchAndroid = WinGetAndroidHandle() = 0
   If $launchAndroid Then
	  ; Launch KOPLAYER
	  $cmdPar = GetAndroidProgramParameter() & " -t " & $AndroidInstance
	  SetDebugLog("ShellExecute: " & $AndroidProgramPath & " " & $cmdPar)
	  $PID = ShellExecute($AndroidProgramPath, $cmdPar, $__KOPLAYER_Path)
	  If _Sleep(1000) Then Return
	  If $PID <> 0 Then $PID = ProcessExists($PID)
	  SetDebugLog("$PID= "&$PID)
	  If $PID = 0 Then  ; IF ShellExecute failed
		SetLog("Unable to load " & $Android & ($AndroidInstance = "" ? "" : "(" & $AndroidInstance & ")") & ", please check emulator/installation.", $COLOR_RED)
		SetLog("Unable to continue........", $COLOR_MAROON)
		btnStop()
		SetError(1, 1, -1)
		Return
	 EndIf
   EndIf

   SetLog("Please wait while " & $Android & " and CoC start...", $COLOR_GREEN)
   $hTimer = TimerInit()

   ; Test ADB is connected
   $connected_to = ConnectAndroidAdb(False, 60 * 1000)
   If Not $RunState Then Return

   If WaitForAndroidBootCompleted($AndroidLaunchWaitSec - TimerDiff($hTimer) / 1000, $hTimer) Then Return

	If TimerDiff($hTimer) >= $AndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
	  SetLog("Serious error has occurred, please restart PC and try again", $COLOR_RED)
	  SetLog($Android & " refuses to load, waited " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_RED)
	  SetError(1, @extended, False)
	  Return
	EndIf

    SetLog($Android & " Loaded, took " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_GREEN)

EndFunc   ;==>OpenKOPLAYER

Func GetKOPLAYERProgramParameter($bAlternative = False)
   If Not $bAlternative Or $AndroidInstance <> $AndroidAppConfig[$AndroidConfig][1] Then
	  ; should be launched with these parameter
	  Return "-n " & ($AndroidInstance = "" ? $AndroidAppConfig[$AndroidConfig][1] : $AndroidInstance)
   EndIf
   ; default instance gets launched as name "default" but vbox instance name is KOPLAYER (this is the alternative way)
   Return "-n default"
EndFunc

Func IsKOPLAYERCommandLine($CommandLine)
   SetDebugLog($CommandLine)
   Local $param1 = GetKOPLAYERProgramParameter()
   Local $param2 = GetKOPLAYERProgramParameter(True)
   If StringInStr($CommandLine, $param1 & " ") > 0 Or StringRight($CommandLine, StringLen($param1)) = $param1 Then Return True
   If StringInStr($CommandLine, $param2 & " ") > 0 Or StringRight($CommandLine, StringLen($param2)) = $param2 Then Return True
   Return False
EndFunc

Func GetKOPLAYERPath()
   Local $KOPLAYER_Path = RegRead($HKLM & "\SOFTWARE\KOPLAYER\SETUP\", "InstallPath")
   If $KOPLAYER_Path = "" Then ; work-a-round
	  $KOPLAYER_Path = @ProgramFilesDir & "\KOPLAYER\"
   Else
	  If StringRight($KOPLAYER_Path, 1) <> "\" Then $KOPLAYER_Path &= "\"
   EndIf
   Return $KOPLAYER_Path
EndFunc

Func GetKOPLAYERAdbPath()
   Local $adbPath = GetKOPLAYERPath() & "Tools\adb.exe"
   If FileExists($adbPath) Then Return $adbPath
   Return ""
EndFunc

Func InitKOPLAYER($bCheckOnly = False)
   Local $process_killed, $aRegExResult, $AndroidAdbDeviceHost, $AndroidAdbDevicePort, $oops = 0
   Local $KOPLAYERVersion = RegRead($HKLM & "\SOFTWARE\KOPLAYER\SETUP\", "Version")
   SetError(0, 0, 0)
   ; Could also read KOPLAYER paths from environment variables KOPLAYER_Path and KOPLAYERHyperv_Path
   Local $KOPLAYER_Path = GetKOPLAYERPath()
   Local $KOPLAYER_Manage_Path = $KOPLAYER_Path & "vbox\VBoxManage.exe"

   If FileExists($KOPLAYER_Path & "KOPLAYER.exe") = False Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find " & $Android & ":", $COLOR_RED)
		 SetLog($KOPLAYER_Path & "KOPLAYER.exe", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   If FileExists(GetKOPLAYERAdbPath()) = False Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find " & $Android & ":", $COLOR_RED)
		 SetLog($KOPLAYER_Path & "adb.exe", $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   If FileExists($KOPLAYER_Manage_Path) = False Then
	  If Not $bCheckOnly Then
		 SetLog("Serious error has occurred: Cannot find KOPLAYER-VBoxManage:", $COLOR_RED)
		 SetLog($KOPLAYER_Manage_Path, $COLOR_RED)
		 SetError(1, @extended, False)
	  EndIf
	  Return False
   EndIf

   ; Read ADB host and Port
   If Not $bCheckOnly Then
	  InitAndroidConfig(True) ; Restore default config

	  $__VBoxVMinfo = LaunchConsole($KOPLAYER_Manage_Path, "showvminfo " & $AndroidInstance, $process_killed)
	  ; check if instance is known
	  If StringInStr($__VBoxVMinfo, "Could not find a registered machine named") > 0 Then
		 ; Unknown vm
		 SetLog("Cannot find " & $Android & " instance " & $AndroidInstance, $COLOR_RED)
		 Return False
	  EndIf
	  ; update global variables
	  $AndroidProgramPath = $KOPLAYER_Path & "KOPLAYER.exe"
	  $AndroidAdbPath = FindPreferredAdbPath()
	  If $AndroidAdbPath = "" Then $AndroidAdbPath = GetKOPLAYERAdbPath()
	  $AndroidVersion = $KOPLAYERVersion
	  $__KOPLAYER_Path = $KOPLAYER_Path
	  $__VBoxManage_Path = $KOPLAYER_Manage_Path
	  $aRegExResult = StringRegExp($__VBoxVMinfo, "name = .*host ip = ([^,]*),.*guest port = 5555", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $AndroidAdbDeviceHost = $aRegExResult[0]
		 If $AndroidAdbDeviceHost = "" Then $AndroidAdbDeviceHost = "127.0.0.1"
		 If $debugSetlog = 1 Then Setlog("Func LaunchConsole: Read $AndroidAdbDeviceHost = " & $AndroidAdbDeviceHost, $COLOR_DEBUG) ;Debug
	  Else
		 $oops = 1
		 SetLog("Cannot read " & $Android & "(" & $AndroidInstance & ") ADB Device Host", $COLOR_RED)
	  EndIF

	  $aRegExResult = StringRegExp($__VBoxVMinfo, "name = .*host port = (\d{3,5}),.*guest port = 5555", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $AndroidAdbDevicePort = $aRegExResult[0]
		 If $debugSetlog = 1 Then Setlog("Func LaunchConsole: Read $AndroidAdbDevicePort = " & $AndroidAdbDevicePort, $COLOR_DEBUG) ;Debug
	  Else
		 $oops = 1
		 SetLog("Cannot read " & $Android & "(" & $AndroidInstance & ") ADB Device Port", $COLOR_RED)
	  EndIF

	  If $oops = 0 Then
		 $AndroidAdbDevice = $AndroidAdbDeviceHost & ":" & $AndroidAdbDevicePort
	  Else ; use defaults
		 SetLog("Using ADB default device " & $AndroidAdbDevice & " for " & $Android, $COLOR_RED)
	  EndIf

	  ; get screencap paths: Name: 'picture', Host path: 'C:\Users\Administrator\Pictures\KOPLAYER Photo' (machine mapping), writable
	  $AndroidPicturesPath = "/mnt/shared/UserData/"
	  $aRegExResult = StringRegExp($__VBoxVMinfo, "Name: 'UserData', Host path: '(.*)'.*", $STR_REGEXPARRAYMATCH)
	  If Not @error Then
		 $AndroidPicturesHostPath = StringReplace($aRegExResult[0], "/", "\") & "\"
	  Else
		 $AndroidAdbScreencap = False
		 $AndroidPicturesHostPath = ""
		 SetLog($Android & " Background Mode is not available", $COLOR_RED)
	  EndIf

	  $__VBoxGuestProperties = LaunchConsole($__VBoxManage_Path, "guestproperty enumerate " & $AndroidInstance, $process_killed)
   EndIf

   Return True

EndFunc

Func SetScreenKOPLAYER()

   If Not InitAndroid() Then Return False

   Local $cmdOutput, $process_killed

   ; Set width and height
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " vbox_graph_mode " & $AndroidClientWidth & "x" & $AndroidClientHeight & "-16", $process_killed)
   ; Set dpi
   $cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $AndroidInstance & " vbox_dpi 160", $process_killed)

   Return True

EndFunc

Func RebootKOPLAYERSetScreen()

   Return RebootAndroidSetScreenDefault()

EndFunc

Func CloseKOPLAYER()

	Return CloseVboxAndroidSvc()

EndFunc   ;==>CloseKOPLAYER

Func CheckScreenKOPLAYER($bSetLog = True)

   If Not InitAndroid() Then Return False

   Local $aValues[2][2] = [ _
	  ["vbox_dpi", "160"], _
	  ["vbox_graph_mode", $AndroidClientWidth & "x" & $AndroidClientHeight & "-16"] _
   ]
   Local $i, $Value, $iErrCnt = 0, $process_killed, $aRegExResult

   For $i = 0 To UBound($aValues) -1
	  $aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: " & $aValues[$i][0] & ", value: (.+), timestamp:", $STR_REGEXPARRAYMATCH)
	  If @error = 0 Then $Value = $aRegExResult[0]
	  If $Value <> $aValues[$i][1] Then
		 If $iErrCnt = 0 Then
			If $bSetLog Then
			   SetLog("MyBot doesn't work with " & $Android & " screen configuration!", $COLOR_RED)
			Else
			   SetDebugLog("MyBot doesn't work with " & $Android & " screen configuration!", $COLOR_RED)
			EndIf
		 EndIf
		 If $bSetLog Then
			SetLog("Setting of " & $aValues[$i][0] & " is " & $Value & " and will be changed to " & $aValues[$i][1], $COLOR_RED)
		 Else
			SetDebugLog("Setting of " & $aValues[$i][0] & " is " & $Value & " and will be changed to " & $aValues[$i][1], $COLOR_RED)
		 EndIf
		 $iErrCnt += 1
	  EndIf
   Next
   If $iErrCnt > 0 Then Return False
   Return True

EndFunc

Func EmbedKOPLAYER($bEmbed = Default)

	If $bEmbed = Default Then $bEmbed = $AndroidEmbedded

	; Find Qt5QWindowToolSaveBits Window
	Local $aWin = _WinAPI_EnumProcessWindows(GetAndroidPid(), False)
	Local $i
	Local $hTool = 0

	For $i = 1 To UBound($aWin) - 1
		Local $h = $aWin[$i][0]
		Local $c = $aWin[$i][1]
		If $c = "Qt5QWindowToolSaveBits" Then
			$hTool = $h
			ExitLoop
		EndIf
	Next

	If $hTool = 0 Then
		SetDebugLog("EmbedKOPLAYER(" & $bEmbed & "): Qt5QWindowToolSaveBits Window not found, list of windows:" & $c, Default, True)
		For $i = 1 To UBound($aWin) - 1
			Local $h = $aWin[$i][0]
			Local $c = $aWin[$i][1]
			SetDebugLog("EmbedKOPLAYER(" & $bEmbed & "): Handle = " & $h & ", Class = " & $c, Default, True)
		Next
	Else
		SetDebugLog("EmbedKOPLAYER(" & $bEmbed & "): $hTool=" & $hTool, Default, True)
		WinMove2($hTool, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
		_WinAPI_ShowWindow($hTool, ($bEmbed ? @SW_HIDE : @SW_SHOWNOACTIVATE))
	EndIf

EndFunc   ;==>EmbedLeapDroid