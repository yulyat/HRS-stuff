cap drop worknr3
gen worknr3 = . 
replace worknr3 = 1 if jstatus08 == 3 & Lage6 == 3
replace worknr3 = 2 if jstatus08 == 3 & Lage6 == 4
replace worknr3 = 3 if jstatus08 == 3 & Lage6 == 5

cap label drop worknr3
label define worknr3 1 "55-59" 2 "60-64" 3 "65-69"
label values worknr3 worknr3
label variable worknr3 "working not retired by age"

tab worknr3

