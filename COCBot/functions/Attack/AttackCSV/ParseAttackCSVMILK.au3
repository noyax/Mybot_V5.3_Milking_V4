; #FUNCTION# ====================================================================================================================
; Name ..........: ParseAttackCSVMILK
; Description ...:
; Syntax ........: ParseAttackCSV()
; Parameters ....: $debug               - [optional]
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ParseAttackCSVMILK($value1 = "M", $value2 = 1, $value3 = 6, $value4 = "gobl", $value5 = 0, $value6 = 0, $value7 = 0)

;			Global $PixelMine[0]
			Local $PixelMineToAttack[0]
;			Global $PixelElixir[0]
			Local $PixelElixirToAttack[0]
;			Global $PixelDarkElixir[0]
			Local $PixelDarkElixirToAttack[0]
			Global $PixelNearCollector[0]
;			Local $NbPixelmaxExposed = 40 ; à changer avec la config
			local $troopMilk1, $troopMilk2, $tempo, $value13, $value14, $troopsmilk
;			$troopMilk = Eval("e" & $value4)
			Local $listInfoPixelDropTroop[0]
			
			If stringlen($value4) > 5 then
				$tempo = StringSplit($value4, "-")
				$value4 = StringStripWS(StringUpper($tempo[1]), 2)
				$value14 = StringStripWS(StringUpper($tempo[2]), 2)
				$troopMilk1 = Eval("e" & $value4)
				$troopMilk2 = Eval("e" & $value14)
				$troopsmilk = 2
				$tempo = StringSplit($value3, "-")
				$value3 = StringStripWS(StringUpper($tempo[1]), 2)
				$value13 = StringStripWS(StringUpper($tempo[2]), 2)
			Else
				$troopMilk1 = Eval("e" & $value4)
				$troopsmilk = 1
			EndIf
				
			If ($value1 = "M") Then
				SetLog("Get Location of Mines...")
				If (IsArray($PixelMine) And (UBound($PixelMine)>0) ) Then
					For $i = 0 To UBound($PixelMine) - 1
						Local $pixelTemp = $PixelMine[$i]
						Local $arrPixelsCloser = _FindPixelCloser($PixelRedArea, $pixelTemp, 1, False)
						Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
						If $tmpDist > 0 And $tmpDist < Number($NbPixelmaxExposed2) Then
;							_ArrayAdd($listInfoPixelDropTroop, $tmplistInfoPixelDropTroop)
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
			If ($value1 = "E") Then
				SetLog("Get Location of Elixir Collectors...")
				If (IsArray($PixelElixir) And (UBound($PixelElixir)>0) ) Then
					For $i = 0 To UBound($PixelElixir) - 1
						Local $pixelTemp = $PixelElixir[$i]
						Local $arrPixelsCloser = _FindPixelCloser($PixelRedArea, $pixelTemp, 1, False)
						Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
						If $tmpDist > 0 And $tmpDist < Number($NbPixelmaxExposed2) Then
;							_ArrayAdd($listInfoPixelDropTroop, $tmplistInfoPixelDropTroop)
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
				If (IsArray($PixelDarkElixir) And (UBound($PixelDarkElixir)>0) ) Then
					For $i = 0 To UBound($PixelDarkElixir) - 1
						Local $pixelTemp = $PixelDarkElixir[$i]
						Local $arrPixelsCloser = _FindPixelCloser($PixelRedArea, $pixelTemp, 1, False)
						Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
						If $tmpDist > 0 And $tmpDist < Number($NbPixelmaxExposed2) Then
;							_ArrayAdd($listInfoPixelDropTroop, $tmplistInfoPixelDropTroop)
							Local $tmpArrayOfPixel[1]
							$tmpArrayOfPixel[0] = $pixelTemp
							_ArrayAdd($PixelDarkElixirToAttack, $tmpArrayOfPixel)
						EndIf
					Next
					_ArrayAdd($PixelNearCollector, $PixelDarkElixirToAttack)
				EndIf
				SetLog("[" & UBound($PixelDarkElixir) & "] Dark Elixir Drill/s")
				$iNbrOfDetectedDrills[$iMatchMode] += UBound($PixelDarkElixir)
			EndIf
; +++++++++++++legion123 new code
			If ($value1 = "TH") and ($TestLoots = False) Then
				THSearch() ;thanks to @LKhjks
				SetLog("Get Location of TH...")
				Local $tmpArrayOfPixel[1]

						Local $pixelTemp =  StringSplit($thx & "-" & $thy, "-", 2)

						Local $arrPixelsCloser = _FindPixelCloser($PixelRedArea, $pixelTemp, 1, False)
						Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
						If $tmpDist > 0 And $tmpDist < Number($NbPixelmaxExposed2) Then
;							_ArrayAdd($listInfoPixelDropTroop, $tmplistInfoPixelDropTroop)
							$tmpArrayOfPixel[0] = $pixelTemp
							_ArrayAdd($PixelNearCollector, $tmpArrayOfPixel)
							SetLog("Attacking TH")
						 Else
							SetLog("Not attacking TH - no droping locations around")
							return
						EndIf
			EndIf
			 ; +++++++++++++end of new code
;			SetLog("Located  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
			UpdateStats()
		
		If UBound($PixelNearCollector) = 0 Then
				SetLog("Error, no pixel found near collectors")
				return
		EndIf
		
;		local $needGobsForColl = UBound($PixelNearCollector) * Number($value3)
;		local $troopMilk = Eval("$e" & $value4)
		
;		for $i = 0 to Ubound($PixelNearCollector)-1
;			If _Sleep($iDelayLaunchTroop21) Then Return
;			SelectDropTroop($troopMilk) ;Select Troop
;			If _Sleep($iDelayLaunchTroop23) Then Return
			SetLog("Dropping " & Number($value3) & "  of " & (Eval("e" & $value4)), $COLOR_GREEN)
;			If $HDVOutDB = 1 Then AttackTHGrid ($eGobl, 4, 1, 2000, 1) ; noyax attack hdv out in db
;			$HDVOutDB = 0
			Local $listEdgesPixelToDrop[0]
			Local $nbTroopsPerEdge = Number($value3)
;			If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
;#cs
			Local $maxElementNearCollector = UBound($PixelNearCollector) - 1
			Local $startIndex = 0
			Local $troopFurther = False
			If ($troopMilk1 = $eArch Or $troopMilk1 = $eWiza Or $troopMilk1 = $eMini or $troopMilk1 = $eBarb) Then
				$troopFurther = True
			EndIf
			Local $centerPixel[2] = [430, 338]
			For $i = $startIndex To $maxElementNearCollector
				$pixel = $PixelNearCollector[$i]
				ReDim $listInfoPixelDropTroop[UBound($listInfoPixelDropTroop) + 1]
				Local $arrPixelToSearch
				If ($pixel[0] < $centerPixel[0] And $pixel[1] < $centerPixel[1]) Then
					If ($troopFurther) Then
						$arrPixelToSearch = $PixelTopLeftFurther
					Else
						$arrPixelToSearch = $PixelTopLeft
					EndIf
				ElseIf ($pixel[0] < $centerPixel[0] And $pixel[1] > $centerPixel[1]) Then
					If ($troopFurther) Then
						$arrPixelToSearch = $PixelBottomLeftFurther
					Else
						$arrPixelToSearch = $PixelBottomLeft
					EndIf
				ElseIf ($pixel[0] > $centerPixel[0] And $pixel[1] > $centerPixel[1]) Then
					If ($troopFurther) Then
						$arrPixelToSearch = $PixelBottomRightFurther
					Else
						$arrPixelToSearch = $PixelBottomRight
					EndIf
				Else
					If ($troopFurther) Then
						$arrPixelToSearch = $PixelTopRightFurther
					Else
						$arrPixelToSearch = $PixelTopRight
					EndIf
				EndIf

				$listInfoPixelDropTroop[UBound($listInfoPixelDropTroop) - 1] = _FindPixelCloser($arrPixelToSearch, $pixel, 1)

			Next
;#ce
;			$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $infoDropTroop
;			setlog(" $troopMilk = " & $troopMilk)

			Local $troopMilk3 = -1
			Local $troopMilk4 = -1
			
			For $i = 0 To UBound($atkTroops) - 1
				If $atkTroops[$i][0] = $troopMilk1 Then
					$troopMilk3 = $i
				EndIf
				If $atkTroops[$i][0] = $troopMilk2 Then
					$troopMilk4 = $i
				EndIf
			Next
			
			If $troopMilk3 = -1 and $troopMilk4 = -1 then return
			
			If IsAttackPage() then
				for $i = 0 to ubound($listInfoPixelDropTroop) - 1
					debugRedArea("$listArrPixel $i : [" & $i & "] ")
					Local $arrPixel = $listInfoPixelDropTroop[$i]
					debugRedArea("$arrPixel $UBound($arrPixel) : [" & UBound($arrPixel) & "] ")
					If UBound($arrPixel) > 0 Then
						SelectDropTroop($troopMilk3)
						Local $pixel = $arrPixel[0]
; noyax decrease time				If IsAttackPage() Then Click($pixel[0], $pixel[1], $number, $iDelayDropOnPixel2, "#0096")
						Click($pixel[0], $pixel[1], Number($value3), 50, "#0096")
						if $troopsmilk = 2 then
							SelectDropTroop($troopMilk4)
							click($Pixel[0], $Pixel[1], Number($value13), 50, "#0096")
						EndIf
					EndIf
					If _Sleep($iDelayDropOnPixel1) Then Return
;				Local $arrPixel = $listInfoPixelDropTroop[$i]
;						click($arrPixel[0], $arrPixel[1], Number($value3), 50, "#1900")
				Next
			EndIf
;			SelectDropTroop($troopMilk2)
;			DropOnPixel($troopMilk2, $listInfoPixelDropTroop, Number($value3), 1)
;			OldDropTroop2($troopMilk, $PixelNearCollector, Number($value3))
;		Next

		Return

EndFunc ; ParseAttackCSVMILK
