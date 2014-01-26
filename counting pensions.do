** counting pensions:

#delimit ;
			label drop pentype;
			label define pentype 
			0 "NA"
			1 "A"
			2 "B"
			3 "A&B"
			4 "cashed out"
			8 "DK/RF";
			#delimit cr


*********
**past pen block
*********

tab pastpenblock

* how many pensions per person
LZ140_1 LZ140_2 LZ140_3 LZ140_4
tab LZ140_1


cap drop penblkpst_total

egen penblkpst_total = anycount(LZ140*), v(1 2 3 4)
replace penblkpst_total = . if _intrk08 != 1
tab penblkpst_total


by type:
		cap drop penblkpst_type*
		local i = 1
		forvalues n = 1/4 {

			gen penblkpst_type`n' = 1 if inlist(LZ140_`n', 1, 3) 
			replace penblkpst_type`n' = 2 if inlist(LZ140_`n', 2, 4) 
		
			tempvar pnstat
			if (`i' == 1 | `i' == 2) {
				egen `pnstat' = anymatch(LJ434_`n'm1 LJ434_`n'm2 LJ434_`n'm3 LJ434_`n'm4 LJ450_`n'm1 LJ450_`n'm2 LJ450_`n'm3 LJ450_`n'm4 ), v(1 2)
			}
			else if `i' == 3 {
				egen `pnstat' = anymatch(LJ434_`n'm1 LJ434_`n'm2 LJ434_`n'm3 LJ450_`n'm1 LJ450_`n'm2 LJ450_`n'm3), v(1 2)
			}
			else if `i' == 4 {
				egen `pnstat' = anymatch(LJ434_`n'm1 LJ434_`n'm2  LJ450_`n'm1 LJ450_`n'm2), v(1 2)
			}
		
		
		replace penblkpst_type`n' = 4 if `pnstat' == 1
		la values penblkpst_type`n' pentype
		tab penblkpst_type`n'
		local i = `i' + 1
		}

		
	
	
		
		
		/* past pen block result --> 1 if still expecting to or currently recieving  benefits
  		 0 if cashed out, rolled over, lost, or record innacurate */

		tab LJ434_1m1 LZ140_1 if _intrk08 ==1, m /* what are you doing with the type A account*/
		tab LJ450_1m1 LZ140_1 if _intrk08 ==1, m /* what are you doing with the type B account  */

		egen pastpenblockresult = anymatch(LJ434_1m1 LJ450_1m1), v(1 2)
		replace pastpenblockresult = . if _intrk08 != 1
		label variable pastpenblockresult pastpenblockresult
		tab pastpenblockresult




***********
** block 1
***********
tab penblock1 if _intrk08 ==1, m

** how many pensions per person
tab LJ085 penblock1 if _intrk08 ==1 ,m
tab LJ086 penblock1 if LJ085 == 98 & _intrk08 ==1 ,m

* generate penblk1_report = in pension block 1, how many pensions do peopel REPORT having
cap drop penblk1_report
gen penblk1_report = LJ085 
replace penblk1_report = 0 if inlist(LJ085,95, 99)
replace penblk1_report = 1 if LJ085 == 98 & LJ086 == 1
replace penblk1_report = 0 if LJ085 == 98 & inlist(LJ086, 8,9)

tab penblk1_report penblock1 if _intrk08 == 1, m


* generate penblk1_list  - how many pensions do people LIST (actually describe)
* if say don't know or rf for both, don't count the pension

cap drop penblk1_list
gen penblk1_list = 0 if penblock1 ==1
local rounds a b c d
foreach n of local rounds {
	replace penblk1_list = penblk1_list + 1 if inlist(LJw082`n', 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
	replace penblk1_list = penblk1_list + 1 if inlist(LJw082`n',97,98,99) & inlist(LJw001`n', 1,2,3)  
	}
	
tab penblk1_list	 

tab penblk1_report penblk1_list if penblock1 == 1, m


tab penblk1_total penblk1_list


**Break down by type. 
** how many of each type: 

		

			
		cap drop penblk1type*
		set trace off
		local rounds a b c d
		local i = 1  
		foreach n of local rounds {
		gen penblk1type`n' = 0 if penblock1 == 1
		replace penblk1type`n' = 1 if inlist(LJw082`n', 3, 12, 16)
		replace penblk1type`n' = 2 if inlist(LJw082`n', 1,2,4,5,6,7,8,9,10,11,13,14)
		replace penblk1type`n' = 3 if LJw082`n' == 15
		replace penblk1type`n' = 8 if inlist(LJw082`n', 97,98,99)


		replace penblk1type`n'  = 1 if penblk1type`n' == 8 & LJw001`n' == 1
		replace penblk1type`n'  = 2 if penblk1type`n' == 8 & LJw001`n' == 2
		replace penblk1type`n'  = 3 if penblk1type`n' == 8 & LJw001`n' == 3
		
		tempvar pnstat
		if (`i' == 1 | `i' == 2) {
			egen `pnstat' = anymatch(LJw097m1`n' LJw097m2`n' LJw097m3`n' LJw097m4`n'), v(8 3 5 7)
			}
		else if `i' == 3 {
			egen `pnstat' = anymatch(LJw097m1`n' LJw097m2`n' LJw097m3`n'), v(8 3 5 7)
			}
		else if `i' == 4 {
			egen `pnstat' = anymatch(LJw097m1`n' LJw097m2`n'), v(8 3 5 7)
			}
		
		tab `pnstat'
		replace penblk1type`n' = 4 if `pnstat' == 1
		la values penblk1type`n' pentype

		local i = `i' + 1
		}
	
	
	 		
	** count up number of each type per person
		
		local rounds a b c d
		foreach n of local rounds {
		tab penblk1type`n' if penblk1total == 1 & penblk1_list == 0 
		}
		
		local rounds a b c d
		foreach n of local rounds {
		tab LJw082`n' LJw001`n' if penblk1total == 1 & penblk1_list == 0 
		}
		
		cap drop penblk1total penblk1total_co penblk1A penblk1B penblk1AB penblk1CO penblk1rf

		egen penblk1total = anycount(penblk1type*), v(1 2 3 4)
		egen penblk1total_co = anycount(penblk1type*), v(1 2 3)


	
	
		egen penblk1A = anycount(penblk1type*), v(1)
		replace penblk1A = . if penblock1 != 1
		la var penblk1A "Type A pensions"
		
		egen penblk1B = anycount(penblk1type*), v(2)
		replace penblk1B = . if penblock1 != 1
		la var penblk1B "Type B pensions"

		tab penblk1B
		
		egen penblk1AB = anycount(penblk1type*), v(3)
		replace penblk1AB = . if penblock1 != 1
		la var penblk1AB "Type comb pensions"
		tab penblk1AB
		
		egen penblk1CO = anycount(penblk1type*), v(4)
		replace penblk1CO = . if penblock1 != 1
		la var penblk1CO "cashed out pensions"

		tab penblk1CO
		
		egen penblk1rf = anycount(penblk1type*), v(8)
		replace penblk1rf = . if penblock1 != 1
		la var penblk1rf "dk"

		tab penblk1rf
		
		
