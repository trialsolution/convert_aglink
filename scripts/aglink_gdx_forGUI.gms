********************************************************************************
$ontext

   CAPRI project

   GAMS file : aglink_gdx_forGUI.GMS

   @purpose  : creates gdx files that can be read by the CAPRI GUI
   @author   : Mihaly
   @date     : 16.07.11
   @refDoc   :
   @seeAlso  :
   @calledBy :

$offtext
********************************************************************************

$include ..\settings.gms

* Aglink set definitions
$include '%capriGams%\baseline\aglink2017dgAgri_sets.gms'

* Additional codes necessary for the baseline process (maybe not used in captrd)
$include additional_codes.gms

set agColsGdx 'aglink columns for converting the Aglink data file in a usable format for the GUI';

*execute_unload "check_lists.gdx", agCols, agRows;
*$stop

* we load in more columns from the gdx not only those that are actually used later on in CAPRI
* this helps to check balances.
* the same is true for the rows
* the additional codes are defined in 'additional_codes.gms'
set agColsGdx 'columns to be read from the gdx file' /
* definitions in capri trunk
    set.agCols

* additional definitions
    set.agColsBaseline
/;

display agColsGdx  ;


set agRowsGdx 'rows to be read from the gdx file' /
* definitions in capri trunk
    set.agRows

* additional definitions
*    set.agRowsBaseline
/;

$include 'mappings.gms';

* define the subsets of the Aglink data cube dimensions
* only part of the full Aglink data cube will be loaded
$batinclude 'data_container.gms' agRegs agColsGdx agRowsGdx agYears


* this data container will store both Aglink baselines
parameter DATAOUT(agRegs, *, agColsGdx, agRowsGdx, agYears) "data output";

*
*   --- OECD milk balance constructed differently? the aggregation below does not make sense in the OECD2017 baseline
*
$batinclude 'aggregations_EU.gms' p_prevAglink

* --- previous Aglink baseline

*a) data from original source
DATAOUT(agRegs, "", agColsGdx, agRowsGdx, agYears) = p_prevAglink(agRegs, agColsGdx, agRowsGdx, agYears);

*b) calculations
$include data_checks.gms
* convert prices in national currencies to eur prices
$include eur_prices.gms



*c) creates gdx
execute_unload "..\results\Capmod\res_2_%releaseYear%%endProjYear%%firstOutputf%.gdx", DATAOUT;


* --- clears data container
DATAOUT(agRegs, "", agColsGdx, agRowsGdx, agYears) = 0;

*
*   --- OECD milk balance constructed differently? the aggregation below does not make sense in the OECD2017 baseline
*
$batinclude 'aggregations_EU.gms' p_newAglink


* --- current Aglink baseline

*a) data from original source
DATAOUT(agRegs, "", agColsGdx, agRowsGdx, agYears) = p_newAglink(agRegs, agColsGdx, agRowsGdx, agYears);

*b) calculations
$include 'data_checks.gms';
* convert prices in national currencies to eur prices
$include 'eur_prices.gms';

*c) creates gdx
execute_unload "..\results\Capmod\res_2_%releaseYear%%endProjYear%%secondOutputf%.gdx", DATAOUT;

* checks if new series are created/previous ones are missing
* reported in display & gdx file
$include 'new_series.gms';
