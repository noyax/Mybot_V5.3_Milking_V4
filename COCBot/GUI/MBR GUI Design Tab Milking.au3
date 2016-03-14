; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Milking
; Description ...: This file Includes GUI Milking
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

;~ -------------------------------------------------------------
;~ Milking Tab
;~ -------------------------------------------------------------
$tabMilking = GUICtrlCreateTabItem(GetTranslated(99,1, "Milking"))
	Local $x = 30, $y = 150
	$grpMilking = GUICtrlCreateGroup(GetTranslated(99,2, "Milking Parameters"), $x - 20, $y - 20, 450, 375)
		$lblcommon = GUICtrlCreateLabel(GetTranslated(99,3, "***** Common to 2 Milking methods (Scripted and new below)*****"), $x , $y + 3)
		$y += 23
		$chkDBAttMilk = GUICtrlCreateCheckbox(GetTranslated(99,4, "Milking with"), $x, $y, -1, -1)
			$txtTip = GetTranslated(99,5, "Use Gobelins Power to try Milking.")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "milkingatt")
		$txtDBAttMilk = GUICtrlCreateInput("90", $x + 75, $y + 3, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(99,6, "Number of troops used for milking attack")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 5)
			_GUICtrlEdit_SetReadOnly(-1, False)
		$lblDBAttMilkDB = GUICtrlCreateLabel(GetTranslated(99,7, "Troops in camps before 1st attack"), $x + 102, $y + 3)
		$y += 23
		$lblHysterGobs = GUICtrlCreateLabel(GetTranslated(99,8, "Nb troops mini in camps before re-train:"), $x - 5 , $y + 3)
		$txtchkHysterGobs = GUICtrlCreateInput("40", $x + 200, $y , 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(99,9, "Number min of troops before train again")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
			_GUICtrlEdit_SetReadOnly(-1, False)
		$y += 21
		$lblTempoTrain = GUICtrlCreateLabel(GetTranslated(99,10, "Nb minutes max between 2 training:"), $x - 5 , $y + 3)
;		$y += 23
		$txtchkTempoTrain = GUICtrlCreateInput("15", $x + 200, $y , 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(99,11, "Number minutes max between 2 trains troops")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
			_GUICtrlEdit_SetReadOnly(-1, False)
		$y += 23
		$lblnew = GUICtrlCreateLabel(GetTranslated(99,12, "****** Scripted method, use only if scripted attack is chosen *******"), $x , $y + 3)
		$y += 23
		$lblPixelmaxExposed2 = GUICtrlCreateLabel(GetTranslated(99,13, "Nb pixels to redline to consider exposed:"), $x - 5 , $y )
		$txtchkPixelmaxExposed2 = GUICtrlCreateInput("40", $x + 200, $y , 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(99,14, "Number min of Pixels to considere collectors exposed")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
			_GUICtrlEdit_SetReadOnly(-1, False)
;		$y += 23
;		$lblPixelmaxExposed2 = GUICtrlCreateLabel("Nb pixels between center of collector to the redline, higher is this number", $x - 5 , $y )
;		$y += 23
;		$lblPixelmaxExposed2 = GUICtrlCreateLabel(" more chance you have to fail attack. 25 seems to be the minimum but too strict. 40 seems good result.", $x - 5 , $y )
		$y += 30
		$lblnew = GUICtrlCreateLabel(GetTranslated(99,15, "****** New method, inactivates if scripted attack is chosen. It's for future update *******"), $x , $y + 3)
		$y += 23
		$lblPixelmaxExposed = GUICtrlCreateLabel(GetTranslated(99,16, "Nb tiles to redline to consider exposed:"), $x - 5 , $y )
		$txtchkPixelmaxExposed = GUICtrlCreateInput("1", $x + 200, $y , 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(99,17, "Number min of Tiles to considere collectors exposed")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
			_GUICtrlEdit_SetReadOnly(-1, False)
		$y += 21
		$txtDBUseGobsForCollector = GUICtrlCreateInput("5", $x, $y, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$txtTip = GetTranslated(99,18, "Bot tries to use X amount of Goblins to attack each exposed collector")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 3)
			_GUICtrlEdit_SetReadOnly(-1, False)
		$lblUseForColl2 = GUICtrlCreateLabel(GetTranslated(99,19, "Gobs / collectors"), $x + 30, $y, -1, -1)
;		$y += 26
		$chkMilkAttackNearGoldMine = GUICtrlCreateCheckbox("", $x + 120, $y, 17, 17)
			$txtTip = GetTranslated(3,37, "Drop troops near Gold Mines")
			GUICtrlSetTip(-1, $txtTip)
		$picMilkAttackNearGoldMine = GUICtrlCreateIcon($pIconLib, $eIcnMine, $x + 140 , $y - 3 , 24, 24)
			GUICtrlSetTip(-1, $txtTip)
		$chkMilkAttackNearElixirCollector = GUICtrlCreateCheckbox("", $x + 175, $y, 17, 17)
			$txtTip = GetTranslated(3,38, "Drop troops near Elixir Collectors")
			GUICtrlSetTip(-1, $txtTip)
		$picMilkAttackNearElixirCollector = GUICtrlCreateIcon($pIconLib, $eIcnCollector, $x + 195 , $y - 3 , 24, 24)
			GUICtrlSetTip(-1, $txtTip)
  		$chkMilkAttackNearDarkElixirDrill = GUICtrlCreateCheckbox("", $x + 230, $y, 17, 17)
			$txtTip = GetTranslated(3,39, "Drop troops near Dark Elixir Drills")
 			GUICtrlSetTip(-1, $txtTip)
		$picMilkAttackNearDarkElixirDrill = GUICtrlCreateIcon($pIconLib, $eIcnDrill, $x + 250 , $y - 3, 24, 24)
 			GUICtrlSetTip(-1, $txtTip)
		$y += 40
		$lblnew = GUICtrlCreateLabel(GetTranslated(99,20, "****** Option TH Snipe *******"), $x , $y + 3)
		$y += 23
		$chkAttIfDB = GUICtrlCreateCheckbox(GetTranslated(99,21, "Attack if loots <"), $x  , $y, -1, -1)
			$txtTip = GetTranslated(99,22, "Attack if TH Snipe found dead base")
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetState(-1, $GUI_ENABLE)
		$lblAttIfDB = GUICtrlCreateLabel(GetTranslated(99,23, "% of total loots"), $x + 125, $y+5, -1, 17)
		    GUICtrlSetTip(-1, $txtTip)
		$txtAttIfDB = GUICtrlCreateInput("10", $x + 95, $y + 1, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetTip(-1, $txtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState(-1, $GUI_ENABLE)
		$y += 30
;		$lblnew = GUICtrlCreateLabel("****** Train troop in dark barracks *******", $x , $y + 3)
;		$y += 23
;		$lblBarrack5 = GUICtrlCreateLabel("5:", $x - 5, $y, -1, -1)
;		$cmbBarrack5 = GUICtrlCreateCombo("", $x + 10, $y, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
;			GUICtrlSetTip(-1, $txtTip & " 5.")
;			GUICtrlSetData(-1, "-----------|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds, "-----------")
;			GUICtrlSetState(-1, $GUI_DISABLE)      
;		$lblBarrack6 = GUICtrlCreateLabel("6:", $x +140, $y, -1, -1)
;		$cmbBarrack6 = GUICtrlCreateCombo("", $x + 155, $y, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
;			GUICtrlSetTip(-1, $txtTip & " 6.")
;			GUICtrlSetData(-1, "-----------|" & $sTxtMinions & "|" & $sTxtHogRiders & "|" & $sTxtValkyries & "|" & $sTxtGolems & "|" & $sTxtWitches & "|" & $sTxtLavaHounds, "-----------")
;			GUICtrlSetState(-1, $GUI_DISABLE)         

	GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
