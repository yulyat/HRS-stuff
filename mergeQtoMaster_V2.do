* merge asset file to respondent:


clear
use $track_preload_J08Working

** many to 1 merge on hhid, Lsubhh, pn, Jfile to assetfile 
cap drop _merge
cap drop Ksubhh
cap drop lvdate lversion
merge m:1 hhid Lsubhh  using $asset08_AHWorking, update replace


cap drop IRA_Q annuQ1_Q  annuQ2_Q penincome_Q

local assets IRA annuQ1 annuQ2 penincome

foreach var of local assets{
	gen `var'_Q = 0 if _intrk08 == 1 
	replace `var'_Q = `var'_self if Lfinr ==1
	replace `var'_Q = `var'_partner if (Lfinr == 5 | Lfinr == 3)
}


