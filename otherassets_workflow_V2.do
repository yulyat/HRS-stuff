

/* this do file runs programs that count annuities, IRAs and other financial assets in the J individual level files and the Q 
household level files, and merges them together, building on the master data built in pensions_workflow.do
** Latest version (V2): 2-23-14
*/

* data location macros:
* do file repository:

/* Vladi set up
use "C:\Users\vvs3\Desktop\Work\SethMeeting\NewY\Data\track_preload_J08.dta"
global track_preload_J08 `"C:\Users\vvs3\Desktop\Work\SethMeeting\NewY\Data\track_preload_J08.dta"'
global track_preload_J08Working `"C:\Users\vvs3\Desktop\Work\SethMeeting\NewY\Data\track_preload_J08Working.dta"'

global dofile_repository `"C:\Users\vvs3\Desktop\Work\SethMeeting\NewY\programs"'

clear 
use $track_preload_J08Working
*save "$track_preload_J08Working", replace


* files needed for this workflow:

global d_root `"C:\Users\vvs3\Desktop\Work\SethMeeting\NewY\Data"'

global track_asset08_AH `"$d_root\trackasset08AH.dta"'
global asset08_AHWorking `"$d_root\asset08AHWorking.dta"'


/* note extra level of folders */
global asset08full `"$d_root\asset08full.dta"' 
*global HHcover08  `"$d_root\HHcover08.dta"'

*global trackerAH `"$d_root\trackerAH.dta"'
*/

* Yulya set up
global dofile_repository `"/Users/truskinovsky/Documents/ADDhealth_HRS/HRS_stuff"'

* master data created in pensions_workflow.do
global track_preload_J08Working `"/Users/truskinovsky/Documents/Amar/data/track_preload_J08Working.dta"'


* files needed for this workflow:

global d_root `"/Users/truskinovsky/Documents/Amar/data"'

global track_asset08_AH `"$d_root/trackasset08AH.dta"'
global asset08_AHWorking `"$d_root/asset08AHWorking.dta"'


/* note extra level of folders */
global asset08full `"$d_root/08/asset08full.dta"' 
global HHcover08  `"$d_root/08/HHcover08.dta"'

global trackerAH `"$d_root/trackerAH.dta"'
*/


set more off

* 1st do file: count IRAs and annuities in household level Q file
do "$dofile_repository/annuitiesQAssetsQ_V2.do"


* 2nd do file: count annuities reporte din Jfile:

do "$dofile_repository/annuitiesJ_V2.do"

* merge Q file to master working file: ( this file also assigns self and partner annuities to correct household member)

do "$dofile_repository/mergeQtoMaster_V2.do"

* assign spouses working status 


tab Lcouple Lfinr if _intrk08 == 1, m

keep if _intrk08 == 1
cap drop couple
egen couple = group(hhid Lsubhh) if _intrk08 == 1

/* qui levelsof(couple), local(fam)

cap drop insamplesp

gen insamplesp = . 

sort couple Lfinr

foreach var of local fam{


	if couple == `var' & Lcouple == 1 & Lfinr == 1 {
		replace insamplesp = insample[_n+1]
	}

	else if couple == `var' & Lcouple == 1 & (Lfinr == 5 | Lfinr == 3){
		replace insamplesp = insamplesp[_n-1]
	 	}

	else if couple == `var' & Lcouple == 5 {
		replace insamplesp = insample 

	 	}	
   
} */

** summing up annuities
egen annu_all = rowtotal(annuQ1_Q annuQ2_Q annuJ1_total annuJ2_total)
replace annu_all=. if annuQ1_Q==. & annuQ2_Q==. & annuJ1_total==. & annuJ2_total==.
replace insample=0 if insample==1 & (annu_all==. | IRA_Q==.)


** generate account all type variable: annuities, IRAS, income from pensions 
cap drop accountalltype
gen accountalltype=.
replace accountalltype=-1 if insample==1
replace accountalltype=0 if insample==1 & IRA_Q==0 & annu_all==0 & penincome_Q == 0
replace accountalltype=1 if insample==1 & IRA_Q==1 & annu_all==0
replace accountalltype=2 if insample==1 & IRA_Q>1 & annu_all==0
replace accountalltype=3 if insample==1 & IRA_Q==0 & annu_all>0
replace accountalltype=4 if insample==1 & IRA_Q>0 & annu_all>0
replace accountalltype=5 if insample==1 & IRA_Q==0 & annu_all == 0 & penincome_Q > 0
replace accountalltype=6 if insample==1 & IRA_Q==0 & annu_all == 0 & penincome_Q > 1
replace accountalltype=7 if insample==1 & (penincome_Q > 0 & (annu_all>0| IRA_Q>0) |(IRA_Q>0 & annu_all>0))



#delimit ;
cap label drop assettype;
label define assettype
 -1 "Not asked" 
 0 "No IRA, annuity, pen income" 
 1 "One IRA reported" 
 2 "More than one IRA reported" 
 3 "Only annuity reported"	
 4 "IRAs and anuity reported"
 5 "only pen income reported"
 6 "multipe pension income"
 7 "Pen income + IRA &/or annuity";
label value accountalltype assettype;
#delimit ;


* working not retired into 3 ages: 55-59, 60-64, 65-69:
cap drop worknr3
gen worknr3 = . 
replace worknr3 = 1 if jstatus08 == 3 & Lage6 == 3
replace worknr3 = 2 if jstatus08 == 3 & Lage6 == 4
replace worknr3 = 3 if jstatus08 == 3 & Lage6 == 5

cap label drop worknr3
label define worknr3 1 "55-59" 2 "60-64" 3 "65-69"
label values worknr3 worknr3
label variable worknr3 "working not retired by age"




** creating sample weights to match addhealth parent study distribution
cap drop n_type
gen n_type = .
forvalues n = 1/6 {
	egen freq`n' = count(Lage6) if Lage6 == `n' & insample == 1
	replace n_type = freq`n' if Lage6 == `n' & insample == 1
}
tab n_type


	** distribution in addhealth parent:
gen N_type = .
replace N_type = 27 if Lage6 == 1 & insample == 1 
replace N_type = 527 if Lage6 == 2 & insample == 1
replace N_type = 2992 if Lage6 == 3 & insample == 1
replace N_type = 4323 if Lage6 == 4 & insample == 1
replace N_type = 3504 if Lage6 == 5 & insample == 1
replace N_type = 1991 if Lage6 == 6 & insample == 1

cap drop weight
gen weight = round(N_type/n_type, .1) if insample == 1

tab Lage6 if insample == 1 [aw=weight]

* frequencies of Assets, annuities, from Q and J file:

tab Lage6 if _intrk08==1,m
tab Lage6 if insample==1,m
tab jstatus08 if insample==1,m
tab Lage6 jstatus08 if insample==1,m
tab worknr3 if insample ==1, m  

tab numpenblocks if insample==1,m
tab numpenblocks jstatus08 if insample==1,m

tab pensionactiveA if insample==1,m
tab pensionactiveA jstatus08 if insample==1,m
tab pensionactiveA worknr3 if insample==1,m

tab pensionactiveB if insample==1,m
tab pensionactiveB jstatus08 if insample==1,m
tab pensionactiveB worknr3 if insample==1,m

tab pensionactiveAB if insample==1,m
tab pensionactiveDK if insample==1,m
tab pensionactiveA1 jstatus08 if insample==1,m
tab pensionactiveB1 jstatus08 if insample==1,m

tab pensionalltype if insample==1,m
tab pensionalltype jstatus08 if insample==1,m
tab pensionalltype worknr3 if insample==1,m

tab IRA_Q if insample==1,m
tab IRA_Q jstatus08 if insample==1,m
tab IRA_Q worknr3 if insample==1,m

tab annu_all if insample==1,m
tab annu_all jstatus08 if insample==1,m
tab annu_all worknr3 if insample==1,m

tab accountalltype if insample==1,m
tab accountalltype jstatus08 if insample==1,m
tab accountalltype worknr3 if insample==1,m

tab pensionalltype if insample==1,m
tab accountalltype pensionalltype if insample==1 & working08==1,m
tab accountalltype pensionalltype if insample==1 & retired08==1,m
