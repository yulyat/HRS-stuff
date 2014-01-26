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

		tab pastpenblock if _intrk08 == 1, m

	* how many pensions per person

	tab LZ140_1


	cap drop penblkpst_total

	egen penblkpst_total = anycount(LZ140*), v(1 2 3 4)
	replace penblkpst_total = . if _intrk08 != 1
	la var penblkpst_total "number of past pension blocks per person"
	tab penblkpst_total if pastpenblock == 1

	
	
	
	* generate var  = 1 if pension is not reported cashed out:
	
	cap drop pbpst_round*
	
	
	
		forvalues n = 1/4 {

			gen pbpst_round`n' = 1 if inlist(LZ140_`n', 1, 3) 
			replace pbpst_round`n' = 2 if inlist(LZ140_`n', 2, 4) 
			tab pbpst_round`n' 
			}
			* if cashed out:

					local i = 1
					forvalues n = 1/4 {


					gen pbpst_round`n'CO = 0 if inlist(pbpst_round`n', 1, 2,3,4)  /* set to 1 if report pension in that round */
					tempvar pbstat
					
					if (`i' == 1)      {
					
						egen `pbstat' = anymatch(LJ434_`n'm1 LJ434_`n'm2 LJ434_`n'm3 LJ434_`n'm4 LJ450_`n'm1 LJ450_`n'm2 LJ450_`n'm3 LJ450_`n'm4 LJ450_`n'm5), v(1 2)
					}
					else if (`i' == 2) {
						egen `pbstat' = anymatch(LJ434_`n'm1 LJ434_`n'm2 LJ434_`n'm3  LJ450_`n'm1 LJ450_`n'm2 LJ450_`n'm3 ), v(1 2)
					}
					else if `i' == 3   {
						egen `pbstat' = anymatch(LJ434_`n'm1 LJ434_`n'm2  LJ450_`n'm1 LJ450_`n'm2 LJ450_`n'm3), v(1 2)
					}
					else if `i' == 4   {
						egen `pbstat' = anymatch(LJ434_`n'm1 LJ434_`n'm2  LJ450_`n'm1 LJ450_`n'm2), v(1 2)
					}

					replace pbpst_round`n'CO = 1 if `pbstat' == 1   /* set to 1 if pension is reported not cashed out ( still active)*/
						local i = `i' + 1
				}

	

	 ** generate pbpstroundXhat = set to 1 if the pension reported in that round is active
	forvalues n = 1/4 {
	gen pbpst_round`n'hat = pbpst_round`n'* pbpst_round`n'CO
	}
	
	** count total number of active pensions
	egen pbpst_totactive = anycount(pbpst_round*hat),v(1,2)
	replace pbpst_totactive = . if pastpenblock != 1
	la var pbpst_totactive "past pension blocks still active"
	

** now by type:

** update type in each round - 1 - type A; 2 - type B; 11 = type A inactive ; 22 - type B inactive:


forvalues n = 1/4 {
	replace pbpst_round`n' = 11 if pbpst_round`n' == 1 & pbpst_round`n'CO == 0
	replace pbpst_round`n' = 22 if pbpst_round`n' == 2 & pbpst_round`n'CO == 0
	}

			
** add up number of each type  = A, B and cashed out:  
		
		cap drop penblkpstA penblkpst2A penblkpstB penblkpst2B penblkpstCO
		
		 
		
		egen penblkpstA = anycount(pbpst_round1 pbpst_round2 pbpst_round3 pbpst_round4), v(1 11)
		replace penblkpstA = . if pastpenblock != 1
		la var penblkpstA "Type A pensions, before cashout"
		
		egen penblkpst2A = anycount(pbpst_round1 pbpst_round2 pbpst_round3 pbpst_round4), v(1)
		replace penblkpst2A = . if pastpenblock != 1
		la var penblkpst2A "Type A pensions - active"
		
		egen penblkpstB = anycount(pbpst_round1 pbpst_round2 pbpst_round3 pbpst_round4), v(2 22)
		replace penblkpstB = . if pastpenblock != 1
		la var penblkpstB "Type B pensions before cashout"

		egen penblkpst2B = anycount(pbpst_round1 pbpst_round2 pbpst_round3 pbpst_round4), v(2)
		replace penblkpst2B = . if pastpenblock != 1
		la var penblkpst2B "Type B pensions - active"		
		
			
		egen penblkpstCO = anycount(pbpst_round1 pbpst_round2 pbpst_round3 pbpst_round4), v(11 22)
		replace penblkpstCO = . if pastpenblock != 1
		la var penblkpstCO "cashed out pensions"

		


tab penblkpstA if pastpenblock == 1
tab penblkpstB if pastpenblock == 1

tab penblkpst2A if pastpenblock == 1 
tab penblkpst2B if pastpenblock == 1 
tab penblkpstCO if pastpenblock == 1



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



* generate penblk1_list  - how many pensions do people LIST (actually describe)
* if say don't know or rf for both, don't count the pension

cap drop penblk1_list
gen penblk1_list = 0 if penblock1 ==1
local rounds a b c d
foreach n of local rounds {
	replace penblk1_list = penblk1_list + 1 if inlist(LJw082`n', 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
	replace penblk1_list = penblk1_list + 1 if inlist(LJw082`n',97,98,99) & inlist(LJw001`n', 1,2,3)  
	}
	

**Break down by type. 

	** identify which type of pension in each of 4 rounds a,b,c,d: 

		

			
		cap drop pb1_round*
		set trace off
		local rounds a b c d 
		foreach n of local rounds {
		gen pb1_round`n' = 0 if penblock1 == 1
		replace pb1_round`n' = 1 if inlist(LJw082`n', 3, 12, 16)
		replace pb1_round`n' = 2 if inlist(LJw082`n', 1,2,4,5,6,7,8,9,10,11,13,14)
		replace pb1_round`n' = 3 if LJw082`n' == 15
		replace pb1_round`n' = 8 if inlist(LJw082`n', 97,98,99)


		replace pb1_round`n'  = 1 if pb1_round`n' == 8 & LJw001`n' == 1
		replace pb1_round`n'  = 2 if pb1_round`n' == 8 & LJw001`n' == 2
		replace pb1_round`n'  = 3 if pb1_round`n' == 8 & LJw001`n' == 3
		}
		
		
	** identify var set to 1 if the pension in that round is still active		
		
		
		cap drop pb1_round`n'CO
		
		local i = 1
		local rounds a b c d 
		foreach n of local rounds {
		gen pb1_round`n'CO = 0  if inlist(pb1_round`n', 1,2,3) /* set to 0 if reported a pension in that round*/
		
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
		replace pb1_round`n'CO = 1  if `pnstat' == 1 /* set to 1 if pension is reported not cashed out ( still active)*/
		local i = `i' + 1
		}
	
	
	** generate pb1_roundXhat = 1 if the pension reported in this round is active:
	
	local rounds a b c d 
	
	foreach n of local rounds {
		gen pb1_round`n'hat = pb1_round`n' * pb1_round`n'CO
		}
	
 		
	** count up total number per person, total reported and active:
	
		

		cap drop penblk1total penblk1totactive penblk1total_co penblk1A penblk1B penblk1AB penblk1CO penblk1rf

		egen penblk1total = anycount(pb1_rounda pb1_roundb pb1_roundc pb1_roundd), v(1 2 3 8)
		replace penblk1total = . if penblock1 != 1
		la var penblk1total "number of pensions reported"
		egen penblk1totactive = anycount(pb1_roundahat pb1_roundbhat pb1_roundchat pb1_rounddhat), v(1 2 3 8)
		replace penblk1totactive = . if penblock1 != 1
		la var penblk1totactive "number reported still active" 


	** update type in each round 11 - type A cashed out 22 - type B casehd out 33- Both types cashed out:
	
	local rounds a b c d 	
	foreach n of local rounds {
		replace pb1_round`n' = 11 if pb1_round`n' == 1 & pb1_round`n'CO == 0
		replace pb1_round`n' = 22 if pb1_round`n' == 2 & pb1_round`n'CO == 0
		replace pb1_round`n' = 33 if pb1_round`n' == 3 & pb1_round`n'CO == 0

		}
	
	** now count up by type	
	

	
		egen penblk1A = anycount(pb1_rounda pb1_roundb pb1_roundc pb1_roundd), v(1 11)
		replace penblk1A = . if penblock1 != 1
		la var penblk1A "Type A pensions"
		
		egen penblk1B = anycount(pb1_rounda pb1_roundb pb1_roundc pb1_roundd), v(2 22)
		replace penblk1B = . if penblock1 != 1
		la var penblk1B "Type B pensions"


		egen penblk1AB = anycount(pb1_rounda pb1_roundb pb1_roundc pb1_roundd), v(3 33)
		replace penblk1AB = . if penblock1 != 1
		la var penblk1AB "Type comb pensions"
		tab penblk1AB
		
		
		egen penblk12A = anycount(pb1_rounda pb1_roundb pb1_roundc pb1_roundd), v(1)
		replace penblk12A = . if penblock1 != 1
		la var penblk12A "Type A active pensions"
		
		egen penblk12B = anycount(pb1_rounda pb1_roundb pb1_roundc pb1_roundd), v(2)
		replace penblk12B = . if penblock1 != 1
		la var penblk12B "Type B active pensions"


		egen penblk12AB = anycount(pb1_rounda pb1_roundb pb1_roundc pb1_roundd), v(3)
		replace penblk12AB = . if penblock1 != 1
		la var penblk12AB "Type comb active pensions"
		

