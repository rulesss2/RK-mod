; #FUNCTION# ====================================================================================================================
; Name ..........: DropSpellFromINIOnDefense
; Description ...:
; Syntax ........: DropSpellFromINIOnDefense($Defense, $options, $qtaMin, $qtaMax, $troopName, $delayPointmin,
;                  $delayPointmax, $delayDropMin, $delayDropMax, $sleepafterMin, $sleepAfterMax[, $debug = False])
; Parameters ....: $Defense             -
;                  $options             -
;                  $qtaMin              -
;                  $qtaMax              -
;                  $troopName           -
;                  $delayPointmin       -
;                  $delayPointmax       -
;                  $delayDropMin        -
;                  $delayDropMax        -
;                  $sleepafterMin       -
;                  $sleepAfterMax       -
;                  $debug               - [optional] Default is False.
; Return values .: None
; Author ........: Just changed DropTroopFromINI() Function from Sardo
; Modified ......: MR.ViPER (19-9-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $debugDropSCommand = 0, $LocateMode = 1 ; Can be 1 OR 2, CURRENTLY 2 is not completed

Func DropSpellFromINIOnDefense($Defense, $options, $qtaMin, $qtaMax, $troopName, $delayPointmin, $delayPointmax, $delayDropMin, $delayDropMax, $sleepafterMin, $sleepAfterMax, $debug = False)
	If $debugDropSCommand = 1 Then SetLog("Func DropSpellFromINIOnDefense(" & $Defense & ", " & $options & ")", $COLOR_DEBUG) ;Debug
	debugAttackCSV("drop using Defense " & $Defense & " and using " & $qtaMin & "-" & $qtaMax & " of " & $troopName)
	debugAttackCSV(" - delay for multiple troops in same point: " & $delayPointmin & "-" & $delayPointmax)
	debugAttackCSV(" - delay when  change deploy point : " & $delayDropMin & "-" & $delayDropMax)
	debugAttackCSV(" - delay after drop all troops : " & $sleepafterMin & "-" & $sleepAfterMax)
	$FullDefenseName = GetFullDefenseName($Defense)
	;Qty to drop
	If $qtaMin <> $qtaMax Then
		Local $qty = Random($qtaMin, $qtaMax, 1)
	Else
		Local $qty = $qtaMin
	EndIf
	debugAttackCSV(">> qty to deploy: " & $qty)

	;number of troop to drop in one point...
	Local $qtyxpoint = Int($qty)
	debugAttackCSV(">> qty x point: " & $qtyxpoint)
	;search slot where is the troop...
	Local $troopPosition = -1
	For $i = 0 To UBound($atkTroops) - 1
		If $atkTroops[$i][0] = Eval("e" & $troopName) Then
			$troopPosition = $i
		EndIf
	Next

	Local $usespell = True
	Switch Eval("e" & $troopName)
		Case $eLSpell
			If $ichkLightSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eHSpell
			If $ichkHealSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eRSpell
			If $ichkRageSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eJSpell
			If $ichkJumpSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eFSpell
			If $ichkFreezeSpell[$iMatchMode] = 0 Then $usespell = False
			;		Case $eCSpell
			;			If $ichkCloneSpell[$iMatchMode] = 0 Then $usespell = False
		Case $ePSpell
			If $ichkPoisonSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eESpell
			If $ichkEarthquakeSpell[$iMatchMode] = 0 Then $usespell = False
		Case $eHaSpell
			If $ichkHasteSpell[$iMatchMode] = 0 Then $usespell = False
			;		Case $eSkSpell
			;			If $ichkSkeletonSpell[$iMatchMode] = 0 Then $usespell = False
	EndSwitch

	If $troopPosition = -1 Or $usespell = False Then
		If $usespell = True Then
			Setlog("No troop found in your attack troops list")
			debugAttackCSV("No troop found in your attack troops list")
		Else
			If $DebugSetLog = 1 Then SetLog("discard use spell", $COLOR_DEBUG) ;Debug
		EndIf

	Else

		;Local $SuspendMode = SuspendAndroid()

		SelectDropTroop($troopPosition) ; select the troop...
		;drop

		Local $tempquant = 0

		If $delayDropMin <> $delayDropMax Then
			$delayDrop = Random($delayDropMin, $delayDropMax, 1)
		Else
			$delayDrop = $delayDropMin
		EndIf

		Local $delayDropLast = 0
		$delayDropLast = $delayDrop
		;$pixel = Execute("$" & Eval("vector" & $j) & "[" & $index - 1 & "]")

		$DefenseResult = AssignPixelOfDefense($Defense, $options)
		Local $pixel[2] = [$DefenseResult[4], $DefenseResult[5]]
		If $DefenseResult[1] = False Then ; If Defense didn't located
			CheckHeroesHealth() ; check hero health == does nothing if hero not dropped
			ReleaseClicks()
			Return
		EndIf
		If IsArray($pixel) Then
			If UBound($pixel) >= 2 Then
				If $pixel[1] <= 0 Then ; If Defense didn't located
					CheckHeroesHealth() ; check hero health == does nothing if hero not dropped
					ReleaseClicks()
					Return
				EndIf
			EndIf
		EndIf
		If $DefenseResult[3] <> "" Then SetLog($DefenseResult[3])

		If $debugDropSCommand = 1 And IsArray($pixel) Then SetLog("$pixel[0] = " & $pixel[0] & " $pixel[1] = " & $pixel[1])
		Local $qty2 = $qtyxpoint

		;delay time between 2 drops in same point
		If $delayPointmin <> $delayPointmax Then
			Local $delayPoint = Random($delayPointmin, $delayPointmax, 1)
		Else
			Local $delayPoint = $delayPointmin
		EndIf

		Local $plural = 0
		If $qty2 > 1 Then $plural = 1

		Switch Eval("e" & $troopName)
			Case $eLSpell To $eSkSpell
				If $debug = True Then
					Setlog("Drop Spell AttackClick( " & $pixel[0] & ", " & $pixel[1] & " , " & $qty2 & ", " & $delayPoint & ",#0666)")
				Else
					AttackClick($pixel[0], $pixel[1], $qty2, $delayPoint, $delayDropLast, "#0667")
					If $qty2 > 0 And $DefenseResult[1] = True Then Setlog(" » Dropping " & $qty2 & " of " & NameOfTroop(Eval("e" & $troopName), $plural) & _
							IIf($DefenseResult[2] = True, " Between ", "") & IIf($DefenseResult[2] = True, $FullDefenseName, " On " & $FullDefenseName) & IIf($DefenseResult[2] = True, "(s)", ""))
				EndIf
			Case Else
				Setlog("Error parsing line")
		EndSwitch
		debugAttackCSV($troopName & " qty " & $qty2 & " in (" & $pixel[0] & "," & $pixel[1] & ") delay " & $delayPoint)
		;;;;if $j <> $numbersOfVectors Then _sleep(5) ;little delay by passing from a vector to another vector

		ReleaseClicks()
		;SuspendAndroid($SuspendMode)

		;sleep time after deploy all troops
		Local $sleepafter = 0
		If $sleepafterMin <> $sleepAfterMax Then
			$sleepafter = Random($sleepafterMin, $sleepAfterMax, 1)
		Else
			$sleepafter = Int($sleepafterMin)
		EndIf
		If $sleepafter > 0 And IsKeepClicksActive() = False Then
			debugAttackCSV(">> delay after drop all troops: " & $sleepafter)
			If $sleepafter <= 1000 Then ; check SLEEPAFTER value is less than 1 second?
				If _Sleep($sleepafter) Then Return
				CheckHeroesHealth() ; check hero health == does nothing if hero not dropped
			Else ; $sleepafter is More than 1 second, then improve pause/stop button response with max 1 second delays
				For $z = 1 To Int($sleepafter / 1000) ; Check hero health every second while while sleeping
					If _Sleep(980) Then Return ; sleep 1 second minus estimated herohealthcheck time when heroes not activiated
					CheckHeroesHealth() ; check hero health == does nothing if hero not dropped
				Next
				If _Sleep(Mod($sleepafter, 1000)) Then Return ; $sleepafter must be integer for MOD function return correct value!
				CheckHeroesHealth() ; check hero health == does nothing if hero not dropped
			EndIf
		EndIf
	EndIf

EndFunc   ;==>DropSpellFromINIOnDefense

Func GetFullDefenseName($Defense)
	If $debugDropSCommand = 1 Then SetLog("Func GetFullDefenseName(" & $Defense & ")", $COLOR_DEBUG) ;Debug
	Select
		Case $Defense = "EAGLE"
			Return "Eagle"
		Case $Defense = "INFERNO"
			Return "Inferno Tower"
		Case $Defense = "ADEFENSE"
			Return "Air Defense"
		Case Else
			Return "Unknown Defense"
	EndSelect
EndFunc   ;==>GetFullDefenseName

Func AssignPixelOfDefense($Defense, $options, $forceReLocate = False)
	If $debugDropSCommand = 1 Then SetLog("Func AssignPixelOfDefense(" & $Defense & ", " & $options & ", " & $forceReLocate & ")", $COLOR_DEBUG) ;Debug
	Local $LocateResult
	Switch $forceReLocate
		Case True
			ResetDefensesLocation($Defense)
			$LocateResult = LocateDefense($Defense, $options)
		Case Else
			$LocateResult = LocateDefense($Defense, $options)
			#cs
				If isLocatedBefore($Defense) = False Then
				$LocateResult = LocateDefense($Defense, $options)
				Else
				$LocateResult = LocateDefense($Defense, $options)
				EndIf
			#ce
	EndSwitch

	Switch $Defense
		Case "EAGLE"
			_ArrayMerge($LocateResult, $PixelEaglePos) ; Merging Arrays To Keep Return 1D Array And More Clear, [4] = $X  AND [5] = $Y
			Return $LocateResult
		Case "INFERNO"
			_ArrayMerge($LocateResult, $PixelInfernoPos) ; Merging Arrays To Keep Return 1D Array And More Clear, [4] = $X  AND [5] = $Y
			Return $LocateResult
		Case "ADEFENSE"
			_ArrayMerge($LocateResult, $PixelADefensePos) ; Merging Arrays To Keep Return 1D Array And More Clear, [4] = $X  AND [5] = $Y
			Return $LocateResult
	EndSwitch
EndFunc   ;==>AssignPixelOfDefense

Func ResetDefensesLocation($Defense = "")
	If $debugDropSCommand = 1 Then SetLog("Func ResetDefensesLocation(" & $Defense & ")", $COLOR_DEBUG) ;Debug
	Select
		Case $LocateMode = 1 Or $Defense <> ""
			Switch $Defense
				Case ""
					$PixelEaglePos[0] = -1
					$PixelEaglePos[1] = -1
					$PixelInfernoPos[0] = -1
					$PixelInfernoPos[1] = -1
					$PixelADefensePos[0] = -1
					$PixelADefensePos[1] = -1
				Case "EAGLE"
					$PixelEaglePos[0] = -1
					$PixelEaglePos[1] = -1
				Case "INFERNO"
					$PixelInfernoPos[0] = -1
					$PixelInfernoPos[1] = -1
				Case "ADEFENSE"
					$PixelADefensePos[0] = -1
					$PixelADefensePos[1] = -1
			EndSwitch
		Case Else
			Switch $Defense
				Case ""
					ReDim $AllPixelEaglePos[1][3]
					ReDim $AllPixelInfernoPos[1][3]
					ReDim $AllPixelADefensePos[1][3]
					$AllPixelEaglePos[0][0] = -1
					$AllPixelEaglePos[0][1] = -1
					$AllPixelEaglePos[0][2] = -1
					$AllPixelInfernoPos[0][0] = -1
					$AllPixelInfernoPos[0][1] = -1
					$AllPixelInfernoPos[0][2] = -1
					$AllPixelADefensePos[0][0] = -1
					$AllPixelADefensePos[0][1] = -1
					$AllPixelADefensePos[0][2] = -1
					$PixelEaglePos[0] = -1
					$PixelEaglePos[1] = -1
					$PixelInfernoPos[0] = -1
					$PixelInfernoPos[1] = -1
					$PixelADefensePos[0] = -1
					$PixelADefensePos[1] = -1
				Case "EAGLE"
					ReDim $AllPixelEaglePos[1][3]
					$AllPixelEaglePos[0][0] = -1
					$AllPixelEaglePos[0][1] = -1
					$AllPixelEaglePos[0][2] = -1
					$PixelEaglePos[0] = -1
					$PixelEaglePos[1] = -1
				Case "INFERNO"
					ReDim $AllPixelInfernoPos[1][3]
					$AllPixelInfernoPos[0][0] = -1
					$AllPixelInfernoPos[0][1] = -1
					$AllPixelInfernoPos[0][2] = -1
					$PixelInfernoPos[0] = -1
					$PixelInfernoPos[1] = -1
				Case "ADEFENSE"
					ReDim $AllPixelADefensePos[1][3]
					$AllPixelADefensePos[0][0] = -1
					$AllPixelADefensePos[0][1] = -1
					$AllPixelADefensePos[0][2] = -1
					$PixelADefensePos[0] = -1
					$PixelADefensePos[1] = -1
			EndSwitch
	EndSelect
EndFunc   ;==>ResetDefensesLocation

Func isLocatedBefore($Defense)
	If $debugDropSCommand = 1 Then SetLog("Func isLocatedBefore(" & $Defense & ")", $COLOR_DEBUG) ;Debug
	Select
		Case $LocateMode = 1
			Switch $Defense
				Case "EAGLE"
					If $PixelEaglePos[0] > 0 Then
						If $PixelEaglePos[1] > 0 Then Return True
						Return False
					Else
						Return False
					EndIf
				Case "INFERNO"
					If $PixelInfernoPos[0] > 0 Then
						If $PixelInfernoPos[1] > 0 Then Return True
						Return False
					Else
						Return False
					EndIf
				Case "ADEFENSE"
					If $PixelADefensePos[0] > 0 Then
						If $PixelADefensePos[1] > 0 Then Return True
						Return False
					Else
						Return False
					EndIf
			EndSwitch
		Case Else
			Switch $Defense
				Case "EAGLE"
					If $AllPixelEaglePos[0][0] > 0 Then
						If $AllPixelEaglePos[0][1] > 0 Then Return True
						Return False
					Else
						Return False
					EndIf
				Case "INFERNO"
					If $AllPixelInfernoPos[0][0] > 0 Then
						If $AllPixelInfernoPos[0][1] > 0 Then Return True
						Return False
					Else
						Return False
					EndIf
				Case "ADEFENSE"
					If $AllPixelADefensePos[0][0] > 0 Then
						If $AllPixelADefensePos[0][1] > 0 Then Return True
						Return False
					Else
						Return False
					EndIf
			EndSwitch
	EndSelect
EndFunc   ;==>isLocatedBefore

Func LocateDefense($Defense, $options)
	If $debugDropSCommand = 1 Then SetLog("Func LocateDefense(" & $Defense & ", " & $options & ")", $COLOR_DEBUG) ;Debug
	Local $Result[4] = [False, False, False, ""]
	; [0] = Will be TRUE if Defense Found
	; [1] = Will be TRUE if Defense Found AND Matched With Side Condition
	; [2] = Will be TRUE if Inferno Tower was near to the other inferno tower AND was possible to drop Spell Between them
	; [3] = Any Text To Send An Extra SetLog with The Text, IF Empty ("") it wont send Extra SetLog

	Local $ParsedOptions = ParseCommandOptions($options)
	Local $RandomizeDropPoint = $ParsedOptions[0] ; Only Will Be TRUE or FALSE
	Local $SideCondition = $ParsedOptions[1] ; Can Be S or O or E
	Local $DropBetween = $ParsedOptions[2] ; Only Can Be TRUE or FALSE

	Switch $Defense
		Case "EAGLE"
			$hTimer = TimerInit()

			Local $directory = @ScriptDir & "\images\WeakBase\Eagle"
			Local $return
			Local $reLocated = False
			If $LocateMode = 1 Then
				$return = returnAllMatchesDefense($directory)
				$reLocated = True
			ElseIf $LocateMode = 2 Then
				If isLocatedBefore($Defense) = True Then
					$return = ReturnSavedPositions($Defense)
				Else
					$return = returnAllMatchesDefense($directory)
					$reLocated = True
					SavePositions($Defense, $return)
				EndIf
			EndIf
			Local $splitedPositions = StringSplit($return, "|", 2)
			If Not (UBound($splitedPositions) >= 1 And StringLen($splitedPositions[0]) > 2) Then DebugImageSave("EagleDetection_NotDetected_", True)
			Local $theEagleSide = ""
			Local $NotdetectedEagle = True
			$Counter = -1
			For $eachPos In $splitedPositions
				$splitedEachPos = StringSplit($eachPos, ",", 2)
				If IsArray($splitedEachPos) And UBound($splitedEachPos) > 1 Then
					$Counter += 1
					If $debugDropSCommand = 1 Then SetLog("$SideCondition = " & $SideCondition, $COLOR_DEBUG) ;Debug
					If IsSameColor($Defense, $Counter, $splitedEachPos[0], $splitedEachPos[1], $Counter = 0, False, $reLocated) = True Then
						Select
							Case $SideCondition = "AnySide"
								$PixelEaglePos[0] = $splitedEachPos[0]
								$PixelEaglePos[1] = $splitedEachPos[1]
								$NotdetectedEagle = False
								ExitLoop
							Case $SideCondition = "SameSide" Or $SideCondition = "OtherSide"
								$sliced = Slice8($splitedEachPos)
								If $debugDropSCommand = 1 Then SetLog("$sliced = " & $sliced, $COLOR_BLUE)
								Switch StringLeft($sliced, 1)
									Case 1, 2
										$theEagleSide = "BOTTOM"
									Case 3, 4
										$theEagleSide = "TOP"
									Case 5, 6
										$theEagleSide = "TOP"
									Case 7, 8
										$theEagleSide = "BOTTOM"
								EndSwitch
								$curMainSide = StringSplit($MAINSIDE, "-", 2)[0]
								If $debugDropSCommand = 1 Then SetLog("$curMainSide = " & $curMainSide, $COLOR_ORANGE)
								If $debugDropSCommand = 1 Then SetLog("$theEagleSide = " & $theEagleSide, $COLOR_ORANGE)
								If $SideCondition = "SameSide" Then
									If $theEagleSide = $curMainSide Then
										$PixelEaglePos[0] = $splitedEachPos[0]
										$PixelEaglePos[1] = $splitedEachPos[1]
										$NotdetectedEagle = False
										ExitLoop
									EndIf
								Else
									If $theEagleSide <> $curMainSide Then
										$PixelEaglePos[0] = $splitedEachPos[0]
										$PixelEaglePos[1] = $splitedEachPos[1]
										$NotdetectedEagle = False
										ExitLoop
									EndIf
								EndIf
						EndSelect
					Else
						$PixelEaglePos[0] = -1
						$PixelEaglePos[1] = -1
					EndIf
				EndIf
			Next
			If $NotdetectedEagle = False Then
				$rToDecreaseX = 4
				$rToIncreaseY = 11
				If $RandomizeDropPoint = True Then
					$rToDecreaseX = Random(0, 8, 1)
					$rToIncreaseY = Random(0, 19, 1)
				EndIf
				If $debugDropSCommand = 1 Then SetLog("$rToDecreaseX = " & $rToDecreaseX)
				If $debugDropSCommand = 1 Then SetLog("$rToDecreaseY = " & $rToIncreaseY)
				$PixelEaglePos[0] -= $rToDecreaseX
				$PixelEaglePos[1] += $rToIncreaseY
			EndIf
			If UBound($splitedPositions) >= 1 And StringLen($splitedPositions[0]) > 2 Then
				$Result[0] = True
				Setlog(" »» Eagle located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds")
			Else
				FlagAsUnDetected($Result)
			EndIf
			Switch $SideCondition
				Case "SameSide"
					If $NotdetectedEagle = False Then
						$Result[1] = True
						SetLog("Eagle Detected in Same Side")
					Else
						FlagAsUnDetected($Result)
						SetLog("No Eagle Detected in same side", $COLOR_ORANGE)
					EndIf
				Case "OtherSide"
					If $NotdetectedEagle = False Then
						$Result[1] = True
						SetLog("Eagle Detected in the Other Side")
					Else
						FlagAsUnDetected($Result)
						SetLog("No Eagle Detected in the other side", $COLOR_ORANGE)
					EndIf
				Case "AnySide"
					If $NotdetectedEagle = False Then
						$Result[1] = True
						SetLog("Eagle Detected")
					Else
						FlagAsUnDetected($Result)
						SetLog("No Eagle Detected at all", $COLOR_ORANGE)
					EndIf
			EndSwitch
			Return $Result
		Case "INFERNO"
			$hTimer = TimerInit()

			Local $directory = @ScriptDir & "\images\WeakBase\Infernos"
			Local $return
			Local $reLocated = False
			If $LocateMode = 1 Then
				$return = returnAllMatchesDefense($directory)
				$reLocated = True
			ElseIf $LocateMode = 2 Then
				If isLocatedBefore($Defense) = True Then
					$return = ReturnSavedPositions($Defense)
				Else
					$return = returnAllMatchesDefense($directory)
					$reLocated = True
					SavePositions($Defense, $return)
				EndIf
			EndIf
			Local $splitedPositions = StringSplit($return, "|", 2)
			If Not (UBound($splitedPositions) >= 1 And StringLen($splitedPositions[0]) > 2) Then DebugImageSave("InfernoDetection_NotDetected_", True)
			Local $theInfernoSide = ""
			Local $NotdetectedInferno = True
			$Counter = -1
			For $eachPos In $splitedPositions
				$splitedEachPos = StringSplit($eachPos, ",", 2)
				If IsArray($splitedEachPos) And UBound($splitedEachPos) > 1 Then
					$Counter += 1
					If $debugDropSCommand = 1 Then SetLog("$SideCondition = " & $SideCondition, $COLOR_DEBUG) ;Debug
					If IsSameColor($Defense, $Counter, $splitedEachPos[0], $splitedEachPos[1], $Counter = 0, False, $reLocated) = True Then
						Select
							Case $SideCondition = "AnySide"
								$PixelInfernoPos[0] = $splitedEachPos[0]
								$PixelInfernoPos[1] = $splitedEachPos[1]
								$NotdetectedInferno = False
								ExitLoop
							Case $SideCondition = "SameSide" Or $SideCondition = "OtherSide"
								;If UBound($splitedEachPos) = 2 Then
								;If $splitedEachPos[1] >= 1 Then
								$sliced = Slice8($splitedEachPos)
								If $debugDropSCommand = 1 Then SetLog("$sliced = " & $sliced, $COLOR_BLUE)
								Switch StringLeft($sliced, 1)
									Case 1, 2
										$theInfernoSide = "BOTTOM"
									Case 3, 4
										$theInfernoSide = "TOP"
									Case 5, 6
										$theInfernoSide = "TOP"
									Case 7, 8
										$theInfernoSide = "BOTTOM"
								EndSwitch
								$curMainSide = StringSplit($MAINSIDE, "-", 2)[0]
								If $debugDropSCommand = 1 Then SetLog("$curMainSide = " & $curMainSide, $COLOR_ORANGE)
								If $debugDropSCommand = 1 Then SetLog("$theInfernoSide = " & $theInfernoSide, $COLOR_ORANGE)
								If $SideCondition = "SameSide" Then
									If $theInfernoSide = $curMainSide Then
										$PixelInfernoPos[0] = $splitedEachPos[0]
										$PixelInfernoPos[1] = $splitedEachPos[1]
										$NotdetectedInferno = False
										ExitLoop
									EndIf
								Else
									If $theInfernoSide <> $curMainSide Then
										$PixelInfernoPos[0] = $splitedEachPos[0]
										$PixelInfernoPos[1] = $splitedEachPos[1]
										$NotdetectedInferno = False
										ExitLoop
									EndIf
								EndIf
								;EndIf
								;EndIf
						EndSelect
					Else
						$PixelInfernoPos[0] = -1
						$PixelInfernoPos[1] = -1
					EndIf
				EndIf
			Next
			Local $isNearToTheOtherOne = IsInfernoTowersNearToTheOtherOne($splitedPositions, $DropBetween)
			If $NotdetectedInferno = True And $isNearToTheOtherOne[4] = True Then
				If $debugDropSCommand = 1 Then SetLog("Near To The Other One Is True But No Inferno Towers Detected!!!, Disabling Drop Between...")
				$isNearToTheOtherOne[4] = False
			EndIf
			If $isNearToTheOtherOne[4] = True And $NotdetectedInferno = False Then
				If $isNearToTheOtherOne[0] = True Then
					$PixelInfernoPos[0] += (($isNearToTheOtherOne[2] / 2) + 0 + IIf($RandomizeDropPoint = True, Random(0, 5, 1), 0)) ; Was 7
				Else
					$PixelInfernoPos[0] -= (($isNearToTheOtherOne[2] / 2) - 0 - IIf($RandomizeDropPoint = True, Random(0, 5, 1), 0)) ; Was 7
				EndIf
				If $isNearToTheOtherOne[1] = True Then
					$PixelInfernoPos[1] += (($isNearToTheOtherOne[3] / 2) + IIf($RandomizeDropPoint = True, 7, 9) + IIf($RandomizeDropPoint = True, Random(1, 3, 1), 0)) ; Was 9
				Else
					$PixelInfernoPos[1] -= (($isNearToTheOtherOne[3] / 2) - IIf($RandomizeDropPoint = True, 7, 9) - IIf($RandomizeDropPoint = True, Random(1, 3, 1), 0)) ; Was 9
				EndIf
			EndIf
			If $debugDropSCommand = 1 Then SetLog("$isNearToTheOtherOne[4] = " & $isNearToTheOtherOne[4], $COLOR_BLUE)
			If $NotdetectedInferno = False And $isNearToTheOtherOne[4] = False Then
				Local $rToDecreaseX = 4
				Local $rToIncreaseY = 11
				If $RandomizeDropPoint = True Then
					$rToDecreaseX = Random(0, 8, 1)
					$rToIncreaseY = Random(0, 19, 1)
				EndIf
				If $debugDropSCommand = 1 Then SetLog("$rToDecreaseX = " & $rToDecreaseX)
				If $debugDropSCommand = 1 Then SetLog("$rToDecreaseY = " & $rToIncreaseY)
				$PixelInfernoPos[0] -= $rToDecreaseX
				$PixelInfernoPos[1] += $rToIncreaseY
			EndIf
			If UBound($splitedPositions) >= 1 And StringLen($splitedPositions[0]) > 2 Then
				$Result[0] = True
				Setlog(" »» " & UBound($splitedPositions) & "x Inferno Tower(s) located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds")
			Else
				FlagAsUnDetected($Result)
			EndIf
			Switch $SideCondition
				Case "SameSide"
					If $NotdetectedInferno = False Then
						If $isNearToTheOtherOne[4] = False Then
							$Result[1] = True
							SetLog("Inferno Tower Detected in Same Side")
						EndIf
						If $isNearToTheOtherOne[4] = True Then
							$Result[1] = True
							$Result[2] = True
							;SetLog("Dropping Between Two Inferno Tower(s) In the Same Side...", $COLOR_BLUE)
						EndIf
					Else
						FlagAsUnDetected($Result)
						SetLog("No Inferno Tower Detected in same side", $COLOR_ORANGE)
					EndIf
				Case "OtherSide"
					If $NotdetectedInferno = False Then
						If $isNearToTheOtherOne[4] = False Then
							$Result[1] = True
							SetLog("Inferno Tower Detected in the Other Side")
						EndIf
						If $isNearToTheOtherOne[4] = True Then
							$Result[1] = True
							$Result[2] = True
							;SetLog("Dropping Between Two Inferno Tower(s) In the Other Side...", $COLOR_BLUE)
						EndIf
					Else
						FlagAsUnDetected($Result)
						SetLog("No Inferno Tower Detected in the other side", $COLOR_ORANGE)
					EndIf
				Case "AnySide"
					If $NotdetectedInferno = False Then
						If $isNearToTheOtherOne[4] = False Then
							$Result[1] = True
							SetLog("Inferno Tower Detected")
						EndIf
						If $isNearToTheOtherOne[4] = True Then
							$Result[1] = True
							$Result[2] = True
							;SetLog("Dropping Between Two Inferno Tower(s)...", $COLOR_BLUE)
						EndIf
					Else
						FlagAsUnDetected($Result)
						SetLog("No Inferno Tower Detected at all", $COLOR_ORANGE)
					EndIf
			EndSwitch
			Return $Result
		Case "ADEFENSE"
			$hTimer = TimerInit()

			Local $directory = @ScriptDir & "\images\WeakBase\ADefense"
			Local $return
			Local $reLocated = False
			If $LocateMode = 1 Then
				$return = returnAllMatchesDefense($directory)
				$reLocated = True
			ElseIf $LocateMode = 2 Then
				If isLocatedBefore($Defense) = True Then
					$return = ReturnSavedPositions($Defense)
				Else
					$return = returnAllMatchesDefense($directory)
					$reLocated = True
					SavePositions($Defense, $return)
				EndIf
			EndIf
			Local $splitedPositions = StringSplit($return, "|", 2)
			If Not (UBound($splitedPositions) >= 1 And StringLen($splitedPositions[0]) > 2) Then DebugImageSave("AirDefenseDetection_NotDetected_", True)
			Local $theADefenseSide = ""
			Local $NotdetectedADefense = True
			$Counter = -1
			For $eachPos In $splitedPositions
				$splitedEachPos = StringSplit($eachPos, ",", 2)
				If IsArray($splitedEachPos) And UBound($splitedEachPos) > 1 Then
					$Counter += 1
					If $debugDropSCommand = 1 Then SetLog("$SideCondition = " & $SideCondition, $COLOR_DEBUG) ;Debug
					If IsSameColor($Defense, $Counter, $splitedEachPos[0], $splitedEachPos[1], $Counter = 0, False, $reLocated) = True Then
						Select
							Case $SideCondition = "AnySide"
								$PixelADefensePos[0] = $splitedEachPos[0]
								$PixelADefensePos[1] = $splitedEachPos[1]
								$NotdetectedADefense = False
								ExitLoop
							Case $SideCondition = "SameSide" Or $SideCondition = "OtherSide"
								;If UBound($splitedEachPos) = 2 Then
								;If $splitedEachPos[1] >= 1 Then
								$sliced = Slice8($splitedEachPos)
								If $debugDropSCommand = 1 Then SetLog("$sliced = " & $sliced, $COLOR_BLUE)
								Switch StringLeft($sliced, 1)
									Case 1, 2
										$theADefenseSide = "BOTTOM"
									Case 3, 4
										$theADefenseSide = "TOP"
									Case 5, 6
										$theADefenseSide = "TOP"
									Case 7, 8
										$theADefenseSide = "BOTTOM"
								EndSwitch
								$curMainSide = StringSplit($MAINSIDE, "-", 2)[0]
								If $debugDropSCommand = 1 Then SetLog("$curMainSide = " & $curMainSide, $COLOR_ORANGE)
								If $debugDropSCommand = 1 Then SetLog("$theADefenseSide = " & $theADefenseSide, $COLOR_ORANGE)
								If $SideCondition = "SameSide" Then
									If $theADefenseSide = $curMainSide Then
										$PixelADefensePos[0] = $splitedEachPos[0]
										$PixelADefensePos[1] = $splitedEachPos[1]
										$NotdetectedADefense = False
										ExitLoop
									EndIf
								Else
									If $theADefenseSide <> $curMainSide Then
										$PixelADefensePos[0] = $splitedEachPos[0]
										$PixelADefensePos[1] = $splitedEachPos[1]
										$NotdetectedADefense = False
										ExitLoop
									EndIf
								EndIf
								;EndIf
								;EndIf
						EndSelect
					Else
						$PixelADefensePos[0] = -1
						$PixelADefensePos[1] = -1
					EndIf
				EndIf
			Next
			If $NotdetectedADefense = False Then
				Local $rToDecreaseX = 4
				Local $rToIncreaseY = 11
				If $RandomizeDropPoint = True Then
					$rToDecreaseX = Random(0, 8, 1)
					$rToIncreaseY = Random(0, 19, 1)
				EndIf
				If $debugDropSCommand = 1 Then SetLog("$rToDecreaseX = " & $rToDecreaseX)
				If $debugDropSCommand = 1 Then SetLog("$rToDecreaseY = " & $rToIncreaseY)
				$PixelADefensePos[0] -= $rToDecreaseX
				$PixelADefensePos[1] += $rToIncreaseY
			EndIf
			If UBound($splitedPositions) >= 1 And StringLen($splitedPositions[0]) > 2 Then
				$Result[0] = True
				Setlog(" »» " & UBound($splitedPositions) & "x Air Defense(s) located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds")
			Else
				FlagAsUnDetected($Result)
			EndIf
			Switch $SideCondition
				Case "SameSide"
					If $NotdetectedADefense = False Then
						$Result[1] = True
						SetLog("Air Defense Detected in Same Side")
					Else
						FlagAsUnDetected($Result)
						SetLog("No Air Defense Detected in same side", $COLOR_ORANGE)
					EndIf
				Case "OtherSide"
					If $NotdetectedADefense = False Then
						$Result[1] = True
						SetLog("Air Defense Detected in the Other Side")
					Else
						FlagAsUnDetected($Result)
						SetLog("No Air Defense Detected in the other side", $COLOR_ORANGE)
					EndIf
				Case "AnySide"
					If $NotdetectedADefense = False Then
						$Result[1] = True
						SetLog("Air Defense Detected")
					Else
						FlagAsUnDetected($Result)
						SetLog("No Air Defense Detected at all", $COLOR_ORANGE)
					EndIf
			EndSwitch
			Return $Result
	EndSwitch
	Return $Result
EndFunc   ;==>LocateDefense

Func FlagAsUnDetected(ByRef $Result)
	For $i = 0 To (UBound($Result) - 1)
		If Not $i = (UBound($Result) - 1) Then ; If index was for Additional SetLog
			$Result[$i] = False
		Else
			$Result[$i] = ""
		EndIf
	Next
EndFunc   ;==>FlagAsUnDetected

Func IsSameColor($Defense, $Counter, $X, $Y, $bNeedCapture = False, $Equal = False, $bSkip = False)
	If $debugDropSCommand = 1 Then SetLog("Func IsSameColor(" & $Defense & ", " & $Counter & ", " & $X & ", " & $Y & ", " & $bNeedCapture & ", " & $Equal & ", " & $bSkip & ")", $COLOR_DEBUG) ;Debug
	If $LocateMode = 1 Or $bSkip = True Then Return True
	Select
		Case $Defense = "EAGLE"
			If $Equal = True Then
				$CurColor = IIf($AllPixelEaglePos[$Counter][2] = _GetPixelColor($X, $Y, $bNeedCapture), True, False)
			Else
				$CurColor = _ColorCheck(_GetPixelColor($X, $Y, $bNeedCapture), Hex("0x" & $AllPixelEaglePos[$Counter][2], 6), 20)
			EndIf
			If $debugDropSCommand = 1 Then SetLog("$CurColor = " & $CurColor & "  $AllPixelEaglePos[" & $Counter & "][2] = " & $AllPixelEaglePos[$Counter][2], $COLOR_BLUE)
			If $CurColor = True Then
				If $debugDropSCommand = 1 Then SetLog("Pixel Colors are same", $COLOR_BLUE)
				Return True
			EndIf
			If $debugDropSCommand = 1 Then SetLog("Pixel Colors not Same", $COLOR_ORANGE)
			Return False
		Case $Defense = "INFERNO"
			If $Equal = True Then
				$CurColor = IIf($AllPixelInfernoPos[$Counter][2] = _GetPixelColor($X, $Y, $bNeedCapture), True, False)
			Else
				$CurColor = _ColorCheck(_GetPixelColor($X, $Y, $bNeedCapture), Hex("0x" & $AllPixelInfernoPos[$Counter][2], 6), 40)
			EndIf
			If $debugDropSCommand = 1 Then SetLog("$CurColor = " & $CurColor & "  $AllPixelInfernoPos[" & $Counter & "][2] = " & $AllPixelInfernoPos[$Counter][2], $COLOR_BLUE)
			If $CurColor = True Then
				If $debugDropSCommand = 1 Then SetLog("Pixel Colors are same", $COLOR_BLUE)
				Return True
			EndIf
			If $debugDropSCommand = 1 Then SetLog("Pixel Colors not Same", $COLOR_ORANGE)
			Return False
		Case $Defense = "ADEFENSE"
			If $Equal = True Then
				$CurColor = IIf($AllPixelADefensePos[$Counter][2] = _GetPixelColor($X, $Y, $bNeedCapture), True, False)
			Else
				$CurColor = _ColorCheck(_GetPixelColor($X, $Y, $bNeedCapture), Hex("0x" & $AllPixelADefensePos[$Counter][2], 6), 90)
			EndIf
			If $debugDropSCommand = 1 Then SetLog("$CurColor = " & $CurColor & "  $AllPixelADefensePos[" & $Counter & "][2] = " & $AllPixelADefensePos[$Counter][2], $COLOR_BLUE)
			If $CurColor = True Then
				If $debugDropSCommand = 1 Then SetLog("Pixel Colors are same", $COLOR_BLUE)
				Return True
			EndIf
			If $debugDropSCommand = 1 Then SetLog("Pixel Colors not Same", $COLOR_ORANGE)
			Return False
	EndSelect
	Return False
EndFunc   ;==>IsSameColor

Func SavePositions($Defense, $return)
	If $debugDropSCommand = 1 Then SetLog("Func SavePositions(" & $Defense & ", " & $return & ")", $COLOR_DEBUG) ;Debug
	Local $splitedPositions = StringSplit($return, "|", 2)
	Select
		Case $Defense = "EAGLE"
			If UBound($splitedPositions) < 1 Then DebugImageSave("EagleDetection_NotDetected_", True)
			$Counter = -1
			For $eachPos In $splitedPositions
				$splitedEachPos = StringSplit($eachPos, ",", 2)
				If IsArray($splitedEachPos) And UBound($splitedEachPos) > 1 Then
					ReDim $AllPixelEaglePos[UBound($AllPixelEaglePos) + 1][3]
					$Counter += 1
					$AllPixelEaglePos[$Counter][0] = $splitedEachPos[0]
					$AllPixelEaglePos[$Counter][1] = $splitedEachPos[1]
					$AllPixelEaglePos[$Counter][2] = _GetPixelColor($splitedEachPos[0], $splitedEachPos[1], True)
				EndIf
			Next
			_ArrayDelete($AllPixelEaglePos, UBound($AllPixelEaglePos) - 1)
		Case $Defense = "INFERNO"
			If UBound($splitedPositions) < 1 Then DebugImageSave("InfernoDetection_NotDetected_", True)
			$Counter = -1
			For $eachPos In $splitedPositions
				$splitedEachPos = StringSplit($eachPos, ",", 2)
				If IsArray($splitedEachPos) And UBound($splitedEachPos) > 1 Then
					ReDim $AllPixelInfernoPos[UBound($AllPixelInfernoPos) + 1][3]
					$Counter += 1
					$AllPixelInfernoPos[$Counter][0] = $splitedEachPos[0]
					$AllPixelInfernoPos[$Counter][1] = $splitedEachPos[1]
					$AllPixelInfernoPos[$Counter][2] = _GetPixelColor($splitedEachPos[0], $splitedEachPos[1], True)
				EndIf
			Next
			_ArrayDelete($AllPixelInfernoPos, UBound($AllPixelInfernoPos) - 1)
		Case $Defense = "ADEFENSE"
			If UBound($splitedPositions) < 1 Then DebugImageSave("ADefenseDetection_NotDetected_", True)
			$Counter = -1
			For $eachPos In $splitedPositions
				$splitedEachPos = StringSplit($eachPos, ",", 2)
				If IsArray($splitedEachPos) And UBound($splitedEachPos) > 1 Then
					ReDim $AllPixelADefensePos[UBound($AllPixelADefensePos) + 1][3]
					$Counter += 1
					$AllPixelADefensePos[$Counter][0] = $splitedEachPos[0]
					$AllPixelADefensePos[$Counter][1] = $splitedEachPos[1]
					$AllPixelADefensePos[$Counter][2] = _GetPixelColor($splitedEachPos[0], $splitedEachPos[1], True)
				EndIf
			Next
			_ArrayDelete($AllPixelADefensePos, UBound($AllPixelADefensePos) - 1)
	EndSelect
EndFunc   ;==>SavePositions

Func ReturnSavedPositions($Defense)
	If $debugDropSCommand = 1 Then SetLog("Func ReturnSavedPositions(" & $Defense & ")", $COLOR_DEBUG) ;Debug
	Local $Result = ""
	Select
		Case $Defense = "EAGLE"
			For $i = 0 To UBound($AllPixelEaglePos) - 1
				$Result &= $AllPixelEaglePos[$i][0] & "," & $AllPixelEaglePos[$i][1] & "|"
			Next
		Case $Defense = "INFERNO"
			;_ArrayDisplay($AllPixelInfernoPos, "$AllPixelInfernoPos")
			For $i = 0 To UBound($AllPixelInfernoPos) - 1
				$Result &= $AllPixelInfernoPos[$i][0] & "," & $AllPixelInfernoPos[$i][1] & "|"
			Next
			#cs
				$counter = 0
				For $Pos In $AllPixelInfernoPos
				$counter += 1
				msgbox(0, "$counter", $counter)
				msgbox(0, "$Pos", $Pos)
				$Result &= $Pos[0] & "," & $Pos[1] & "|"
				Next
			#ce
		Case $Defense = "ADEFENSE"
			For $i = 0 To UBound($AllPixelADefensePos) - 1
				$Result &= $AllPixelADefensePos[$i][0] & "," & $AllPixelADefensePos[$i][1] & "|"
			Next
	EndSelect
	If StringRight($Result, 1) = "|" Then $Result = StringLeft($Result, StringLen($Result) - 1)
	;MsgBox(0, "$Result", $Result)
	Return $Result
EndFunc   ;==>ReturnSavedPositions

Func ParseCommandOptions($options)
	If $debugDropSCommand = 1 Then SetLog("Func ParseCommandOptions(" & $options & ")", $COLOR_DEBUG) ;Debug
	Local $Result[3] = [False, "", True]
	;	[0] = IF True, Change Drop Position by a Low Random Number
	; 	[1] = Side
	;	[2] = IF True, Drop Spell Between Both 2 Inferno Towers IF Both of them was going to be affected by ONE Spell EVEN, Else Drop on one of them
	Local $splitedOptions = StringSplit($options, ",", 2)
	For $Opt In $splitedOptions
		$optSplited = StringSplit($Opt, ":", 2)
		$optArg = $optSplited[0]
		$optValue = $optSplited[1]
		Switch $optArg
			Case "R"
				If $optValue = "T" Then
					$Result[0] = True
				Else
					$Result[0] = False
				EndIf
			Case "B"
				If $optValue = "T" Then
					$Result[2] = True ; Drop Between
				Else
					$Result[2] = False ; DON'T Drop Between
				EndIf
			Case "S"
				Switch $optValue
					Case "S"
						$Result[1] = "SameSide"
					Case "O"
						$Result[1] = "OtherSide"
					Case "A"
						$Result[1] = "AnySide"
				EndSwitch
		EndSwitch
	Next
	Return $Result
EndFunc   ;==>ParseCommandOptions

Func IsInfernoTowersNearToTheOtherOne($positions, $DropBetween)
	If $debugDropSCommand = 1 Then SetLog("Func IsInfernoTowersNearToTheOtherOne(" & $positions & ", " & $DropBetween & ")", $COLOR_DEBUG) ;Debug
	Local $Result[5] = [False, False, 0, 0, False]
	; [0] = $xDiff was started with "-" at first
	; [1] = $yDiff was started with "-" at first
	; [2] = $xDiff
	; [3] = $yDiff
	; [4] = True OR False, The Result
	; ---
	If UBound($positions) < 2 Or $DropBetween = False Then
		If $debugDropSCommand = 1 Then SetLog("UBound($positions) < 2 OR $DropBetween = False")
		If $debugDropSCommand = 1 Then SetLog("UBound($positions) = " & UBound($positions))
		If $debugDropSCommand = 1 Then SetLog("$DropBetween = " & $DropBetween)
		Return $Result
	EndIf
	Local $allowedXDiff = 74, $allowedYDiff = 53 ; xDiff was 64,		yDiff was 53
	If IsArray(StringSplit($positions[0], ",", 2)) And IsArray(StringSplit($positions[1], ",", 2)) Then Return $Result
	Local $firstInfernoPosition[2] = [StringSplit($positions[0], ",", 2)[0], StringSplit($positions[0], ",", 2)[1]]
	Local $secondInfernoPosition[2] = [StringSplit($positions[1], ",", 2)[0], StringSplit($positions[1], ",", 2)[1]]
	;MsgBox(0, "ArrayToString", _ArrayToString($firstInfernoPosition, ",") & @CRLF & _ArrayToString($secondInfernoPosition, ","))		; Should be uncommented Only when you want to debug it
	Local $xDiff = $firstInfernoPosition[0] - $secondInfernoPosition[0], $yDiff = $firstInfernoPosition[1] - $secondInfernoPosition[1]
	If StringLeft(String($xDiff), 1) = "-" Then
		$xDiff = $secondInfernoPosition[0] - $firstInfernoPosition[0]
		$Result[0] = True
	EndIf
	If StringLeft(String($yDiff), 1) = "-" Then
		$yDiff = $secondInfernoPosition[1] - $firstInfernoPosition[1]
		$Result[1] = True
	EndIf
	;MsgBox(0, "Diff", "$xDiff = " & $xDiff & @CRLF & "$yDiff = " & $yDiff)		; Should be uncommented Only when you want to debug it
	$Result[2] = $xDiff
	$Result[3] = $yDiff
	If $xDiff <= $allowedXDiff And $yDiff <= $allowedYDiff Then
		$Result[4] = True
		Return $Result
	EndIf
	SetLog("Inferno Towers are so far from the other one, Cannot Drop Between", $COLOR_ORANGE)
	Return $Result
EndFunc   ;==>IsInfernoTowersNearToTheOtherOne


Func _ArrayMerge(ByRef $a_base, ByRef $a_add, $i_start = 0)
	Local $X
	For $X = $i_start To UBound($a_add) - 1
		_ArrayAdd($a_base, $a_add[$X])
	Next
EndFunc   ;==>_ArrayMerge

