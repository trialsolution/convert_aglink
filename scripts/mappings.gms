********************************************************************************
$ontext

   CAPRI project

   GAMS file : MAPPINGS.GMS

   @purpose  :
   @author   :
   @date     : 31.08.11
   @refDoc   :
   @seeAlso  :
   @calledBy :

$offtext
********************************************************************************

* --- aggregated product mappings
set aggreg_prod(agRowsGdx, agRowsGdx) "aggregated product mappings" /
* vegetable oils
     VL.(OL,PL,KL,CL)
     OL.(RL,SFL,SL,CSL,GL)
/;

set map_EU(agRegs, agRegs) "mapping for aggregating EU results"/

    EUN.(E15,NMS)
/;
