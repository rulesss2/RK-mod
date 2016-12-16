; #FUNCTION# ====================================================================================================================
; Name ..........: CheckZoomOut
; Description ...:
; Syntax ........: CheckZoomOut()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #12
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func CheckZoomOut($Attack = False)
	If $Attack = True Then WaitForClouds()
	Local $aVillageResult = SearchZoomOut(@ScriptDir & "\imgxml\zoomout", $CenterVillage[0], $Attack)
	If StringInStr($aVillageResult[0], "zoomou") = 0 Then
		; not zoomed out, Return
		SetLog("Not Zoomed Out! Exiting to MainScreen...", $COLOR_ERROR)
		checkMainScreen() ;exit battle screen
		$Restart = True ; Restart Attack
		$Is_ClientSyncError = True ; quick restart
		Return False
	EndIf
	Return True
EndFunc   ;==>CheckZoomOut
