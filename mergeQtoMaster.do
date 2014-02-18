* merge asset file to respondent:


clear
use $track_preload_J08Working

** many to 1 merge on hhid, Lsubhh, pn, Jfile to assetfile 
cap drop _merge
merge m:1 hhid Lsubhh  using $asset08_AHWorking, update replace


cap drop IRA_Q annu1_Q  annu2_Q

local assets IRA annuQ1 annuQ2

foreach var of local assets{
	gen `var'_Q = . 
	replace `var'_Q = `var'_self if Lfinr ==1
	replace `var'_Q = `var'_partner if (Lfinr == 5 | Lfinr == 3)
}




/* nonmissing conflict for 621 obs? = otherwise everybody merges
** identify partners:

keep if _intrk08 == 1
cap drop couple
egen couple = group(hhid Lsubhh) 


qui levelsof(couple), local(fam)

cap drop IRA_Q annu1_Q  annu2_Q

gen IRA_Q = .
gen annu1_Q = .
gen annu2_Q = .

foreach var of local fam{
	qui replace IRA_Q = IRA_self if couple == `var' & Lfinr == 1
	qui replace IRA_Q = IRA_partner if couple == `var' & (Lfinr == 5 | Lfinr == 3)

	qui replace annu1_Q = annuQ1_self if couple == `var' & Lfinr == 1
	qui replace annu1_Q = annuQ1_partner if couple == `var' & (Lfinr == 5 | Lfinr == 3)

	qui replace annu2_Q = annuQ2_self if couple == `var' & Lfinr == 1
	qui replace annu2_Q = annuQ2_partner if couple == `var' & (Lfinr == 5 | Lfinr == 3)



}
*/

