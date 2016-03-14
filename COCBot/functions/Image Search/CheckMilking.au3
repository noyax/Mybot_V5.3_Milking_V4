; #FUNCTION# ====================================================================================================================
; Name ..........: CheckMilking.au3
; Description ...: This file Includes function to Milking.
; Syntax ........:
; Parameters ....: None
; Return values .: True if Fill collectors conditions is found
; Author ........: Noyax37
; Modified ......: 
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================


Global $newGoldADV[0]
Global $newElixADV[0]
Global $newDEADV[0]
Global $debugDeadBaseImage = 0
Global $DefaultCocSearchArea = "70|70|720|540"
Global $DefaultCocDiamond = "430,70|787,335|430,605|67,333"
Global $statChkMilk = $sProfilePath & "\" & $sCurrProfile & "\stats_chkMilk.INI"
Global $RedLineTile = @ScriptDir & "\images\RedLine\REDLINE.bmp"

Func CheckMilking()

	$debugDeadBaseImage = 1
	Global $PixelToLaunch[0]
	Local $hTimer = TimerInit()
	Local $useimages
	$useimages1 = "*.bmp"
	$useimages2 = "*.png"
;			Global $PixelMine[0]
			Local $PixelMineToAttack[0]
;			Global $PixelElixir[0]
			Local $PixelElixirToAttack[0]
;			Global $PixelDarkElixir[0]
			Local $PixelDarkElixirToAttack[0]

	
;	$newDEADV[0] = @ScriptDir & "\images\DBNEW\10.bmp"	    ;DBNEW_1;Image 0 is Lv 8 Full Fill  ------ 0.92
;	$newDEADV[1] = @ScriptDir & "\images\DBNEW\11.bmp"		;DBNEW_1;Image 1 is Lv 9 Full Fill  ------ 0.92
;	$newDEADV[2] = @ScriptDir & "\images\DBNEW\11_1.bmp"	;DBNEW_1;Image 2 is Lv 10 Full Fill ------ 0.94
;	$newDEADV[3] = @ScriptDir & "\images\DBNEW\12.bmp"		;DBNEW_1;Image 3 is Lv 11 Full Fill ------ 0.92
;	$newDEADV[4] = @ScriptDir & "\images\DBNEW\12_1.bmp"	;DBNEW_1;Image 4 is Lv 11 60% Fill  ------ 0.94
;	$newDEADV[5] = @ScriptDir & "\images\DBNEW\12_2.bmp"	;DBNEW_1;Image 5 is Lv 12 Full Fill ------ 0.92
	;$newDEADV[6] = @ScriptDir & "\images\DBNEW\12_b.bmp"	;DBNEW_1;Image 6 is Lv 12 60%  Fill ------ 0.94
	;$newDEADV[7] = @ScriptDir & "\images\DBNEW\12_b1.bmp"	;DBNEW_1

	$newGoldADV = _FileListToArray(@ScriptDir & "\images\Milking\Gold", "*.*")
           If @error = 1 Then
                MsgBox(0, "", "No Gold Folders Found.")
 ;               Exit
            EndIf
            If @error = 4 Then
                MsgBox(0, "", "No Gold Files Found.")
 ;               Exit
            EndIf
	$newElixADV = _FileListToArray(@ScriptDir & "\images\Milking\Elixir", "*.*")
           If @error = 1 Then
                MsgBox(0, "", "No Elixir Folders Found.")
 ;               Exit
            EndIf
            If @error = 4 Then
                MsgBox(0, "", "No Elixir Files Found.")
 ;               Exit
            EndIf
	$newDEADV = _FileListToArray(@ScriptDir & "\images\Milking\Dark", "*.*")
           If @error = 1 Then
                MsgBox(0, "", "No Dark Folders Found.")
 ;               Exit
            EndIf
            If @error = 4 Then
                MsgBox(0, "", "No Dark Files Found.")
 ;               Exit
            EndIf


	Local $ElixirLocationx
	Local $ElixirLocationy
	Local $GoldLocationx
	Local $GoldLocationy
	Local $DarkLocationx
	Local $DarkLocationy
	Local $ZombieFoundGold = 0
	Local $ZombieFoundEli = 0
	Local $ZombieFoundDark = 0
	Local $SimilarityMilk = 0.90 ; 1~0.99 is the equal image (lower number is more tolerance)
	Local $EditedImage
	Local $ImageInfo
	Local $ElixirLocation

	If $debugDeadBaseImage = 1 Then
		$EditedImage = $hBitmap
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($EditedImage)
		Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ;create a pencil Color FF0000/RED
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
	EndIf
	

		Global $PixelMine[0]
		Global $PixelElixir[0]
		Global $PixelDarkElixir[0]
		Global $PixelNearCollector[0]
		Local $PixelNearCollectortemp[0]

		SetLog("Locating Mines, Collectors or/and Drills", $COLOR_BLUE)
		$hTimer = TimerInit()

		_WinAPI_DeleteObject($hBitmapFirst)
		$hBitmapFirst = _CaptureRegion2()
		_CaptureRegion(0,0,$DEFAULT_WIDTH,$DEFAULT_HEIGHT,true)
		$sendHBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)

		
;		setlog("MilkAttackNearGoldMine " & $MilkAttackNearGoldMine)
;		setlog("MilkAttackNearElixirCollector " & $MilkAttackNearElixirCollector)

		Local $TilesToPixelsx = 24 +  8 + ( 16 * number($NbPixelmaxExposed) ) ; calcul = 24 pixels between center image x collector and corner + [8 + 16 (1 +0.5 pixels tiles)]
		Local $TilesToPixelsy = 18 +  6 + ( 12 * number($NbPixelmaxExposed) ) ; calcul = 18 pixels between center image y collector and corner + [6 + 12 (1 +0.5 pixels tiles)] * sqr(2) diagonal
		setlog ("$TilesToPixels = " & $TilesToPixelsx & " : " & $TilesToPixelsy)
		
		If $MilkAttackNearGoldMine = 1 Then
			; If drop troop near gold mine
			Local $TempPixelToLaunch[0]
			$PixelMine = GetLocationMine()
			If (IsArray($PixelMine)) Then
				For $i = 0 To UBound($PixelMine) - 1
					Local $pixelTemp = $PixelMine[$i]
					If isInsideDiamondXY($pixelTemp[0], $pixelTemp[1]) Then
						$pixelTemp[0] += 3 ; to re center the point
						$pixelTemp[1] += 6 ; to re center the point
						setlog("$pixelTemp = " & $pixelTemp[0] & " : " & $pixelTemp[1])
						Local $LineSearchDiamonds = $pixelTemp[0] & "," & string(number($pixelTemp[1]) -  $TilesToPixelsy) & "|" & string(number($pixelTemp[0]) - $TilesToPixelsx) & "," & $pixelTemp[1] & "|" & $pixelTemp[0] & "," & string(number($pixelTemp[1]) + $TilesToPixelsy) & "|" & string(number($pixelTemp[0]) + $TilesToPixelsx) & "," & $pixelTemp[1] ; test new dll
						setlog ("$LineSearchDiamonds = " & $LineSearchDiamonds)
						Local $res = DllCall($LibDir & "\ImgLoc.dll", "str", "SearchRedLines", "handle", $sendHBitmap, "str", $RedLineTile , "float", 0.94, "str" , $LineSearchDiamonds )
						If IsArray($res) Then
		;					setlog("$res[0] = " & $res[0])
							If $res[0] = "0" Then
								$res = ""
							ElseIf $res[0] = "-1" Then
								SetLog("DLL Error", $COLOR_RED)
							ElseIf $res[0] = "-2" Then
								SetLog("Invalid Resolution", $COLOR_RED)
							Else
								$arrPixelsCloser = StringSplit($res[0], "|", 2)
	;							If ubound($arrPixelsCloser) > 0 then
	;								setlog("$arrPixelsCloser = " & _ArrayDisplay($arrPixelsCloser))
									Local $tmpDist = _GetPixelCloserDistance2($arrPixelsCloser, $pixelTemp)
									If $tmpDist > 0 Then
				;							DropOnPixel($troopMilk, $arrPixelsCloser, Number($value3), 1)	
				;							OldDropTroop2($troopMilk, $arrPixelsCloser, Number($value3))
										Local $tmpArrayOfPixel[1]
										$tmpArrayOfPixel[0] = $pixelTemp
										_ArrayAdd($PixelMineToAttack, $tmpArrayOfPixel)
										_ArrayAdd($TempPixelToLaunch, $tmpPixelCloser2)
									EndIf
	;							EndIf
							EndIf
						EndIf
					EndIf
				Next
			EndIf
			SetLog("[" & UBound($PixelMineToAttack) & "] Gold Mines near red lines")

			For $i = 0 to ubound($PixelMineToAttack)-1
				Local $pixelTemp = $PixelMineToAttack[$i]
		;		setlog("$pixelTemp[0] $pixelTemp[1] " & $pixelTemp[0] & " " & $pixelTemp[1])
				Local $CocSearchArea = string($pixelTemp[0] - 20) & "|" & string($pixelTemp[1] - 30) & "|" & string($pixelTemp[0] + 20) & "|" & string($pixelTemp[1] + 20)
				Local $CocDiamond = string($pixelTemp[0]) & "," & string($pixelTemp[1] - 40) & "|" & string($pixelTemp[0]-40) & "," & string($pixelTemp[1]) & "|" &  string($pixelTemp[0]) & "," & string($pixelTemp[1] + 20) & "|" & string($pixelTemp[0] + 20) & "," & string($pixelTemp[1])
		;		setlog("$CocSearchArea = " & $CocSearchArea & "  $CocDiamond = " & $CocDiamond)
				For $t = 1 To $newGoldADV[0]
					If FileExists(@ScriptDir & "\images\Milking\Gold\" & $newGoldADV[$t]) Then
						$res = ""
						$res = DllCall($LibDir & "\imgloc.dll", "str", "SearchTile", "handle", $sendHBitmap, "str", @ScriptDir & "\images\Milking\Gold\" & $newGoldADV[$t], "float", $SimilarityMilk , "str", $CocSearchArea, "str", $CocDiamond)
		;				setlog("$res = " & $res)
						If IsArray($res) Then
		;					setlog("$res[0] = " & $res[0])
							If $res[0] = "0" Then
								$res = ""
							ElseIf $res[0] = "-1" Then
								SetLog("DLL Error", $COLOR_RED)
							ElseIf $res[0] = "-2" Then
								SetLog("Invalid Resolution", $COLOR_RED)
							Else
								$expRet = StringSplit($res[0], "|", 2)
								For $j = 1 To UBound($expRet) - 1 Step 2
									$ElixirLocationx = Int($expRet[$j])
									$ElixirLocationy = Int($expRet[$j + 1])
									If isInsideDiamondXY($ElixirLocationx, $ElixirLocationy) Then
										If $debugDeadBaseImage = 1 Then
											$ImageInfo = String("I_" & $t)
											_GDIPlus_GraphicsDrawRect($hGraphic, $ElixirLocationx - 5, $ElixirLocationy - 5, 10, 10, $hPen)
											_GDIPlus_GraphicsDrawString($hGraphic, $ImageInfo, $ElixirLocationx , $ElixirLocationy - 30, "Arial", 15)
										EndIf
										_ArrayAdd($PixelNearCollector, $expRet)
										_ArrayAdd($PixelToLaunch, $TempPixelToLaunch[$i])
										Local $batsav = $newGoldADV[$t]
										addstatmilk("Gold", $batsav)
										setlog("file = " & $newGoldADV[$t])
										$ZombieFoundGold += 1
										setlog("Mine Locationx, Mine Locationy = " & $ElixirLocationx & " : " & $ElixirLocationy)
;										setlog("Pixels to launch = " & _ArrayDisplay($TempPixelToLaunch[$i])
										If $ZombieFoundGold = 7 Then 
											ExitLoop (3)
										else
											ExitLoop (2)
										EndIf
									EndIf
								Next
							EndIf
						Else
							SetLog("$res is not array", $COLOR_RED)
						EndIf
					EndIf
				Next
			Next

	;		_WinAPI_DeleteObject($hBitmap)
			setlog ("Found " & $ZombieFoundGold & " collectors ready to attack in: " & Round((TimerDiff($hTimer) / 1000)) & " secondes")
			
			
		EndIf

		If $MilkAttackNearElixirCollector = 1 Then
			; If drop troop near elixir collector
			$PixelElixir = GetLocationElixir()
			If (IsArray($PixelElixir)) Then
				For $i = 0 To UBound($PixelElixir) - 1
					Local $pixelTemp = $PixelElixir[$i]
					$pixelTemp[0] += 0
					$pixelTemp[1] += 10
					Local $arrPixelsCloser = _FindPixelCloser($PixelRedArea, $pixelTemp, 1)
					Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
					If $tmpDist > 0 And $tmpDist < Number($NbPixelmaxExposed) Then
						Local $tmpArrayOfPixel[1]
						$tmpArrayOfPixel[0] = $pixelTemp
						_ArrayAdd($PixelElixirToAttack, $tmpArrayOfPixel)
					EndIf
				Next
			EndIf
			SetLog("[" & UBound($PixelElixirToAttack) & "] Elixir Collectors near red lines")
		EndIf
		If $MilkAttackNearDarkElixirDrill = 1 Then
			; If drop troop near dark elixir drill
			$PixelDarkElixir = GetLocationDarkElixir()
			If (IsArray($PixelDarkElixir)) Then
				For $i = 0 To UBound($PixelDarkElixir) - 1
					Local $pixelTemp = $PixelDarkElixir[$i]
					$pixelTemp[0] += 0
					$pixelTemp[1] += 4
					Local $arrPixelsCloser = _FindPixelCloser($PixelRedArea, $pixelTemp, 1)
					Local $tmpDist = _GetPixelCloserDistance($arrPixelsCloser, $pixelTemp)
					If $tmpDist > 0 And $tmpDist < Number($NbPixelmaxExposed) Then
						Local $tmpArrayOfPixel[1]
						$tmpArrayOfPixel[0] = $pixelTemp
						_ArrayAdd($PixelDarkElixirToAttack, $tmpArrayOfPixel)
					EndIf
				Next
			EndIf
			SetLog("[" & UBound($PixelDarkElixirToAttack) & "] Dark Elixir Collectors near red lines")
		EndIf

		SetLog("Located  (in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds) :")
		UpdateStats()
;		$ZombieFound = 0

;		_WinAPI_DeleteObject($hBitmap)
;		_CaptureRegion()
;		If $debugDeadBaseImage = 1 Then
;			DebugImageSave2("MilkingSearch_collector_", $hHBitmap)
;		EndIf



	If $MilkAttackNearElixirCollector = 1 Then
		For $i = 0 to ubound($PixelElixirToAttack)-1
			Local $pixelTemp = $PixelElixirToAttack[$i]
	;		setlog("$pixelTemp[0] $pixelTemp[1] " & $pixelTemp[0] & " " & $pixelTemp[1])
			Local $CocSearchArea = string($pixelTemp[0] - 20) & "|" & string($pixelTemp[1] - 20) & "|" & string($pixelTemp[0] + 20) & "|" & string($pixelTemp[1] + 20)
			Local $CocDiamond = string($pixelTemp[0]) & "," & string($pixelTemp[1] - 20) & "|" & string($pixelTemp[0]-20) & "," & string($pixelTemp[1]) & "|" &  string($pixelTemp[0]) & "," & string($pixelTemp[1] + 20) & "|" & string($pixelTemp[0] + 20) & "," & string($pixelTemp[1])
	;		setlog("$CocSearchArea = " & $CocSearchArea & "  $CocDiamond = " & $CocDiamond)
			For $t = 1 To $newElixADV[0]
				If FileExists(@ScriptDir & "\images\Milking\Elixir\" & $newElixADV[$t]) Then
					$res = ""
					$res = DllCall($LibDir & "\imgloc.dll", "str", "SearchTile", "handle", $sendHBitmap, "str", @ScriptDir & "\images\Milking\Elixir\" & $newElixADV[$t], "float", $SimilarityMilk , "str", $CocSearchArea, "str", $CocDiamond)
	;				setlog("$res = " & $res)
					If IsArray($res) Then
	;					setlog("$res[0] = " & $res[0])
						If $res[0] = "0" Then
							$res = ""
						ElseIf $res[0] = "-1" Then
							SetLog("DLL Error", $COLOR_RED)
						ElseIf $res[0] = "-2" Then
							SetLog("Invalid Resolution", $COLOR_RED)
						Else
							$expRet = StringSplit($res[0], "|", 2)
							For $j = 1 To UBound($expRet) - 1 Step 2
								$ElixirLocationx = Int($expRet[$j])
								$ElixirLocationy = Int($expRet[$j + 1])
								If isInsideDiamondXY($ElixirLocationx, $ElixirLocationy) Then
									If $debugDeadBaseImage = 1 Then
										$ImageInfo = String("I_" & $t)
										_GDIPlus_GraphicsDrawRect($hGraphic, $ElixirLocationx - 5, $ElixirLocationy - 5, 10, 10, $hPen)
										_GDIPlus_GraphicsDrawString($hGraphic, $ImageInfo, $ElixirLocationx , $ElixirLocationy - 30, "Arial", 15)
									EndIf
									_ArrayAdd($PixelNearCollector, $expRet)
									Local $batsav = $newElixADV[$t]
									addstatmilk("Elixir", $batsav)
									setlog("file = " & $newElixADV[$t])
									$ZombieFoundEli += 1
									setlog("$ElixirLocationx, $ElixirLocationy = " & $ElixirLocationx & " : " & $ElixirLocationy)
									If $ZombieFoundEli = 7 Then 
										ExitLoop (3)
									else
										ExitLoop (2)
									EndIf
								EndIf
							Next
						EndIf
					Else
						SetLog("$res is not array", $COLOR_RED)
					EndIf
				EndIf
			Next
		Next

	;		_WinAPI_DeleteObject($hBitmap)
			setlog ("Found " & $ZombieFoundEli & " collectors ready to attack in: " & Round((TimerDiff($hTimer) / 1000)) & " secondes")
	EndIF
		
	If $MilkAttackNearDarkElixirDrill = 1 Then
		For $i = 0 to ubound($PixelDarkElixirToAttack)-1
			Local $pixelTemp = $PixelDarkElixirToAttack[$i]
	;		setlog("$pixelTemp[0] $pixelTemp[1] " & $pixelTemp[0] & " " & $pixelTemp[1])
			Local $CocSearchArea = string($pixelTemp[0] - 20) & "|" & string($pixelTemp[1] - 20) & "|" & string($pixelTemp[0] + 20) & "|" & string($pixelTemp[1] + 20)
			Local $CocDiamond = string($pixelTemp[0]) & "," & string($pixelTemp[1] - 20) & "|" & string($pixelTemp[0]-20) & "," & string($pixelTemp[1]) & "|" &  string($pixelTemp[0]) & "," & string($pixelTemp[1] + 20) & "|" & string($pixelTemp[0] + 20) & "," & string($pixelTemp[1])
	;		setlog("$CocSearchArea = " & $CocSearchArea & "  $CocDiamond = " & $CocDiamond)
			For $t = 1 To $newDEADV[0]
				If FileExists(@ScriptDir & "\images\Milking\Dark\" & $newDEADV[$t]) Then
					$res = ""
					$res = DllCall($LibDir & "\imgloc.dll", "str", "SearchTile", "handle", $sendHBitmap, "str", @ScriptDir & "\images\Milking\Dark\" & $newDEADV[$t], "float", $SimilarityMilk , "str", $CocSearchArea, "str", $CocDiamond)
	;				setlog("$res = " & $res)
					If IsArray($res) Then
	;					setlog("$res[0] = " & $res[0])
						If $res[0] = "0" Then
							$res = ""
						ElseIf $res[0] = "-1" Then
							SetLog("DLL Error", $COLOR_RED)
						ElseIf $res[0] = "-2" Then
							SetLog("Invalid Resolution", $COLOR_RED)
						Else
							$expRet = StringSplit($res[0], "|", 2)
							For $j = 1 To UBound($expRet) - 1 Step 2
								$ElixirLocationx = Int($expRet[$j])
								$ElixirLocationy = Int($expRet[$j + 1])
								If isInsideDiamondXY($ElixirLocationx, $ElixirLocationy) Then
									If $debugDeadBaseImage = 1 Then
										$ImageInfo = String("I_" & $t)
										_GDIPlus_GraphicsDrawRect($hGraphic, $ElixirLocationx - 5, $ElixirLocationy - 5, 10, 10, $hPen)
										_GDIPlus_GraphicsDrawString($hGraphic, $ImageInfo, $ElixirLocationx , $ElixirLocationy - 30, "Arial", 15)
									EndIf
									_ArrayAdd($PixelNearCollector, $expRet)
									Local $batsav = $newDEADV[$t]
									addstatmilk("Dark", $batsav)
									setlog("file = " & $newDEADV[$t])
									$ZombieFoundDark += 1
									setlog("Dark Locationx, Dark Locationy = " & $ElixirLocationx & " : " & $ElixirLocationy)
									If $ZombieFoundDark = 3 Then 
										ExitLoop (3)
									else
										ExitLoop (2)
									EndIf
								EndIf
							Next
						EndIf
					Else
						SetLog("$res is not array", $COLOR_RED)
					EndIf
				EndIf
			Next
		Next

	;		_WinAPI_DeleteObject($hBitmap)
			setlog ("Found " & $ZombieFoundDark & " dark collectors ready to attack in: " & Round((TimerDiff($hTimer) / 1000)) & " secondes")
	EndIf
		
	If $ZombieFoundGold > 0 Or $ZombieFoundEli > 0 or $ZombieFoundDark > 0 Then
		If $debugDeadBaseImage = 1 Then
			DebugImageSave("MilkingSearch_BaseFound_", True)
			_GDIPlus_PenDispose($hPen)
			_GDIPlus_GraphicsDispose($hGraphic)
		EndIf
		$debugDeadBaseImage = 0
		Return False ;True
	Else
		If $debugDeadBaseImage = 1 Then
			DebugImageSave("MilkingSearch_NoBaseFound_", True)
			_GDIPlus_PenDispose($hPen)
			_GDIPlus_GraphicsDispose($hGraphic)
		EndIf
		$debugDeadBaseImage = 0
		Return False
	EndIf

EndFunc   ;==>ZombieSearch3

Func SaveStatChkMilk($tempfich)
	Local $hFile
	$hFile = FileOpen($statChkMilk, $FO_UTF16_LE + $FO_OVERWRITE)
	If FileExists($statChkMilk) Then
		IniWrite($statChkMilk, $tempfich)
	EndIf
	FileClose($hFile)

EndFunc   ;==>SaveStatChkMilk

Func DebugImageSave2($TxtName = "Unknown", $hBitmap = "")

	; Debug Code to save images before zapping for later review, time stamped to align with logfile!
	;SetLog("Taking snapshot for later review", $COLOR_GREEN) ;Debug purposes only :)
	$Date = @MDAY & "." & @MON & "." & @YEAR
	$Time = @HOUR & "." & @MIN & "." & @SEC
	local $tempfile = $dirTempDebug & $TxtName & $Date & " at " & $Time
	while FileExists($tempfile & ".png")
		$i += 1
		$tempfile = $tempfile & $i
	WEnd
	
	_GDIPlus_ImageSaveToFile($hBitmap, $tempfile & ".png")
	If $debugsetlog=1 Then Setlog( $tempfile & ".png", $COLOR_purple)
	If _Sleep($iDelayDebugImageSave1) Then Return

EndFunc   ;==>DebugImageSave2

Func addstatmilk($collbat = "Elixir", $batsav = "")
	Local $saveMilk = $sProfilePath & "\" & $sCurrProfile & "\SaveMilk.ini"
	
	Local $c = 0
	
	If FileExists($saveMilk) Then
		$c = IniRead($saveMilk, $collbat, $batsav, "0")
	EndIf
	
	$c += 1
	
	Local $hFile = -1
	If $ichkExtraAlphabets = 1 Then $hFile = FileOpen($saveMilk, $FO_UTF16_LE + $FO_OVERWRITE)
	IniWrite($saveMilk, $collbat, $batsav, $c)
	If $hFile <> -1 Then FileClose($hFile)

EndFunc  ;=>addstatmilk

Func _GetPixelCloserDistance2($arrPixelCloser, $pixel)
	Local $DistancePixeltoPixCLoser = -1 
	If (UBound($arrPixelCloser) > 0) Then
		Global $tmpPixelCloser2x = $arrPixelCloser[1]
		Global $tmpPixelCloser2y = $arrPixelCloser[1]
		
		If UBound($arrPixelCloser) > 1 Then
			For $m = 1 To UBound($arrPixelCloser) - 1 Step 2
				Local $arrTemp3x = $arrPixelCloser[$m]
				Local $arrTemp3y = $arrPixelCloser[$m + 1]
				If (($arrTemp3x-$pixel[0])^2 + ($arrTemp3y - $pixel[1])^2 < ($tmpPixelCloser2x-$pixel[0])^2 + ($tmpPixelCloser2y - $pixel[1])^2) Then
					$tmpPixelCloser2x = $arrTemp3x
					$tmpPixelCloser2y= $arrTemp3y
				EndIf
			Next
		EndIf
		
		$DistancePixeltoPixCLoser = Sqrt(($tmpPixelCloser2x-$pixel[0])^2 + ($tmpPixelCloser2y - $pixel[1])^2)
		SetLog("Distance = " & Int($DistancePixeltoPixCLoser) & "; Collector (" & $pixel[0] & "," & $pixel[1] & "); RedLine Pixel Closer (" & $tmpPixelCloser2x & "," & $tmpPixelCloser2y & ")", $COLOR_BLUE)


	If ($tmpPixelCloser2x-$pixel[0]) > 0 Then
			$tmpPixelCloser2x += 4
		Else
			$tmpPixelCloser2x -= 4
		EndIf
		If ($tmpPixelCloser2y-$pixel[1]) > 0 Then
			$tmpPixelCloser2y += 4
		Else
			$tmpPixelCloser2y -= 4
		EndIf
	Else
		return -1
	EndIf
	
	Global $tmpPixelCloser2[2]
	$tmpPixelCloser2[0] = $tmpPixelCloser2x
	$tmpPixelCloser2[1] = $tmpPixelCloser2y

	setlog("Launch point = " & $tmpPixelCloser2[0] & " : " & $tmpPixelCloser2[1])
	
	Return $DistancePixeltoPixCLoser
EndFunc   ;==>_GetPixelCloserDistance2

