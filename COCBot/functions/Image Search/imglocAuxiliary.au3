; #FUNCTION# ====================================================================================================================
; Name ..........: Imgloc Aux functions
; Description ...: auxyliary functions used by imgloc
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: Trlopes (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func decodeMultipleCoords($coords)
	;returns array of N coordinates [0=x, 1=y][0=x1, 1=y1]
	Local $retCoords[1] =[""]
	Local $p
	If $DebugSetlog = 1 Then SetLog("**decodeMultipleCoords: " & $coords, $COLOR_ORANGE)
	Local $aCoordsSplit = StringSplit($coords, "|", $STR_NOCOUNT)
	if StringInStr($aCoordsSplit[0], ",") = True then
		Redim $retCoords[ubound($aCoordsSplit)-1]
		$p=1
	else ;has total count in value
		Redim $retCoords[Number($aCoordsSplit[0])]
		$p=0
	endif

	For $p=0 to Ubound($retCoords)-1
		$retCoords[$p] = decodeSingleCoord($aCoordsSplit[$p+1])
	Next
	Return $retCoords
EndFunc   ;==>decodeMultipleCoords

Func decodeSingleCoord($coords)
	;returns array with 2 coordinates 0=x, 1=y
	Local $aCoordsSplit = StringSplit($coords, ",", $STR_NOCOUNT)
	Return $aCoordsSplit
EndFunc

Func returnImglocProperty($key, $property)
	; Get the property
	Local $aValue = DllCall($hImgLib2, "str", "GetProperty", "str", $key, "str", $property)
	if checkImglocError( $aValue , "returnImglocProperty") = true then
		return ""
	EndIf
	Return $aValue[0]
EndFunc   ;==>returnImglocProperty

Func checkImglocError( $imglocvalue , $funcName)
	;Return true if there is an error in imgloc return string
	If IsArray($imglocvalue) Then  ;despite beeing a string, AutoIt receives a array[0]
		If $imglocvalue[0] = "0" or $imglocvalue[0] = "" Then
			If $DebugSetlog = 1 Then SetLog($funcName & " imgloc search returned no results!", $COLOR_RED)
			Return True
		ElseIf StringLeft($imglocvalue[0],2) = "-1" Then  ;error
			If $DebugSetlog = 1 Then SetLog($funcName & " - Imgloc DLL Error: " + $imglocvalue[0], $COLOR_RED)
			Return True
		Else
			;If $DebugSetlog Then SetLog($funcName & " imgloc search performed with results!")
			Return False
		EndIF
	Else
		If $DebugSetlog = 1 Then SetLog($funcName & " - Imgloc  Error: Not an Array Result" , $COLOR_RED)
		Return True
	EndIF
EndFunc   ;==>checkImglocError

Func findButton($sButtonName, $buttonTileArrayOrPatternOrFullPath = Default, $maxReturnPoints = 1, $bForceCapture = True)

	If $buttonTileArrayOrPatternOrFullPath = Default Then $buttonTileArrayOrPatternOrFullPath = $sButtonName & "*"

	Local $error, $extError
	Local $searchArea = GetButtonDiamond($sButtonName)
	Local $aCoords = "" ; use AutoIt mixed varaible type and initialize array of coordinates to null
	Local $aButtons
	Local $sButtons = ""

	; check if file tile is a pattern
	If IsString($buttonTileArrayOrPatternOrFullPath) Then
		$sButtons = $buttonTileArrayOrPatternOrFullPath
		If StringInStr($buttonTileArrayOrPatternOrFullPath, "*") > 0 Then
			Local $aFiles = _FileListToArray(@ScriptDir & "\imgxml\imglocbuttons", $sButtons, $FLTA_FILES, True)
			If UBound($aFiles) < 2 Or $aFiles[0] < 1 Then
				Return SetError(1, 1, "No files in " & @ScriptDir & "\imgxml\imglocbuttons")  ; Set external error code = 1 for bad input values
			EndIf
			Local $a[0], $j
			$j = 0
			For $i = 1 To $aFiles[0]
				If StringRegExp($aFiles[$i], ".+[.](xml|png|bmp)$") Then
					$j += 1
					ReDim $a[$j]
					$a[$i - 1] = $aFiles[$i]
				EndIf
			Next
			$aButtons = $a
		Else
			Local $a[1] = [$sButtons]
			$aButtons = $a
		EndIf
	ElseIf IsArray($buttonTileArrayOrPatternOrFullPath) Then
		$aButtons = $buttonTileArrayOrPatternOrFullPath
		$sButtons = _ArrayToString($aButtons)
	Else
		Return SetError(1, 2, "Bad Input Values : " & $buttonTileArrayOrPatternOrFullPath)  ; Set external error code = 1 for bad input values
	EndIf

	; Check function parameters
	If Not IsString($sButtonName) Or UBound($aButtons) < 1 Then
		Return SetError(1, 3, "Bad Input Values : " & $sButtons)  ; Set external error code = 1 for bad input values
	EndIF

	For $buttonTile In $aButtons

		; Check function parameters
		If FileExists($buttonTile) = 0 Then
			Return SetError(1, 4, "Bad Input Values : Button Image NOT FOUND : " & $buttonTile)  ; Set external error code = 1 for bad input values
		EndIF

		; Capture the screen for comparison
		; _CaptureRegion2() or similar must be used before
		; Perform the search
		If $bForceCapture THEN _CaptureRegion2() ;to have FULL screen image to work with

		If $DebugSetlog Then SetLog(" imgloc searching for: " & $sButtonName  & " : " & $buttonTile)

		Local $result = DllCall($pImgLib2, "str", "FindTile", "handle", $hHBitmap2, "str", $buttonTile, "str", $searchArea, "Int", $maxReturnPoints)
		$error = @error  ; Store error values as they reset at next function call
		$extError = @extended
		If $error Then
			_logErrorDLLCall($pImgLib2, $error)
			SetDebugLog(" imgloc DLL Error imgloc " & $error & " --- "  & $extError)
			Return SetError(2, 1, $extError)  ; Set external error code = 2 for DLL error
		EndIF

		If $result[0] <> "" And checkImglocError($result, "imglocFindButton") = False Then
			If $DebugSetlog Then SetLog($sButtonName & " Button Image Found in: " & $result[0])
			$aCoords = StringSplit($result[0], "|", $STR_NOCOUNT)
			;[0] - total points found
			;[1] -  coordinates
			If $maxReturnPoints = 1 then
				Return StringSplit($aCoords[1], ",", $STR_NOCOUNT); return just X,Y coord
			Else
				; @TODO return 2 dimensional array
				Return $result[0] ; return full string with count and points
			EndIf
		EndIF

	Next

	SetDebugLog($sButtonName & " Button Image(s) NOT FOUND : " & $sButtons, $COLOR_ERROR)
	Return $aCoords
EndFunc   ;==>findButton

Func GetButtonDiamond($sButtonName )
	Local $btnDiamond = "FV"

	Switch $sButtonName
		Case "FindMatch" ;Find Match Screen
			$btnDiamond = "133,515|360,515|360,620|133,620"
		Case "CloseFindMatch" ;Find Match Screen
			$btnDiamond = "780,15|830,15|830,60|780,60"
		Case "CloseFindMatch"  ;Find Match Screen
			$btnDiamond = "780,15|830,15|830,60|780,60"
		Case "Attack" ;Main Window Screen
			$btnDiamond = "15,620|112,620|112,715|15,715"
		Case "OpenTrainWindow" ;Main Window Screen
			$btnDiamond = "15,560|65,560|65,610|15,610"
		Case "OK"
			$btnDiamond =  "440,395|587,395|587,460|440,460"
		Case "CANCEL"
			$btnDiamond =  "272,395|420,395|420,460|272,460"
		Case "ReturnHome"
			$btnDiamond =  "357,545|502,545|502,607|357,607"
		Case "Next" ; attackpage attackwindow
			$btnDiamond =  "697,542|850,542|850,610|697,610"
		Case "ObjectButtons", "BoostOne" ; Full size of object buttons at the bottom
			$btnDiamond =  GetDiamondFromRect("200,617(460,83)")
		Case "GEM" ; Boost window button (full button size)
			$btnDiamond =  GetDiamondFromRect("359,412(148,66)")
		Case "EnterShop"
			$btnDiamond =  GetDiamondFromRect("359,392(148,66)")
		Case "EndBattleSurrender" ;surrender - attackwindow
			$btnDiamond =  "12,577|125,577|125,615|12,615"
		Case "ExpandChat" ;mainwindow
			$btnDiamond =  "2,330|35,350|35,410|2,430"
		Case "CollapseChat" ;mainwindow
			$btnDiamond =  "315,334|350,350|350,410|315,430"
		Case "ChatOpenRequestPage" ;mainwindow - chat open
			$btnDiamond =  "5,688|65,688|65,615|5,725"
		Case "Profile" ;mainwindow - only visible if chat closed
			$btnDiamond =  "172,15|205,15|205,48|172,48"
		Case "DonateWindow" ;mainwindow - only when donate window is visible
			$btnDiamond =  "310,0|360,0|360,732|310,732"
		Case "DonateButton" ;mainwindow - only when chat window is visible
			$btnDiamond =  "200,85|305,85|305,680|200,680"
		Case "UpDonation" ;mainwindow - only when chat window is visible
			$btnDiamond =  "282,85|306,85|306,130|282,130"
		Case "DownDonation" ;mainwindow - only when chat window is visible
			$btnDiamond =  "282,635|306,635|306,680|282,680"

		Case Else
			$btnDiamond = "FV" ; use full image to locate button
	EndSwitch
	Return $btnDiamond
EndFunc   ;==>GetButtonDiamond

Func findImage($sImageName, $sImageTile ,$sImageArea , $maxReturnPoints = 1, $bForceCapture = True )
	; same has findButton, but allow custom area instead of button area decoding
	; nice for dinamic locations
	Local $error, $extError
	Local $searchArea = $sImageArea
	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null

	; Check function parameters
	If  Not FileExists($sImageTile) Then
		SetError(1, "Bad Input Values", $aCoords)  ; Set external error code = 1 for bad input values
		Return
	EndIF

	; Capture the screen for comparison
	; _CaptureRegion2() or similar must be used before
	; Perform the search
	If $bForceCapture THEN _CaptureRegion2() ;to have FULL screen image to work with

	If $DebugSetlog Then SetLog("findImage Looking for : " & $sImageName  & " : " & $sImageTile & " on " & $sImageArea)

	Local $result = DllCall($pImgLib2, "str", "FindTile", "handle", $hHBitmap2, "str", $sImageTile, "str", $searchArea, "Int", $maxReturnPoints)
	$error = @error  ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($pImgLib2, $error)
		If $DebugSetlog Then SetLog(" imgloc DLL Error imgloc " & $error & " --- "  & $extError)
		SetError(2, $extError , $aCoords)  ; Set external error code = 2 for DLL error
		Return
	EndIF

	If checkImglocError( $result, "findImage" ) = True Then
		If $DebugSetlog = 1 Then SetLog("findImage Returned Error or No values : ", $COLOR_DEBUG)
		If $DebugSetlog = 1 And $DebugImageSave = 1 Then DebugImageSave("findImage_" & $sImageName, True)
		Return $aCoords
	EndIF

	If $result[0] <> "" Then  ;despite being a string, AutoIt receives a array[0]
			If $DebugSetlog Then SetLog("findImage : " & $sImageName & " Found in: " & $result[0])
			$aCoords = StringSplit($result[0], "|", $STR_NOCOUNT)
			;[0] - total points found
			;[1] -  coordinates
			If $maxReturnPoints = 1 then
				Return $aCoords[1]; return just X,Y coord
			Else
				Return $result[0] ; return full string with count and points
			Endif
	Else
		If $DebugSetlog = 1 Then SetLog("findImage : " & $sImageName & " NOT FOUND " & $sImageTile)
		If $DebugSetlog = 1 And $DebugImageSave = 1 Then DebugImageSave("findImage_" & $sImageName, True)
		Return $aCoords
	EndIF

EndFunc   ;==>findImage

Func GetDeployableNextTo($sPoints, $distance = 3)
	Local $result = DllCall($pImgLib2, "str", "GetDeployableNextTo", "str", $sPoints, "int", $distance)
	$error = @error  ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($pImgLib2, $error)
		If $DebugSetlog Then SetLog(" imgloc DLL Error imgloc " & $error & " --- "  & $extError)
		SetError(2, $extError , "")  ; Set external error code = 2 for DLL error
		Return ""
	EndIF

	If UBound($result) = 0 Then Return ""
	If $DebugSetlog = 1 Then SetLog("GetDeployableNextTo : " & $sPoints & ", dist. = " & $distance & " : " & $result[0], $COLOR_ORANGE)
	Return $result[0]
EndFunc   ;==>GetDeployableNextTo

Func GetOffsetRedline($sArea = "TL", $distance = 3)
	Local $result = DllCall($pImgLib2, "str", "GetOffSetRedline", "str", $sArea, "int", $distance)
	$error = @error  ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($pImgLib2, $error)
		If $DebugSetlog Then SetLog(" imgloc DLL Error imgloc " & $error & " --- "  & $extError)
		SetError(2, $extError , "")  ; Set external error code = 2 for DLL error
		Return ""
	EndIF

	If UBound($result) = 0 Then Return ""
	If $DebugSetlog = 1 Then SetLog("GetOffSetRedline : " & $sArea & ", dist. = " & $distance & " : " & $result[0], $COLOR_ORANGE)
	Return $result[0]
EndFunc   ;==>GetOffSetRedline

Func findMultiple($directory ,$sCocDiamond ,$redLines, $minLevel=0, $maxLevel=1000, $maxReturnPoints = 0, $returnProps="objectname,objectlevel,objectpoints", $bForceCapture = True )
	; same has findButton, but allow custom area instead of button area decoding
	; nice for dinamic locations
	If $DebugSetlog = 1 Then SetLog("******** findMultiple *** START ***", $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : directory : " & $directory, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : sCocDiamond : " & $sCocDiamond, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : redLines : " & $redLines, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : minLevel : " & $minLevel, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : maxLevel : " & $maxLevel, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : maxReturnPoints : " & $maxReturnPoints, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("findMultiple : returnProps : " & $returnProps, $COLOR_ORANGE)
	If $DebugSetlog = 1 Then SetLog("******** findMultiple *** START ***", $COLOR_ORANGE)

	Local $error, $extError

	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null
	Local $returnData = StringSplit($returnProps,",",$STR_NOCOUNT)
	Local $returnLine[Ubound($returnData)]
	Local $returnValues[0]


	; Capture the screen for comparison
	; Perform the search
	If $bForceCapture THEN _CaptureRegion2() ;to have FULL screen image to work with

	Local $result = DllCall($pImgLib2, "str", "SearchMultipleTilesBetweenLevels", "handle", $hHBitmap2, "str", $directory, "str", $sCocDiamond, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	$error = @error  ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($pImgLib2, $error)
		If $DebugSetlog = 1 Then SetLog(" imgloc DLL Error : " & $error & " --- "  & $extError)
		SetError(2, $extError , $aCoords)  ; Set external error code = 2 for DLL error
		Return ""
	EndIF

	;If $DebugSetlog = 1 Then SetLog(" imglocFindMultiple " &  $result[0])
	If checkImglocError( $result, "findMultiple" ) = True Then
		If $DebugSetlog = 1 Then SetLog("findMultiple Returned Error or No values : ", $COLOR_DEBUG)
		If $DebugSetlog = 1 Then SetLog("******** findMultiple *** END ***", $COLOR_ORANGE)
		Return ""
	else
		If $DebugSetlog = 1 Then SetLog("findMultiple found : " & $result[0])
	EndIF

	If $result[0] <> "" Then  ;despite being a string, AutoIt receives a array[0]
			Local $resultArr = StringSplit($result[0],"|",$STR_NOCOUNT)
			Redim $returnValues[Ubound($resultArr)]
			For $rs=0 to ubound($resultArr)-1
				For $rD=0 to Ubound($returnData)-1 ; cycle props
					$returnLine[$rD] = returnImglocProperty($resultArr[$rs],$returnData[$rD])
					If $DebugSetlog = 1 Then SetLog("findMultiple : " & $resultArr[$rs] & "->" & $returnData[$rD] & " -> " & $returnLine[$rD] )
				Next
				$returnValues[$rs] = $returnLine
			Next

			;;lets check if we should get redlinedata
			If $redLines="" Then
				$IMGLOCREDLINE = returnImglocProperty("redline","")			;global var set in imglocTHSearch
				If $DebugSetlog = 1 Then SetLog("findMultiple : Redline argument is emty, seting global Redlines" )
			EndIf
			If $DebugSetlog = 1 Then SetLog("******** findMultiple *** END ***", $COLOR_ORANGE)
			return $returnValues

	Else
		If $DebugSetlog = 1 Then SetLog(" ***  findMultiple has no result **** ", $COLOR_ORANGE)
		If $DebugSetlog = 1 Then SetLog("******** findMultiple *** END ***", $COLOR_ORANGE)
		Return ""
	EndIF

EndFunc   ;==>findMultiple

Func GetDiamondFromRect($rect)
	;receives "StartX,StartY,EndX,EndY" or "StartX,StartY(Width,Height)"
	;returns "StartX,StartY|EndX,StartY|EndX,EndY|StartX,EndY"
	Local $returnvalue = "", $i
	If $DebugSetlog = 1 Then SetLog("GetDiamondFromRect : > " & $rect, $COLOR_INFO)
	Local $RectValues = StringSplit($rect,",",$STR_NOCOUNT)
	If UBound($RectValues) = 3 Then
		ReDim $RectValues[4]
		; check for width and height
		$i = StringInStr($RectValues[2], ")")
		If $i = 0 Then
			SetDebugLog("GetDiamondFromRect : Bad Input Values : " & $rect, $COLOR_ERROR)
			Return SetError(1, 1, $returnvalue)
		EndIf
		$RectValues[3] = $RectValues[1] + StringLeft($RectValues[2], $i - 1) - 1
		$i = StringInStr($RectValues[1], "(")
		If $i = 0 Then
			SetDebugLog("GetDiamondFromRect : Bad Input Values : " & $rect, $COLOR_ERROR)
			Return SetError(1, 2, $returnvalue)
		EndIf
		$RectValues[2] = $RectValues[0] + StringMid($RectValues[1], $i + 1) - 1
		$RectValues[1] = StringLeft($RectValues[1], $i - 1)
	EndIf
	If UBound($RectValues) < 4 Then
		SetDebugLog("GetDiamondFromRect : Bad Input Values : " & $rect, $COLOR_ERROR)
		Return SetError(1, 3, $returnvalue)
	EndIf
	Local $DiamdValues[4]
	Local $X=Number($RectValues[0])
	Local $Y=Number($RectValues[1])
	Local $Ex=Number($RectValues[2])
	Local $Ey=Number($RectValues[3])
	$DiamdValues[0] = $X & "," & $Y
	$DiamdValues[1]	= $Ex & "," & $Y
	$DiamdValues[2]	= $Ex & "," & $Ey
	$DiamdValues[3] = $X & "," & $Ey
	$returnvalue = $DiamdValues[0] & "|" & $DiamdValues[1] & "|" & $DiamdValues[2] & "|" & $DiamdValues[3]
	If $DebugSetlog = 1 Then SetLog("GetDiamondFromRect : < " & $returnvalue, $COLOR_INFO)
	Return $returnvalue
EndFunc   ;==>GetDiamondFromRect

Func FindImageInPlace($sImageName, $sImageTile,$place)
	;creates a reduced capture of the place area a finds the image in that area
	;returns string with X,Y of ACTUALL FULL SCREEN coordinates or Empty if not found
	If $DebugSetlog = 1 Then SetLog("FindImageInPlace : > " & $sImageName & " - " & $sImageTile & " - " & $place, $COLOR_INFO)
	Local $returnvalue = ""
	Local $aPlaces = StringSplit($place,",",$STR_NOCOUNT)
	_CaptureRegion2(Number($aPlaces[0]),Number($aPlaces[1]),Number($aPlaces[2]),Number($aPlaces[3]))
	Local $sImageArea = GetDiamondFromRect($place)
	Local $coords =  findImage($sImageName, $sImageTile ,"FV" , 1, False ); reduce capture full image
	If $coords = "" Then
		If $DebugSetlog = 1 Then SetLog("FindImageInPlace : " & $sImageName & " NOT Found", $COLOR_INFO)
		Return ""
	EndIf
	Local $aCoords = DecodeSingleCoord($coords)
	$returnvalue = Number($aCoords[0]) + Number($aPlaces[0]) & "," & Number($aCoords[1]) + Number($aPlaces[1])
	If $DebugSetlog = 1 Then SetLog("FindImageInPlace : < " & $sImageName & " Found in " & $returnvalue , $COLOR_INFO)
	Return  $returnvalue
EndFunc   ;==>FindImageInPlace

Func decodeTroopEnum($tEnum)
Switch $tEnum
	Case $eBarb
 		Return "Barbarian"
	Case $eArch
 		Return "Archer"
	Case $eBall
 		Return "Balloon"
	Case $eDrag
 		Return "Dragon"
	Case $eGiant
 		Return "Giant"
	Case $eGobl
 		Return "Goblin"
	Case $eGole
 		Return "Golem"
	Case $eHeal
 		Return "Healer"
	Case $eHogs
 		Return "HogRider"
	Case $eKing
 		Return "King"
	Case $eLava
 		Return "LavaHound"
	Case $eMini
 		Return "Minion"
	Case $ePekk
 		Return "Pekka"
	Case $eQueen
 		Return "Queen"
	Case $eValk
 		Return "Valkyrie"
	Case $eWall
 		Return "WallBreaker"
	Case $eWarden
 		Return "Warden"
	Case $eWitc
 		Return "Witch"
	Case $eWiza
 		Return "Wizard"
	Case $eBabyD
 		Return "BabyDragon"
	Case $eMine
 		Return "Miner"
	Case $eBowl
 		Return "Bowler"
	Case $eESpell
 		Return "EarthquakeSpell"
	Case $eFSpell
 		Return "FreezeSpell"
	Case $eHaSpell
 		Return "HasteSpell"
	Case $eHSpell
 		Return "HealSpell"
	Case $eJSpell
 		Return "JumpSpell"
	Case $eLSpell
 		Return "LightningSpell"
	Case $ePSpell
 		Return "PoisonSpell"
	Case $eRSpell
 		Return "RageSpell"
	Case $eSkSpell
 		Return "SkeletonSpell" ;Missing
	Case $eCSpell
 		Return "CloneSpell" ;Missing
	Case $eCastle
 		Return "Castle"
 	EndSwitch

EndFunc   ;==>decodeTroopEnum


Func decodeTroopName($sName)

	Switch $sName
		Case "Barbarian"
			Return $eBarb
	 	Case "Archer"
			Return $eArch
	 	Case "Balloon"
			Return $eBall
	 	Case "Dragon"
			Return $eDrag
	 	Case "Giant"
			Return $eGiant
	 	Case "Goblin"
			Return $eGobl
	 	Case "Golem"
			Return $eGole
	 	Case "Healer"
			Return $eHeal
	 	Case "HogRider"
			Return $eHogs
	 	Case "King"
			Return $eKing
	 	Case "LavaHound"
			Return $eLava
	 	Case "Minion"
			Return $eMini
	 	Case "Pekka"
			Return $ePekk
	 	Case "Queen"
			Return $eQueen
	 	Case "Valkyrie"
			Return $eValk
	 	Case "WallBreaker"
			Return $eWall
	 	Case "Warden"
			Return $eWarden
	 	Case "Witch"
			Return $eWitc
	 	Case "Wizard"
			Return $eWiza
	 	Case "BabyDragon"
			Return $eBabyD
	 	Case "Miner"
			Return $eMine
	 	Case "Bowler"
			Return $eBowl
	 	Case "EarthquakeSpell"
			Return $eESpell
	 	Case "FreezeSpell"
			Return $eFSpell
	 	Case "HasteSpell"
			Return $eHaSpell
	 	Case "HealSpell"
			Return $eHSpell
	 	Case "JumpSpell"
			Return $eJSpell
	 	Case "LightningSpell"
			Return $eLSpell
	 	Case "PoisonSpell"
			Return $ePSpell
	 	Case "RageSpell"
			Return $eRSpell
	 	Case "SkeletonSpell" ;Missing
			Return $eSkSpell
	 	Case "CloneSpell" ;Missing
			Return $eCSpell
	 	Case "Castle"
			Return $eCastle

 	EndSwitch

EndFunc   ;==>decodeTroopName


Func GetDummyRectangle($sCoords,$ndistance)
	;creates a dummy rectangle to be used by Reduced Image Capture
	Local $aCoords = StringSplit($sCoords,",",$STR_NOCOUNT)
	return Number($aCoords[0])-$nDistance & "," & Number($aCoords[1])-$nDistance & "," & Number($aCoords[0])+$nDistance & "," & Number($aCoords[1])+$nDistance
EndFunc   ;==>GetDummyRectangle