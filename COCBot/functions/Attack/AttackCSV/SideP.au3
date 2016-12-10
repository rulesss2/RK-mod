; #FUNCTION# ====================================================================================================================
; Name ..........: SideP
; Description ...: Determine Side Multiple times More fast, All This File Only For 'SideP' Command in Attack CSV
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: MR.ViPER (12-11-2016), MR.ViPER (22-11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $DebugSideP = 0
Global Const $dGoldMines = @ScriptDir & "\images\Resources\SideP\GoldMines", $dDarkDrills = @ScriptDir & "\images\Resources\SideP\Drills", $dElixirCollectors = @ScriptDir & "\images\Resources\SideP\Collectors"
Global $allMinesFound[7][2], $allCollectorsFound[7][2], $allDrillsFound[3][2]

Func TestSideP()
	Local $oRunState = $RunState
	$RunState = True

	GetRedLines()
	Local $rGetCountEachSide = GetCountEachSide("Collector")
	If Not @error Then
		GetPercentageEachSide($rGetCountEachSide)
	EndIf
	ResetRedLines()

	$RunState = $oRunState
EndFunc   ;==>TestSideP

Func GetPercentageEachSide($rGetCountEachSide)
	Local $ToReturn[4] = [0, 0, 0, 0]
	Local $TotalFound = $rGetCountEachSide[0] + $rGetCountEachSide[1] + $rGetCountEachSide[2] + $rGetCountEachSide[3]
	If $DebugSideP Then SetLog("Total Objects Found: " & $TotalFound)
	If $TotalFound = 0 Then Return SetError(1)

	$ToReturn[0] = Round(($rGetCountEachSide[0] / $TotalFound) * 100)
	$ToReturn[1] = Round(($rGetCountEachSide[1] / $TotalFound) * 100)
	$ToReturn[2] = Round(($rGetCountEachSide[2] / $TotalFound) * 100)
	$ToReturn[3] = Round(($rGetCountEachSide[3] / $TotalFound) * 100)

	If $DebugSideP Then
		SetLog("==============Percentage===============")
		SetLog("BOTTOM-RIGHT Percentage: " & $ToReturn[0] & "%", $COLOR_BLUE)
		SetLog("TOP-RIGHT Percentage: " & $ToReturn[1] & "%", $COLOR_BLUE)
		SetLog("TOP-LEFT Percentage: " & $ToReturn[2] & "%", $COLOR_BLUE)
		SetLog("BOTTOM-LEFT Percentage: " & $ToReturn[3] & "%", $COLOR_BLUE)
	EndIf
	Return $ToReturn
EndFunc   ;==>GetPercentageEachSide

Func GetCountEachSide($sToSearch)
	Local $ToReturn[4] = [0, 0, 0, 0]
	Local $iSearchResult = ""
	Local $bSomethingFound = False
	Local $splitedPositions
	$iSearchResult = ValidateOldPositions($sToSearch)

	If $iSearchResult <> "" And StringLen($iSearchResult) > 3 Then $bSomethingFound = True
	If $bSomethingFound Then
		If StringInStr($iSearchResult, "|") > 0 Then
			$splitedPositions = StringSplit($iSearchResult, "|", 2)
		Else
			$splitedPositions = _StringEqualSplit($iSearchResult, StringLen($iSearchResult))
		EndIf
	EndIf

	If $bSomethingFound = False Then
		If $DebugSideP Then
			SetLog("SomethingFound is false and" & @CRLF & "$iSearchResult = " & $iSearchResult, $COLOR_RED)
			DebugImageSave("SideP_BuildingNotFound_", False)
		EndIf
		Return SetError(2)
	Else
		SetLog("x" & UBound($splitedPositions) & " " & GetObjNameSideP($sToSearch) & " Verified", $COLOR_GREEN)
	EndIf

	For $Pos In $splitedPositions
		Switch StringLeft(Slice8(StringSplit($Pos, ",", 2)), 1)
			Case 1, 2 ; BOTTOM-RIGHT
				$ToReturn[0] += 1
			Case 3, 4 ; TOP-RIGHT
				$ToReturn[1] += 1
			Case 5, 6 ; TOP-LEFT
				$ToReturn[2] += 1
			Case 7, 8 ; BOTTOM-LEFT
				$ToReturn[3] += 1
		EndSwitch
	Next
	If $DebugSideP Then
		SetLog("==============Objects Count===============")
		SetLog("BOTTOM-RIGHT Objects Count: x" & $ToReturn[0], $COLOR_BLUE)
		SetLog("TOP-RIGHT Objects Count: x" & $ToReturn[1], $COLOR_BLUE)
		SetLog("TOP-LEFT Objects Count: x" & $ToReturn[2], $COLOR_BLUE)
		SetLog("BOTTOM-LEFT Objects Count: x" & $ToReturn[3], $COLOR_BLUE)
	EndIf

	Return $ToReturn
EndFunc   ;==>GetCountEachSide

Func GetObjNameSideP($sToSearch, $Plural = Default)
	Switch $sToSearch
		Case "Mine"
			If $Plural = Default Then Return "Gold Mine(s)"
			If $Plural = 0 Then Return "Gold Mine"
			If $Plural = 1 Then Return "Gold Mines"
		Case "Collector"
			If $Plural = Default Then Return "Elixir Collector(s)"
			If $Plural = 0 Then Return "Elixir Collector"
			If $Plural = 1 Then Return "Elixir Collectors"
		Case "Drill"
			Return "Dark Elixir Drill(s)"
			If $Plural = Default Then Return "Dark Elixir Drill(s)"
			If $Plural = 0 Then Return "Dark Elixir Drill"
			If $Plural = 1 Then Return "Dark Elixir Drills"
		Case Else
			Return $sToSearch
	EndSwitch
EndFunc   ;==>GetObjNameSideP

Func ResetSideP()
	For $i = 0 To (UBound($allMinesFound) - 1)
		$allMinesFound[$i][0] = -1
		$allMinesFound[$i][1] = -1
	Next

	For $i = 0 To (UBound($allCollectorsFound) - 1)
		$allCollectorsFound[$i][0] = -1
		$allCollectorsFound[$i][1] = -1
	Next

	For $i = 0 To (UBound($allDrillsFound) - 1)
		$allDrillsFound[$i][0] = -1
		$allDrillsFound[$i][1] = -1
	Next
EndFunc   ;==>ResetSideP

Func checkForSidePInCSV($sFilePath)
	Local $AvailableSideP = CheckSidePCommands($sFilePath)

	If UBound($AvailableSideP) > 0 Then
		SetLog("Initializing SideP for further uses", $COLOR_BLUE)
		_CaptureRegion2()
		For $i = 0 To (UBound($AvailableSideP) - 1)
			If Not IsObjLocated($AvailableSideP[$i]) Then StoreSidePPositions($AvailableSideP[$i], True)
		Next

		Local $iMinesFound = 0, $iCollectorsFound = 0, $iDrillsFound = 0
		For $i = 0 To (UBound($allMinesFound) - 1)
			If $allMinesFound[$i][0] > 0 And $allMinesFound[$i][1] > 0 Then $iMinesFound += 1
		Next
		For $i = 0 To (UBound($allCollectorsFound) - 1)
			If $allCollectorsFound[$i][0] > 0 And $allCollectorsFound[$i][1] > 0 Then $iCollectorsFound += 1
		Next
		For $i = 0 To (UBound($allDrillsFound) - 1)
			If $allDrillsFound[$i][0] > 0 And $allDrillsFound[$i][1] > 0 Then $iDrillsFound += 1
		Next
		SetLog("x" & $iMinesFound & " Gold Mine(s) located", $COLOR_BLUE)
		SetLog("x" & $iCollectorsFound & " Elixir Collector(s) located", $COLOR_BLUE)
		SetLog("x" & $iDrillsFound & " Dark Elixir Drill(s) located", $COLOR_BLUE)
	EndIf
EndFunc   ;==>checkForSidePInCSV

Func CheckSidePCommands($sFilePath)
	Local $ToReturn = ""
	If $RunState = False Then Return

	; Code For DeadBase
	If $iDBcheck = 1 Then
		If $iAtkAlgorithm[$DB] = 1 Then ; Scripted Attack is Selected
			$ToReturn &= GetSidePCommands($DB, $sFilePath)
		EndIf
	EndIf

	; Code For LiveBase
	If $iABcheck = 1 Then
		If $iAtkAlgorithm[$LB] = 1 Then ; Scripted Attack is Selected
			$ToReturn &= GetSidePCommands($LB, $sFilePath)
		EndIf
	EndIf

	$ToReturn = StringSplit($ToReturn, "|", 2)

	ArrayRemoveDuplicates($ToReturn) ; Remove Duplicates

	Return $ToReturn
EndFunc   ;==>CheckSidePCommands

Func GetSidePCommands($Mode, $sFilePath)
	Local $ToReturn = ""
	Local $filename = ""
	If $RunState = False Then Return

	Local $rownum = 0
	If FileExists($sFilePath) Then
		Local $f, $line, $acommand, $command
		Local $value1, $Troop
		$f = FileOpen($sFilePath, 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			$rownum += 1
			If @error = -1 Then ExitLoop
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), 2)
				If $command = "SIDEP" Then
					$EXTRGOLD = StringStripWS(StringUpper($acommand[2]), 2)
					$EXTRELIXIR = StringStripWS(StringUpper($acommand[3]), 2)
					$EXTRDARK = StringStripWS(StringUpper($acommand[4]), 2)

					$DEPOGOLD = StringStripWS(StringUpper($acommand[5]), 2)
					$DEPOELIXIR = StringStripWS(StringUpper($acommand[6]), 2)
					$DEPODARK = StringStripWS(StringUpper($acommand[7]), 2)

					$CTOWNHALL = StringStripWS(StringUpper($acommand[8]), 2)

					If Int($EXTRGOLD) > 0 Then $ToReturn &= "Mine" & "|"
					If Int($EXTRELIXIR) > 0 Then $ToReturn &= "Collector" & "|"
					If Int($EXTRDARK) > 0 Then $ToReturn &= "Drill" & "|"

					If Int($DEPOGOLD) > 0 Then $ToReturn &= "SMine" & "|"
					If Int($DEPOELIXIR) > 0 Then $ToReturn &= "SCollector" & "|"
					If Int($DEPODARK) > 0 Then $ToReturn &= "SDark" & "|"

					If Int($CTOWNHALL) > 0 Then $ToReturn &= "TownHall" & "|"
				EndIf
			EndIf
		WEnd
		FileClose($f)
	EndIf
	Return $ToReturn
EndFunc   ;==>GetSidePCommands

Func StoreSidePPositions($sToStore, $useOldCapture = True)
	Local $sResult = GetSidePPositions($sToStore, $useOldCapture)
	Switch $sToStore
		Case "Mine"
			If StringInStr($sResult, ",") > 0 And StringLen($sResult) > 2 Then
				Local $tmpSplitedPositions
				If StringInStr($sResult, "|") > 0 Then
					$tmpSplitedPositions = StringSplit($sResult, "|", 2)
				Else
					$tmpSplitedPositions = _StringEqualSplit($sResult, StringLen($sResult))
				EndIf
				Local $tmpSplitedPositions2
				For $i = 0 To (UBound($allMinesFound) - 1)
					If $i >= UBound($tmpSplitedPositions) Then
						$allMinesFound[$i][0] = -1
						$allMinesFound[$i][1] = -1
					Else
						$tmpSplitedPositions2 = StringSplit($tmpSplitedPositions[$i], ",", 2)
						$allMinesFound[$i][0] = $tmpSplitedPositions2[0]
						$allMinesFound[$i][1] = $tmpSplitedPositions2[1]
					EndIf
				Next
			Else
				For $i = 0 To (UBound($allMinesFound) - 1)
					$allMinesFound[$i][0] = -1
					$allMinesFound[$i][1] = -1
				Next
			EndIf
		Case "Collector"
			If StringInStr($sResult, ",") > 0 And StringLen($sResult) > 2 Then
				Local $tmpSplitedPositions
				If StringInStr($sResult, "|") > 0 Then
					$tmpSplitedPositions = StringSplit($sResult, "|", 2)
				Else
					$tmpSplitedPositions = _StringEqualSplit($sResult, StringLen($sResult))
				EndIf
				Local $tmpSplitedPositions2
				For $i = 0 To (UBound($allCollectorsFound) - 1)
					If $i >= UBound($tmpSplitedPositions) Then
						$allCollectorsFound[$i][0] = -1
						$allCollectorsFound[$i][1] = -1
					Else
						$tmpSplitedPositions2 = StringSplit($tmpSplitedPositions[$i], ",", 2)
						$allCollectorsFound[$i][0] = $tmpSplitedPositions2[0]
						$allCollectorsFound[$i][1] = $tmpSplitedPositions2[1]
					EndIf
				Next
			Else
				For $i = 0 To (UBound($allCollectorsFound) - 1)
					$allCollectorsFound[$i][0] = -1
					$allCollectorsFound[$i][1] = -1
				Next
			EndIf
		Case "Drill"
			If StringInStr($sResult, ",") > 0 And StringLen($sResult) > 2 Then
				Local $tmpSplitedPositions
				If StringInStr($sResult, "|") > 0 Then
					$tmpSplitedPositions = StringSplit($sResult, "|", 2)
				Else
					$tmpSplitedPositions = _StringEqualSplit($sResult, StringLen($sResult))
				EndIf
				Local $tmpSplitedPositions2
				For $i = 0 To (UBound($allDrillsFound) - 1)
					If $i >= UBound($tmpSplitedPositions) Then
						$allDrillsFound[$i][0] = -1
						$allDrillsFound[$i][1] = -1
					Else
						$tmpSplitedPositions2 = StringSplit($tmpSplitedPositions[$i], ",", 2)
						$allDrillsFound[$i][0] = $tmpSplitedPositions2[0]
						$allDrillsFound[$i][1] = $tmpSplitedPositions2[1]
					EndIf
				Next
			Else
				For $i = 0 To (UBound($allDrillsFound) - 1)
					$allDrillsFound[$i][0] = -1
					$allDrillsFound[$i][1] = -1
				Next
			EndIf
		Case Else
			Return SetError(1)
	EndSwitch
EndFunc   ;==>StoreSidePPositions

Func ValidateOldPositions($sToFind)
	Local $ToReturn = ""
	Local $searchResult = ""
	Local $iX, $iY
	Local $rGetHighestImageSize
	_CaptureRegion2()
	Switch $sToFind
		Case "Mine"
			$rGetHighestImageSize = GetHighestImageSize($dGoldMines, 3, 3)
			$iX = $rGetHighestImageSize[0]
			$iY = $rGetHighestImageSize[1]
			For $i = 0 To (UBound($allMinesFound) - 1)
				If Int($allMinesFound[$i][0]) > 0 And Int($allMinesFound[$i][1]) > 0 Then
					Local $X = $allMinesFound[$i][0] - $iX, $Y = $allMinesFound[$i][1] - $iY, $X1 = $allMinesFound[$i][0] + $iX, $Y1 = $allMinesFound[$i][1] + $iY
					$searchResult = multiMatchesPixelOnly($dGoldMines, 1, "FV", "FV", "", 0, 1000, $X, $Y, $X1, $Y1, False)
					Local $tmpSplitedPositions
					If StringInStr($searchResult, ",") > 0 Then
						$tmpSplitedPositions = StringSplit($searchResult, ",", 2)
						$ToReturn &= $tmpSplitedPositions[0] + $X & "," & $tmpSplitedPositions[1] + $Y & "|"
					EndIf
				EndIf
			Next
		Case "Collector"
			$rGetHighestImageSize = GetHighestImageSize($dElixirCollectors, 3, 3)
			$iX = $rGetHighestImageSize[0]
			$iY = $rGetHighestImageSize[1]
			For $i = 0 To (UBound($allCollectorsFound) - 1)
				If Int($allCollectorsFound[$i][0]) > 0 And Int($allCollectorsFound[$i][1]) > 0 Then
					Local $X = $allCollectorsFound[$i][0] - $iX, $Y = $allCollectorsFound[$i][1] - $iY, $X1 = $allCollectorsFound[$i][0] + $iX, $Y1 = $allCollectorsFound[$i][1] + $iY
					$searchResult = multiMatchesPixelOnly($dElixirCollectors, 1, "FV", "FV", "", 0, 1000, $X, $Y, $X1, $Y1, False)
					Local $tmpSplitedPositions
					If StringInStr($searchResult, ",") > 0 Then
						$tmpSplitedPositions = StringSplit($searchResult, ",", 2)
						$ToReturn &= $tmpSplitedPositions[0] + $X & "," & $tmpSplitedPositions[1] + $Y & "|"
					EndIf
				EndIf
			Next
		Case "Drill"
			$rGetHighestImageSize = GetHighestImageSize($dDarkDrills, 3, 3)
			$iX = $rGetHighestImageSize[0]
			$iY = $rGetHighestImageSize[1]
			For $i = 0 To (UBound($allDrillsFound) - 1)
				If Int($allDrillsFound[$i][0]) > 0 And Int($allDrillsFound[$i][1]) > 0 Then
					Local $X = $allDrillsFound[$i][0] - $iX, $Y = $allDrillsFound[$i][1] - $iY, $X1 = $allDrillsFound[$i][0] + $iX, $Y1 = $allDrillsFound[$i][1] + $iY
					$searchResult = multiMatchesPixelOnly($dDarkDrills, 1, "FV", "FV", "", 0, 1000, $X, $Y, $X1, $Y1, False)
					Local $tmpSplitedPositions
					If StringInStr($searchResult, ",") > 0 Then
						$tmpSplitedPositions = StringSplit($searchResult, ",", 2)
						$ToReturn &= $tmpSplitedPositions[0] + $X & "," & $tmpSplitedPositions[1] + $Y & "|"
					EndIf
				EndIf
			Next
	EndSwitch

	If StringRight($ToReturn, 1) = "|" Then $ToReturn = StringLeft($ToReturn, (StringLen($ToReturn) - 1))
	Return $ToReturn
EndFunc   ;==>ValidateOldPositions

Func GetSidePPositions($sToFind, $useOldCapture = True)
	Local $iSearchResult
	Switch $sToFind
		Case "Mine"
			If $useOldCapture = True Then
				$iSearchResult = multiMatchesPixelOnly($dGoldMines, 0, $ECD, $ECD, "", 0, 1000, 0, 0, $GAME_WIDTH, $GAME_HEIGHT, False, 10, 10, True)
			Else
				$iSearchResult = multiMatchesPixelOnly($dGoldMines, 0, $ECD, $ECD, "", 0, 1000, 0, 0, $GAME_WIDTH, $GAME_HEIGHT, True, 10, 10, True)
			EndIf
		Case "Collector"
			If $useOldCapture = True Then
				$iSearchResult = multiMatchesPixelOnly($dElixirCollectors, 0, $ECD, $ECD, "", 0, 1000, 0, 0, $GAME_WIDTH, $GAME_HEIGHT, False, 5, 10, True)
			Else
				$iSearchResult = multiMatchesPixelOnly($dElixirCollectors, 0, $ECD, $ECD, "", 0, 1000, 0, 0, $GAME_WIDTH, $GAME_HEIGHT, True, 10, 10, True)
			EndIf
		Case "Drill"
			If $useOldCapture = True Then
				$iSearchResult = multiMatchesPixelOnly($dDarkDrills, 0, $ECD, $ECD, "", 0, 1000, 0, 0, $GAME_WIDTH, $GAME_HEIGHT, False, 10, 10, True)
			Else
				$iSearchResult = multiMatchesPixelOnly($dDarkDrills, 0, $ECD, $ECD, "", 0, 1000, 0, 0, $GAME_WIDTH, $GAME_HEIGHT, True, 10, 10, True)
			EndIf
		Case Else
			Return SetError(1)
	EndSwitch
	Return $iSearchResult
EndFunc   ;==>GetSidePPositions

Func IsObjLocated($Obj)
	Switch $Obj
		Case "Mine"
			For $i = 0 To (UBound($allMinesFound) - 1)
				If ($allMinesFound[$i][0] > 0 And $allMinesFound[$i][1] > 0) Then Return True
			Next
			Return False
		Case "Collector"
			For $i = 0 To (UBound($allCollectorsFound) - 1)
				If ($allCollectorsFound[$i][0] > 0 And $allCollectorsFound[$i][1] > 0) Then Return True
			Next
			Return False
		Case "Drill"
			For $i = 0 To (UBound($allDrillsFound) - 1)
				If ($allDrillsFound[$i][0] > 0 And $allDrillsFound[$i][1] > 0) Then Return True
			Next
			Return False
		Case Else
			Return False
	EndSwitch
EndFunc   ;==>IsObjLocated

Func GetRedLines()
	If StringLen($CurBaseRedLine[0]) > 30 Then Return $CurBaseRedLine
	If $DebugSideP Then $hTimer = TimerInit()
	_CaptureRegion2()
	Local $SingleCocDiamond = "ECD"
	Local $result = DllCall($pImgLib2, "str", "SearchRedLines", "handle", $hHBitmap2, "str", $SingleCocDiamond)
	If IsArray($result) Then
		If $DebugSideP Then SetLog("Redline grabbed within " & Round(TimerDiff($hTimer) / 1000, 2) & " second(s)", $COLOR_GREEN)
		$CurBaseRedLine[0] = $result[0]
	EndIf
	Return $CurBaseRedLine
EndFunc   ;==>GetRedLines

