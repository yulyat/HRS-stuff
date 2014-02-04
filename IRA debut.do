

clear
set more off


global track_asset08_AH `"/Users/truskinovsky/Documents/Amar/data/trackasset08AH.dta"'

global asset08 `"/Users/truskinovsky/Documents/Amar/data/08/asset08.dta"' 
global HHcover08  `"/Users/truskinovsky/Documents/Amar/data/08/HHcover08.dta"'

global trackerAH `"/Users/truskinovsky/Documents/Amar/data/trackerAH.dta"'

** generate hh level tracker file and merge with asset file
clear
use $trackerAH

* drop K* M*   /* drop variable from other waves that may be miss coded across files */

sort hhid Lsubhh _intrk08 Lfinr   /* sort to make sure that hh representative person is in analysitical sample, financial respondents respondents */ 

duplicates drop hhid Lsubhh, force

tab _intrk08, m

merge 1:1 hhid Lsubhh using $asset08, update replace


tab _intrk08 _merge, m


save $track_asset08_AH, replace

cap drop _merge

merge 1:1  hhid Lsubhh using $HHcover08, update replace
save $track_asset08_AH, replace



*** 



tab LQ162
tab LQ163, m

** gen haveIRA = == 1 if household reports having at least 1 IRA account

gen haveIRA = LQ162 == 1 if _intrk08 == 1
la var haveIRA "reports at least 1 IRA account" 

gen IRAcount = LQ163 if inlist(LQ163, 1, 2, 3, 4)
la var IRAcount" number of IRAS reporting"


#delimit ;
label define LQ165 
1 "respondent" 
2 "partner";
#delimit cr


cap drop ownIRA*
forvalues n = 1/3 {
gen ownIRA`n' = LQ165_`n' if inlist(LQ165_`n', 1,2)
label values ownIRA`n' LQ165
tab ownIRA`n'
}

tab IRAcount

