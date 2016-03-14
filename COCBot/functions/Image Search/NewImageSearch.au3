; #FUNCTION# ====================================================================================================================
; Name ..........: CheckTombs.au3
; Description ...: This file Includes function to perform defense farming.
; Syntax ........:
; Parameters ....: None
; Return values .: False if regular farming is needed to refill storage
; Author ........: Z0mbie
; Modified ......: ProMac (2016)
; Remarks .......: This file is part of ClashGameBot. Copyright 2015
;                  ClashGameBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TH DETCTION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Global $newTHADV[6][2]


Func checkTownhallNew()
	$newTHADV[0][0] = @ScriptDir & "\images\THNEW\6\1.bmp"
	$newTHADV[0][1] = @ScriptDir & "\images\THNEW\6\2.bmp"
	$newTHADV[1][0] = @ScriptDir & "\images\THNEW\7\1.bmp"
	$newTHADV[1][1] = @ScriptDir & "\images\THNEW\7\2.bmp"
	$newTHADV[2][0] = @ScriptDir & "\images\THNEW\8\1.bmp"
	$newTHADV[2][1] = @ScriptDir & "\images\THNEW\8\2.bmp"
	$newTHADV[3][0] = @ScriptDir & "\images\THNEW\9\1.bmp"
	$newTHADV[3][1] = @ScriptDir & "\images\THNEW\9\2.bmp"
	$newTHADV[4][0] = @ScriptDir & "\images\THNEW\10\1.bmp"
	$newTHADV[4][1] = @ScriptDir & "\images\THNEW\10\2.bmp"
	$newTHADV[5][0] = @ScriptDir & "\images\THNEW\11\1.bmp"
	$newTHADV[5][1] = @ScriptDir & "\images\THNEW\11\2.bmp"

	;SetLog("Verifying TH Location...", $COLOR_BLUE)
	Local $SimilarityTH[6] = [0.92, 0.92, 0.92, 0.92, 0.91, 0.92]

	Local $hTimer = TimerInit()


	For $t = 0 To 5 ; each level
		_CaptureRegion()
		For $i = 0 To 1 ; each picture
			If FileExists($newTHADV[$t][$i]) Then
				$res = ""
				$sendHBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap)
				$res = DllCall($LibDir & "\ImageSearch.dll", "str", "searchTile", "handle", $sendHBitmap, "str", $newTHADV[$t][$i], "float", $SimilarityTH[$t])
				_WinAPI_DeleteObject($sendHBitmap)

				If IsArray($res) Then
					If $res[0] = "0" Then
						$res = ""
					ElseIf $res[0] = "-1" Then
						SetLog("DLL Error", $COLOR_RED)
						Return
					ElseIf $res[0] = "-2" Then
						SetLog("Invalid Resolution", $COLOR_RED)
						Return
					Else
						$expRet = StringSplit($res[0], "|", 2)
						$THx = Int($expRet[1])
						$THy = Int($expRet[2])
						$THLocation = 1
						If isInsideDiamondXY($THx, $THy) Then
							Local $fDiff = Round((TimerDiff($hTimer) / 1000), 2)
							$ImageInfo = String("TH" & $THText[$t] & "-" & $i)
							If $debugsetlog = 1 Then SetLog("Found TH in " & $fDiff / 1000 & "s", $COLOR_RED)
							If $debugsetlog = 1 Then SetLog("Found TH Lv" & $THText[$t] & "[" & $i & "]", $COLOR_RED)
							If $debugsetlog = 1 Then SetLog("Found TH (" & $THx & "/" & $THy & ")", $COLOR_RED)
							If $debugImageSave = 1 Then CaptureTHwithInfo($THx, $THy, $ImageInfo)
							Return $THText[$t]
						EndIf
					EndIf
				Else
					;SetLog("DLL Error", $COLOR_RED)
					Return
				EndIf
			EndIf
		Next
	Next
	DebugImageSave("checkTownhallADV2_NoTHFound_", False)
	Return "-"
EndFunc   ;==>checkTownhallNew


