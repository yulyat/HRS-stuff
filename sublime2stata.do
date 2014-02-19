clear
use $track_preload_J08Working

** many to 1 merge on hhid, Lsubhh, pn, Jfile to assetfile 
cap drop _merge
cap drop Ksubhh
cap drop lvdate lversion
merge m:1 hhid Lsubhh  using $asset08_AHWorking, update replace

