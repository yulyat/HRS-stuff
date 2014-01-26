  *******
  *Tables
  *******
  
  *  variables used in this file:
  
** past pension block :

	*1. number of people have a past pension:
	tab pastpenblock if _intrk08 == 1, m
	
	
	*2. how many pensions listed per person, total and active:
	tab pbpst_total
	tab pbpst_totactive
	
	*3: of those listed, how many are type A, B, overall and still active:
	tab penblkpstA if pastpenblock == 1
	tab penblkpstB if pastpenblock == 1

	tab penblkpst2A if pastpenblock == 1 
	tab penblkpst2B if pastpenblock == 1 
	tab penblkpstCO if pastpenblock == 1

  
**  pension block 1 particulars:
 
  *	1. number of people who get pension block 1/ report having this type of pension block
  		
  		tab penblock1 if _intrk08 ==1, m
  		
 *	2. how many pensions people say they have
 		 
 		tab penblk1_report if penblock1 == 1, m

 *	3. how many pensions people list - total and active:
 
 tab penblk1total
 tab penblk1totactive
 


 *	4. of those listed, how many type a, type b, both, total and still active:
  
 		
		local types A B AB 
		
		foreach n of local types {
			di "number of pension types `n' per person"
			tab penblk1`n' if penblock1 == 1
			di "number of active  pension types `n' per person"
			tab penblk12`n' if penblock1 == 1
			}
			
		

 
