global dofile_repository `"/Users/truskinovsky/Documents/ADDhealth_HRS/HRS_stuff"'
global log `"/Users/truskinovsky/Documents/ADDhealth_HRS/log`c(current_date)'"'

* master data created in pensions_workflow.do
*global track_preload_J08Working `"/Users/truskinovsky/Documents/Amar/data/track_preload_J08Working.dta"'


* files needed for this workflow:

global d_root `"/Users/truskinovsky/Documents/Amar/data"'

global track_asset08_AH `"$d_root/trackasset08AH.dta"'
global track_asset08_AHWorking `"$d_root/trackasset08AHWorking.dta"'


/* note extra level of folders */
global asset08full `"$d_root/08/asset08full.dta"' 
global HHcover08  `"$d_root/08/HHcover08.dta"'

global trackerAH `"$d_root/trackerAH.dta"'
*/


set more off
clear 
use $asset08full
