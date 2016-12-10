; #FUNCTION# ====================================================================================================================
; Name ..........: Global Variables - Mod.au3
; Description ...: Extension of MBR Global Variables for Mod
; Syntax ........: #include , Global
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

;Variables for SwitchAcc Mode - DEMEN
Global $profile = $sProfilePath & "\Profile.ini"
Global $aconfig[8]
Global $ichkSwitchAcc = 0

Global $icmbTotalCoCAcc		; 0 = 6, 1 = 1 account, 2 = 2 accounts
Global $nTotalCoCAcc = 6
Global $ichkSmartSwitch = 1

Global $ichkCloseTraining = 0

Global $nCurProfile = 1
Global $ProfileList
Global $nTotalProfile = 1

Global $ProfileType			; Type of the Current Profile, 1 = active, 2 = donate, 3 = idle
Global $aProfileType[8]		; Type of the all Profiles, 1 = active, 2 = donate, 3 = idle

Global $MatchProfileAcc		; Account match with Current Profile
Global $aMatchProfileAcc[8]	; Accounts match with All Profiles

Global $DonateSwitchCounter = 0

Global $bReMatchAcc = False

Global $aTimerStart[8]
Global $aTimerEnd[8]
Global $aRemainTrainTime[8]
Global $aUpdateRemainTrainTime[8]
Global $nNexProfile
Global $nMinRemainTrain

Global $aAccPosY[6]

;Forecast
Global Const $COLOR_DEEPPINK = 0xFF1493
Global Const $COLOR_DARKGREEN = 0x006400
Global $oIE = ObjCreate("Shell.Explorer.2")
Global $dtStamps[0]
Global $lootMinutes[0]
Global $timeOffset = 0
Global $TimerForecast = 0
Global $lootIndexScaleMarkers
Global $currentForecast
Global $chkForecastPause, $txtForecastPause
Global $iChkForecastPause, $iTxtForecastPause
Global $iChkDontRemoveredzone, $chkDontRemoveredzone
Global $chkForecastBoost, $txtForecastBoost
Global $iChkForecastBoost, $iTxtForecastBoost
Global $cmbForecastHopingSwitchMax, $cmbForecastHopingSwitchMin
Global $ichkForecastHopingSwitchMax, $icmbForecastHopingSwitchMax, $itxtForecastHopingSwitchMax, $ichkForecastHopingSwitchMin, $icmbForecastHopingSwitchMin, $itxtForecastHopingSwitchMin

; ChatBot -modification by rulesss
Global $FoundChatMessage = 0
Global $ChatbotStartTime

;==========;Russian Languages by Kychera==========
Global $chkRusLang
Global $ichkRusLang = 0
Global $chkRusLang2
Global $ichkRusLang2 = 0
;==========;Russian Languages by Kychera==========


; Multi Finger Attack Style Setting
Global Enum $directionLeft, $directionRight
Global Enum $sideBottomRight, $sideTopLeft, $sideBottomLeft, $sideTopRight
Global Enum $mfRandom, $mfFFStandard, $mfFFSpiralLeft, $mfFFSpiralRight, $mf8FBlossom, $mf8FImplosion, $mf8FPinWheelLeft, $mf8FPinWheelRight

Global $iMultiFingerStyle = 1

Global Enum  $eCCSpell = $eHaSpell + 1

; CSV Deployment Speed Mod
Global $isldSelectedCSVSpeed[$iModeCount], $iCSVSpeeds[19]
$isldSelectedCSVSpeed[$DB] = 4
$isldSelectedCSVSpeed[$LB] = 4
$iCSVSpeeds[0] = .1
$iCSVSpeeds[1] = .25
$iCSVSpeeds[2] = .5
$iCSVSpeeds[3] = .75
$iCSVSpeeds[4] = 1
$iCSVSpeeds[5] = 1.25
$iCSVSpeeds[6] = 1.5
$iCSVSpeeds[7] = 1.75
$iCSVSpeeds[8] = 2
$iCSVSpeeds[9] = 2.25
$iCSVSpeeds[10] = 2.5
$iCSVSpeeds[11] = 2.75
$iCSVSpeeds[12] = 3
$iCSVSpeeds[13] = 5
$iCSVSpeeds[14] = 8
$iCSVSpeeds[15] = 10
$iCSVSpeeds[16] = 20
$iCSVSpeeds[17] = 50
$iCSVSpeeds[18] = 99