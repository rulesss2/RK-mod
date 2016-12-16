; #FUNCTION# ====================================================================================================================
; Name ..........: Config save - Mod.au3
; Description ...: Extension of saveConfig() for Mod
; Syntax ........: saveConfig()
; Parameters ....: NA
; Return values .: NA
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


; Config save for SwitchAcc Mode - DEMEN

	If GUICtrlRead($radActiveProfile) = $GUI_CHECKED Then														; 1 = Active, 2 = Donate, 3 = Idle
		IniWrite($config, "Switch Account", "Profile Type", 1)
		IniWrite($profile, "Profile Type", _GUICtrlCombobox_GetCurSel($cmbProfile)+1, 1)
	 ElseIf GUICtrlRead($radDonateProfile) = $GUI_CHECKED Then
		IniWrite($config, "Switch Account", "Profile Type", 2)
		IniWrite($profile, "Profile Type", _GUICtrlCombobox_GetCurSel($cmbProfile)+1, 2)
	 Else
		IniWrite($config, "Switch Account", "Profile Type", 3)
		IniWrite($profile, "Profile Type", _GUICtrlCombobox_GetCurSel($cmbProfile)+1, 3)
	EndIf

	IniWrite($config, "Switch Account", "Match Profile Acc", _GUICtrlCombobox_GetCurSel($cmbMatchProfileAcc))	 ; 0 = No Acc (idle), 1 = Acc 1, 2 = Acc 2, etc.

	If GUICtrlRead($chkSwitchAcc) = $GUI_CHECKED Then
		IniWrite($profile, "Switch Account", "Enable", 1)
	Else
		IniWrite($profile, "Switch Account", "Enable", 0)
	EndIf

	IniWrite($profile, "Switch Account", "Total Coc Account", _GUICtrlCombobox_GetCurSel($cmbTotalAccount))	; 0 = AutoDetect, 1 = 1 Acc, 2 = 2 Acc, etc.

	If GUICtrlRead($radSmartSwitch) = $GUI_CHECKED Then
	   IniWrite($profile, "Switch Account", "Smart Switch", 1)
	Else
	   IniWrite($profile, "Switch Account", "Smart Switch", 0)
	EndIf

	If GUICtrlRead($chkUseTrainingClose) = $GUI_CHECKED Then
		If GUICtrlRead($radCloseCoC) = $GUI_CHECKED Then
			IniWrite($profile, "Switch Account", "Sleep Combo", 1)		; Sleep Combo = 1 => Close CoC
		Else
			IniWrite($profile, "Switch Account", "Sleep Combo", 2)		; Sleep Combo = 2 => Close Android
		EndIf
	Else
		IniWrite($profile, "Switch Account", "Sleep Combo", 0)
	EndIf

	For $i = 1 to 6
		IniWriteS($profile, "Acc Location", "yAccNo." & $i, $aAccPosY[$i-1])
	Next

; Config for Adding Quicktrain Combo - DEMEN
	If GUICtrlRead($hRadio_Army12) = $GUI_CHECKED Then
		IniWriteS($config, "troop", "QuickTrain12", 1)
	Else
		IniWriteS($config, "troop", "QuickTrain12", 0)
	EndIf

	If GUICtrlRead($hRadio_Army123) = $GUI_CHECKED Then
		IniWriteS($config, "troop", "QuickTrain123", 1)
	Else
		IniWriteS($config, "troop", "QuickTrain123", 0)
	EndIf

    ;forecast
	IniWrite($config, "forecast", "txtForecastBoost", GUICtrlRead($txtForecastBoost))

	If GUICtrlRead($chkForecastBoost) = $GUI_CHECKED Then
		IniWrite($config, "forecast", "chkForecastBoost", 1)
	Else
		IniWrite($config, "forecast", "chkForecastBoost", 0)
	EndIf

	If GUICtrlRead($chkForecastHopingSwitchMax) = $GUI_CHECKED Then
		IniWrite($config, "profiles", "chkForecastHopingSwitchMax", 1)
	Else
		IniWrite($config, "profiles", "chkForecastHopingSwitchMax", 0)
	EndIf
	IniWrite($config, "profiles", "cmbForecastHopingSwitchMax", _GUICtrlComboBox_GetCurSel($cmbForecastHopingSwitchMax))
	IniWrite($config, "profiles", "txtForecastHopingSwitchMax", GUICtrlRead($txtForecastHopingSwitchMax))

	If GUICtrlRead($chkForecastHopingSwitchMin) = $GUI_CHECKED Then
		IniWrite($config, "profiles", "chkForecastHopingSwitchMin", 1)
	Else
		IniWrite($config, "profiles", "chkForecastHopingSwitchMin", 0)
	EndIf
	IniWrite($config, "profiles", "cmbForecastHopingSwitchMin", _GUICtrlComboBox_GetCurSel($cmbForecastHopingSwitchMin))
	IniWrite($config, "profiles", "txtForecastHopingSwitchMin", GUICtrlRead($txtForecastHopingSwitchMin))

	;modification Chat by rulesss
	IniWrite($config, "global", "chdelay", GUICtrlRead($chkchatdelay))

	; Android Settings
	IniWrite($config, "Android", "Emulator", GUICtrlRead($cmbAndroid))
	IniWrite($config, "Android", "Instance", GUICtrlRead($txtAndroidInstance))

	; Misc Battle Settings - - Added by rulesss
	If GUICtrlRead($chkFastADBClicks) = $GUI_CHECKED Then
		IniWrite($config, "Fast Clicks", "UseADBFastClicks", 1)
	Else
		IniWrite($config, "Fast Clicks", "UseADBFastClicks", 0)
    EndIf

    ;==========;Russian Languages by Kychera==========
	If GUICtrlRead($chkRusLang) = $GUI_CHECKED Then
		$ichkRusLang = 1
	Else
		$ichkRusLang = 0
	EndIf

	IniWriteS($config, "Lang", "chkRusLang", $ichkRusLang)
	If GUICtrlRead($chkRusLang2) = $GUI_CHECKED Then
		$ichkRusLang2 = 1
	Else
		$ichkRusLang2 = 0
	EndIf

	IniWriteS($config, "Lang", "chkRusLang2", $ichkRusLang2)
	;==========;Russian Languages by Kychera==========

	; Multi Finger - Added by rulesss
    IniWrite($config, "MultiFinger", "Select", $iMultiFingerStyle)

	; CSV Deployment Speed Mod
	IniWriteS($config, "attack", "CSVSpeedDB", $isldSelectedCSVSpeed[$DB])
	IniWriteS($config, "attack", "CSVSpeedAB", $isldSelectedCSVSpeed[$LB])