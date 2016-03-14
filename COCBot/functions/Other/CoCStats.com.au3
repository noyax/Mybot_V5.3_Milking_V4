#cs ----------------------------------------------------------------------------
    AutoIt Version: 3.3.6.1
    This file was made to software MyBot v4.2.2
    Author:   JK

    Script Function: CoCStats
 MyBot is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.
 MyBot is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty;of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with CoCgameBot.  If not, see ;<http://www.gnu.org/licenses/>.
 #ce ----------------------------------------------------------------------------

Func CoCStats($starsearned)

If $ichkCoCStats = 0 Then Return

; ==================== Begin CoCStats Mod ====================
   SetLog("Sending attack report to CoCStats.com...", $COLOR_BLUE)
   $sPD = 'apikey=' & $MyApiKey & '&ctrophy=' & $iTrophyCurrent & '&cgold=' & $iGoldCurrent & '&celix=' & $iElixirCurrent & '&cdelix=' & $iDarkCurrent & '&search=' & $SearchCount & '&gold=' & $iGoldLast & '&elix=' & $iElixirLast & '&delix=' & $iDarkLast & '&trophy=' & $iTrophyLast & '&bgold=' & $iGoldLastBonus & '&belix=' & $iElixirLastBonus & '&bdelix=' & $iDarkLastBonus & '&stars=' & $starsearned & '&thlevel=' & $iTownHallLevel & '&log='

   $tempLogText = _GuiCtrlRichEdit_GetText($txtLog, True)
   For $i = 1 To StringLen($tempLogText)
	  $acode = Asc(StringMid($tempLogText, $i, 1))
	  Select
		 Case ($acode >= 48 And $acode <= 57) Or _
			   ($acode >= 65 And $acode <= 90) Or _
			   ($acode >= 97 And $acode <= 122)
			$sPD = $sPD & StringMid($tempLogText, $i, 1)
		 Case $acode = 32
			$sPD = $sPD & "+"
		 Case Else
			$sPD = $sPD & "%" & Hex($acode, 2)
	  EndSelect
   Next

   $oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
   $oHTTP.Open("POST", "https://cocstats.com/api/log.php", False)
   $oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

   $oHTTP.Send($sPD)

   $oReceived = $oHTTP.ResponseText
   $oStatusCode = $oHTTP.Status
   SetLog("Report sent. " & $oStatusCode & " " & $oReceived, $COLOR_BLUE)
; ===================== End CoCStats Mod =====================

EndFunc
