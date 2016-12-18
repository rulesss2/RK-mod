; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
$6 = GUICtrlCreatePic(@ScriptDir & "\Images\1.jpg", 2, 23, 442, 367, $WS_CLIPCHILDREN)

Local $x = 25, $y = 45
	$grpABActivate = GUICtrlCreateGroup(GetTranslated(625,0, -1), $x - 20, $y - 20, 190, 305)
		$x -= 15
		$chkABActivateSearches = GUICtrlCreateCheckbox(GetTranslated(625,1, -1), $x, $y, 68, 18)
			$txtTip = GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,69, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1,$GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkABActivateSearches")
		$txtABSearchesMin = GUICtrlCreateInput("1", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(625,2, -1) & @CRLF & @CRLF & GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,69, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$lblABSearches = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
		$txtABSearchesMax = GUICtrlCreateInput("9999", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER)) ;ChrW(8734)
			$txtTip = GetTranslated(625,3, -1) & @CRLF & @CRLF & GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,69,-1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picABSearches = GUICtrlCreateIcon($pIconLib, $eIcnMagnifier, $x + 163, $y + 1, 16, 16)
	$y +=21
		$chkABActivateTropies = GUICtrlCreateCheckbox(GetTranslated(625,4, -1), $x, $y, 68, 18)
			$txtTip = GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,70,-1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABActivateTropies")
		$txtABTropiesMin = GUICtrlCreateInput("0", $x + 70, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1,$GUI_DISABLE)
			$txtTip = GetTranslated(625,5, -1) & @CRLF & @CRLF & GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,70,-1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$lblABTropies = GUICtrlCreateLabel("-", $x + 113, $y + 2, -1, -1)
			GUICtrlSetState(-1,$GUI_DISABLE)
		$txtABTropiesMax = GUICtrlCreateInput("6000", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetState(-1,$GUI_DISABLE)
			$txtTip = GetTranslated(625,6, -1) & @CRLF & @CRLF & GetTranslated(625,68, -1) & @CRLF & GetTranslated(625,70,-1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picABTrophies = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 163, $y + 1, 16, 16)
	$y +=21
		$chkABActivateCamps = GUICtrlCreateCheckbox(GetTranslated(625,7, -1), $x, $y, 110, 18)
			$txtTip = GetTranslated(625,8, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABActivateCamps")
		$lblABArmyCamps = GUICtrlCreateLabel(ChrW(8805), $x + 113 - 1, $y + 2, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1,$GUI_DISABLE)
		$txtABArmyCamps = GUICtrlCreateInput("100", $x + 120, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1,$GUI_DISABLE)
			GUICtrlSetLimit(-1, 6)
		$txtABArmyCampsPerc = GUICtrlCreateLabel("%", $x + 163 + 3, $y + 4, -1, -1)
			GUICtrlSetState(-1,$GUI_DISABLE)
	$y +=23
		$picABHeroesWait = GUICtrlCreateIcon($pIconLib, $eIcnHourGlass, $x - 1, $y + 3, 16, 16)
		$txtABHeroesWait = GUICtrlCreateLabel(GetTranslated(625,9, -1) & ":", $x + 20, $y + 4, 180, 18)
	$y += 20
	$x += 20
		$chkABKingWait = GUICtrlCreateCheckbox("", $x , $y + 55, 16, 16)
 			$txtTip = GetTranslated(625,10, -1) & @CRLF & GetTranslated(625, 50, -1) & @CRLF & GetTranslated(625, 65, -1)
 			_GUICtrlSetTip(-1, $txtTip)
 			GUICtrlSetOnEvent(-1, "chkABKingWait")
		$IMGchkABKingWait=GUICtrlCreateIcon($pIconLib, $eIcnKing, $x - 18, $y + 4, 48, 48)
 			_GUICtrlSetTip(-1, $txtTip)
		$IMGchkABKingSleepWait=GUICtrlCreateIcon($pIconLib, $eIcnSleepingKing, $x - 18, $y + 4, 48, 48)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1,$GUI_HIDE)
	$x += 55
		$chkABQueenWait = GUICtrlCreateCheckbox("", $x , $y + 55, 16, 16)
 			$txtTip = GetTranslated(625,12, -1) & @CRLF & GetTranslated(625, 50, -1) & @CRLF & GetTranslated(625, 66, -1)
 			_GUICtrlSetTip(-1, $txtTip)
 			GUICtrlSetOnEvent(-1, "chkABQueenWait")
 		$IMGchkABQueenWait=GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x - 18, $y + 4, 48, 48)
 			_GUICtrlSetTip(-1, $txtTip)
		$IMGchkABQueenSleepWait=GUICtrlCreateIcon($pIconLib, $eIcnSleepingQueen, $x - 18, $y + 4, 48, 48)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1,$GUI_HIDE)
	$x += 55
 		$chkABWardenWait = GUICtrlCreateCheckbox("", $x , $y + 55, 16, 16)
 			$txtTip = GetTranslated(625,13, -1) & @CRLF & GetTranslated(625, 50, -1) & @CRLF & GetTranslated(625, 67, -1)
 			_GUICtrlSetTip(-1, $txtTip)
 			GUICtrlSetOnEvent(-1, "chkABWardenWait")
 		$IMGchkABWardenWait=GUICtrlCreateIcon($pIconLib, $eIcnWarden, $x - 18, $y + 4, 48, 48)
 			_GUICtrlSetTip(-1, $txtTip)
		$IMGchkABWardenSleepWait=GUICtrlCreateIcon($pIconLib, $eIcnSleepingWarden, $x - 18, $y + 4, 48, 48)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1,$GUI_HIDE)
	$y += 80
	$x = 8
		$IMGchkABLightSpellWait = GUICtrlCreateIcon($pIconLib, $eIcnLightSpell, $x, $y, 22, 22)
		$IMGchkABHealSpellWait = GUICtrlCreateIcon($pIconLib, $eIcnHealSpell, $x+23, $y, 22, 22)
		$IMGchkABRageSpellWait = GUICtrlCreateIcon($pIconLib, $eIcnRageSpell, $x+46, $y, 22, 22)
		$IMGchkABJumpSpellWait = GUICtrlCreateIcon($pIconLib, $eIcnJumpSpell , $x+69, $y, 22, 22)
		$IMGchkABFreezeSpellWait = GUICtrlCreateIcon($pIconLib, $eIcnFreezeSpell , $x+92, $y, 22, 22)
      $IMGchkABPoisonSpellWait = GUICtrlCreateIcon($pIconLib, $eIcnPoisonSpell , $x+115, $y, 22, 22)
      $IMGchkABEarthquakeSpellWait = GUICtrlCreateIcon($pIconLib, $eIcnEarthquakeSpell , $x+138, $y, 22, 22)
      $IMGchkABHasteSpellWait = GUICtrlCreateIcon($pIconLib, $eIcnHasteSpell, $x+161, $y, 22, 22)
	$y += 22
	$x = 10
	$x = 10
	    $chkABSpellsWait = GUICtrlCreateCheckbox(GetTranslated(625,99, "Wait for Spells to be Ready"), $x, $y, -1, -1)
			$txtTip = GetTranslated(625,100, -1) & @CRLF & _
			GetTranslated(625,101, -1)
 			_GUICtrlSetTip(-1, $txtTip)
 			GUICtrlSetOnEvent(-1, "chkABSpellsWait")

		$chkABWaitForCastleSpell = GUICtrlCreateCheckbox(GetTranslated(1010,6, "Wait to get Castle Spell"), $x, $y + 25, -1, -1)
			$txtTip = GetTranslated(1010,7, "Wait until Someone Donate you an Spell")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABWaitForCCSpell")

		$cmbABWaitForCastleSpell = GUICtrlCreateCombo(GetTranslated(1010,10, "Any"), $x, $y + 50, -1, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(1010,11, "Wait until Someone Donate this Spell, Else remove other spells in Castle and Request AGAIN")
			GUICtrlSetData(-1, GetTranslated(1010,12, "Poison|EarthQuake|Haste|Skeleton"))
			_GUICtrlSetTip(-1, $txtTip)

		$chkABWaitForCastleTroops = GUICtrlCreateCheckbox(GetTranslated(1010,8,"Wait to for Castle troops to be full"), $x, $y + 75, -1, -1)
			$txtTip = GetTranslated(1010,9, "Wait until your Clan Castle be Full")
			_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $x = 220, $y = 45
	$grpABFilter = GUICtrlCreateGroup(GetTranslated(625,14, -1), $x - 20, $y - 20, 225, 305)
		$x -= 15
		$cmbABMeetGE = GUICtrlCreateCombo("", $x , $y + 10, 65, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(625,15, -1) & @CRLF & GetTranslated(625,16, -1) & @CRLF & GetTranslated(625,17, -1) & @CRLF & GetTranslated(625,18, -1)
			GUICtrlSetData(-1, GetTranslated(625,19, -1) &"|" & GetTranslated(625,20, -1) & "|" & GetTranslated(625,21, -1), GetTranslated(625,19, -1))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "cmbABGoldElixir")
		$txtABMinGold = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(625,23, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picABMinGold = GUICtrlCreateIcon($pIconLib, $eIcnGold, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$y += 21
		$txtABMinElixir = GUICtrlCreateInput("80000", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(625,24, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
		$picABMinElixir = GUICtrlCreateIcon($pIconLib, $eIcnElixir, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$y -= 11
		$txtABMinGoldPlusElixir = GUICtrlCreateInput("160000", $x + 85, $y, 50, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(625,25, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 6)
			GUICtrlSetState (-1, $GUI_HIDE)
 		$picABMinGPEGold = GUICtrlCreateIcon($pIconLib, $eIcnGoldElixir, $x + 137, $y + 1, 16, 16)
 			_GUICtrlSetTip(-1, $txtTip)
 			GUICtrlSetState (-1, $GUI_HIDE)
		$y += 34
		$chkABMeetDE = GUICtrlCreateCheckbox(GetTranslated(625,26, -1), $x, $y, -1, -1)
			$txtTip = GetTranslated(625,27, -1)
			GUICtrlSetOnEvent(-1, "chkABMeetDE")
			_GUICtrlSetTip(-1, $txtTip)
		$txtABMinDarkElixir = GUICtrlCreateInput("0", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(625,28, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
			_GUICtrlEdit_SetReadOnly(-1, True)
		$picABMinDarkElixir = GUICtrlCreateIcon($pIconLib, $eIcnDark, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$y += 24
		$chkABMeetTrophy = GUICtrlCreateCheckbox(GetTranslated(625,4, -1), $x, $y, -1, -1)
			$txtTip = GetTranslated(625,29, -1)
			GUICtrlSetOnEvent(-1, "chkABMeetTrophy")
			_GUICtrlSetTip(-1, $txtTip)
		$txtABMinTrophy = GUICtrlCreateInput("0", $x + 85, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(625,30, -1)
			_GUICtrlSetTip(-1, $txtTip)
			_GUICtrlEdit_SetReadOnly(-1, True)
			GUICtrlSetLimit(-1, 2)
		$picABMinTrophies = GUICtrlCreateIcon($pIconLib, $eIcnTrophy, $x + 137, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$y += 24
		$chkABMeetTH = GUICtrlCreateCheckbox(GetTranslated(625,31, -1), $x, $y, -1, -1)
			$txtTip = GetTranslated(625,32, -1)
			GUICtrlSetOnEvent(-1, "chkABMeetTH")
			_GUICtrlSetTip(-1, $txtTip)
		$cmbABTH = GUICtrlCreateCombo("", $x + 85, $y - 1, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(625,33, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetData(-1, "4-6|7|8|9|10|11", "4-6")
		$picABMaxTH10 = GUICtrlCreateIcon($pIconLib, $eIcnTH10, $x + 137, $y - 3, 24, 24)
			_GUICtrlSetTip(-1, $txtTip)
		$y += 24
		$chkABMeetTHO = GUICtrlCreateCheckbox(GetTranslated(625,34, -1), $x, $y, -1, -1)
			$txtTip = GetTranslated(625,35, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$y += 24
		GUICtrlCreateGroup(GetTranslated(1002,1, "Weak base | max defenses"), $x, $y, 215, 100)
		$x += 5
		$y += 20
		$xStarColumn = $x
		$yStartColumn = $y
		$chkMaxMortar[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = GetTranslated(625,59, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$cmbWeakMortar[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(625,38, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 5")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picABWeakMortar = GUICtrlCreateIcon($pIconLib, $eIcnMortar, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $txtTip)
		$y +=24
		$chkMaxWizTower[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = GetTranslated(625,60, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$cmbWeakWizTower[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(625,39, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8|Lvl 9", "Lvl 4")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picABWeakWizTower = GUICtrlCreateIcon($pIconLib, $eIcnWizTower, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $txtTip)
		$y += 24
		$chkMaxAirDefense[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = "Search for a base that has Air Defense below this level"
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$cmbWeakAirDefense[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = "Set the Max. level of the Air Defense to search for on a village to attack."
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4|Lvl 5|Lvl 6|Lvl 7|Lvl 8", "Lvl 7")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picABWeakAirDefense = GUICtrlCreateIcon($pIconLib, $eIcnAirDefense, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $txtTip)
		$x = $xStarColumn + 104
		$y = $yStartColumn
		$chkMaxXBow[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = GetTranslated(625,61, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$cmbWeakXBow[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(625,51, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3|Lvl 4", "Lvl 2")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picABWeakXBow = GUICtrlCreateIcon($pIconLib, $eIcnXBow3, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $txtTip)
		$y +=24
		$chkMaxInferno[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = GetTranslated(625,62, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$cmbWeakInferno[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(625,52, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2|Lvl 3", "Lvl 2")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picABWeakInferno = GUICtrlCreateIcon($pIconLib, $eIcnInferno4, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $txtTip)
		$y +=24
		$chkMaxEagle[$LB] = GUICtrlCreateCheckbox("", $x, $y, 17, 17)
			$txtTip = GetTranslated(625,63, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkABWeakBase")
		$cmbWeakEagle[$LB] = GUICtrlCreateCombo("", $x + 19, $y, 50, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(625,53, -1)
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "-|Lvl 1|Lvl 2", "Lvl 1")
			GUICtrlSetState(-1, $GUI_DISABLE)
		$picABWeakEagle = GUICtrlCreateIcon($pIconLib, $eIcnEagleArt, $x + 75, $y - 2, 24, 24)
			_GUICtrlSetTip(-1, $txtTip)
		$y += 44
		$x = $xStarColumn
		$chkABMeetOne = GUICtrlCreateCheckbox(GetTranslated(625,40, -1), $x, $y, -1, -1)
			$txtTip = GetTranslated(625,41, -1)
			_GUICtrlSetTip(-1, $txtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
