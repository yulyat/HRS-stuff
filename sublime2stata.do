clear
use $trackerAH 

** many to 1 merge on hhid, Lsubhh, pn, tracker to assetfile 
cap drop _merge
merge 1:m hhid Lsubhh pn using $track_asset08_AH, update replace

