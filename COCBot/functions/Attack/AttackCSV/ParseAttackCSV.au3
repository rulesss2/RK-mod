; #FUNCTION# ====================================================================================================================
; Name ..........: ParseAttackCSV
; Description ...:
; Syntax ........: ParseAttackCSV([$debug = False])
; Parameters ....: $debug               - [optional]
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: MR.ViPER (5-10-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ParseAttackCSV($debug = False)
	Global $ATTACKVECTOR_A, $ATTACKVECTOR_B, $ATTACKVECTOR_C, $ATTACKVECTOR_D, $ATTACKVECTOR_E, $ATTACKVECTOR_F
	Global $ATTACKVECTOR_G, $ATTACKVECTOR_H, $ATTACKVECTOR_I, $ATTACKVECTOR_J, $ATTACKVECTOR_K, $ATTACKVECTOR_L
	Global $ATTACKVECTOR_M, $ATTACKVECTOR_N, $ATTACKVECTOR_O, $ATTACKVECTOR_P, $ATTACKVECTOR_Q, $ATTACKVECTOR_R
	Global $ATTACKVECTOR_S, $ATTACKVECTOR_T, $ATTACKVECTOR_U, $ATTACKVECTOR_V, $ATTACKVECTOR_W, $ATTACKVECTOR_X
	Global $ATTACKVECTOR_Y, $ATTACKVECTOR_Z

	Local $rownum = 0

	;Local $filename = "attack1"
	If $iMatchMode = $DB Then
		Local $filename = $scmbDBScriptName
	Else
		Local $filename = $scmbABScriptName
	EndIf
	Setlog("execute " & $filename)

	Local $f, $line, $acommand, $command
	Local $value1, $value2, $value3, $value4, $value5, $value6, $value7, $value8, $value9
	If FileExists($dirAttacksCSV & "\" & $filename & ".csv") Then
		checkForSidePInCSV($dirAttacksCSV & "\" & $filename & ".csv")
		$f = FileOpen($dirAttacksCSV & "\" & $filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			$rownum += 1
			If @error = -1 Then ExitLoop
			If $debug = True Then Setlog("parse line:<<" & $line & ">>")
			debugAttackCSV("line content: " & $line)
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), 2)
				$value1 = StringStripWS(StringUpper($acommand[2]), 2)
				$value2 = StringStripWS(StringUpper($acommand[3]), 2)
				$value3 = StringStripWS(StringUpper($acommand[4]), 2)
				$value4 = StringStripWS(StringUpper($acommand[5]), 2)
				$value5 = StringStripWS(StringUpper($acommand[6]), 2)
				$value6 = StringStripWS(StringUpper($acommand[7]), 2)
				$value7 = StringStripWS(StringUpper($acommand[8]), 2)
				$value8 = StringStripWS(StringUpper($acommand[9]), 2)
				$value9 = StringStripWS(StringUpper($acommand[10]), 2)

				Switch $command
					Case ""
						debugAttackCSV("comment line")
					Case "MAKE"
						ReleaseClicks()
						If CheckCsvValues("MAKE", 2, $value2) Then
							Local $sidex = StringReplace($value2, "-", "_")
							If $sidex = "RANDOM" Then
								Switch Random(1, 4, 1)
									Case 1
										$sidex = "FRONT_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "LEFT"
										Else
											$sidex &= "RIGHT"
										EndIf
									Case 2
										$sidex = "BACK_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "LEFT"
										Else
											$sidex &= "RIGHT"
										EndIf
									Case 3
										$sidex = "LEFT_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "FRONT"
										Else
											$sidex &= "BACK"
										EndIf
									Case 4
										$sidex = "RIGHT_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "FRONT"
										Else
											$sidex &= "BACK"
										EndIf
								EndSwitch
							EndIf
							If CheckCsvValues("MAKE", 1, $value1) And CheckCsvValues("MAKE", 5, $value5) Then
								Assign("ATTACKVECTOR_" & $value1, MakeDropPoints(Eval($sidex), $value3, $value4, $value5, $value6, $value7))
								For $i = 0 To UBound(Execute("$ATTACKVECTOR_" & $value1)) - 1
									$pixel = Execute("$ATTACKVECTOR_" & $value1 & "[" & $i & "]")
									debugAttackCSV($i & " - " & $pixel[0] & "," & $pixel[1])
								Next
							Else
								Setlog("Discard row, bad value1 or value 5 parameter: row " & $rownum)
								debugAttackCSV("Discard row, bad value1 or value5 parameter")
							EndIf
						Else
							Setlog("Discard row, bad value2 parameter:row " & $rownum)
							debugAttackCSV("Discard row, bad value2 parameter:row " & $rownum)
						EndIf
					Case "DROP"
						KeepClicks()
						;index...
						Local $index1, $index2, $indexArray, $indexvect
						$indexvect = StringSplit($value2, "-", 2)
						If UBound($indexvect) > 1 Then
							$indexArray = 0
							If Int($indexvect[0]) > 0 And Int($indexvect[1]) > 0 Then
								$index1 = Int($indexvect[0])
								$index2 = Int($indexvect[1])
							Else
								$index1 = 1
								$index2 = 1
							EndIf
						Else
							$indexArray = StringSplit($value2, ",", 2)
							If UBound($indexArray) > 1 Then
								$index1 = 0
								$index2 = UBound($indexArray) - 1
							Else
								$indexArray = 0
								If Int($value2) > 0 Then
									$index1 = Int($value2)
									$index2 = Int($value2)
								Else
									$index1 = 1
									$index2 = 1
								EndIf
							EndIf
						EndIf
						;qty...
						Local $qty1, $qty2, $qtyvect
						$qtyvect = StringSplit($value3, "-", 2)
						If UBound($qtyvect) > 1 Then
							If Int($qtyvect[0]) > 0 And Int($qtyvect[1]) > 0 Then
								$qty1 = Int($qtyvect[0])
								$qty2 = Int($qtyvect[1])
							Else
								$index1 = 1
								$qty2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$qty1 = Int($value3)
								$qty2 = Int($value3)
							Else
								$qty1 = 1
								$qty2 = 1
							EndIf
						EndIf
						;delay between points
						Local $delaypoints1, $delaypoints2, $delaypointsvect
						$delaypointsvect = StringSplit($value5, "-", 2)
						If UBound($delaypointsvect) > 1 Then
							If Int($delaypointsvect[0]) > 0 And Int($delaypointsvect[1]) > 0 Then
								$delaypoints1 = Int($delaypointsvect[0])
								$delaypoints2 = Int($delaypointsvect[1])
							Else
								$delaypoints1 = 1
								$delaypoints2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$delaypoints1 = Int($value5)
								$delaypoints2 = Int($value5)
							Else
								$delaypoints1 = 1
								$delaypoints2 = 1
							EndIf
						EndIf
						;delay between  drops in same point
						Local $delaydrop1, $delaydrop2, $delaydropvect
						$delaydropvect = StringSplit($value6, "-", 2)
						If UBound($delaydropvect) > 1 Then
							If Int($delaydropvect[0]) > 0 And Int($delaydropvect[1]) > 0 Then
								$delaydrop1 = Int($delaydropvect[0])
								$delaydrop2 = Int($delaydropvect[1])
							Else
								$delaydrop1 = 1
								$delaydrop2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$delaydrop1 = Int($value6)
								$delaydrop2 = Int($value6)
							Else
								$delaydrop1 = 1
								$delaydrop2 = 1
							EndIf
						EndIf
						;sleep time after drop
						Local $sleepdrop1, $sleepdrop2, $sleepdroppvect
						$sleepdroppvect = StringSplit($value7, "-", 2)
						If UBound($sleepdroppvect) > 1 Then
							If Int($sleepdroppvect[0]) > 0 And Int($sleepdroppvect[1]) > 0 Then
								$sleepdrop1 = Int($sleepdroppvect[0])
								$sleepdrop2 = Int($sleepdroppvect[1])
							Else
								$index1 = 1
								$sleepdrop2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$sleepdrop1 = Int($value7)
								$sleepdrop2 = Int($value7)
							Else
								$sleepdrop1 = 1
								$sleepdrop2 = 1
							EndIf
						EndIf

						If $value4 = "REMAIN" Then ;drop remain troops
							SetLog("dropRemain:  Dropping left over troops", $COLOR_BLUE)
							If PrepareAttack($iMatchMode, True) > 0 Then
								For $ii = $eLava To $eBarb Step -1 ; lauch all remaining troops from last to first
									LauchTroop($ii, 1, 0, 1)
								Next
							EndIf
						Else
							DropTroopFromINI($value1, $index1, $index2, $indexArray, $qty1, $qty2, $value4, $delaypoints1, $delaypoints2, $delaydrop1, $delaydrop2, $sleepdrop1, $sleepdrop2, $debug)
						EndIf
						ReleaseClicks($AndroidAdbClicksTroopDeploySize)
						If _Sleep($iDelayRespond) Then ; check for pause/stop, close file before return
							FileClose($f)
							Return
						EndIf
					Case "DROPS"
						KeepClicks()
						;qty...
						Local $qty1, $qty2, $qtyvect
						$qtyvect = StringSplit($value3, "-", 2)
						If UBound($qtyvect) > 1 Then
							If Int($qtyvect[0]) > 0 And Int($qtyvect[1]) > 0 Then
								$qty1 = Int($qtyvect[0])
								$qty2 = Int($qtyvect[1])
							Else
								$index1 = 1
								$qty2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$qty1 = Int($value3)
								$qty2 = Int($value3)
							Else
								$qty1 = 1
								$qty2 = 1
							EndIf
						EndIf
						;delay between points
						Local $delaypoints1, $delaypoints2, $delaypointsvect
						$delaypointsvect = StringSplit($value5, "-", 2)
						If UBound($delaypointsvect) > 1 Then
							If Int($delaypointsvect[0]) > 0 And Int($delaypointsvect[1]) > 0 Then
								$delaypoints1 = Int($delaypointsvect[0])
								$delaypoints2 = Int($delaypointsvect[1])
							Else
								$delaypoints1 = 1
								$delaypoints2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$delaypoints1 = Int($value5)
								$delaypoints2 = Int($value5)
							Else
								$delaypoints1 = 1
								$delaypoints2 = 1
							EndIf
						EndIf
						;delay between  drops in same point
						Local $delaydrop1, $delaydrop2, $delaydropvect
						$delaydropvect = StringSplit($value6, "-", 2)
						If UBound($delaydropvect) > 1 Then
							If Int($delaydropvect[0]) > 0 And Int($delaydropvect[1]) > 0 Then
								$delaydrop1 = Int($delaydropvect[0])
								$delaydrop2 = Int($delaydropvect[1])
							Else
								$delaydrop1 = 1
								$delaydrop2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$delaydrop1 = Int($value6)
								$delaydrop2 = Int($value6)
							Else
								$delaydrop1 = 1
								$delaydrop2 = 1
							EndIf
						EndIf
						;sleep time after drop
						Local $sleepdrop1, $sleepdrop2, $sleepdroppvect
						$sleepdroppvect = StringSplit($value7, "-", 2)
						If UBound($sleepdroppvect) > 1 Then
							If Int($sleepdroppvect[0]) > 0 And Int($sleepdroppvect[1]) > 0 Then
								$sleepdrop1 = Int($sleepdroppvect[0])
								$sleepdrop2 = Int($sleepdroppvect[1])
							Else
								$index1 = 1
								$sleepdrop2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$sleepdrop1 = Int($value7)
								$sleepdrop2 = Int($value7)
							Else
								$sleepdrop1 = 1
								$sleepdrop2 = 1
							EndIf
						EndIf
						DropSpellFromINIOnDefense($value1, $value2, $qty1, $qty2, $value4, $delaypoints1, $delaypoints2, $delaydrop1, $delaydrop2, $sleepdrop1, $sleepdrop2, $debug)
						ReleaseClicks($AndroidAdbClicksTroopDeploySize)
						If _Sleep($iDelayRespond) Then ; check for pause/stop, close file before return
							FileClose($f)
							Return
						EndIf
					Case "ZINIT"
						ReleaseClicks()
						ZInit(String($value1 & "|" & $value2 & "|" & $value3 & "|" & $value4 & "|" & $value5 & "|" & $value6 & "|" & $value7 & "|" & $value8))
					Case "ZAP"
						KeepClicks()
						Local $splitedVal8 = StringSplit($value8, "-", 2)
						If StringInStr($value8, "-") > 0 Then $value8 = Int(Random(Number($splitedVal8[0]), Number($splitedVal8[1]), 1))
						ParseZapCommand(String($value1 & "|" & $value2 & "|" & $value3 & "|" & $value4 & "|" & $value5 & "|" & $value6 & "|" & $value7 & "|" & $value8))
					Case "WAIT"
						ReleaseClicks()
						;sleep time
						Local $sleep1, $sleep2, $sleepvect
						$sleepvect = StringSplit($value1, "-", 2)
						If UBound($sleepvect) > 1 Then
							If Int($sleepvect[0]) > 0 And Int($sleepvect[1]) > 0 Then
								$sleep1 = Int($sleepvect[0])
								$sleep2 = Int($sleepvect[1])
							Else
								$sleep1 = 1
								$sleep2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$sleep1 = Int($value1)
								$sleep2 = Int($value1)
							Else
								$sleep1 = 1
								$sleep2 = 1
							EndIf
						EndIf
						If $sleep1 <> $sleep2 Then
							Local $sleep = Random(Int($sleep1), Int($sleep2), 1)
						Else
							Local $sleep = Int($sleep1)
						EndIf
						debugAttackCSV("wait " & $sleep)
						;If _Sleep($sleep) Then Return
						Local $Gold = 0
						Local $Elixir = 0
						Local $DarkElixir = 0
						Local $Trophies = 0
						Local $exitOneStar = 0
						Local $exitTwoStars = 0
						Local $exitNoResources = 0
						Local $hSleepTimer = TimerInit()
						While TimerDiff($hSleepTimer) < $sleep
							;READ RESOURCES
							$Gold = getGoldVillageSearch(48, 69)
							$Elixir = getElixirVillageSearch(48, 69 + 29)
							If _Sleep($iDelayRespond) Then ; check for pause/stop, close file before return
								FileClose($f)
								Return
							EndIf
							$Trophies = getTrophyVillageSearch(48, 69 + 99)
							If $Trophies <> "" Then ; If trophy value found, then base has Dark Elixir
								$DarkElixir = getDarkElixirVillageSearch(48, 69 + 57)
							Else
								$DarkElixir = ""
								$Trophies = getTrophyVillageSearch(48, 69 + 69)
							EndIf
							If $DebugSetLog = 1 Then SetLog("detected [G]: " & $Gold & " [E]: " & $Elixir & " [DE]: " & $DarkElixir, $COLOR_DEBUG) ;Debug
							;EXIT IF RESOURCES = 0
							If $ichkEndNoResources[$iMatchMode] = 1 And Number($Gold) = 0 And Number($Elixir) = 0 And Number($DarkElixir) = 0 Then
								If $DebugSetLog = 1 Then Setlog("From Attackcsv: Gold & Elixir & DE = 0, end battle ", $COLOR_DEBUG) ;Debug
								$exitNoResources = 1
								ExitLoop
							EndIf
							;CALCULATE TWO STARS REACH
							If $ichkEndTwoStars[$iMatchMode] = 1 And _CheckPixel($aWonTwoStar, True) Then
								If $DebugSetLog = 1 Then Setlog("From Attackcsv: Two Star Reach, exit", $COLOR_DEBUG) ;Debug
								$exitTwoStars = 1
								ExitLoop
							EndIf
							;CALCULATE ONE STARS REACH
							If $ichkEndOneStar[$iMatchMode] = 1 And _CheckPixel($aWonOneStar, True) Then
								If $DebugSetLog = 1 Then Setlog("From Attackcsv: One Star Reach, exit", $COLOR_DEBUG) ;Debug
								$exitOneStar = 1
								ExitLoop
							EndIf
							If _Sleep($iDelayRespond) Then ; check for pause/stop, close file before return
								FileClose($f)
								Return
							EndIf
							CheckHeroesHealth()
						WEnd
						If $exitOneStar = 1 Or $exitTwoStars = 1 Or $exitNoResources = 1 Then ExitLoop ;stop parse CSV file, start exit battle procedure

					Case "RECALC"
						ReleaseClicks()
						PrepareAttack($iMatchMode, True)
					Case "SIDE"
						ReleaseClicks()
						Setlog("Calculate main side... ")
						If StringUpper($value8) = "EAGLE" Then
							Setlog("Forced side: " & StringUpper($value8))
							;Local $PixelEaglePos[2]
							$hTimer = TimerInit()

							Local $directory = @ScriptDir & "\images\WeakBase\Eagle"
							Local $return = returnHighestLevelSingleMatch($directory)
							Local $NotdetectedEagle = True
							If $DebugSetLog = 1 Then Setlog(" »» Ubound ROW $return: " & UBound($return, $UBOUND_ROWS), $COLOR_DEBUG) ;Debug
							If $DebugSetLog = 1 Then Setlog(" »» Ubound COLUMNS $return: " & UBound($return, $UBOUND_COLUMNS), $COLOR_DEBUG) ;Debug
							If $DebugSetLog = 1 Then Setlog(" »» Ubound DIMENSIONS $return: " & UBound($return, $UBOUND_DIMENSIONS), $COLOR_DEBUG) ;Debug


							If UBound($return) > 0 Then
								If $DebugSetLog = 1 Then Setlog(" »» Image: " & $return[0], $COLOR_DEBUG) ;Debug
								If $DebugSetLog = 1 Then Setlog(" »» Build: " & $return[1], $COLOR_DEBUG) ;Debug
								If $DebugSetLog = 1 Then Setlog(" »» Level: " & $return[2], $COLOR_DEBUG) ;Debug
								Local $EaglePosition = $return[5]
								If $DebugSetLog = 1 Then Setlog(" »» $EaglePosition[0] X: " & $EaglePosition[0][0], $COLOR_DEBUG) ;Debug
								If $DebugSetLog = 1 Then Setlog(" »» $EaglePosition[1] Y: " & $EaglePosition[0][1], $COLOR_DEBUG) ;Debug
								If $DebugSetLog = 1 Then Setlog(" »» Ubound ROW $EaglePosition: " & UBound($EaglePosition, $UBOUND_ROWS), $COLOR_DEBUG) ;Debug
								If $DebugSetLog = 1 Then Setlog(" »» Ubound COLUMNS $EaglePosition: " & UBound($EaglePosition, $UBOUND_COLUMNS), $COLOR_DEBUG) ;Debug
								If $DebugSetLog = 1 Then Setlog(" »» Ubound DIMENSIONS $EaglePosition: " & UBound($EaglePosition, $UBOUND_DIMENSIONS), $COLOR_DEBUG) ;Debug

								If $EaglePosition[0][0] <> "" Then
									$PixelEaglePos[0] = $EaglePosition[0][0]
									$PixelEaglePos[1] = $EaglePosition[0][1]
									Setlog(" »» Eagle located in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds")
									Switch StringLeft(Slice8($PixelEaglePos), 1)
										Case 1, 2
											$MAINSIDE = "BOTTOM-RIGHT"
										Case 3, 4
											$MAINSIDE = "TOP-RIGHT"
										Case 5, 6
											$MAINSIDE = "TOP-LEFT"
										Case 7, 8
											$MAINSIDE = "BOTTOM-LEFT"
									EndSwitch
									Setlog(" » Eagle located : " & $MAINSIDE, $COLOR_BLUE)
									$NotdetectedEagle = False
								Else
									Setlog("> Eagle not detected!", $COLOR_BLUE)
									DebugImageSave("EagleDetection_NotDetected_", True)
								EndIf
							Else
								Setlog("> Eagle not Present!", $COLOR_BLUE)
								DebugImageSave("EagleDetection_NotPresent_", True)
							EndIf

							If $MAINSIDE = "" Then $MAINSIDE = "TOP-RIGHT" ; Just in csae of any error
							If $attackcsv_locate_townhall = 1 And $NotdetectedEagle = True Then
								$pixel = StringSplit($thx & "-" & $thy, "-", 2)
								Switch StringLeft(Slice8($pixel), 1)
									Case 1, 2
										$MAINSIDE = "BOTTOM-RIGHT"
									Case 3, 4
										$MAINSIDE = "TOP-RIGHT"
									Case 5, 6
										$MAINSIDE = "TOP-LEFT"
									Case 7, 8
										$MAINSIDE = "BOTTOM-LEFT"
								EndSwitch
							EndIf
						ElseIf StringUpper($value8) = "ADEFENSE" Or StringUpper($value8) = "AIRDEFENSE" Then
							Setlog("Forced side: " & StringUpper($value8))
							Local $directory = @ScriptDir & "\images\WeakBase\ADefense"
							Local $rADefenseSearch = multiMatchesPixelOnly($directory, 0, $ECD, $ECD)
							If StringInStr($rADefenseSearch, ",") > 0 And StringLen($rADefenseSearch) > 2 Then ; If Any Air Defense Found
								Local $tmpSplitedPositions
								If StringInStr($rADefenseSearch, "|") > 0 Then
									$tmpSplitedPositions = StringSplit($rADefenseSearch, "|", 2)
									Local $splitedPositions[UBound($tmpSplitedPositions)][2]
								Else
									$tmpSplitedPositions = StringSplit($rADefenseSearch, ",", 2)
									Local $splitedPositions[1][2] = [-1, -1]
								EndIf
								For $i = 0 To (UBound($tmpSplitedPositions) - 1)
									$splitedPositions[$i][0] = StringSplit($tmpSplitedPositions[$i], ",", 2)[0]
									$splitedPositions[$i][1] = StringSplit($tmpSplitedPositions[$i], ",", 2)[1]
								Next
								SetLog(UBound($splitedPositions) & "x Air Defenses Found")
								Local $iABottomRight = 0, $iATopLeft = 0, $iATopRight = 0, $iABottomLeft = 0
								For $i = 0 To (UBound($splitedPositions) - 1)
									Switch StringLeft(Slice8($splitedPositions[$i]), 1)
										Case 1, 2
											$iABottomRight += 1
										Case 3, 4
											$iATopRight += 1
										Case 5, 6
											$iATopLeft += 1
										Case 7, 8
											$iABottomLeft += 1
									EndSwitch
								Next
								Local $maxValue = $iABottomRight
								Local $sidename = "BOTTOM-RIGHT"

								If $iATopLeft > $maxValue Then
									$maxValue = $iATopLeft
									$sidename = "TOP-LEFT"
								EndIf

								If $iATopRight > $maxValue Then
									$maxValue = $iATopRight
									$sidename = "TOP-RIGHT"
								EndIf

								If $iABottomLeft > $maxValue Then
									$maxValue = $iABottomLeft
									$sidename = "BOTTOM-LEFT"
								EndIf

								$MAINSIDE = $sidename
								Setlog(" » Air Defenses located : " & $MAINSIDE, $COLOR_BLUE)
							Else
								SetLog("No Air Defenses found to determine Main Side", $COLOR_BLUE)
								$MAINSIDE = "TOP-RIGHT"
								If $attackcsv_locate_townhall = 1 Then
									$pixel = StringSplit($thx & "-" & $thy, "-", 2)
									Switch StringLeft(Slice8($pixel), 1)
										Case 1, 2
											$MAINSIDE = "BOTTOM-RIGHT"
										Case 3, 4
											$MAINSIDE = "TOP-RIGHT"
										Case 5, 6
											$MAINSIDE = "TOP-LEFT"
										Case 7, 8
											$MAINSIDE = "BOTTOM-LEFT"
									EndSwitch
									SetLog("MAINSIDE = TH Side")
								EndIf
							Else
								SetLog("MAINSIDE = TOP-RIGHT")
							EndIf
						ElseIf StringUpper($value8) = "TOP-LEFT" Or StringUpper($value8) = "TOP-RIGHT" Or StringUpper($value8) = "BOTTOM-LEFT" Or StringUpper($value8) = "BOTTOM-RIGHT" Then
							$MAINSIDE = StringUpper($value8)
							Setlog("Forced side: " & StringUpper($value8))
						Else
							Local $heightTopLeft = 0, $heightTopRight = 0, $heightBottomLeft = 0, $heightBottomRight = 0
							UpdateResourcesLocations($line)
							For $i = 0 To UBound($PixelMine) - 1
								Local $str = ""
								Local $pixel = $PixelMine[$i]
								If UBound($pixel) = 2 Then
									Switch StringLeft(Slice8($pixel), 1)
										Case 1, 2
											$heightBottomRight += Int($value1)
										Case 3, 4
											$heightTopRight += Int($value1)
										Case 5, 6
											$heightTopLeft += Int($value1)
										Case 7, 8
											$heightBottomLeft += Int($value1)
									EndSwitch
								EndIf
							Next

							For $i = 0 To UBound($PixelElixir) - 1
								Local $str = ""
								Local $pixel = $PixelElixir[$i]
								If UBound($pixel) = 2 Then
									Switch StringLeft(Slice8($pixel), 1)
										Case 1, 2
											$heightBottomRight += Int($value2)
										Case 3, 4
											$heightTopRight += Int($value2)
										Case 5, 6
											$heightTopLeft += Int($value2)
										Case 7, 8
											$heightBottomLeft += Int($value2)
									EndSwitch
								EndIf
							Next

							For $i = 0 To UBound($PixelDarkElixir) - 1
								Local $str = ""
								Local $pixel = $PixelDarkElixir[$i]
								If UBound($pixel) = 2 Then
									Switch StringLeft(Slice8($pixel), 1)
										Case 1, 2
											$heightBottomRight += Int($value3)
										Case 3, 4
											$heightTopRight += Int($value3)
										Case 5, 6
											$heightTopLeft += Int($value3)
										Case 7, 8
											$heightBottomLeft += Int($value3)
									EndSwitch
								EndIf
							Next

							If IsArray($GoldStoragePos) Then
								For $i = 0 To UBound($GoldStoragePos) - 1
									Local $pixel = $GoldStoragePos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value4)
											Case 3, 4
												$heightTopRight += Int($value4)
											Case 5, 6
												$heightTopLeft += Int($value4)
											Case 7, 8
												$heightBottomLeft += Int($value4)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($ElixirStoragePos) Then
								For $i = 0 To UBound($ElixirStoragePos) - 1
									Local $pixel = $ElixirStoragePos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value5)
											Case 3, 4
												$heightTopRight += Int($value5)
											Case 5, 6
												$heightTopLeft += Int($value5)
											Case 7, 8
												$heightBottomLeft += Int($value5)
										EndSwitch
									EndIf
								Next
							EndIf

							Switch StringLeft(Slice8($darkelixirStoragePos), 1)
								Case 1, 2
									$heightBottomRight += Int($value6)
								Case 3, 4
									$heightTopRight += Int($value6)
								Case 5, 6
									$heightTopLeft += Int($value6)
								Case 7, 8
									$heightBottomLeft += Int($value6)
							EndSwitch

							$pixel = StringSplit($thx & "-" & $thy, "-", 2)
							Switch StringLeft(Slice8($pixel), 1)
								Case 1, 2
									$heightBottomRight += Int($value7)
								Case 3, 4
									$heightTopRight += Int($value7)
								Case 5, 6
									$heightTopLeft += Int($value7)
								Case 7, 8
									$heightBottomLeft += Int($value7)
							EndSwitch

							Local $maxValue = $heightBottomRight
							Local $sidename = "BOTTOM-RIGHT"

							If $heightTopLeft > $maxValue Then
								$maxValue = $heightTopLeft
								$sidename = "TOP-LEFT"
							EndIf

							If $heightTopRight > $maxValue Then
								$maxValue = $heightTopRight
								$sidename = "TOP-RIGHT"
							EndIf

							If $heightBottomLeft > $maxValue Then
								$maxValue = $heightBottomLeft
								$sidename = "BOTTOM-LEFT"
							EndIf

							Setlog("Mainside: " & $sidename & " (top-left:" & $heightTopLeft & " top-right:" & $heightTopRight & " bottom-left:" & $heightBottomLeft & " bottom-right:" & $heightBottomRight & ")")
							$MAINSIDE = $sidename
						EndIf
						Switch $MAINSIDE
							Case "BOTTOM-RIGHT"
								$FRONT_LEFT = "BOTTOM-RIGHT-DOWN"
								$FRONT_RIGHT = "BOTTOM-RIGHT-UP"
								$RIGHT_FRONT = "TOP-RIGHT-DOWN"
								$RIGHT_BACK = "TOP-RIGHT-UP"
								$LEFT_FRONT = "BOTTOM-LEFT-DOWN"
								$LEFT_BACK = "BOTTOM-LEFT-UP"
								$BACK_LEFT = "TOP-LEFT-DOWN"
								$BACK_RIGHT = "TOP-LEFT-UP"
							Case "BOTTOM-LEFT"
								$FRONT_LEFT = "BOTTOM-LEFT-UP"
								$FRONT_RIGHT = "BOTTOM-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-RIGHT-DOWN"
								$RIGHT_BACK = "BOTTOM-RIGHT-UP"
								$LEFT_FRONT = "TOP-LEFT-DOWN"
								$LEFT_BACK = "TOP-LEFT-UP"
								$BACK_LEFT = "TOP-RIGHT-UP"
								$BACK_RIGHT = "TOP-RIGHT-DOWN"
							Case "TOP-LEFT"
								$FRONT_LEFT = "TOP-LEFT-UP"
								$FRONT_RIGHT = "TOP-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-LEFT-UP"
								$RIGHT_BACK = "BOTTOM-LEFT-DOWN"
								$LEFT_FRONT = "TOP-RIGHT-UP"
								$LEFT_BACK = "TOP-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-RIGHT-UP"
								$BACK_RIGHT = "BOTTOM-RIGHT-DOWN"
							Case "TOP-RIGHT"
								$FRONT_LEFT = "TOP-RIGHT-DOWN"
								$FRONT_RIGHT = "TOP-RIGHT-UP"
								$RIGHT_FRONT = "TOP-LEFT-UP"
								$RIGHT_BACK = "TOP-LEFT-DOWN"
								$LEFT_FRONT = "BOTTOM-RIGHT-UP"
								$LEFT_BACK = "BOTTOM-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-LEFT-DOWN"
								$BACK_RIGHT = "BOTTOM-LEFT-UP"
						EndSwitch
						ParseAndMakeDropLines($MAINSIDE)
					Case "SIDEP"
						Local $sidep_locate_mine = 0, $sidep_locate_elixir = 0, $sidep_locate_drill = 0
						$sidep_locate_mine = IIf(Int($value1) > 0, 1, 0)
						$sidep_locate_elixir = IIf(Int($value2) > 0, 1, 0)
						$sidep_locate_drill = IIf(Int($value3) > 0, 1, 0)
						Local $heightTopLeft = 0, $heightTopRight = 0, $heightBottomLeft = 0, $heightBottomRight = 0
						Local $rGetCountEachSide
						Local $hLTimer
						If $sidep_locate_mine = 1 Then
							$hLTimer = TimerInit()
							$rGetCountEachSide = GetCountEachSide("Mine")
							If Not @error Then
								SetLog("Gold Mines Located within " & Round(Number(TimerDiff($hLTimer) / 1000), 2) & " second(s)")
								$heightBottomRight += ($rGetCountEachSide[0] * Int($value1))
								$heightTopRight += ($rGetCountEachSide[1] * Int($value1))
								$heightTopLeft += ($rGetCountEachSide[2] * Int($value1))
								$heightBottomLeft += ($rGetCountEachSide[3] * Int($value1))
							ElseIf @error = 2 Then
								SetLog("Cannot find Gold Mines", $COLOR_ORANGE)
							EndIf
						EndIf
						If $sidep_locate_elixir = 1 Then
							$hLTimer = TimerInit()
							$rGetCountEachSide = GetCountEachSide("Collector")
							If Not @error Then
								SetLog("Elixir Collectors Located within " & Round(Number(TimerDiff($hLTimer) / 1000), 2) & " second(s)")
								$heightBottomRight += ($rGetCountEachSide[0] * Int($value2))
								$heightTopRight += ($rGetCountEachSide[1] * Int($value2))
								$heightTopLeft += ($rGetCountEachSide[2] * Int($value2))
								$heightBottomLeft += ($rGetCountEachSide[3] * Int($value2))
							ElseIf @error = 2 Then
								SetLog("Cannot find Elixir Collectors", $COLOR_ORANGE)
							EndIf
						EndIf
						If $sidep_locate_drill = 1 Then
							$hLTimer = TimerInit()
							$rGetCountEachSide = GetCountEachSide("Drill")
							If Not @error Then
								SetLog("Dark Drills Located within " & Round(Number(TimerDiff($hLTimer) / 1000), 2) & " second(s)")
								$heightBottomRight += ($rGetCountEachSide[0] * Int($value3))
								$heightTopRight += ($rGetCountEachSide[1] * Int($value3))
								$heightTopLeft += ($rGetCountEachSide[2] * Int($value3))
								$heightBottomLeft += ($rGetCountEachSide[3] * Int($value3))
							ElseIf @error = 2 Then
								SetLog("Cannot find Dark Drills", $COLOR_ORANGE)
							EndIf
						EndIf

						Local $maxValue = $heightBottomRight
						Local $sidename = "BOTTOM-RIGHT"

						Switch $value8
							Case "Highest"

								If $heightTopLeft > $maxValue Then
									$maxValue = $heightTopLeft
									$sidename = "TOP-LEFT"
								EndIf

								If $heightTopRight > $maxValue Then
									$maxValue = $heightTopRight
									$sidename = "TOP-RIGHT"
								EndIf

								If $heightBottomLeft > $maxValue Then
									$maxValue = $heightBottomLeft
									$sidename = "BOTTOM-LEFT"
								EndIf

							Case "Lowest"

								If $heightTopLeft < $maxValue Then
									$maxValue = $heightTopLeft
									$sidename = "TOP-LEFT"
								EndIf

								If $heightTopRight < $maxValue Then
									$maxValue = $heightTopRight
									$sidename = "TOP-RIGHT"
								EndIf

								If $heightBottomLeft < $maxValue Then
									$maxValue = $heightBottomLeft
									$sidename = "BOTTOM-LEFT"
								EndIf

							Case Else

								If $heightTopLeft > $maxValue Then
									$maxValue = $heightTopLeft
									$sidename = "TOP-LEFT"
								EndIf

								If $heightTopRight > $maxValue Then
									$maxValue = $heightTopRight
									$sidename = "TOP-RIGHT"
								EndIf

								If $heightBottomLeft > $maxValue Then
									$maxValue = $heightBottomLeft
									$sidename = "BOTTOM-LEFT"
								EndIf
						EndSwitch
						Setlog("SideP-Mainside: " & $sidename & " (top-left:" & $heightTopLeft & " top-right:" & $heightTopRight & " bottom-left:" & $heightBottomLeft & " bottom-right:" & $heightBottomRight & ")")
						$MAINSIDE = $sidename
						Switch $MAINSIDE
							Case "BOTTOM-RIGHT"
								$FRONT_LEFT = "BOTTOM-RIGHT-DOWN"
								$FRONT_RIGHT = "BOTTOM-RIGHT-UP"
								$RIGHT_FRONT = "TOP-RIGHT-DOWN"
								$RIGHT_BACK = "TOP-RIGHT-UP"
								$LEFT_FRONT = "BOTTOM-LEFT-DOWN"
								$LEFT_BACK = "BOTTOM-LEFT-UP"
								$BACK_LEFT = "TOP-LEFT-DOWN"
								$BACK_RIGHT = "TOP-LEFT-UP"
							Case "BOTTOM-LEFT"
								$FRONT_LEFT = "BOTTOM-LEFT-UP"
								$FRONT_RIGHT = "BOTTOM-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-RIGHT-DOWN"
								$RIGHT_BACK = "BOTTOM-RIGHT-UP"
								$LEFT_FRONT = "TOP-LEFT-DOWN"
								$LEFT_BACK = "TOP-LEFT-UP"
								$BACK_LEFT = "TOP-RIGHT-UP"
								$BACK_RIGHT = "TOP-RIGHT-DOWN"
							Case "TOP-LEFT"
								$FRONT_LEFT = "TOP-LEFT-UP"
								$FRONT_RIGHT = "TOP-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-LEFT-UP"
								$RIGHT_BACK = "BOTTOM-LEFT-DOWN"
								$LEFT_FRONT = "TOP-RIGHT-UP"
								$LEFT_BACK = "TOP-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-RIGHT-UP"
								$BACK_RIGHT = "BOTTOM-RIGHT-DOWN"
							Case "TOP-RIGHT"
								$FRONT_LEFT = "TOP-RIGHT-DOWN"
								$FRONT_RIGHT = "TOP-RIGHT-UP"
								$RIGHT_FRONT = "TOP-LEFT-UP"
								$RIGHT_BACK = "TOP-LEFT-DOWN"
								$LEFT_FRONT = "BOTTOM-RIGHT-UP"
								$LEFT_BACK = "BOTTOM-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-LEFT-DOWN"
								$BACK_RIGHT = "BOTTOM-LEFT-UP"
						EndSwitch
						ParseAndMakeDropLines($MAINSIDE)
					Case Else
						Setlog("attack row bad, discard :row " & $rownum, $COLOR_RED)
				EndSwitch
			Else
				If StringLeft($line, 7) <> "NOTE  |" And StringLeft($line, 7) <> "      |" And StringStripWS(StringUpper($line), 2) <> "" Then Setlog("attack row error, discard.: " & $line, $COLOR_RED)
			EndIf
			CheckHeroesHealth()
			If _Sleep($iDelayRespond) Then ; check for pause/stop after each line of CSV, close file before return
				FileClose($f)
				Return
			EndIf
		WEnd
		ResetSideP()
		ResetZapCmd()
		ResetRedLines()
		ReleaseClicks()
		FileClose($f)
	Else
		SetLog("Cannot find attack file " & $dirAttacksCSV & "\" & $filename & ".csv", $color_red)
	EndIf
EndFunc   ;==>ParseAttackCSV
