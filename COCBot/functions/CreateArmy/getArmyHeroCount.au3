
; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyHeroCount
; Description ...: Obtains count of heroes available from Training - Army Overview window
; Syntax ........: getArmyHeroCount()
; Parameters ....: $bOpenArmyWindow  = Bool value true if train overview window needs to be opened
;				 : $bCloseArmyWindow = Bool value, true if train overview window needs to be closed
; Return values .: None
; Author ........: Separated from checkArmyCamp()
; Modified ......: MonkeyHunter (06-2016), MR.ViPER (16-10-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func getArmyHeroCount($bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $debugsetlogTrain = 1 Or $debugSetlog = 1 Then SETLOG("Begin getArmyTHeroCount:", $COLOR_DEBUG) ;Debug

	If $bOpenArmyWindow = False And ISArmyWindow() = False Then ; check for train page
		SetError(1)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow = True Then
		If OpenArmyWindow() = False Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($iDelaycheckArmyCamp5) Then Return
	EndIf

	If $iTownHallLevel < 7 then return

	$iHeroAvailable = $HERO_NOHERO ; Reset hero available data
	$bFullArmyHero = False
	Local $debugArmyHeroCount = 0 ; local debug flag

	; Detection by OCR
	Local $sResult
	Local Const $HeroSlots[3][2] = [[464, 446], [526, 446], [588, 446]] ; Location of hero status check tile
	Local $sMessage = ""

	For $index = 0 To UBound($HeroSlots) - 1
		$sResult = ArmyHeroStatus($index) ; OCR slot for information
		If $sResult <> "" Then ; we found something, figure out what?
			Select
				Case StringInStr($sResult, "king", $STR_NOCASESENSEBASIC)
					Setlog(" - Barbarian King available", $COLOR_GREEN)
					$iHeroAvailable = BitOR($iHeroAvailable, $HERO_KING)
				Case StringInStr($sResult, "queen", $STR_NOCASESENSEBASIC)
					Setlog(" - Archer Queen available", $COLOR_GREEN)
					$iHeroAvailable = BitOR($iHeroAvailable, $HERO_QUEEN)
				Case StringInStr($sResult, "warden", $STR_NOCASESENSEBASIC)
					Setlog(" - Grand Warden available", $COLOR_GREEN)
					$iHeroAvailable = BitOR($iHeroAvailable, $HERO_WARDEN)
				Case StringInStr($sResult, "heal", $STR_NOCASESENSEBASIC)
					If $debugsetlogTrain = 1 Or $debugArmyHeroCount = 1 Then
						Switch $index
							Case 0
								$sMessage = "-Barbarian King"
							Case 1
								$sMessage = "-Archer Queen"
							Case 2
								$sMessage = "-Grand Warden"
							Case Else
								$sMessage = "-Very Bad Monkey Needs"
						EndSwitch
						SetLog("Hero slot#" & $index + 1 & $sMessage & " Healing", $COLOR_DEBUG) ;Debug
					EndIf
					If $index = 0 then Setlog(" - Barbarian King Recovering", $COLOR_ACTION)
					If $index = 1 then Setlog(" - Archer Queen Recovering", $COLOR_ACTION)
					If $index = 2 then Setlog(" - Grand Warden Recovering", $COLOR_ACTION)
				Case StringInStr($sResult, "upgrade", $STR_NOCASESENSEBASIC)
					Switch $index
						Case 0
							$sMessage = "-Barbarian King"
							; safety code to warn user when wait for hero found while being upgraded to reduce stupid user posts for not attacking
							If BitAND($iHeroAttack[$DB], $iHeroWait[$DB], $HERO_KING) = $HERO_KING Or BitAND($iHeroAttack[$LB], $iHeroWait[$LB], $HERO_KING) = $HERO_KING Then  ; check wait for hero status
								;$iHeroWait[$DB] = BitAND($iHeroWait[$DB], $HERO_QUEEN, $HERO_WARDEN) ; remove wait for king value with mask
								;$iHeroWait[$LB] = BitAND($iHeroWait[$LB], $HERO_QUEEN, $HERO_WARDEN)
								;GUICtrlSetState($chkDBKingWait, $GUI_UNCHECKED)  ; uncheck GUI box to show user wait for king not possible
								;GUICtrlSetState($chkABKingWait, $GUI_UNCHECKED)
								_GUI_Value_STATE("SHOW", $groupKingSleeping)  ; Show king sleeping icon
								SetLog("Warning: King Upgrading & Wait enabled, Disable Wait for King or may never attack!", $COLOR_RED)
							EndIf
						Case 1
							$sMessage = "-Archer Queen"
							; safety code
							If BitAND($iHeroAttack[$DB], $iHeroWait[$DB], $HERO_QUEEN) = $HERO_QUEEN Or BitAND($iHeroAttack[$LB], $iHeroWait[$LB], $HERO_QUEEN) = $HERO_QUEEN Then
								;$iHeroWait[$DB] = BitAND($iHeroWait[$DB], $HERO_KING, $HERO_WARDEN)
								;$iHeroWait[$LB] = BitAND($iHeroWait[$LB], $HERO_KING, $HERO_WARDEN)
								;GUICtrlSetState($chkDBQueenWait, $GUI_UNCHECKED)
								;GUICtrlSetState($chkABQueenWait, $GUI_UNCHECKED)
								_GUI_Value_STATE("SHOW", $groupQueenSleeping)
								SetLog("Warning: Queen Upgrading & Wait enabled, Disable Wait for Queen or may never attack!", $COLOR_RED)
							EndIf
						Case 2
							$sMessage = "-Grand Warden"
							; safety code
							If BitAND($iHeroAttack[$DB], $iHeroWait[$DB], $HERO_WARDEN) = $HERO_WARDEN Or BitAND($iHeroAttack[$LB], $iHeroWait[$LB], $HERO_WARDEN) = $HERO_WARDEN Then
								;$iHeroWait[$DB] = BitAND($iHeroWait[$DB], $HERO_KING, $HERO_QUEEN)
								;$iHeroWait[$LB] = BitAND($iHeroWait[$LB], $HERO_KING, $HERO_QUEEN)
								;GUICtrlSetState($chkDBWardenWait, $GUI_UNCHECKED)
								;GUICtrlSetState($chkABWardenWait, $GUI_UNCHECKED)
								_GUI_Value_STATE("SHOW", $groupWardenSleeping)
								SetLog("Warning: Warden Upgrading & Wait enabled, Disable Wait for Warden or may never attack!", $COLOR_RED)
							EndIf
						Case Else
							$sMessage = "-Need to Get Monkey"
					EndSwitch
					If $debugsetlogTrain = 1 Or $debugArmyHeroCount = 1 Then SetLog("Hero slot#" & $index + 1 & $sMessage & " Upgrade in Process", $COLOR_DEBUG) ;Debug
				Case StringInStr($sResult, "none", $STR_NOCASESENSEBASIC)
					If $debugsetlogTrain = 1 Or $debugArmyHeroCount = 1 Then SetLog("Hero slot#" & $index + 1 & " Empty, stop count", $COLOR_DEBUG) ;Debug
					ExitLoop ; when we find empty slots, done looking for heroes
				Case Else
					SetLog("Hero slot#" & $i + 1 & " bad OCR string returned!", $COLOR_RED)
			EndSelect
		Else
			SetLog("Hero slot#" & $index + 1 & " status read problem!", $COLOR_RED)
		EndIf
	Next

	If $iDBcheck = 0 then $iHeroWait[$DB] = $HERO_NOHERO
	If $iABcheck = 0 then $iHeroWait[$LB] = $HERO_NOHERO

	If (($iDBcheck = 1 and $iHeroWait[$DB]<= $iHeroAvailable) Or ($iABcheck = 1 and $iHeroWait[$LB]<= $iHeroAvailable)) Or _
			($iHeroWait[$DB] = $HERO_NOHERO And $iHeroWait[$LB] = $HERO_NOHERO) Then
		$bFullArmyHero = True
		If $debugsetlogTrain = 1 Or $debugArmyHeroCount = 1 Then SetLog("$bFullArmyHero= " & $bFullArmyHero, $COLOR_DEBUG) ;Debug
	EndIf

	If $debugsetlogTrain = 1 Or $debugArmyHeroCount = 1 Then SetLog("Hero Status K|Q|W : " & BitAND($iHeroAvailable, $HERO_KING) & "|" & BitAND($iHeroAvailable, $HERO_QUEEN) & "|" & BitAND($iHeroAvailable, $HERO_WARDEN), $COLOR_DEBUG) ;Debug

	If $bCloseArmyWindow = True Then
		ClickP($aAway, 1, 0, "#0000") ;Click Away
		If _Sleep($iDelaycheckArmyCamp4) Then Return
	EndIf

EndFunc   ;==>getArmyHeroCount
