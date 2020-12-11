********************************************************************************
$ontext

   CAPRI project

   GAMS file : additional_codes.gms

   @purpose  : to include Aglink codes not present in the aglink_sets.gms file in capri trunk
   @author   : mihalyh (mihaly.himics@ec.europa.eu)
   @date     : 24.08.2011
   @refDoc   :
   @seeAlso  : aglink_gdx_forGUI.gms
   @calledBy : aglink_gdx_forGUI.gms

$offtext
********************************************************************************


* other column items necessary for checking the Aglink baseline
* not necesseraly for further calculations in captrd

set agColsBaseline 'additional aglink columns necessary for checking the Aglink baseline' /
    'ST'    'Ending stocks'
    'IST'   'Intervention stocks (ending)'
    'PRST'  'Stocks in private storage (ending)'
    'diff_balance'  "shows if the market balance is closed"
    'eur_PP'  "producer price in eur"
    'suw_export'    "refined (white) sugar balance for E27"
* export of live animals and meat
*   'EXL'               'Exports live'
   'EXL-USA'          'Exports live'
*   'EXM'               'Exports meat'
   'EXM-USA'          'Exports meat'

   'EX-SUB'           'Subsidized Exports'

   'EX-SUB-LIM'      'Subsidized Exports limits (SUW)'
*   'EX-SUB-LIM-VAL' 'Exports'
   'EX-SUB-LIMADJ'   'Subsidized Exports limits determined by value (SUW)'
*   'EX-SUB-WTOVAL'   'WTO Subsidized Exports limits in value thsd EUR (SUW)'


   'EX-SUBLB'         'Subsidized Exports lower bound'
   'EX-SUBUB'         'Subsidized Exports upper bound'
*   'EX-T'             'Exports'
*   'EX-TAS-WE27'     'Exports'
*   'EX-TC-EU'        'Exports'
   'EX-UNS'           'Unsubsidized Exports'
*   'EX-UNS-CON'      'Exports'
*   'EX-UNS-MLT'      'Exports'

*   'QP-DS'             'Direct Sales (milk)'


* --- sugar related variables
'PP-ET'          'producer price -- commodity for ethanol production'
'PP-NQT'         'Non-quota producer price for sugar beet'
'QT'              'Quota'
'YLD-SBE'        'Yield'
'EPA'             'payment per area'
'EPA-DP'         'specific direct payments per area'
'EX-T'           'Exports'
'LEVY'            'Levy (sugar)'
'ST-CF'          'Carry-forward stock of non-quota sugar'
'XP'              'World market price'
'XP-E27'         'World market price to EU27 (copy of world market price)'
/;



*set agRowsBaseline  'additional aglink rows necessary for checking the Aglink baseline' /
* missing vegetable oils (not directly used in captrd)
*   'GL'                'Peanuts oil '
*   'CSL'               'Cottonseed oil'
*   'KL'                'Palmkernel oil'
*   'CL'                'Coconut oil'
*/;