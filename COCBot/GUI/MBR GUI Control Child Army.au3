; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func chkUseQTrain()
	If GUICtrlRead($hChk_UseQTrain) = $GUI_CHECKED Then
		GUICtrlSetState($hRadio_Army1, $GUI_ENABLE)
		GUICtrlSetState($hRadio_Army2, $GUI_ENABLE)
		GUICtrlSetState($hRadio_Army3, $GUI_ENABLE)
		GUICtrlSetState($hRadio_Army12, $GUI_ENABLE)	;	Adding Quicktrain Combo - Demen
		GUICtrlSetState($hRadio_Army123, $GUI_ENABLE)	;	Adding Quicktrain Combo - Demen
		;GUICtrlSetState($grpTrainTroops, $GUI_DISABLE)
		For $i = $txtNumBarb To $txtNumLava
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		For $i = $txtNumLightningSpell To $txtNumSkeletonSpell
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	Else
		GUICtrlSetState($hRadio_Army1, $GUI_DISABLE)
		GUICtrlSetState($hRadio_Army2, $GUI_DISABLE)
		GUICtrlSetState($hRadio_Army3, $GUI_DISABLE)
		GUICtrlSetState($hRadio_Army12, $GUI_DISABLE)	;	Adding Quicktrain Combo - Demen
		GUICtrlSetState($hRadio_Army123, $GUI_DISABLE)	;	Adding Quicktrain Combo - Demen
		;GUICtrlSetState($grpTrainTroops, $GUI_ENABLE)
		For $i = $txtNumBarb To $txtNumLava
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		For $i = $txtNumLightningSpell To $txtNumSkeletonSpell
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	EndIf
EndFunc

Func SetComboTroopComp()
	Local $bWasRedraw = SetRedrawBotWindow(False)
	Local $ArmyCampTemp = 0

	If GUICtrlRead($chkTotalCampForced) = $GUI_CHECKED Then
		$ArmyCampTemp = Floor(GUICtrlRead($txtTotalCampForced) * GUICtrlRead($txtFullTroop)/100)
	Else
		$ArmyCampTemp = Floor($TotalCamp * GUICtrlRead($txtFullTroop)/100)
	EndIf

	Local $TotalTroopsTOtrain = 0

	lblTotalCount()
	SetRedrawBotWindow($bWasRedraw)
EndFunc   ;==>SetComboTroopComp

Func lblTotalCount()

	Local $TotalTroopsTOtrain = 0
	Local $ArmyCampTemp = 0

	If GUICtrlRead($chkTotalCampForced) = $GUI_CHECKED Then
		$ArmyCampTemp = Floor(GUICtrlRead($txtTotalCampForced) * GUICtrlRead($txtFullTroop) / 100)
	Else
		$ArmyCampTemp = Floor($TotalCamp * GUICtrlRead($txtFullTroop)/100)
	EndIf

	For $i = 0 To UBound($TroopName) - 1
		If GUICtrlRead(Eval("txtNum" & $TroopName[$i])) > 0 Then
			$TotalTroopsTOtrain += GUICtrlRead(Eval("txtNum" & $TroopName[$i])) * $TroopHeight[$i]
		Else
			GUICtrlSetData(Eval("txtNum" & $TroopName[$i]), 0)
		EndIf
	Next

	#CS		This Codes Not Needed With New 'True' Train Order and new Training System ;)
	For $i = 0 To UBound($TroopDarkName) - 1
		If GUICtrlRead(Eval("txtNum" & $TroopDarkName[$i])) > 0 Then
			$TotalTroopsTOtrain += GUICtrlRead(Eval("txtNum" & $TroopDarkName[$i])) * $TroopDarkHeight[$i]
		Else
			GUICtrlSetData(Eval("txtNum" & $TroopDarkName[$i]), 0)
		EndIf
	Next
	#CE

	GUICtrlSetData($lblTotalCount, String($TotalTroopsTOtrain))

	If GUICtrlRead($chkTotalCampForced) = $GUI_CHECKED And GUICtrlRead($lblTotalCount) = GUICtrlRead($txtTotalCampForced) Then
		GUICtrlSetBkColor($lblTotalCount, $COLOR_MONEYGREEN)
	ElseIf GUICtrlRead($lblTotalCount) = $ArmyCampTemp Then
		GUICtrlSetBkColor($lblTotalCount, $COLOR_MONEYGREEN)
	ElseIf GUICtrlRead($lblTotalCount) > $ArmyCampTemp / 2 And GUICtrlRead($lblTotalCount) < $ArmyCampTemp Then
		GUICtrlSetBkColor($lblTotalCount, $COLOR_ORANGE)
	Else
		GUICtrlSetBkColor($lblTotalCount, $COLOR_RED)
	EndIf

	If GUICtrlRead($chkTotalCampForced) = $GUI_CHECKED Then
		GUICtrlSetData($caltotaltroops, (Floor((GUICtrlRead($lblTotalCount) / GUICtrlRead($txtTotalCampForced)) * 100) < 1 ? (GUICtrlRead($lblTotalCount) > 0 ? 1 : 0) : Floor((GUICtrlRead($lblTotalCount) / GUICtrlRead($txtTotalCampForced)) * 100)))
	Else
		GUICtrlSetData($caltotaltroops, (Floor((GUICtrlRead($lblTotalCount) / $ArmyCampTemp) * 100) < 1 ? (GUICtrlRead($lblTotalCount) > 0 ? 1 : 0) : Floor((GUICtrlRead($lblTotalCount) / $ArmyCampTemp) * 100)))
	EndIf

	If GUICtrlRead($chkTotalCampForced) = $GUI_CHECKED And GUICtrlRead($lblTotalCount) > GUICtrlRead($txtTotalCampForced) Then
		GUICtrlSetState($lbltotalprogress, $GUI_SHOW)
	ElseIf GUICtrlRead($lblTotalCount) > $ArmyCampTemp Then
		GUICtrlSetState($lbltotalprogress, $GUI_SHOW)
	Else
		GUICtrlSetState($lbltotalprogress, $GUI_HIDE)
	EndIf

EndFunc   ;==>lblTotalCount

Func lblTotalCountSpell()
	_GUI_Value_STATE("HIDE", $groupListSpells)
	; calculate $iTotalTrainSpaceSpell value
	$iTotalTrainSpaceSpell = (GUICtrlRead($txtNumLightningSpell) * 2) + (GUICtrlRead($txtNumHealSpell) * 2) + (GUICtrlRead($txtNumRageSpell) * 2) + (GUICtrlRead($txtNumJumpSpell) * 2) + _
			(GUICtrlRead($txtNumFreezeSpell) * 2) + (GUICtrlRead($txtNumCloneSpell) * 4) + GUICtrlRead($txtNumPoisonSpell) + GUICtrlRead($txtNumHasteSpell) + GUICtrlRead($txtNumEarthSpell) + GUICtrlRead($txtNumSkeletonSpell)

	For $i = 0 To UBound($TxtNameSpell) - 1
		If GUICtrlRead(Eval("txtNum" & $TxtNameSpell[$i])) < 0 Then
			GUICtrlSetData(Eval("txtNum" & $TxtNameSpell[$i]), 0)
		EndIf
	Next

	If $iTotalTrainSpaceSpell < GUICtrlRead($txtTotalCountSpell) + 1 Then
		GUICtrlSetBkColor($txtNumLightningSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumHealSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumRageSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumJumpSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumFreezeSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumCloneSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumPoisonSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumEarthSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumHasteSpell, $COLOR_MONEYGREEN)
		GUICtrlSetBkColor($txtNumSkeletonSpell, $COLOR_MONEYGREEN)
	Else
		GUICtrlSetBkColor($txtNumLightningSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumHealSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumRageSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumFreezeSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumCloneSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumJumpSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumPoisonSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumEarthSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumHasteSpell, $COLOR_RED)
		GUICtrlSetBkColor($txtNumSkeletonSpell, $COLOR_RED)
	EndIf
	$iTownHallLevel = Int($iTownHallLevel)
	If $iTownHallLevel > 4 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupLightning)
	Else
		GUICtrlSetData($txtNumLightningSpell, 0)
		GUICtrlSetData($txtNumRageSpell, 0)
		GUICtrlSetData($txtNumHealSpell, 0)
		GUICtrlSetData($txtNumJumpSpell, 0)
		GUICtrlSetData($txtNumFreezeSpell, 0)
		GUICtrlSetData($txtNumCloneSpell, 0)
		GUICtrlSetData($txtNumPoisonSpell, 0)
		GUICtrlSetData($txtNumEarthSpell, 0)
		GUICtrlSetData($txtNumHasteSpell, 0)
		GUICtrlSetData($txtNumSkeletonSpell, 0)
		GUICtrlSetData($txtTotalCountSpell, 0)
	EndIf
	If $iTownHallLevel > 5 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupHeal)
	Else
		GUICtrlSetData($txtNumRageSpell, 0)
		GUICtrlSetData($txtNumJumpSpell, 0)
		GUICtrlSetData($txtNumFreezeSpell, 0)
		GUICtrlSetData($txtNumCloneSpell, 0)
		GUICtrlSetData($txtNumPoisonSpell, 0)
		GUICtrlSetData($txtNumEarthSpell, 0)
		GUICtrlSetData($txtNumHasteSpell, 0)
		GUICtrlSetData($txtNumSkeletonSpell, 0)
	EndIf
	If $iTownHallLevel > 6 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupRage)
	Else
		GUICtrlSetData($txtNumJumpSpell, 0)
		GUICtrlSetData($txtNumFreezeSpell, 0)
		GUICtrlSetData($txtNumCloneSpell, 0)
		GUICtrlSetData($txtNumPoisonSpell, 0)
		GUICtrlSetData($txtNumEarthSpell, 0)
		GUICtrlSetData($txtNumHasteSpell, 0)
		GUICtrlSetData($txtNumSkeletonSpell, 0)
	EndIf
	If $iTownHallLevel > 7 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupPoison)
		_GUI_Value_STATE("SHOW", $groupEarthquake)
	Else
		GUICtrlSetData($txtNumJumpSpell, 0)
		GUICtrlSetData($txtNumFreezeSpell, 0)
		GUICtrlSetData($txtNumCloneSpell, 0)
		GUICtrlSetData($txtNumHasteSpell, 0)
		GUICtrlSetData($txtNumSkeletonSpell, 0)
	EndIf
	If $iTownHallLevel > 8 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupJumpSpell)
		_GUI_Value_STATE("SHOW", $groupFreeze)
		_GUI_Value_STATE("SHOW", $groupHaste)
		_GUI_Value_STATE("SHOW", $groupSkeleton)
	Else
		GUICtrlSetData($txtNumCloneSpell, 0)
	EndIf
	If $iTownHallLevel > 9 Or $iTownHallLevel = 0 Then
		_GUI_Value_STATE("SHOW", $groupClone)
	EndIf
EndFunc   ;==>lblTotalCountSpell

Func chkBoostBarracksHoursE1()
	If GUICtrlRead($chkBoostBarracksHoursE1) = $GUI_CHECKED And GUICtrlRead($chkBoostBarracksHours0) = $GUI_CHECKED Then
		For $i = $chkBoostBarracksHours0 To $chkBoostBarracksHours11
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkBoostBarracksHours0 To $chkBoostBarracksHours11
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkBoostBarracksHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkBoostBarracksHoursE1

Func chkBoostBarracksHoursE2()
	If GUICtrlRead($chkBoostBarracksHoursE2) = $GUI_CHECKED And GUICtrlRead($chkBoostBarracksHours12) = $GUI_CHECKED Then
		For $i = $chkBoostBarracksHours12 To $chkBoostBarracksHours23
			GUICtrlSetState($i, $GUI_UNCHECKED)
		Next
	Else
		For $i = $chkBoostBarracksHours12 To $chkBoostBarracksHours23
			GUICtrlSetState($i, $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($chkBoostBarracksHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkBoostBarracksHoursE2

Func chkCloseWaitEnable()
	If GUICtrlRead($chkCloseWaitEnable) = $GUI_CHECKED Then
		$ichkCloseWaitEnable = 1
		_GUI_Value_STATE("ENABLE", $groupCloseWaitTrain)
		GUICtrlSetState($lblCloseWaitingTroops, $GUI_ENABLE)
		GUICtrlSetState($cmbMinimumTimeClose, $GUI_ENABLE)
		GUICtrlSetState($lblSymbolWaiting, $GUI_ENABLE)
		GUICtrlSetState($lblWaitingInMinutes, $GUI_ENABLE)
	Else
		$ichkCloseWaitEnable = 0
		_GUI_Value_STATE("DISABLE", $groupCloseWaitTrain)
		GUICtrlSetState($lblCloseWaitingTroops, $GUI_DISABLE)
		GUICtrlSetState($cmbMinimumTimeClose, $GUI_DISABLE)
		GUICtrlSetState($lblSymbolWaiting, $GUI_DISABLE)
		GUICtrlSetState($lblWaitingInMinutes, $GUI_DISABLE)
	EndIf
	If GUICtrlRead($btnCloseWaitStopRandom) = $GUI_CHECKED Then
		GUICtrlSetState($btnCloseWaitStop, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	Else
		If GUICtrlRead($chkCloseWaitEnable) = $GUI_CHECKED Then GUICtrlSetState($btnCloseWaitStop, $GUI_ENABLE)
	EndIf
EndFunc   ;==>chkCloseWaitEnable

Func chkCloseWaitTrain()
	If GUICtrlRead($chkCloseWaitTrain) = $GUI_CHECKED Then
		$ichkCloseWaitTrain = 1
	Else
		$ichkCloseWaitTrain = 0
	EndIf
EndFunc   ;==>chkCloseWaitTrain

Func btnCloseWaitStop()
	If GUICtrlRead($btnCloseWaitStop) = $GUI_CHECKED Then
		$ibtnCloseWaitStop = 1
	Else
		$ibtnCloseWaitStop = 0
	EndIf
EndFunc   ;==>btnCloseWaitStop

Func btnCloseWaitStopRandom()
	If GUICtrlRead($btnCloseWaitStopRandom) = $GUI_CHECKED Then
		$ibtnCloseWaitStopRandom = 1
		$ibtnCloseWaitStop = 0
		GUICtrlSetState($btnCloseWaitStop, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	Else
		$ibtnCloseWaitStopRandom = 0
		If GUICtrlRead($chkCloseWaitEnable) = $GUI_CHECKED Then GUICtrlSetState($btnCloseWaitStop, $GUI_ENABLE)
	EndIf
EndFunc   ;==>btnCloseWaitStopRandom

Func btnCloseWaitRandom()
	If GUICtrlRead($btnCloseWaitExact) = $GUI_CHECKED Then
		$ibtnCloseWaitExact = 1
		$ibtnCloseWaitRandom = 0
		GUICtrlSetState($cmbCloseWaitRdmPercent, $GUI_DISABLE)
	ElseIf GUICtrlRead($btnCloseWaitRandom) = $GUI_CHECKED Then
		$ibtnCloseWaitExact = 0
		$ibtnCloseWaitRandom = 1
		If GUICtrlRead($chkCloseWaitEnable) = $GUI_CHECKED Then GUICtrlSetState($cmbCloseWaitRdmPercent, $GUI_ENABLE)
	Else
		$ibtnCloseWaitExact = 0
		$ibtnCloseWaitRandom = 0
		GUICtrlSetState($cmbCloseWaitRdmPercent, $GUI_DISABLE)
	EndIf
EndFunc   ;==>btnCloseWaitRandom

Func sldTrainITDelay()
	$isldTrainITDelay = GUICtrlRead($sldTrainITDelay)
	GUICtrlSetData($lbltxtTrainITDelayTime, $isldTrainITDelay & " ms")
EndFunc   ;==>sldTrainITDelay

Func chkTroopOrder2()
	;GUI OnEvent functions cannot have parameters, so below call is used for the default parameter
	chkTroopOrder()
EndFunc   ;==>chkTroopOrder2

Func chkTroopOrder($bNoiseMode = True)
	If GUICtrlRead($chkTroopOrder) = $GUI_CHECKED Then
		$ichkTroopOrder = 1
		GUICtrlSetState($btnTroopOrderSet, $GUI_ENABLE)
		For $i = 0 To UBound($aTroopOrderList) - 2
			GUICtrlSetState($cmbTroopOrder[$i], $GUI_ENABLE)
		Next
		If IsUseCustomTroopOrder() = True Then GUICtrlSetImage($ImgTroopOrderSet, $pIconLib, $eIcnRedLight)
	Else
		$ichkTroopOrder = 0
		GUICtrlSetState($btnTroopOrderSet, $GUI_DISABLE) ; disable button
		For $i = 0 To UBound($aTroopOrderList) - 2
			GUICtrlSetState($cmbTroopOrder[$i], $GUI_DISABLE) ; disable combo boxes
		Next
		SetDefaultTroopGroup($bNoiseMode) ; Reset troopgroup values to default
		If $bNoiseMode Or $debugsetlogTrain = 1 Then
			Local $sNewTrainList = ""
			For $i = 0 To UBound($DefaultTroopGroup) - 1
				$sNewTrainList &= $TroopName[$i] & ", "
			Next
			$sNewTrainList = StringLeft($sNewTrainList, StringLen($sNewTrainList)-2)
			Setlog("Current train order= " & $sNewTrainList, $COLOR_BLUE)
		EndIf
	EndIf
EndFunc   ;==>chkTroopOrder


Func chkDarkTroopOrder2()
	;GUI OnEvent functions cannot have parameters, so below call is used for the default parameter
	chkDarkTroopOrder()
EndFunc   ;==>chkDarkTroopOrder2

Func chkDarkTroopOrder($bNoiseMode = True)
	If GUICtrlRead($chkDarkTroopOrder) = $GUI_CHECKED Then
		$ichkDarkTroopOrder = 1
		GUICtrlSetState($btnDarkTroopOrderSet, $GUI_ENABLE)
		For $i = 0 To UBound($aDarkTroopOrderList) - 2
			GUICtrlSetState($cmbDarkTroopOrder[$i], $GUI_ENABLE)
		Next
		If IsUseCustomDarkTroopOrder() = True Then GUICtrlSetImage($ImgDarkTroopOrderSet, $pIconLib, $eIcnRedLight)
	Else
		$ichkDarkTroopOrder = 0
		GUICtrlSetState($btnDarkTroopOrderSet, $GUI_DISABLE) ; disable button
		For $i = 0 To UBound($aDarkTroopOrderList) - 2
			GUICtrlSetState($cmbDarkTroopOrder[$i], $GUI_DISABLE) ; disable combo boxes
		Next
		SetDefaultTroopGroupDark($bNoiseMode) ; Reset troopgroup values to default
		If $bNoiseMode Or $debugsetlogTrain = 1 Then
			Local $sNewTrainList = ""
			For $i = 0 To UBound($DefaultTroopGroupDark) - 1
				$sNewTrainList &= $TroopDarkName[$i] & ", "
			Next
			$sNewTrainList = StringLeft($sNewTrainList, StringLen($sNewTrainList)-2)
			Setlog("Current train order= " & $sNewTrainList, $COLOR_BLUE)
		EndIf
	EndIf
EndFunc   ;==>chkDarkTroopOrder


Func GUITrainOrder()
	Local $bDuplicate = False
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iCtrlIdImage = $iGUI_CtrlId + 1 ; record control ID for $ImgTroopOrder[$z] based on control of combobox that called this function
	Local $iTroopIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) + 1 ; find zero based index number of troop selected in combo box, add one for enum of proper icon

	GUICtrlSetImage($iCtrlIdImage, $pIconLib, $aTroopOrderIcon[$iTroopIndex]) ; set proper troop icon

	For $i = 0 To UBound($aTroopOrderList) - 2 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $cmbTroopOrder[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($cmbTroopOrder[$i]) Then
			GUICtrlSetImage($ImgTroopOrder[$i], $pIconLib, $eIcnOptions)
			_GUICtrlComboBox_SetCurSel($cmbTroopOrder[$i], -1)
			GUISetState()
			$bDuplicate = True
		EndIf
	Next
	If $bDuplicate = True Then
		GUICtrlSetState($BtnTroopOrderSet, $GUI_DISABLE) ; enable button to apply new order
		Return
	Else
		GUICtrlSetState($BtnTroopOrderSet, $GUI_ENABLE) ; enable button to apply new order
		GUICtrlSetImage($ImgTroopOrderSet, $pIconLib, $eIcnRedLight) ; set status indicator to show need to apply new order
	EndIf
EndFunc   ;==>GUITrainOrder

Func GUITrainDarkOrder()
	Local $bDuplicate = False
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iCtrlIdImage = $iGUI_CtrlId + 1 ; record control ID for $ImgTroopOrder[$z] based on control of combobox that called this function
	Local $iTroopIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) + 1 ; find zero based index number of troop selected in combo box, add one for enum of proper icon

	GUICtrlSetImage($iCtrlIdImage, $pIconLib, $aDarkTroopOrderIcon[$iTroopIndex]) ; set proper troop icon

	For $i = 0 To UBound($aDarkTroopOrderList) - 2 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $cmbDarkTroopOrder[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($cmbDarkTroopOrder[$i]) Then
			GUICtrlSetImage($ImgDarkTroopOrder[$i], $pIconLib, $eIcnOptions)
			_GUICtrlComboBox_SetCurSel($cmbDarkTroopOrder[$i], -1)
			GUISetState()
			$bDuplicate = True
		EndIf
	Next
	If $bDuplicate = True Then
		GUICtrlSetState($BtnDarkTroopOrderSet, $GUI_DISABLE) ; enable button to apply new order
		Return
	Else
		GUICtrlSetState($BtnDarkTroopOrderSet, $GUI_ENABLE) ; enable button to apply new order
		GUICtrlSetImage($ImgDarkTroopOrderSet, $pIconLib, $eIcnRedLight) ; set status indicator to show need to apply new order
	EndIf
EndFunc   ;==>GUITrainDarkOrder

Func BtnTroopOrderSet()
	Local $bReady = True ; Initialize ready to record troop order flag
	Local $sNewTrainList = ""

	; check for duplicate combobox index and flag with read color
	For $i = 0 To UBound($aTroopOrderList) - 2
		For $j = 0 To UBound($aTroopOrderList) - 2
			If $i = $j Then ContinueLoop ; skip if index are same
			If _GUICtrlComboBox_GetCurSel($cmbTroopOrder[$i]) = _GUICtrlComboBox_GetCurSel($cmbTroopOrder[$j]) Then
				_GUICtrlComboBox_SetCurSel($cmbTroopOrder[$j], -1)
				GUICtrlSetImage($ImgTroopOrder[$j], $pIconLib, $eIcnOptions)
				$bReady = False
			Else
				GUICtrlSetColor($cmbTroopOrder[$j], $COLOR_BLACK)
			EndIf
			$icmbTroopOrder[$i] = _GUICtrlComboBox_GetCurSel($cmbTroopOrder[$i]) ; update combo array variable with new value
		Next
	Next
	If $bReady Then
		ChangeTroopTrainOrder() ; code function to record new training order
		If @error Then
			Switch @error
				Case 1
					Setlog("Code problem, can not continue till fixed!", $COLOR_RED)
				Case 2
					Setlog("Bad Combobox selections, please fix!", $COLOR_RED)
				Case 3
					Setlog("Unable to Change Troop Train Order due bad change count!", $COLOR_RED)
				Case Else
					Setlog("Monkey ate bad banana, something wrong with ChangeTroopTrainOrder() code!", $COLOR_RED)
			EndSwitch
			GUICtrlSetImage($ImgTroopOrderSet, $pIconLib, $eIcnRedLight)
		Else
			Setlog("Troop training order changed successfully!", $COLOR_GREEN)
			For $i = 0 To UBound($DefaultTroopGroup) - 1
				$sNewTrainList &= $TroopName[$i] & ", "
			Next
			Setlog("Troop train order= " & $sNewTrainList, $COLOR_BLUE)
		EndIf
	Else
		Setlog("Must use all troops and No duplicate troop names!", $COLOR_RED)
		GUICtrlSetImage($ImgTroopOrderSet, $pIconLib, $eIcnRedLight)
	EndIf
	GUICtrlSetState(BtnTroopOrderSet, $GUI_DISABLE)
EndFunc   ;==>BtnTroopOrderSet

Func BtnDarkTroopOrderSet()
	Local $bReady = True ; Initialize ready to record troop order flag
	Local $sNewTrainList = ""

	; check for duplicate combobox index and flag with read color
	For $i = 0 To UBound($aDarkTroopOrderList) - 2
		For $j = 0 To UBound($aDarkTroopOrderList) - 2
			If $i = $j Then ContinueLoop ; skip if index are same
			If _GUICtrlComboBox_GetCurSel($cmbDarkTroopOrder[$i]) = _GUICtrlComboBox_GetCurSel($cmbDarkTroopOrder[$j]) Then
				_GUICtrlComboBox_SetCurSel($cmbDarkTroopOrder[$j], -1)
				GUICtrlSetImage($ImgDarkTroopOrder[$j], $pIconLib, $eIcnOptions)
				$bReady = False
			Else
				GUICtrlSetColor($cmbDarkTroopOrder[$j], $COLOR_BLACK)
			EndIf
			$icmbDarkTroopOrder[$i] = _GUICtrlComboBox_GetCurSel($cmbDarkTroopOrder[$i]) ; update combo array variable with new value
		Next
	Next
	If $bReady Then
		ChangeDarkTroopTrainOrder() ; code function to record new training order
		If @error Then
			Switch @error
				Case 1
					Setlog("Code problem, can not continue till fixed!", $COLOR_RED)
				Case 2
					Setlog("Bad Combobox selections, please fix!", $COLOR_RED)
				Case 3
					Setlog("Unable to Change Dark Troop Train Order due bad change count!", $COLOR_RED)
				Case Else
					Setlog("Monkey ate bad banana, something wrong with ChangeDarkTroopTrainOrder() code!", $COLOR_RED)
			EndSwitch
			GUICtrlSetImage($ImgDarkTroopOrderSet, $pIconLib, $eIcnRedLight)
		Else
			Setlog("Troop training order changed successfully!", $COLOR_GREEN)
			For $i = 0 To UBound($DefaultTroopGroupDark) - 1
				$sNewTrainList &= $TroopDarkName[$i] & ", "
			Next
			Setlog("Troop train order= " & $sNewTrainList, $COLOR_BLUE)
		EndIf
	Else
		Setlog("Must use all dark troops and No duplicate troop names!", $COLOR_RED)
		GUICtrlSetImage($ImgDarkTroopOrderSet, $pIconLib, $eIcnRedLight)
	EndIf
	GUICtrlSetState($BtnDarkTroopOrderSet, $GUI_DISABLE)
EndFunc   ;==>BtnDarkTroopOrderSet


Func ChangeTroopTrainOrder()

	If $debugsetlog = 1 Or $debugsetlogTrain = 1 Then Setlog("Begin Func ChangeTroopTrainOrder()", $COLOR_DEBUG) ;Debug

	; reference for original troopgroup list
	;$TroopGroup[10][3] = [["Arch", 1, 1], ["Giant", 2, 5], ["Wall", 4, 2], ["Barb", 0, 1], ["Gobl", 3, 1], ["Heal", 7, 14], ["Pekk", 9, 25], ["Ball", 5, 5], ["Wiza", 6, 4], ["Drag", 8, 20]]

	Local $sComboText = ""
	Local $NewTroopGroup[19][3]
	Local $iUpdateCount = 0

	If UBound($aTroopOrderList) - 1 <> UBound($TroopGroup) Then ; safety check in case troops are added
		If $debugsetlogTrain = 1 Then Setlog("UBound($aTroopOrderList) - 1: " & UBound($aTroopOrderList) - 1 & " = " & UBound($TroopGroup) & "UBound($TroopGroup)", $COLOR_DEBUG) ;Debug
		Setlog("Monkey ate bad banana, fix $aTroopOrderList & $TroopGroup arrays!", $COLOR_RED)
		SetError(1, 0, False)
		Return
	EndIf

	If IsUseCustomTroopOrder() = False Then ; check if no custom troop values saved yet.
		SetError(2, 0, False)
		Return
	EndIf

	For $i = 0 To UBound($aTroopOrderList) - 2 ; Look for match of combobox text to troopgroup and create new train order
		$sComboText = StringLeft(StringStripWS(GUICtrlRead($cmbTroopOrder[$i]), $STR_STRIPALL), 5)
		For $j = 0 To UBound($DefaultTroopGroup) - 1
			;Setlog("$i=" & $i & ", ComboSel=" & _GUICtrlComboBox_GetCurSel($cmbTroopOrder[$i]) & ", $DefaultTroopGroup[" & $j & "][0]: " & $DefaultTroopGroup[$j][0] & " = " & $sComboText& " :$sComboText" , $COLOR_DEBUG) ;Debug
			If StringInStr($sComboText, $j > 11 ? StringLeft($DefaultTroopGroup[$j][0], 3) : $DefaultTroopGroup[$j][0], $STR_NOCASESENSEBASIC) = 0 Then ContinueLoop
			$iUpdateCount += 1 ; keep count of troops updated to ensure success
			;Setlog("$iUpdateCount: " & $iUpdateCount , $COLOR_DEBUG) ;Debug  ; debug
			For $k = 0 To UBound($DefaultTroopGroup, 2) - 1 ; if true then assign next $i array element(s) in list to match in troopgroup
				$NewTroopGroup[$i][$k] = $DefaultTroopGroup[$j][$k]
			Next ; ; $NewTroopGroup[$i][$k] loop
			ExitLoop
		Next ; $DefaultTroopGroup[$j][x] loop
	Next ; $cmbTroopOrder[$i] loop

	If $iUpdateCount = UBound($DefaultTroopGroup, 1) Then ; safety check that all troops properly assigned to new array.
		For $j = 0 To UBound($DefaultTroopGroup) - 1
			For $k = 0 To UBound($DefaultTroopGroup, 2) - 1
				$TroopGroup[$j][$k] = $NewTroopGroup[$j][$k]
			Next
			If $debugsetlogTrain = 1 Then Setlog("$TroopGroup[" & $j & "]= " & $TroopGroup[$j][0] & ":" & $TroopGroup[$j][1] & ":" & $TroopGroup[$j][2], $COLOR_ORANGE)
		Next
		For $i = 0 To UBound($TroopGroup, 1) - 1
			$TroopName[$i] = $TroopGroup[$i][0]
			$TroopNamePosition[$i] = $TroopGroup[$i][1]
			$TroopHeight[$i] = $TroopGroup[$i][2]
		Next
		GUICtrlSetImage($ImgTroopOrderSet, $pIconLib, $eIcnGreenLight)
	Else
		Setlog($iUpdateCount & "|" & UBound($DefaultTroopGroup, 1) & " - Error - Bad troop assignment in ChangeTroopTrainOrder()", $COLOR_RED)
		SetError(3, 0, False)
		Return
	EndIf

	Return True

EndFunc   ;==>ChangeTroopTrainOrder

Func ChangeDarkTroopTrainOrder()

	If $debugsetlog = 1 Or $debugsetlogTrain = 1 Then Setlog("Begin Func ChangeDarkTroopTrainOrder()", $COLOR_DEBUG) ;Debug

	Local $sComboText = ""
	Local $NewTroopGroup[7][3]
	Local $iUpdateCount = 0

	If UBound($aDarkTroopOrderList) - 1 <> UBound($TroopGroupDark) Then ; safety check in case troops are added
		If $debugsetlogTrain = 1 Then Setlog("UBound($aDarkTroopOrderList) - 1: " & UBound($aDarkTroopOrderList) - 1 & " = " & UBound($TroopGroupDark) & "UBound($TroopGroupDark)", $COLOR_DEBUG) ;Debug
		Setlog("Monkey ate bad banana, fix $aDarkTroopOrderList & $TroopGroupDark arrays!", $COLOR_RED)
		SetError(1, 0, False)
		Return
	EndIf

	If IsUseCustomDarkTroopOrder() = False Then ; check if no custom troop values saved yet.
		SetError(2, 0, False)
		Return
	EndIf

	For $i = 0 To UBound($aDarkTroopOrderList) - 2 ; Look for match of combobox text to troopgroup and create new train order
		$sComboText = StringLeft(StringStripWS(GUICtrlRead($cmbDarkTroopOrder[$i]), $STR_STRIPALL), 5)
		For $j = 0 To UBound($DefaultTroopGroupDark) - 1
			;Setlog("$i=" & $i & ", ComboSel=" & _GUICtrlComboBox_GetCurSel($cmbDarkTroopOrder[$i]) & ", $DefaultTroopGroupDark[" & $j & "][0]: " & StringLeft($DefaultTroopGroupDark[$j][0], 3) & " = " & $sComboText& " :$sComboText" , $COLOR_DEBUG) ;Debug
			If StringInStr($sComboText, StringLeft($DefaultTroopGroupDark[$j][0],3), $STR_NOCASESENSEBASIC) = 0 Then ContinueLoop
			$iUpdateCount += 1 ; keep count of troops updated to ensure success
			;Setlog("$iUpdateCount: " & $iUpdateCount , $COLOR_DEBUG) ;Debug  ; debug
			For $k = 0 To UBound($DefaultTroopGroupDark, 2) - 1 ; if true then assign next $i array element(s) in list to match in troopgroup
				$NewTroopGroup[$i][$k] = $DefaultTroopGroupDark[$j][$k]
			Next ; ; $NewTroopGroupDark[$i][$k] loop
			ExitLoop
		Next ; $DefaultTroopGroupDark[$j][x] loop
	Next ; $cmbDarkTroopOrder[$i] loop

	If $iUpdateCount = UBound($DefaultTroopGroupDark, 1) Then ; safety check that all troops properly assigned to new array.
		For $j = 0 To UBound($DefaultTroopGroupDark) - 1
			For $k = 0 To UBound($DefaultTroopGroupDark, 2) - 1
				$TroopGroupDark[$j][$k] = $NewTroopGroup[$j][$k]
			Next
			If $debugsetlogTrain = 1 Then Setlog("$TroopGroupDark[" & $j & "]= " & $TroopGroupDark[$j][0] & ":" & $TroopGroupDark[$j][1] & ":" & $TroopGroupDark[$j][2], $COLOR_ORANGE)
		Next
		For $i = 0 To UBound($TroopGroupDark, 1) - 1
			$TroopDarkName[$i] = $TroopGroupDark[$i][0]
			$TroopDarkNamePosition[$i] = $TroopGroupDark[$i][1]
			$TroopDarkHeight[$i] = $TroopGroupDark[$i][2]
		Next
		GUICtrlSetImage($ImgDarkTroopOrderSet, $pIconLib, $eIcnGreenLight)
	Else
		Setlog("Error - Bad troop assignment in ChangeDarkTroopTrainOrder()", $COLOR_RED)
		SetError(3, 0, False)
		Return
	EndIf

	Return True

EndFunc   ;==>ChangeDarkTroopTrainOrder

Func SetDefaultTroopGroup($bNoiseMode = True)
	;
	; $TroopGroup[10][3] = [["Arch", 1, 1], ["Giant", 2, 5], ["Wall", 4, 2], ["Barb", 0, 1], ["Gobl", 3, 1], ["Heal", 7, 14], ["Pekk", 9, 25], ["Ball", 5, 5], ["Wiza", 6, 4], ["Drag", 8, 20]]
	;
	For $i = 0 To UBound($DefaultTroopGroup, 1) - 1
		For $j = 0 To UBound($DefaultTroopGroup, 2) - 1
			$TroopGroup[$i][$j] = $DefaultTroopGroup[$i][$j]
		Next
	Next
	For $i = 0 To UBound($DefaultTroopGroup, 1) - 1
		$TroopName[$i] = $TroopGroup[$i][0]
		$TroopNamePosition[$i] = $TroopGroup[$i][1]
		$TroopHeight[$i] = $TroopGroup[$i][2]
	Next
	If $bNoiseMode Or $debugsetlogTrain = 1 Then Setlog("Default troop training order set", $COLOR_GREEN)
EndFunc   ;==>SetDefaultTroopGroup

Func SetDefaultTroopGroupDark($bNoiseMode = True)
	;
	; $DefaultTroopGroupDark[7][3] = [["Mini", 0, 2], ["Hogs", 1, 5], ["Valk", 2, 8], ["Gole", 3, 30], ["Witc", 4, 12], ["Lava", 5, 30], ["Bowl", 6, 6]]
	;
	For $i = 0 To UBound($DefaultTroopGroupDark, 1) - 1
		For $j = 0 To UBound($DefaultTroopGroupDark, 2) - 1
			$TroopGroupDark[$i][$j] = $DefaultTroopGroupDark[$i][$j]
		Next
	Next
	For $i = 0 To UBound($DefaultTroopGroupDark, 1) - 1
		$TroopDarkName[$i] = $TroopGroupDark[$i][0]
		$TroopDarkNamePosition[$i] = $TroopGroupDark[$i][1]
		$TroopDarkHeight[$i] = $TroopGroupDark[$i][2]
	Next
	If $bNoiseMode Or $debugsetlogTrain = 1 Then Setlog("Default dark troop training order set", $COLOR_GREEN)
EndFunc   ;==>SetDefaultTroopGroupDark

Func IsUseCustomTroopOrder()
	For $i = 0 To UBound($aTroopOrderList) - 2 ; Check if custom train order has been used to select log message
		If $icmbTroopOrder[$i] = -1 Then
			If $debugsetlogTrain = 1 Then Setlog("Custom train order not used...", $COLOR_DEBUG) ;Debug
			Return False
		EndIf
	Next
	If $debugsetlogTrain = 1 Then Setlog("Custom train order used...", $COLOR_DEBUG) ;Debug
	Return True
EndFunc   ;==>IsUseCustomTroopOrder

Func IsUseCustomDarkTroopOrder()
	For $i = 0 To UBound($aDarkTroopOrderList) - 2 ; Check if custom train order has been used to select log message
		If $icmbDarkTroopOrder[$i] = -1 Then
			If $debugsetlogTrain = 1 Then Setlog("Custom dark train order not used...", $COLOR_DEBUG) ;Debug
			Return False
		EndIf
	Next
	If $debugsetlogTrain = 1 Then Setlog("Custom dark train order used...", $COLOR_DEBUG) ;Debug
	Return True
EndFunc   ;==>IsUseCustomDarkTroopOrder

;==============================================================
; SmartZap - Added by DocOC team
;==============================================================
Func chkSmartLightSpell()
	If GUICtrlRead($chkSmartLightSpell) = $GUI_CHECKED Then
		GUICtrlSetState($chkSmartZapDB, $GUI_ENABLE)
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_ENABLE)
		GUICtrlSetState($txtMinDark, $GUI_ENABLE)
		GUICtrlSetState($chkNoobZap, $GUI_ENABLE)
		$ichkSmartZap = 1
	Else
		GUICtrlSetState($chkSmartZapDB, $GUI_DISABLE)
		GUICtrlSetState($chkSmartZapSaveHeroes, $GUI_DISABLE)
		GUICtrlSetState($txtMinDark, $GUI_DISABLE)
		GUICtrlSetState($chkNoobZap, $GUI_DISABLE)
		$ichkSmartZap = 0
	EndIf
EndFunc   ;==>chkSmartLightSpell

Func ForceTimeStopAtk()
	If GUICtrlRead($chkSmartLightSpell) = $GUI_CHECKED And GUICtrlRead($chkDBTimeStopAtk) = $GUI_CHECKED Then
		GUICtrlSetState($chkDBTimeStopAtk, $GUI_UNCHECKED)
		$ichkTimeStopAtk[$DB] = 0
	EndIf
	If GUICtrlRead($chkSmartLightSpell) = $GUI_CHECKED And GUICtrlRead($chkABTimeStopAtk) = $GUI_CHECKED Then
		GUICtrlSetState($chkABTimeStopAtk, $GUI_UNCHECKED)
		$ichkTimeStopAtk[$LB] = 0
	EndIf
EndFunc   ;==>ForceTimeStopAtk

Func chkNoobZap()
	If GUICtrlRead($chkNoobZap) = $GUI_CHECKED Then
		GUICtrlSetState($txtExpectedDE, $GUI_ENABLE)
		$ichkNoobZap = 1
	Else
		GUICtrlSetState($txtExpectedDE, $GUI_DISABLE)
		$ichkNoobZap = 0
	EndIf
EndFunc   ;==>chkDumbZap

Func chkSmartZapDB()
    If GUICtrlRead($chkSmartZapDB) = $GUI_CHECKED Then
        $ichkSmartZapDB = 1
    Else
        $ichkSmartZapDB = 0
    EndIf
EndFunc   ;==>chkSmartZapDB

Func chkSmartZapSaveHeroes()
    If GUICtrlRead($chkSmartZapSaveHeroes) = $GUI_CHECKED Then
        $ichkSmartZapSaveHeroes = 1
    Else
        $ichkSmartZapSaveHeroes = 0
    EndIf
EndFunc   ;==>chkSmartZapSaveHeroes

Func txtMinDark()
	$itxtMinDE = GUICtrlRead($txtMinDark)
EndFunc   ;==>txtMinDark

Func txtExpectedDE()
	$itxtExpectedDE = GUICtrlRead($txtExpectedDE)
EndFunc   ;==>TxtExpectedDE
;==========================END=================================
;			 SmartZap - Added by DocOC team
;==============================================================

Func leftclick()
	If $iGUIEnabled = False Then Return
	$ilftclck = GUIGetCursorInfo($frmBot)
	Switch $ilftclck[4]
		;Troops
		Case $icnBarb
			LevUpDown("Barb")
			lblTotalCount()
		Case $icnArch
			LevUpDown("Arch")
			lblTotalCount()
		Case $icnGiant
			LevUpDown("Giant")
			lblTotalCount()
		Case $icnGobl
			LevUpDown("Gobl")
			lblTotalCount()
		Case $icnWall
			LevUpDown("Wall")
			lblTotalCount()
		Case $icnWiza
			LevUpDown("Wiza")
			lblTotalCount()
		Case $icnBall
			LevUpDown("Ball")
			lblTotalCount()
		Case $icnHeal
			LevUpDown("Heal")
			lblTotalCount()
		Case $icnDrag
			LevUpDown("Drag")
			lblTotalCount()
		Case $icnPekk
			LevUpDown("Pekk")
			lblTotalCount()
		Case $icnBabyD
			LevUpDown("BabyD")
			lblTotalCount()
		Case $icnMine
			LevUpDown("Mine")
			lblTotalCount()
		Case $icnMini
			LevUpDown("Mini")
			lblTotalCount()
		Case $icnHogs
			LevUpDown("Hogs")
			lblTotalCount()
		Case $icnValk
			LevUpDown("Valk")
			lblTotalCount()
		Case $icnGole
			LevUpDown("Gole")
			lblTotalCount()
		Case $icnWitc
			LevUpDown("Witc")
			lblTotalCount()
		Case $icnLava
			LevUpDown("Lava")
			lblTotalCount()
		Case $icnBowl
			LevUpDown("Bowl")
			lblTotalCount()
		;Spell
		Case $lblLightningIcon
			LevUpDown("LightningSpell")
			lblTotalCountSpell()
		Case $lblHealIcon
			LevUpDown("HealSpell")
			lblTotalCountSpell()
		Case $lblRageIcon
			LevUpDown("RageSpell")
			lblTotalCountSpell()
		Case $lblJumpSpellIcon
			LevUpDown("JumpSpell")
			lblTotalCountSpell()
		Case $lblFreezeIcon
			LevUpDown("FreezeSpell")
			lblTotalCountSpell()
		Case $lblCloneIcon
			LevUpDown("CloneSpell")
			lblTotalCountSpell()
		Case $lblPoisonIcon
			LevUpDown("PoisonSpell")
			lblTotalCountSpell()
		Case $lblEarthquakeIcon
			LevUpDown("EarthSpell")
			lblTotalCountSpell()
		Case $lblHasteIcon
			LevUpDown("HasteSpell")
			lblTotalCountSpell()
		Case $lblSkeletonIcon
			LevUpDown("SkeletonSpell")
			lblTotalCountSpell()
	EndSwitch
	Return
EndFunc   ;==>leftclick

Func rightclick()
	If $iGUIEnabled = False Then Return
	$irghtclck = GUIGetCursorInfo($frmBot)
	Switch $irghtclck[4]
		;Troops
		Case $icnBarb
			LevUpDown("Barb")
			lblTotalCount()
		Case $icnArch
			LevUpDown("Arch")
			lblTotalCount()
		Case $icnGiant
			LevUpDown("Giant")
			lblTotalCount()
		Case $icnGobl
			LevUpDown("Gobl")
			lblTotalCount()
		Case $icnWall
			LevUpDown("Wall")
			lblTotalCount()
		Case $icnWiza
			LevUpDown("Wiza")
			lblTotalCount()
		Case $icnBall
			LevUpDown("Ball")
			lblTotalCount()
		Case $icnHeal
			LevUpDown("Heal")
			lblTotalCount()
		Case $icnDrag
			LevUpDown("Drag")
			lblTotalCount()
		Case $icnPekk
			LevUpDown("Pekk")
			lblTotalCount()
		Case $icnBabyD
			LevUpDown("BabyD")
			lblTotalCount()
		Case $icnMine
			LevUpDown("Mine")
			lblTotalCount()
		Case $icnMini
			LevUpDown("Mini")
			lblTotalCount()
		Case $icnHogs
			LevUpDown("Hogs")
			lblTotalCount()
		Case $icnValk
			LevUpDown("Valk")
			lblTotalCount()
		Case $icnGole
			LevUpDown("Gole")
			lblTotalCount()
		Case $icnWitc
			LevUpDown("Witc")
			lblTotalCount()
		Case $icnLava
			LevUpDown("Lava")
			lblTotalCount()
		Case $icnBowl
			LevUpDown("Bowl")
			lblTotalCount()
		;Spell
		Case $lblLightningIcon
			LevUpDown("LightningSpell")
			lblTotalCountSpell()
		Case $lblHealIcon
			LevUpDown("HealSpell")
			lblTotalCountSpell()
		Case $lblRageIcon
			LevUpDown("RageSpell")
			lblTotalCountSpell()
		Case $lblJumpSpellIcon
			LevUpDown("JumpSpell")
			lblTotalCountSpell()
		Case $lblFreezeIcon
			LevUpDown("FreezeSpell")
			lblTotalCountSpell()
		Case $lblCloneIcon
			LevUpDown("CloneSpell")
			lblTotalCountSpell()
		Case $lblPoisonIcon
			LevUpDown("PoisonSpell")
			lblTotalCountSpell()
		Case $lblEarthquakeIcon
			LevUpDown("EarthSpell")
			lblTotalCountSpell()
		Case $lblHasteIcon
			LevUpDown("HasteSpell")
			lblTotalCountSpell()
		Case $lblSkeletonIcon
			LevUpDown("SkeletonSpell")
			lblTotalCountSpell()
	EndSwitch
	Return
EndFunc   ;==>rightclick

Func LevUpDown($SelTroopSpell)
	Local $TempClick
	While _IsPressed(01)
		$TempClick = Eval("txtNum" & $SelTroopSpell) + 1
		GUICtrlSetData(Eval("txtNum" & $SelTroopSpell), GUICtrlRead(Eval("txtNum" & $SelTroopSpell)) + 1)
		Sleep(150)
	WEnd

	While _IsPressed(02)
		$TempClick = Eval("txtNum" & $SelTroopSpell) - 1
		GUICtrlSetData(Eval("txtNum" & $SelTroopSpell), GUICtrlRead(Eval("txtNum" & $SelTroopSpell)) - 1)
		Sleep(150)
	WEnd
EndFunc   ;==>LevUpDown
