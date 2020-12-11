********************************************************************************
$ontext

   CAPRI project

   GAMS file : CREATE_XML.GMS

   @purpose  : utility to create the table definiton file for the GUI
                makes possible to use the capri GUI for the Aglink baseline
   @author   : Mihaly
   @date     : 17.07.11
   @refDoc   :
   @seeAlso  :
   @calledBy :

   updated by mihaly on 190416: for usage in 2016 baseline exercise

   Note that the working directory for gams should be the same where settings.gms sits

$offtext
********************************************************************************
*
*   --- main settings for the baseline scripts and GUI
*
$include ..\..\settings.gms

$setglobal curdir %capriGams%

* Aglink set definitions
* don't forget to change the file name according to the input file in settings.gms (!)
$include %capriGams%\baseline\aglink2017dgAgri_sets.gms

file xmltags /xmltags.xml/;
put xmltags;
loop(agREgs,
        put '<region>' /;
        put '<key>', agRegs.tl:3, '</key>' /;
        put '<itemName>', agRegs.te(agRegs), '</itemName>' /;
        put '<sel>', '[all]', '</sel>' /;
        put '</region>' /;
);

put '****---- products start here----****' ///;

loop(agRows,
        put '<product>' /;
        put '<key>', agRows.tl:3, '</key>' /;
        put '<itemName>', agRows.te(agRows), '</itemName>' /;
        put '<sel>', '[all]', '</sel>' /;
        put '</product>' /;
);


put '****---- activities (Aglink variables) start here----****' ///;

loop(agCols,
        put '<activity>' /;
        put '<key>', agCols.tl, '</key>' /;
        put '<itemName>', agCols.te(agCols), '</itemName>' /;
        put '<sel>', '[all]', '</sel>' /;
        put '</activity>' /;
);


* other column items necessary for checking the Aglink baseline
* not necesseraly for further calculations in captrd
set agColsBaseline 'aglink columns necessary for checking the Aglink baseline' /
    'ST'    'Ending stocks'
    'IST'   'Intervention stocks (ending)'
    'PRST'  'Stocks in private storage (ending)'
/;
loop(agColsBaseline,
        put '<activity>' /;
        put '<key>', agColsBaseline.tl, '</key>' /;
        put '<itemName>', agColsBaseline.te(agColsBaseline), '</itemName>' /;
        put '<sel>', '[all]', '</sel>' /;
        put '</activity>' /;
);




put '****---- items start here; move manually to appropriate table definitions----****' ///;


put '****---- balance positions; move manually to appropriate table definitions----****' ///;
loop(agBalPos,
        put '<item>' /;
        put '<key>', agBalPos.tl:4, '</key>' /;
        put '<itemName>', agBalPos.te(agBalPos), '</itemName>' /;
        put '<unit>', '', '</unit>' /;
        put '<longtext>', '', '</longtext>' /;
        put '</item>' /;
);

put '****---- MACRO VARIABLES; move manually to appropriate table definitions----****' ///;
loop(agMacroVar,
        put '<item>' /;
        put '<key>', agMacroVar.tl:4, '</key>' /;
        put '<itemName>', agMacroVar.te(agMacroVar), '</itemName>' /;
        put '<unit>', '', '</unit>' /;
        put '<longtext>', '', '</longtext>' /;
        put '</item>' /;
);


put '****---- BIOFUEL VARIABLES; move manually to appropriate table definitions----****' ///;
loop(agBioVar,
        put '<item>' /;
        put '<key>', agBioVar.tl, '</key>' /;
        put '<itemName>', agBioVar.te(agBioVar), '</itemName>' /;
        put '<unit>', '', '</unit>' /;
        put '<longtext>', '', '</longtext>' /;
        put '</item>' /;
);



putclose xmltags;
