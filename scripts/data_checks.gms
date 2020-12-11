********************************************************************************
$ontext

   CAPRI project

   GAMS file : DATA_CHECKS.GMS

   @purpose  : calculates test columns that will be appear in the GUI
   @author   : mihalyh (mihaly.himics@ec.europa.eu
   @date     : 26.08.11
   @refDoc   :
   @seeAlso  :
   @calledBy : aglink_gdx_forGUI.gdx

$offtext
********************************************************************************




*a) difference of balance items -- should be zero

* --- coarse grains

DATAOUT(agRegs, "", "diff_balance", "CG" , agYears) $ (agYears.val gt 2000) =
* QP + IM
        DATAOUT(agRegs, "", "QP", "CG", agYears) + DATAOUT(agRegs, "", "IM", "CG", agYears)

* change in stocks
        + DATAOUT(agRegs, "", "ST", "CG", agYears-1) - DATAOUT(agRegs, "", "ST", "CG", agYears)

* - QC - EX
        - DATAOUT(agRegs, "", "QC", "CG", agYears) - DATAOUT(agRegs, "", "EX", "CG", agYears)
;
*DATAOUT(agRegs, "", "diff_balance", "CG" , "2000") = NA;



* --- sugar (SU) in raw sugar equivalent
DATAOUT(agRegs, "", "diff_balance", "SU" , agYears) $ (agYears.val gt 2000) =
* QP + IM
        DATAOUT(agRegs, "", "QP", "SU", agYears) + DATAOUT(agRegs, "", "IM", "SU", agYears)

* change in stocks
        + DATAOUT(agRegs, "", "ST", "SU", agYears-1) - DATAOUT(agRegs, "", "ST", "SU", agYears)

* - QC - EX
        - DATAOUT(agRegs, "", "QC", "SU", agYears) - DATAOUT(agRegs, "", "EX", "SU", agYears)
;


* --- refined (white) sugar
* check SUW export balance, after 2006 (E27_SUW_EX = E15_SUW_EX-SUB + E12_SUW_EX-SUB-LIM)
DATAOUT("EUN", "", "suw_export", "SUW" , agYears) $ (agYears.val gt 2006) =
   DATAOUT("E15", "", "EX-SUB", "SUW", agYears)
   + DATAOUT("NMS", "", "EX-SUB-LIM", "SUW", agYears) $ DATAOUT("NMS", "", "EX-SUB-LIM", "SUW", agYears)
   - DATAOUT("EUN", "", "EX", "SUW", agYears);



* --- vegetable oils
* a bit bizarre but vegetable and oilseed oils are in nested equations:
* VL=OL+PL+KL+CL
*    OL=RL+SFL+SL+CSL+GL

DATAOUT(agRegs, "", "diff_balance", "VL" , agYears) $ (agYears.val gt 2000) =
* QP + IM
        DATAOUT(agRegs, "", "QP", "VL", agYears) + DATAOUT(agRegs, "", "IM", "VL", agYears)

* change in stocks
        + DATAOUT(agRegs, "", "ST", "VL", agYears-1) - DATAOUT(agRegs, "", "ST", "VL", agYears)

* - QC - EX
        - DATAOUT(agRegs, "", "QC", "VL", agYears) - DATAOUT(agRegs, "", "EX", "VL", agYears)
;

DATAOUT(agRegs, "", "diff_balance", "OL" , agYears) $ (agYears.val gt 2000) =
* QP + IM
        DATAOUT(agRegs, "", "QP", "OL", agYears) + DATAOUT(agRegs, "", "IM", "OL", agYears)

* change in stocks
        + DATAOUT(agRegs, "", "ST", "OL", agYears-1) - DATAOUT(agRegs, "", "ST", "OL", agYears)

* - QC - EX
        - DATAOUT(agRegs, "", "QC", "OL", agYears) - DATAOUT(agRegs, "", "EX", "OL", agYears)
;


* --- subitems in VL and OL may not be balanced individually only at aggregated level
DATAOUT(agRegs, "", "diff_balance", agRowsGdx, agYears) $ ((agYears.val gt 2000)
                and aggreg_prod("VL", agRowsGdx)) =
* QP + IM
        DATAOUT(agRegs, "", "QP", agRowsGdx, agYears) + DATAOUT(agRegs, "", "IM", agRowsGdx, agYears)

* change in stocks
        + DATAOUT(agRegs, "", "ST", agRowsGdx, agYears-1) - DATAOUT(agRegs, "", "ST", agRowsGdx, agYears)

* - QC - EX
        - DATAOUT(agRegs, "", "QC", agRowsGdx, agYears) - DATAOUT(agRegs, "", "EX", agRowsGdx, agYears)
;
*
DATAOUT(agRegs, "", "diff_balance", agRowsGdx, agYears) $ ((agYears.val gt 2000)
                and aggreg_prod("OL", agRowsGdx)) =
* QP + IM
        DATAOUT(agRegs, "", "QP", agRowsGdx, agYears) + DATAOUT(agRegs, "", "IM", agRowsGdx, agYears)

* change in stocks
        + DATAOUT(agRegs, "", "ST", agRowsGdx, agYears-1) - DATAOUT(agRegs, "", "ST", agRowsGdx, agYears)

* - QC - EX
        - DATAOUT(agRegs, "", "QC", agRowsGdx, agYears) - DATAOUT(agRegs, "", "EX", agRowsGdx, agYears)
;




* --- barley

DATAOUT(agRegs, "", "diff_balance", "BA" , agYears) $ (agYears.val gt 2000) =
* QP + IM
        DATAOUT(agRegs, "", "QP", "BA", agYears) + DATAOUT(agRegs, "", "IM", "BA", agYears)

* change in stocks
        + DATAOUT(agRegs, "", "ST", "BA", agYears-1) - DATAOUT(agRegs, "", "ST", "BA", agYears)

* - QC - EX
        - DATAOUT(agRegs, "", "QC", "BA", agYears) - DATAOUT(agRegs, "", "EX", "BA", agYears)
;



* --- for biodiesel only net trade is in the equations
DATAOUT(agRegs, "", "diff_balance", "BD" , agYears) $ (agYears.val gt 2000) =
* QP + NT
        DATAOUT(agRegs, "", "QP", "BD", agYears) - DATAOUT(agRegs, "", "NT", "BD", agYears)

* - QC
        - DATAOUT(agRegs, "", "QC", "BD", agYears)
;

* --- bioethanol is like biodiesel
DATAOUT(agRegs, "", "diff_balance", "ET" , agYears) $ (agYears.val gt 2000) =
* QP + NT
        DATAOUT(agRegs, "", "QP", "ET", agYears) - DATAOUT(agRegs, "", "NT", "ET", agYears)

* - QC
        - DATAOUT(agRegs, "", "QC", "ET", agYears)
;



* --- Dairy products

* --- butter
* note that VST is calculated for butter
* VST = IST - IST(-1) + PRST
DATAOUT(agRegs, "", "diff_balance", "BT" , agYears) $ (agYears.val gt 2000) =
* QP + IM
        DATAOUT(agRegs, "", "QP", "BT", agYears) + DATAOUT(agRegs, "", "IM", "BT", agYears)

* - QC - EX - vst
        - DATAOUT(agRegs, "", "QC", "BT", agYears) - DATAOUT(agRegs, "", "EX", "BT", agYears) - DATAOUT(agRegs, "", "VST", "BT", agYears)
;

* CA casein
DATAOUT(agRegs, "", "diff_balance", "CA" , agYears) $ (agYears.val gt 2000) =
* QP + IM
        DATAOUT(agRegs, "", "QP", "CA", agYears) + DATAOUT(agRegs, "", "IM", "CA", agYears)

* change in stocks
        - DATAOUT(agRegs, "", "VST", "CA", agYears)

* - QC - EX
        - DATAOUT(agRegs, "", "QC", "CA", agYears) - DATAOUT(agRegs, "", "EX", "CA", agYears)
;


* CH Cheese
DATAOUT(agRegs, "", "diff_balance", "CH" , agYears) $ (agYears.val gt 2000) =
* QP + IM
        DATAOUT(agRegs, "", "QP", "CH", agYears) + DATAOUT(agRegs, "", "IM", "CH", agYears)

* change in stocks
        - DATAOUT(agRegs, "", "VST", "CH", agYears)

* - QC - EX
        - DATAOUT(agRegs, "", "QC", "CH", agYears) - DATAOUT(agRegs, "", "EX", "CH", agYears)
;

* FDP Fresh dairy products
* it only has food use: QC=FO
* no stocks, no trade
* the balance: QP=QC
DATAOUT(agRegs, "", "diff_balance", "FDP" , agYears) $ (agYears.val gt 2000) =
* QP
        DATAOUT(agRegs, "", "QP", "FDP", agYears)
* - QC
        - DATAOUT(agRegs, "", "QC", "FDP", agYears)
;


* ODP Other dairy products
* not for the EU, only for a few countries

* SMP skimmed milk powder
DATAOUT(agRegs, "", "diff_balance", "SMP" , agYears) $ (agYears.val gt 2000) =
* QP + IM
        DATAOUT(agRegs, "", "QP", "SMP", agYears) + DATAOUT(agRegs, "", "IM", "SMP", agYears)

* change in stocks
        - DATAOUT(agRegs, "", "VST", "SMP", agYears)

* - QC - EX
        - DATAOUT(agRegs, "", "QC", "SMP", agYears) - DATAOUT(agRegs, "", "EX", "SMP", agYears)
;


* WMP whole milk powder
DATAOUT(agRegs, "", "diff_balance", "WMP" , agYears) $ (agYears.val gt 2000) =
* QP + IM
        DATAOUT(agRegs, "", "QP", "WMP", agYears) + DATAOUT(agRegs, "", "IM", "WMP", agYears)

* change in stocks
        - DATAOUT(agRegs, "", "VST", "WMP", agYears)

* - QC - EX
        - DATAOUT(agRegs, "", "QC", "WMP", agYears) - DATAOUT(agRegs, "", "EX", "WMP", agYears)
;

* WYP whey powder
* only net trade, no stocks
DATAOUT(agRegs, "", "diff_balance", "WYP" , agYears) $ (agYears.val gt 2000) =
* QP + NT
        DATAOUT(agRegs, "", "QP", "WYP", agYears) - DATAOUT(agRegs, "", "NT", "WYP", agYears)

* - QC
        - DATAOUT(agRegs, "", "QC", "WYP", agYears)
;



* --- live animal and meat export


* --- beef and veal
* code correction for USA
* EXL-USA and EXL-USA are relevant not for the US but for CAN and MEX
* this is the export going to the US
DATAOUT("USA", "", "EXL", "BV" , agYears) $ (not DATAOUT("USA", "", "EXL", "BV" , agYears)) =
  DATAOUT("USA", "", "EXL-USA", "BV" , agYears);

DATAOUT("USA", "", "EXM", "BV" , agYears) $ (not DATAOUT("USA", "", "EXM", "BV" , agYears)) =
  DATAOUT("USA", "", "EXM-USA", "BV" , agYears);

* balance
* usually EX=EXM+EXL is already calculated in the database-.
* -. same for IM=IMM+IML
DATAOUT(agRegs, "", "diff_balance", "BV" , agYears) $ (agYears.val gt 2000) =
* QP + IM
        DATAOUT(agRegs, "", "QP", "BV", agYears) + DATAOUT(agRegs, "", "IM", "BV", agYears)

* change in stocks
        + DATAOUT(agRegs, "", "ST", "BV", agYears-1) - DATAOUT(agRegs, "", "ST", "BV", agYears)

* - QC - EXM - EXL
        - DATAOUT(agRegs, "", "QC", "BV", agYears) - DATAOUT(agRegs, "", "EXM", "BV", agYears) - DATAOUT(agRegs, "", "EXL", "BV", agYears)
;
