********************************************************************************
$ontext

   CAPRI project

   GAMS file : NEW_SERIES.GMS

   @purpose  : to check differences between the new Aglink baseline
                                               and the previous one
   @author   : Mihaly
   @date     : 16.07.11
   @refDoc   :
   @seeAlso  :
   @calledBy :

$offtext
********************************************************************************

* the parameters p_newAglink and p_prevAglink still need to be in memory...

* dimensions: agRegs agColsGdx agRowsGdx agYears

parameters
        p_newSeries(agRegs,agColsGdx,agRowsGdx,agYears) "time series that appear first in the new baseline"
        p_missingSeries(agRegs,agColsGdx,agRowsGdx,agYears) "time series that disappear in the new baseline"
        p_absdiffSeries(agRegs,agColsGdx,agRowsGdx,agYears) "absolute differences between the time series"
        p_reldiffSeries(agRegs,agColsGdx,agRowsGdx,agYears) "relative differences between the time series"
;

p_newSeries(agRegs,agColsGdx,agRowsGdx,agYears) $
        ( p_newAglink(agRegs,agColsGdx,agRowsGdx,agYears) and (not p_prevAglink(agRegs,agColsGdx,agRowsGdx,agYears)) ) = yes;

p_missingSeries(agRegs,agColsGdx,agRowsGdx,agYears) $
        ( (not p_newAglink(agRegs,agColsGdx,agRowsGdx,agYears)) and p_prevAglink(agRegs,agColsGdx,agRowsGdx,agYears) ) = yes;

p_absdiffSeries(agRegs,agColsGdx,agRowsGdx,agYears) $
        ( p_newAglink(agRegs,agColsGdx,agRowsGdx,agYears) and p_prevAglink(agRegs,agColsGdx,agRowsGdx,agYears) )
           = p_newAglink(agRegs,agColsGdx,agRowsGdx,agYears) - p_prevAglink(agRegs,agColsGdx,agRowsGdx,agYears);

p_reldiffSeries(agRegs,agColsGdx,agRowsGdx,agYears) $
        ( p_newAglink(agRegs,agColsGdx,agRowsGdx,agYears) and (p_prevAglink(agRegs,agColsGdx,agRowsGdx,agYears) ne 0))
           = (p_newAglink(agRegs,agColsGdx,agRowsGdx,agYears) / p_prevAglink(agRegs,agColsGdx,agRowsGdx,agYears) -1) * 100;

display p_newSeries, p_missingSeries, p_absdiffSeries, p_reldiffSeries;

execute_unload "diff_%firstOutputf%_%secondOutputf%.gdx", p_newSeries, p_missingSeries, p_absdiffSeries, p_reldiffSeries;