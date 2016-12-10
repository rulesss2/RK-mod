; #FUNCTION# ====================================================================================================================
; Name ..........: SuperXP
; Description ...: This file is all related to Gaining XP by Attacking to Goblin Picninc Signle player
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MR.ViPER (2016-11-5), MR.ViPER (2016-11-13)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $DebugSX = 0

;Global $ichkEnableSuperXP = 0, $irbSXTraining = 1, $ichkSXBK = 0, $ichkSXAQ = 0, $ichkSXGW = 0

; [0] = Queen, [1] = Warden, [2] = Barbarian King
; [0][0] = X, [0][1] = Y, [0][2] = XRandomOffset, [0][3] = YRandomOffset
Global $DpGoblinPicnic[3][4] = [[300, 205, 5, 5], [340, 140, 5, 5], [290, 220, 5, 5]]
Global $BdGoblinPicnic[3] = [0, "5000-7000", "6000-8000"] ; [0] = Queen, [1] = Warden, [2] = Barbarian King
Global $ActivatedHeroes[3] = [False, False, False] ; [0] = Queen, [1] = Warden, [2] = Barbarian King , Prevent to click on them to Activate Again And Again
Global Const $minStarsToEnd = 1
Global $canGainXP = False

Func MainSuperXPHandler()
	If $ichkEnableSuperXP = 0 Then Return
	If $irbSXTraining = 1 And $IsFullArmywithHeroesAndSpells = True Then Return ; If Gain while Training Enabled but Army is Full Then Return

	If WaitForMain() = False Then
		SetLog("Cannot get in Main Screen!! Exiting SuperXP", $COLOR_RED)
		Return False
	EndIf

	$iTrophyCurrent = getTrophyMainScreen($aTrophies[0], $aTrophies[1]) ; get OCR to read current Village Trophies
	If $DebugSetlog = 1 Then SetLog("Current Trophy Count: " & $iTrophyCurrent, $COLOR_DEBUG) ;Debug
	If Number($iTrophyCurrent) > Number($iTxtMaxTrophy) Then Return

	getArmyHeroCount(True, True)
	If WaitForMain() = False Then
		SetLog("Cannot get in Main Screen!! Exiting SuperXP", $COLOR_RED)
		Return False
	EndIf
	$canGainXP = ((IIf($ichkSXBK = $HERO_NOHERO, False, $iHeroAvailable >= $ichkSXBK) Or IIf($ichkSXAQ = $HERO_NOHERO, False, $iHeroAvailable >= $ichkSXAQ) Or IIf($ichkSXGW = $HERO_NOHERO, False, $iHeroAvailable >= $ichkSXGW)) And $iHeroAvailable <> $HERO_NOHERO And IIf($irbSXTraining = 1, $IsFullArmywithHeroesAndSpells = False, True))

	If $DebugSX = 1 Then SetLog("$iHeroAvailable = " & $iHeroAvailable)
	If $DebugSX = 1 Then SetLog("BK: " & $ichkSXBK & ", AQ: " & $ichkSXAQ & ", GW: " & $ichkSXGW)
	If $DebugSX = 1 Then SetLog("$canGainXP = " & $canGainXP & @CRLF & "1: " & String(IIf($ichkSXBK = $HERO_NOHERO, False, $iHeroAvailable >= $ichkSXBK)) & ", 2: " & _
			String(IIf($ichkSXAQ = $HERO_NOHERO, False, $iHeroAvailable >= $ichkSXAQ)) & ", 3: " & _
			String(IIf($ichkSXGW = $HERO_NOHERO, False, $iHeroAvailable >= $ichkSXGW)) & ", 4: " & ($iHeroAvailable <> $HERO_NOHERO) & _
			", 5: " & String(IIf($irbSXTraining = 1, $IsFullArmywithHeroesAndSpells = False, True)))

	If $canGainXP = False Then Return

	; Check if Start XP is not grabbed YET
	If $iStartXP = 0 Then
		$iStartXP = GetCurXP()
		SXSetXP("S")
	EndIf

	; Okay everything is Good, Attack Goblin Picnic
	While $canGainXP = True
		If WaitForMain() = False Then
			SetLog("Cannot get in Main Screen!! Exiting SuperXP", $COLOR_RED)
			Return False
		EndIf
		SetLog("Attacking to Goblin Picnic - GoblinXP", $COLOR_BLUE)
		If $RunState = False Then Return
		If OpenGoblinPicnic() = False Then
			SafeReturnSX()
			Return False
		EndIf
		If $RunState = False Then Return
		$rAttackSuperXP = AttackSuperXP()
		If $rAttackSuperXP = True Then
			If $RunState = False Then Return
			WaitToFinishSuperXP()
		EndIf
		If $RunState = False Then Return
		SetLog("Attacking Finished - GoblinXP", $COLOR_GREEN)
		If $rAttackSuperXP = True Then AttackFinishedSX()
		If $canGainXP = False Then ExitLoop
		DonateCC(True)
		If $irbSXTraining = 1 Then CheckForFullArmy()
		$canGainXP = ((IIf($ichkSXBK = $HERO_NOHERO, False, $iHeroAvailable >= $ichkSXBK) Or IIf($ichkSXAQ = $HERO_NOHERO, False, $iHeroAvailable >= $ichkSXAQ) Or IIf($ichkSXGW = $HERO_NOHERO, False, $iHeroAvailable >= $ichkSXGW)) And $iHeroAvailable <> $HERO_NOHERO And IIf($irbSXTraining = 1, $IsFullArmywithHeroesAndSpells = False, True) And $ichkEnableSuperXP = 1)
		If $DebugSX = 1 Then SetLog("$iHeroAvailable = " & $iHeroAvailable)
		If $DebugSX = 1 Then SetLog("BK: " & $ichkSXBK & ", AQ: " & $ichkSXAQ & ", GW: " & $ichkSXGW)
		If $DebugSX = 1 Then SetLog("While|$canGainXP = " & $canGainXP & @CRLF & "1: " & String(IIf($ichkSXBK = $HERO_NOHERO, False, $iHeroAvailable >= $ichkSXBK)) & ", 2: " & _
				String(IIf($ichkSXAQ = $HERO_NOHERO, False, $iHeroAvailable >= $ichkSXAQ)) & ", 3: " & _
				String(IIf($ichkSXGW = $HERO_NOHERO, False, $iHeroAvailable >= $ichkSXGW)) & ", 4: " & ($iHeroAvailable <> $HERO_NOHERO) & _
				", 5: " & String(IIf($irbSXTraining = 1, $IsFullArmywithHeroesAndSpells = False, True)) & ", 6: " & String($ichkEnableSuperXP = 1))
	WEnd
EndFunc   ;==>MainSuperXPHandler

Func CheckForFullArmy()
	If $DebugSX = 1 Then SetLog("SX|CheckForFullArmy", $COLOR_PURPLE)

	If WaitForMain() = False Then
		SetLog("Cannot get in Main Screen!! Exiting CheckForFullArmy", $COLOR_RED)
		Return False
	EndIf

	OpenArmyWindow()

	$fullarmy = False
	$bFullArmySpells = False

	$canRequestCC = _ColorCheck(_GetPixelColor($aRequestTroopsAO[0], $aRequestTroopsAO[1], True), Hex($aRequestTroopsAO[2], 6), $aRequestTroopsAO[5])

	IsFullArmy(True)
	If $RunState = False Then Return
	IsFullSpells(True)

	Local $fullcastlespells = IsFullCastleSpells()
	If $RunState = False Then Return
	Local $fullcastletroops = IsFullCastleTroops()

	Local $checkSpells = checkspells()

	;Test for Train/Donate Only and Fullarmy
	If ($CommandStop = 3 Or $CommandStop = 0) And $fullarmy Then
		SetLog("You are in halt attack mode and your Army is prepared!", $COLOR_DEBUG) ;Debug
		If $FirstStart Then $FirstStart = False
		Return
	EndIf

	If IsWaitforHeroesActive() Or $iChkTrophyRange = 1 Or $ichkEnableSuperXP = 1 Then
		;CheckExistentArmy("Heroes")
		getArmyHeroCount()
	Else
		$bFullArmyHero = True
	EndIf

	If $RunState = False Then Return

	If $fullarmy And $checkSpells And $bFullArmyHero And $fullcastlespells And $fullcastletroops Then
		$IsFullArmywithHeroesAndSpells = True
		$FirstStart = False
	Else
		$IsFullArmywithHeroesAndSpells = False
	EndIf

	If $IsFullArmywithHeroesAndSpells = False And (_ColorCheck(_GetPixelColor(391, 126, True), Hex(0x605C4C, 6), 15) = True And _ColorCheck(_GetPixelColor(587, 126, True), Hex(0x605C4D, 6), 15) = True) Then ; if Full army was false and nothing was in 'Train' and 'Brew' Queue then check for train
		If $DebugSX = 1 Then SetLog("SX|CFFA TrainRevamp Condi. #1")
		TestTrainRevamp()
	ElseIf $IsFullArmywithHeroesAndSpells = True And $ichkEnableSuperXP = 1 And $irbSXTraining = 1 Then ; Train Troops Before Attack
		If $DebugSX = 1 Then SetLog("SX|CFFA TrainRevamp Condi. #2")
		TestTrainRevamp()
	EndIf

	ClickP($aAway, 2, 0, "#0346") ;Click Away
	If $DebugSX = 1 Then SetLog("SX|CheckForFullArmy Finished", $COLOR_PURPLE)
EndFunc   ;==>CheckForFullArmy

Func SafeReturnSX()
	If $DebugSX = 1 Then SetLog("SX|SafeReturn", $COLOR_PURPLE)
	$canGainXP = False
	If IsMainPage() Then Return True
	Local $rExit = False
	If IsInAttackSuperXP() Then
		$rExit = ReturnHomeSuperXP()
	ElseIf IsInSPPage() Then
		$rExit = ExitSPPage()
	EndIf
	If $DebugSX = 1 Then SetLog("SX|SafeReturn=" & $rExit)
	Return $rExit
EndFunc   ;==>SafeReturnSX

Func ExitSPPage()
	If $DebugSX = 1 Then SetLog("SX|ExitSPPage", $COLOR_PURPLE)
	Click(822, 32, 1, 0, "#0152")
	Local $Counter = 0
	While Not (IsMainPage())
		If _Sleep(50) Then Return False
		$Counter += 1
		If $Counter >= 200 Then ExitLoop
	WEnd
	If $Counter >= 200 Then
		SetLog("Cannot Exit Single Player Page", $COLOR_RED)
		Return False
	EndIf
	If $DebugSX = 1 Then SetLog("SX|ExitSPPage Finished", $COLOR_PURPLE)
	Return True
EndFunc   ;==>ExitSPPage

Func AttackFinishedSX()
	If $DebugSX = 1 Then SetLog("SX|AttackFinished", $COLOR_PURPLE)
	$iCurrentXP = GetCurXP()
	$iGainedXP += 5
	SXSetXP()
	$ActivatedHeroes[0] = False
	$ActivatedHeroes[1] = False
	$ActivatedHeroes[2] = False
	If $DebugSX = 1 Then SetLog("SX|AttackFinished Finished", $COLOR_PURPLE)
EndFunc   ;==>AttackFinishedSX

Func GetCurXP()
	Return getVillageExp(55, 20)
EndFunc   ;==>GetCurXP

Func TestSuperXP()
	Local $oRunState = $RunState
	$RunState = True

	OpenGoblinPicnic()

	$RunState = $oRunState
EndFunc   ;==>TestSuperXP

Func WaitToFinishSuperXP()
	If $DebugSX = 1 Then SetLog("SX|WaitToFinishSuperXP", $COLOR_PURPLE)
	Local $BdTimer = TimerInit()
	While 1
		If CheckEarnedStars($minStarsToEnd) = True Then ExitLoop
		If _Sleep(70) Then ExitLoop
		If $RunState = False Then ExitLoop
		If IsInAttackSuperXP() = False Then ExitLoop
		ActivateHeroesByDelay($BdTimer)
		If TimerDiff($BdTimer) >= 120000 Then		; If Battle Started 2 Minutes ago, Then Return
			If $DebugSX = 1 Then SetLog("SX|WaitToFinishSuperXP TimeOut", $COLOR_RED)
			SafeReturnSX()
			ExitLoop
		EndIf
	WEnd
	If $DebugSX = 1 Then SetLog("SX|WaitToFinishSuperXP Finished", $COLOR_PURPLE)
	Return True
EndFunc   ;==>WaitToFinishSuperXP

Func ActivateHeroesByDelay($hBdTimer)
	$QueenDelay = $BdGoblinPicnic[0]
	If StringInStr($QueenDelay, "-") > 0 Then $QueenDelay = Random(Number(StringSplit($QueenDelay, "-", 2)[0]), Number(StringSplit($QueenDelay, "-", 2)[1]), 1)

	$WardenDelay = $BdGoblinPicnic[1]
	If StringInStr($WardenDelay, "-") > 0 Then $WardenDelay = Random(Number(StringSplit($WardenDelay, "-", 2)[0]), Number(StringSplit($WardenDelay, "-", 2)[1]), 1)

	$KingDelay = $BdGoblinPicnic[2]
	If StringInStr($KingDelay, "-") > 0 Then $KingDelay = Random(Number(StringSplit($KingDelay, "-", 2)[0]), Number(StringSplit($KingDelay, "-", 2)[1]), 1)

	Local $tDiff = TimerDiff($hBdTimer)
	If $tDiff >= $QueenDelay And $QueenDelay <> 0 And $ActivatedHeroes[0] = False And $Queen <> -1 And $ichkSXAQ <> $HERO_NOHERO Then
		If $DebugSX = 1 Then SetLog("SX|Activating Queen Ability After " & Round($tDiff, 3) & "/" & $QueenDelay & " ms(s)")
		SelectDropTroop($Queen)
		$ActivatedHeroes[0] = True
	EndIf
	If $tDiff >= $WardenDelay And $WardenDelay <> 0 And $ActivatedHeroes[1] = False And $Warden <> -1 And $ichkSXGW <> $HERO_NOHERO Then
		If $DebugSX = 1 Then SetLog("SX|Activating Warden Ability After " & Round($tDiff, 3) & "/" & $WardenDelay & " ms(s)")
		SelectDropTroop($Warden)
		$ActivatedHeroes[1] = True
	EndIf
	If $tDiff >= $KingDelay And $KingDelay <> 0 And $ActivatedHeroes[2] = False And $King <> -1 And $ichkSXBK <> $HERO_NOHERO Then
		If $DebugSX = 1 Then SetLog("SX|Activating King Ability After " & Round($tDiff, 3) & "/" & $KingDelay & " ms(s)")
		SelectDropTroop($King)
		$ActivatedHeroes[2] = True
	EndIf
EndFunc   ;==>ActivateHeroesByDelay

Func IsInAttackSuperXP()
	If $DebugSX = 1 Then SetLog("SX|IsInAttackSuperXP", $COLOR_PURPLE)
	If _ColorCheck(_GetPixelColor(60, 576, True), Hex(0x000000, 6), 20) Then Return True
	If $DebugSX = 1 Then SetLog("SX|IsInAttackSuperXP=FALSE")
	Return False
EndFunc   ;==>IsInAttackSuperXP

Func IsInSPPage()
	If $DebugSX = 1 Then SetLog("SX|IsInSPPage", $COLOR_PURPLE)
	Local $rColCheck = _ColorCheck(_GetPixelColor(316, 34, True), Hex(0xFFFFFF, 6), 20)
	If $DebugSX = 1 Then SetLog("SX|IsInSPPage=" & $rColCheck)
	Return $rColCheck
EndFunc   ;==>IsInSPPage

Func AttackSuperXP()
	If $DebugSX = 1 Then SetLog("SX|AttackSuperXP", $COLOR_PURPLE)
	If WaitForNoClouds() = False Then
		If $DebugSX = 1 Then SetLog("SX|ASX|Wait For Clouds = False")
		$Is_ClientSyncError = False
		Return False
	EndIf
	PrepareSuperXPAttack()
	If CheckAvailableHeroes() = False Then
		SetLog("No heroes available to attack with", $COLOR_ORANGE)
		ReturnHomeSuperXP()
		Return False
	EndIf
	DropAQSuperXP($BdGoblinPicnic[0] = 0)
	If CheckEarnedStars($minStarsToEnd) = True Then Return True
	DropGWSuperXP($BdGoblinPicnic[1] = 0)
	If CheckEarnedStars($minStarsToEnd) = True Then Return True
	DropBKSuperXP($BdGoblinPicnic[2] = 0)
	If $DebugSX = 1 Then SetLog("SX|AttackSuperXP Finished", $COLOR_PURPLE)
	Return True
EndFunc   ;==>AttackSuperXP

Func CheckAvailableHeroes()
	$canGainXP = ((IIf($ichkSXBK = $HERO_NOHERO, False, $King <> -1) Or IIf($ichkSXAQ = $HERO_NOHERO, False, $Queen <> -1) Or IIf($ichkSXGW = $HERO_NOHERO, False, $Warden <> -1)) And IIf($irbSXTraining = 1, $IsFullArmywithHeroesAndSpells = False, True))
	If $DebugSX = 1 Then SetLog("SX|CheckAvailableHeroes=" & $canGainXP)
	Return $canGainXP
EndFunc   ;==>CheckAvailableHeroes

Func DropAQSuperXP($bActivateASAP = True)
	If $Queen <> -1 And $ichkSXAQ <> $HERO_NOHERO Then
		SetLog("Deploying Queen", $COLOR_BLUE)
		Click(GetXPosOfArmySlot($Queen, 68), 595 + $bottomOffsetY, 1, 0, "#0000") ;Select Queen
		If _Sleep($iDelayDropSuperXP1) Then Return False
		If CheckEarnedStars($minStarsToEnd) = True Then Return True
		ClickP(GetDropPointSuperXP(1), 1, 0, "#0000") ;Drop Queen
		If _Sleep($iDelayDropSuperXP3) Then Return False
		If $bActivateASAP = True Then
			If IsAttackPage() Then
				SelectDropTroop($Queen) ;If Queen was not activated: Boost Queen
				$ActivatedHeroes[0] = True
			EndIf
		EndIf
		If _Sleep($iDelayDropSuperXP3) Then Return False
	EndIf
EndFunc   ;==>DropAQSuperXP

Func DropGWSuperXP($bActivateASAP = True)
	If $Warden <> -1 And $ichkSXGW <> $HERO_NOHERO Then
		SetLog("Deploying Warden", $COLOR_BLUE)
		Click(GetXPosOfArmySlot($Warden, 68), 595 + $bottomOffsetY, 1, 0, "#0179") ;Select Warden
		If _Sleep($iDelayDropSuperXP1) Then Return False
		If CheckEarnedStars($minStarsToEnd) = True Then Return True
		ClickP(GetDropPointSuperXP(2), 1, 0, "#0180") ;Drop Warden
		If _Sleep($iDelayDropSuperXP3) Then Return False
		If $bActivateASAP = True Then
			If IsAttackPage() Then
				SelectDropTroop($Warden) ;If Warden was not activated: Boost Warden
				$ActivatedHeroes[1] = True
			EndIf
		EndIf
		If _Sleep($iDelayDropSuperXP3) Then Return False
	EndIf
EndFunc   ;==>DropGWSuperXP

Func DropBKSuperXP($bActivateASAP = True)
	If $King <> -1 And $ichkSXBK <> $HERO_NOHERO Then
		SetLog("Deploying King", $COLOR_BLUE)
		Click(GetXPosOfArmySlot($King, 68), 595 + $bottomOffsetY, 1, 0, "#0177") ;Select King
		If _Sleep($iDelayDropSuperXP1) Then Return False
		If CheckEarnedStars($minStarsToEnd) = True Then Return True
		ClickP(GetDropPointSuperXP(3), 1, 0, "#0178") ;Drop King
		If _Sleep($iDelayDropSuperXP3) Then Return False
		If $bActivateASAP = True Then
			If IsAttackPage() Then
				SelectDropTroop($King) ;If King was not activated: Boost King
				$ActivatedHeroes[2] = True
			EndIf
		EndIf
		If _Sleep($iDelayDropSuperXP3) Then Return False
	EndIf
EndFunc   ;==>DropBKSuperXP

Func GetDropPointSuperXP($iHero)
	Local $ToReturn[2] = [-1, -1]
	Local $rDpGoblinPicnic[4] = [$DpGoblinPicnic[$iHero - 1][0], $DpGoblinPicnic[$iHero - 1][1], $DpGoblinPicnic[$iHero - 1][2], $DpGoblinPicnic[$iHero - 1][3]]
	$ToReturn[0] = Random($rDpGoblinPicnic[0] - $rDpGoblinPicnic[2], $rDpGoblinPicnic[0] + $rDpGoblinPicnic[2], 1)
	$ToReturn[1] = Random($rDpGoblinPicnic[1] - $rDpGoblinPicnic[3], $rDpGoblinPicnic[1] + $rDpGoblinPicnic[3], 1)

	Return $ToReturn
EndFunc   ;==>GetDropPointSuperXP

Func PrepareSuperXPAttack()
	If $DebugSX = 1 Then SetLog("SX|PrepareSuperXPAttack", $COLOR_PURPLE)
	Local $troopsnumber = 0
	If _Sleep($iDelayPrepareAttack1) Then Return
	_CaptureRegion2(0, 571 + $bottomOffsetY, 859, 671 + $bottomOffsetY)
	Local $Plural = 0
	Local $result = AttackBarCheck()
	If $debugSetlog = 1 Then Setlog("DLL Troopsbar list: " & $result, $COLOR_DEBUG) ;Debug
	Local $aTroopDataList = StringSplit($result, "|")
	Local $aTemp[12][3]
	If $result <> "" Then
		For $i = 1 To $aTroopDataList[0]
			Local $troopData = StringSplit($aTroopDataList[$i], "#", $STR_NOCOUNT)
			$aTemp[Number($troopData[1])][0] = $troopData[0]
			$aTemp[Number($troopData[1])][1] = Number($troopData[2])
			$aTemp[Number($troopData[1])][2] = Number($troopData[1])
		Next
	EndIf
	For $i = 0 To UBound($aTemp) - 1
		If $aTemp[$i][0] = "" And $aTemp[$i][1] = "" Then
			$atkTroops[$i][0] = -1
			$atkTroops[$i][1] = 0
		Else
			$troopKind = $aTemp[$i][0]
			If $troopKind < $eKing Then
				$atkTroops[$i][0] = $aTemp[$i][0]
				$atkTroops[$i][1] = $aTemp[$i][1]
				$troopKind = $aTemp[$i][1]
				$troopsnumber += $aTemp[$i][1]

			Else ;king, queen, warden and spells
				$atkTroops[$i][0] = $troopKind
				$troopsnumber += 1
				$atkTroops[$i][0] = $aTemp[$i][0]
				$troopKind = $aTemp[$i][1]
				$troopsnumber += 1
			EndIf
			$Plural = 0
			If $aTemp[$i][1] > 1 Then $Plural = 1
			If $troopKind <> -1 Then SetLog($aTemp[$i][2] & " » " & $aTemp[$i][1] & " " & NameOfTroop($atkTroops[$i][0], $Plural), $COLOR_GREEN)
		EndIf
	Next

	;ResumeAndroid()

	If $debugSetlog = 1 Then Setlog("troopsnumber  = " & $troopsnumber)

	$King = -1
	$Queen = -1
	$Warden = -1
	For $i = 0 To UBound($atkTroops) - 1
		If $atkTroops[$i][0] = $eKing Then
			$King = $i
		ElseIf $atkTroops[$i][0] = $eQueen Then
			$Queen = $i
		ElseIf $atkTroops[$i][0] = $eWarden Then
			$Warden = $i
		EndIf
	Next

	If $DebugSX = 1 Then SetLog("SX|PrepareSuperXPAttack Finished", $COLOR_PURPLE)
	Return $troopsnumber
EndFunc   ;==>PrepareSuperXPAttack

Func CheckEarnedStars($ExitWhileHave = 0) ; If the parameter is 0, will not exit from attack lol
	If $DebugSX = 1 Then SetLog("SX|CheckEarnedStars", $COLOR_PURPLE)
	Local $starsearned = 0

	If $ExitWhileHave = 1 Then
		; IT CAN BE DETECTED By WRONG... But just made this to prevent heroes getting attacked
		; Please Simply Comment This If Condition If you Saw Problems And Bot Returned to Home Without Getting At Least One Star
		If _ColorCheck(_GetPixelColor(455, 405, True), Hex(0xD0D8D0, 6), 20) Then
			SetLog("1 Star earned", $COLOR_GREEN)
			If ReturnHomeSuperXP() = False Then CloseCoC(True) ; If Something Was Wrong with Returning Home, Close CoC And Open Again
			Return True
		EndIf
	EndIf

	If _ColorCheck(_GetPixelColor(714, 594, True), Hex(0xCCCFC8, 6), 20) Then $starsearned += 1

	If $ExitWhileHave <> 0 And $starsearned >= $ExitWhileHave Then
		SetLog($starsearned & " Star earned", $COLOR_GREEN)
		If ReturnHomeSuperXP() = False Then CloseCoC(True) ; If Something Was Wrong with Returning Home, Close CoC And Open Again
		Return True
	EndIf

	If $ExitWhileHave >= 2 Then
		If _ColorCheck(_GetPixelColor(740, 583, True), Hex(0xC6CBC5, 6), 20) Then $starsearned += 1

		If $ExitWhileHave <> 0 And $starsearned >= $ExitWhileHave Then
			SetLog($starsearned & " Stars earned", $COLOR_GREEN)
			If ReturnHomeSuperXP() = False Then CloseCoC(True) ; If Something Was Wrong with Returning Home, Close CoC And Open Again
			Return True
		EndIf

		If $ExitWhileHave >= 3 Then
			If _ColorCheck(_GetPixelColor(764, 583, True), Hex(0xBEC5BE, 6), 20) Then $starsearned += 1

			If $ExitWhileHave <> 0 And $starsearned >= $ExitWhileHave Then
				SetLog($starsearned & " Stars earned", $COLOR_GREEN)
				If ReturnHomeSuperXP() = False Then CloseCoC(True) ; If Something Was Wrong with Returning Home, Close CoC And Open Again
				Return True
			EndIf
		EndIf
	EndIf

	Return False

EndFunc   ;==>CheckEarnedStars

Func ReturnHomeSuperXP()
	Local Const $EndBattleText[4] = [29, 595, 0xFFFFFF, 10], $EndBattle2Text[4] = [491, 424, 0xFFFFFF, 10], $ReturnHomeText[4] = [445, 575, 0xFFFFFF, 10]
	Local Const $iDelayEachCheck = 70, $iRetryLimits = 429 ; Wait for each Color About 30 Seconds If didn't found!
	Local $Counter = 0

	$King = -1
	$Queen = -1
	$Warden = -1
	SetLog("Returning Home - SuperXP", $COLOR_BLUE)

	; 1st Step
	While _ColorCheck(_GetPixelColor($EndBattleText[0], $EndBattleText[1], True), Hex($EndBattleText[2], 6), $EndBattleText[3]) = False ; First EndBattle Button
		If _Sleep($iDelayEachCheck) Then Return False
		$Counter += 1
		If $Counter >= $iRetryLimits Then
			If $DebugSX = 1 Then SetLog("SX|RHSX|First EndBattle Button not found")
			Return False
		EndIf
	WEnd

	Click(Random($EndBattleText[0] - 5, $EndBattleText[0] + 5, 1), Random($EndBattleText[1] - 5, $EndBattleText[1] + 5, 1)) ; Click First EndBattle Button
	If _Sleep($iDelayEachCheck) Then Return False

	; 2nd Step
	$Counter = 0 ; Reset Counter
	While _ColorCheck(_GetPixelColor($EndBattle2Text[0], $EndBattle2Text[1], True), Hex($EndBattle2Text[2], 6), $EndBattle2Text[3]) = False ; Second EndBattle Button
		If _Sleep($iDelayEachCheck) Then Return False
		If IsMainPage() Then
			_GUICtrlEdit_SetText($txtLog, _PadStringCenter(" BOT LOG ", 71, "="))
			_GUICtrlRichEdit_SetFont($txtLog, 6, "Lucida Console")
			_GUICtrlRichEdit_AppendTextColor($txtLog, "" & @CRLF, _ColorConvert($Color_Black))
			Return True
		EndIf
		$Counter += 1
		If $Counter >= $iRetryLimits Then
			If $DebugSX = 1 Then SetLog("SX|RHSX|Second EndBattle Button not found")
			Return False
		EndIf
	WEnd

	Click(Random($EndBattle2Text[0] - 5, $EndBattle2Text[0] + 5, 1), Random($EndBattle2Text[1] - 5, $EndBattle2Text[1] + 5, 1)) ; Click 2nd EndBattle Button, (Verify)
	If _Sleep($iDelayEachCheck) Then Return False

	; 3rd Step
	$Counter = 0 ; Reset Counter
	While _ColorCheck(_GetPixelColor($ReturnHomeText[0], $ReturnHomeText[1], True), Hex($ReturnHomeText[2], 6), $ReturnHomeText[3]) = False ; Last - Return Home Button
		If _Sleep($iDelayEachCheck) Then Return False
		If IsMainPage() Then
			_GUICtrlEdit_SetText($txtLog, _PadStringCenter(" BOT LOG ", 71, "="))
			_GUICtrlRichEdit_SetFont($txtLog, 6, "Lucida Console")
			_GUICtrlRichEdit_AppendTextColor($txtLog, "" & @CRLF, _ColorConvert($Color_Black))
			Return True
		EndIf
		$Counter += 1
		If $Counter >= $iRetryLimits Then
			If $DebugSX = 1 Then SetLog("SX|RHSX|Last Return Home Button not found")
			Return False
		EndIf
	WEnd

	Click(Random($ReturnHomeText[0] - 5, $ReturnHomeText[0] + 5, 1), Random($ReturnHomeText[1] - 5, $ReturnHomeText[1] + 5, 1)) ; Click on Return Home Button
	If _Sleep($iDelayReturnHome2) Then Return ; short wait for screen to Exit

	; Last Step, Check for Main Screen
	$Counter = 0 ; Reset Counter
	While 1
		If _Sleep($iDelayReturnHome4) Then Return
		If IsMainPage() Then
			_GUICtrlEdit_SetText($txtLog, _PadStringCenter(" BOT LOG ", 71, "="))
			_GUICtrlRichEdit_SetFont($txtLog, 6, "Lucida Console")
			_GUICtrlRichEdit_AppendTextColor($txtLog, "" & @CRLF, _ColorConvert($Color_Black))
			Return True
		EndIf
		$Counter += 1
		If $Counter >= 50 Or isProblemAffect(True) Then
			SetLog("Cannot return home.", $COLOR_RED)
			checkMainScreen(False, True)
			Return True
		EndIf
	WEnd

EndFunc   ;==>ReturnHomeSuperXP

Func WaitForNoClouds()
	If $DebugSX = 1 Then SetLog("SX|WaitForNoClouds", $COLOR_PURPLE)
	Local $i = 0
	ForceCaptureRegion()
	While _ColorCheck(_GetPixelColor(60, 576, True), Hex(0x000000, 6), 20) = False
		If _Sleep($iDelayGetResources1) Then Return False
		$i += 1
		If $i >= 120 Or isProblemAffect(True) Then ; Wait 30 seconds then restart bot and CoC
			$Is_ClientSyncError = True
			checkMainScreen()
			If $Restart Then
				$iNbrOfOoS += 1
				UpdateStats()
				SetLog("Disconnected At Search Clouds - SuperXP", $COLOR_RED)
				PushMsg("OoSResources")
			Else
				SetLog("Stuck At Search Clouds, Restarting CoC and Bot... - SuperXP", $COLOR_RED)
				$Is_ClientSyncError = False ; disable fast OOS restart if not simple error and restarting CoC
				CloseCoC(True)
			EndIf
			Return False
		EndIf
		If $DebugSX = 1 Then SetLog("SX|WFNC|Loop #" & $i)
		ForceCaptureRegion() ; ensure screenshots are not cached
	WEnd
	If $DebugSX = 1 Then SetLog("SX|WaitFornoClouds Finished", $COLOR_PURPLE)
	Return True
EndFunc   ;==>WaitForNoClouds

Func OpenGoblinPicnic()
	If $DebugSX = 1 Then SetLog("SX|OpenGoblinPicnic", $COLOR_PURPLE)
	Local $rOpenSinglePlayerPage = OpenSinglePlayerPage()
	If $rOpenSinglePlayerPage = False Then
		SetLog("Failed to open Attack page, Single Player", $COLOR_RED)
		SafeReturnSX()
		Return False
	EndIf
	Local $rDragToGoblinPicnic = DragToGoblinPicnic()
	If $rDragToGoblinPicnic = False Then
		SetLog("Failed to find Goblin Picnic", $COLOR_RED)
		SafeReturnSX()
		Return False
	EndIf
	If $DebugSX = 1 Then SetLog("SX|OGP|Clicking On GP Text: " & $rDragToGoblinPicnic[0] & ", " & $rDragToGoblinPicnic[1])
	Click($rDragToGoblinPicnic[0], $rDragToGoblinPicnic[1]) ; Click On Goblin Picnic Text To Show Attack Button
	Local $Counter = 0
	While _ColorCheck(_GetPixelColor(621, 665, True), Hex(0xFFFFFF, 6), 10) = False Or _ColorCheck(_GetPixelColor(663, 662, True), Hex(0xFFFFFF, 6), 10) = False ; Wait for Attack Button
		If _Sleep(50) Then ExitLoop
		$Counter += 1
		If $Counter > 200 Then ExitLoop
	WEnd
	If $Counter > 200 Then
		SetLog("Available loot info didn't Displayed!", $COLOR_RED)
		SafeReturnSX()
		Return False
	EndIf
	$Counter = 0
	While _ColorCheck(_GetPixelColor($rDragToGoblinPicnic[0], $rDragToGoblinPicnic[1] + 78, True), Hex(0xE04A00, 6), 30) = False
		If _Sleep(50) Then ExitLoop
		Click($rDragToGoblinPicnic[0], $rDragToGoblinPicnic[1]) ; Click On Goblin Picnic Text To Show Attack Button
		$Counter += 1
		If $Counter > 200 Then ExitLoop
	WEnd
	If $Counter > 200 Then
		If IsGoblinPicnicLocked($rDragToGoblinPicnic) = True Then
			SetLog("Are you kidding me? Goblin Picnic is Locked", $COLOR_RED)
			DisableSX()
			SafeReturnSX()
			Return False
		EndIf
		SetLog("Attack Button Cannot be Verified", $COLOR_RED)
		DebugImageSave("SuperXP_", True, "png", True, String(Number($rDragToGoblinPicnic[0], 2) & ", " & Number($rDragToGoblinPicnic[1], 2) & @CRLF & Number($rDragToGoblinPicnic[0], 2) & ", " & Number($rDragToGoblinPicnic[1] + 78, 2)), 80, 145, 35, $rDragToGoblinPicnic[0] - 5, $rDragToGoblinPicnic[1] - 5 + 78, 10, 10)
		SafeReturnSX()
		Return False
	EndIf
	If $DebugSX = 1 Then
		SetLog("SX|OGP|Clicking On Attack Btn: " & $rDragToGoblinPicnic[0] & ", " & $rDragToGoblinPicnic[1] + 78)
	EndIf

	Click($rDragToGoblinPicnic[0], $rDragToGoblinPicnic[1] + 78) ; Click On Attack Button

	$Counter = 0
	While IsInSPPage()
		If _Sleep(50) Then ExitLoop
		$Counter += 1
		If $Counter > 150 Then ExitLoop
	WEnd
	If $Counter >= 150 Then
		SetLog("Still in SinglePlayer Page!! Something Strange Happened", $COLOR_RED)
		DebugImageSave("SuperXP_", True, "png", True, String(Number($rDragToGoblinPicnic[0], 2) & ", " & Number($rDragToGoblinPicnic[1], 2) & @CRLF & Number($rDragToGoblinPicnic[0], 2) & ", " & Number($rDragToGoblinPicnic[1] + 78, 2)), 80, 145, 35, $rDragToGoblinPicnic[0] - 5, $rDragToGoblinPicnic[1] - 5 + 78, 10, 10)
		$canGainXP = False
		Return False
	EndIf

	#CS          Not Sure If This Checks Are Needed
		Local $result = getAttackDisable(346, 182) ; Grab Ocr for TakeABreak check
		checkAttackDisable($iTaBChkAttack, $result) ;See If TakeABreak msg on screen
		If $debugSetlog = 1 Then Setlog("PrepareSearch exit check $Restart= " & $Restart & ", $OutOfGold= " & $OutOfGold, $COLOR_DEBUG) ;Debug
		If $Restart = True Or $OutOfGold = 1 Then ; If we have one or both errors, then return
		$Is_ClientSyncError = False ; reset fast restart flag to stop OOS mode, and rearm, collecting resources etc.
		Return False
		EndIf
	#CE

	Local $rIsGoblinPicnic = IsInGoblinPicnic() ; Wait/Check if is In Goblin Picnic Base
	If $rIsGoblinPicnic = False Then
		SetLog("Looks like we're not in Goblin Picnic", $COLOR_RED)
		If _CheckPixel($aCancelFight, $bNoCapturePixel) Or _CheckPixel($aCancelFight2, $bNoCapturePixel) Then
			If $debugSetlog Then SetLog("#cOb# Clicks X 2, $aCancelFight", $COLOR_BLUE)
			PureClickP($aCancelFight, 1, 0, "#0135") ;Clicks X
			If _Sleep($iDelaycheckObstacles1) Then Return False
			SafeReturnSX()
			Return False
		EndIf
		SafeReturnSX()
		Return False
	EndIf
	SetLog("Now we're in Goblin Picnic Base", $COLOR_GREEN)
	Return True
EndFunc   ;==>OpenGoblinPicnic

Func IsInGoblinPicnic($Retry = True, $maxRetry = 30, $timeBetweenEachRet = 300)
	If $DebugSX = 1 Then SetLog("SX|IsInGoblinPicnic", $COLOR_PURPLE)
	Local $Found = False
	Local $Counter = 0
	Local $directory = @ScriptDir & "\images\Resources\SuperXP\Verify"
	Local $result = ""
	While $Found = False
		If _Sleep($timeBetweenEachRet) Then Return False
		If IsInAttackSuperXP() = False Then ContinueLoop

		$result = multiMatchesPixelOnly($directory, 0, "FV", "FV", "", 0, 1000, 0, 0, 111, 31)
		If $DebugSX = 1 Then SetLog("SX|IGP|$result=" & $result)
		$Found = (StringLen($result) > 2 And StringInStr($result, ","))

		$Counter += 1
		If $Counter = $maxRetry Then
			$Found = False
			ExitLoop
		EndIf
	WEnd
	If $DebugSX = 1 Then SetLog("SX|IsGoblinPicnic=" & $Found, $COLOR_PURPLE)
	Return $Found
EndFunc   ;==>IsInGoblinPicnic

Func IsGoblinPicnicLocked($FoundCoord)
	If $DebugSX = 1 Then SetLog("SX|IsGoblinPicnicLocked", $COLOR_PURPLE)
	Local $x = $FoundCoord[0], $y = $FoundCoord[1] + 9, $x1 = $x + 29, $y1 = $y + 34
	Local $directory = @ScriptDir & "\images\Resources\SuperXP\Locked"
	Local $result = multiMatchesPixelOnly($directory, 0, "FV", "FV", "", 0, 1000, $x, $y, $x1, $y1)
	If $DebugSX = 1 Then SetLog("SX|IGPL|$result=" & $result)
	Local $Found = (StringLen($result) > 2 And StringInStr($result, ","))
	If $DebugSX = 1 Then SetLog("SX|IGPL Return " & $Found)
	Return $Found
EndFunc   ;==>IsGoblinPicnicLocked

Func DragToGoblinPicnic()
	If $DebugSX = 1 Then SetLog("SX|DragToGoblinPicnic", $COLOR_PURPLE)
	Local $rIsGoblinPicnicFound = False
	Local $Counter = 0
	Local $posInSinglePlayer2 = "MIDDLE"
	Local $posInSinglePlayer = GetPositionInSinglePlayer()
	If $DebugSX = 1 Then SetLog("SX|DTGP|$posInSinglePlayer=" & $posInSinglePlayer)
	If $posInSinglePlayer = "MIDDLE" Then
		If $DebugSX = 1 Then SetLog("SX|DTGP|Pos Middle, checking for GP")
		$rIsGoblinPicnicFound = IsGoblinPicnicFound()
		If IsArray($rIsGoblinPicnicFound) Then Return $rIsGoblinPicnicFound
		If $DebugSX = 1 Then SetLog("SX|DTGP|Pos middle, Dragging To End")
		If DragToEndSinglePlayer() = True Then $posInSinglePlayer = "END" ; If position was Middle, then try to Drag to end
	EndIf
	If $posInSinglePlayer = "MIDDLE" Then
		If $DebugSX = 1 Then SetLog("SX|DTGP|Failed to Drag To End, Still middle")
		Return False ; If Failed to Drag To End Then Return False
	EndIf

	Switch $posInSinglePlayer
		Case "END"
			While Not (IsArray($rIsGoblinPicnicFound))
				If $DebugSX = 1 Then SetLog("SX|DTGP|Drag from End Loop #" & $Counter)
				ClickDrag(Random(505, 515, 1), Random(95, 105, 1), Random(505, 515, 1), Random(656, 666, 1), 100)
				If _Sleep(100) Then Return False
				$rIsGoblinPicnicFound = IsGoblinPicnicFound()
				If IsArray($rIsGoblinPicnicFound) Then ExitLoop
				$Counter += 1
				$posInSinglePlayer2 = GetPositionInSinglePlayer()
				If $Counter = 15 Or $posInSinglePlayer2 = "FIRST" Then ExitLoop
			WEnd
			If $Counter = 15 Or $posInSinglePlayer2 And IsArray($rIsGoblinPicnicFound) = False Then Return False
			Return $rIsGoblinPicnicFound
		Case "FIRST"
			While Not (IsArray($rIsGoblinPicnicFound))
				If $DebugSX = 1 Then SetLog("SX|DTGP|Drag from First Loop #" & $Counter)
				ClickDrag(Random(505, 515, 1), Random(656, 666, 1), Random(505, 515, 1), Random(95, 105, 1), 100)
				If _Sleep(100) Then Return False
				$rIsGoblinPicnicFound = IsGoblinPicnicFound()
				If IsArray($rIsGoblinPicnicFound) Then ExitLoop
				$Counter += 1
				$posInSinglePlayer2 = GetPositionInSinglePlayer()
				If $Counter = 15 Or $posInSinglePlayer2 = "FIRST" Then ExitLoop
			WEnd
			If $Counter = 15 Or $posInSinglePlayer2 And IsArray($rIsGoblinPicnicFound) = False Then Return False
			Return $rIsGoblinPicnicFound
	EndSwitch
EndFunc   ;==>DragToGoblinPicnic

Func IsGoblinPicnicFound()
	If $DebugSX = 1 Then SetLog("SX|IsGoblinPicnicFound", $COLOR_PURPLE)
	Click(840, 230 + $midOffsetY)
	If _Sleep(50) Then Return False
	Local $directory = @ScriptDir & "\images\Resources\SuperXP\Find"
	Local $result = multiMatchesPixelOnly($directory, 0, "FV", "FV", "", 0, 1000, 554, 120, 639, $GAME_HEIGHT)
	If $DebugSX = 1 Then SetLog("SX|IGPF|$result=" & $result)
	If StringLen($result) < 3 And StringInStr($result, "|") = 0 Then
		If $DebugSX = 1 Then SetLog("SX|IGPF|Return False")
		Return False
	EndIf

	Local $ToReturn = ""
	If StringInStr($result, "|") > 0 Then
		$ToReturn = StringSplit(StringSplit($result, "|", 2)[0], ",", 2)
	Else
		$ToReturn = StringSplit($result, ",", 2)
	EndIf

	$ToReturn[0] += 554
	$ToReturn[1] += 120
	If $DebugSX = 1 Then SetLog("SX|IGPF Return $ToReturn[2] = [0]=" & $ToReturn[0] & ",[1]=" & $ToReturn[1])
	Return $ToReturn
EndFunc   ;==>IsGoblinPicnicFound

Func DragToEndSinglePlayer()
	If $DebugSX = 1 Then SetLog("SX|DragToEndSinglePlayer", $COLOR_PURPLE)
	Local $rColCheckEnd = _ColorCheck(_GetPixelColor(670, 695, True), Hex(0x393224, 6), 20)
	Local $Counter = 0
	While $rColCheckEnd = False
		If $DebugSX = 1 Then SetLog("SX|DTESP|Loop #" & $Counter)
		ClickDrag(500, 635 + $midOffsetY, 500, 60 + $midOffsetY, 100)
		$rColCheckEnd = _ColorCheck(_GetPixelColor(670, 695, True), Hex(0x393224, 6), 20)
		$Counter += 1
		If $Counter = 15 Then ExitLoop
	WEnd
	If $Counter = 15 Then
		If $DebugSX = 1 Then SetLog("SX|DTESP|Return False")
		Return False
	EndIf
	If $DebugSX = 1 Then SetLog("SX|DTESP|Return True")
	Return True
EndFunc   ;==>DragToEndSinglePlayer

Func GetPositionInSinglePlayer()
	If $DebugSX = 1 Then SetLog("SX|GetPositionInSinglePlayer", $COLOR_PURPLE)
	ClickP($aAway, 2, 0, "#0346") ;Click Away To Hide Available Loot Info

	Local $Counter = 0
	While _ColorCheck(_GetPixelColor(621, 665, True), Hex(0xFFFFFF, 6), 10) And _ColorCheck(_GetPixelColor(663, 662, True), Hex(0xFFFFFF, 6), 10)
		If _Sleep(50) Then ExitLoop
		ClickP($aAway, 2, 0, "#0346") ;Click Away To Hide Available Loot Info
		$Counter += 1
		If $Counter > 100 Then
			If $DebugSX = 1 Then SetLog("SX|GPISP|Available Loot Not Hidden, Returning")
			ExitLoop
		EndIf
	WEnd

	$rColCheckEnd = _ColorCheck(_GetPixelColor(670, 695, True), Hex(0x393224, 6), 20)
	If $rColCheckEnd Then
		If $DebugSX = 1 Then SetLog("SX|GPISP|Return END")
		Return "END"
	Else
		$rColCheckFirst = _ColorCheck(_GetPixelColor(585, 4, True), Hex(0x2E281D, 6), 20)
		If $rColCheckFirst Then
			If $DebugSX = 1 Then SetLog("SX|GPISP|Return FIRST")
			Return "FIRST"
		Else
			If $DebugSX = 1 Then SetLog("SX|GPISP|Return MIDDLE")
			Return "MIDDLE"
		EndIf
	EndIf
EndFunc   ;==>GetPositionInSinglePlayer

Func OpenSinglePlayerPage()
	If $DebugSX = 1 Then SetLog("SX|OpenSinglePlayerPage", $COLOR_PURPLE)

	IsWaitingForConnection()

	If WaitForMain(True, 50, 300) = False Then
		If $DebugSX = 1 Then SetLog("SX|MainPage Not Displayed to Open SingleP")
		Return False
	EndIf

	SetLog("Going to Gain XP...", $COLOR_BLUE)

	If IsMainPage() Then

		If $iUseRandomClick = 0 Then
			ClickP($aAttackButton, 1, 0, "#0149") ; Click Attack Button
		Else
			ClickR($aAttackButtonRND, $aAttackButton[0], $aAttackButton[1], 1, 0)
		EndIf
	EndIf
	If _Sleep(70) Then Return

	Local $j = 0
	While _ColorCheck(_GetPixelColor(606, 33, True), Hex(0xFFFFFF, 6), 10) = False And _ColorCheck(_GetPixelColor(804, 32, True), Hex(0xFFFFFF, 6), 10) = False
		If _Sleep(70) Then Return
		$j += 1
		If $j > 214 Then ExitLoop
	WEnd
	If $j > 214 Then
		SetLog("Launch attack Page Fail", $COLOR_RED)
		checkMainScreen()
		Return False
	Else
		Return True
	EndIf

EndFunc   ;==>OpenSinglePlayerPage

Func WaitForMain($clickAway = True, $delayEachCheck = 50, $maxRetry = 100)
	If $clickAway Then ClickP($aAway, 2, 0, "#0346") ;Click Away

	Local $Counter = 0
	While Not (IsMainPage())
		If _Sleep($delayEachCheck) Then Return True
		If $clickAway Then ClickP($aAway, 2, 0, "#0346") ;Click Away
		$Counter += 1
		If $Counter > $maxRetry Then
			Return False
		EndIf
	WEnd

	Return True
EndFunc   ;==>WaitForMain
