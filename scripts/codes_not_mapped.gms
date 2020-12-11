*=============================================================================
* File      : codes_not_mapped.gms
* Author    : mihalyh
* Version   : 1.0
* Date      : 07.09.2012 11:19:49
* Changed   : 07.09.2012 14:11:26
* Changed by: mihalyh
* Remarks   :
$ontext
 *--- EXTRA CODES THAT ARE NOT MAPPED ANYMORE => CAPRI CODE NEEDS TO BE REVISED
$offtext
*=============================================================================



*--- paths to a CAPRI installation
$include ..\settings.gms
$setlocal excelfile  "oecd_full.xlsx"
$setlocal aglinkversion "2011oecd"

*-- CURDIR used by some CAPRI code that is included below
$setglobal CURDIR %capriGams%

*--- READ IN DATA FROM AGLINK RESULT FILE (Excel) ------------------------------


*! please note that the order of commodities and attributes are the other way round in
* the original Aglink result file --> need to be edited manually before this procedure
* 'Org.' and 'Type' columns in Aglink result files should be deleted (not used by CAPRI)

$onecho > convert.txt
dset=countries rng=data!a2   rdim=1
dset=attributes rng=data!b2 rdim=1
dset=commodities rng=data!c2 rdim=1
dset=aglinkYears rng=data!d1  cdim=1
set=tuple rng=data!a2 rdim=3
par=DATAOUT  rng=data!a1 cdim=1 rdim=3 SkipEmpty=0
$offecho


$call 'gdxxrw.exe %excelfile% O=temp.gdx @convert.txt';

$gdxin temp.gdx

sets
    countries
    attributes
    commodities;

$load  countries attributes commodities

$gdxin

display countries;

*--- READ IN mappings from CAPRI
$include %capriGams%\sets.gms
$include %capriGams%\baseline\aglink%aglinkversion%_sets.gms
$include %capriGams%\global\fao_Codes.gms
$onmulti
$include %capriGams%\baseline\aglink%aglinkversion%_mappings.gms
$offmulti


display countries;

*--- AGLINK DIMENSIONS ALREADY EXPLAINED ---------------------------------------

* defined as subsets
set explainedRegions(countries);
set explainedCols(attributes);
set explainedRows(commodities);

* note that aglinkRegions, aglinkRegions and co are defined in the included CAPRI files
* countries which are found in the definiton set
    explainedRegions(countries) $ sum(aglinkRegions, sameas(countries, aglinkRegions)) = yes;

* populate aglinkCols
* attributes which are found in the definiton set
    explainedCols(attributes) $ sum(aglinkCols, sameas(attributes, aglinkCols)) = yes;

* populate aglinkRows
* commodities which are found in the definiton set
    explainedRows(commodities) $ sum(aglinkRows, sameas(commodities, aglinkRows)) = yes;


*--- checking codes that are used in CAPRI (at least mapped) but not anymore in Aglink

* extra codes in the definition set
set ExtraRegions(aglinkRegions) "regions extra in the set definitions";
set ExtraAttribs(aglinkCols) "attributes extra in the set definitions";
set ExtraComms(aglinkRows) "commodities extra in the set definitions";


    ExtraRegions(aglinkRegions)  $ (
*                                  the country code is in the CAPRI code list but not in the Excel sheet
                                   (not sum(countries, sameas(aglinkRegions, countries)))
                                   and
*                                  the country code is mapped in CAPRI (potentially used somewhere in calculations)
                                   aglinkRegionsMapped(aglinkRegions) )
                                   = yes;

    ExtraAttribs(aglinkCols)     $ (
                                   (not sum(attributes, sameas(aglinkCols, attributes)))
                                   and
                                   aglinkColsMapped(aglinkCols) )
                                   = yes;
    ExtraComms(aglinkRows)       $ (
                                    (not sum(commodities, sameas(aglinkRows, commodities)))
                                   and
                                   aglinkRowsMapped(aglinkRows) )
                                    = yes;

* send extrea codes to an Excel sheet for further investigation...
$onecho > extra_codes.txt
set=ExtraRegions   rng=regions!a1             rdim=1
set=ExtraAttribs   rng=attributes!a1 rdim=1   rdim=1
set=ExtraComms     rng=commodities!a1         rdim=1
$offecho

execute_unload "temp_MappedNotFound.gdx", ExtraRegions, ExtraAttribs, ExtraComms;
* removes old excel sheet if exists
execute 'if exist MappedNotFound.xlsx rm MappedNotFound.xlsx'
execute 'gdxxrw.exe temp_MappedNotFound.gdx O=MappedNotFound.xlsx @extra_codes.txt';


* clean up temporary files
execute 'if exist temp.gdx rm temp.gdx'
execute 'if exist temp_MappedNotFound.gdx rm temp_MappedNotFound.gdx'



*============================   End Of File   ================================