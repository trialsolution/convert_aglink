********************************************************************************
$ontext

   CAPRI project

   GAMS file : DATA_CONTAINER.GMS

   @purpose  : loads in selected parts of the Aglink data cube
   @author   : Mihaly
   @date     : 16.07.11
   @refDoc   :
   @seeAlso  :
   @calledBy :

$offtext
********************************************************************************

* data containers for new and previous Aglink results
parameters
        p_prevAglink(%1, %2, %3, %4) "data container for previous Aglink results"
        p_newAglink(%1, %2, %3, %4)  "data container for current Aglink results"
;


* check only the balance positions and define the data containers accordingly
* => the execute load will work as a filter and loads in only the data we need

execute_load %prevAglink%, p_prevAglink=%prevParam%;
execute_load %newAglink%, p_newAglink=%newParam%;

* delete NA's
p_prevAglink(%1, %2, %3, %4) $ (p_prevAglink(%1, %2, %3, %4) eq NA) = 0;
p_newAglink(%1, %2, %3, %4) $ (p_newAglink(%1, %2, %3, %4) eq NA) = 0;

