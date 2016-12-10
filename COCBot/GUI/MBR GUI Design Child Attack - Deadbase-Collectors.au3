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
$13 = GUICtrlCreatePic (@ScriptDir & "\Images\1.jpg", 2, 23, 442, 367, $WS_CLIPCHILDREN)

Global $chkLvl6, $chkLvl7, $chkLvl8, $chkLvl9, $chkLvl10, $chkLvl11, $chkLvl12
Global $cmbLvl6, $cmbLvl7, $cmbLvl8, $cmbLvl9, $cmbLvl10, $cmbLvl11, $cmbLvl12
Global $sldCollectorTolerance

Local $x = 10, $y = 45
Local $txtTip1 = GetTranslated(626,15, "If this box is checked, then the bot will look")
Local $txtFull = GetTranslated(626,30, "Full")

Local $txtTipOutSide1 = GetTranslated(626, 36, "Check for outside")
Local $txtTipOutSide2 = GetTranslated(626, 37, "Sensitivity to detect as OutSide,")
Local $txtTipOutSide3 = GetTranslated(626, 38, "Less than 40 will detect as OutSide very often")
Local $txtTipOutSide4 = GetTranslated(626, 39, "Higher than 100 will detect as OutSide almost always")
Local $txtTipOutSide5P1 = GetTranslated(626, 40, "Count OR Percentage of minimum OutSide")
Local $txtTipOutSide5P2 = GetTranslated(626, 41, "to Attack")

	$grpDeadBaseCollectors = GUICtrlCreateGroup(GetTranslated(626,1,"Collectors"), $x - 5, $y - 20, 420, 305)
		$txtCollectors = GUICtrlCreateLabel(GetTranslated(626,2, "Choose which collectors to search for while looking for a dead base. Also, choose how full they must be."), $x, $y, 250, 28)
		$chkDeadBaseDisableCollectorsFilter = GUICtrlCreateCheckbox(GetTranslated(626,32,"Disable Collector Filter"), $x+250, $y+7, 150, 18)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslated(626,33, "Excluding Collector Filter the bot consider DeadBase as LiveBase"))

$x += 215

	$grpOutSide = GUICtrlCreateGroup(GetTranslated(626, 42, "OutSide Check"), $x, $y+35, 193, 245)
$x += 7
$y += 3
		$grpOutCollectors = GUICtrlCreateGroup(GetTranslated(626, 43, "Elixir Collectors"), $x, $y+51, 177, 65)
			$chkOutSideCollectors = GUICtrlCreateCheckbox(GetTranslated(626, 46, "OutSide"), $x+8, $y+67, 57, 17)
				GUICtrlSetTip(-1, $txtTipOutSide1 & " Collectors")
				GUICtrlSetOnEvent(-1, "chkOutSideCollectors")
			GUICtrlCreateLabel(GetTranslated(626, 47, "Sensitivity") & ":", $x+79, $y+69, 54, 17)
			$txtSensCollectors = GUICtrlCreateInput("60", $x+136, $y+67, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
				GUICtrlSetTip(-1, $txtTipOutSide2 & @CRLF & $txtTipOutSide3 & @CRLF & $txtTipOutSide4)
			GUICtrlCreateLabel(GetTranslated(626, 48, "OutSide Count/Percent.") & " >", $x+8, $y+93, 127, 17)
			$txtPercentCollectors = GUICtrlCreateInput("60%", $x+136, $y+91, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
				GUICtrlSetTip(-1, $txtTipOutSide5P1 & " Collectors " & $txtTipOutSide5P2)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y += 74
		$grpOutMines = GUICtrlCreateGroup(GetTranslated(626, 44, "Gold Mines"), $x, $y+51, 177, 65)
			$chkOutSideMines = GUICtrlCreateCheckbox(GetTranslated(626, 46, "OutSide"), $x+8, $y+67, 57, 17)
				GUICtrlSetTip(-1, $txtTipOutSide1 & " Gold Mines")
				GUICtrlSetOnEvent(-1, "chkOutSideMines")
			GUICtrlCreateLabel(GetTranslated(626, 47, "Sensitivity") & ":", $x+79, $y+69, 54, 17)
			$txtSensMines = GUICtrlCreateInput("60", $x+136, $y+67, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
				GUICtrlSetTip(-1, $txtTipOutSide2 & @CRLF & $txtTipOutSide3 & @CRLF & $txtTipOutSide4)
			GUICtrlCreateLabel(GetTranslated(626, 48, "OutSide Count/Percent.") & " >", $x+8, $y+93, 127, 17)
			$txtPercentMines = GUICtrlCreateInput("60%", $x+136, $y+91, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
				GUICtrlSetTip(-1, $txtTipOutSide5P1 & " Gold Mines " & $txtTipOutSide5P2)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y += 74
		$grpOutDrills = GUICtrlCreateGroup(GetTranslated(626, 45, "Dark Elixir Drills"), $x, $y+51, 177, 65)
			$chkOutSideDrills = GUICtrlCreateCheckbox(GetTranslated(626, 46, "OutSide"), $x+8, $y+67, 57, 17)
				GUICtrlSetTip(-1, $txtTipOutSide1 & " Dark Drills")
				GUICtrlSetOnEvent(-1, "chkOutSideDrills")
			GUICtrlCreateLabel(GetTranslated(626, 47, "Sensitivity") & ":", $x+79, $y+69, 54, 17)
			$txtSensDrills = GUICtrlCreateInput("60", $x+136, $y+67, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
				GUICtrlSetTip(-1, $txtTipOutSide2 & @CRLF & $txtTipOutSide3 & @CRLF & $txtTipOutSide4)
			GUICtrlCreateLabel(GetTranslated(626, 48, "OutSide Count/Percent.") & " >", $x+8, $y+93, 127, 17)
			$txtPercentDrills = GUICtrlCreateInput("60%", $x+136, $y+91, 33, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
				GUICtrlSetTip(-1, $txtTipOutSide5P1 & " Dark Drills " & $txtTipOutSide5P2)
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

$x -= 215
$y -= (74 + 74)

	$y += 40
		$chkLvl6 = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$txtTip = $txtTip1 & @CRLF & GetTranslated(626,16, "for level 6 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
			GUICtrlSetOnEvent(-1, "chkLvl6")
		$picLvl6 = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$txtLvl6 = GUICtrlCreateLabel(GetTranslated(626,3, "Lvl 6. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$cmbLvl6 = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(626,23,'Select how full a level 6 collector needs to be for it to be marked "dead"')
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbLvl6")
	$y+= 25
		$chkLvl7 = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$txtTip = $txtTip1 & @CRLF & GetTranslated(626,17, "for level 7 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkLvl7")
		$picLvl7 = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$txtLvl7 = GUICtrlCreateLabel(GetTranslated(626,4, "Lvl 7. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$cmbLvl7 = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(626,24,'Select how full a level 7 collector needs to be for it to be marked "dead"')
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbLvl7")
	$y+= 25
		$chkLvl8 = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$txtTip = $txtTip1 & @CRLF & GetTranslated(626,18,"for level 8 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkLvl8")
		$picLvl8 = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$txtLvl8 = GUICtrlCreateLabel(GetTranslated(626,5, "Lvl 8. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$cmbLvl8 = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(626,25,'Select how full a level 8 collector needs to be for it to be marked "dead"')
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbLvl8")
	$y+= 25
		$chkLvl9 = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$txtTip = $txtTip1 & @CRLF & GetTranslated(626,19,"for level 9 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkLvl9")
		$picLvl9 = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$txtLvl9 = GUICtrlCreateLabel(GetTranslated(626,6, "Lvl 9. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$cmbLvl9 = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(626,26,'Select how full a level 9 collector needs to be for it to be marked "dead"')
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbLvl9")
	$y+= 25
		$chkLvl10 = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$txtTip = $txtTip1&@CRLF&GetTranslated(626,20,"for level 10 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkLvl10")
		$picLvl10 = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$txtLvl10 = GUICtrlCreateLabel(GetTranslated(626,7, "Lvl 10. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$cmbLvl10 = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(626,27,'Select how full a level 10 collector needs to be for it to be marked "dead"')
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbLvl10")
	$y+= 25
		$chkLvl11 = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$txtTip = $txtTip1&@CRLF&GetTranslated(626,21,"for level 11 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkLvl11")
		$picLvl11 = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$txtLvl11 = GUICtrlCreateLabel(GetTranslated(626,8, "Lvl 11. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$cmbLvl11 = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(626,28,'Select how full a level 11 collector needs to be for it to be marked "dead"')
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbLvl11")
	$y+= 25
		$chkLvl12 = GUICtrlCreateCheckbox("", $x, $y, 18, 18)
			$txtTip = $txtTip1&@CRLF&GetTranslated(626,22,"for level 12 elixir collectors during dead base detection.")
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkLvl12")
		$picLvl12 = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 20, $y, 16, 16)
			_GUICtrlSetTip(-1, $txtTip)
		$txtLvl12 = GUICtrlCreateLabel(GetTranslated(626,9, "Lvl 12. Must be >"), $x + 40, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $txtTip)
		$cmbLvl12 = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$txtTip = GetTranslated(626,29,'Select how full a level 12 collector needs to be for it to be marked "dead"')
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "50%|100%", "50%")
			GUICtrlSetOnEvent(-1, "cmbLvl12")
	$y+= 25
		$txtMinCollectorMatches = GUICtrlCreateLabel(GetTranslated(626,34, "Collectors required"), $x, $y + 3, -1, -1)
			$txtTip = GetTranslated(626,35,'Select how many collectors are needed to consider village "dead"')
			_GUICtrlSetTip(-1, $txtTip)
		$cmbMinCollectorMatches = GUICtrlCreateCombo("", $x + 125, $y, 75, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetData(-1, "1|2|3|4|5|6", "3")
			GUICtrlSetOnEvent(-1, "cmbMinCollectorMatches")

	$y += 25
		$lblTolerance = GUICtrlCreateLabel("-15" & _PadStringCenter(GetTranslated(626,11, "Tolerance"), 50, " ") & "15", $x, $y)
	$y += 15
		$sldCollectorTolerance = GUICtrlCreateSlider($x, $y, 205, 20, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS)) ;,
		$txtTip = GetTranslated(626,12, "Use this slider to adjust the tolerance of ALL images.") &@CRLF& GetTranslated(626,13, "If you want to adjust individual images, you must edit the files.")&@CRLF&GetTranslated(626,31,"WARNING: Do not change this setting unless you know what you are doing. Set it to 0 if you're not sure.")
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			_GUICtrlSetTip(-1, $txtTip)
			_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
			_GUICtrlSlider_SetTicFreq(-1,1)
			GUICtrlSetLimit(-1, 15,-15) ; change max/min value
			GUICtrlSetData(-1, 0) ; default value
			GUICtrlSetOnEvent(-1, "sldCollectorTolerance")
		If $DevMode = 0 Then
			GUICtrlSetState($lblTolerance, $GUI_HIDE)
			GUICtrlSetState($sldCollectorTolerance, $GUI_HIDE)
		EndIf
	$y += 25
		$lblCollectorWarning = GUICtrlCreateLabel("Warning: no collecters are selected. The bot will never find a dead base.", $x, $y, 255, 30)
			GUICtrlSetFont(-1, 10, $FW_BOLD)
			GUICtrlSetColor(-1, $COLOR_RED)
			GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
