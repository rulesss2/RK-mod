; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), KnowJack(July 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func Initiate()
	WinGetAndroidHandle()
	If $HWnD <> 0 And ($AndroidBackgroundLaunched = True Or AndroidControlAvailable()) Then
		SetLog(_PadStringCenter(" " & $sBotTitle & " Powered by MyBot.run ", 50, "~"), $COLOR_DEBUG) ;Debug
		SetLog($Compiled & " running on " & @OSVersion & " " & @OSServicePack & " " & @OSArch)
		If Not $bSearchMode Then
			SetLog(_PadStringCenter(" Bot Start ", 50, "="), $COLOR_GREEN)
		Else
			SetLog(_PadStringCenter(" Search Mode Start ", 50, "="), $COLOR_GREEN)
		EndIf
		SetLog(_PadStringCenter("  Current Profile: " & $sCurrProfile & " ", 73, "-"), $COLOR_BLUE)
		If $DebugSetlog = 1 Or $DebugOcr = 1 Or $debugRedArea = 1 Or $DevMode = 1 Or $debugImageSave = 1 Or $debugBuildingPos = 1 Or $debugOCRdonate = 1 Then
			SetLog(_PadStringCenter(" Warning Debug Mode Enabled! Setlog: " & $DebugSetlog & " OCR: " & $DebugOcr & " RedArea: " & $debugRedArea & " ImageSave: " & $debugImageSave & " BuildingPos: " & $debugBuildingPos & " OCRDonate: " & $debugOCRdonate, 55, "-"), $COLOR_DEBUG) ;Debug
		EndIf

		$AttackNow = False
		$FirstStart = True
		$Checkrearm = True

		If $NotifyDeleteAllPushesOnStart = 1 Then _DeletePush()

		If Not $bSearchMode Then
			$sTimer = TimerInit()
		EndIf

		AndroidBotStartEvent() ; signal android that bot is now running
		If Not $RunState Then Return

		;		$RunState = True

		If Not $bSearchMode Then
			;AdlibRegister("SetTime", 1000)
			If $restarted = 1 Then
				$restarted = 0
				IniWrite($config, "general", "Restarted", 0)
				PushMsg("Restarted")
			EndIf
		EndIf
		If Not $RunState Then Return

		AndroidShield("Initiate", True)
		checkMainScreen()
		If Not $RunState Then Return

		ZoomOut()

		If $ichkSwitchAcc = 1 Then ; SwitchAcc - Demen
		   InitiateSwitchAcc()
		EndIf

		If Not $RunState Then Return

		If Not $bSearchMode Then
			BotDetectFirstTime()
			If Not $RunState Then Return

			If $ichklanguageFirst = 0 And $ichklanguage = 1 Then $ichklanguageFirst = TestLanguage()
			If Not $RunState Then Return

			runBot()
		EndIf
	Else
		SetLog("Not in Game!", $COLOR_RED)
		;		$RunState = True
		btnStop()
	EndIf
EndFunc   ;==>Initiate

Func InitiateLayout()

	Local $AdjustScreenIfNecessarry = True
	WinGetAndroidHandle()
	Local $BSsize = getAndroidPos()

	If IsArray($BSsize) Then ; Is Android Client Control available?

		Local $BSx = $BSsize[2]
		Local $BSy = $BSsize[3]

		SetDebugLog("InitiateLayout: " & $title & " Android-ClientSize: " & $BSx & " x " & $BSy, $COLOR_BLUE)

		If Not CheckScreenAndroid($BSx, $BSy) Then ; Is Client size now correct?
			If $AdjustScreenIfNecessarry = True Then
				Local $MsgRet = $IDOK
				;If _Sleep(3000) Then Return False
				;Local $MsgRet = MsgBox(BitOR($MB_OKCANCEL, $MB_SYSTEMMODAL), "Change the resolution and restart " & $Android & "?", _
				;	"Click OK to adjust the screen size of " & $Android & " and restart the emulator." & @CRLF & _
				;	"If your " & $Android & " really has the correct size (" & $DEFAULT_WIDTH & " x " & $DEFAULT_HEIGHT & "), click CANCEL." & @CRLF & _
				;	"(Automatically Cancel in 15 Seconds)", 15)

				If $MsgRet = $IDOK Then
					Return RebootAndroidSetScreen() ; recursive call!
					;Return "RebootAndroidSetScreen()"
				EndIf
			Else
				SetLog("Cannot use " & $Android & ".", $COLOR_RED)
				SetLog("Please set its screen size manually to " & $AndroidClientWidth & " x " & $AndroidClientHeight, $COLOR_RED)
				btnStop()
				Return False
			EndIf
		EndIf

		DisposeWindows()
		Return True

	EndIf

	Return False

EndFunc   ;==>InitiateLayout

Func chkBackground()
	If GUICtrlRead($chkBackground) = $GUI_CHECKED Then
		$ichkBackground = 1
		updateBtnHideState($GUI_ENABLE)
	Else
		$ichkBackground = 0
		updateBtnHideState($GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBackground

Func IsStopped()
	If $RunState Then Return False
	If $Restart Then Return True
	Return False
EndFunc   ;==>IsStopped

Func btnStart()
	; decide when to run
	EnableControls($frmBotBottom, False, $frmBotBottomCtrlState)
	Local $RunNow = $BotAction <> $eBotNoAction
	If $RunNow Then
		BotStart()
	Else
		$BotAction = $eBotStart
	EndIf
	$iGUIEnabled = False
EndFunc   ;==>btnStart

Func btnStop()
	If $RunState Then
		; always invoked in MyBot.run.au3!
		EnableControls($frmBotBottom, False, $frmBotBottomCtrlState)
		$RunState = False ; Exit BotStart()
		$BotAction = $eBotStop
	EndIf
	$iGUIEnabled = True
EndFunc   ;==>btnStop

Func btnSearchMode()
	; decide when to run
	EnableControls($frmBotBottom, False, $frmBotBottomCtrlState)
	Local $RunNow = $BotAction <> $eBotNoAction
	If $RunNow Then
		BotSearchMode()
	Else
		$BotAction = $eBotSearchMode
	EndIf
EndFunc   ;==>btnSearchMode

Func btnPause($RunNow = True)
	;Send("{PAUSE}")
	TogglePause()
EndFunc   ;==>btnPause

Func btnResume()
	;Send("{PAUSE}")
	TogglePause()
EndFunc   ;==>btnResume

Func btnAttackNowDB()
	If $RunState Then
		$bBtnAttackNowPressed = True
		$iMatchMode = $DB
	EndIf
EndFunc   ;==>btnAttackNowDB

Func btnAttackNowLB()
	If $RunState Then
		$bBtnAttackNowPressed = True
		$iMatchMode = $LB
	EndIf
EndFunc   ;==>btnAttackNowLB

Func btnAttackNowTS()
	If $RunState Then
		$bBtnAttackNowPressed = True
		$iMatchMode = $TS
	EndIf
EndFunc   ;==>btnAttackNowTS

;~ Hide Android Window again without overwriting $botPos[0] and [1]
Func reHide()
	WinGetAndroidHandle()
	If $Hide = True And $HWnD <> 0 And $AndroidEmbedded = False Then
		SetDebugLog("Hide " & $Android & " Window after restart")
		Return WinMove2($HWnD, "", -32000, -32000)
	EndIf
	Return 0
EndFunc   ;==>reHide

Func updateBtnHideState($newState = $GUI_ENABLE)
	Local $hideState = GUICtrlGetState($btnHide)
	Local $newHideState = ($AndroidEmbedded = True ? $GUI_DISABLE : $newState)
	If $hideState <> $newHideState Then GUICtrlSetState($btnHide, $newHideState)
EndFunc   ;==>updateBtnHideState

Func btnHide()
	ResumeAndroid()
	WinGetAndroidHandle() ; updates android position
	WinGetPos($HWnD)
	If @error <> 0 Then Return SetError(0, 0, 0)

	If $Hide = False Then
		GUICtrlSetData($btnHide, GetTranslated(602, 26, "Show"))
		Local $a = WinGetPos($HWnD)
		WinMove2($HWnD, "", -32000, -32000)
		$Hide = True
	Else
		GUICtrlSetData($btnHide, GetTranslated(602, 11, "Hide"))

		WinMove2($HWnD, "", $AndroidPosX, $AndroidPosY)
		WinActivate($HWnD)
		$Hide = False
	EndIf
EndFunc   ;==>btnHide

Func updateBtnEmbed()
	If IsDeclared("btnEmbed") = $DECLARED_UNKNOWN Then Return False
	UpdateFrmBotStyle()
	Local $state = GUICtrlGetState($btnEmbed)
	If $HWnD = 0 Or $AndroidBackgroundLaunched = True Or $AndroidEmbed = False Then
		If $state <> $GUI_DISABLE Then GUICtrlSetState($btnEmbed, $GUI_DISABLE)
		Return False
	EndIf

	Local $text = GUICtrlRead($btnEmbed)
	Local $newText
	If $AndroidEmbedded = True Then
		$newText = GetTranslated(602, 28, "Undock")
	Else
		$newText = GetTranslated(602, 27, "Dock")
	EndIf
	If $text <> $newText Then GUICtrlSetData($btnEmbed, $newText)
	If $state <> $GUI_ENABLE Then GUICtrlSetState($btnEmbed, $GUI_ENABLE)
	; also update hide button
	updateBtnHideState()
	Return True
EndFunc   ;==>updateBtnEmbed

Func btnEmbed()
	ResumeAndroid()
	WinGetAndroidHandle()
	WinGetPos($HWnD)
	If @error <> 0 Then Return SetError(0, 0, 0)
	AndroidEmbed(Not $AndroidEmbedded)
EndFunc   ;==>btnEmbed

Func btnMakeScreenshot()
	If $RunState Then $iMakeScreenshotNow = True
EndFunc   ;==>btnMakeScreenshot

Func GetFont()
	Local $i, $sText = "", $DefaultFont
	$DefaultFont = __EMB_GetDefaultFont()
	For $i = 0 To UBound($DefaultFont) - 1
		$sText &= " $DefaultFont[" & $i & "]= " & $DefaultFont[$i] & ", "
	Next
	Setlog($sText, $COLOR_DEBUG) ;Debug
EndFunc   ;==>GetFont

Func btnAnalyzeVillage()
	$debugBuildingPos = 1
	$debugDeadBaseImage = 1
	SETLOG("DEADBASE CHECK..................")
	$dbBase = checkDeadBase()
	SETLOG("TOWNHALL CHECK..................")
	$searchTH = townHallCheck(True)
	SETLOG("MINE CHECK C#...................")
	$PixelMine = GetLocationMine()
	SetLog("[" & UBound($PixelMine) & "] Gold Mines")
	SETLOG("ELIXIR CHECK C#.................")
	$PixelElixir = GetLocationElixir()
	SetLog("[" & UBound($PixelElixir) & "] Elixir Collectors")
	SETLOG("DARK ELIXIR CHECK C#............")
	$PixelDarkElixir = GetLocationDarkElixir()
	SetLog("[" & UBound($PixelDarkElixir) & "] Dark Elixir Drill/s")
	SETLOG("DARK ELIXIR STORAGE CHECK C#....")
	$BuildingToLoc = GetLocationDarkElixirStorage
	SetLog("[" & UBound($BuildingToLoc) & "] Dark Elixir Storage")
	For $i = 0 To UBound($BuildingToLoc) - 1
		$pixel = $BuildingToLoc[$i]
		If $DebugSetlog = 1 Then SetLog("- Dark Elixir Storage " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_DEBUG) ;Debug
	Next
	SETLOG("LOCATE BARRACKS C#..............")
	Local $PixelBarrackHere = GetLocationItem("getLocationBarrack")
	SetLog("Total No. of Barracks: " & UBound($PixelBarrackHere), $COLOR_DEBUG) ;Debug
	For $i = 0 To UBound($PixelBarrackHere) - 1
		$pixel = $PixelBarrackHere[$i]
		If $DebugSetlog = 1 Then SetLog("- Barrack " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_DEBUG) ;Debug
	Next
	SETLOG("LOCATE BARRACKS C#..............")
	Local $PixelDarkBarrackHere = GetLocationItem("getLocationDarkBarrack")
	SetLog("Total No. of Dark Barracks: " & UBound($PixelBarrackHere), $COLOR_DEBUG) ;Debug
	For $i = 0 To UBound($PixelDarkBarrackHere) - 1
		$pixel = $PixelDarkBarrackHere[$i]
		If $DebugSetlog = 1 Then SetLog("- Dark Barrack " & $i + 1 & ": (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_DEBUG) ;Debug
	Next
	SetLog("WEAK BASE C#.....................", $COLOR_TEAL)
	; Weak Base Detection modified by LunaEclipse
	Local $weakBaseValues
	If IsWeakBaseActive($DB) Or IsWeakBaseActive($LB) Then
		$weakBaseValues = IsWeakBase()
	EndIf
	For $i = 0 To $iModeCount - 2
		If IsWeakBaseActive($i) Then
			If getIsWeak($weakBaseValues, $i) Then
				SetLog(StringUpper($sModeText[$i]) & " IS A WEAK BASE: TRUE", $COLOR_DEBUG) ;Debug
			Else
				SetLog(StringUpper($sModeText[$i]) & " IS A WEAK BASE: FALSE", $COLOR_DEBUG) ;Debug
			EndIf

			SetLog("Time taken: " & $weakBaseValues[5][0] & " " & $weakBaseValues[5][1], $COLOR_DEBUG) ;Debug
		EndIf
	Next
	Setlog("--------------------------------------------------------------", $COLOR_TEAL)
	$debugBuildingPos = 0
	$debugDeadBaseImage = 0
EndFunc   ;==>btnAnalyzeVillage

Func btnVillageStat()
	GUICtrlSetState($lblVillageReportTemp, $GUI_HIDE)

	If GUICtrlGetState($lblResultGoldNow) = $GUI_ENABLE + $GUI_SHOW Then
		;hide normal values
		GUICtrlSetState($lblResultGoldNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultElixirNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultDENow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultGemNow, $GUI_ENABLE + $GUI_HIDE)
		;show stats values
		GUICtrlSetState($lblResultGoldHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultElixirHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultDEHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultRuntimeNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultAttackedHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultSkippedHourNow, $GUI_ENABLE + $GUI_SHOW)
		; hide normal pics
		GUICtrlSetState($picResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($picResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($picResultGemNow, $GUI_ENABLE + $GUI_HIDE)
		;show stats pics
		GUICtrlSetState($picResultRuntimeNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($picResultAttackedHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($picResultSkippedHourNow, $GUI_ENABLE + $GUI_SHOW)
	Else
		;show normal values
		GUICtrlSetState($lblResultGoldNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultElixirNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultDENow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultTrophyNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultBuilderNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($lblResultGemNow, $GUI_ENABLE + $GUI_SHOW)
		;hide stats values
		GUICtrlSetState($lblResultGoldHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultElixirHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultDEHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultRuntimeNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultAttackedHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($lblResultSkippedHourNow, $GUI_ENABLE + $GUI_HIDE)
		; show normal pics
		GUICtrlSetState($picResultTrophyNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($picResultBuilderNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($picResultGemNow, $GUI_ENABLE + $GUI_SHOW)
		;hide stats pics
		GUICtrlSetState($picResultRuntimeNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($picResultAttackedHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($picResultSkippedHourNow, $GUI_ENABLE + $GUI_HIDE)
	EndIf

EndFunc   ;==>btnVillageStat

Func btnTestDeadBase()
	Local $test = 0
	;LoadTHImage()
	LoadElixirImage()
	LoadElixirImage75Percent()
	LoadElixirImage50Percent()
	Zoomout()
	If $debugBuildingPos = 0 Then
		$test = 1
		$debugBuildingPos = 1
	EndIf
	SETLOG("DEADBASE CHECK..................")
	$dbBase = checkDeadBase()
	SETLOG("TOWNHALL CHECK..................")
	$searchTH = townHallCheck(True)
	If $test = 1 Then $debugBuildingPos = 0
EndFunc   ;==>btnTestDeadBase

Func btnTestDonate()
	$RunState = True
	SETLOG("DONATE TEST..................START")
	ZoomOut()
	saveconfig()
	readconfig()
	applyconfig()
	DonateCC()
	SETLOG("DONATE TEST..................STOP")
	$RunState = False
EndFunc   ;==>btnTestDonate

Func btnTestButtons()

	$RunState = True
	Local $ButtonX, $ButtonY
	Local $hTimer = TimerInit()
	Local $res
	Local $ImagesToUse[3]
	$ImagesToUse[0] = @ScriptDir & "\images\Button\Traps.png"
	$ImagesToUse[1] = @ScriptDir & "\images\Button\Xbow.png"
	$ImagesToUse[2] = @ScriptDir & "\images\Button\Inferno.png"
	Local $x = 1
	Local $y = 1
	Local $w = 615
	Local $h = 105

	$ToleranceImgLoc = 0.950

	SETLOG("SearchTile TEST..................START")
	;;;;;; Use the Polygon to a rectangle or Square search zone ;;;;;;;;;;
	$SearchArea = String($x & "|" & $y & "|" & $w & "|" & $h) ; x|y|Width|Height
	; form a polygon " top(x,y) | Right (w,y) | Bottom(w,h) | Left(x,h) "
	Local $AreaInRectangle = String($x + 1 & "," & $y + 1 & "|" & $w - 1 & "," & $y + 1 & "|" & $w - 1 & "," & $h - 1 & "|" & $x + 1 & "," & $h - 1)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	_CaptureRegion(125, 610, 740, 715)
	For $i = 0 To 2
		If FileExists($ImagesToUse[$i]) Then
			$res = DllCall($pImgLib, "str", "SearchTile", "handle", $hHBitmap2, "str", $ImagesToUse[$i], "float", $ToleranceImgLoc, "str", $SearchArea, "str", $AreaInRectangle)
			If @error Then _logErrorDLLCall($pImgLib, @error)
			If IsArray($res) Then
				If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_DEBUG) ;Debug
				If $res[0] = "0" Then
					; failed to find a loot cart on the field
					SetLog("No Button found")
				ElseIf $res[0] = "-1" Then
					SetLog("DLL Error", $COLOR_RED)
				ElseIf $res[0] = "-2" Then
					SetLog("Invalid Resolution", $COLOR_RED)
				Else
					$expRet = StringSplit($res[0], "|", 2)
					$ButtonX = 125 + Int($expRet[1])
					$ButtonY = 610 + Int($expRet[2])
					SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_GREEN)
					;If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
					If _Sleep(200) Then Return
					;Click(515, 400, 1, 0, "#0226")
					If _Sleep(200) Then Return
					If isGemOpen(True) = True Then
						Setlog("Not enough loot to rearm traps.....", $COLOR_RED)
						Click(585, 252, 1, 0, "#0227") ; Click close gem window "X"
						If _Sleep(200) Then Return
					Else
						If $i = 0 Then SetLog("Rearmed Trap(s)", $COLOR_GREEN)
						If $i = 1 Then SetLog("Reloaded XBow(s)", $COLOR_GREEN)
						If $i = 2 Then SetLog("Reloaded Inferno(s)", $COLOR_GREEN)
						If _Sleep(200) Then Return
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
	SETLOG("SearchTile TEST..................STOP")

	Local $hTimer = TimerInit()
	SETLOG("MBRSearchImage TEST..................STOP")

	For $i = 0 To 2
		If FileExists($ImagesToUse[$i]) Then
			_CaptureRegion2(125, 610, 740, 715)
			$res = DllCall($pImgLib, "str", "MBRSearchImage", "handle", $hHBitmap2, "str", $ImagesToUse[$i], "float", $ToleranceImgLoc)
			If @error Then _logErrorDLLCall($pImgLib, @error)
			If IsArray($res) Then
				If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_DEBUG) ;Debug
				If $res[0] = "0" Then
					; failed to find a loot cart on the field
					SetLog("No Button found")
				ElseIf $res[0] = "-1" Then
					SetLog("DLL Error", $COLOR_RED)
				ElseIf $res[0] = "-2" Then
					SetLog("Invalid Resolution", $COLOR_RED)
				Else
					$expRet = StringSplit($res[0], "|", 2)
					$ButtonX = 125 + Int($expRet[1])
					$ButtonY = 610 + Int($expRet[2])
					SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_GREEN)
					;If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
					If _Sleep(200) Then Return
					;Click(515, 400, 1, 0, "#0226")
					If _Sleep(200) Then Return
					If isGemOpen(True) = True Then
						Setlog("Not enough loot to rearm traps.....", $COLOR_RED)
						Click(585, 252, 1, 0, "#0227") ; Click close gem window "X"
						If _Sleep(200) Then Return
					Else
						If $i = 0 Then SetLog("Rearmed Trap(s)", $COLOR_GREEN)
						If $i = 1 Then SetLog("Reloaded XBow(s)", $COLOR_GREEN)
						If $i = 2 Then SetLog("Reloaded Inferno(s)", $COLOR_GREEN)
						If _Sleep(200) Then Return
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
	SETLOG("MBRSearchImage TEST..................STOP")
	$RunState = False

EndFunc   ;==>btnTestButtons

Func btnDBCheck()
	SetLog("Func btnDBCheck", $COLOR_DEBUG) ;Debug
	Local $oDebugBuildingPos = $debugBuildingPos
	$debugBuildingPos = 1
	checkDeadBase()
	$debugBuildingPos = $oDebugBuildingPos
	SetLog("EndFunc btnDBCheck", $COLOR_DEBUG) ;Debug
EndFunc   ;==>btnDBCheck

Func ButtonBoost()

	$RunState = True
	Local $ButtonX, $ButtonY
	Local $hTimer = TimerInit()
	Local $res
	Local $ImagesToUse[2]
	$ImagesToUse[0] = @ScriptDir & "\images\Button\BoostBarrack.png"
	$ImagesToUse[1] = @ScriptDir & "\images\Button\BarrackBoosted.png"
	$ToleranceImgLoc = 0.90
	SETLOG("MBRSearchImage TEST..................STARTED")
	_CaptureRegion2(125, 610, 740, 715)
	For $i = 0 To 1
		If FileExists($ImagesToUse[$i]) Then
			$res = DllCall($pImgLib, "str", "MBRSearchImage", "handle", $hHBitmap2, "str", $ImagesToUse[$i], "float", $ToleranceImgLoc)
			If @error Then _logErrorDLLCall($pImgLib, @error)
			If IsArray($res) Then
				If $DebugSetlog = 1 Then SetLog("DLL Call succeeded " & $res[0], $COLOR_DEBUG) ;Debug
				If $res[0] = "0" Then
					; failed to find a loot cart on the field
					If $i = 1 Then SetLog("No Button found")
				ElseIf $res[0] = "-1" Then
					SetLog("DLL Error", $COLOR_RED)
				ElseIf $res[0] = "-2" Then
					SetLog("Invalid Resolution", $COLOR_RED)
				Else
					If _Sleep(200) Then Return
					If $i = 0 Then
						SetLog("Found the Button to Boost individual")
						$expRet = StringSplit($res[0], "|", 2)
						$ButtonX = 125 + Int($expRet[1])
						$ButtonY = 610 + Int($expRet[2])
						SetLog("found (" & $ButtonX & "," & $ButtonY & ")", $COLOR_GREEN)
						;If IsMainPage() Then Click($ButtonX, $ButtonY, 1, 0, "#0330")
						ExitLoop
					Else
						SetLog("The Barrack is already boosted!")
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	SetLog("  - Calculated  in: " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds ", $COLOR_TEAL)
	SETLOG("MBRSearchImage TEST..................STOP")
	$RunState = False

EndFunc   ;==>ButtonBoost

Func btnEagle()

	Local $PixelEaglePos[2]
	Local $colorVariation = 40
	Local $xSkip = 1
	Local $ySkip = 5

	$hTimer = TimerInit()

	Local $directory = @ScriptDir & "\images\WeakBase\Eagle"
	Local $return = returnHighestLevelSingleMatch($directory)
	Local $NotdetectedEagle = True
	Setlog(" »» Ubound ROW $return: " & UBound($return, $UBOUND_ROWS))
	Setlog(" »» Ubound COLUMNS $return: " & UBound($return, $UBOUND_COLUMNS))
	Setlog(" »» Ubound DIMENSIONS $return: " & UBound($return, $UBOUND_DIMENSIONS))

	Local $result = DllCall($hFuncLib, "str", "getRedArea", "ptr", $hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation)

	If UBound($return) > 0 Then
		Setlog(" »» Image: " & $return[0])
		Setlog(" »» Build: " & $return[1])
		Setlog(" »» Level: " & $return[2])
		Local $EaglePosition = $return[5]
		Setlog(" »» $EaglePosition[0] X: " & $EaglePosition[0][0])
		Setlog(" »» $EaglePosition[1] Y: " & $EaglePosition[0][1])
		Setlog(" »» Ubound ROW $EaglePosition: " & UBound($EaglePosition, $UBOUND_ROWS))
		Setlog(" »» Ubound COLUMNS $EaglePosition: " & UBound($EaglePosition, $UBOUND_COLUMNS))
		Setlog(" »» Ubound DIMENSIONS $EaglePosition: " & UBound($EaglePosition, $UBOUND_DIMENSIONS))
		Setlog(" »» REDlines Imgloc: " & $return[6])
		Setlog(" »» REDlines MBRFunction: " & $result[0])

		Local $AllPoints = StringSplit($return[6], "|", $STR_NOCOUNT)
		Dim $EachPoint[UBound($AllPoints)][2]
		Local $PixelTopLeft, $PixelBottomLeft, $PixelBottomRight, $PixelTopRight

		For $i = 0 To UBound($AllPoints) - 1
			Local $temp = StringSplit($AllPoints[$i], ",", $STR_NOCOUNT)
			$EachPoint[$i][0] = Number($temp[0])
			$EachPoint[$i][1] = Number($temp[1])
			Setlog(" $EachPoint[0]: " & $EachPoint[$i][0] & " | $EachPoint[1]: " & $EachPoint[$i][1])
		Next

		_ArraySort($EachPoint, 0, 0, 0, 0)

		For $i = 0 To UBound($EachPoint) - 1

			If $EachPoint[$i][0] > 0 And $EachPoint[$i][0] < 430 And $EachPoint[$i][1] > 0 And $EachPoint[$i][1] < 338 Then

				$PixelTopLeft &= String("|" & $EachPoint[$i][0] & "-" & $EachPoint[$i][1])

			ElseIf $EachPoint[$i][0] > 0 And $EachPoint[$i][0] < 430 And $EachPoint[$i][1] > 338 And $EachPoint[$i][1] < 650 Then

				$PixelBottomLeft &= String("|" & $EachPoint[$i][0] & "-" & $EachPoint[$i][1])

			ElseIf $EachPoint[$i][0] > 430 And $EachPoint[$i][0] < 840 And $EachPoint[$i][1] > 338 And $EachPoint[$i][1] < 650 Then

				$PixelBottomRight &= String("|" & $EachPoint[$i][0] & "-" & $EachPoint[$i][1])

			ElseIf $EachPoint[$i][0] > 430 And $EachPoint[$i][0] < 840 And $EachPoint[$i][1] > 0 And $EachPoint[$i][1] < 338 Then

				$PixelTopRight &= String("|" & $EachPoint[$i][0] & "-" & $EachPoint[$i][1])
			EndIf

		Next

		If Not StringIsSpace($PixelTopLeft) Then $PixelTopLeft = StringTrimLeft($PixelTopLeft, 1)
		If Not StringIsSpace($PixelBottomLeft) Then $PixelBottomLeft = StringTrimLeft($PixelBottomLeft, 1)
		If Not StringIsSpace($PixelBottomRight) Then $PixelBottomRight = StringTrimLeft($PixelBottomRight, 1)
		If Not StringIsSpace($PixelTopRight) Then $PixelTopRight = StringTrimLeft($PixelTopRight, 1)

		Local $NewRedLineString = $PixelTopLeft & "#" & $PixelBottomLeft & "#" & $PixelBottomRight & "#" & $PixelTopRight

		Setlog(" »» NEW REDlines Imgloc: " & $NewRedLineString)

		If $EaglePosition[0][0] <> "" Then
			$PixelEaglePos[0] = $EaglePosition[0][0]
			$PixelEaglePos[1] = $EaglePosition[0][1]
			Setlog(" »» Eagle located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds")
			Switch StringLeft(Slice8($PixelEaglePos), 1)
				Case 1, 2
					$MAINSIDE = "BOTTOM-RIGHT"
				Case 3, 4
					$MAINSIDE = "TOP-RIGHT"
				Case 5, 6
					$MAINSIDE = "TOP-LEFT"
				Case 7, 8
					$MAINSIDE = "BOTTOM-LEFT"
			EndSwitch
			Setlog(" » Eagle located : " & $MAINSIDE, $COLOR_BLUE)
			$NotdetectedEagle = False
		Else
			Setlog("> Eagle not detected!", $COLOR_BLUE)
			DebugImageSave("EagleDetection_NotDetected_", True)
		EndIf
	Else
		Setlog("> Eagle not detected!", $COLOR_BLUE)
		DebugImageSave("EagleDetection_NotPresent_", True)
	EndIf

EndFunc   ;==>btnEagle

Func btnDropRSpell()
	$oldDebugSetlog = $DebugSetlog
	$oldRunState = $RunState
	Local $debugDropSCommand
	Local $oldDropSDebug = $debugDropSCommand

	$debugDropSCommand = 1
	$DebugSetlog = 1
	$iMatchMode = $LB ; Select Live Base As Attack Type
	$iAtkAlgorithm[$LB] = 1 ; Select Scripted Attack
	$scmbABScriptName = "Test DropS Command" ; Select Scripted Attack File From The Combo Box, Cos it wasn't refreshing until pressing Start button
	$iMatchMode = 1 ; Select Live Base As Attack Type
	$RunState = True
	PrepareAttack($iMatchMode)
	Attack() ; Fire xD
	$RunState = $oldRunState
	$DebugSetlog = $oldDebugSetlog
	$debugDropSCommand = $oldDropSDebug
EndFunc   ;==>btnDropRSpell

Func btnNEWRedLineDetection()

	$RunState = True

	$hTimer = TimerInit()
;~ 	_CaptureRegion2()
;~ 	Local $GetRed = DllCall($hFuncRedLib, "str", "getRedArea", "ptr", $hHBitmap2, "int", 1, "int", 5, "int", 57) ;GetImgLoc2MBR()
;~ 	Setlog("$GetRed: " & UBound($GetRed) )
;~ 	Setlog(" »» getRedArea located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds")
;~ 	Setlog("Get Red Area : " & $GetRed[0])
;~ 	Local $listPixelBySide = StringSplit($GetRed[0], "#", 2)
;~ 	Local $1 = StringSplit($listPixelBySide[0], "|", 2)
;~ 	Local $2 = StringSplit($listPixelBySide[1], "|", 2)
;~ 	Local $3 = StringSplit($listPixelBySide[2], "|", 2)
;~ 	Local $4 = StringSplit($listPixelBySide[3], "|", 2)
;~ 	Setlog("Sides: " & UBound($listPixelBySide))
;~ 	Setlog("Side TopLeft: " & UBound($1) & " Pixels")
;~ 	Setlog("Side BottomLeft: " & UBound($2) & " Pixels")
;~ 	Setlog("Side BottomRight: " & UBound($3) & " Pixels")
;~ 	Setlog("Side TopRigh: " & UBound($4) & " Pixels")

;~ 	_CaptureRegion()

;~ 	; Store a copy of the image handle
;~ 	Local $editedImage = $hBitmap
;~ 	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
;~ 	Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED
;~ 	Local $hPenBlue = _GDIPlus_PenCreate(0xFF0000ff, 2) ; Create a pencil Color FF0000/RED
;~ 	Local $subDirectory = @ScriptDir & "\TestsImages"
;~ 	DirCreate($subDirectory)
;~ 	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
;~ 	Local $Time = @HOUR & "." & @MIN & "." & @SEC
;~ 	Local $fileName = String($Date & "_" & $Time &"_.png")

;~ 	Setlog("Pixels 1")
;~ 	For $i = 0 To UBound($1) - 1
;~ 		Local $temp = StringSplit($1[$i], "-", 2)
;~ 		If UBound($temp) > 1 Then
;~ 			_GDIPlus_GraphicsDrawRect($hGraphic, $temp[0] - 2, $temp[1] - 2, 4, 4, $hPenRED)
;~ 		EndIf
;~ 	Next
;~ 	For $i = 0 To UBound($2) - 1
;~ 		Local $temp = StringSplit($2[$i], "-", 2)
;~ 		If UBound($temp) > 1 Then
;~ 			_GDIPlus_GraphicsDrawRect($hGraphic, $temp[0] - 2, $temp[1] - 2, 4, 4, $hPenRED)
;~ 		EndIf
;~ 	Next
;~ 	For $i = 0 To UBound($3) - 1
;~ 		Local $temp = StringSplit($3[$i], "-", 2)
;~ 		If UBound($temp) > 1 Then
;~ 			_GDIPlus_GraphicsDrawRect($hGraphic, $temp[0] - 2, $temp[1] - 2, 4, 4, $hPenRED)
;~ 		EndIf
;~ 	Next
;~ 	For $i = 0 To UBound($4) - 1
;~ 		Local $temp = StringSplit($4[$i], "-", 2)
;~ 		If UBound($temp) > 1 Then
;~ 			_GDIPlus_GraphicsDrawRect($hGraphic, $temp[0] - 2, $temp[1] - 2, 4, 4, $hPenRED)
;~ 		EndIf
;~ 	Next

;~ 	Setlog("Pixels 3")
;~ 	_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $fileName)
;~ 	_GDIPlus_PenDispose($hPenRED)
;~ 	_GDIPlus_PenDispose($hPenBlue)
;~ 	_GDIPlus_GraphicsDispose($hGraphic)


	$DebugOcr = 1
	$debugImageSave = 1

	Local $result = AttackBarCheck()
	Local $plural = 0

	Local $aTroopDataList = StringSplit($result, "|" , $STR_NOCOUNT)
	Local $aTemp[Ubound($aTroopDataList)][3]
	If $result <> "" Then
		For $i = 0 To UBound($aTroopDataList) - 1
			Local $troopData = StringSplit($aTroopDataList[$i], "#", $STR_NOCOUNT)
			$aTemp[$i][0] = $troopData[0] ; Troop number
			$aTemp[$i][1] = Number($troopData[1]) ; Slot
			$aTemp[$i][2] = Number($troopData[2]) ; Quant
		Next
	EndIf

	Local $x = 0, $y = 659, $x1 = 853, $y1 = 698

	_CaptureRegion($x,$y,$x1,$y1)
	Local $subDirectory = @ScriptDir & "\AttackBarCheck"
	DirCreate($subDirectory)
	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $fileName = String($Date & "_" & $Time & "_.png")
	Local $editedImage = $hBitmap
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
	Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED


	For $i = 0 To UBound($aTemp) - 1
		$plural = 0
		If $aTemp[$i][2] > 1  then $plural = 1
		SetLog($aTemp[$i][1] & " » " & $aTemp[$i][2] & " " & NameOfTroop($aTemp[$i][0], $Plural), $COLOR_GREEN)
	Next

	_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $fileName)
	_GDIPlus_PenDispose($hPenRED)
	_GDIPlus_GraphicsDispose($hGraphic)

	Setlog(" »» AttackBarCheck located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds")
	$DebugOcr = 0
	$debugImageSave = 0

	$RunState = False
EndFunc   ;==>btnNEWRedLineDetection

Func btnTestAD()
	$hTimer = TimerInit()
	Local $directory = @ScriptDir & "\images\WeakBase\ADefense"
	Local $return = returnAllMatches($directory)
	Setlog(" »» Air Defense located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds")
	_ArrayDisplay($return)
EndFunc   ;==>btnTestAD

Func btnPosCheck()
	Local $oRunState = $RunState
	$RunState = True

	Local $ToCheck = "IsMainGrayed"
	Select
		Case $ToCheck = "IsPostDefenseSummaryPage"
			$result = IsPostDefenseSummaryPage()
			SetLog("=============", $COLOR_TEAL)
			SetLog("#*# Func btnPosCheck", $COLOR_TEAL)
			SetLog("To Check = " & $ToCheck, $COLOR_TEAL)
			SetLog("Result = " & $result, $COLOR_TEAL)
		Case $ToCheck = "NoCloudsAttack"
			$result = _CheckPixel($aNoCloudsAttack, $bCapturePixel)
			SetLog("=============", $COLOR_TEAL)
			SetLog("#*# Func btnPosCheck", $COLOR_TEAL)
			SetLog("To Check = " & $ToCheck, $COLOR_TEAL)
			SetLog("Result = " & $result, $COLOR_TEAL)
			;If $Result = False Then SetLog("Cur Color = " & _GetPixelColor($aNoCloudsAttack[0], $aNoCloudsAttack[1], True), $COLOR_TEAL)
		Case $ToCheck = "SurrenderButton"
			$result = _CheckPixel($aSurrenderButton, $bCapturePixel)
			SetLog("=============", $COLOR_TEAL)
			SetLog("#*# Func btnPosCheck", $COLOR_TEAL)
			SetLog("To Check = " & $ToCheck, $COLOR_TEAL)
			SetLog("Result = " & $result, $COLOR_TEAL)
			If $result = False Then SetLog("Cur Color = " & _GetPixelColor($aSurrenderButton[0], $aSurrenderButton[1], True), $COLOR_TEAL)
		Case $ToCheck = "IsMain"
			$result = _CheckPixel($aIsMain, $bCapturePixel)
			SetLog("=============", $COLOR_TEAL)
			SetLog("#*# Func btnPosCheck", $COLOR_TEAL)
			SetLog("To Check = " & $ToCheck, $COLOR_TEAL)
			SetLog("Result = " & $result, $COLOR_TEAL)
			If $result = False Then SetLog("Cur Color = " & _GetPixelColor($aIsMain[0], $aIsMain[1], True), $COLOR_TEAL)
		Case $ToCheck = "RequestCC"
			$result = _GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True)
			$CCheck1 = _ColorCheck($result, Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])
			$CCheck2 = _ColorCheck($result, Hex($aRequestTroopsAO[3], 6), $aRequestTroopsAO[5])
			$CCheck3 = _ColorCheck($result, Hex($aRequestTroopsAO[4], 6), $aRequestTroopsAO[5])
			SetLog("=============", $COLOR_TEAL)
			SetLog("#*# Func btnPosCheck", $COLOR_TEAL)
			SetLog("To Check = " & $ToCheck, $COLOR_TEAL)
			SetLog("Can Request = " & $CCheck1, $COLOR_TEAL)
			SetLog("Already Made = " & $CCheck2, $COLOR_TEAL)
			SetLog("Army Full / No Clan = " & $CCheck3, $COLOR_TEAL)
		Case $ToCheck = "IsMainGrayed"
			$result = _CheckPixel($aIsMainGrayed, $bCapturePixel)
			SetLog("=============", $COLOR_TEAL)
			SetLog("#*# Func btnPosCheck", $COLOR_TEAL)
			SetLog("To Check = " & $ToCheck, $COLOR_TEAL)
			SetLog("Result = " & $result, $COLOR_TEAL)
			If $result = False Then SetLog("Cur Color = " & _GetPixelColor($aIsMainGrayed[0], $aIsMainGrayed[1], True), $COLOR_TEAL)
	EndSelect

	$RunState = $oRunState
EndFunc   ;==>btnPosCheck

Func arrows()
	getArmyHeroCount()
EndFunc   ;==>arrows

Func EnableGuiControls($OptimizedRedraw = True)
	Return ToggleGuiControls(True, $OptimizedRedraw)
EndFunc   ;==>EnableGuiControls

Func DisableGuiControls($OptimizedRedraw = True)
	Return ToggleGuiControls(False, $OptimizedRedraw)
EndFunc   ;==>DisableGuiControls

Func ToggleGuiControls($Enable, $OptimizedRedraw = True)
	If $OptimizedRedraw = True Then SetRedrawBotWindow(False)
	If $Enable = False Then
		SetDebugLog("Disable GUI Controls")
	Else
		SetDebugLog("Enable GUI Controls")
	EndIf
	$GUIControl_Disabled = True
	For $i = $FirstControlToHide To $LastControlToHide
		If IsTab($i) Or IsAlwaysEnabledControl($i) Then ContinueLoop
		If $NotifyPBEnabled And $i = $btnNotifyDeleteMessages Then ContinueLoop ; exclude the DeleteAllMesages button when PushBullet is enabled
		If $i = $btnMakeScreenshot Then ContinueLoop ; exclude
		If $i = $divider Then ContinueLoop ; exclude divider
		If $Enable = False Then
			; Save state of all controls on tabs
			$iPrevState[$i] = GUICtrlGetState($i)
			GUICtrlSetState($i, $GUI_DISABLE)
		Else
			; Restore previous state of controls
			GUICtrlSetState($i, $iPrevState[$i])
		EndIf
	Next
	$GUIControl_Disabled = False
	If $OptimizedRedraw = True Then SetRedrawBotWindow(True)
EndFunc   ;==>ToggleGuiControls
