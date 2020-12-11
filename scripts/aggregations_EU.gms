********************************************************************************
$ontext

   CAPRI project

   GAMS file : AGGREGATIONS_EU.GMS

   @purpose  : aggregate certain items to EU27 level
   @author   :
   @date     : 06.09.11
   @refDoc   :
   @seeAlso  :
   @calledBy : aglink_gdx_forGUI.gms

$offtext
********************************************************************************

* milk domestic use aggregation

* FE feed use on farm
%1("EUN", "FE", "MK" , agYears) = sum(agRegs$map_EU("EUN", agRegs), %1(agRegs,  "FE", "MK" , agYears));
* QP..DS direct sales
%1("EUN",  "QP-DS", "MK" , agYears) = sum(agRegs$map_EU("EUN", agRegs), %1(agRegs,  "QP-DS", "MK" , agYears));
* OU other use
%1("EUN",  "OU", "MK" , agYears) = sum(agRegs$map_EU("EUN", agRegs), %1(agRegs,  "OU", "MK" , agYears));


* milk use (FU = FE + OU + QP..DS)
%1("EUN",  "FU", "MK" , agYears) = sum(agRegs$map_EU("EUN", agRegs), %1(agRegs,  "FU", "MK" , agYears));



* VST variation in stocks calculation
