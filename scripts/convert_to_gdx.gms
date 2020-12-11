********************************************************************************
$ontext

   CAPRI project

   GAMS file : CONVERT_TO_GDX.GMS

   @purpose  : to convert the original aglink  excel sheet into the appropriate
                gdx format

               output file: aglink20XXDGAgri_oriData.gdx

   @author   : mihalyh
   @date     : 02.11.10
   @refDoc   :
   @seeAlso  :
   @calledBy :

   updated   : 07.11.2011.

              by mihaly on 190416:  Aglink results are now supplied directly in .gdx
                                    see R\adjust_gdx.r for further details
                                    
              by mihaly on 040118:  to process the OECD baseline 2017                      

              by mihaly 220120:     to process MTO2019

$offtext
********************************************************************************

* this is the file created by the R script
$setlocal gdxinputfile "..\data\MTO_2019.gdx"

* this output .gdx will be used directly by CAPTRD in the load_aglink module
$setlocal gdxresultfile aglink2019dgAgri_oriData


*--- READ IN DATA FROM AGLINK RESULT FILE ------------------------------
*$call 'gdxxrw.exe %gdxinputfile% O=temp.gdx @convert.txt';

$gdxin %gdxinputfile% 


*--- INCLUDES CODE LISTS, must be cross-checked with codes in the Excel file----
$include 'codelists.gms'


* sending the  code definiton list (as defined in codelists.gms) to an Excel sheet for further investigation...
$onecho > code_definitions.txt
set=aglinkRegions1          rng=regions!a1 rdim=1
set=aglinkCols1             rng=attributes!a1  rdim=1
set=aglinkRows1             rng=commodities!a1 rdim=1
$offecho

execute_unload "temp_code_definitions.gdx", aglinkRegions1, aglinkCols1, aglinkRows1;
execute 'if exist Code_definitions.xls rm Code_definitions.xls'
execute 'gdxxrw.exe temp_code_definitions.gdx O=Code_definitions.xls @code_definitions.txt';



* sending the full code list as found in the dataset (Excel file)  to an Excel sheet for further investigation...
$onecho > full_codes.txt
set=countries          rng=regions!a1 rdim=1
set=attributes         rng=attributes!a1  rdim=1
set=commodities        rng=commodities!a1 rdim=1
$offecho

execute_unload "temp_allcodes.gdx", countries, attributes, commodities;
execute 'if exist allCodes.xls rm allCodes.xls'
execute 'gdxxrw.exe temp_allcodes.gdx O=allCodes.xls @full_codes.txt';



*--- AGLINK DIMENSIONS ALREADY EXPLAINED ---------------------------------------

* 'aglinkRegions/Cols/Rows1' are those defined in codelist.gms (known codes)
* 'aglinkRegions/Cols/Rows' (not ending to 1) are those found in the AGLINK result cube


* defined as subsets
set aglinkRegions(countries);
set aglinkCols(attributes);
set aglinkRows(commodities);

* populate aglinkRegions
* countries which are found in the definiton set
    aglinkRegions(countries) $ sum(aglinkRegions1, sameas(countries, aglinkRegions1)) = yes;

* populate aglinkCols
* attributes which are found in the definiton set
    aglinkCols(attributes) $ sum(aglinkCols1, sameas(attributes, aglinkCols1)) = yes;

* populate aglinkRows
* commodities which are found in the definiton set
    aglinkRows(commodities) $ sum(aglinkRows1, sameas(commodities, aglinkRows1)) = yes;



*--- CHECKING MISSING OR EXTRA CODES IN codelists.gms --------------------------


* codes not covered in the definition set (needs to be checked afterwards...)
set NotCoveredRegions(countries) "regions not covered in the set definitions";
set NotCoveredAttribs(attributes) "attributes not covered in the set definitions";
set NotCoveredComms(commodities) "commodities not covered in the set definitions";


    NotCoveredRegions(countries)  $ (not aglinkRegions(countries)) = yes;
    NotCoveredAttribs(attributes) $ (not aglinkCols(attributes))   = yes;
    NotCoveredComms(commodities)  $ (not aglinkRows(commodities))  = yes;



$onecho > missing_codes.txt
set=NotCoveredRegions  rng=regions!a1 rdim=1
set=NotCoveredAttribs  rng=attributes!a1 rdim=1
set=NotCoveredComms    rng=commodities!a1 rdim=1
$offecho

* send missing codes to an Excel sheet for further investigation...
execute_unload "temp_codes.gdx", NotCoveredRegions, NotCoveredAttribs, NotCoveredComms;
execute 'if exist newCodesFound.xls rm newCodesFound.xls'
execute 'gdxxrw.exe temp_codes.gdx O=newCodesFound.xls @missing_codes.txt';


* extra codes in the definition set
set ExtraRegions(aglinkRegions1) "regions extra in the set definitions";
set ExtraAttribs(aglinkCols1) "attributes extra in the set definitions";
set ExtraComms(aglinkRows1) "commodities extra in the set definitions";


    ExtraRegions(aglinkRegions1)  $ (not sum(countries, sameas(aglinkRegions1, countries))) = yes;
    ExtraAttribs(aglinkCols1)     $ (not sum(attributes, sameas(aglinkCols1, attributes)))    = yes;
    ExtraComms(aglinkRows1)       $ (not sum(commodities, sameas(aglinkRows1, commodities)))    = yes;

* send extrea codes to an Excel sheet for further investigation...
$onecho > extra_codes.txt
set=ExtraRegions   rng=regions!a1
set=ExtraAttribs   rng=attributes!a1 rdim=1
set=ExtraComms     rng=commodities!a1
$offecho

execute_unload "temp_extracodes.gdx", ExtraRegions, ExtraAttribs, ExtraComms;
* removes old excel sheet if exists
execute 'if exist ExtraCodesFound.xls rm ExtraCodesFound.xls'
execute 'gdxxrw.exe temp_extracodes.gdx O=ExtraCodesFound.xls @extra_codes.txt';




*--- CREATES DATA FILE USED BY CAPRI -------------------------------------------

* tuples for final reporting
set aglinkTuple(countries, attributes, commodities);
aglinkTuple(aglinkRegions, aglinkCols, aglinkRows) $
   (tuple(aglinkRegions, aglinkCols, aglinkRows)) = YES;


parameter  p_aglinkOri(countries, attributes, commodities, aglinkYears);

p_aglinkOri(aglinkRegions, aglinkCols, aglinkRows, aglinkYears)
    = DATAOUT(aglinkRegions, aglinkCols, aglinkRows, aglinkYears);

execute_unload "..\results\%gdxresultfile%.gdx" p_aglinkOri, aglinkRegions, aglinkCols, aglinkRows, aglinkYears, aglinkTuple;
execute_unload "..\data\%gdxresultfile%.gdx" p_aglinkOri, aglinkRegions, aglinkCols, aglinkRows, aglinkYears, aglinkTuple;

* clean up temporary files
execute 'if exist temp.gdx rm temp.gdx'
execute 'if exist temp_codes.gdx rm temp_codes.gdx'
execute 'if exist temp_extracodes.gdx rm temp_extracodes.gdx'
execute 'if exist temp_allcodes.gdx rm temp_allcodes.gdx'
execute 'if exist temp_code_definitions.gdx rm temp_code_definitions.gdx'
