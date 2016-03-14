; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Milking
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Noyax37
; Modified ......: 
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include "..\functions\Attack\Attack Algorithms\algorithm_AllTroops_Milk.au3"
#include "..\functions\Image Search\CheckMilking.au3"
#include "..\functions\Search\VillageSearch_Milking.au3"

Global $chkMilkenabled
Global $countFindPixCloser = 0 ;Noyax count collector exposed
Global $countCollectorexposed = 0 ;Noyax count collector exposed	
Global $MilkAtt, $NbTrpMilk, $PercentExposed, $DBUseGobsForCollector, $NbPercentExposed, $NbPixelmaxExposed, $NbPixelmaxExposed2, $AttackAnyway, $ToAttackAnyway[16], $HysterGobs, $TempoTrain ;Noyax for milking
Global $retourdeguerre = 0 ; noyax
Global $HDVOutDB = 0 ;Noyax 
Global $icmbDetectTrapedTH, $ichkAirTrapTH, $ichkGroundTrapTH ;Noyax detect trapped TH
Global $TestLoots = False ;Noyax
Global $iOptAttIfDB = 1 ; Noyax attack when TH Snipe found DB
Global $iPercentThsn = 10 ; Noyax % loots to considere dead base in TH Snipe
Global $skipStartTime ;noyax add Ancient used to prevent infinate skips
Global $configMilk = $sProfilePath & "\" & $sCurrProfile & "\configMilk.ini"
Global $MilkAttackNearGoldMine, $MilkAttackNearElixirCollector, $MilkAttackNearDarkElixirDrill
;ZAP DE
Global $ichkSmartLightSpell
global $ichkTrainLightSpell
Global $iDrills[4][4] = [[-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1], [-1, -1, -1, -1]] ; [LocX, LocY, BldgLvl, Quantity=filled by other functions]
Global $smartZapGain = 0
Global $iSnipeSprint = 0
Global $iSnipeSprintCount = 0
Global $iSniperTroop = 0
Global $NumLTSpellsUsed = 0
Global $ichkDrillZapTH
Global $itxtMinDark
Global $txtMinDark
Global $iLTSpellCost, $LTSCost , $LTSpellCost

;telegram
Global $PushToken2 = ""
global $access_token2
Global $first = 0
global $chat_id2 = 0
Global $lastremote = 0
Global $pEnabled2

; CoCStats
Global $ichkCoCStats = 0
Global $stxtAPIKey = ""
Global $MyApiKey = ""

; TH Snipe
Global $PixelRedArea2[0]
Global $PixelRedAreaFurther2[0]
Global $TestLoots = False

Func milkingatt()
	If GUICtrlRead($chkDBAttMilk) = $GUI_CHECKED Then
		GUICtrlSetState($txtchkPixelmaxExposed, $GUI_ENABLE)
		GUICtrlSetState($txtchkPixelmaxExposed2, $GUI_ENABLE)
		GUICtrlSetState($txtDBUseGobsForCollector, $GUI_ENABLE)
		GUICtrlSetState($txtchkTempoTrain, $GUI_ENABLE)
		GUICtrlSetState($txtDBAttMilk, $GUI_ENABLE)
		GUICtrlSetState($txtchkHysterGobs, $GUI_ENABLE)
		GUICtrlSetState($chkMilkAttackNearGoldMine, $GUI_ENABLE)
		GUICtrlSetState($chkMilkAttackNearElixirCollector, $GUI_ENABLE)
		GUICtrlSetState($chkMilkAttackNearDarkElixirDrill, $GUI_ENABLE)
		$MilkAtt = 1
	Else
		GUICtrlSetState($txtchkPixelmaxExposed, $GUI_ENABLE)
		GUICtrlSetState($txtchkPixelmaxExposed2, $GUI_ENABLE)
		GUICtrlSetState($txtDBUseGobsForCollector, $GUI_DISABLE)
		GUICtrlSetState($txtchkHysterGobs, $GUI_DISABLE)
		GUICtrlSetState($txtchkTempoTrain, $GUI_DISABLE)
		GUICtrlSetState($txtDBAttMilk, $GUI_DISABLE)
		GUICtrlSetState($chkMilkAttackNearGoldMine, $GUI_DISABLE)
		GUICtrlSetState($chkMilkAttackNearElixirCollector, $GUI_DISABLE)
		GUICtrlSetState($chkMilkAttackNearDarkElixirDrill, $GUI_DISABLE)
		$MilkAtt = 0
	EndIf
EndFunc   ;==>milkingatt

Func saveparamMilk()

	$configMilk = $sProfilePath & "\" & $sCurrProfile & "\configMilk.ini"
	
	Local $hFile = -1
	If $ichkExtraAlphabets = 1 Then $hFile = FileOpen($configMilk, $FO_UTF16_LE + $FO_OVERWRITE)

	If GUICtrlRead($chkDBAttMilk) = $GUI_CHECKED Then
		IniWrite($configMilk, "Milking", "Milking", 1)
	Else
		IniWrite($configMilk, "Milking", "Milking", 0)
	EndIf
	IniWrite($configMilk, "Milking", "NbTrpMilk", GUICtrlRead($txtDBAttMilk))
	IniWrite($configMilk, "Milking", "HysterGobs", GUICtrlRead($txtchkHysterGobs))
	IniWrite($configMilk, "Milking", "TempoTrain", GUICtrlRead($txtchkTempoTrain))
	IniWrite($configMilk, "Milking", "NbPixelmaxExposed", GUICtrlRead($txtchkPixelmaxExposed))
	IniWrite($configMilk, "Milking", "NbPixelmaxExposed2", GUICtrlRead($txtchkPixelmaxExposed2))
	IniWrite($configMilk, "Milking", "DBUseGobsForCollector", GUICtrlRead($txtDBUseGobsForCollector))

	If GUICtrlRead($chkMilkAttackNearGoldMine) = $GUI_CHECKED Then
		IniWrite($configMilk, "Milking", "MilkAttackNearGoldMine", 1)
	Else
		IniWrite($configMilk, "Milking", "MilkAttackNearGoldMine", 0)
	EndIf

	If GUICtrlRead($chkMilkAttackNearElixirCollector) = $GUI_CHECKED Then
		IniWrite($configMilk, "Milking", "MilkAttackNearElixirCollector", 1)
	Else
		IniWrite($configMilk, "Milking", "MilkAttackNearElixirCollector", 0)
	EndIf

	If GUICtrlRead($chkMilkAttackNearDarkElixirDrill) = $GUI_CHECKED Then
		IniWrite($configMilk, "Milking", "MilkAttackNearDarkElixirDrill", 1)
	Else
		IniWrite($configMilk, "Milking", "MilkAttackNearDarkElixirDrill", 0)
	EndIf

;	IniWrite($configMilk, "advanced", "THsnPercent", GUICtrlRead($txtAttIfDB))

	If $hFile <> -1 Then FileClose($hFile)

	IniWrite($configMilk, "Telegram", "AccountToken2", GUICtrlRead($PushBTokenValue2)) ; noyax telegram

 	If GUICtrlRead($chkPBenabled2) = $GUI_CHECKED Then
		IniWrite($configMilk, "Telegram", "PBEnabled2", 1)
	Else
		IniWrite($configMilk, "Telegram", "PBEnabled2", 0)
	EndIf

; CoCStats
	If GUICtrlRead($chkCoCStats) = $GUI_CHECKED Then
		IniWrite($configMilk, "Stats", "chkCoCStats", "1")
	Else
		IniWrite($configMilk, "Stats", "chkCoCStats", "0")
	EndIf
	IniWrite($configMilk, "Stats", "txtAPIKey", GUICtrlRead($txtAPIKey))

;TH Snipe
	If GUICtrlRead($chkAttIfDB) = $GUI_CHECKED Then
		IniWrite($configMilk, "TH Snipe", "THsnAttIfDB", 1)
	Else
		IniWrite($configMilk, "TH Snipe", "THsnAttIfDB", 0)
	EndIf
	IniWrite($configMilk, "TH Snipe", "THsnPercent", GUICtrlRead($txtAttIfDB))

;train dark troops
;	IniWrite($configMilk, "troop", "troop5", _GUICtrlComboBox_GetCurSel($cmbBarrack5))
;	IniWrite($configMilk, "troop", "troop6", _GUICtrlComboBox_GetCurSel($cmbBarrack6))  
	
EndFunc

Func readconfigMilk()
	$configMilk = $sProfilePath & "\" & $sCurrProfile & "\configMilk.ini"
	If FileExists($configMilk) Then
		$MilkAtt = IniRead($configMilk, "Milking", "Milking", "0")
		$NbTrpMilk = IniRead($configMilk, "Milking", "NbTrpMilk", "90")
		$NbPixelmaxExposed = IniRead($configMilk, "Milking", "NbPixelmaxExposed", "1")
		$NbPixelmaxExposed2 = IniRead($configMilk, "Milking", "NbPixelmaxExposed2", "40")
		$DBUseGobsForCollector = IniRead($configMilk, "Milking", "DBUseGobsForCollector", "5")
		$HysterGobs = IniRead($configMilk, "Milking", "HysterGobs", "40")
		$TempoTrain = IniRead($configMilk, "Milking", "TempoTrain", "15")
		$MilkAttackNearGoldMine = IniRead($configMilk, "Milking", "MilkAttackNearGoldMine", "1")
		$MilkAttackNearElixirCollector = IniRead($configMilk, "Milking", "MilkAttackNearElixirCollector", "1")
		$MilkAttackNearDarkElixirDrill = IniRead($configMilk, "Milking", "MilkAttackNearDarkElixirDrill", "0")
	Else
		Return False
	EndIf

	$PushToken2 = IniRead($configMilk, "Telegram", "AccountToken2", "") ; noyax telegram
	$pEnabled2 = IniRead($configMilk, "Telegram", "PBEnabled2", "0") ; noyax telegram
; CoCStats
	$ichkCoCStats = IniRead($configMilk, "Stats", "chkCoCStats", "0")
	$stxtAPIKey = IniRead($configMilk, "Stats", "txtAPIKey", "")

;TH Snipe
	$iOptAttIfDB = IniRead($configMilk, "TH Snipe", "THsnAttIfDB", "1")
	$iPercentThsn = IniRead($configMilk, "TH Snipe", "THsnPercent", "10")

;train dark troops
;	ReDim $barrackTroop[Ubound($barrackTroop) + 2]
;	For $i = 4 To 5 ;Covers all 2 dark Barracks
;		$barrackTroop[$i] = IniRead($configMilk, "troop", "troop" & $i + 1, "0")
;	Next

	
EndFunc 

Func applyconfigMilk()
	GUICtrlSetData($txtDBAttMilk, $NbTrpMilk)
	If $MilkAtt = 1 Then
		GUICtrlSetState($chkDBAttMilk, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkDBAttMilk, $GUI_UNCHECKED)
	EndIf
	If $MilkAttackNearGoldMine = 1 Then
		GUICtrlSetState($chkMilkAttackNearGoldMine, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkMilkAttackNearGoldMine, $GUI_UNCHECKED)
	EndIf
	If $MilkAttackNearElixirCollector = 1 Then
		GUICtrlSetState($chkMilkAttackNearElixirCollector, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkMilkAttackNearElixirCollector, $GUI_UNCHECKED)
	EndIf
	If $MilkAttackNearDarkElixirDrill = 1 Then
		GUICtrlSetState($chkMilkAttackNearDarkElixirDrill, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkMilkAttackNearDarkElixirDrill, $GUI_UNCHECKED)
	EndIf
	GUICtrlSetData($txtchkPixelmaxExposed, $NbPixelmaxExposed)
	GUICtrlSetData($txtchkPixelmaxExposed2, $NbPixelmaxExposed2)
	GUICtrlSetData($txtDBUseGobsForCollector, $DBUseGobsForCollector)
	GUICtrlSetData($txtchkHysterGobs, $HysterGobs)
	GUICtrlSetData($txtchkTempoTrain, $TempoTrain)
	milkingatt()
	
	GUICtrlSetData($PushBTokenValue2, $PushToken2);noyax telegram

;noyax top telegram
	 If $pEnabled2 = 1 Then
		GUICtrlSetState($chkPBenabled2, $GUI_CHECKED)
		chkPBenabled2()
	ElseIf $pEnabled2 = 0 Then
		GUICtrlSetState($chkPBenabled2, $GUI_UNCHECKED)
		chkPBenabled2()
	EndIf
;noyax bottom telegram
	; CoCStats
	If $ichkCoCStats = 1 Then
		GUICtrlSetState($chkCoCStats, $GUI_CHECKED)
		GUICtrlSetState($txtAPIKey, $GUI_ENABLE)
	Else
		GUICtrlSetState($chkCoCStats, $GUI_UNCHECKED)
		GUICtrlSetState($txtAPIKey, $GUI_DISABLE)
	EndIf
	GUICtrlSetData($txtAPIKey, $stxtAPIKey)
	chkCoCStats()
	txtAPIKey()
	
;th snipe
	If $iOptAttIfDB = 1 Then
		GUICtrlSetState($chkAttIfDB, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkAttIfDB, $GUI_UNCHECKED)
	EndIf
	GUICtrlSetData($txtAttIfDB, $iPercentThsn)
	
;  _GUICtrlComboBox_SetCurSel($cmbBarrack5, $barrackTroop[4])
;  _GUICtrlComboBox_SetCurSel($cmbBarrack6, $barrackTroop[5])


EndFunc

;CocStats
Func txtAPIKey()
   $stxtAPIKey  = GUICtrlRead($txtAPIKey)
   IniWrite($configMilk, "Stats", "txtAPIKey", $stxtAPIKey)
   $MyApiKey = $stxtAPIKey
EndFunc ;==> txtAPIKey

Func chkCoCStats()
   If GUICtrlRead($chkCoCStats) = $GUI_CHECKED Then
	  $ichkCoCStats = 1
	  GUICtrlSetState($txtAPIKey, $GUI_ENABLE)
   Else
	  $ichkCoCStats = 0
	  GUICtrlSetState($txtAPIKey, $GUI_DISABLE)
EndIf
IniWrite($configMilk, "Stats", "chkCoCStats",$ichkCoCStats)
EndFunc ;==> chkCoCStats



; #FUNCTION# ====================================================================================================================
; Name ..........: TestLoots
; Description ...: test loot when Th fall
; Syntax ........: 
; Parameters ....: 
; Return values .: 
; Author ........: Noyax37 
; Modified ......:
; Remarks .......: This file is part of MyBot Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Example .......: 
; ===============================================================================================================================
Func TestLoots($Gold1 = 0, $Elixir1 = 0)

	Local $Gold2 = getGoldVillageSearch(48, 69)
	Local $Elixir2 = getElixirVillageSearch(48, 69 + 29)
	Local $Ggold = 0
	$Ggold = $Gold1 - $Gold2
	Local $Gelixir = 0
	$Gelixir = $Elixir1 - $Elixir2
	Setlog ("Gold loots = " & $Gold1 & " - " & $Gold2 & " = " & $Ggold)
	Setlog ("% Gold = 100 * " & $Ggold & " / " & $Gold1 & " = " & Round(100 * $Ggold / $Gold1, 1))
	Setlog ("Elixir loots = " & $Elixir1 & " - " & $Elixir2 & " = " & $Gelixir)
	Setlog ("% Elixir = 100 * " & $Gelixir & " / " & $Elixir1 & " = " & Round(100 * $Gelixir / $Elixir1, 1))
	If Round(100 * $Ggold / $Gold1, 1) < $iPercentThsn Or Round(100 * $Gelixir / $Elixir1, 1) < $iPercentThsn Then 
		Setlog ("Go to attack this dead base")
		If $zoomedin = True Then
			ZoomOut()
			$zoomedin = False
			$zCount = 0
			$sCount = 0
		EndIf
		$TestLoots = True
		$iMatchMode = $DB
		PrepareAttack($iMatchMode)
		If $Restart = True Then 
			$TestLoots = False
			$iMatchMode = $TS
			Return
		EndIf
		Attack()
		$TestLoots = False
		$iMatchMode = $TS
		Return
	EndIf
	
EndFunc
