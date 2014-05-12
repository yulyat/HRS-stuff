egen annu_all = rowtotal(annuQ1_Q annuQ2_Q annuJ1_total annuJ2_total)
replace annu_all=. if annuQ1_Q==. & annuQ2_Q==. & annuJ1_total==. & annuJ2_total==.
replace insample=0 if insample==1 & (annu_all==. | IRA_Q==. |penincome_Q==.)


** generate account all type variable: annuities, IRAS, income from pensions 
cap drop accountalltype
gen accountalltype=.
replace accountalltype=-1 if insample==1
replace accountalltype=0 if insample==1 & IRA_Q==0 & annu_all==0 & penincome_Q == 0
replace accountalltype=1 if insample==1 & IRA_Q==1 & annu_all==0 & penincome_Q == 0
replace accountalltype=2 if insample==1 & IRA_Q>1 & annu_all==0 & penincome_Q ==0
replace accountalltype=3 if insample==1 & IRA_Q==0 & annu_all>0 & penincome_Q ==0
replace accountalltype=4 if insample==1 & IRA_Q>0 & annu_all>0 & penincome_Q == 0
replace accountalltype=5 if insample==1 & IRA_Q==0 & annu_all == 0 & penincome_Q > 0
replace accountalltype=6 if insample==1 & IRA_Q==0 & annu_all == 0 & penincome_Q > 1
replace accountalltype=7 if insample==1 & (penincome_Q > 0 & (IRA_Q>0 | annu_all>0))



#delimit ;
cap label drop assettype;
label define assettype
 -1 "Not asked" 
 0 "No IRA, ann. or pens." 
 1 "One IRA reported"  
 2 ">1 IRAs reported" 
 3 "One annuity reported"	
 4 "IRAs and annuities"
 5 "One pension reported"
 6 "Multiple pensions"
 7 "Pens. + IRA &/or ann.";
label value accountalltype assettype;
#delimit cr 


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
gen weight = N_type/n_type if insample == 1


capture log close
set logtype text
log using "$log", replace
set more off

* frequencies of Assets, annuities, from Q and J file:

tab Lage6 if _intrk08==1,m
tab Lage6 if insample==1,m
tab Lage6 [aweight=weight] if insample==1,m
