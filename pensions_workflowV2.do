  

* this do file takes the merged dataset track_preload_J08.dta, creates a copy and saves 
* it in the same folder,  and generates tables for 
* pension block particulars from jfile
* Latest version(V2): 2-23-14

**********
**Set Up**
**********

/*
* Vladi Set up
* locate data set and create a working copy:
use "C:\Users\vvs3\Desktop\Work\SethMeeting\NewY\Data\track_preload_J08.dta"
global track_preload_J08 `"C:\Users\vvs3\Desktop\Work\SethMeeting\NewY\Data\track_preload_J08.dta"'
global track_preload_J08Working `"C:\Users\vvs3\Desktop\Work\SethMeeting\NewY\Data\track_preload_J08Working.dta"'

global dofile_repository `"C:\Users\vvs3\Desktop\Work\SethMeeting\NewY\programs"'
*/

* Yulya Set up
* locate data set and create a working copy:
global track_preload_J08 `"/Users/truskinovsky/Documents/Amar/data/track_preload_J08.dta"'
global track_preload_J08Working `"/Users/truskinovsky/Documents/Amar/data/track_preload_J08Working.dta"'

global dofile_repository `"/Users/truskinovsky/Documents/ADDhealth_HRS/HRS_stuff"'

clear 
use $track_preload_J08
save "$track_preload_J08Working", replace


*********START**************


clear 
use $track_preload_J08
save "$track_preload_J08Working", replace

set more off 

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

do "$dofile_repository/pensions_1V2.do"

/* 2nd dofile PEnsions2.do: creates all the variables relevant for accounting for pensions and types
	note naming system: 
	pen1 = past pensions from preload
	pen2 = first pension block in j section: askes aobut previous pensions for those who have changed 
			working status since the last wave
	pen3 = second pension block in j section: everybody who is working n 08 is asked this
	pen4 = old pensions not already mentioned - 3rd pension block in jfile: everybody gets this who is 
			not over 70 /full time nursing home

*/

do "$dofile_repository/pensions_2V2.do"


  *******
  *Tables
  *******
  
  /*variables used in this file
  */

	
* asked not asked by status: each column is percent of obs in that status that are 
* asked that penblock	
