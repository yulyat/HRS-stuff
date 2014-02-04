  

* this do file takes the merged dataset track_preload_J08.dta, creates a copy and saves 
* it in the same folder,  and generates tables for 
* pension block particular from jfile

* locate data set and create a working copy:
global track_preload_J08 `"/Users/truskinovsky/Documents/Amar/data/track_preload_J08.dta"'
global track_preload_J08Working `"/Users/truskinovsky/Documents/Amar/data/track_preload_J08Working.dta"'

global dofile_repository `"/Users/truskinovsky/Documents/ADDhealth HRS/HRS stuff "'

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

	local blocks pen1 pen2 pen3 pen4

	foreach var of local blocks {
		di "cross tab of "
		tab combo0608 `var' if _intrk08 ==1, m
	}

	tab pastpenblock if _intrk08 == 1, m
	
	
	*2. how many pensions listed per person, total and active:
	tab pbpst_total
	tab pbpst_totactive
	
	*3: of those listed, how many are type A, B, overall and still active:
	tab penblkpstA if pastpenblock == 1
	tab penblkpstB if pastpenblock == 1

	tab penblkpst2A if pastpenblock == 1 
	tab penblkpst2B if pastpenblock == 1 
	tab penblkpstCO if pastpenblock == 1

  
**  pension block 1 particulars:
 
  *	1. number of people who get pension block 1/ report having this type of pension block
  		
  		tab penblock1 if _intrk08 ==1, m
  		
 *	2. how many pensions people say they have
 		 
 		tab penblk1_report if penblock1 == 1, m

 *	3. how many pensions people list - total and active:
 
 tab penblk1total
 tab penblk1totactive
 


 *	4. of those listed, how many type a, type b, both, total and still active:
  
 		
		local types A B AB 
		
		foreach n of local types {
			di "number of pension types `n' per person"
			tab penblk1`n' if penblock1 == 1
			di "number of active  pension types `n' per person"
			tab penblk12`n' if penblock1 == 1
			}
			

**  pension block 2 particulars:
 
  *	1. number of people who get pension block 2 report having this type of pension block
  		
  		tab penblock2 if _intrk08 ==1, m
  		
 *	2. how many pensions people say they have
 		 
 		tab penblk2_report if penblock2 == 1, m

 *	3. how many pensions people list - total and active:
 
 tab penblk2total
 


 *	4. of those listed, how many type a, type b, both:
  
 		
		local types A B AB 
		
		foreach n of local types {
			di "number of pension types `n' per person"
			tab penblk2`n' if penblock2 == 1
			
			}


** total number of pensions across all blocks, total reported and total active:

tab pensiontotal

tab pensiontotactive		

tab pensiontotalA
tab pensiontotal2A
 
tab pensiontotalB
tab pensiontotal2B

tab pensiontotal if oldNH != 1

tab pensiontotactive	if oldNH != 1	

tab pensiontotalA if oldNH != 1
tab pensiontotal2A if oldNH != 1
 
tab pensiontotalB if oldNH != 1
tab pensiontotal2B if oldNH != 1

