; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design SuperXP
; Description ...: This file Includes GUI Design For Farm XP Goblin Picnic
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: DocOC Team (10-11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
$12 = GUICtrlCreatePic (@ScriptDir & "\Images\1.jpg", 2, 23, 442, 367, $WS_CLIPCHILDREN)

Local $x = 25, $y = 45, $xStart = 25, $yStart = 45

	$grpSuperXP = GUICtrlCreateGroup(GetTranslated(700, 1, "Goblin XP"), $x - 20, $y - 20, 420, 305)
		$chkEnableSuperXP = GUICtrlCreateCheckbox(GetTranslated(700, 2, "Enable Goblin XP"), $x, $y, 102, 17)
		GUICtrlSetOnEvent(-1, "chkEnableSuperXP")
			$rbSXTraining = GUICtrlCreateRadio(GetTranslated(700, 3, "Farm XP during troops Training"), $x, $y + 23, 165, 17)
			GUICtrlSetState(-1, $GUI_CHECKED)
			$lblLOCKEDSX = GUICtrlCreateLabel(GetTranslated(700, 13, "LOCKED"), $x + 210, $y + 23, 173, 50)
			GUICtrlSetFont(-1, 30, 800, 0, "Arial")
			GUICtrlSetColor(-1, 0xFF0000)
			GUICtrlSetState(-1, $GUI_HIDE)
			$rbSXIAttacking = GUICtrlCreateRadio(GetTranslated(700, 4, "Farm XP instead of Attacking"), $x, $y + 46, 158, 17)
	        GUICtrlCreateLabel (GetTranslated(700, 14, "Max XP to Gain") & ":", $x, $y + 69, -1, 17)
			$txtMaxXPtoGain = GUICtrlCreateInput("500", $x + 85, $y + 67, 70, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 6)
	$x += 129
	$y += 100
		GUICtrlCreateLabel(GetTranslated(700, 5, "Use"), $x - 35, $y + 13, 23, 17)
			GUICtrlCreateIcon($pIconLib, $eIcnKing, $x, $y, 32, 32)
			GUICtrlCreateIcon($pIconLib, $eIcnQueen, $x + 40, $y, 32, 32)
			GUICtrlCreateIcon($pIconLib, $eIcnWarden, $x + 80, $y, 32, 32)
		GUICtrlCreateLabel(GetTranslated(700, 6, "to gain XP"), $x + 123, $y + 13, 53, 17)
	$x += 10
		$chkSXBK = GUICtrlCreateCheckbox("", $x, $y + 35, 17, 17)
		$chkSXAQ = GUICtrlCreateCheckbox("", $x + 40, $y + 35, 17, 17)
		$chkSXGW = GUICtrlCreateCheckbox("", $x + 80, $y + 35, 17, 17)

	$x = $xStart + 25
	$y += 73
		GUICtrlCreateLabel("", $x - 25, $y, 5, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		$DocXP1 = GUICtrlCreateLabel(GetTranslated(700, 7, "XP at Start"), $x - 20, $y, 98, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		$DocXP2 = GUICtrlCreateLabel(GetTranslated(700, 8, "Current XP"), $x + 63 + 15, $y, 104, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		$DocXP3 = GUICtrlCreateLabel(GetTranslated(700, 9, "XP Won"), $x + 71 + 76 + 35, $y, 103, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		$DocXP4 = GUICtrlCreateLabel(GetTranslated(700, 10, "XP Won/Hour"), $x + 69 + 55 + 110 + 45, $y, 87, 19)
		GUICtrlSetBkColor (-1, 0xD8D8D8)
		GUICtrlCreateGroup("", $x - 28, $y - 7, 395, 29)
	$y += 15
			GUICtrlCreateLabel("", $x - 25, $y + 7, 5, 36)
			GUICtrlSetBkColor (-1, 0xbfdfff)
		$lblXPatStart = GUICtrlCreateLabel("0", $x - 20, $y + 7, 99, 36)
			GUICtrlSetFont(-1, 20, 800, 0, "Arial")
			GUICtrlSetBkColor (-1, 0xbfdfff)
		$lblXPCurrent = GUICtrlCreateLabel("0", $x + 78, $y + 7, 105, 36)
			GUICtrlSetFont(-1, 20, 800, 0, "Arial")
			GUICtrlSetBkColor (-1, 0xbfdfff)
		$lblXPSXWon = GUICtrlCreateLabel("0", $x + 182, $y + 7, 97, 36)
			GUICtrlSetFont(-1, 20, 800, 0, "Arial")
			GUICtrlSetBkColor (-1, 0xbfdfff)
		$lblXPSXWonHour = GUICtrlCreateLabel("0", $x + 279, $y + 7, 87, 36)
			GUICtrlSetFont(-1, 20, 800, 0, "Arial")
			GUICtrlSetBkColor (-1, 0xbfdfff)

	$x = $xStart
	$y += 60
		GUICtrlCreateLabel(GetTranslated(700, 11, "Goblin XP attack continuously the TH of Goblin Picnic to farm XP."), $x, $y, 312, 17)
		GUICtrlCreateLabel(GetTranslated(700, 12, "At each attack, you win 5 XP"), $x, $y + 20, 306, 17)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
