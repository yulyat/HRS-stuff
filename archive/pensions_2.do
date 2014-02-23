


****************************************************************************
** This do file generates variables needed to count pension plans in J file 
** using merged data file called $track_preload_J08Wroking
************************************************************************
clear
use "$track_preload_J08Working"



	
*********
**past pen block ( Pen1)
*********

		cap drop pen1 pen1indicator
		gen pen1 = 1 if !mi(LZ140_1)  /* dummy indicates if obs has value for this pension block*/
		gen pen1indicator = pen1


	* how many pensions per person 

		cap drop pen1_total

		egen pen1_total = anycount(LZ140*), v(1 2 3 4)
		replace pen1_total = . if _intrk08 != 1
		la var pen1_total "number of past pension blocks per person"

	* within each round, define pension types and active vs inactive:
	
		cap drop pen1_round*
		forvalues n = 1/4 {
			gen pen1_round`n' = 1 if inlist(LZ140_`n', 1, 3) 
			replace pen1_round`n' = 2 if inlist(LZ140_`n', 2, 4) 
			}
			
		

* if cashed out:

		local i = 1
		forvalues n = 1/4 {
			gen pen1_round`n'act = 0 if inlist(pen1_round`n', 1, 2)  /* set to 0 if report pension in that round */
			tempvar pbstatA
			tempvar pbstatB
					
			if (`i' == 1)  {
					
				egen `pbstatA' = anymatch(LJ434_`n'm1 LJ434_`n'm2 LJ434_`n'm3 LJ434_`n'm4), v(1 2)		
				egen `pbstatB' = anymatch(LJ450_`n'm1 LJ450_`n'm2 LJ450_`n'm3 LJ450_`n'm4 LJ450_`n'm5), v(1 7)
						}
			else if (`i' == 2) {
				egen `pbstatA' = anymatch(LJ434_`n'm1 LJ434_`n'm2 LJ434_`n'm3), v(1 2)
				egen `pbstatB' = anymatch(LJ450_`n'm1 LJ450_`n'm2 LJ450_`n'm3), v(1 7)
				}
			else if `i' == 3   {
				egen `pbstatA' = anymatch(LJ434_`n'm1 LJ434_`n'm2), v(1 2)
				egen `pbstatB' = anymatch(LJ450_`n'm1 LJ450_`n'm2 LJ450_`n'm3), v(1 7)

				}
			else if `i' == 4   {
				egen `pbstatA' = anymatch(LJ434_`n'm1 LJ434_`n'm2), v(1 2)
				egen `pbstatB' = anymatch(LJ450_`n'm1 LJ450_`n'm2), v(1 7)
				}

			replace pen1_round`n'act = 1 if `pbstatA' == 1   /* set to 1 if pension is reported not cashed out ( still active)*/
			replace pen1_round`n'act = 1 if `pbstatB' == 1   /* set to 1 if pension is reported not cashed out ( still active)*/

			local i = `i' + 1
			}


		 /* generate pen1roundXhat = set to 1 if the pension reported in that round is active*/
		
			forvalues n = 1/4 {
			gen pen1_round`n'hat = pen1_round`n'* pen1_round`n'act
			}
	
		** count total number of active pensions
			
			egen pen1_totactive = anycount(pen1_round*hat),v(1,2)
			replace pen1_totactive = . if pen1 != 1
			la var pen1_totactive "past pension blocks still active"
	

		** now by type:

		** update type in each round - 1 - type A; 2 - type B; 11 = type A inactive ; 22 - type B inactive:


			forvalues n = 1/4 {
			replace pen1_round`n' = 11 if pen1_round`n' == 1 & pen1_round`n'act == 0
			replace pen1_round`n' = 22 if pen1_round`n' == 2 & pen1_round`n'act == 0
			}

			
		** add up number of each type  = A, B and cashed out:  
		
		cap drop pen1A pen12A pen1B pen12B pen1CO
		

		egen pen1A_total = anycount(pen1_round1 pen1_round2 pen1_round3 pen1_round4), v(1 11)
		replace pen1A_total = . if pen1 != 1
		la var pen1A_total "Total number of type A pensions"
		
		egen pen1A_active = anycount(pen1_round1 pen1_round2 pen1_round3 pen1_round4), v(1)
		replace pen1A_active = . if pen1 != 1
		la var pen1A_active "Number of Active Type A pensions"
		
		egen pen1B_total = anycount(pen1_round1 pen1_round2 pen1_round3 pen1_round4), v(2 22)
		replace pen1B_total = . if pen1 != 1
		la var pen1B_total "Total number of type B pensions"

		egen pen1B_active = anycount(pen1_round1 pen1_round2 pen1_round3 pen1_round4), v(2)
		replace pen1B_active = . if pen1 != 1
		la var pen1B_active "Number of active type B pensions"		
					
		egen pen1_CashOut = anycount(pen1_round1 pen1_round2 pen1_round3 pen1_round4), v(11 22)
		replace pen1_CashOut = . if pen1 != 1
		la var pen1_CashOut "Total number of cashed out pensions, regardless of type"

		




		***********
		** block 1 : Pen2
		***********
		
		/* generate variable not missing if respondent was asked pension block 2 
		(missing if didn't get penblock)*/

		cap drop pen2
		gen pen2 = .
		replace pen2 = 1 if LJ084 == 1
		replace pen2 = 0 if inlist(LJ084,5)
		replace pen2 = -1 if inlist(LJ084,8,9)

		/* recode don't don't knows as - 1..? */

		gen pen2indicator = 1 if !mi(pen2)

		* generate pen2_report = in pension block 2, how many pensions do people REPORT having
		cap drop pen2_report
		gen pen2_report = LJ085 
		replace pen2_report = 0 if inlist(LJ085,95, 99)
		replace pen2_report = 1 if LJ085 == 98 & LJ086 == 1
		replace pen2_report = 0 if LJ085 == 98 & inlist(LJ086, 8,9)


	

	**Break down by type. 
	* C = both A&B type, D = don't know, refused, other confusing responses

		** identify which type of pension in each of 4 rounds a,b,c,d: 
		
		cap drop pen2_round*
		local rounds a b c d 

		foreach n of local rounds {

			gen pen2_round`n' = 0 if (pen2 == 1 | pen2 == -1)
			replace pen2_round`n' = 1 if inlist(LJw082`n', 3, 12, 16)
			replace pen2_round`n' = 2 if inlist(LJw082`n', 1,2,4,5,6,7,8,9,10,11,13,14)
			replace pen2_round`n' = 3 if LJw082`n' == 15
			replace pen2_round`n' = 4 if inlist(LJw082`n',97,98,99)
			replace pen2_round`n' = 0 if inlist(LJw082`n', 95)


			replace pen2_round`n'  = 1 if pen2_round`n' == 4 & LJw001`n' == 1
			replace pen2_round`n'  = 2 if pen2_round`n' == 4 & LJw001`n' == 2
			replace pen2_round`n'  = 3 if pen2_round`n' == 4 & LJw001`n' == 3
			replace pen2_round`n'  = 4 if pen2_round`n' == 4 & inlist(LJw001`n',8,9)

			}
		
	** identify var set to 1 if the pension in that round is still active		
		
		
		cap drop pen2_round`n'act
		
		local i = 1
		local rounds a b c d 
		foreach n of local rounds {
			gen pen2_round`n'act = 0  if inlist(pen2_round`n', 1,2,3) /* set to 0 if reported a pension in that round*/
		
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
			replace pen2_round`n'act = 1  if `pnstat' == 1 /* set to 1 if pension is reported not cashed out ( still active)*/
			local i = `i' + 1
			}
	
	
	** generate pen2_roundXhat = 1 if the pension reported in this round is active:
	
	local rounds a b c d 
	
	foreach n of local rounds {
		gen pen2_round`n'hat = pen2_round`n' * pen2_round`n'act
		}
	
 		
	** count up total number per person, total reported and active:
	
		cap drop pen2_total pen2_totactive 

		egen pen2_total = anycount(pen2_rounda pen2_roundb pen2_roundc pen2_roundd), v(1 2 3 4)
		replace pen2_total = . if pen2 != 1
		la var pen2_total "number of pensions reported"
		egen pen2_totactive = anycount(pen2_roundahat pen2_roundbhat pen2_roundchat pen2_rounddhat), v(1 2 3 4)
		replace pen2_totactive = . if pen2 != 1
		la var pen2_totactive "number reported still active" 


	/* update type in each round:
		 11 - type A cashed out 
		 22 - type B casehd out 
		 33- Both types cashed out
		 44 - dk & refused & but cashed out ( should be empty)

	*/
	
	local rounds a b c d 	
	foreach n of local rounds {
		replace pen2_round`n' = 11 if pen2_round`n' == 1 & pen2_round`n'act == 0
		replace pen2_round`n' = 22 if pen2_round`n' == 2 & pen2_round`n'act == 0
		replace pen2_round`n' = 33 if pen2_round`n' == 3 & pen2_round`n'act == 0
		replace pen2_round`n' = 44 if pen2_round`n' == 4 & pen2_round`n'act == 0

		}
	
	** now count up by type:	
	
	cap drop pen2A_total pen2B_total pen2AB_total pen2DK_total

	
		egen pen2A_total  = anycount(pen2_rounda pen2_roundb pen2_roundc pen2_roundd), v(1 11)
		replace pen2A_total = . if (pen2 != 1 & pen2 != -1)
		la var pen2A_total "Type A pensions"
		
		egen pen2B_total = anycount(pen2_rounda pen2_roundb pen2_roundc pen2_roundd), v(2 22)
		replace pen2B_total = . if (pen2 != 1 & pen2 != -1)
		la var pen2B_total "Type B pensions"


		egen pen2AB_total = anycount(pen2_rounda pen2_roundb pen2_roundc pen2_roundd), v(3 33)
		replace pen2AB_total = . if (pen2 != 1 & pen2 != -1)
		la var pen2AB_total "Type comb pensions"
		tab pen2AB_total
		
		egen pen2DK_total = anycount(pen2_rounda pen2_roundb pen2_roundc pen2_roundd), v(4 44)
		replace pen2DK_total = . if (pen2 != 1 & pen2 != -1)
		la var pen2DK_total "Type unknown pensions"
		tab pen2DK_total


		egen pen2A_active = anycount(pen2_rounda pen2_roundb pen2_roundc pen2_roundd), v(1)
		replace pen2A_active = . if (pen2 != 1 & pen2 != -1)
		la var pen2A_active "Type A active pensions"
		
		egen pen2B_active = anycount(pen2_rounda pen2_roundb pen2_roundc pen2_roundd), v(2)
		replace pen2B_active = . if (pen2 != 1 & pen2 != -1)
		la var pen2B_active "Type B active pensions"


		egen pen2AB_active = anycount(pen2_rounda pen2_roundb pen2_roundc pen2_roundd), v(3)
		replace pen2AB_active = . if (pen2 != 1 & pen2 != -1)
		la var pen2AB_active "Type comb active pensions"

		egen pen2DK_active = anycount(pen2_rounda pen2_roundb pen2_roundc pen2_roundd), v(4)
		replace pen2DK_active = . if (pen2 != 1 & pen2 != -1)
		la var pen2DK_active "Type unknownactive  pensions"
		/* note that if type is unknown, this is the end of the pension loop, so count 
		all unknown pensions as active */


******************
* pension block 3: this is the pension blcok that everybody  who is working in 08 gets
******************
	
		cap drop pen3

		gen pen3 = .  
		replace pen3 = 1 if (LJ848 == 1 & LJ849 == 1) 
		replace pen3 = 0 if LJ848 == 1 & inlist(LJ849,5,8,9)  
		replace pen3 = 1 if LJ324 == 1
		replace pen3 = -1 if (inlist(LJ324,5,8,9) | inlist(LJ848,5,8,9))
	
		gen pen3indicator = 1 if !mi(pen3)
	
	* how many pensions reported:
		cap drop pen3_report 
		gen pen3_report = LJ335 if pen3== 1 
		replace pen3_report = 0 if inlist(LJ335, 98,99)
		


	* break down by type:
		cap drop pen3_round*


		forvalues n = 1/4 {
			gen pen3_round`n' = 0 if (pen3 == 1 | pen3 == -1)
			replace pen3_round`n' = 1 if inlist(LJ393_`n', 3, 12, 16)
			replace pen3_round`n' = 2 if inlist(LJ393_`n', 1,2,4,5,6,7,8,9,10,11,13,14)
			replace pen3_round`n' = 3 if LJ393_`n' == 15
			replace pen3_round`n' = 4 if inlist(LJ393_`n',95, 97, 98, 99)
			replace pen3_round`n' = 0 if inlist(LJ393_`n', 95)


			replace pen3_round`n'  = 1 if pen3_round`n' == 4 & LJ338_`n' == 1
			replace pen3_round`n'  = 2 if pen3_round`n' == 4 & LJ338_`n' == 2
			replace pen3_round`n'  = 3 if pen3_round`n' == 4 & LJ338_`n' == 3
			replace pen3_round`n'  = 4 if pen3_round`n' == 4 & inlist(LJ338_`n',8,9)

		}

		** update using LJ338

	* add up number of pensions per person :
		cap drop pen3_total
		egen pen3_total = anycount(pen3_round*), v(1 2 3 4)
		la var pen3_total "total number of pensions per person"

	* number of penson of each type:
	
		cap drop pen3A_total pen3B_total pen3AB_total pen3DK_total
		local i = 1
		local type A B AB DK
		foreach z of local type {
			egen pen3`z'_total = anycount(pen3_round*), v(`i')
			replace pen3`z' = . if pen3 !=1 & pen3 != -1
			local i = `i'+1
		}

		la var pen3A_total "number of type A pensions"
		la var pen3B_total "number of type B pensions"
		la var pen3AB_total "number of type AB pensions"
		la var pen3DK_total "number of unknown type pensions"


***********
* pen4: everybody who is is under < 71 & !in nursing home. 
* count all of them as active type 4 pensions (unknown)
* **********

		cap drop pen4
		gen pen4 = 1 if inlist(LJw066, 1) 
		replace pen4 = 2 if inlist(LJw066, 2) 
		replace pen4 = -1 if inlist(LJw066,8, 9) 

		replace pen4 = 0 if LJw066 == 5
		gen pen4indicator = 1 if !mi(pen4)


* need to generate pen4_total to account for -1 (put it in don't know category)
		cap drop pen4_total
		gen pen4_total = pen4
		replace pen4_total = 1 if pen4 == -1

* label all pen1-4 with value label:

		#delimit ;
		label define penlabel
		2 "<1"
		-1 "dk";
		#delimit cr 

		forvalues n = 1/4 {
			label variable pen`n' penlabel
		}






********************************
*Adding up pensions across blocks
*******************************
** number of pensions per person across blocks:

		cap drop pensiontotal 
		egen pensiontotal = rowtotal(pen1_total pen2_total pen3_total pen4_total)
		la var pensiontotal "number of pensions across blocks"
		
		
		cap drop pensiontotactive
		egen pensiontotactive = rowtotal(pen1_totactive pen2_totactive pen3_total pen4_total)
		replace pensiontotactive = . if _intrk08 != 1
		la var pensiontotactive "number of  active pensions across blocks"
		

		cap drop pensiontotalA
		egen pensiontotalA = rowtotal(pen1A_total pen2A_total pen3A_total)
		replace pensiontotalA = . if _intrk08 != 1
		la var pensiontotalA "number of A type pensions across blocks"
	
		
		cap drop pensionactiveA
		egen pensionactiveA = rowtotal(pen1A_active pen2A_active pen3A_total)
		replace pensionactiveA = . if _intrk08 != 1
		la var pensionactiveA "number of active A type pensions across blocks"
		***
		
		cap drop pensiontotalB
		egen pensiontotalB = rowtotal(pen1B_total pen2B_total pen3B_total)
		replace pensiontotalB = . if _intrk08 != 1
		la var pensiontotalB "number of B type pensions across blocks"
		 

		cap drop pensionactiveB
		egen pensionactiveB = rowtotal(pen1B_active pen2B_active pen3B_total)
		replace pensionactiveB = . if _intrk08 != 1
		la var pensionactiveB "number of active B type pensions across blocks"
		
		/* combination or unknown type pensions) */

		cap drop pensiontotal4
		egen pensiontotal4 = rowtotal(pen2AB_total pen2DK_total pen3AB_total pen3DK_total pen4_total)
		replace pensiontotal4 = . if _intrk08 != 1
		la var pensiontotal4 "number of unknown or combo type pensions across blocks"

* how many pension blocks :

cap drop numpenblocks 
egen numpenblocks = rowtotal(pen1indicator pen2indicator pen3indicator pen4indicator), m
replace numpenblocks = 0 if mi(numpenblocks) & _intrk08 == 1
/* replace with 0 if not asked any pension blocks*/


la var numpenblocks "number of pensions blocks asked"		

		
save "$track_preload_J08Working", replace



