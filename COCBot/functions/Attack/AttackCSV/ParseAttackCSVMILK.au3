; #FUNCTION# ====================================================================================================================
; Name ..........: ParseAttackCSVMILK
; Description ...:
; Syntax ........: ParseAttackCSV()
; Parameters ....: $debug               - [optional]
; Return values .: None
; Author ........: MereDoku (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ParseAttackCSVMILK($value1 = "M", $value2 = 1, $value3 = 6, $value4 = "gobl", $value5 = 0, $value6 = 0, $value7 = 0)


	Local $PixelMineToAttack[0]
	Local $PixelElixirToAttack[0]
	Local $PixelDarkElixirToAttack[0]
	Global $PixelNearCollector[0]

	Local $aTroopMilkName
	Local $aTroopMilkNumber
	Local $troopEnumValue

	#cs
		The array $aTroopMilkName will contain the following values:
		$aTroopMilkName[1] = "gobl"
		$aTroopMilkName[2] = "arch"
		$aTroopMilkName[3] = "mini"
		...
		$aTroopMilkName[7] = "barb"
	#ce
	$aTroopMilkName = StringSplit($value4, "-")

	;$aTroopMilkName[0] contains the number of strings returned
	;The array $aTroopMilkName will contain the position in the bottom bar of the troop to drop
	Local $aTroopMilkPosition[$aTroopMilkName[0]+1]
	$aTroopMilkPosition[0] = $aTroopMilkName[0]

	For $i = 1 To $aTroopMilkName[0] ; Loop through the array returned by StringSplit to display the individual values.

		;StringStripWS(StringUpper($aTroopMilkPosition[$i]), 2) => "Gobl"
		$aTroopMilkName[$i] = StringStripWS(_StringProper($aTroopMilkName[$i]), 2)

		;Eval("e" & $aTroopMilkName[$i]) => 3 (Enum Value)
		$troopEnumValue = Eval("e" & $aTroopMilkName[$i])

		For $j = 0 To UBound($atkTroops) - 1
			If $atkTroops[$j][0] = $troopEnumValue Then
				$aTroopMilkPosition[$i] = $j
			EndIf
		Next
	Next

	#cs
		The array $aTroopMilkNumber will contain the following values:
		$aTroopMilkNumber[1] = "20"
		$aTroopMilkNumber[2] = "24"
		$aTroopMilkNumber[3] = "18"
		...
		$aTroopMilkNumber[7] = "12"
		the number of each troop to drop
	#ce
	$aTroopMilkNumber = StringSplit($value3, "-")

	;$aTroopMilkNumber[0] contains the number of strings returned

	For $i = 1 To $aTroopMilkNumber[0] ; Loop through the array returned by StringSplit to display the individual values.
		;Number(StringStripWS($aTroopMilkNumber[$i], 2)) => 20
		$aTroopMilkNumber[$i] = Number(StringStripWS($aTroopMilkNumber[$i], 2))
	Next

	If ($value1 = "M") Then
		SetLog("Get Location of Mines...")
		If (IsArray($PixelMine) And (UBound($PixelMine) > 0)) Then
			For $i = 0 To UBound($PixelMine) - 1
				Local $pixelTemp = $PixelMine[$i]
				Local $arrPixelsCloser = _FindPixelCloser($PixelRedArea, $pixelTemp, 1, False)
				Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
				If $tmpDist > 0 And $tmpDist < Number($NbPixelmaxExposed2) Then
					Local $tmpArrayOfPixel[1]
					$tmpArrayOfPixel[0] = $pixelTemp
					_ArrayAdd($PixelMineToAttack, $tmpArrayOfPixel)
				EndIf
			Next
			_ArrayAdd($PixelNearCollector, $PixelMineToAttack)
		EndIf
		SetLog("[" & UBound($PixelMine) & "] Gold Mines")
		$iNbrOfDetectedMines[$iMatchMode] += UBound($PixelMine)
	EndIf

	; If drop troop near elixir collector
	If ($value1 = "E" And $searchElixir > 150000) Then
		SetLog("Get Location of Elixir Collectors...")
		If (IsArray($PixelElixir) And (UBound($PixelElixir) > 0)) Then
			For $i = 0 To UBound($PixelElixir) - 1
				Local $pixelTemp = $PixelElixir[$i]
				Local $arrPixelsCloser = _FindPixelCloser($PixelRedArea, $pixelTemp, 1, True)
				Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
				If $tmpDist > 0 And $tmpDist < 40 Then
					Local $tmpArrayOfPixel[1]
					$tmpArrayOfPixel[0] = $pixelTemp
					_ArrayAdd($PixelElixirToAttack, $tmpArrayOfPixel)
				EndIf
			Next
			_ArrayAdd($PixelNearCollector, $PixelElixirToAttack)
		EndIf
		SetLog("[" & UBound($PixelElixir) & "] Elixir Collectors")
		$iNbrOfDetectedCollectors[$iMatchMode] += UBound($PixelElixir)
	EndIf

	; If drop troop near dark elixir drill
	If ($value1 = "D") Then
		SetLog("Get Location of Dark Elixir Drills...")
		If (IsArray($PixelDarkElixir) And (UBound($PixelDarkElixir) > 0)) Then
			For $i = 0 To UBound($PixelDarkElixir) - 1
				Local $pixelTemp = $PixelDarkElixir[$i]
				Local $arrPixelsCloser = _FindPixelCloser($PixelRedArea, $pixelTemp, 1, True)
				Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
				SetLog("distance jusqu'au collector = " & $tmpDist)
				SetLog("$NbPixelmaxExposed2 = " & $NbPixelmaxExposed2)
				If $tmpDist > 0 And $tmpDist < Number($NbPixelmaxExposed2) Then
					Local $tmpArrayOfPixel[1]
					$tmpArrayOfPixel[0] = $pixelTemp
					_ArrayAdd($PixelDarkElixirToAttack, $tmpArrayOfPixel)
				EndIf
			Next
			_ArrayAdd($PixelNearCollector, $PixelDarkElixirToAttack)
		EndIf
		SetLog("[" & UBound($PixelDarkElixirToAttack) & "] Dark Elixir Drill/s")
		$iNbrOfDetectedDrills[$iMatchMode] += UBound($PixelDarkElixir)
	EndIf

	; +++++++++++++legion123 new code
	If ($value1 = "TH") Then
		SetLog("Get Location of TH...")
		Local $tmpArrayOfPixel[1]

		Local $pixelTemp = StringSplit($thx & "-" & $thy, "-", 2)

		Local $arrPixelsCloser = _FindPixelCloser($PixelRedArea, $pixelTemp, 1, True)
		Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
		If $tmpDist > 0 And $tmpDist < Number($NbPixelmaxExposed2) Then
			$tmpArrayOfPixel[0] = $pixelTemp
			_ArrayAdd($PixelNearCollector, $tmpArrayOfPixel)
			SetLog("Attacking TH")
		Else
			SetLog("Not attacking TH - no dropping locations around")
			Return
		EndIf
	EndIf
	; +++++++++++++end of new code
	;			SetLog("Located  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
	UpdateStats()

	If UBound($PixelNearCollector) = 0 Then
		SetLog("Error, no pixel found near collectors")
		Return
	EndIf

	Local $listEdgesPixelToDrop[0]
	Local $listInfoPixelDropTroop[0]
	Local $listInfoPixelDropTroopFurther[0]
	Local $listInfoPixelDropGiant1[0]
	Local $listInfoPixelDropGiant2[0]
	Local $nbTroopsPerEdge = Number($value3)
	Local $maxElementNearCollector = UBound($PixelNearCollector) - 1

	Local $centerPixel[2] = [430, 338]
	For $i = 0 To $maxElementNearCollector
		$pixel = $PixelNearCollector[$i]
		Local $pixelGiant1 = $PixelNearCollector[$i]
		Local $pixelGiant2 = $PixelNearCollector[$i]
		
		Local $arraySize = UBound($listInfoPixelDropTroop) + 1
		
		ReDim $listInfoPixelDropTroop[$arraySize]
		ReDim $listInfoPixelDropTroopFurther[$arraySize]
		ReDim $listInfoPixelDropGiant1[$arraySize]
		ReDim $listInfoPixelDropGiant2[$arraySize]

		Local $arrPixelToSearch
		Local $arrPixelToSearchFurther
		Local $arrPixelToSearchGiant1[0]
		Local $arrPixelToSearchGiant2[0]

		If ($pixel[0] < $centerPixel[0] And $pixel[1] < $centerPixel[1]) Then
			$arrPixelToSearch = $PixelTopLeft
			$arrPixelToSearchFurther = $PixelTopLeftFurther
			$pixelGiant1[0] = $pixel[0] + 50
			$pixelGiant2[1] = $pixel[1] + 50
		ElseIf ($pixel[0] < $centerPixel[0] And $pixel[1] > $centerPixel[1]) Then
			$arrPixelToSearch = $PixelBottomLeft
			$arrPixelToSearchFurther = $PixelBottomLeftFurther
			$pixelGiant1[0] = $pixel[0] + 50
			$pixelGiant2[1] = $pixel[1] - 50
		ElseIf ($pixel[0] > $centerPixel[0] And $pixel[1] > $centerPixel[1]) Then
			$arrPixelToSearch = $PixelBottomRight
			$arrPixelToSearchFurther = $PixelBottomRightFurther
			$pixelGiant1[0] = $pixel[0] - 50
			$pixelGiant2[1] = $pixel[1] - 50
		Else
			$arrPixelToSearch = $PixelTopRight
			$arrPixelToSearchFurther = $PixelTopRightFurther
			$pixelGiant1[0] = $pixel[0] - 50
			$pixelGiant2[1] = $pixel[1] + 50
		EndIf

		
		Local $pixelCloser = _FindPixelCloser($arrPixelToSearch, $pixel, 1)
		Local $pixel = $pixelCloser[0]
		$listInfoPixelDropTroop[UBound($listInfoPixelDropTroop) - 1] = $pixelCloser
		
		$pixelCloser = _FindPixelCloser($arrPixelToSearchFurther, $pixel, 1)
		$pixel = $pixelCloser[0]	
		$listInfoPixelDropTroopFurther[UBound($listInfoPixelDropTroop) - 1] = $pixelCloser
		
		$pixelCloser = _FindPixelCloser($arrPixelToSearch, $pixelGiant1, 1)
		$pixel = $pixelCloser[0]
 		$listInfoPixelDropGiant1[UBound($listInfoPixelDropGiant1) - 1] = $pixelCloser
		
		$pixelCloser = _FindPixelCloser($arrPixelToSearch, $pixelGiant2, 1)
		$pixel = $pixelCloser[0]
 		$listInfoPixelDropGiant2[UBound($listInfoPixelDropGiant2) - 1] = $pixelCloser
	Next		

	If IsAttackPage() Then
		Local $arrPixel;
		Local $isListInfoPixelDropGiant1 = true
		For $i = 0 To UBound($listInfoPixelDropTroop) - 1
			debugRedArea("$listArrPixel $i : [" & $i & "] ")
			For $j = 1 To $aTroopMilkName[0]
				If ($aTroopMilkName[$j] = "Giant") Then
					SelectDropTroop($aTroopMilkPosition[$j])
					For $k = 1 To $aTroopMilkNumber[$j]
						If $isListInfoPixelDropGiant1 = true Then
							$arrPixel = $listInfoPixelDropGiant1[$i]
						Else
							$arrPixel = $listInfoPixelDropGiant2[$i]
						EndIf
						$isListInfoPixelDropGiant1 = Not $isListInfoPixelDropGiant1
						If UBound($arrPixel) > 0 Then
							Local $pixel = $arrPixel[0]
							SetLog("Dropping 1 Giant at position (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_GREEN)
							click($pixel[0], $pixel[1], 1, 50, "#0096")
							If _Sleep($iDelayDropOnPixel1) Then Return
						Else
							SetLog("No Pixel found to drop Giant")
							$arrPixel = $listInfoPixelDropTroop[$i]
							If UBound($arrPixel) > 0 Then
								Local $pixel = $arrPixel[0]
								SetLog("Dropping 1 Giant at position (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_GREEN)
								click($pixel[0], $pixel[1], 1, 50, "#0096")
								If _Sleep($iDelayDropOnPixel1) Then Return
							EndIf
						EndIf

					Next
				Else
					If ($aTroopMilkName[$j] = "Arch" Or $aTroopMilkName[$j] = "Wiza" Or $aTroopMilkName[$j] = "Mini") Then
						$arrPixel = $listInfoPixelDropTroopFurther[$i]
					Else
						$arrPixel = $listInfoPixelDropTroop[$i]
					EndIf
					debugRedArea("$arrPixel $UBound($arrPixel) : [" & UBound($arrPixel) & "] ")
					If UBound($arrPixel) > 0 Then
						Local $pixel = $arrPixel[0]
						SetLog("Dropping " & $aTroopMilkNumber[$j] & "  of " & $aTroopMilkName[$j] & " at position (" & $pixel[0] & "," & $pixel[1] & ")", $COLOR_GREEN)
						SelectDropTroop($aTroopMilkPosition[$j])						
						click($pixel[0], $pixel[1], $aTroopMilkNumber[$j], 50, "#0096")
						If _Sleep($iDelayDropOnPixel1) Then Return
					EndIf
				EndIf
			Next
			If _Sleep($iDelayDropOnPixel1) Then Return

		Next
	EndIf


	Return

EndFunc   ;==>ParseAttackCSVMILK
