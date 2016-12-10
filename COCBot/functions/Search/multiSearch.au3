; #FUNCTION# ====================================================================================================================
; Name ..........: multiSearch
; Description ...: Various functions to return information from a multiple tile search
; Syntax ........:
; Parameters ....: None
; Return values .: An array of values of detected defense levels and information
; Author ........: LunaEclipse(April 2016)
; Modified ......: MR.ViPER (October-2016), MR.ViPER (November-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func updateMultiSearchStats($aResult, $statFile = "")
	Switch $statFile
		Case $statChkWeakBase
			updateWeakBaseStats($aResult)
		Case Else
			; Don't log stats at present
	EndSwitch
EndFunc   ;==>updateMultiSearchStats

Func addInfoToDebugImage($hGraphic, $hPen, $fileName, $x, $y)
	; Draw the location on the image
	_GDIPlus_GraphicsDrawRect($hGraphic, $x - 5, $y - 5, 10, 10, $hPen)

	; Store the variables needed for writing the text
	Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
	Local $hFormat = _GDIPlus_StringFormatCreate()
	Local $hFamily = _GDIPlus_FontFamilyCreate("Tahoma")
	Local $hFont = _GDIPlus_FontCreate($hFamily, 12, 2)
	Local $tLayout = _GDIPlus_RectFCreate($x + 10, $y, 0, 0)
	Local $sString = String($fileName)
	Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $sString, $hFont, $tLayout, $hFormat)

	; Write the level found on the image
	_GDIPlus_GraphicsDrawStringEx($hGraphic, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)

	; Dispose all resources
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
EndFunc   ;==>addInfoToDebugImage

Func captureDebugImage($aResult, $subDirectory)
	Local $coords

	If IsArray($aResult) Then
		; Create the directory in case it doesn't exist
		DirCreate($dirTempDebug & $subDirectory)

		; Capture the screen for comparison
		_CaptureRegion()

		; Store a copy of the image handle
		Local $editedImage = $hBitmap

		; Create the timestamp and filename
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $fileName = String($Date & "_" & $Time & ".png")

		; Needed for editing the picture
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED

		; Edit the image with information about items found
		For $i = 1 To UBound($aResult) - 1
			; Check to make sure there is results to display
			If Number($aResult[$i][4]) > 0 Then
				; Retrieve the coords sub-array
				$coords = $aResult[$i][5]

				If IsArray($coords) Then
					; Loop through all found points for the item and add them to the image
					For $j = 0 To UBound($coords) - 1
						addInfoToDebugImage($hGraphic, $hPen, $aResult[$i][0], $coords[$j][0], $coords[$j][1])
					Next
				EndIf
			EndIf
		Next

		; Display the time take for the search
		_GDIPlus_GraphicsDrawString($hGraphic, "Time Taken:" & $aResult[0][2] & " " & $aResult[0][3], 350, 50, "Verdana", 20)

		; Save the image and release any memory
		_GDIPlus_ImageSaveToFile($editedImage, $dirTempDebug & $subDirectory & "\" & $fileName)
		_GDIPlus_PenDispose($hPen)
		_GDIPlus_GraphicsDispose($hGraphic)
	EndIf
EndFunc   ;==>captureDebugImage

Func returnPropertyValue($key, $property)
	; Get the property
	Local $aValue = DllCall($hImgLib, "str", "GetProperty", "str", $key, "str", $property)

	Return $aValue[0]
EndFunc   ;==>returnPropertyValue

Func updateResultsRow(ByRef $aResult, $redLines = "")
	; Create the local variable to do the counting
	Local $numberFound = 0

	If IsArray($aResult) Then
		; Loop through the results to get the total number of objects found
		If UBound($aResult) > 1 Then
			For $j = 1 To UBound($aResult) - 1
				$numberFound += Number($aResult[$j][4])
			Next
		EndIf

		; Store the redline data in case we need to do more searches
		$aResult[0][0] = $redLines
		$aResult[0][1] = $numberFound ; Store the total number found
	Else
		; Not an array, so we are not going to do anything, this should only happen if there is a problem
	EndIf
EndFunc   ;==>updateResultsRow

Func multiMatches($directory, $maxReturnPoints = 0, $fullCocAreas = $DCD, $redLines = "", $statFile = "", $minLevel = 0, $maxLevel = 1000)
	; Setup arrays, including default return values for $return
	Local $aResult[1][6] = [["", 0, 0, "Seconds", "", ""]], $aCoordArray[0][0], $aCoords, $aCoordsSplit, $aValue

	; Capture the screen for comparison
	_CaptureRegion2()

	Local $hTimer = TimerInit()

	; Perform the search
	$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", $fullCocAreas, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)

	; Get the redline data
	$aValue = DllCall($hImgLib, "str", "GetProperty", "str", "redline", "str", "")
	$redLines = $aValue[0]


	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

		; Redimension the result array to allow for the new entries
		ReDim $aResult[UBound($aKeys) + 1][6]

		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			; Get the property values
			$aResult[$i + 1][0] = returnPropertyValue($aKeys[$i], "filename")
			$aResult[$i + 1][1] = returnPropertyValue($aKeys[$i], "objectname")
			$aResult[$i + 1][2] = returnPropertyValue($aKeys[$i], "objectlevel")
			$aResult[$i + 1][3] = returnPropertyValue($aKeys[$i], "filllevel")
			$aResult[$i + 1][4] = returnPropertyValue($aKeys[$i], "totalobjects")

			; Get the coords property
			$aValue = returnPropertyValue($aKeys[$i], "objectpoints")
			$aCoords = StringSplit($aValue, "|", $STR_NOCOUNT)
			ReDim $aCoordArray[UBound($aCoords)][2]

			; Loop through the found coords
			For $j = 0 To UBound($aCoords) - 1
				; Split the coords into an array
				$aCoordsSplit = StringSplit($aCoords[$j], ",", $STR_NOCOUNT)
				If UBound($aCoordsSplit) = 2 Then
					; Store the coords into a two dimensional array
					$aCoordArray[$j][0] = $aCoordsSplit[0] ; X coord.
					$aCoordArray[$j][1] = $aCoordsSplit[1] ; Y coord.
				EndIf
			Next

			; Store the coords array as a sub-array
			$aResult[$i + 1][5] = $aCoordArray
		Next
	EndIf

	Local $timertemp = Round(TimerDiff($hTimer) / 1000, 2)
	$aResult[0][2] = $timertemp

	; Updated the results row of the array, no need to assign to a variable, because the array is passed ByRef,
	; so the function updates the array that is passed as a parameter.
	updateResultsRow($aResult, $redLines)
	updateMultiSearchStats($aResult, $statFile)

	Return $aResult
EndFunc   ;==>multiMatches

Func multiMatches2($directory, $maxReturnPoints = 0, $fullCocAreas = $DCD, $redLines = "", $statFile = "", $minLevel = 0, $maxLevel = 1000)
	; Setup arrays, including default return values for $return
	Local $aResult[1][6] = [["", 0, 0, "Seconds", "", ""]], $aCoordArray[0][0], $aCoords, $aCoordsSplit, $aValue

	; Capture the screen for comparison
	_CaptureRegion2()
	; Perform the search

	$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", $fullCocAreas, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)

	Local $strPositions = ""
	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)
		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			; Get the coords property
			$aValue = returnPropertyValue($aKeys[$i], "objectpoints")
			$strPositions &= $aValue & "|"
		Next
	EndIf

	If StringRight($strPositions, 1) = "|" Then $strPositions = StringLeft($strPositions, StringLen($strPositions) - 1)
	Return $strPositions
EndFunc   ;==>multiMatches2

Func multiMatchesPixelOnly($directory, $maxReturnPoints = 0, $fullCocAreas = $ECD, $redLines = "", $statFile = "", $minLevel = 0, $maxLevel = 1000, $x1 = 0, $y1 = 0, $x2 = $GAME_WIDTH, $y2 = $GAME_HEIGHT, $bCaptureNew = True, $xDiff = Default, $yDiff = Default, $forceReturnString = False, $saveSourceImg = False)
	; Setup arrays, including default return values for $return
	Local $Result = ""
	Local $res

	; Capture the screen for comparison
	If $bCaptureNew Then
		_CaptureRegion2($x1, $y1, $x2, $y2)
		; Perform the search
		$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", $fullCocAreas, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
		If $saveSourceImg = True Then _GDIPlus_ImageSaveToFile(_GDIPlus_BitmapCreateFromHBITMAP($hHBitmap2), @ScriptDir & "\multiMatchesPixelOnly.png")
	Else
		Local $hClone = CloneAreaToSearch($x1, $y1, $x2, $y2)
		$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hClone, "str", $directory, "str", $fullCocAreas, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
		If $saveSourceImg = True Then _GDIPlus_ImageSaveToFile(_GDIPlus_BitmapCreateFromHBITMAP($hClone), @ScriptDir & "\multiMatchesPixelOnly.png")
	EndIf
	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			$Result &= returnPropertyValue($aKeys[$i], "objectpoints") & "|"
		Next
	EndIf

	If StringRight($Result, 1) = "|" Then $Result = StringLeft($Result, (StringLen($Result) - 1))
	If ($xDiff <> Default) Or ($yDiff <> Default) Then
		If $xDiff = Default Then $xDiff = 0
		If $yDiff = Default Then $yDiff = 0

		Local $tmpSplitedPositions
		If StringInStr($Result, "|") > 0 Then
			$tmpSplitedPositions = StringSplit($Result, "|", 2)
		Else
			$tmpSplitedPositions = _StringEqualSplit($Result, StringLen($Result))
		EndIf
		Local $splitedPositions[UBound($tmpSplitedPositions)][2]
		For $j = 0 To (UBound($tmpSplitedPositions) - 1)
			$splitedPositions[$j][0] = StringSplit($tmpSplitedPositions[$j], ",", 2)[0]
			$splitedPositions[$j][1] = StringSplit($tmpSplitedPositions[$j], ",", 2)[1]
		Next
		DelPosWithDiff($splitedPositions, $xDiff, $yDiff)
		If $forceReturnString = True Then
			$Result = ""
			For $k = 0 To (UBound($splitedPositions) - 1)
				$Result &= $splitedPositions[$k][0] & "," & $splitedPositions[$k][1] & "|"
			Next
			If StringRight($Result, 1) = "|" Then $Result = StringLeft($Result, (StringLen($Result) - 1))
			Return $Result
		Else
			Return $splitedPositions
		EndIf
	EndIf
	Return $Result
EndFunc   ;==>multiMatchesPixelOnly

Func CloneAreaToSearch($x, $y, $x1, $y1)
	Local $hClone, $hImage, $iX, $iY, $hBMP
	$iX = $x1 - $x
	$iY = $y1 - $y
	If StringInStr($iX, "-") > 0 Or StringInStr($iY, "-") > 0 Or $iX = 0 Or $iY = 0 Then Return $hHBitmap2
	$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap2)
	$hClone = _GDIPlus_BitmapCloneArea($hImage, $x, $y, $iX, $iY)
	$hBMP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hClone)
	Return $hBMP
EndFunc   ;==>CloneAreaToSearch

; DelPosWithDiff Can be used to delete positions found by multiple images for ONE Object, $Arr Parameter should be 2D Array, [1][2]
Func DelPosWithDiff(ByRef $Arr, $xDiff, $yDiff, $And = True)
	Local $iStart = 0
	Local $iXDiff = 0, $iYDiff = 0
	Local $IndexesToDelete = ""
	For $i = $iStart To (UBound($Arr) - 1)
		For $j = $i + 1 To (UBound($Arr) - 1)
			$iXDiff = Number(Abs(Number(Number($Arr[$i][0]) - Number($Arr[$j][0]))))
			$iYDiff = Number(Abs(Number(Number($Arr[$i][1]) - Number($Arr[$j][1]))))
			If $And = True Then
				If ($iXDiff <= $xDiff) And ($iYDiff <= $yDiff) Then
					$IndexesToDelete &= $j & ","
					$i += 1
					ExitLoop
				EndIf
			Else
				If ($iXDiff <= $xDiff) Or ($iYDiff <= $yDiff) Then
					$IndexesToDelete &= $j & ","
					$i += 1
					ExitLoop
				EndIf
			EndIf
			$iXDiff = 0
			$iYDiff = 0
		Next

	Next
	If StringRight($IndexesToDelete, 1) = "," Then $IndexesToDelete = StringLeft($IndexesToDelete, (StringLen($IndexesToDelete) - 1))
	Local $tmpArr[UBound($Arr)][2]
	Local $splitedToDelete = StringSplit($IndexesToDelete, ",", 2)

	For $i = 0 To (UBound($Arr) - 1)
		If _ArraySearch($splitedToDelete, $i) > -1 Then ContinueLoop ; If The Array Index Should be Deleted
		$tmpArr[$i][0] = $Arr[$i][0]
		$tmpArr[$i][1] = $Arr[$i][1]
	Next
	_ArryRemoveBlanks($tmpArr)
	$Arr = $tmpArr
EndFunc   ;==>DelPosWithDiff

Func GetHighestImageSize($directory, $addX = 0, $addY = 0)
	Local $ToReturn[2] = [-1, -1]
	Local $imgList = _FileListToArray($directory, "*", 1, True)
	Local $hImage, $iX, $iY
	For $i = 1 To (UBound($imgList) - 1)
		$hImage = _GDIPlus_BitmapCreateFromFile($imgList[$i])
		$iX &= _GDIPlus_ImageGetWidth($hImage) & "|"
		$iY &= _GDIPlus_ImageGetHeight($hImage) & "|"
		_GDIPlus_ImageDispose($hImage)
	Next
	If StringRight($iX, 1) = "|" Then $iX = StringLeft($iX, (StringLen($iX) - 1))
	If StringRight($iY, 1) = "|" Then $iY = StringLeft($iY, (StringLen($iY) - 1))
	$iX = StringSplit($iX, "|", 2)
	$iY = StringSplit($iY, "|", 2)
	$ToReturn[0] = Number(_ArrayMax($iX, 1)) + $addX
	$ToReturn[1] = Number(_ArrayMax($iY, 1)) + $addY
	Return $ToReturn
EndFunc   ;==>GetHighestImageSize

Func SearchWalls($directory, $minLevel = 0, $maxLevel = 11, $maxReturnPoints = 0, $fullCocAreas = $ECD, $redLines = $ECD, $statFile = "")
	Local $DebugIt = False
	; Setup arrays, including default return values for $return
	Local $aResult[1][4]
	Local $i
	; Capture the screen for comparison
	_CaptureRegion2()

	; Perform the search
	$res = DllCall($hImgLib, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", $fullCocAreas, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

		; Redimension the result array to allow for the new entries
		ReDim $aResult[UBound($aKeys) + 1][6]

		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			; Get the property values
			$aResult[$i][1] = returnPropertyValue($aKeys[$i], "objectlevel")
			$aResult[$i][2] = returnPropertyValue($aKeys[$i], "totalobjects")
			$aResult[$i][3] = returnPropertyValue($aKeys[$i], "filename")
			If $DebugIt = True Then
				SetLog("Found x" & $aResult[$i][2] & " Level #" & $aResult[$i][1] & " Walls By '" & $aResult[$i][3] & "' Image")
			EndIf

			; Get the coords property
			$aValue = returnPropertyValue($aKeys[$i], "objectpoints")
			$aValue = StringReplace($aValue, ",", "-")

			$aResult[$i][0] = $aValue
		Next
	EndIf

	; Updated the results row of the array, no need to assign to a variable, because the array is passed ByRef,
	; so the function updates the array that is passed as a parameter.
	updateMultiSearchStats($aResult, $statFile)
	If $i = 1 Then _ArrayDelete($aResult, 1)
	Return $aResult
EndFunc   ;==>SearchWalls

Func returnMultipleMatchesOwnVillage($directory, $maxReturnPoints = 0, $statFile = "", $minLevel = 0, $maxLevel = 1000)
	; This is simple, just do a multiMatch search, but pass "ECD" for the redlines and full coc area
	; so whole village is checked because obstacles can appear on the outer grass area
	Local $aResult = multiMatches($directory, $maxReturnPoints, $ECD, $ECD, $statFile, $minLevel, $maxLevel)

	Return $aResult
EndFunc   ;==>returnMultipleMatchesOwnVillage

Func returnSingleMatchOwnVillage($directory, $statFile = "", $minLevel = 0, $maxLevel = 1000)
	; This is simple, just do a multiMatch search, with 1 return point but pass "ECD" for the redlines
	; and full coc area so whole village is checked because obstacles can appear on the outer grass area
	Local $aResult = multiMatches($directory, 1, $ECD, $ECD, $statFile, $minLevel, $maxLevel)

	Return $aResult
EndFunc   ;==>returnSingleMatchOwnVillage

Func returnAllMatches($directory, $redLines = "", $statFile = "", $minLevel = 0, $maxLevel = 1000)
	; This is simple, just do a multiMatches search with 0 for the Max return points parameter
	Local $aResult = multiMatches($directory, 0, $DCD, $redLines, $statFile, $minLevel, $maxLevel)

	Return $aResult
EndFunc   ;==>returnAllMatches

Func returnAllMatchesDefense($directory, $statFile = "", $minLevel = 0, $maxLevel = 1000)
	; This is simple, just do a multiMatches search with 0 for the Max return points parameter

	Local $aResult = multiMatches2($directory, 0, $DCD, $CurBaseRedLine, $statFile, $minLevel, $maxLevel)

	Return $aResult
EndFunc   ;==>returnAllMatchesDefense

Func returnHighestLevelSingleMatch($directory, $redLines = "", $statFile = "", $minLevel = 0, $maxLevel = 1000)
	; Setup default return coords of 0,0
	Local $defaultCoords[1][2] = [[0, 0]]
	; Setup arrays, including default return values for $return
	Local $return[7] = ["None", "None", 0, 0, 0, $defaultCoords, ""]

	; This is simple, just do a multiMatches search with 1 for the Max return points parameter
	Local $aResult = multiMatches($directory, 1, $ECD, $redLines, $statFile, $minLevel, $maxLevel)

	If UBound($aResult) > 1 Then
		; Now loop through the array to modify values, select the highest entry to return
		For $i = 1 To UBound($aResult) - 1
			; Check to see if its a higher level then currently stored
			If Number($aResult[$i][2]) > Number($return[2]) Then
				; Store the data because its higher
				$return[0] = $aResult[$i][0] ; Filename
				$return[1] = $aResult[$i][1] ; Type
				$return[2] = $aResult[$i][2] ; Level
				$return[3] = $aResult[$i][3] ; Fill Percent
				$return[4] = $aResult[$i][4] ; Total Objects
				$return[5] = $aResult[$i][5] ; Coords
			EndIf
		Next
	EndIf
	; Add the redline data if we want to make future searches faster
	$return[6] = $aResult[0][0] ; Redline Data

	Return $return
EndFunc   ;==>returnHighestLevelSingleMatch

Func returnLowestLevelSingleMatch($directory, $returnMax = 100, $redLines = "", $statFile = "", $minLevel = 0, $maxLevel = 1000)
	; Setup default return coords of 0,0
	Local $defaultCoords[1][2] = [[0, 0]]
	; Setup arrays, including default return values for $return
	Local $return[7] = ["None", "None", $returnMax + 1, 0, 0, $defaultCoords, ""]

	; This is simple, just do a multiMatches search with 1 for the Max return points parameter
	Local $aResult = multiMatches($directory, 1, $DCD, $redLines, $statFile, $minLevel, $maxLevel)

	If UBound($aResult) > 1 Then
		; Now loop through the array to modify values, select the lowest entry to return
		For $i = 1 To UBound($aResult) - 1
			; Check to see if its a lower level then currently stored
			If Number($aResult[$i][2]) < Number($return[2]) Then
				; Store the data because its lower
				$return[0] = $aResult[$i][0] ; Filename
				$return[1] = $aResult[$i][1] ; Type
				$return[2] = $aResult[$i][2] ; Level
				$return[3] = $aResult[$i][3] ; Fill Percent
				$return[4] = $aResult[$i][4] ; Total Objects
				$return[5] = $aResult[$i][5] ; Coords
			EndIf
		Next
	EndIf
	; Add the redline data if we want to make future searches faster
	$return[6] = $aResult[0][0] ; Redline Data

	Return $return
EndFunc   ;==>returnLowestLevelSingleMatch

Func returnMultipleMatches($directory, $maxReturnPoints = 0, $redLines = "", $statFile = "", $minLevel = 0, $maxLevel = 1000)
	; This is simple, just do a multiMatches search specifying the Max return points parameter
	Local $aResult = multiMatches($directory, $maxReturnPoints, $DCD, $redLines, $statFile, $minLevel, $maxLevel)

	Return $aResult
EndFunc   ;==>returnMultipleMatches

Func returnSingleMatch($directory, $redLines = "", $statFile = "", $minLevel = 0, $maxLevel = 1000)
	; This is simple, just do a multiMatches search with 1 for the Max return points parameter
	Local $aResult = multiMatches($directory, 1, $DCD, $redLines, $statFile, $minLevel, $maxLevel)

	Return $aResult
EndFunc   ;==>returnSingleMatch
