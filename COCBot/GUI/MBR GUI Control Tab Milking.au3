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
Global $iTrophiesBottomLevel = 0, $iTrophiesPause = 15 ; ageofclash
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
Global $gbGoldElixirChangeEBO = True
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
Global $iMinGoldMilk, $iMinElixirMilk, $iMinGoldPlusElixirMilk, $iCmbMeetGEMilk, $lblTSMinGPEMilk; Minimum Resources conditions
Global $TrophyAoC = 0


; SmartZap Totals - Added by LunaEclipse
Global $iOldsmartZapGain = 0, $iOldNumLTSpellsUsed = 0

; SmartZap GUI variables - Added by LunaEclipse
Global $ichkSmartZap = 1
Global $ichkSmartZapDB = 1
Global $ichkSmartZapSaveHeroes = 1
Global $itxtMinDE = 250

; SmartZap stats - Added by LunaEclipse
Global $smartZapGain = 0
Global $numLSpellsUsed = 0

; SmartZap Array to hold Total Amount of DE available from Drill at each level (1-6) - Added by LunaEclipse
Global Const $drillLevelHold[6] = [120, _
								   225, _
								   405, _
								   630, _
								   960, _
								   1350]

; SmartZap Array to hold Amount of DE available to steal from Drills at each level (1-6) - Added by LunaEclipse
Global Const $drillLevelSteal[6] = [59, _
                                    102, _
								    172, _
								    251, _
								    343, _
								    479]

; Brew in advance
Global $iLightningSpellBrewInAdvance = 0, $iHealSpellBrewInAdvance = 0, $iRageSpellBrewInAdvance = 0, $iJumpSpellBrewInAdvance = 0, $iFreezeSpellBrewInAdvance = 0, $iPoisonSpellBrewInAdvance = 0, $iEarthSpellBrewInAdvance = 0, $iHasteSpellBrewInAdvance = 0

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

	; ageofclash -- start
	IniWrite($configMilk, "Milking", "TrophiesBottomLevel", GUICtrlRead($txtTrophiesBottomLevel))
	IniWrite($configMilk, "Milking", "TrophiesPause", GUICtrlRead($txtTrophiesPause))
	; ageofclash -- end 

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

	IniWrite($configMilk, "TH Snipe", "TSMeetGE", _GUICtrlComboBox_GetCurSel($cmbTSMeetGEMilk))
	IniWrite($configMilk, "TH Snipe", "TSsearchGold", GUICtrlRead($txtTSMinGoldMilk))
	IniWrite($configMilk, "TH Snipe", "TSsearchElixir", GUICtrlRead($txtTSMinElixirMilk))
	IniWrite($configMilk, "TH Snipe", "TSsearchGoldPlusElixir", GUICtrlRead($txtTSMinGoldPlusElixirMilk))

;train dark troops
;	IniWrite($configMilk, "troop", "troop5", _GUICtrlComboBox_GetCurSel($cmbBarrack5))
;	IniWrite($configMilk, "troop", "troop6", _GUICtrlComboBox_GetCurSel($cmbBarrack6))  

;brewspell in advance
	
	If GUICtrlRead($chkBrewInAdvanceLightningSpell) = $GUI_CHECKED Then
		IniWrite($configMilk, "Spells", "BrewInAdvanceLightningSpell", 1)
	Else
		IniWrite($configMilk, "Spells", "BrewInAdvanceLightningSpell", 0)
	EndIf	
	
	If GUICtrlRead($chkBrewInAdvanceHealSpell) = $GUI_CHECKED Then
		IniWrite($configMilk, "Spells", "BrewInAdvanceHealSpell", 1)
	Else
		IniWrite($configMilk, "Spells", "BrewInAdvanceHealSpell", 0)
	EndIf

	If GUICtrlRead($chkBrewInAdvanceRageSpell) = $GUI_CHECKED Then
		IniWrite($configMilk, "Spells", "BrewInAdvanceRageSpell", 1)
	Else
		IniWrite($configMilk, "Spells", "BrewInAdvanceRageSpell", 0)
	EndIf

	If GUICtrlRead($chkBrewInAdvanceJumpSpell) = $GUI_CHECKED Then
		IniWrite($configMilk, "Spells", "BrewInAdvanceJumpSpell", 1)
	Else
		IniWrite($configMilk, "Spells", "BrewInAdvanceJumpSpell", 0)
	EndIf	
	
	If GUICtrlRead($chkBrewInAdvanceFreezeSpell) = $GUI_CHECKED Then
		IniWrite($configMilk, "Spells", "BrewInAdvanceFreezeSpell", 1)
	Else
		IniWrite($configMilk, "Spells", "BrewInAdvanceFreezeSpell", 0)
	EndIf	

	If GUICtrlRead($chkBrewInAdvancePoisonSpell) = $GUI_CHECKED Then
		IniWrite($configMilk, "Spells", "BrewInAdvancePoisonSpell", 1)
	Else
		IniWrite($configMilk, "Spells", "BrewInAdvancePoisonSpell", 0)
	EndIf	
	
	If GUICtrlRead($chkBrewInAdvanceEarthSpell) = $GUI_CHECKED Then
		IniWrite($configMilk, "Spells", "BrewInAdvanceEarthSpell", 1)
	Else
		IniWrite($configMilk, "Spells", "BrewInAdvanceEarthSpell", 0)
	EndIf

	If GUICtrlRead($chkBrewInAdvanceHasteSpell) = $GUI_CHECKED Then
		IniWrite($configMilk, "Spells", "BrewInAdvanceHasteSpell", 1)
	Else
		IniWrite($configMilk, "Spells", "BrewInAdvanceHasteSpell", 0)
	EndIf		
	
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

; ageofclash - start
	    $iTrophiesBottomLevel = IniRead ($configMilk, "Milking", "TrophiesBottomLevel", "0")
	    $iTrophiesPause = IniRead ($configMilk, "Milking", "TrophiesPause", "15")
; ageofclash - end

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

	$iMinGoldMilk = IniRead($configMilk, "TH Snipe", "TSsearchGold", "80000")
	$iMinElixirMilk = IniRead($configMilk, "TH Snipe", "TSsearchElixir", "80000")
	$iMinGoldPlusElixirMilk = IniRead($configMilk, "TH Snipe", "TSsearchGoldPlusElixir", "160000")
	$iCmbMeetGEMilk = IniRead($configMilk, "TH Snipe", "TSMeetGE", "2")
;train dark troops
;	ReDim $barrackTroop[Ubound($barrackTroop) + 2]
;	For $i = 4 To 5 ;Covers all 2 dark Barracks
;		$barrackTroop[$i] = IniRead($configMilk, "troop", "troop" & $i + 1, "0")
;	Next

;brewspell in advance
	$iLightningSpellBrewInAdvance = Int(IniRead($configMilk, "Spells", "BrewInAdvanceLightningSpell", "0"))
	$iHealSpellBrewInAdvance = Int(IniRead($configMilk, "Spells", "BrewInAdvanceHealSpell", "0"))
	$iRageSpellBrewInAdvance = Int(IniRead($configMilk, "Spells", "BrewInAdvanceRageSpell", "0"))		
	$iJumpSpellBrewInAdvance = Int(IniRead($configMilk, "Spells", "BrewInAdvanceJumpSpell", "0"))	
	$iFreezeSpellBrewInAdvance = Int(IniRead($configMilk, "Spells", "BrewInAdvanceFreezeSpell", "0"))	
	$iPoisonSpellBrewInAdvance = Int(IniRead($configMilk, "Spells", "BrewInAdvancePoisonSpell", "0"))	 
	$iEarthSpellBrewInAdvance = Int(IniRead($configMilk, "Spells", "BrewInAdvanceEarthSpell", "0"))	 
	$iHasteSpellBrewInAdvance = Int(IniRead($configMilk, "Spells", "BrewInAdvanceHasteSpell", "0"))	

	
EndFunc 

Func applyconfigMilk()
; ageofclash - start
     GUICtrlSetData($txtTrophiesBottomLevel, $iTrophiesBottomLevel)
     GUICtrlSetData($txtTrophiesPause, $iTrophiesPause)
; ageofclash - end

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

	GUICtrlSetData($txtTSMinGoldMilk, $iMinGoldMilk)
	GUICtrlSetData($txtTSMinElixirMilk, $iMinElixirMilk)
	GUICtrlSetData($txtTSMinGoldPlusElixirMilk, $iMinGoldPlusElixirMilk)
	_GUICtrlComboBox_SetCurSel($cmbTSMeetGEMilk, $iCmbMeetGEMilk)
	cmbTSGoldElixirMilk()
	
;  _GUICtrlComboBox_SetCurSel($cmbBarrack5, $barrackTroop[4])
;  _GUICtrlComboBox_SetCurSel($cmbBarrack6, $barrackTroop[5])

; brew spell in advance
	If $iLightningSpellBrewInAdvance = 1 Then
		GUICtrlSetState($chkBrewInAdvanceLightningSpell, $GUI_CHECKED)
	ElseIf $iLastAttack = 0 Then
		GUICtrlSetState($chkBrewInAdvanceLightningSpell, $GUI_UNCHECKED)
	EndIf	
	
	If $iHealSpellBrewInAdvance = 1 Then
		GUICtrlSetState($chkBrewInAdvanceHealSpell, $GUI_CHECKED)
	ElseIf $iLastAttack = 0 Then
		GUICtrlSetState($chkBrewInAdvanceHealSpell, $GUI_UNCHECKED)
	EndIf
	
	If $iRageSpellBrewInAdvance = 1 Then
		GUICtrlSetState($chkBrewInAdvanceRageSpell, $GUI_CHECKED)
	ElseIf $iLastAttack = 0 Then
		GUICtrlSetState($chkBrewInAdvanceRageSpell, $GUI_UNCHECKED)
	EndIf	
	
	If $iJumpSpellBrewInAdvance = 1 Then
		GUICtrlSetState($chkBrewInAdvanceJumpSpell, $GUI_CHECKED)
	ElseIf $iLastAttack = 0 Then
		GUICtrlSetState($chkBrewInAdvanceJumpSpell, $GUI_UNCHECKED)
	EndIf

	If $iFreezeSpellBrewInAdvance = 1 Then
		GUICtrlSetState($chkBrewInAdvanceFreezeSpell, $GUI_CHECKED)
	ElseIf $iLastAttack = 0 Then
		GUICtrlSetState($chkBrewInAdvanceFreezeSpell, $GUI_UNCHECKED)
	EndIf	
	
	If $iPoisonSpellBrewInAdvance = 1 Then
		GUICtrlSetState($chkBrewInAdvancePoisonSpell, $GUI_CHECKED)
	ElseIf $iLastAttack = 0 Then
		GUICtrlSetState($chkBrewInAdvancePoisonSpell, $GUI_UNCHECKED)
	EndIf	

	If $iEarthSpellBrewInAdvance = 1 Then
		GUICtrlSetState($chkBrewInAdvanceEarthSpell, $GUI_CHECKED)
	ElseIf $iLastAttack = 0 Then
		GUICtrlSetState($chkBrewInAdvanceEarthSpell, $GUI_UNCHECKED)
	EndIf	

	If $iHasteSpellBrewInAdvance = 1 Then
		GUICtrlSetState($chkBrewInAdvanceHasteSpell, $GUI_CHECKED)
	ElseIf $iLastAttack = 0 Then
		GUICtrlSetState($chkBrewInAdvanceHasteSpell, $GUI_UNCHECKED)
	EndIf		


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

	Local $G = (Number($Gold1) >= Number($iMinGoldMilk))
	Local $E = (Number($Elixir1) >= Number($iMinElixirMilk))
	Local $GPE = ((Number($Elixir1) + Number($Gold1)) >= Number($iMinGoldPlusElixirMilk))

	If _GUICtrlComboBox_GetCurSel($cmbTSMeetGEMilk) = 0 then
		Local $ressMilk = $G and $E
	Else
		If _GUICtrlComboBox_GetCurSel($cmbTSMeetGEMilk) = 1 then
			Local $ressMilk = $G or $E
		Else
			Local $ressMilk = $GPE
		EndIF
	EndIf

	Setlog ("$ressMilk = " & $ressMilk)
	SetLog ("$iOptAttIfDB = " & $iOptAttIfDB)
	
	If (Round(100 * $Ggold / $Gold1, 1) < $iPercentThsn Or Round(100 * $Gelixir / $Elixir1, 1) < $iPercentThsn) and $iOptAttIfDB = 1 and  $ressMilk = True Then 
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

;TH Snipe
Func cmbTSGoldElixirMilk()
	If _GUICtrlComboBox_GetCurSel($cmbTSMeetGEMilk) < 2 Then
		GUICtrlSetState($txtTSMinGoldMilk, $GUI_SHOW)
		GUICtrlSetState($picTSMinGoldMilk, $GUI_SHOW)
		GUICtrlSetState($txtTSMinElixirMilk, $GUI_SHOW)
		GUICtrlSetState($picTSMinElixirMilk, $GUI_SHOW)
		GUICtrlSetState($txtTSMinGoldPlusElixirMilk, $GUI_HIDE)
		GUICtrlSetState($picTSMinGPEGoldMilk, $GUI_HIDE)
		GUICtrlSetState($lblTSMinGPEMilk, $GUI_HIDE)
		GUICtrlSetState($picTSMinGPEElixirMilk, $GUI_HIDE)
	Else
		GUICtrlSetState($txtTSMinGoldMilk, $GUI_HIDE)
		GUICtrlSetState($picTSMinGoldMilk, $GUI_HIDE)
		GUICtrlSetState($txtTSMinElixirMilk, $GUI_HIDE)
		GUICtrlSetState($picTSMinElixirMilk, $GUI_HIDE)
		GUICtrlSetState($txtTSMinGoldPlusElixirMilk, $GUI_SHOW)
		GUICtrlSetState($picTSMinGPEGoldMilk, $GUI_SHOW)
		GUICtrlSetState($lblTSMinGPEMilk, $GUI_SHOW)
		GUICtrlSetState($picTSMinGPEElixirMilk, $GUI_SHOW)
	EndIf
EndFunc   ;==>cmbTSGoldElixir

; Noyax by ageofclash -- start
Func ToggleTrophyPause()
   SetRedrawBotWindow(True)
   Local $BlockInputPausePrev
	$TPaused = NOT $TPaused
	If $TPaused and $Runstate = True Then
			$iTimePassed += Int(TimerDiff($sTimer))
			AdlibUnRegister("SetTime")
	ElseIf $TPaused = False And $Runstate = True Then
			$sTimer = TimerInit()
			AdlibRegister("SetTime", 1000)
		ZoomOut()
	EndIf
EndFunc
; Noyax by ageofclash -- end

; Brew_In_Advance made by @MereDoku
Func Brew_in_advance()
		If $numFactorySpellAvaiables = 1 And (($iLightningSpellComp > 0 And $iLightningSpellBrewInAdvance > 0) Or ($iHealSpellComp > 0 And $iHealSpellBrewInAdvance > 0) Or ($iRageSpellComp > 0 And $iRageSpellBrewInAdvance > 0) Or ($iJumpSpellComp > 0 And $iJumpSpellBrewInAdvance > 0) Or ($iFreezeSpellComp > 0 And $iFreezeSpellBrewInAdvance > 0)) Then
			$iBarrHere = 0
			While Not (isSpellFactory())
				If Not (IsTrainPage()) Then Return
				_TrainMoveBtn(+1) ;click Next button
				$iBarrHere += 1
				If _Sleep($iDelayTrain3) Then ExitLoop
				If $iBarrHere = 8 Then ExitLoop
			WEnd
			If isSpellFactory() Then
				If ($iLightningSpellComp > 0 And $iLightningSpellBrewInAdvance > 0) Then ; Lightning Spells
					Local $iTempLightningSpell = Number(getBarracksTroopQuantity(175 + 107 * 0, 296 + $midOffsetY))					
					Local $iLightningSpell = $iLightningSpellComp * 2 - ($CurLightningSpell + $iTempLightningSpell)
					If $debugSetlog = 1 Then SetLog("Making in advance Lightning Spell: " & $iLightningSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iLightningSpell > 0 Then
						If _ColorCheck(_GetPixelColor(239 + 107 * 0, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 0
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
							Return
						ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
							setlog("Spell Factory Full", $COLOR_RED)
							Return
						Else
							GemClick(220 + 107 * 0, 354 + $midOffsetY, $iLightningSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iLightningSpell & " Lightning Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				EndIf
				If ($iHealSpellComp > 0 And $iHealSpellBrewInAdvance > 0) Then ; Heal Spells
					Local $iTempHealSpell = Number(getBarracksTroopQuantity(175 + 107 * 1, 296 + $midOffsetY))
					Local $iHealSpell = $iHealSpellComp * 2 - ($CurHealSpell + $iTempHealSpell)
					If $debugSetlog = 1 Then SetLog("Making in advance Heal Spell: " & $iHealSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iHealSpell > 0 Then
						If _ColorCheck(_GetPixelColor(239 + 107 * 1, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
							Return
						ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
							setlog("Spell Factory Full", $COLOR_RED)
							Return
						Else
							GemClick(220 + 107 * 1, 354 + $midOffsetY, $iHealSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iHealSpell & " Heal Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				EndIf
				If ($iRageSpellComp > 0 And $iRageSpellBrewInAdvance > 0) Then ; Rage Spells
					Local $iTempRageSpell = Number(getBarracksTroopQuantity(175 + 107 * 2, 296 + $midOffsetY))
					Local $iRageSpell = $iRageSpellComp * 2 - ($CurRageSpell + $iTempRageSpell)
					If $debugSetlog = 1 Then SetLog("Making in advance Rage Spell: " & $iRageSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iRageSpell > 0 Then
						If _ColorCheck(_GetPixelColor(220 + 107 * 2, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
							Return
						ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
							setlog("Spell Factory Full", $COLOR_RED)
							Return
						Else
							GemClick(220 + 107 * 2, 354 + $midOffsetY, $iRageSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iRageSpell & " Rage Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				EndIf
				If ($iJumpSpellComp > 0 And $iJumpSpellBrewInAdvance > 0) Then ; Jump Spells
					Local $iTempJumpSpell = Number(getBarracksTroopQuantity(175 + 107 * 3, 296 + $midOffsetY))
					Local $iJumpSpell = $iJumpSpellComp * 2 - ($CurJumpSpell + $iTempJumpSpell)
					If $debugSetlog = 1 Then SetLog("Making in advance Jump Spell: " & $iJumpSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iJumpSpell > 0 Then
						If _ColorCheck(_GetPixelColor(239 + 107 * 3, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 0
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
							Return
						ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
							setlog("Spell Factory Full", $COLOR_RED)
							Return
						Else
							GemClick(220 + 107 * 3, 354 + $midOffsetY, $iJumpSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iJumpSpell & " Jump Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				EndIf
				If ($iFreezeSpellComp > 0 And $iFreezeSpellBrewInAdvance > 0) Then ; Freeze Spells
					Local $iTempFreezeSpell = Number(getBarracksTroopQuantity(175 + 107 * 4, 296 + $midOffsetY))
					Local $iFreezeSpell = $iFreezeSpellComp * 2 - ($CurFreezeSpell + $iTempFreezeSpell)
					If $debugSetlog = 1 Then SetLog("Making in advance Freeze Spell: " & $iFreezeSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iFreezeSpell > 0 Then
						If _ColorCheck(_GetPixelColor(239 + 107 * 4, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; White into number 0
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
							Return
						ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
							setlog("Spell Factory Full", $COLOR_RED)
							Return
						Else
							GemClick(220 + 107 * 4, 354 + $midOffsetY, $iFreezeSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iFreezeSpell & " Freeze Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf	

		If $numFactoryDarkSpellAvaiables = 1 And (($iPoisonSpellComp > 0  And $iPoisonSpellBrewInAdvance > 0) Or ($iEarthSpellComp > 0 And $iEarthSpellBrewInAdvance > 0) Or ($iHasteSpellComp > 0 And $iHasteSpellBrewInAdvance > 0)) Then
			$iBarrHere = 0
			While Not (isDarkSpellFactory())
				If Not (IsTrainPage()) Then Return
				_TrainMoveBtn(+1) ;click Next button
				$iBarrHere += 1
				If $iBarrHere = 8 Then ExitLoop
				If _Sleep($iDelayTrain3) Then Return
			WEnd
			If isDarkSpellFactory() Then
				If ($iPoisonSpellComp > 0  And $iPoisonSpellBrewInAdvance > 0) Then ; Poison Spells
					Local $iTempPoisonSpell = Number(getBarracksTroopQuantity(175 + 107 * 0, 296 + $midOffsetY))
					Local $iPoisonSpell = $iPoisonSpellComp * 2 - ($CurPoisonSpell + $iTempPoisonSpell)
					If $debugSetlog = 1 Then SetLog("Making in advance Poision Spell: " & $iPoisonSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iPoisonSpell > 0 Then
						If _sleep($iDelayTrain2) Then Return
						If _ColorCheck(_GetPixelColor(239, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
							Return
						ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
							setlog("Spell Factory Full", $COLOR_RED)
							Return
						Else
							GemClick(222, 354 + $midOffsetY, $iPoisonSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iPoisonSpell & " Poison Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				EndIf

				If ($iEarthSpellComp > 0 And $iEarthSpellBrewInAdvance > 0) Then ; EarthQuake Spells
					Local $iTempEarthSpell = Number(getBarracksTroopQuantity(175 + 107 * 1, 296 + $midOffsetY))
					Local $iEarthSpell = $iEarthSpellComp * 2 - ($CurEarthSpell + $iTempEarthSpell)
					If $debugSetlog = 1 Then SetLog("Making in advance EarthQuake Spell: " & $iEarthSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iEarthSpell > 0 Then
						If _sleep($iDelayTrain2) Then Return
						If _ColorCheck(_GetPixelColor(346, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; black pixel in number 5
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
							Return
						ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
							setlog("Spell Factory Full", $COLOR_RED)
							Return
						Else
							GemClick(329, 354 + $midOffsetY, $iEarthSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iEarthSpell & " EarthQuake Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				EndIf

				If ($iHasteSpellComp > 0 And $iHasteSpellBrewInAdvance > 0) Then ; Haste Spells
					Local $iTempHasteSpell = Number(getBarracksTroopQuantity(175 + 107 * 2, 296 + $midOffsetY))
					Local $iHasteSpell = $iHasteSpellComp * 2 - ($CurHasteSpell + $iTempHasteSpell)
					If $debugSetlog = 1 Then SetLog("Making in advance Haste Spell: " & $iHasteSpell)
					If _sleep($iDelayTrain2) Then Return
					If $iHasteSpell > 0 Then
						If _sleep($iDelayTrain2) Then Return
						If _ColorCheck(_GetPixelColor(453, 375 + $midOffsetY, True), Hex(0xFFFFFF, 6), 20) = False Then ; black pixel in number 5
							setlog("Not enough Elixir to create Spell", $COLOR_RED)
							Return
						ElseIf _ColorCheck(_GetPixelColor(200, 346 + $midOffsetY, True), Hex(0x414141, 6), 20) Then
							setlog("Spell Factory Full", $COLOR_RED)
							Return
						Else
							GemClick(430, 354 + $midOffsetY, $iHasteSpell, $iDelayTrain7, "#0290")
							SetLog("Created " & $iHasteSpell & " Haste Spell(s)", $COLOR_BLUE)
						EndIf
					EndIf
				EndIf
			Else
				SetLog("Dark Spell Factory not found...", $COLOR_BLUE)
			EndIf
		EndIf		
		
EndFunc ; brew_in_advance

; Get_Training_Time made by @MereDoku
; Return the training time of a specific troop in seconds
Func Get_Training_Time($eTroopType)
	Local $unitaryTrainingTimeInSeconds = 0
	
	Select
		case $eTroopType = $eBarb
			$unitaryTrainingTimeInSeconds = 20
		case $eTroopType = $eArch
			$unitaryTrainingTimeInSeconds = 25	
		case $eTroopType = $eGobl
			$unitaryTrainingTimeInSeconds = 30				
		case $eTroopType = $eGiant
			$unitaryTrainingTimeInSeconds = 2*60				
		case $eTroopType = $eWall
			$unitaryTrainingTimeInSeconds = 2*60	
		case $eTroopType = $eBall
			$unitaryTrainingTimeInSeconds = 8*60	
		case $eTroopType = $eWiza
			$unitaryTrainingTimeInSeconds = 8*60		
		case $eTroopType = $eHeal
			$unitaryTrainingTimeInSeconds = 15*60	
		case $eTroopType = $eDrag
			$unitaryTrainingTimeInSeconds = 30*60	
		case $eTroopType = $ePekk
			$unitaryTrainingTimeInSeconds = 45*60	
		case $eTroopType = $eMini
			$unitaryTrainingTimeInSeconds = 45	
		case $eTroopType = $eHogs
			$unitaryTrainingTimeInSeconds = 2*60	
		case $eTroopType = $eValk
			$unitaryTrainingTimeInSeconds = 8*60	
		case $eTroopType = $eGole
			$unitaryTrainingTimeInSeconds = 45*60		
		case $eTroopType = $eWitc
			$unitaryTrainingTimeInSeconds = 20*60	
		case $eTroopType = $eLava
			$unitaryTrainingTimeInSeconds = 45*60	
		case $eTroopType = $eLSpell
			$unitaryTrainingTimeInSeconds = 20*60	
		case $eTroopType = $eHSpell
			$unitaryTrainingTimeInSeconds = 20*60
		case $eTroopType = $eRSpell
			$unitaryTrainingTimeInSeconds = 20*60
		case $eTroopType = $eJSpell
			$unitaryTrainingTimeInSeconds = 20*60
		case $eTroopType = $eFSpell
			$unitaryTrainingTimeInSeconds = 20*60	
		case $eTroopType = $ePSpell
			$unitaryTrainingTimeInSeconds = 10*60	
		case $eTroopType = $eESpell
			$unitaryTrainingTimeInSeconds = 10*60	
		case $eTroopType = $eHaSpell
			$unitaryTrainingTimeInSeconds = 10*60				
	EndSelect	
	
	Return $unitaryTrainingTimeInSeconds
EndFunc ; Get_Training_Time

; Get_Housing_Space made by @MereDoku
; Return the housing space of a specific troop
Func Get_Housing_Space($eTroopType)
	Local $unitaryHousingSpace = 0
	
	Select
		case $eTroopType = $eBarb
			$unitaryHousingSpace = 1
		case $eTroopType = $eArch
			$unitaryHousingSpace = 1
		case $eTroopType = $eGobl
			$unitaryHousingSpace = 1			
		case $eTroopType = $eGiant
			$unitaryHousingSpace = 5					
		case $eTroopType = $eWall
			$unitaryHousingSpace = 2	
		case $eTroopType = $eBall
			$unitaryHousingSpace = 5	
		case $eTroopType = $eWiza
			$unitaryHousingSpace = 4		
		case $eTroopType = $eHeal
			$unitaryHousingSpace = 14	
		case $eTroopType = $eDrag
			$unitaryHousingSpace = 20	
		case $eTroopType = $ePekk
			$unitaryHousingSpace = 25	
		case $eTroopType = $eMini
			$unitaryHousingSpace = 2	
		case $eTroopType = $eHogs
			$unitaryHousingSpace = 5	
		case $eTroopType = $eValk
			$unitaryHousingSpace = 8	
		case $eTroopType = $eGole
			$unitaryHousingSpace = 30		
		case $eTroopType = $eWitc
			$unitaryHousingSpace = 12	
		case $eTroopType = $eLava
			$unitaryHousingSpace = 30	
		case $eTroopType = $eLSpell
			$unitaryHousingSpace = 2	
		case $eTroopType = $eHSpell
			$unitaryHousingSpace = 2
		case $eTroopType = $eRSpell
			$unitaryHousingSpace = 2
		case $eTroopType = $eJSpell
			$unitaryHousingSpace = 2
		case $eTroopType = $eFSpell
			$unitaryHousingSpace = 2	
		case $eTroopType = $ePSpell
			$unitaryHousingSpace = 1	
		case $eTroopType = $eESpell
			$unitaryHousingSpace = 1	
		case $eTroopType = $eHaSpell
			$unitaryHousingSpace = 1				
	EndSelect	
	
	Return $unitaryHousingSpace
EndFunc ; Get_Housing_Space


; Get_Time_To_Fill_Camps made by @MereDoku
; Notice : this is working only if you use barrack mode
; Return the time in seconds to fill the camps with a wanted housing space
Func Get_Time_To_Fill_Camps($currentunitaryHousingSpace, $wantedHouseSpace)
	Local $commonDenominator
	Local $totalHousingSpace
	Local $timeToFillCamps
	Local $unitaryTrainingTime1, $unitaryTrainingTime2, $unitaryTrainingTime3, $unitaryTrainingTime4, $unitaryTrainingTime5, $unitaryTrainingTime6 	
	Local $unitaryHousingSpace1, $unitaryHousingSpace2, $unitaryHousingSpace3, $unitaryHousingSpace4, $unitaryHousingSpace5, $unitaryHousingSpace6 
	Local $totalHousingSpace1, $totalHousingSpace2, $totalHousingSpace3, $totalHousingSpace4, $totalHousingSpace5, $totalHousingSpace6 	
	
	If $icmbTroopComp = 8 Then
		;We are in barrack mode
		
		;1st barrack
		$unitaryTrainingTime1 = Get_Training_Time($barrackTroop[0])
		$unitaryHousingSpace1 = Get_Housing_Space($barrackTroop[0])
		;2nd barrack
		$unitaryTrainingTime2 = Get_Training_Time($barrackTroop[1])
		$unitaryHousingSpace2 = Get_Housing_Space($barrackTroop[1])
		;3rd barrack
		$unitaryTrainingTime3 = Get_Training_Time($barrackTroop[2])
		$unitaryHousingSpace3 = Get_Housing_Space($barrackTroop[2])
		;4th barrack
		$unitaryTrainingTime4 = Get_Training_Time($barrackTroop[3])
		$unitaryHousingSpace4 = Get_Housing_Space($barrackTroop[3])
			
	Else
		;We are not in barrack mode
		;Calculation of the default time for milking = 4 barracks with goblins
		
		;1st barrack
		$unitaryTrainingTime1 = Get_Training_Time($eGobl)
		$unitaryHousingSpace1 = Get_Housing_Space($eGobl)
		;2nd barrack
		$unitaryTrainingTime2 = Get_Training_Time($eGobl)
		$unitaryHousingSpace2 = Get_Housing_Space($eGobl)
		;3rd barrack
		$unitaryTrainingTime3 = Get_Training_Time($eGobl)
		$unitaryHousingSpace3 = Get_Housing_Space($eGobl)
		;4th barrack
		$unitaryTrainingTime4 = Get_Training_Time($eGobl)
		$unitaryHousingSpace4 = Get_Housing_Space($eGobl)		
		
	EndIf
	
	$commonDenominator = $unitaryTrainingTime1 * $unitaryTrainingTime2 * $unitaryTrainingTime3 * $unitaryTrainingTime4
	;in $commonDenominator seconds I will make $totalHousingSpace1 housing space in the 1st barrack
	$totalHousingSpace1 = $commonDenominator / $unitaryTrainingTime1 * $unitaryHousingSpace1
	;in $commonDenominator seconds I will make $totalHousingSpace2 housing space in the 2nd barrack
	$totalHousingSpace2 = $commonDenominator / $unitaryTrainingTime2 * $unitaryHousingSpace2
	;in $commonDenominator seconds I will make $totalHousingSpace3 housing space in the 3rd barrack
	$totalHousingSpace3 = $commonDenominator / $unitaryTrainingTime3 * $unitaryHousingSpace3
	;in $commonDenominator seconds I will make $totalHousingSpace4 housing space in the 4th barrack
	$totalHousingSpace4 = $commonDenominator / $unitaryTrainingTime4 * $unitaryHousingSpace4	
	
	If $icmbDarkTroopComp = 0 Then 
		;We are in dark barrack mode
		;1st dark barrack
		$unitaryTrainingTime5 = Get_Training_Time($darkBarrackTroop[0])
		$unitaryHousingSpace5 = Get_Housing_Space($darkBarrackTroop[0])
		;2nd dark barrack
		$unitaryTrainingTime6 = Get_Training_Time($darkBarrackTroop[1])
		$unitaryHousingSpace6 = Get_Housing_Space($darkBarrackTroop[1])			

		$commonDenominator = $commonDenominator * $unitaryTrainingTime5 * $unitaryTrainingTime6
		;in $commonDenominator seconds I will make $totalHousingSpace5 housing space in the 1st dark barrack
		$totalHousingSpace5 = $commonDenominator / $unitaryTrainingTime5 * $unitaryHousingSpace5
		;in $commonDenominator seconds I will make $totalHousingSpace6 housing space in the 2nd dark barrack
		$totalHousingSpace6 = $commonDenominator / $unitaryTrainingTime6 * $unitaryHousingSpace6
	Else
		;We are not in dark barrack mode
		;Calculation of the default time for milking = no barrack 
		$totalHousingSpace5 = 0
		$totalHousingSpace6 = 0
	EndIf	
	


	;in $commonDenominator seconds I will make $totalHousingSpace housing space for all the barrack
	$totalHousingSpace = $totalHousingSpace1 + $totalHousingSpace2 + $totalHousingSpace3 + $totalHousingSpace4 + $totalHousingSpace5 + $totalHousingSpace6		
	
	$timeToFillCamps = 	$commonDenominator * ($wantedHouseSpace - $currentunitaryHousingSpace) / $totalHousingSpace
	
	Return Int($timeToFillCamps)
		
EndFunc ; Get_Time_To_Fill_Camps