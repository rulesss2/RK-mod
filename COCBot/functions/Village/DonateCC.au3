; #FUNCTION# ====================================================================================================================
; Name ..........: DonateCC
; Description ...: This file includes functions to Donate troops
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Zax (2015)
; Modified ......: Safar46 (2015), Hervidero (2015-04), HungLe (2015-04), Sardo (2015-08), Promac (2015-12), Hervidero (2016-01), MonkeyHunter (2016-07)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $DonationWindowY
Global $iTotalDonateCapacity, $iTotalDonateSpellCapacity
Global $iDonTroopsLimit, $iDonSpellsLimit, $iDonTroopsAv, $iDonSpellsAv
Global $iDonTroopsQuantityAv, $iDonTroopsQuantity, $iDonSpellsQuantityAv, $iDonSpellsQuantity
Global $bSkipDonTroops, $bSkipDonSpells

Func SetbDonateTrain()
	$bDonateTrain = BitOR(BitOR($iChkDonateBarbarians, $iChkDonateArchers, $iChkDonateGiants, $iChkDonateGoblins, _
			$iChkDonateWallBreakers, $iChkDonateBalloons, $iChkDonateWizards, $iChkDonateHealers, _
			$iChkDonateDragons, $iChkDonatePekkas, $iChkDonateBabyDragons, $iChkDonateMiners, $iChkDonateMinions, $iChkDonateHogRiders, _
			$iChkDonateValkyries, $iChkDonateGolems, $iChkDonateWitches, $iChkDonateLavaHounds, $iChkDonateBowlers, $iChkDonateCustomA, $iChkDonateCustomB), BitOR($iChkDonateAllBarbarians, $iChkDonateAllArchers, $iChkDonateAllGiants, $iChkDonateAllGoblins, _
			$iChkDonateAllWallBreakers, $iChkDonateAllBalloons, $iChkDonateAllWizards, $iChkDonateAllHealers, _
			$iChkDonateAllDragons, $iChkDonateAllPekkas, $iChkDonateAllBabyDragons, $iChkDonateAllMiners, $iChkDonateAllMinions, $iChkDonateAllHogRiders, _
			$iChkDonateAllValkyries, $iChkDonateAllGolems, $iChkDonateAllWitches, $iChkDonateAllLavaHounds, $iChkDonateAllBowlers, $iChkDonateAllCustomA, $iChkDonateAllCustomB), BitOR($iChkDonatePoisonSpells, $iChkDonateEarthQuakeSpells, $iChkDonateHasteSpells, $iChkDonateSkeletonSpells), BitOR($iChkDonateAllPoisonSpells, $iChkDonateAllEarthQuakeSpells, $iChkDonateAllHasteSpells, $iChkDonateAllSkeletonSpells))
EndFunc   ;==>SetbDonate

Func DonateCC($Check = False)

	Local $bDonateTroop = BitOR($iChkDonateBarbarians, $iChkDonateArchers, $iChkDonateGiants, $iChkDonateGoblins, _
			$iChkDonateWallBreakers, $iChkDonateBalloons, $iChkDonateWizards, $iChkDonateHealers, _
			$iChkDonateDragons, $iChkDonatePekkas, $iChkDonateBabyDragons, $iChkDonateMiners, $iChkDonateMinions, $iChkDonateHogRiders, _
			$iChkDonateValkyries, $iChkDonateGolems, $iChkDonateWitches, $iChkDonateLavaHounds, $iChkDonateBowlers, $iChkDonateCustomA, $iChkDonateCustomB)

	Local $bDonateAllTroop = BitOR($iChkDonateAllBarbarians, $iChkDonateAllArchers, $iChkDonateAllGiants, $iChkDonateAllGoblins, _
			$iChkDonateAllWallBreakers, $iChkDonateAllBalloons, $iChkDonateAllWizards, $iChkDonateAllHealers, _
			$iChkDonateAllDragons, $iChkDonateAllPekkas, $iChkDonateAllBabyDragons, $iChkDonateAllMiners, $iChkDonateAllMinions, $iChkDonateAllHogRiders, _
			$iChkDonateAllValkyries, $iChkDonateAllGolems, $iChkDonateAllWitches, $iChkDonateAllLavaHounds, $iChkDonateAllBowlers, $iChkDonateAllCustomA, $iChkDonateAllCustomB)

	Local $bDonateSpell = BitOR($iChkDonatePoisonSpells, $iChkDonateEarthQuakeSpells, $iChkDonateHasteSpells, $iChkDonateSkeletonSpells)
	Local $bDonateAllSpell = BitOR($iChkDonateAllPoisonSpells, $iChkDonateAllEarthQuakeSpells, $iChkDonateAllHasteSpells, $iChkDonateAllSkeletonSpells)
	Local $bOpen = True, $bClose = False

	Local $ClanString = ""

	$bDonate = BitOR($bDonateTroop, $bDonateAllTroop, $bDonateSpell, $bDonateAllSpell)
	$iDonTroopsLimit = 5
	$iDonSpellsLimit = 1
	$iDonTroopsAv = 0
	$iDonSpellsAv = 0
	$iDonTroopsQuantityAv = 0
	$iDonTroopsQuantity = 0
	$iDonSpellsQuantityAv = 0
	$iDonSpellsQuantity = 0

	$bSkipDonTroops = False
	$bSkipDonSpells = False

	;Global $bDonateAllRespectBlk = False ; is turned on off durning donate all section, must be false all other times
	; Global $aTimeTrain[0] = Remain Troops train time , minutes
	; Global $aTimeTrain[1] = Spells remain time , minutes
	; Global $aTimeTrain[2] = Remain time to Heroes recover , minutes

	If $bDonate = False Or $bDonationEnabled = False Then
		If $debugsetlog = 1 Then Setlog("Donate Clan Castle troops skip", $COLOR_DEBUG) ;Debug
		Return ; exit func if no donate checkmarks
	EndIf

	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
	If $iPlannedDonateHours[$hour[0]] = 0 And $iPlannedDonateHoursEnable = 1 Then
		If $debugsetlog = 1 Then SetLog("Donate Clan Castle troops not planned, Skipped..", $COLOR_DEBUG) ;Debug
		Return ; exit func if no planned donate checkmarks
	EndIf


	Local $y = 90
	;check for new chats first
	If $Check = True Then
		If _ColorCheck(_GetPixelColor(26, 312 + $midOffsetY, True), Hex(0xf00810, 6), 20) = False And $CommandStop <> 3 Then
			Return ;exit if no new chats
		EndIf
	EndIf
	;<---- opens clan tab and verbose in log
	ClickP($aAway, 1, 0, "#0167") ;Click Away

	ForceCaptureRegion()
	If _CheckPixel($aChatTab, $bCapturePixel) = False Then ClickP($aOpenChat, 1, 0, "#0168") ; Clicks chat tab
	If _Sleep($iDelayDonateCC4) Then Return

	Setlog("Checking for Donate Requests in Clan Chat", $COLOR_BLUE)

	Local $icount = 0
	While 1
		;If Clan tab is selected.
		If _ColorCheck(_GetPixelColor(189, 24, True), Hex(0x706C50, 6), 20) = True Then ; color med gray
			ExitLoop
		EndIf
		;If Global tab is selected.
		If _ColorCheck(_GetPixelColor(189, 24, True), Hex(0x383828, 6), 20) = True Then ; Darker gray
			If _Sleep($iDelayDonateCC1) Then Return
			ClickP($aClanTab, 1, 0, "#0169") ; clicking clan tab
			ExitLoop
		EndIf
		;counter for time approx 3 sec max allowed for tab to open
		$icount += 1
		If $icount >= 15 Then
			SetLog("Clan Chat Did Not Open - Abandon Donate")
			Return
		EndIf
		If _Sleep($iDelayDonateCC1) Then Return ; delay Allow 15x
	WEnd

	Local $Scroll
	While 1
		ForceCaptureRegion()
		;$Scroll = _PixelSearch(288, 640 + $bottomOffsetY, 290, 655 + $bottomOffsetY, Hex(0x588800, 6), 20)
		$y = 90
		$Scroll = _PixelSearch(293, 8 + $y, 295, 23 + $y, Hex(0xFFFFFF, 6), 20)
		If IsArray($Scroll) And _ColorCheck(_GetPixelColor(300, 110, True), Hex(0x509808, 6), 20) = True Then ; a second pixel for the green
			$bDonate = True
			Click($Scroll[0], $Scroll[1], 1, 0, "#0172")
			$y = 90
			If _Sleep($iDelayDonateCC2 + 100) Then ExitLoop
			ContinueLoop
		EndIf
		ExitLoop
	WEnd
	While $bDonate
		checkAttackDisable($iTaBChkIdle) ; Early Take-A-Break detection
		$ClanString = ""

		If _Sleep($iDelayDonateCC2) Then ExitLoop
		ForceCaptureRegion()
		$DonatePixel = _MultiPixelSearch(202, $y, 224, 660 + $bottomOffsetY, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 15)
		If IsArray($DonatePixel) Then ; if Donate Button found
			If $debugsetlog = 1 Then Setlog("$DonatePixel: (" & $DonatePixel[0] & "," & $DonatePixel[1] & ")", $COLOR_DEBUG) ;Debug

			;reset every run
			$bDonate = False ; donate only for one request at a time
			$bSkipDonTroops = False
			$bSkipDonSpells = False

			;Read chat request for DonateTroop and DonateSpell
			If $bDonateTroop Or $bDonateSpell Then
				If $ichkExtraAlphabets = 1 Then
					; Chat Request , Latin + Turkish + Extra latin + Cyrillic Alphabets / three paragraphs.
					$ClanString = ""
					$ClanString = getChatString(30, $DonatePixel[1] - 50, "coc-latin-cyr")
					If $ClanString = "" Then
						$ClanString = getChatString(30, $DonatePixel[1] - 36, "coc-latin-cyr")
					Else
						$ClanString &= " " & getChatString(30, $DonatePixel[1] - 36, "coc-latin-cyr")
					EndIf
					If $ClanString = "" Or $ClanString = " " Then
						$ClanString = getChatString(30, $DonatePixel[1] - 23, "coc-latin-cyr")
					Else
						$ClanString &= " " & getChatString(30, $DonatePixel[1] - 23, "coc-latin-cyr")
					EndIf
					If _Sleep($iDelayDonateCC2) Then ExitLoop
				Else
					; Chat Request , Latin + Turkish + Extra / three paragraphs.
					$ClanString = ""
					$ClanString = getChatString(30, $DonatePixel[1] - 50, "coc-latinA")
					If $ClanString = "" Then
						$ClanString = getChatString(30, $DonatePixel[1] - 36, "coc-latinA")
					Else
						$ClanString &= " " & getChatString(30, $DonatePixel[1] - 36, "coc-latinA")
					EndIf
					If $ClanString = "" Or $ClanString = " " Then
						$ClanString = getChatString(30, $DonatePixel[1] - 23, "coc-latinA")
					Else
						$ClanString &= " " & getChatString(30, $DonatePixel[1] - 23, "coc-latinA")
					EndIf
					If _Sleep($iDelayDonateCC2) Then ExitLoop
				EndIf

				If $ClanString = "" Or $ClanString = " " Then
					SetLog("Unable to read Chat Request!", $COLOR_RED)
					;					$bDonate = True
					$y = $DonatePixel[1] + 50
					ContinueLoop
				Else
					If $ichkExtraAlphabets = 1 Then
						ClipPut($ClanString)
						Local $tempClip = ClipGet()
						SetLog("Chat Request: " & $tempClip)
					Else
						SetLog("Chat Request: " & $ClanString)
					EndIf
				EndIf
			EndIf

			; Get remaining CC capacity of requested troops from your ClanMates
			RemainingCCcapacity()

			If $CurTotalDarkSpell = 0 And $FirstStart And $bDonateSpell Then
				SetLog("Getting total Spells Available To be ready for Donation...", $COLOR_BLUE)
				Click($aCloseChat[0], $aCloseChat[1], 1, 0, "#0173") ; required to close Chat tab
				If _Sleep(500) Then Return


				OpenArmyWindow()
				If _Sleep(250) Then Return
				CheckExistentArmy("Spells")
				CountNumberDarkSpells() ; needed value for spell donates
				ClickP($aAway, 2, 0, "#0346") ;Click Away
				If _Sleep(1000) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts
				SetLog("Total DElixir Spells Available and can be donated : " & $CurTotalDarkSpell, $COLOR_BLUE)
				ForceCaptureRegion()
				If _CheckPixel($aChatTab, $bCapturePixel) = False Then ClickP($aOpenChat, 1, 0, "#0168") ; Clicks chat tab
				If _Sleep($iDelayDonateCC4) Then Return

				$icount = 0
				While 1
					;If Clan tab is selected.
					If _ColorCheck(_GetPixelColor(189, 24, True), Hex(0x706C50, 6), 20) = True Then ExitLoop ; color med gray
					;If Global tab is selected.
					If _ColorCheck(_GetPixelColor(189, 24, True), Hex(0x383828, 6), 20) = True Then ; Darker gray
						If _Sleep($iDelayDonateCC1) Then Return ;small delay to allow tab to completely open
						ClickP($aClanTab, 1, 0, "#0169") ; clicking clan tab
						ExitLoop
					EndIf
					;counter for time approx 3 sec max allowed for tab to open
					$icount += 1
					If $icount >= 15 Then ; allows for up to a sleep of 3000
						SetLog("Clan Chat Did Not Open - Abandon Donate")
						Return
					EndIf
					If _Sleep($iDelayDonateCC1) Then Return ; delay Allow 15x
				WEnd

				While 1
					ForceCaptureRegion()
					;$Scroll = _PixelSearch(288, 640 + $bottomOffsetY, 290, 655 + $bottomOffsetY, Hex(0x588800, 6), 20)
					$y = 90
					$Scroll = _PixelSearch(293, 8 + $y, 295, 23 + $y, Hex(0xFFFFFF, 6), 20)
					If IsArray($Scroll) And _ColorCheck(_GetPixelColor(300, 110, True), Hex(0x509808, 6), 20) = True Then ; a second pixel for the green
						$bDonate = True
						Click($Scroll[0], $Scroll[1], 1, 0, "#0172")
						$y = 90
						If _Sleep($iDelayDonateCC2 + 100) Then ExitLoop
						ContinueLoop
					EndIf
					ExitLoop
				WEnd
			EndIf

			If $iTotalDonateCapacity <= 0 Then
				Setlog("Clan Castle troops are full, skip troop donation...", $COLOR_ORANGE)
				$bSkipDonTroops = True
			EndIf
			If $iTotalDonateSpellCapacity = 0 Then
				Setlog("Clan Castle spells are full, skip spell donation...", $COLOR_ORANGE)
				$bSkipDonSpells = True
			ElseIf $iTotalDonateSpellCapacity = -1 Then
				; no message, this CC has no Spell capability
				If $debugsetlog = 1 Then Setlog("This CC cannot accept spells, skip spell donation...", $COLOR_DEBUG) ;Debug

				$bSkipDonSpells = True
			ElseIf $CurTotalDarkSpell = 0 Then
				If $debugsetlog = 1 Then Setlog("No spells available, skip spell donation...", $COLOR_DEBUG) ;Debug
				Setlog("No spells available, skip spell donation...", $COLOR_ORANGE)
				$bSkipDonSpells = True
			EndIf

			If $bSkipDonTroops And $bSkipDonSpells Then
				$bDonate = True
				$y = $DonatePixel[1] + 50
				ContinueLoop ; go to next button if cant read Castle Troops and Spells before the donate window opens
			EndIf

			; open Donate Window
			If _Sleep(1000) Then Return
			If ($bSkipDonTroops = True And $bSkipDonSpells = True) Or DonateWindow($bOpen) = False Then
				$bDonate = True
				$y = $DonatePixel[1] + 50
				SetLog("Donate Window did not open - Exiting Donate", $COLOR_RED)
				ExitLoop ; Leave donate to prevent a bot hang condition
			EndIf

			If $bDonateTroop Or $bDonateSpell Then
				If $debugsetlog = 1 Then Setlog("Troop/Spell checkpoint.", $COLOR_DEBUG) ;Debug

				; read available donate cap, and ByRef set the $bSkipDonTroops and $bSkipDonSpells flags
				DonateWindowCap($bSkipDonTroops, $bSkipDonSpells)
				If $bSkipDonTroops And $bSkipDonSpells Then
					DonateWindow($bClose)
					$bDonate = True
					$y = $DonatePixel[1] + 50
					If _Sleep($iDelayDonateCC2) Then ExitLoop
					ContinueLoop ; go to next button if already donated, maybe this is an impossible case..
				EndIf

				If $bDonateTroop = 1 And $bSkipDonTroops = False Then
					If $debugsetlog = 1 Then Setlog("Troop checkpoint.", $COLOR_DEBUG) ;Debug

					;;; Custom Combination Donate by ChiefM3, edited by MonkeyHunter
					If $iChkDonateCustomA = 1 And CheckDonateTroop(19, $aDonCustomA, $aBlkCustomA, $aBlackList, $ClanString) Then
						For $i = 0 To 2
							If $varDonateCustomA[$i][0] < $eBarb Then
								$varDonateCustomA[$i][0] = $eArch ; Change strange small numbers to archer
							ElseIf $varDonateCustomA[$i][0] > $eBowl Then
								ContinueLoop ; If "Nothing" is selected then continue
							EndIf
							If $varDonateCustomA[$i][1] < 1 Then
								ContinueLoop ; If donate number is smaller than 1 then continue
							ElseIf $varDonateCustomA[$i][1] > 8 Then
								$varDonateCustomA[$i][1] = 8 ; Number larger than 8 is unnecessary
							EndIf
							DonateTroopType($varDonateCustomA[$i][0], $varDonateCustomA[$i][1], $iChkDonateCustomA) ;;; Donate Custom Troop using DonateTroopType2
						Next
					EndIf

					If $iChkDonateCustomB = 1 And CheckDonateTroop(19, $aDonCustomB, $aBlkCustomB, $aBlackList, $ClanString) Then
						For $i = 0 To 2
							If $varDonateCustomB[$i][0] < $eBarb Then
								$varDonateCustomB[$i][0] = $eArch ; Change strange small numbers to archer
							ElseIf $varDonateCustomB[$i][0] > $eBowl Then
								ContinueLoop ; If "Nothing" is selected then continue
							EndIf
							If $varDonateCustomB[$i][1] < 1 Then
								ContinueLoop ; If donate number is smaller than 1 then continue
							ElseIf $varDonateCustomB[$i][1] > 8 Then
								$varDonateCustomB[$i][1] = 8 ; Number larger than 8 is unnecessary
							EndIf
							DonateTroopType($varDonateCustomB[$i][0], $varDonateCustomB[$i][1], $iChkDonateCustomB) ;;; Donate Custom Troop using DonateTroopType2
						Next
					EndIf

					If $iChkDonateLavaHounds = 1 And $bSkipDonTroops = False And CheckDonateTroop($eLava, $aDonLavaHounds, $aBlkLavaHounds, $aBlackList, $ClanString, False) Then DonateTroopType($eLava)
					If $iChkDonateGolems = 1 And $bSkipDonTroops = False And CheckDonateTroop($eGole, $aDonGolems, $aBlkGolems, $aBlackList, $ClanString, False) Then DonateTroopType($eGole)
					If $iChkDonatePekkas = 1 And $bSkipDonTroops = False And CheckDonateTroop($ePekk, $aDonPekkas, $aBlkPekkas, $aBlackList, $ClanString, False) Then DonateTroopType($ePekk)
					If $iChkDonateDragons = 1 And $bSkipDonTroops = False And CheckDonateTroop($eDrag, $aDonDragons, $aBlkDragons, $aBlackList, $ClanString, False) Then DonateTroopType($eDrag)
					If $iChkDonateWitches = 1 And $bSkipDonTroops = False And CheckDonateTroop($eWitc, $aDonWitches, $aBlkWitches, $aBlackList, $ClanString, False) Then DonateTroopType($eWitc)
					If $iChkDonateHealers = 1 And $bSkipDonTroops = False And CheckDonateTroop($eHeal, $aDonHealers, $aBlkHealers, $aBlackList, $ClanString, False) Then DonateTroopType($eHeal)
					If $iChkDonateBabyDragons = 1 And $bSkipDonTroops = False And CheckDonateTroop($eBabyD, $aDonBabyDragons, $aBlkBabyDragons, $aBlackList, $ClanString, False) Then DonateTroopType($eBabyD)
					If $iChkDonateValkyries = 1 And $bSkipDonTroops = False And CheckDonateTroop($eValk, $aDonValkyries, $aBlkValkyries, $aBlackList, $ClanString, False) Then DonateTroopType($eValk)
					If $iChkDonateBowlers = 1 And $bSkipDonTroops = False And CheckDonateTroop($eBowl, $aDonBowlers, $aBlkBowlers, $aBlackList, $ClanString, False) Then DonateTroopType($eBowl)
					If $iChkDonateMiners = 1 And $bSkipDonTroops = False And CheckDonateTroop($eMine, $aDonMiners, $aBlkMiners, $aBlackList, $ClanString, False) Then DonateTroopType($eMine)
					If $iChkDonateGiants = 1 And $bSkipDonTroops = False And CheckDonateTroop($eGiant, $aDonGiants, $aBlkGiants, $aBlackList, $ClanString, False) Then DonateTroopType($eGiant)
					If $iChkDonateBalloons = 1 And $bSkipDonTroops = False And CheckDonateTroop($eBall, $aDonBalloons, $aBlkBalloons, $aBlackList, $ClanString, False) Then DonateTroopType($eBall)
					If $iChkDonateHogRiders = 1 And $bSkipDonTroops = False And CheckDonateTroop($eHogs, $aDonHogRiders, $aBlkHogRiders, $aBlackList, $ClanString, False) Then DonateTroopType($eHogs)
					If $iChkDonateWizards = 1 And $bSkipDonTroops = False And CheckDonateTroop($eWiza, $aDonWizards, $aBlkWizards, $aBlackList, $ClanString, False) Then DonateTroopType($eWiza)
					If $iChkDonateWallBreakers = 1 And $bSkipDonTroops = False And CheckDonateTroop($eWall, $aDonWallBreakers, $aBlkWallBreakers, $aBlackList, $ClanString, False) Then DonateTroopType($eWall)
					If $iChkDonateMinions = 1 And $bSkipDonTroops = False And CheckDonateTroop($eMini, $aDonMinions, $aBlkMinions, $aBlackList, $ClanString, False) Then DonateTroopType($eMini)
					If $iChkDonateArchers = 1 And $bSkipDonTroops = False And CheckDonateTroop($eArch, $aDonArchers, $aBlkArchers, $aBlackList, $ClanString, False) Then DonateTroopType($eArch)
					If $iChkDonateBarbarians = 1 And $bSkipDonTroops = False And CheckDonateTroop($eBarb, $aDonBarbarians, $aBlkBarbarians, $aBlackList, $ClanString, False) Then DonateTroopType($eBarb)
					If $iChkDonateGoblins = 1 And $bSkipDonTroops = False And CheckDonateTroop($eGobl, $aDonGoblins, $aBlkGoblins, $aBlackList, $ClanString, False) Then DonateTroopType($eGobl)

				EndIf

				If $bDonateSpell = 1 And $bSkipDonSpells = False Then
					If $debugsetlog = 1 Then Setlog("Spell checkpoint.", $COLOR_DEBUG) ;Debug
					If $iChkDonatePoisonSpells = 1 And $bSkipDonSpells = False And CheckDonateTroop($ePSpell, $aDonPoisonSpells, $aBlkPoisonSpells, $aBlackList, $ClanString, False) Then DonateTroopType($ePSpell)
					If $iChkDonateEarthQuakeSpells = 1 And $bSkipDonSpells = False And CheckDonateTroop($eESpell, $aDonEarthQuakeSpells, $aBlkEarthQuakeSpells, $aBlackList, $ClanString, False) Then DonateTroopType($eESpell)
					If $iChkDonateHasteSpells = 1 And $bSkipDonSpells = False And CheckDonateTroop($eHaSpell, $aDonHasteSpells, $aBlkHasteSpells, $aBlackList, $ClanString, False) Then DonateTroopType($eHaSpell)
					If $iChkDonateSkeletonSpells = 1 And $bSkipDonSpells = False And CheckDonateTroop($eSkSpell, $aDonSkeletonSpells, $aBlkSkeletonSpells, $aBlackList, $ClanString, False) Then DonateTroopType($eSkSpell)
				EndIf
			EndIf

			If $bDonateAllTroop Or $bDonateAllSpell Then

				; read available donate cap, and ByRef set the $bSkipDonTroops and $bSkipDonSpells flags
				DonateWindowCap($bSkipDonTroops, $bSkipDonSpells)
				If $bSkipDonTroops And $bSkipDonSpells Then
					DonateWindow($bClose)
					$bDonate = True
					$y = $DonatePixel[1] + 50
					If _Sleep($iDelayDonateCC2) Then ExitLoop
					ContinueLoop ; go to next button if already donated, maybe this is an impossible case..
				EndIf

				If $debugsetlog = 1 Then Setlog("Troop/Spell All checkpoint.", $COLOR_DEBUG) ;Debug

				$bDonateAllRespectBlk = True

				If $bDonateAllTroop And $bSkipDonTroops = False Then

					If $debugsetlog = 1 Then Setlog("Troop All checkpoint.", $COLOR_DEBUG) ;Debug
					Select
						Case $iChkDonateAllCustomA = 1
							For $i = 0 To 2
								If $varDonateCustomA[$i][0] < $eBarb Then
									$varDonateCustomA[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $varDonateCustomA[$i][0] > $eBowl Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $DonatePixel[1] + 50
									If _Sleep($iDelayDonateCC2) Then ExitLoop
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $varDonateCustomA[$i][1] < 1 Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $DonatePixel[1] + 50
									If _Sleep($iDelayDonateCC2) Then ExitLoop
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $varDonateCustomA[$i][1] > 8 Then
									$varDonateCustomA[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($varDonateCustomA[$i][0], $varDonateCustomA[$i][1], $iChkDonateAllCustomA, $bDonateAllTroop) ;;; Donate Custom Troop using DonateTroopType2
							Next
						Case $iChkDonateAllCustomB = 1
							For $i = 0 To 2
								If $varDonateCustomB[$i][0] < $eBarb Then
									$varDonateCustomB[$i][0] = $eArch ; Change strange small numbers to archer
								ElseIf $varDonateCustomB[$i][0] > $eBowl Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $DonatePixel[1] + 50
									If _Sleep($iDelayDonateCC2) Then ExitLoop
									ContinueLoop ; If "Nothing" is selected then continue
								EndIf
								If $varDonateCustomB[$i][1] < 1 Then
									DonateWindow($bClose)
									$bDonate = True
									$y = $DonatePixel[1] + 50
									If _Sleep($iDelayDonateCC2) Then ExitLoop
									ContinueLoop ; If donate number is smaller than 1 then continue
								ElseIf $varDonateCustomB[$i][1] > 8 Then
									$varDonateCustomB[$i][1] = 8 ; Number larger than 8 is unnecessary
								EndIf
								DonateTroopType($varDonateCustomB[$i][0], $varDonateCustomB[$i][1], $iChkDonateAllCustomB, $bDonateAllTroop) ;;; Donate Custom Troop using DonateTroopType2
							Next
						Case $iChkDonateAllLavaHounds = 1
							If CheckDonateTroop($eLava, $aDonLavaHounds, $aBlkLavaHounds, $aBlackList, $ClanString, True) Then DonateTroopType($eLava, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllGolems = 1
							If CheckDonateTroop($eGole, $aDonGolems, $aBlkGolems, $aBlackList, $ClanString, True) Then DonateTroopType($eGole, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllPekkas = 1
							If CheckDonateTroop($ePekk, $aDonPekkas, $aBlkPekkas, $aBlackList, $ClanString, True) Then DonateTroopType($ePekk, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllDragons = 1
							If CheckDonateTroop($eDrag, $aDonDragons, $aBlkDragons, $aBlackList, $ClanString, True) Then DonateTroopType($eDrag, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllWitches = 1
							If CheckDonateTroop($eWitc, $aDonWitches, $aBlkWitches, $aBlackList, $ClanString, True) Then DonateTroopType($eWitc, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllHealers = 1
							If CheckDonateTroop($eHeal, $aDonHealers, $aBlkHealers, $aBlackList, $ClanString, True) Then DonateTroopType($eHeal, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllBabyDragons = 1
							If CheckDonateTroop($eBabyD, $aDonBabyDragons, $aBlkBabyDragons, $aBlackList, $ClanString, True) Then DonateTroopType($eBabyD, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllValkyries = 1
							If CheckDonateTroop($eValk, $aDonValkyries, $aBlkValkyries, $aBlackList, $ClanString, True) Then DonateTroopType($eValk, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllBowlers = 1
							If CheckDonateTroop($eBowl, $aDonBowlers, $aBlkBowlers, $aBlackList, $ClanString, True) Then DonateTroopType($eBowl, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllMiners = 1
							If CheckDonateTroop($eMine, $aDonMiners, $aBlkMiners, $aBlackList, $ClanString, True) Then DonateTroopType($eMine, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllGiants = 1
							If CheckDonateTroop($eGiant, $aDonGiants, $aBlkGiants, $aBlackList, $ClanString, True) Then DonateTroopType($eGiant, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllBalloons = 1
							If CheckDonateTroop($eBall, $aDonBalloons, $aBlkBalloons, $aBlackList, $ClanString, True) Then DonateTroopType($eBall, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllHogRiders = 1
							If CheckDonateTroop($eHogs, $aDonHogRiders, $aBlkHogRiders, $aBlackList, $ClanString, True) Then DonateTroopType($eHogs, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllWizards = 1
							If CheckDonateTroop($eWiza, $aDonWizards, $aBlkWizards, $aBlackList, $ClanString, True) Then DonateTroopType($eWiza, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllWallBreakers = 1
							If CheckDonateTroop($eWall, $aDonWallBreakers, $aBlkWallBreakers, $aBlackList, $ClanString, True) Then DonateTroopType($eWall, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllMinions = 1
							If CheckDonateTroop($eMini, $aDonMinions, $aBlkMinions, $aBlackList, $ClanString, True) Then DonateTroopType($eMini, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllBarbarians = 1
							If CheckDonateTroop($eBarb, $aDonBarbarians, $aBlkBarbarians, $aBlackList, $ClanString, True) Then DonateTroopType($eBarb, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllArchers = 1
							If CheckDonateTroop($eArch, $aDonArchers, $aBlkArchers, $aBlackList, $ClanString, True) Then DonateTroopType($eArch, 0, False, $bDonateAllTroop)
						Case $iChkDonateAllGoblins = 1
							If CheckDonateTroop($eGobl, $aDonGoblins, $aBlkGoblins, $aBlackList, $ClanString, True) Then DonateTroopType($eGobl, 0, False, $bDonateAllTroop)
					EndSelect
				EndIf

				If $bDonateAllSpell And $bSkipDonSpells = False Then
					If $debugsetlog = 1 Then Setlog("Spell All checkpoint.", $COLOR_DEBUG) ;Debug

					Select
						Case $iChkDonateAllPoisonSpells = 1
							If CheckDonateTroop($ePSpell, $aDonPoisonSpells, $aBlkPoisonSpells, $aBlackList, $ClanString, True) Then DonateTroopType($ePSpell, 0, False, $bDonateAllSpell)
						Case $iChkDonateAllEarthQuakeSpells = 1
							If CheckDonateTroop($eESpell, $aDonEarthQuakeSpells, $aBlkEarthQuakeSpells, $aBlackList, $ClanString, True) Then DonateTroopType($eESpell, 0, False, $bDonateAllSpell)
						Case $iChkDonateAllHasteSpells = 1
							If CheckDonateTroop($eHaSpell, $aDonHasteSpells, $aBlkHasteSpells, $aBlackList, $ClanString, True) Then DonateTroopType($eHaSpell, 0, False, $bDonateAllSpell)
						Case $iChkDonateAllSkeletonSpells = 1
							If CheckDonateTroop($eSkSpell, $aDonSkeletonSpells, $aBlkSkeletonSpells, $aBlackList, $ClanString, True) Then DonateTroopType($eSkSpell, 0, False, $bDonateAllSpell)
					EndSelect
				EndIf
				$bDonateAllRespectBlk = False
			EndIf

			;close Donate Window
			DonateWindow($bClose)

			$bDonate = True
			$y = $DonatePixel[1] + 50
			ClickP($aAway, 1, 0, "#0171")
			If _Sleep($iDelayDonateCC2) Then ExitLoop
		EndIf
		;ck for more donate buttons
		ForceCaptureRegion()
		$DonatePixel = _MultiPixelSearch(202, $y, 224, 660 + $bottomOffsetY, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 15)
		If IsArray($DonatePixel) Then
			If $debugsetlog = 1 Then Setlog("More Donate buttons found, new $DonatePixel: (" & $DonatePixel[0] & "," & $DonatePixel[1] & ")", $COLOR_DEBUG) ;Debug
			ContinueLoop
		Else
			If $debugsetlog = 1 Then Setlog("No more Donate buttons found, closing chat ($y=" & $y & ")", $COLOR_DEBUG) ;Debug
		EndIf
		; Scroll Down

		ForceCaptureRegion()
		;$Scroll = _PixelSearch(288, 640 + $bottomOffsetY, 290, 655 + $bottomOffsetY, Hex(0x588800, 6), 20)
		;$y = 90
		;$Scroll = _PixelSearch(293, 8 + $y, 295, 23 + $y, Hex(0xFFFFFF, 6), 20)
		$Scroll = _PixelSearch(293, 687 - 30, 295, 693 - 30, Hex(0xFFFFFF, 6), 20)


		If IsArray($Scroll) Then
			$bDonate = True
			Click($Scroll[0], $Scroll[1], 1, 0, "#0172")
			$y = 600

			If _Sleep($iDelayDonateCC2) Then ExitLoop
			ContinueLoop
		EndIf
		$bDonate = False
	WEnd

	ClickP($aAway, 1, 0, "#0176") ; click away any possible open window
	If _Sleep($iDelayDonateCC2) Then Return

	$i = 0
	While 1
		If _Sleep(100) Then Return
		If _ColorCheck(_GetPixelColor($aCloseChat[0], $aCloseChat[1], True), Hex($aCloseChat[2], 6), $aCloseChat[3]) Then
			; Clicks chat thing
			Click($aCloseChat[0], $aCloseChat[1], 1, 0, "#0173") ;Clicks chat thing
			ExitLoop
		Else
			If _Sleep(100) Then Return
			$i += 1
			If $i > 30 Then
				SetLog("Error finding Clan Tab to close...", $COLOR_RED)
				ExitLoop
			EndIf
		EndIf
	WEnd

	;SetLog("------End Donate-----------")
	If _Sleep($iDelayDonateCC2) Then Return

EndFunc   ;==>DonateCC

Func CheckDonateTroop($Type, $aDonTroop, $aBlkTroop, $aBlackList, $ClanString, $bDonateAllRespectBlk = False)

	For $i = 1 To UBound($aBlackList) - 1
		If CheckDonateString($aBlackList[$i], $ClanString) Then
			SetLog("General Blacklist Keyword found: " & $aBlackList[$i], $COLOR_RED)
			Return False
		EndIf
	Next

	For $i = 1 To UBound($aBlkTroop) - 1
		If CheckDonateString($aBlkTroop[$i], $ClanString) Then
			If $Type = 19 Then
				Setlog("Custom Blacklist Keyword found: " & $aBlkTroop[$i], $COLOR_RED)
			Else
				SetLog(NameOfTroop($Type) & " Blacklist Keyword found: " & $aBlkTroop[$i], $COLOR_RED)
			EndIf
			Return False
		EndIf
	Next

	If $bDonateAllRespectBlk = True Then Return True
	; Return here true black lists were tested and if this far... good to donate to all

	For $i = 1 To UBound($aDonTroop) - 1
		If CheckDonateString($aDonTroop[$i], $ClanString) Then
			If $Type = 19 Then
				Setlog("Custom Donation Keyword found: " & $aDonTroop[$i], $COLOR_GREEN)
			Else
				Setlog(NameOfTroop($Type) & " Keyword found: " & $aDonTroop[$i], $COLOR_GREEN)
			EndIf
			Return True
		EndIf
	Next


	If $debugsetlog = 1 Then Setlog("Bad call of CheckDonateTroop:" & $Type & "=" & NameOfTroop($Type), $COLOR_DEBUG) ;Debug

	Return False
EndFunc   ;==>CheckDonateTroop

Func CheckDonateString($String, $ClanString) ;Checks if exact
	Local $Contains = StringMid($String, 1, 1) & StringMid($String, StringLen($String), 1)

	If $Contains = "[]" Then
		If $ClanString = StringMid($String, 2, StringLen($String) - 2) Then
			Return True
		Else
			Return False
		EndIf
	Else
		If StringInStr($ClanString, $String, 2) Then
			Return True
		Else
			Return False
		EndIf
	EndIf
EndFunc   ;==>CheckDonateString

Func DonateTroopType($Type, $Quant = 0, $Custom = False, $bDonateAll = False)

	If $debugsetlog = 1 Then Setlog("$DonateTroopType Start: " & NameOfTroop($Type), $COLOR_DEBUG) ;Debug

	Local $Slot = -1, $YComp = 0, $sTextToAll = ""
	Local $detectedSlot = -1
	Local $donaterow = -1 ;( =3 for spells)
	Local $donateposinrow = -1

	If $iTotalDonateCapacity = 0 And $iTotalDonateSpellCapacity = 0 Then Return

	If $Type >= $eBarb And $Type <= $eBowl Then
		;troops
		For $i = 0 To UBound($TroopName) - 1
			If Eval("e" & $TroopName[$i]) = $Type Then
				$iDonTroopsQuantityAv = Floor($iTotalDonateCapacity / $TroopHeight[$i])
				If $iDonTroopsQuantityAv < 1 Then
					Setlog("Sorry Chief! " & NameOfTroop($Type, 1) & " don't fit in the remaining space!")
					Return
				EndIf
				If $iDonTroopsQuantityAv >= $iDonTroopsLimit Then
					$iDonTroopsQuantity = $iDonTroopsLimit
				Else
					$iDonTroopsQuantity = $iDonTroopsQuantityAv
				EndIf
			EndIf
		Next

		For $i = 0 To UBound($TroopDarkName) - 1
			If Eval("e" & $TroopDarkName[$i]) = $Type Then
				$iDonTroopsQuantityAv = Floor($iTotalDonateCapacity / $TroopDarkHeight[$i])
				If $iDonTroopsQuantityAv < 1 Then
					Setlog("Sorry Chief! " & NameOfTroop($Type, 1) & " don't fit in the remaining space!")
					Return
				EndIf
				If $iDonTroopsQuantityAv >= $iDonTroopsLimit Then
					$iDonTroopsQuantity = $iDonTroopsLimit
				Else
					$iDonTroopsQuantity = $iDonTroopsQuantityAv
				EndIf
			EndIf
		Next
	EndIf

	If $Type >= $ePSpell And $Type <= $eSkSpell Then
		;spells
		For $i = 0 To UBound($SpellName) - 1
			If Eval("e" & $SpellName[$i]) = $Type Then
				$iDonSpellsQuantityAv = Floor($iTotalDonateSpellCapacity / $SpellHeight[$i])
				If $iDonSpellsQuantityAv < 1 Then
					Setlog("Sorry Chief! " & NameOfTroop($Type, 1) & " don't fit in the remaining space!")
					Return
				EndIf
				If $iDonSpellsQuantityAv >= $iDonSpellsLimit Then
					$iDonSpellsQuantity = $iDonSpellsLimit
				Else
					$iDonSpellsQuantity = $iDonSpellsQuantityAv
				EndIf
			EndIf
		Next
	EndIf

	; Detect the Troops Slot
	If $debugOCRdonate = 1 Then
		Local $oldDebugOcr = $debugOcr
		$debugOcr = 1
	EndIf
	$Slot = DetectSlotTroop($Type)
	$detectedSlot = $Slot
	If $debugsetlog = 1 Then setlog("slot found = " & $Slot, $COLOR_DEBUG) ;Debug
	If $debugOCRdonate = 1 Then $debugOcr = $oldDebugOcr

	If $Slot = -1 Then Return

	$donaterow = 1 ;first row of trrops
	$donateposinrow = $Slot
	If $Slot >= 6 And $Slot <= 11 Then
		$donaterow = 2 ;second row of troops
		$Slot = $Slot - 6
		$donateposinrow = $Slot
		$YComp = 88 ; correct 860x780
	EndIf

	If $Slot >= 12 And $Slot <= 14 Then
		$donaterow = 3 ;row of poisons
		$Slot = $Slot - 12
		$donateposinrow = $Slot
		$YComp = 203 ; correct 860x780
	EndIf

	If $YComp <> 203 Then ; troops
		; Verify if the type of troop to donate exists
		If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
				_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
				_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'
			Local $plural = 0
			If $Custom Then
				If $Quant > 1 Then $plural = 1

				If $bDonateAll Then $sTextToAll = " (to all requests)"
				SetLog("Donating " & $Quant & " " & NameOfTroop($Type, $plural) & $sTextToAll, $COLOR_GREEN)
				If $debugOCRdonate = 1 Then
					Setlog("donate", $color_RED)
					Setlog("row: " & $donaterow, $color_RED)
					Setlog("pos in row: " & $donateposinrow, $color_red)
					setlog("coordinate: " & 365 + ($Slot * 68) & "," & $DonationWindowY + 100 + $YComp, $color_red)
					debugimagesave("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & NameOfTroop($Type) & "_")
				EndIf

				If $debugOCRdonate = 0 Then
					; Use slow clikc when the Train system is Quicktrain
					If $ichkUseQTrain = 1 Then
						$icount = 0
						For $x = 0 To $Quant
							If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
									_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
									_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'
								Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, 1, $iDelayDonateCC3, "#0175")
								If $CommandStop = 3 Then
									$CommandStop = 0
									$fullArmy = False
								EndIf
								If _Sleep(1000) Then Return
								$icount += 1
							EndIf
						Next
						$Quant = $icount ; Count Troops Donated Clicks
						;						DonatedTroop($Type, $Quant)
					Else
						If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
								_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
								_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'
							Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $Quant, $iDelayDonateCC3, "#0175")
							;							DonatedTroop($Type, $Quant)
							If $CommandStop = 3 Then
								$CommandStop = 0
								$fullArmy = False
							EndIf
						EndIf
					EndIf

					If $bDonateAll Then $sTextToAll = " (to all requests)"
					SetLog("Donating " & $Quant & " " & NameOfTroop($Type, $plural) & $sTextToAll, $COLOR_GREEN)
					DonatedTroop($Type, $Quant)
					; Adjust Values for donated troops to prevent a Double ghost donate to stats and train
					If $Type >= $eBarb And $Type <= $eBowl Then
						For $i = 0 To UBound($TroopName) - 1
							If Eval("e" & $TroopName[$i]) = $Type Then
								;Reduce iTotalDonateCapacity by troops donated
								$iTotalDonateCapacity = $iTotalDonateCapacity - ($Quant * $TroopHeight[$i])
								;If donated max allowed troop qty set $bSkipDonTroops = True
								If $iDonTroopsLimit = $Quant Then
									$bSkipDonTroops = True
								EndIf
							EndIf
						Next
						;Dark Troops
						For $i = 0 To UBound($TroopDarkName) - 1
							If Eval("e" & $TroopDarkName[$i]) = $Type Then
								;Reduce iTotalDonateCapacity by troops donated
								$iTotalDonateCapacity = $iTotalDonateCapacity - ($Quant * $TroopDarkHeight[$i])
								;If donated max allowed troop qty set $bSkipDonTroops = True
								If $iDonTroopsLimit = $Quant Then
									$bSkipDonTroops = True
								EndIf
							EndIf
						Next
					EndIf
				EndIf

			Else
				If $iDonTroopsQuantity > 1 Then $plural = 1
				If $debugOCRdonate = 1 Then
					Setlog("donate", $color_RED)
					Setlog("row: " & $donaterow, $color_RED)
					Setlog("pos in row: " & $donateposinrow, $color_red)
					setlog("coordinate: " & 365 + ($Slot * 68) & "," & $DonationWindowY + 100 + $YComp, $color_red)
					debugimagesave("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & NameOfTroop($Type) & "_")
				EndIf
				If $debugOCRdonate = 0 Then
					; Use slow clikc when the Train system is Quicktrain
					If $ichkUseQTrain = 1 Then
						$icount = 0
						For $x = 0 To $iDonTroopsQuantity
							If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
									_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
									_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'
								Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, 1, $iDelayDonateCC3, "#0175")
								$icount += 1
								If $CommandStop = 3 Then
									$CommandStop = 0
									$fullArmy = False
								EndIf
								If _Sleep(1000) Then Return
							EndIf
						Next
						$iDonTroopsQuantity = $icount ; Count Troops Donated Clicks
						;						DonatedTroop($Type,$iDonTroopsQuantity)
					Else
						If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
								_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x306ca8, 6), 20) Or _
								_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x306ca8, 6), 20) Then ; check for 'blue'
							Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $iDonTroopsQuantity, $iDelayDonateCC3, "#0175")
							;							DonatedTroop($Type, $iDonTroopsQuantity)
							If $CommandStop = 3 Then
								$CommandStop = 0
								$fullArmy = False
							EndIf
						EndIf
					EndIf

					If $bDonateAll Then $sTextToAll = " (to all requests)"
					SetLog("Donating " & $iDonTroopsQuantity & " " & NameOfTroop($Type, $plural) & $sTextToAll, $COLOR_GREEN)
					DonatedTroop($Type, $iDonTroopsQuantity)
					; Adjust Values for donated troops to prevent a Double ghost donate to stats and train
					If $Type >= $eBarb And $Type <= $eBowl Then
						For $i = 0 To UBound($TroopName) - 1
							If Eval("e" & $TroopName[$i]) = $Type Then
								;Reduce iTotalDonateCapacity by troops donated
								$iTotalDonateCapacity = $iTotalDonateCapacity - ($iDonTroopsQuantity * $TroopHeight[$i])
								;If donated max allowed troop qty set $bSkipDonTroops = True
								If $iDonTroopsLimit = $iDonTroopsQuantity Then
									$bSkipDonTroops = True
								EndIf
							EndIf
						Next
						;Dark Troops
						For $i = 0 To UBound($TroopDarkName) - 1
							If Eval("e" & $TroopDarkName[$i]) = $Type Then
								;Reduce iTotalDonateCapacity by troops donated
								$iTotalDonateCapacity = $iTotalDonateCapacity - ($iDonTroopsQuantity * $TroopDarkHeight[$i])
								;If donated max allowed troop qty set $bSkipDonTroops = True
								If $iDonTroopsLimit = $iDonTroopsQuantity Then
									$bSkipDonTroops = True
								EndIf
							EndIf
						Next
					EndIf
				EndIf
			EndIf

			$bDonate = True

			; Assign the donated quantity troops to train : $Don $TroopName
			If $ichkUseQTrain = 1 Then
				If $Custom Then
					For $i = 0 To UBound($TroopName) - 1
						If Eval("e" & $TroopName[$i]) = $Type Then
							Assign("Don" & $TroopName[$i], Eval("Don" & $TroopName[$i]) + $Quant)
						EndIf
					Next
					For $i = 0 To UBound($TroopDarkName) - 1
						If Eval("e" & $TroopDarkName[$i]) = $Type Then
							Assign("Don" & $TroopDarkName[$i], Eval("Don" & $TroopDarkName[$i]) + $Quant)
						EndIf
					Next
				Else
					For $i = 0 To UBound($TroopName) - 1
						If Eval("e" & $TroopName[$i]) = $Type Then
							Assign("Don" & $TroopName[$i], Eval("Don" & $TroopName[$i]) + $iDonTroopsQuantity)
						EndIf
					Next
					For $i = 0 To UBound($TroopDarkName) - 1
						If Eval("e" & $TroopDarkName[$i]) = $Type Then
							Assign("Don" & $TroopDarkName[$i], Eval("Don" & $TroopDarkName[$i]) + $iDonTroopsQuantity)
						EndIf
					Next
				EndIf
			EndIf


		ElseIf $DonatePixel[1] - 5 + $YComp > 675 Then
			Setlog("Unable to donate " & NameOfTroop($Type) & ". Donate screen not visible, will retry next run.", $COLOR_RED)
		Else
			SetLog("No " & NameOfTroop($Type) & " available to donate..", $COLOR_RED)
		EndIf
	Else ; spells
		SetLog("Else Spells Condition Matched", $COLOR_ORANGE)
		If _ColorCheck(_GetPixelColor(350 + ($Slot * 68), $DonationWindowY + 105 + $YComp, True), Hex(0x6038B0, 6), 20) Or _
				_ColorCheck(_GetPixelColor(355 + ($Slot * 68), $DonationWindowY + 106 + $YComp, True), Hex(0x6038B0, 6), 20) Or _
				_ColorCheck(_GetPixelColor(360 + ($Slot * 68), $DonationWindowY + 107 + $YComp, True), Hex(0x6038B0, 6), 20) Then ; check for 'purple'
			If $bDonateAll Then $sTextToAll = " (to all requests)"
			;SetLog("Else Spell Colors Conditions Matched ALSO", $COLOR_ORANGE)
			;SetLog("Donating " & $iDonSpellsQuantity & " " & NameOfTroop($Type) & $sTextToAll, $COLOR_GREEN)
			;Setlog("click donate")
			If $debugOCRdonate = 1 Then
				Setlog("donate", $color_RED)
				Setlog("row: " & $donaterow, $color_RED)
				Setlog("pos in row: " & $donateposinrow, $color_red)
				setlog("coordinate: " & 365 + ($Slot * 68) & "," & $DonationWindowY + 100 + $YComp, $color_red)
				debugimagesave("LiveDonateCC-r" & $donaterow & "-c" & $donateposinrow & "-" & NameOfTroop($Type) & "_")
			EndIf
			If $debugOCRdonate = 0 Then
				Click(365 + ($Slot * 68), $DonationWindowY + 100 + $YComp, $iDonSpellsQuantity, $iDelayDonateCC3, "#0600")
				$bFullArmySpells = False
				$fullArmy = False
				For $i = 0 To UBound($SpellName) - 1
					If Eval("e" & $SpellName[$i]) = $Type Then
						Assign("Don" & $SpellName[$i], Eval("Don" & $SpellName[$i]) + 1)
					EndIf
				Next
				If $CommandStop = 3 Then
					$CommandStop = 0
					$bFullArmySpells = False
				EndIf
				DonatedSpell($Type, $iDonSpellsQuantity)
			EndIf

			$bDonate = True

		ElseIf $DonatePixel[1] - 5 + $YComp > 675 Then
			Setlog("Unable to donate " & NameOfTroop($Type) & ". Donate screen not visible, will retry next run.", $COLOR_RED)
		Else
			SetLog("No " & NameOfTroop($Type) & " available to donate..", $COLOR_RED)
		EndIf
	EndIf

EndFunc   ;==>DonateTroopType

Func DonateWindow($Open = True)
	If $debugsetlog = 1 And $Open = True Then Setlog("DonateWindow Open Start", $COLOR_DEBUG) ;Debug
	If $debugsetlog = 1 And $Open = False Then Setlog("DonateWindow Close Start", $COLOR_DEBUG) ;Debug

	If $Open = False Then ; close window and exit
		ClickP($aAway, 1, 0, "#0176")
		If _Sleep($iDelayDonateWindow1) Then Return
		If $debugsetlog = 1 Then Setlog("DonateWindow Close Exit", $COLOR_DEBUG) ;Debug
		Return
	EndIf

	; Click on Donate Button and wait for the window
	Local $iLeft = 0, $iTop = 0, $iRight = 0, $iBottom = 0, $i
	For $i = 0 To UBound($aChatDonateBtnColors) - 1
		If $aChatDonateBtnColors[$i][1] < $iLeft Then $iLeft = $aChatDonateBtnColors[$i][1]
		If $aChatDonateBtnColors[$i][1] > $iRight Then $iRight = $aChatDonateBtnColors[$i][1]
		If $aChatDonateBtnColors[$i][2] < $iTop Then $iTop = $aChatDonateBtnColors[$i][2]
		If $aChatDonateBtnColors[$i][2] > $iBottom Then $iBottom = $aChatDonateBtnColors[$i][2]
	Next
	$iLeft += $DonatePixel[0]
	$iTop += $DonatePixel[1]
	$iRight += $DonatePixel[0] + 1
	$iBottom += $DonatePixel[1] + 1
	ForceCaptureRegion()
	Local $DonatePixelCheck = _MultiPixelSearch($iLeft, $iTop, $iRight, $iBottom, 50, 1, Hex(0x98D057, 6), $aChatDonateBtnColors, 15)
	If IsArray($DonatePixelCheck) Then
		Click($DonatePixel[0] + 50, $DonatePixel[1] + 10, 1, 0, "#0174")
	Else
		If $debugsetlog = 1 Then SetLog("Could not find the Donate Button!", $COLOR_DEBUG) ;Debug
		Return False
	EndIf
	If _Sleep($iDelayDonateWindow1) Then Return

	;_CaptureRegion(0, 0, 320 + $midOffsetY, $DonatePixel[1] + 30 + $YComp)
	$icount = 0
	While Not (_ColorCheck(_GetPixelColor(331, $DonatePixel[1], True), Hex(0xffffff, 6), 0))
		If _Sleep($iDelayDonateWindow1) Then Return
		;_CaptureRegion(0, 0, 320 + $midOffsetY, $DonatePixel[1] + 30 + $YComp)
		$icount += 1
		If $icount = 20 Then ExitLoop
	WEnd

	; Determinate the right position of the new Donation Window
	; Will search in $Y column = 410 for the first pure white color and determinate that position the $DonationWindowTemp
	$DonationWindowY = 0

	Local $aDonWinOffColors[2][3] = [[0xFFFFFF, 0, 2], [0xc7c5bc, 0, 209]]
	Local $aDonationWindow = _MultiPixelSearch(409, 0, 410, $DEFAULT_HEIGHT, 1, 1, Hex(0xFFFFFF, 6), $aDonWinOffColors, 10)

	If IsArray($aDonationWindow) Then
		$DonationWindowY = $aDonationWindow[1]
		If _Sleep($iDelayDonateWindow1) Then Return
		If $debugsetlog = 1 Then Setlog("$DonationWindowY: " & $DonationWindowY, $COLOR_DEBUG) ;Debug
	Else
		SetLog("Could not find the Donate Window!", $COLOR_RED)
		Return False
	EndIf

	If $debugsetlog = 1 Then Setlog("DonateWindow Open Exit", $COLOR_DEBUG) ;Debug
	Return True
EndFunc   ;==>DonateWindow

Func DonateWindowCap(ByRef $bSkipDonTroops, ByRef $bSkipDonSpells)
	If $debugsetlog = 1 Then Setlog("DonateCapWindow Start", $COLOR_DEBUG) ;Debug
	;read troops capacity
	If $bSkipDonTroops = False Then
		Local $sReadCCTroopsCap = getCastleDonateCap(427, $DonationWindowY + 15) ; use OCR to get donated/total capacity
		If $debugsetlog = 1 Then Setlog("$sReadCCTroopsCap: " & $sReadCCTroopsCap, $COLOR_DEBUG) ;Debug

		Local $aTempReadCCTroopsCap = StringSplit($sReadCCTroopsCap, "#")
		If $aTempReadCCTroopsCap[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $debugsetlog = 1 Then Setlog("$aTempReadCCTroopsCap splitted :" & $aTempReadCCTroopsCap[1] & "/" & $aTempReadCCTroopsCap[2], $COLOR_DEBUG) ;Debug
			If $aTempReadCCTroopsCap[2] > 0 Then
				$iDonTroopsAv = $aTempReadCCTroopsCap[1]
				$iDonTroopsLimit = $aTempReadCCTroopsCap[2]
				;Setlog("Donate Troops: " & $iDonTroopsAv & "/" & $iDonTroopsLimit)
			EndIf
		Else
			Setlog("Error reading the Castle Troop Capacity...", $COLOR_RED) ; log if there is read error
			$iDonTroopsAv = 0
			$iDonTroopsLimit = 0
		EndIf
	EndIf

	If $bSkipDonSpells = False Then
		Local $sReadCCSpellsCap = getCastleDonateCap(420, $DonationWindowY + 220) ; use OCR to get donated/total capacity
		If $debugsetlog = 1 Then Setlog("$sReadCCSpellsCap: " & $sReadCCSpellsCap, $COLOR_DEBUG) ;Debug
		Local $aTempReadCCSpellsCap = StringSplit($sReadCCSpellsCap, "#")
		If $aTempReadCCSpellsCap[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $debugsetlog = 1 Then Setlog("$aTempReadCCSpellsCap splitted :" & $aTempReadCCSpellsCap[1] & "/" & $aTempReadCCSpellsCap[2], $COLOR_DEBUG) ;Debug
			If $aTempReadCCSpellsCap[2] > 0 Then
				$iDonSpellsAv = $aTempReadCCSpellsCap[1]
				$iDonSpellsLimit = $aTempReadCCSpellsCap[2]
				;Setlog("Donate Spells: " & $iDonSpellsAv & "/" & $iDonSpellsLimit)
			EndIf
		Else
			Setlog("Error reading the Castle Spells Capacity...", $COLOR_RED) ; log if there is read error
			$iDonSpellsAv = 0
			$iDonSpellsLimit = 0
		EndIf
	EndIf

	If $iDonTroopsAv = $iDonTroopsLimit Then
		$bSkipDonTroops = True
		SetLog("Donate Troop Limit Reached")
	EndIf
	If $iDonSpellsAv = $iDonSpellsLimit Then
		$bSkipDonSpells = True
		SetLog("Donate Spell Limit Reached")
	EndIf

	If $bSkipDonTroops = True And $bSkipDonSpells = True And $iDonTroopsAv < $iDonTroopsLimit And $iDonSpellsAv < $iDonSpellsLimit Then
		Setlog("Donate Troops: " & $iDonTroopsAv & "/" & $iDonTroopsLimit & ", Spells: " & $iDonSpellsAv & "/" & $iDonSpellsLimit)
	EndIf
	If $bSkipDonSpells = False And $iDonTroopsAv < $iDonTroopsLimit And $iDonSpellsAv = $iDonSpellsLimit Then Setlog("Donate Troops: " & $iDonTroopsAv & "/" & $iDonTroopsLimit)
	If $bSkipDonTroops = False And $iDonTroopsAv = $iDonTroopsLimit And $iDonSpellsAv < $iDonSpellsLimit Then Setlog("Donate Spells: " & $iDonSpellsAv & "/" & $iDonSpellsLimit)

	If $debugsetlog = 1 Then Setlog("$bSkipDonTroops: " & $bSkipDonTroops, $COLOR_DEBUG) ;Debug
	If $debugsetlog = 1 Then Setlog("$bSkipDonSpells: " & $bSkipDonSpells, $COLOR_DEBUG) ;Debug
	If $debugsetlog = 1 Then Setlog("DonateCapWindow End", $COLOR_DEBUG) ;Debug
EndFunc   ;==>DonateWindowCap

Func RemainingCCcapacity()
	; Remaining CC capacity of requested troops from your ClanMates
	; Will return the $iTotalDonateCapacity with that capacity for use in donation logic.

	Local $aCapTroops = "", $aTempCapTroops = "", $aCapSpells = "", $aTempCapSpells
	Local $iDonatedTroops = 0, $iDonatedSpells = 0
	Local $iCapTroopsTotal = 0, $iCapSpellsTotal = 0

	$iTotalDonateCapacity = -1
	$iTotalDonateSpellCapacity = -1

	; Verify with OCR the Donation Clan Castle capacity
	If $debugsetlog = 1 Then Setlog("Started dual getOcrSpaceCastleDonate", $COLOR_DEBUG) ;Debug
	$aCapTroops = getOcrSpaceCastleDonate(49, $DonatePixel[1]) ; when the request is troops+spell
	$aCapSpells = getOcrSpaceCastleDonate(153, $DonatePixel[1]) ; when the request is troops+spell

	If $debugsetlog = 1 Then Setlog("$aCapTroops :" & $aCapTroops, $COLOR_DEBUG) ;Debug
	If $debugsetlog = 1 Then Setlog("$aCapSpells :" & $aCapSpells, $COLOR_DEBUG) ;Debug

	If Not (StringInStr($aCapTroops, "#") Or StringInStr($aCapSpells, "#")) Then ; verify if the string is valid or it is just a number from request without spell
		If $debugsetlog = 1 Then Setlog("Started single getOcrSpaceCastleDonate", $COLOR_DEBUG) ;Debug
		$aCapTroops = getOcrSpaceCastleDonate(78, $DonatePixel[1]) ; when the Request don't have Spell

		If $debugsetlog = 1 Then Setlog("$aCapTroops :" & $aCapTroops, $COLOR_DEBUG) ;Debug
		$aCapSpells = -1
	EndIf

	If $aCapTroops <> "" Then
		; Splitting the XX/XX
		$aTempCapTroops = StringSplit($aCapTroops, "#")

		; Local Variables to use
		If $aTempCapTroops[0] >= 2 Then
			;  Note - stringsplit always returns an array even if no values split!
			If $debugsetlog = 1 Then Setlog("$aTempCapTroops splitted :" & $aTempCapTroops[1] & "/" & $aTempCapTroops[2], $COLOR_DEBUG) ;Debug
			If $aTempCapTroops[2] >= 0 Then
				$iDonatedTroops = $aTempCapTroops[1]
				$iCapTroopsTotal = $aTempCapTroops[2]
				If $iCapTroopsTotal = 0 Then
					$iCapTroopsTotal = 30
				EndIf
				If $iCapTroopsTotal = 5 Then
					$iCapTroopsTotal = 35
				EndIf
			EndIf
		Else
			Setlog("Error reading the Castle Troop Capacity...", $COLOR_RED) ; log if there is read error
			$iDonatedTroops = 0
			$iCapTroopsTotal = 0
		EndIf
	Else
		Setlog("Error reading the Castle Troop Capacity...", $COLOR_RED) ; log if there is read error
		$iDonatedTroops = 0
		$iCapTroopsTotal = 0
	EndIf

	If $aCapSpells <> -1 Then
		If $aCapSpells <> "" Then
			; Splitting the XX/XX
			$aTempCapSpells = StringSplit($aCapSpells, "#")

			; Local Variables to use
			If $aTempCapSpells[0] >= 2 Then
				; Note - stringsplit always returns an array even if no values split!
				If $debugsetlog = 1 Then Setlog("$aTempCapSpells splitted :" & $aTempCapSpells[1] & "/" & $aTempCapSpells[2], $COLOR_DEBUG) ;Debug
				If $aTempCapSpells[2] > 0 Then
					$iDonatedSpells = $aTempCapSpells[1]
					$iCapSpellsTotal = $aTempCapSpells[2]
				EndIf
			Else
				Setlog("Error reading the Castle Spell Capacity...", $COLOR_RED) ; log if there is read error
				$iDonatedSpells = 0
				$iCapSpellsTotal = 0
			EndIf
		Else
			Setlog("Error reading the Castle Spell Capacity...", $COLOR_RED) ; log if there is read error
			$iDonatedSpells = 0
			$iCapSpellsTotal = 0
		EndIf
	EndIf


	; $iTotalDonateCapacity it will be use to determinate the quantity of kind troop to donate
	$iTotalDonateCapacity = ($iCapTroopsTotal - $iDonatedTroops)
	If $aCapSpells <> -1 Then $iTotalDonateSpellCapacity = ($iCapSpellsTotal - $iDonatedSpells)

	If $iTotalDonateCapacity < 0 Then
		SetLog("Unable to read Castle Capacity!", $COLOR_RED)
	Else
		If $aCapSpells <> -1 Then
			SetLog("Chat Troops: " & $iDonatedTroops & "/" & $iCapTroopsTotal & ", Spells: " & $iDonatedSpells & "/" & $iCapSpellsTotal)
		Else
			SetLog("Chat Troops: " & $iDonatedTroops & "/" & $iCapTroopsTotal)
		EndIf
	EndIf

	;;Return $iTotalDonateCapacity

EndFunc   ;==>RemainingCCcapacity

Func DetectSlotTroop($Type)

	Local $FullTemp
	If $Type >= $eBarb And $Type <= $eBowl Then
		For $Slot = 0 To 5
			$FullTemp = getOcrDonationTroopsDetection(343 + (68 * $Slot), $DonationWindowY + 37)
			If $debugsetlog = 1 Then Setlog("Slot: " & $Slot & " getOcrDonationTroopsDetection returned >>" & $FullTemp & "<<", $COLOR_DEBUG) ;Debug
			If StringInStr($FullTemp & " ", "empty") > 0 Then ExitLoop
			If $FullTemp <> "" Then
				For $i = $eBarb To $eBowl
					$sTmp = StringStripWS(StringLeft(NameOfTroop($i), 4), $STR_STRIPTRAILING)
					;If $debugsetlog = 1 Then Setlog(NameOfTroop($i) & " = " & $sTmp, $COLOR_DEBUG) ;Debug
					If StringInStr($FullTemp & " ", $sTmp) > 0 Then
						If $debugsetlog = 1 Then Setlog("Detected " & NameOfTroop($i), $COLOR_DEBUG) ;Debug
						If $Type = $i Then Return $Slot
						ExitLoop
					EndIf
					If $i = $eBowl Then ; detection failed
						If $debugsetlog = 1 Then Setlog("Slot: " & $Slot & "Troop Detection Failed", $COLOR_DEBUG) ;Debug
					EndIf
				Next
			EndIf
		Next
		For $Slot = 6 To 11
			$FullTemp = getOcrDonationTroopsDetection(343 + (68 * ($Slot - 6)), $DonationWindowY + 124)
			If $debugsetlog = 1 Then Setlog("Slot: " & $Slot & " getOcrDonationTroopsDetection returned >>" & $FullTemp & "<<", $COLOR_DEBUG) ;Debug
			If StringInStr($FullTemp & " ", "empty") > 0 Then ExitLoop
			If $FullTemp <> "" Then
				For $i = $eBall To $eBowl
					$sTmp = StringStripWS(StringLeft(NameOfTroop($i), 4), $STR_STRIPTRAILING)
					;If $debugsetlog = 1 Then Setlog(NameOfTroop($i) & " = " & $sTmp, $COLOR_DEBUG) ;Debug
					If StringInStr($FullTemp & " ", $sTmp) > 0 Then
						If $debugsetlog = 1 Then Setlog("Detected " & NameOfTroop($i), $COLOR_DEBUG) ;Debug
						If $Type = $i Then Return $Slot
						ExitLoop
					EndIf
					If $i = $eBowl Then ; detection failed
						If $debugsetlog = 1 Then Setlog("Slot: " & $Slot & "Troop Detection Failed", $COLOR_DEBUG) ;Debug
					EndIf
				Next
			EndIf
		Next
	EndIf
	If $Type >= $ePSpell And $Type <= $eSkSpell Then
		For $Slot = 12 To 16
			$FullTemp = getOcrDonationTroopsDetection(343 + (68 * ($Slot - 12)), $DonationWindowY + 241)
			If $debugsetlog = 1 Then Setlog("Slot: " & $Slot & " getOcrDonationTroopsDetection returned >>" & $FullTemp & "<<", $COLOR_DEBUG) ;Debug
			If StringInStr($FullTemp & " ", "empty") > 0 Then ExitLoop
			If $FullTemp <> "" Then
				For $i = $ePSpell To $eSkSpell
					$sTmp = StringLeft(NameOfTroop($i), 4)
					;If $debugsetlog = 1 Then Setlog(NameOfTroop($i) & " = " & $sTmp, $COLOR_DEBUG) ;Debug
					If StringInStr($FullTemp & " ", $sTmp) > 0 Then
						If $debugsetlog = 1 Then Setlog("Detected " & NameOfTroop($i), $COLOR_DEBUG) ;Debug
						If $Type = $i Then Return $Slot
						ExitLoop
					EndIf
					If $i = $eSkSpell Then ; detection failed
						If $debugsetlog = 1 Then Setlog("Slot: " & $Slot & "Spell Detection Failed", $COLOR_DEBUG) ;Debug
					EndIf
				Next
			EndIf
		Next
	EndIf

	Return -1

EndFunc   ;==>DetectSlotTroop

