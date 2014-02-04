  

* this do file takes the merged dataset track_preload_J08.dta, creates a copy and saves 
* it in the same folder,  and generates tables for 
* pension block particular from jfile

* locate data set and create a working copy:
global track_preload_J08 `"/Users/truskinovsky/Documents/Amar/data/track_preload_J08.dta"'
global track_preload_J08Working `"/Users/truskinovsky/Documents/Amar/data/track_preload_J08Working.dta"'

global dofile_repository `"/Users/truskinovsky/Documents/ADDhealth_HRS/HRS_stuff"'

clear 
use $track_preload_J08
save "$track_preload_J08Working", replace



/* 1st dofile Pensions1.do: create basic variables necessary for analysis of pensions:
    _intrk08 - variable identifies which observations participated in 2008
	gender
	LAge6    - 6 category age variable, matching addhealth tables
	combo0608 -12 category variable accounting for status and transtions
				between 06 and 08
	Jstatus08 - working and retirement status as reported in 06	
	oldNH - dummy variable  for if respondent is over 70 or lives in a nursing home full time	 				
do
*/

do "$dofile_repository/pensions_1.do"

/* 2nd dofile PEnsions2.do: creates all the variables relevant for accounting for pensions and types
	note naming system: 
	pen1 = past pensions from preload
	pen2 = first pension block in j section: askes aobut previous pensions for those who have changed 
			working status since the last wave
	pen3 = second pension block in j section: everybody who is working n 08 is asked this
	pen4 = old pensions not already mentioned - 3rd pension block in jfile: everybody gets this who is 
			not over 70 /full time nursing home

*/

do "$dofile_repository/pensions_2.do"


  *******
  *Tables
  *******
  
  /*variables used in this file
  */

	
* asked not asked by status: each column is percent of obs in that status that are 
* asked that penblock	
local blocks pen1 pen2 pen3 pen4

	foreach var of local blocks {
		qui estpost tab comb0608 `var'indicator if _intrk08 == 1, m
		esttab, cell(rowpct(fmt(2))) noobs unstack  varlabels(`e(labels)') ///
		eqlabels(, lhs("0608 Status")) ///
		title(Crosstab of Status with `var')
	}

** number of pensionblocks asked per person:
di" number of pension blocks asked per person" 
tab numpenblocks if _intrk08==1, m

local covars comb0608 jstatus08 Lage6 gender Lfinr
foreach var of local covars{
	tab `var' numpenblocks if _intrk08 ==1, m
}

** everythingn that follows is just fo those who are asked:
* 	pen1 (past pension block from preload)
** of those who have pen1, how many pensions do they report?
	di"of those who have pen1, how many pensions do they describe?"
	 tab pen1_total if pen1indicator == 1 & _intrk08 ==1, m


	 local types A B
	 foreach n of local types {
	 di"how many `n' total"
	 tab pen1`n'_total if _intrk08 == 1, m
	 di"how many `n' active"
	 tab pen1`n'_active if _intrk08 == 1, m

	 }
	 

* pen2( previously penblock1):
	di"of those who have pen2, how many pensions do they report?"
	tab pen2_report if pen2indicator == 1 & _intrk08 ==1, m
	
	di"of those who have pen2, how many pensions do they describe?"
	tab pen2_total if pen2indicator == 1 & _intrk08 ==1, m
	



	 local types A B AB DK
	 foreach n of local types {
	 di"how many `n' total"
	 cap tab pen2`n'_total if _intrk08 == 1, m
	 di"how many `n' active"
	 tab pen2`n'_active if _intrk08 == 1, m

	 }
	 
* pen3: 

	di"of those who have pen3, how many pensions do they report?"
	tab pen3_report if pen3indicator == 1 & _intrk08 ==1, m
	
	di"of those who have pen3, how many pensions do they describe?"
	tab pen3_total if pen3indicator == 1 & _intrk08 ==1, m
	



	 local types A B AB DK
	 foreach n of local types {
	 di"how many `n' total"
	 cap tab pen3`n'_total if _intrk08 == 1, m
	 
	 }


* pen4:
 
 di"who has ppensions block 4"

 tab pen4 if _intrk08 == 1, m

***
 
*Totals across block by type:

 		local types pensiontotal  pensiontotalA  pensiontotalB pensiontotal4
 		foreach n of local types {
 			di "`n' "
 			tab `n' if _intrk08 ==1, m
  			}

	local types pensiontotactive  pensionactiveA  pensionactiveB
 		foreach n of local types {
 			di "`n' "
 			tab `n' if _intrk08 ==1, m
  			}
  			
  			
		local types pensiontotactive  pensionactiveA  pensionactiveB pensiontotal4
 		local covars comb0608 jstatus08 Lage6 gender Lfinr
 		foreach n of local types {
 			foreach var of local covars{
 				 di "how many active `n' types by `var'"
 				 tab `var' `n' if _intrk08 ==1, m 

 			}
 			}
 	
