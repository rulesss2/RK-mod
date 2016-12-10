
; #FUNCTION# ====================================================================================================================
; Name ..........: SmartWait4Train
; Description ...: Will shutdown Android emulator & stop bot based on GUI configuration when waiting for troop training, spell cooking, or hero healing
; Syntax ........: SmartWait4Train()
; Parameters ....:
; Return values .: None
; Author ........: MonkeyHunter (05/06-2016)
; Modified ......: MR.ViPER (16-10-2016), TheRevenor (22-10-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;

Func SmartWait4Train()

	If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("Begin SmartWait4Train:", $COLOR_DEBUG1)

	If $ichkCloseWaitEnable = 0 Then Return ; Skip if not enabled

	Local $iExitCount = 0
	If _Sleep($iDelaySmartWait) Then Return ; first start 500ms so no false "**Main Window FAIL**" pops up
	While IsMainPage() = False ; check & wait for main page to ensure can read shield information properly
		If _Sleep($iDelayIdle1) Then Return
		$iExitCount += 1
		If $iExitCount > 25 Then ; 5 seconds before have error?
			Setlog("SmartWait4Train not finding Main Page, skip function!", $COLOR_ERROR)
			Return
		EndIf
	WEnd

	If BitOR($ichkCloseWaitEnable, $ichkCloseWaitTrain) = 0 Then Return ; skip if nothing selected in GUI

	Local $aResult, $iActiveHero
	Local $aHeroResult[3]
	Local Const $TRAINWAIT_NOWAIT = 0x00 ; default no waiting
	Local Const $TRAINWAIT_SHIELD = 0x01 ; Flag value used to simplify shield exists
	Local Const $TRAINWAIT_TROOP = 0x02 ; Value when wait for troop training and valid time exists
	Local Const $TRAINWAIT_SPELL = 0x04 ; Value when wait for spell cooking and valid time exists
	Local Const $TRAINWAIT_HERO = 0x08 ; Value when wait for hero healing, valid time exists, and Wait for Hero is enabled for active atttack modes

	Local $iTrainWaitCloseFlag = $TRAINWAIT_NOWAIT
	Local $sNowTime = "", $sTrainEndTime = ""
	Local $iShieldTime = 0, $iDiffDateTime = 0, $iDiffTime = 0
	Local $RandomAddPercent = Random(0, $icmbCloseWaitRdmPercent / 100) ; generate random percentage between 0 and user set GUI value
	Local $MinimumTimeClose = Number($icmbMinimumTimeClose * 60) ; Minimum time required to close
	If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("Random add percent = " & StringFormat("%.4f", $RandomAddPercent), $COLOR_DEBUG)
	If $debugSetlog = 1 Then Setlog("$MinimumTimeClose = " & $MinimumTimeClose & "s", $COLOR_DEBUG)

	; Determine state of $StopEmulator flag
	Local $StopEmulator = False
	If $ibtnCloseWaitStopRandom = 1 Then $StopEmulator = "random"
	If $ibtnCloseWaitStop = 1 Then $StopEmulator = True

	; Determine what wait mode(s) are enabled
	If IsArray($aShieldStatus) And (StringInStr($aShieldStatus[0], "shield", $STR_NOCASESENSEBASIC) Or StringInStr($aShieldStatus[0], "guard", $STR_NOCASESENSEBASIC)) Then
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("Have shield till " & $aShieldStatus[2] & ", close game while wait for train)", $COLOR_DEBUG)
		$iTrainWaitCloseFlag = BitOR($iTrainWaitCloseFlag, $TRAINWAIT_SHIELD) ; close if we have a shield
	EndIf
	If _Sleep($iDelayRespond) Then Return

	; verify shield info & update if not already exist
	If IsArray($aShieldStatus) = 0 Or $aShieldStatus[0] = "" Or $aShieldStatus[0] = "none" Then
		$aResult = getShieldInfo()
		If @error Then
			Setlog("SmartWait4Train Shield OCR error = " & @error & "Extended = " & @extended, $COLOR_ERROR)
			Return False
		Else
			$aShieldStatus = $aResult ; Update new values
		EndIf
		If IsArray($aShieldStatus) And (StringInStr($aShieldStatus[0], "shield", $STR_NOCASESENSEBASIC) Or StringInStr($aShieldStatus[0], "guard", $STR_NOCASESENSEBASIC)) Then ; check shield after update
			If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("Have shield till " & $aShieldStatus[2] & ", close game while wait for train)", $COLOR_DEBUG)
			$iTrainWaitCloseFlag = BitOR($iTrainWaitCloseFlag, $TRAINWAIT_SHIELD)
		EndIf
	EndIf
	If $debugsetlogTrain = 1 Or $debugSetlog = 1 And IsArray($aShieldStatus) Then Setlog("Shield Status:" & $aShieldStatus[0] & ", till " & $aShieldStatus[2], $COLOR_DEBUG)

	$result = OpenArmyWindow() ; Open train overview
	If $result = False Then
		If $debugimagesave = 1 Or $debugsetlogTrain = 1 Then Debugimagesave("SmartWait4Troop2_")
	EndIf
	If _Sleep($iDelayRespond) Then Return


	; Get troop training time remaining if enabled
	If $ichkCloseWaitTrain = 1 Or BitAND($iTrainWaitCloseFlag, $TRAINWAIT_SHIELD) = $TRAINWAIT_SHIELD Then
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("$ichkCloseWaitTrain enabled", $COLOR_DEBUG)
		getArmyTroopTime() ; update for Oct 2016
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("getArmyTroopTime returned: " & $aTimeTrain[0], $COLOR_DEBUG)
		If _Sleep($iDelayRespond) Then Return
		If $aTimeTrain[0] > 0 Then
			If $ibtnCloseWaitRandom = 1 Then
				$aTimeTrain[0] += $aTimeTrain[0] * $RandomAddPercent ; add some random percent
			EndIf
			$iTrainWaitCloseFlag = BitOR($iTrainWaitCloseFlag, $TRAINWAIT_TROOP)
		EndIf
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("$iTrainWaitCloseFlag:" & $iTrainWaitCloseFlag & ", troop time = " & StringFormat("%.2f", $aTimeTrain[0]), $COLOR_DEBUG)
	EndIf

	; get spell training time remaining if enabled
	If ($ichkCloseWaitTrain = 1 Or BitAND($iTrainWaitCloseFlag, $TRAINWAIT_SHIELD) = $TRAINWAIT_SHIELD) And IsWaitforSpellsActive() Then
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("$ichkCloseWaitSpell enabled", $COLOR_DEBUG)
		getArmySpellTime()
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("getArmySpellTime returned: " & $aTimeTrain[1], $COLOR_DEBUG)
		If _Sleep($iDelayRespond) Then Return
		If $aTimeTrain[1] > 0 Then
			If $ibtnCloseWaitRandom = 1 Then
				$aTimeTrain[1] += $aTimeTrain[1] * $RandomAddPercent ; add some random percent
			EndIf
			$iTrainWaitCloseFlag = BitOR($iTrainWaitCloseFlag, $TRAINWAIT_SPELL)
		EndIf
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("$iTrainWaitCloseFlag:" & $iTrainWaitCloseFlag & ", spell time = " & StringFormat("%.2f", $aTimeTrain[1]), $COLOR_DEBUG)
	EndIf

	; get hero regen time remaining if enabled
	If ($ichkCloseWaitTrain = 1 Or BitAND($iTrainWaitCloseFlag, $TRAINWAIT_SHIELD) = $TRAINWAIT_SHIELD) And IsWaitforHeroesActive() Then
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("$ichkCloseWaitHero enabled", $COLOR_DEBUG)
		For $j = 0 To UBound($aResult) - 1
			$aHeroResult[$j] = 0 ; reset old values
		Next
		If _Sleep($iDelayRespond) Then Return
		$aHeroResult = getArmyHeroTime("all")
		If @error Then
			Setlog("getArmyHeroTime return error, exit SmartWait!", $COLOR_ERROR)
			Return ; if error, then quit smartwait
		EndIf
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SetLog("getArmyHeroTime returned: " & $aHeroResult[0] & ":" & $aHeroResult[1] & ":" & $aHeroResult[2], $COLOR_DEBUG)
		If _Sleep($iDelayRespond) Then Return
		If $aHeroResult[0] > 0 Or $aHeroResult[1] > 0 Or $aHeroResult[2] > 0 Then ; check if hero is enabled to use/wait and set wait time
			For $pTroopType = $eKing To $eWarden ; check all 3 hero
				For $pMatchMode = $DB To $iModeCount - 1 ; check all attack modes
					If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then
						SetLog("$pTroopType: " & NameOfTroop($pTroopType) & ", $pMatchMode: " & $sModeText[$pMatchMode], $COLOR_DEBUG)
						Setlog("TroopToBeUsed: " & IsSpecialTroopToBeUsed($pMatchMode, $pTroopType) & ", Hero Wait Status: " & (BitAND($iHeroAttack[$pMatchMode], $iHeroWait[$pMatchMode]) = $iHeroAttack[$pMatchMode]), $COLOR_DEBUG)
					EndIf
					$iActiveHero = -1
					If IsSpecialTroopToBeUsed($pMatchMode, $pTroopType) And _
							BitAND($iHeroAttack[$pMatchMode], $iHeroWait[$pMatchMode]) = $iHeroAttack[$pMatchMode] Then ; check if Hero enabled to wait
						$iActiveHero = $pTroopType - $eKing ; compute array offset to active hero
					EndIf
					If $iActiveHero <> -1 And $aHeroResult[$iActiveHero] > 0 Then ; valid time?
						; check exact time & existing time is less than new time
						If $ibtnCloseWaitRandom = 1 And $aTimeTrain[2] < $aHeroResult[$iActiveHero] Then
							$aTimeTrain[2] = $aHeroResult[$iActiveHero] + ($aHeroResult[$iActiveHero] * $RandomAddPercent) ; add some random percent
						ElseIf $ibtnCloseWaitExact = 1 And $aTimeTrain[2] < $aHeroResult[$iActiveHero] Then
							$aTimeTrain[2] = $aHeroResult[$iActiveHero] ; use exact time
						EndIf
						$iTrainWaitCloseFlag = BitOR($iTrainWaitCloseFlag, $TRAINWAIT_HERO)
						If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then
							SetLog("Wait enabled: " & NameOfTroop($pTroopType) & ":" & $sModeText[$pMatchMode] & ", $iTrainWaitCloseFlag:" & $iTrainWaitCloseFlag & ", Hero Time:" & $aHeroResult[$iActiveHero] & ", Wait Time: " & StringFormat("%.2f", $aTimeTrain[2]), $COLOR_DEBUG)
						EndIf
					EndIf
				Next
				If _Sleep($iDelayRespond) Then Return
			Next
		Else
			If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("getArmyHeroTime return all zero hero wait times", $COLOR_DEBUG)
		EndIf
		If $aTimeTrain[2] > 0 Then
			If $ibtnCloseWaitRandom = 1 Then
				$aTimeTrain[2] += $aTimeTrain[2] * $RandomAddPercent ; add some random percent
			EndIf
			$iTrainWaitCloseFlag = BitOR($iTrainWaitCloseFlag, $TRAINWAIT_HERO)
		EndIf
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("$iTrainWaitCloseFlag:" & $iTrainWaitCloseFlag & ", hero time = " & StringFormat("%.2f", $aTimeTrain[2]), $COLOR_DEBUG)
	Else
		$aTimeTrain[2] = 0 ; clear hero remain time if disabled during stop
	EndIf

	; update CC remaining time till next request if request made and CC not full
	If $iCCRemainTime = 0 And _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[3], 6), $aRequestTroopsAO[5]) Then
		getArmyCCStatus()
	EndIf

	ClickP($aAway, 1, 0, "#0000") ;Click Away to close arny overview window
	If _Sleep($iDelaycheckArmyCamp4) Then Return

	If $iTrainWaitCloseFlag = $TRAINWAIT_NOWAIT Then Return ; Check close game flag enabled or return back without close

	; determine time to close CoC
	Switch $iTrainWaitCloseFlag
		Case 14 To 15 ; BitAND($iTrainWaitCloseFlag, $TRAINWAIT_HERO, $TRAINWAIT_SPELL, $TRAINWAIT_TROOP, $TRAINWAIT_SHIELD) = $iTrainWaitCloseFlag
			$iTrainWaitTime = _ArrayMax($aTimeTrain, 1, 0, 2, 0) ; use larger of troop, spell, or hero time
		Case 12 To 13
			$iTrainWaitTime = _Max($aTimeTrain[1], $aTimeTrain[2]) ; use larger of spell or hero time
		Case 10 To 11
			$iTrainWaitTime = _Max($aTimeTrain[0], $aTimeTrain[2]) ; use larger of train or hero time
		Case 8 To 9
			$iTrainWaitTime = $aTimeTrain[2] ; use hero time
		Case 6 To 7
			$iTrainWaitTime = _Max($aTimeTrain[0], $aTimeTrain[1]) ; use larger of troop or spell time
		Case 4 To 5
			$iTrainWaitTime = $aTimeTrain[1] ; use shield time
		Case 2 To 3
			$iTrainWaitTime = $aTimeTrain[0] ; use troop time
		Case 1 ; BitAND($iTrainWaitCloseFlag, $TRAINWAIT_SHIELD) = $iTrainWaitCloseFlag
			If $aTimeTrain[0] <= 1 Then
				ClickP($aAway, 1, 0, "#0000") ;Click Away to close window
				If _Sleep($iDelaycheckArmyCamp4) Then Return
				Setlog("No smart troop wait needed", $COLOR_SUCCESS)
				Return
			Else
				$iTrainWaitTime = $aTimeTrain[0] ; use troop time
			EndIf
		Case Else
			Setlog("Impossible > Slipped on banana checking train time flag!", $COLOR_ERROR)
			Return ; stop trying to close while training this time
	EndSwitch

	If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then
		Setlog("Training time values: " & StringFormat("%.2f", $aTimeTrain[0]) & " : " & StringFormat("%.2f", $aTimeTrain[1]) & " : " & StringFormat("%.2f", $aTimeTrain[2]), $COLOR_DEBUG)
		SetLog("$iTrainWaitTime = " & StringFormat("%.2f", $iTrainWaitTime) & " minutes", $COLOR_DEBUG)
		Setlog("$iTrainWaitCloseFlag: " & $iTrainWaitCloseFlag)
	EndIf

	; Adjust train wait time if CC request is enabled to ensure CC is full before troops are done training
	If $iPlannedRequestCCHoursEnable = 1 And $iCCRemainTime > 0 And $iCCRemainTime < $iTrainWaitTime Then
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("Wait time reduced for CC from: " & StringFormat("%.2f", $iTrainWaitTime) & " To " & StringFormat("%.2f", $iCCRemainTime), $COLOR_DEBUG)
		$iTrainWaitTime = $iCCRemainTime ; Set wait time based on time remaining in CC request to ensure CC is full
	EndIf

	$iTrainWaitTime = $iTrainWaitTime * 60 ; convert $iTrainWaitTime to seconds instead of minutes returned from OCR

	$sNowTime = _NowCalc() ; find/store time right now
	If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("Train end time: " & _DateAdd("s", Int($iTrainWaitTime), $sNowTime), $COLOR_DEBUG)

	If IsArray($aShieldStatus) And _DateIsValid($aShieldStatus[2]) Then ;check for valid shield time and find lessor of shield & train time remaining.
		$iShieldTime = _DateDiff("s", $sNowTime, $aShieldStatus[2]) ; find minutes until shield expires
		If @error Then _logErrorDateDiff(@error)
		If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("Shield time remain: " & $iShieldTime & " seconds", $COLOR_DEBUG)
		; subtract 45 seconds from actual Shield to allow for misc emulator/App start & stop delays, to prevent being attacked
		; immediately after Guard shield expires when you have no grace time.  Feature required to avoid losing trophy when trophy pushing
		$iShieldTime -= 45
	EndIf
	If $iTrainWaitTime >= $MinimumTimeClose Then
		If $iShieldTime > 0 Then
			$iDiffTime = $iShieldTime - ($iTrainWaitTime) ; Find difference between train and shield time easy way?
			If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("Time Train:Shield:Diff " & ($iTrainWaitTime) & ":" & $iShieldTime & ":" & $iDiffTime, $COLOR_DEBUG)

			If $iDiffTime <= 0 And $iShieldTime > 120 Then
				; close game = $iShieldTime because less than train time remaining
				Setlog("Smart wait while shield time = " & StringFormat("%.2f", $iShieldTime / 60) & " Minutes", $COLOR_INFO)
				UniversalCloseWaitOpenCoC($iShieldTime * 1000, "SmartWait4Train_", $StopEmulator)
				$Restart = True ; Set flag to exit idle loop to deal with potential user changes to GUI
				For $i = 0 To UBound($aTimeTrain) - 1 ; reset remaining time array
					$aTimeTrain[$i] = 0
				Next
			Else
				; close game  = $iTrainWaitTime because shield is larger than train time
				Setlog("Smart wait train time = " & StringFormat("%.2f", $iTrainWaitTime / 60) & " Minutes", $COLOR_INFO)
				UniversalCloseWaitOpenCoC($iTrainWaitTime * 1000, "SmartWait4Train_", $StopEmulator)
				$Restart = True ; Set flag to exit idle loop to deal with potential user changes to GUI
				For $i = 0 To UBound($aTimeTrain) - 1 ; reset remaining time array
					$aTimeTrain[$i] = 0
				Next
			EndIf

		ElseIf ($ichkCloseWaitTrain = 1 And $aTimeTrain[0] > 0) Or ($ichkCloseWaitSpell = 1 And $aTimeTrain[1] > 0) Or ($ichkCloseWaitHero = 1 And $aTimeTrain[2] > 0) Then
			;when no shield close game for $iTrainWaitTime time
			Setlog("Smart Wait time = " & StringFormat("%.2f", $iTrainWaitTime / 60) & " Minutes", $COLOR_INFO)
			UniversalCloseWaitOpenCoC($iTrainWaitTime * 1000, "SmartWait4TrainNoShield_", $StopEmulator)
			$Restart = True ; Set flag to exit idle loop to deal with potential user changes to GUI
			For $i = 0 To UBound($aTimeTrain) - 1 ; reset remaining time array
				$aTimeTrain[$i] = 0
			Next
		Else
			If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then Setlog("Troop training with time remaining not enabled, skip SmartWait game exit", $COLOR_DEBUG)
		EndIf
	ElseIf $iTrainWaitTime < $MinimumTimeClose Then
		Setlog("Smart Wait Time < Minimum Time Required To Close [" & ($MinimumTimeClose / 60) & " Min]", $COLOR_INFO)
		Setlog("Wait Train Time = " & StringFormat("%.2f", $iTrainWaitTime / 60) & " Minutes", $COLOR_INFO)
		Setlog("Not Close CoC Just Wait In The Main Screen", $COLOR_INFO)
		; Just wait without close the CoC
		_SleepStatus($iTrainWaitTime * 1000)
	EndIf

EndFunc   ;==>SmartWait4Train

