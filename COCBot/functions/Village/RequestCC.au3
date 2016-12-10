; #FUNCTION# ====================================================================================================================
; Name ..........: RequestCC
; Description ...:
; Syntax ........: RequestCC()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #73
; Modified ......: (2015-06) Sardo, KnowJack(Jul/Aug 2015), Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func RequestCC($ClickPAtEnd = True, $specifyText = "")

	If $iPlannedRequestCCHoursEnable <> 1 Or $canRequestCC = False Or $bDonationEnabled = False Then
		Return
	EndIf

	If $iPlannedRequestCCHoursEnable = 1 Then
		Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		If $iPlannedRequestCCHours[$hour[0]] = 0 Then
			SetLog("Request Clan Castle troops not planned, Skipped..", $COLOR_ORANGE)
			Return ; exit func if no planned donate checkmarks
		EndIf
	EndIf

	SetLog("Requesting Clan Castle Troops", $COLOR_BLUE)

	;open army overview
	If IsMainPage() Then
		If $iUseRandomClick = 0 Then
			Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0334")
		Else
			ClickR($aArmyTrainButtonRND, $aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0)
		EndIf
	EndIf
	If _Sleep($iDelayRequestCC1) Then Return

	checkAttackDisable($iTaBChkIdle) ; Early Take-A-Break detection

	;wait to see army overview
	Local $icount = 0
	While Not ( _ColorCheck(_GetPixelColor($aArmyOverviewTest[0], $aArmyOverviewTest[1], True), Hex($aArmyOverviewTest[2], 6), $aArmyOverviewTest[3]))
		If _Sleep($iDelayRequestCC1) Then ExitLoop
		$icount += 1
		If $DebugSetLog = 1 Then Setlog("$icount1 = " & $icount & ", " & _GetPixelColor($aArmyOverviewTest[0], $aArmyOverviewTest[1], True), $COLOR_DEBUG) ;Debug
		If $icount > 5 Then ExitLoop ; wait 6*500ms = 3 seconds max
	WEnd
	If $icount > 5 And $DebugSetLog = 1 Then Setlog("RequestCC warning 1", $COLOR_DEBUG) ;Debug


	$color = _GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True)
	If _ColorCheck($color, Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5]) Then
		;can make a request
		$specifyText = IsFullCastleSpells(True)
		Local $x = _makerequest($specifyText)
	ElseIf _ColorCheck($color, Hex($aRequestTroopsAO[3], 6), $aRequestTroopsAO[5]) Then
		;request has allready been made
		SetLog("Request has already been made")
	ElseIf _ColorCheck($color, Hex($aRequestTroopsAO[4], 6), $aRequestTroopsAO[5]) Then
		;clan full or not in clan
		SetLog("Your Clan Castle is already full or you are not in a clan.")
		$canRequestCC = False
	Else
		;no button request found
		SetLog("Cannot detect button request troops.")
	EndIf
	#CS

		Local $directory = @ScriptDir & "\images\Other\CCButton"
		$SearchButton = SearchArmy($directory, 645, 528, 800, 610, "")
		If StringLen($SearchButton[0][0]) > 3 Then
		Local $BtnStatus = StringRegExp($SearchButton[0][0], "(?iU)(?:Req)(\w++)", 3)
		If IsArray($BtnStatus) Then $BtnStatus = $BtnStatus[0]
		Select
		Case $BtnStatus = "Can"
		;can make a request
		Local $x = _makerequest()
		Case $BtnStatus = "Ed"
		;request has allready been made
		SetLog("Request has already been made")
		Case $BtnStatus = "Filled"
		;clan full or not in clan
		SetLog("Your Clan Castle is already full or you are not in a clan.")
		$canRequestCC = False
		Case Else
		;no button request found
		SetLog("Cannot detect button request troops.")
		EndSelect
		EndIf
	#CE
	;exit from army overview
	If _Sleep($iDelayRequestCC1) Then Return
	If $ClickPAtEnd = True Then ClickP($aAway, 2, 0, "#0335")

EndFunc   ;==>RequestCC


Func _makerequest($specifyText = "")
	;click button request troops
	Click($aRequestTroopsAO[0], $aRequestTroopsAO[1], 1, 0, "0336") ;Select text for request

	;wait window
	Local $icount = 0
	While Not ( _ColorCheck(_GetPixelColor($aCancRequestCCBtn[0], $aCancRequestCCBtn[1], True), Hex($aCancRequestCCBtn[2], 6), $aCancRequestCCBtn[3]))
		If _Sleep($iDelaymakerequest1) Then ExitLoop
		$icount += 1
		If $DebugSetLog = 1 Then Setlog("$icount2 = " & $icount & ", " & _GetPixelColor($aCancRequestCCBtn[0], $aCancRequestCCBtn[1], True), $COLOR_DEBUG) ;Debug
		If $icount > 20 Then ExitLoop ; wait 21*500ms = 10.5 seconds max
	WEnd
	If $icount > 20 Then
		SetLog("Request has already been made, or request window not available", $COLOR_RED)
		ClickP($aAway, 2, 0, "#0257")
		If _Sleep($iDelaymakerequest2) Then Return
	Else
		Local $tempTxtRequest = $specifyText
		If $tempTxtRequest = "" Then $tempTxtRequest = $sTxtRequest
		If $tempTxtRequest <> "" Then
			If $ichkBackground = 0 And $NoFocusTampering = False Then ControlFocus($HWnD, "", "")
			; fix for Android send text bug sending symbols like ``"
			AndroidSendText($tempTxtRequest, True)
			Click($atxtRequestCCBtn[0], $atxtRequestCCBtn[1], 1, 0, "#0254") ;Select text for request $atxtRequestCCBtn[2] = [430, 140]
			_Sleep($iDelaymakerequest2)
;=====================================================================			
			If $ichkRusLang2 = 1 Then	
	  SetLog("Request in russian", $COLOR_BLUE)
     AutoItWinSetTitle('MyAutoItTitle')
    _WinAPI_SetKeyboardLayout(WinGetHandle(AutoItWinGetTitle()), 0x0419)
	 Sleep(1000)	 
	 ControlFocus($HWnd, "", "")	 
	 Sleep(1000)
	 SendKeepActive($HWnd)
	 If _SendExEx($tempTxtRequest) = 0 Then	
	            Setlog(" Request text entry failed, try again", $COLOR_RED)
				  Return
			   EndIf	
            Else 
	;SetLog("Request other lang", $COLOR_BLUE)	
	If SendText($tempTxtRequest) = 0 Then
				Setlog(" Request text entry failed, try again", $COLOR_RED)				
				 Return
			   EndIf
	 SendKeepActive("")		   
       EndIf			   
	EndIf
;+++++++++++++++++++++++++++++	Kychera Modified ++++++++++++++++++++++		
;						Support for the Russian language.
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++			
;=======================================================================			
		If _Sleep($iDelaymakerequest2) Then Return ; wait time for text request to complete
		$icount = 0
		While Not _ColorCheck(_GetPixelColor($aSendRequestCCBtn[0], $aSendRequestCCBtn[1], True), Hex(0x5fac10, 6), 20)
			If _Sleep($iDelaymakerequest1) Then ExitLoop
			$icount += 1
			If $DebugSetLog = 1 Then Setlog("$icount3 = " & $icount & ", " & _GetPixelColor($aSendRequestCCBtn[0], $aSendRequestCCBtn[1], True), $COLOR_DEBUG) ;Debug
			If $icount > 25 Then ExitLoop ; wait 26*500ms = 13 seconds max
		WEnd
		If $icount > 25 Then
			If $DebugSetLog = 1 Then SetLog("Send request button not found", $COLOR_DEBUG) ;Debug
			CheckMainScreen(False) ;emergency exit
		EndIf
		If $ichkBackground = 0 And $NoFocusTampering = False Then ControlFocus($HWnD, "", "") ; make sure Android has window focus
		Click($aSendRequestCCBtn[0], $aSendRequestCCBtn[1], 1, 100, "#0256") ; click send button
		$canRequestCC = False
	EndIf

EndFunc   ;==>_makerequest
