  *******
  *Tables
  *******
  
  *  variables used in this file:
  
  1
  
 2. pension block 1 particulars:
 
  *	1. number of people who get pension block 1/ report having this type of pension block
  		
  		tab penblock1 if _intrk08 ==1, m
  		
 *	2. how many pensions people say they have
 		 
 		tab penblk1_report if penblock1 == 1, m

 *	3. how many pensions people list
 
 		tab penblk1_list if penblock1 == 1, m
 		
 * 3.5 comparison:
 	
 		tab penblk1_report penblk1_list if penblock1 == 1, m
		

	* total number of pensions per person, cashed out and not cashed out: 
		
		tab penblk1total if penblock1 == 1, m
		tab penblk1total_co if penblock1 == 1, m

 *	4. of those listed, how many type a, type b, both or cashed out. 
 		
		local types A B AB CO rf
		
		foreach n of local types {
			di "number of pension types `n' per person"
			tab penblk1`n' if penblock1 == 1
			}
			
		
		
 
 

