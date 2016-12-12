; #FUNCTION# ====================================================================================================================
; Name ..........: GUI Design - Profiles Mod
; Description ...: Extension of GUI Design Child Bot - Profiles Tab
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

; Defining botting type of eachh profile - SwitchAcc - DEMEN
		$x -= 3
		$y += 40
	    $lblProfile = GUICtrlCreateLabel(GetTranslated(637,17, "Profile Type:"), $x, $y + 1, -1, -1)
			$txtTip = (GetTranslated(637,18, "Choosing type for this Profile") & @CRLF & GetTranslated(637,19, "Active Profile for botting") & @CRLF & GetTranslated(637,20, "Donate Profile for donating only") & @CRLF & GetTranslated(637,21, "Idle Profile for staying inactive"))
			GUICtrlSetTip(-1, $txtTip)

	    $radActiveProfile= GUICtrlCreateRadio(GetTranslated(637,22, "Active"), $x + 70 , $y, -1, 16)
			GUICtrlSetTip(-1, GetTranslated(637,23, "Set as Active Profile for training troops & attacking"))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "radProfileType")

		$radDonateProfile = GUICtrlCreateRadio(GetTranslated(637,24, "Donate"), $x + 135, $y, -1, 16)
			GUICtrlSetTip(-1, GetTranslated(637,25, "Set as Donating Profile for training troops & donating only"))
			GUICtrlSetOnEvent(-1, "radProfileType")

		$radIdleProfile = GUICtrlCreateRadio(GetTranslated(637,26, "Idle"), $x + 190, $y, -1, 16)
			GUICtrlSetTip(-1, GetTranslated(637,27, "Set as Idle Profile. The Bot will ignore this Profile"))
			GUICtrlSetOnEvent(-1, "radProfileType")

	    $lblMatchProfileAcc = GUICtrlCreateLabel(GetTranslated(637,28, "Matching Acc. No."), $x + 260, $y + 1 , -1, 16)
			$txtTip = GetTranslated(637,29, "Select the index of CoC Account to match with this Profile")
			GUICtrlSetTip(-1, $txtTip)

		$cmbMatchProfileAcc = GUICtrlCreateCombo("", $x + 360, $y -3, 60, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "---" & "|" & "Acc. 1" & "|" & "Acc. 2" & "|" & "Acc. 3" & "|" & "Acc. 4" & "|" & "Acc. 5" & "|" & "Acc. 6", "---")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "cmbMatchProfileAcc")

; SwitchAcc - DEMEN

	Local $x = 25, $y = 135
	$grpSwitchAcc = GUICtrlCreateGroup(GetTranslated(637, 30, "Switch Account Mode"), $x - 15, $y - 20, 215, 265)
		$chkSwitchAcc = GUICtrlCreateCheckbox(GetTranslated(637,31, "Enable Switch Account"), $x , $y, -1, -1)
			$txtTip = "Switch to another account & profile when troop training time is >= 3 minutes" & @CRLF & "This function supports maximum 6 CoC accounts & 6 Bot profiles" & @CRLF & "Make sure to create sufficient Profiles equal to number of CoC Accounts, and align the index of accounts order with profiles order"
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkSwitchAcc")

		$lblTotalAccount = GUICtrlCreateLabel(GetTranslated(637,32, "Total CoC Acc:"), $x + 15, $y + 29, -1, -1)
			$txtTip = GetTranslated(637,33, "Choose number of CoC Accounts pre-logged")
			GUICtrlSetState(-1, $GUI_DISABLE)

		$cmbTotalAccount= GUICtrlCreateCombo("", $x + 100, $y + 25, -1, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, "--------" & "|" & "1 Account" & "|" & "2 Accounts" & "|" & "3 Accounts" & "|" & "4 Accounts" & "|" & "5 Accounts" & "|" & "6 Accounts")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$radSmartSwitch= GUICtrlCreateRadio(GetTranslated(637,34, "Smart switch"), $x + 15 , $y + 55, -1, 16)
			GUICtrlSetTip(-1, GetTranslated(637,35, "Switch to account with the shortest remain training time"))
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetState(-1, $GUI_DISABLE)

		$radNormalSwitch = GUICtrlCreateRadio(GetTranslated(637,36, "Normal switch"), $x + 100, $y + 55, -1, 16)
			GUICtrlSetTip(-1, GetTranslated(637,37, "Switching accounts continously"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "radNormalSwitch")

		$y += 80

		$chkUseTrainingClose = GUICtrlCreateCheckbox(GetTranslated(637,38, "Combo Sleep after Switch Account"), $x, $y, -1, -1)
			$txtTip = GetTranslated(637,39, "Close CoC combo with Switch Account when there is more than 3 mins remaining on training time of all accounts.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetOnEvent(-1, "chkUseTrainingClose")

		GUIStartGroup()
		$radCloseCoC= GUICtrlCreateRadio(GetTranslated(637,40, "Close CoC"), $x + 15 , $y + 30, -1, 16)
			GUICtrlSetState(-1, $GUI_CHECKED)

		$radCloseAndroid = GUICtrlCreateRadio(GetTranslated(637,41, "Close Android"), $x + 100, $y + 30, -1, 16)

		$lblLocateAcc = GUICtrlCreateLabel(GetTranslated(637,42, "Manually locate account coordinates"), $x, $y + 60, -1, -1)

		For $i = 1 to 6
			If $i <= 3 Then	GUICtrlCreateButton("Acc. " & $i, $x + 15 + 48 * ($i-1), $y + 85, 40, 25)
			If $i > 3 Then GUICtrlCreateButton("Acc. " & $i, $x + 15 + 48 * ($i-4), $y + 120, 40, 25)
			GUICtrlSetTip(-1, GetTranslated(637,43, "locate your CoC Account No. ") & $i)
			GUICtrlSetOnEvent(-1, "btnLocateAcc" & $i)
		Next

		GUICtrlCreateButton(GetTranslated(637,44, "Clear All"), $x + 159, $y + 85, 30, 60, $BS_MULTILINE)
			GUICtrlSetTip(-1, GetTranslated(637,45, "clear location data of all accounts"))
			GUICtrlSetOnEvent(-1, "btnClearAccLocation")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

; Profiles & Account matching

	Local $x = 250, $y = 135
	$grpSwitchAccMapping = GUICtrlCreateGroup(GetTranslated(637,46, "Profiles"), $x - 20, $y - 20, 210, 265)
		$btnUpdateProfiles = GUICtrlCreateButton(GetTranslated(637,47, "Update Profiles/ Acc matching"), $x, $y - 5 , 170, 25)
		GUICtrlSetOnEvent(-1, "btnUpdateProfile")

		Global $lblProfileList[8]

		$y += 25
		 For $i = 0 To 7
			$lblProfileList[$i] = GUICtrlCreateLabel("", $x, $y + ($i) * 25, 190, 18, $SS_LEFT)
		 Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)