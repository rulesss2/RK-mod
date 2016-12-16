; #FUNCTION# ====================================================================================================================
; Name ..........: Config read - Mod.au3
; Description ...: Extension of readConfig() for Mod
; Syntax ........: readConfig()
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

   ; Config Read for SwitchAcc Mode - DEMEN
		$ichkSwitchAcc = IniRead($profile, "Switch Account", "Enable", "0")
		$icmbTotalCoCAcc = IniRead($profile, "Switch Account", "Total Coc Account", "0")	; 0 = AutoDetect
		$ichkSmartSwitch = IniRead($profile, "Switch Account", "Smart Switch", "1")
		$ichkCloseTraining = Number(IniRead($profile, "Switch Account", "Sleep Combo", "0"))	; Sleep Combo, 1 = Close CoC, 2 = Close Android, 0 = No sleep

		$ProfileType = IniRead($config, "Switch Account", "Profile Type", "")
		$MatchProfileAcc = IniRead($config, "Switch Account", "Match Profile Acc", "")

	For $i = 1 to 6
		IniReadS($aAccPosY[$i - 1], $profile, "Acc Location", "yAccNo." & $i, "-1")
	Next


      ; Config for Adding Quicktrain Combo - DEMEN
	  IniReadS($iRadio_Army12, $config, "troop", "QuickTrain12", "0")
	  IniReadS($iRadio_Army123, $config, "troop", "QuickTrain123", "0")

      ;Forecast
	  $iTxtForecastBoost = IniRead($config, "forecast", "txtForecastBoost", "6.0")
	  $iChkForecastBoost = IniRead($config, "forecast", "chkForecastBoost", "0")
	  $ichkForecastHopingSwitchMax = IniRead($config, "profiles", "chkForecastHopingSwitchMax", "0")
	  $icmbForecastHopingSwitchMax = IniRead($config, "profiles", "cmbForecastHopingSwitchMax", "0")
	  $itxtForecastHopingSwitchMax = IniRead($config, "profiles", "txtForecastHopingSwitchMax", "2.5")
	  $ichkForecastHopingSwitchMin = IniRead($config, "profiles", "chkForecastHopingSwitchMin", "0")
	  $icmbForecastHopingSwitchMin = IniRead($config, "profiles", "cmbForecastHopingSwitchMin", "0")
	  $itxtForecastHopingSwitchMin = IniRead($config, "profiles", "txtForecastHopingSwitchMin", "2.5")

	  ;modification Chat by rulesss
	  $ichkchatdelay = IniRead($config, "global", "chdelay", "0")

	  ; Android Settings
	  $sAndroid = IniRead($config, "Android", "Emulator", "<No Emulators>")
	  $sAndroidInstance = IniRead($config, "Android", "Instance", "")

	  ; Misc Battle Settings - Added by rulesss
	  $AndroidAdbClicksEnabled = IniRead($config, "Fast Clicks", "UseADBFastClicks", "0")

	  ;==========;Russian Languages by Kychera==========
	   $ichkRusLang = IniRead($config, "Lang", "chkRusLang", "0")
       $ichkRusLang2 = IniRead($config, "Lang", "chkRusLang2", "0")
	  ;==========;Russian Languages by Kychera==========

	  ; Multi Finger - Added by rulesss
      $iMultiFingerStyle = IniRead($config, "MultiFinger", "Select", "2")
	  ;=======

	  ; CSV Deployment Speed Mod-- Added by rulesss
		IniReadS($isldSelectedCSVSpeed[$DB], $config, "attack", "CSVSpeedDB", 3)
		IniReadS($isldSelectedCSVSpeed[$LB], $config, "attack", "CSVSpeedAB", 3)