; #FUNCTION# ====================================================================================================================
; Name ..........: CheckOutSide.au3
; Description ...: Check if the Village matches with OutSide Conditions
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: MR.ViPER (24-11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $DebugOutSide = 0

Func IsOutSideMatch()
	If $ichkOutSideCollectors = 0 And $ichkOutSideMines = 0 And $ichkOutSideDrills = 0 Then Return True

	Local $checkCollectors = ($ichkOutSideCollectors = 1) ? False : True, $checkMines = ($ichkOutSideMines = 1) ? False : True, $checkDrills = ($ichkOutSideDrills = 1) ? False : True

	Local $rGetOutSideStats

	Local $dbgImgText = ""

	_CaptureRegion2()

	; Elixir Collectors
	If $checkCollectors = False Then
		If $DebugOutSide Then SetLog("Checking OutSide Collectors")
		If Not IsObjLocated("Collector") Then StoreSidePPositions("Collector", True)

		$rGetOutSideStats = GetOutSideStats($allCollectorsFound, $itxtSensCollectors)
		If $DebugOutSide OR $debugImageSave Then $dbgImgText &= "Collectors [Out]= " & $rGetOutSideStats[0] & ", [In]= " & $rGetOutSideStats[1] & ", [SENS]= " & $itxtSensCollectors & @CRLF
		If StringInStr($stxtPercentCollectors, "%") > 0 Then
			If Number(GetOutSidePercentage($rGetOutSideStats)[0]) >= Number($stxtPercentCollectors) Then $checkCollectors = True
		Else
			If Number($rGetOutSideStats[0]) >= Number($stxtPercentCollectors) Then $checkCollectors = True
		EndIf

	EndIf

	; Gold Mines
	If $checkMines = False Then
		If $DebugOutSide Then SetLog("Checking OutSide Mines")
		If Not IsObjLocated("Mine") Then StoreSidePPositions("Mine", True)

		$rGetOutSideStats = GetOutSideStats($allMinesFound, $itxtSensMines)
		If $DebugOutSide OR $debugImageSave Then $dbgImgText &= "Mines [Out]= " & $rGetOutSideStats[0] & ", [In]= " & $rGetOutSideStats[1] & ", [SENS]= " & $itxtSensMines & @CRLF
		If StringInStr($stxtPercentMines, "%") > 0 Then
			If Number(GetOutSidePercentage($rGetOutSideStats)[0]) >= Number($stxtPercentMines) Then $checkMines = True
		Else
			If Number($rGetOutSideStats[0]) >= Number($stxtPercentMines) Then $checkMines = True
		EndIf

	EndIf

	; Dark Elixir Drills
	If $checkDrills = False Then
		If $DebugOutSide Then SetLog("Checking OutSide Drills")
		If Not IsObjLocated("Drill") Then StoreSidePPositions("Drill", True)

		$rGetOutSideStats = GetOutSideStats($allDrillsFound, $itxtSensDrills)
		If $DebugOutSide OR $debugImageSave Then $dbgImgText &= "Drills [Out]= " & $rGetOutSideStats[0] & ", [In]= " & $rGetOutSideStats[1] & ", [SENS]= " & $itxtSensDrills
		If StringInStr($stxtPercentDrills, "%") > 0 Then
			If Number(GetOutSidePercentage($rGetOutSideStats)[0]) >= Number($stxtPercentDrills) Then $checkDrills = True
		Else
			If Number($rGetOutSideStats[0]) >= Number($stxtPercentDrills) Then $checkDrills = True
		EndIf

	EndIf

	If $DebugOutSide Then SetLog("2nd: " & $checkCollectors & ", " & $checkMines & ", " & $checkDrills)

	Local $Result = $checkCollectors And $checkMines And $checkDrills

	If $Result = False And $debugImageSave OR $DebugOutSide Then
		DebugImageSave("NotOutSide_", False, "png", True, $dbgImgText, 0, 500, 10, 0, 0, 0, 0, $CurBaseRedLine[0])
	EndIf

	Return $Result
EndFunc   ;==>IsOutSideMatch

Func GetOutSidePercentage($rGetOutSideStats)
	Local $ToReturn[2]
	Local $iTotalItems = Number(Number($rGetOutSideStats[0]) + Number($rGetOutSideStats[1]))
	$ToReturn[0] = Round(($rGetOutSideStats[0] / $iTotalItems) * 100) ; Out Side Collectors Percentage
	$ToReturn[1] = Round(($rGetOutSideStats[1] / $iTotalItems) * 100) ; In Side Collectors Percentage
	Return $ToReturn
EndFunc   ;==>GetOutSidePercentage

Func GetOutSideStats($AllPositions, $iValToDetectAsOutSide)
	Local $ToReturn[2]
	Local $iOutSide = 0, $iInSide = 0
	Local $rGetNearestDropPoint
	For $i = 0 To (UBound($AllPositions) - 1)
		$rGetNearestDropPoint = GetNearestDropPoint($AllPositions[$i][0], $AllPositions[$i][1], True)
		If $rGetNearestDropPoint <= $iValToDetectAsOutSide Then
			$iOutSide += 1
		Else
			$iInSide += 1
		EndIf
		If ($iOutSide + $iInSide) = 7 Then ExitLoop
	Next
	$ToReturn[0] = $iOutSide
	$ToReturn[1] = $iInSide
	If $DebugOutSide Then SetLog("OutSide Count = x" & $iOutSide & ", InSide Count = x" & $iInSide, $COLOR_BLUE)
	Return $ToReturn
EndFunc   ;==>GetOutSideStats

Func GetNearestDropPoint($X, $Y, $ReturnDistance = True)
	Local $Point[2] = [$X, $Y]
	Local $rGetRedLines = GetRedLines()
	Local $RedLinesOutSide = $rGetRedLines[0]
	Local $splitedRedLines = StringSplit($RedLinesOutSide, "|", 2)
	Local $tmpRedLinePoints
	Local $AllLinesWithDistance[UBound($splitedRedLines)][3]
	For $i = 0 To (UBound($splitedRedLines) - 1)
		$tmpRedLinePoints = StringSplit($splitedRedLines[$i], ",", 2)
		$AllLinesWithDistance[$i][0] = $tmpRedLinePoints[0]
		$AllLinesWithDistance[$i][1] = $tmpRedLinePoints[1]
		$AllLinesWithDistance[$i][2] = Abs(Number($tmpRedLinePoints[0]) - $Point[0]) + Abs(Number($tmpRedLinePoints[1]) - $Point[1])
	Next
	_ArraySort($AllLinesWithDistance, 0, 0, 0, 2)
	If $ReturnDistance = True Then Return $AllLinesWithDistance[0][2]
EndFunc   ;==>GetNearestDropPoint
