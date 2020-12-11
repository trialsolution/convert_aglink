********************************************************************************
$ontext

   CAPRI project

   GAMS file : SETTINGS.GMS

   @purpose  : settings related to the capri modelling system:
                model directory, gams directory
   @author   : Mihaly
   @date     : 16.07.11
   @refDoc   :
   @seeAlso  :
   @calledBy :

$offtext
********************************************************************************

* main directory of the CAPRI modelling system
$setglobal capriMain 'c:\Users\Public\trunk\'

* gams directory of CAPRI
$setglobal capriGams %capriMain%gams

* dat directory of CAPRI
$setglobal capriDat %capriMain%dat

* data files for the new Aglink baseline and for the previous one
$setglobal prevAglink "'..\data\aglink2017dgAgri_oriData.gdx'"
$setglobal newAglink  "'..\data\aglink2019dgAgri_oriData.gdx'"

* parameter names in the original data files
$setglobal prevParam p_aglinkOri
$setglobal newParam p_aglinkOri

* these names will be used as scenario names
$setglobal firstOutputf  "Agri2017"
$setglobal secondOutputf "Agri2019"

$setglobal releaseYear 19
$setglobal endProjYear 30
