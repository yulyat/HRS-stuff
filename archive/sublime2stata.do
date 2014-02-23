cap drop couple
egen couple = group(hhid Lsubhh) if _intrk08 == 1


qui levelsof(couple), local(fam)

cap drop jstatus08sp

gen jstatus08sp = . 

sort couple Lfinr

foreach var of local fam{


	if couple == `var' & Lcouple == 1 & Lfinr == 1 {
		replace jstatus08sp = jstatus08[_n+1]
	}

	else if couple == `var' & Lcouple == 1 & (Lfinr == 5 | Lfinr == 3){
		replace jstatus08sp = jstatus08[_n-1]
	 	}

	else if couple == `var' & Lcouple == 5 {
		replace jstatus08sp = -1 

	 	}	
   
}

