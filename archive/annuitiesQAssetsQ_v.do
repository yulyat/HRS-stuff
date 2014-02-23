

************************************************************
** generate hh level tracker file and merge with asset file
************************************************************

/* 
this do file uses the financial assets Q file, and counts financial assets, IRAS and annuities
it prepares self and partner level variables where appropriate to merge with individual level 
track_J08 file 

*/

******

clear 
use $asset08full

set more off

save $asset08_AHWorking, replace


** financial assets: 


* 1. have financial assets: CDS, Bonds, stocks, 
* how to treat financial assets?
/*
local finassets LQ316 LQ330 LQ356
foreach asset of local havefinassets{
	tab `asset', m
}

*/

* sum up how many financial assets respondents say YES to
    cap drop finassetcount
    egen finassetcount = anycount(LQ316 LQ330 LQ356), v(1)

    la var finassetcount " count of stocks, bonds, CDs"


** gen haveIRA = == 1 if household reports having at least 1 IRA account

    gen haveIRA = LQ162 == 1 
    la var haveIRA "reports at least 1 IRA account" 



* assign IRA to self(1 ) or partner (2):


      #delimit ;
      cap label drop LQ165 ;
      label define LQ165 
      1 "self" 
      2 "partner";
      #delimit cr

  cap drop IRA_round*
  forvalues n=1/3 { 
  		gen IRA_round`n' = 1 if inlist(LQ165_`n', 1, 8,9)
  		replace IRA_round`n' = 2 if LQ165_`n' ==  2
  		label values IRA_round`n' LQ165
		if (`n'==3){
			gen IRA_round4 = 1 if inlist(LQ165_3, 1, 8,9) & LQ163==4
			replace IRA_round4 = 2 if LQ165_3 ==  2 & LQ163 == 4
			label values IRA_round4 LQ165
			}
			
  	}


	cap drop IRA_self IRA_partner IRA_all

	egen IRA_self = anycount(IRA_round*), v(1)
	replace IRA_self = . if mi(LQ162)


	egen IRA_partner = anycount(IRA_round*), v(2)
	replace IRA_partner = . if mi(LQ162)
	
	egen IRA_all = anycount(IRA_round*), v(1 2)
	replace IRA_all = . if mi(LQ162)
	



** annuities:
* annuQ1 - Q182 loop
* convert any IRAs to annuities since last interview?
/* note: if report dk, don't know whos it is - how to count*/

    cap drop annuQ1_have
    gen annuQ1_have = LQ182 
    replace annuQ1_have = 0 if LQ182 == 5
    replace annuQ1_have = -1 if (LQ182 == 8 | LQ182 == 9)
    
	cap drop annuQ1_convert annuQ1_self annuQ1_partner
	egen annuQ1_convert = anymatch(LQ184*), v(2)
	
	gen annuQ1_self = 0
	replace annuQ1_self = annuQ1_convert if inlist(LQ183, 1, 3, 8, 9) 
	replace annuQ1_self = . if  mi(LQ182) 

	gen annuQ1_partner = 0
	replace annuQ1_partner = annuQ1_convert if LQ183 == 2 & annuQ1_convert == 1  
	replace annuQ1_partner = . if mi(LQ182) 
	
	gen annuQ1_all = 0
	replace annuQ1_all = annuQ1_convert
	replace annuQ1_all = . if mi(LQ182)


* other annuities: LS270 block: annuQ2:

** LQ273: income from other annuities?

    cap drop annuQ2_have
    gen annuQ2_have = LQ273
    replace annuQ2_have = 0 if LQ273 == 5
    replace annuQ2_have = -1 if (LQ273 == 8 | LQ273 == 9)


    cap drop  annuQ2_self annuQ2_partner
	
    gen annuQ2_self = 0
	replace annuQ2_self = LQ276 if LQ276!=. 
    replace annuQ2_self = 1 if inlist(LQ276, 98, 99)
    replace annuQ2_self = . if mi(LQ273)

    gen annuQ2_partner = 0
	replace annuQ2_partner = LQ296 if LQ296!=.
	replace annuQ2_partner = 1 if inlist(LQ296, 98, 99)
    replace annuQ2_partner = . if mi(LQ273)


    save $asset08_AHWorking, replace








