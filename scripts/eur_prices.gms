*<%REGION File header%>
*=============================================================================
* File      : eur_prices.gms
* Author    : mihalyh
* Version   : 1.0
* Date      : 5/23/2012 5:17:39 PM
* Changed   : 5/23/2012 5:41:02 PM
* Changed by: mihalyh
* Remarks   :
$ontext
             converts prices from nat.currencies per unit of m.
                      into EUR per unit of m.
$offtext
*=============================================================================
*<%/REGION File header%>




DATAOUT(agRegs, "", "eur_PP", agRowsGdx , agYears) $ (DATAOUT(agRegs, "", "XR", "ME" , agYears)
        $ DATAOUT(agRegs, "", "PP", agRowsGdx , agYears) )

* ---                                                   exchange rate format: USD / nat. currency 
 =        DATAOUT(agRegs, "", "PP", agRowsGdx , agYears) /  DATAOUT(agRegs, "", "XR", "ME" , agYears)
          * DATAOUT("EUN", "", "XR", "ME" , agYears);






*============================   End Of File   ================================
