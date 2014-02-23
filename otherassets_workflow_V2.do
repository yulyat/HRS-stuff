

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
do "$dofile_repository/annuitiesQAssetsQ_v.do"


* 2nd do file: count annuities reporte din Jfile:

do "$dofile_repository/annuitiesJ_v.do"

* merge Q file to master working file: ( this file also assigns self and partner annuities to correct household member)

do "$dofile_repository/mergeQtoMaster_v.do"

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

* frequencies of Assets, annuities, from Q and J file:

tab Lage6 if _intrk08==1,m
tab Lage6 if insample==1,m
tab jstatus08 if insample==1,m
tab Lage6 jstatus08 if insample==1,m
tab numpenblocks if insample==1,m
tab numpenblocks jstatus08 if insample==1,m
tab pensionactiveA if insample==1,m
tab pensionactiveA jstatus08 if insample==1,m
tab pensionactiveB if insample==1,m
tab pensionactiveB jstatus08 if insample==1,m
tab pensionactiveAB if insample==1,m
tab pensionactiveDK if insample==1,m
tab pensionactiveA1 jstatus08 if insample==1,m
tab pensionactiveB1 jstatus08 if insample==1,m
tab pensionalltype if insample==1,m
tab pensionalltype jstatus08 if insample==1,m
tab IRA_Q if insample==1,m
tab IRA_Q jstatus08 if insample==1,m
tab annu_all if insample==1,m
tab annu_all jstatus08 if insample==1,m
tab accountalltype if insample==1,m
tab accountalltype jstatus08 if insample==1,m
tab accountalltype pensionalltype if insample==1,m
tab accountalltype pensionalltype if insample==1 & working08==1,m
tab accountalltype pensionalltype if insample==1 & retired08==1,m
