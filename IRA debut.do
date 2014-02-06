

clear
set more off


global track_asset08_AH `"/Users/truskinovsky/Documents/Amar/data/trackasset08AH.dta"'

global asset08full `"/Users/truskinovsky/Documents/Amar/data/08/asset08full.dta"' 
global HHcover08  `"/Users/truskinovsky/Documents/Amar/data/08/HHcover08.dta"'

global trackerAH `"/Users/truskinovsky/Documents/Amar/data/trackerAH.dta"'


************************************************************
** generate hh level tracker file and merge with asset file
************************************************************


clear
use $trackerAH

* drop K* M*   /* drop variable from other waves that may be miss coded across files */

sort hhid Lsubhh _intrk08 Lfinr   /* sort to make sure that hh representative person is in analysitical sample, financial respondents respondents */ 

duplicates drop hhid Lsubhh, force

tab _intrk08, m

merge 1:1 hhid Lsubhh using $asset08full, update replace



save $track_asset08_AH, replace

cap drop _merge

merge 1:1  hhid Lsubhh using $HHcover08, update replace
save $track_asset08_AH, replace



*** *****

** financial assets: 
set more off

* 1. have financial assets: CDS, Bonds, stocks, 
* how to treat financial assets?

tab _intrk08, m
local finassets LQ316 LQ330 LQ356
foreach asset of local havefinassets{
	tab `asset', m
}

* sum up how many financial assets respondents say YES to
cap drop finassetcount
egen finassetcount = anycount(LQ316 LQ330 LQ356), v(1)

la var finassetcount " count of stocks, bonds, CDs"
tab finassetcount if _intrk08 == 1, m


** gen haveIRA = == 1 if household reports having at least 1 IRA account

gen haveIRA = LQ162 == 1 if _intrk08 == 1
la var haveIRA "reports at least 1 IRA account" 

gen IRAcount = LQ163 if inlist(LQ163, 1, 2, 3, 4)
la var IRAcount" number of IRAS reporting"


#delimit ;
cap label drop LQ165 ;
label define LQ165 
1 "self" 
2 "partner";
#delimit cr


cap drop ownIRA*
forvalues n = 1/3 {
gen ownIRA`n' = LQ165_`n' if inlist(LQ165_`n', 1,2)
label values ownIRA`n' LQ165
tab ownIRA`n'
}

tab IRAcount


** annuities:
* convert any IRAs to annuities since last interview?

tab LQ182 if _intrk08 ==1, m

tab LQ184m1 if _intrk08 ==1, m  
tab LQ184m2 if _intrk08 ==1, m 
tab LQ184m3 if _intrk08 ==1, m
** total of 98 households in this category 

* other annuities: LS270 block:

** LQ273: income from other annuities?

tab LQ273 if _intrk08 ==1, m

tab LQ274 if _intrk08==1, m
* number of annuities, self or both
tab LQ276 if (LQ274 == 1 | LQ274 == 3) & _intrk08==1, m
* number of annuities, partner:
tab LQ296 if LQ274 == 2 & _intrk08 == 1, m

save $track_asset08_AH, replace








