;
; #FUNCTION# ====================================================================================================================
; Name ..........: _FindPixelCloser
; Description ...: Search the closer array of pixel in the array of pixel
; Syntax ........: _FindPixelCloser($arrPixel, $pixel[, $nb = 1])
; Parameters ....: $arrPixel            - an array of unknowns.
;                  $pixel               - a pointer value.
;                  $nb                  - [optional] a general number value. Default is 1.
; Return values .: None
; Author ........: didipe
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _FindPixelCloser($arrPixel, $pixel, $nb = 1, $calcDist = False)

	If ((IsArray($arrPixel) = False) Or (UBound($arrPixel) <1)) Then Return ; Prevent error

	Local $arrPixelCloser[0]
	For $j = 0 To $nb
		Local $PixelCloser = $arrPixel[0]
		For $i = 0 To UBound($arrPixel) - 1
			$alreadyExist = False
			Local $arrTemp = $arrPixel[$i]
			Local $found = False
			;search closer only on y
			If ($pixel[0] = -1) Then
				If (Abs($arrTemp[1] - $pixel[1]) < Abs($PixelCloser[1] - $pixel[1])) Then
					$found = True
				EndIf
				;search closer only on x
			ElseIf ($pixel[1] = -1) Then
				If (Abs($arrTemp[0] - $pixel[0]) < Abs($PixelCloser[0] - $pixel[0])) Then
					$found = True
				EndIf
				;search closer on x/y
			Else
				;If ((Abs($arrTemp[0] - $pixel[0]) + Abs($arrTemp[1] - $pixel[1])) < (Abs($PixelCloser[0] - $pixel[0]) + Abs($PixelCloser[1] - $pixel[1]))) Then
				;	$found = True
				;EndIf
				If ((($arrTemp[0]-$pixel[0])^2 + ($arrTemp[1] - $pixel[1])^2) < (($PixelCloser[0]-$pixel[0])^2 + ($PixelCloser[1] - $pixel[1])^2)) Then
					$found = True
				EndIf
			EndIf
			If ($found) Then
				For $k = 0 To UBound($arrPixelCloser) - 1
					Local $arrTemp2 = $arrPixelCloser[$k]
					If ($arrTemp[0] = $arrTemp2[0] And $arrTemp[1] = $arrTemp2[1]) Then
						$alreadyExist = True
						ExitLoop
					EndIf
				Next
				If ($alreadyExist = False) Then
					$PixelCloser = $arrTemp
				EndIf
			EndIf
		Next
		ReDim $arrPixelCloser[UBound($arrPixelCloser) + 1]
		$arrPixelCloser[UBound($arrPixelCloser) - 1] = $PixelCloser

	Next
	If $calcDist And (UBound($arrPixelCloser) > 0) Then
		Local $tmpPixelCloser = $arrPixelCloser[0]
		If UBound($arrPixelCloser) > 1 Then
			For $m = 1 To UBound($arrPixelCloser) - 1
				Local $arrTemp3 = $arrPixelCloser[$m]
				If (($arrTemp3[0]-$pixel[0])^2 + ($arrTemp3[1] - $pixel[1])^2 < ($tmpPixelCloser[0]-$pixel[0])^2 + ($tmpPixelCloser[1] - $pixel[1])^2) Then
					$tmpPixelCloser = $arrTemp3
				EndIf
			Next
		EndIf
		
		Local $DistancePixeltoPixCLoser = Sqrt(($tmpPixelCloser[0]-$pixel[0])^2 + ($tmpPixelCloser[1] - $pixel[1])^2)
		SetLog("Distance = " & Int($DistancePixeltoPixCLoser) & "; Collector (" & $pixel[0] & "," & $pixel[1] & "); RedLine Pixel Closer (" & $tmpPixelCloser[0] & "," & $tmpPixelCloser[1] & ")", $COLOR_BLUE)
	EndIf

	Return $arrPixelCloser
EndFunc   ;==>_FindPixelCloser


Func _GetPixelCloserDistance($arrPixelCloser, $pixel)
	global $tmplistInfoPixelDropTroop[0]
	Local $DistancePixeltoPixCLoser = -1 
	If (UBound($arrPixelCloser) > 0) Then
		Local $tmpPixelCloser = $arrPixelCloser[0]
		If UBound($arrPixelCloser) > 1 Then
			For $m = 1 To UBound($arrPixelCloser) - 1
				Local $arrTemp3 = $arrPixelCloser[$m]
				If (($arrTemp3[0]-$pixel[0])^2 + ($arrTemp3[1] - $pixel[1])^2 < ($tmpPixelCloser[0]-$pixel[0])^2 + ($tmpPixelCloser[1] - $pixel[1])^2) Then
					$tmpPixelCloser = $arrTemp3
				EndIf
			Next
		EndIf
		
		$DistancePixeltoPixCLoser = Sqrt(($tmpPixelCloser[0]-$pixel[0])^2 + ($tmpPixelCloser[1] - $pixel[1])^2)
		SetLog("Distance = " & Int($DistancePixeltoPixCLoser) & "; Collector (" & $pixel[0] & "," & $pixel[1] & "); RedLine Pixel Closer (" & $tmpPixelCloser[0] & "," & $tmpPixelCloser[1] & ")", $COLOR_BLUE)
		_ArrayAdd($tmplistInfoPixelDropTroop, $tmpPixelCloser)
	EndIf
	Return $DistancePixeltoPixCLoser
EndFunc   ;==>_GetPixelCloserDistance

