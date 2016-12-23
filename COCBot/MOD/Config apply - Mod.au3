; #FUNCTION# ====================================================================================================================
; Name ..........: Config apply - Mod.au3
; Description ...: Extension of applyConfig() for Mod
; Syntax ........: applyConfig()
; Parameters ....:
; Return values .:
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Config Apply for SwitchAcc Mode - DEMEN
	Switch $ProfileType
	Case 1
	   GUICtrlSetState($radActiveProfile, $GUI_CHECKED)
	Case 2
	   GUICtrlSetState($radDonateProfile, $GUI_CHECKED)
	Case 3
	   GUICtrlSetState($radIdleProfile, $GUI_CHECKED)
	EndSwitch

	_GUICtrlCombobox_SetCurSel($cmbMatchProfileAcc, $MatchProfileAcc)

 	If $ichkSwitchAcc = 1 Then
 		GUICtrlSetState($chkSwitchAcc, $GUI_CHECKED)
 	Else
 		GUICtrlSetState($chkSwitchAcc, $GUI_UNCHECKED)
 	EndIf

	If $ichkSmartSwitch = 1 Then
	   GUICtrlSetState($radSmartSwitch, $GUI_CHECKED)
 	Else
	   GUICtrlSetState($radNormalSwitch, $GUI_CHECKED)
 	EndIf

	chkSwitchAcc()

	_GUICtrlCombobox_SetCurSel($cmbTotalAccount, $icmbTotalCoCAcc)	; 0 = AutoDetect

	If $ichkCloseTraining >= 1 Then
		GUICtrlSetState($chkUseTrainingClose, $GUI_CHECKED)
		If $ichkCloseTraining = 1 Then
			GUICtrlSetState($radCloseCoC, $GUI_CHECKED)
		Else
			GUICtrlSetState($radCloseAndroid, $GUI_CHECKED)
		EndIf
	Else
		GUICtrlSetState($chkUseTrainingClose, $GUI_UNCHECKED)
	EndIf

   ;Forecast
	GUICtrlSetData($txtForecastBoost, $iTxtForecastBoost)
	If $iChkForecastBoost = 1 Then
		GUICtrlSetState($chkForecastBoost, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkForecastBoost, $GUI_UNCHECKED)
	EndIf
	chkForecastBoost()

	If $ichkForecastHopingSwitchMax = 1 Then
		GUICtrlSetState($chkForecastHopingSwitchMax, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkForecastHopingSwitchMax, $GUI_UNCHECKED)
	EndIf
	_GUICtrlComboBox_SetCurSel($cmbForecastHopingSwitchMax, $icmbForecastHopingSwitchMax)
	GUICtrlSetData($txtForecastHopingSwitchMax, $itxtForecastHopingSwitchMax)
	chkForecastHopingSwitchMax()

	If $ichkForecastHopingSwitchMin = 1 Then
		GUICtrlSetState($chkForecastHopingSwitchMin, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkForecastHopingSwitchMin, $GUI_UNCHECKED)
	EndIf
	_GUICtrlComboBox_SetCurSel($cmbForecastHopingSwitchMin, $icmbForecastHopingSwitchMin)
	GUICtrlSetData($txtForecastHopingSwitchMin, $itxtForecastHopingSwitchMin)
	chkForecastHopingSwitchMin()

	;modification Chat by rulesss
	GUICtrlSetData($chkchatdelay, $ichkchatdelay)

	; Android Settings
	If _GUICtrlComboBox_FindStringExact($cmbAndroid, String($sAndroid)) <> -1 Then
		_GUICtrlComboBox_SelectString($cmbAndroid, String($sAndroid))
	Else
		_GUICtrlComboBox_SetCurSel($cmbAndroid, 0)
	EndIf
	GUICtrlSetData($txtAndroidInstance, $sAndroidInstance)
	modifyAndroid()

	; Misc Battle Settings - Added by LunaEclipse
	If $AndroidAdbClicksEnabled = 1 Then
		GUICtrlSetState($chkFastADBClicks, $GUI_CHECKED)
		$AndroidAdbClicksEnabled = True
	Else
		GUICtrlSetState($chkFastADBClicks, $GUI_UNCHECKED)
		$AndroidAdbClicksEnabled = False
    EndIf

   ;==========;Russian Languages by Kychera==========
	If $ichkRusLang = 1 Then
		GUICtrlSetState($chkRusLang, $GUI_CHECKED)

	ElseIf $ichkRusLang = 0 Then
		GUICtrlSetState($chkRusLang, $GUI_UNCHECKED)

	EndIf

	If $ichkRusLang2 = 1 Then
		GUICtrlSetState($chkRusLang2, $GUI_CHECKED)

	ElseIf $ichkRusLang2 = 0 Then
		GUICtrlSetState($chkRusLang2, $GUI_UNCHECKED)

	EndIf
    ;==========;Russian Languages by Kychera==========

; Multi Finger (LunaEclipse)
_GUICtrlComboBox_SetCurSel($cmbDBMultiFinger,$iMultiFingerStyle)
cmbDBMultiFinger()

cmbDeployAB()
cmbDeployDB()

; CSV Deployment Speed Mod
GUICtrlSetData($sldSelectedSpeedDB, $isldSelectedCSVSpeed[$DB])
GUICtrlSetData($sldSelectedSpeedAB, $isldSelectedCSVSpeed[$LB])
sldSelectedSpeedDB()
sldSelectedSpeedAB()