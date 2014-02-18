

/* this do file runs programs that count annuities, IRAs and other financial assets in the J individual level files and the Q 
household level files, and merges them together, building on the master data built in pensions_workflow.do
*/

* data location macros:
* do file repository:
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

set more off

* 1st do file: count IRAs and annuities in household level Q file
do "$dofile_repository/annuitiesQAssetsQ.do"


* 2nd do file: count annuities reporte din Jfile:

do "$dofile_repository/annuitiesJ.do"

* merge Q file to master working file: ( this file also assigns self and partner annuities to correct household member)

do "$dofile_repository/mergeQtoMaster.do"


* frequencies of Assets, annuities, from Q and J file:


tab IRA_Q, m
tab annu1_Q, m
tab annu2_Q, m

tab annuJ1_total, m
tab annuJ2_total, m