
clear
set more off

global track_preload_J08 `"/Users/truskinovsky/Documents/Amar/data/track_preload_J08.dta"'

use $track_preload_J08
save "$track_preload_J08", replace


								*********************
								*  _intrk variable 
								********************



			/* 

				Useful variables in making the _intrk variable:
  			    		Xalive  - Wave X Vital Status
   						Xinsamp - Wave X Sample Status
   						Xiwtype - Wave X Interview Type
  					    Xiwwave - Wave X Whether Interviewed in the Wave
  	 					Xrescode = Wave X Result Code
  
			*/



			** Generate _intrk08 

		cap drop _intrk08
		gen _intrk08 = .

		replace _intrk08 = 1 if Liwwave == 1 & Lalive == 1        /*in the analytical sample*/
		replace _intrk08 = 2 if !mi(Liwwave) & Lalive == 5        /*known died since 2006 */
		replace _intrk08 = 3 if Liwwave == 0 & Lalive < 5         /* evaded since previous wave: refused, not found, removed) */


		replace _intrk08 = 4 if mi(Liwwave) & inlist(Kalive,5,6)  /* known to be dead in 2006*/
		replace _intrk08 = 4 if Lalive == 6                       /* known to be dead in 2006*/
		replace _intrk08 = 5 if mi(Liwwave) & inlist(Linsamp,6,8) /*(evaded pre 2006, not known dead) */
		replace _intrk08 = 6 if inlist(Linsamp, 2,3,4)            /* should not appear in this wave */ 


			tab _intrk08, m
			#delimit ; 
 			cap label define intrk08  
			1 "in analytical sample"
			2 "dead since 06"
			3 "evaded since 06"
			4 "died pre 06"
			5 "evaded pre 06"
			6 "not eligible";
			label values _intrk08 intrk08 ;
			tab _intrk08;
			#delimit cr 

		** _intrk10

		cap drop _intrk10
		gen _intrk10 = .

		replace _intrk10 = 1 if Miwwave == 1 & Malive == 1 /*in the analytical sample*/
		replace _intrk10 = 2 if !mi(Miwwave) & Malive == 5 /*known dead since 2006 */
		replace _intrk10 = 3 if Miwwave == 0 & Malive < 5   /* evaded since previous wave: refused, not found, removed) */


		replace _intrk10 = 4 if mi(Miwwave) & inlist(Lalive,5,6) /* known dead in 2008*/
		replace _intrk10 = 4 if Malive == 6
		replace _intrk10 = 5 if mi(Miwwave) & inlist(Minsamp,6,8) /*( evaded pre 2008, not known dead) */
		replace _intrk10 = 6 if inlist(Minsamp, 2,3,4) /* should not appear in this wave */ 


			#delimit ; 
			cap label define intrk10  
			1 "in analytical sample"
			2 "dead since 08"
			3 "evaded since 08"
			4 "died pre 08"
			5 "evaded pre 08"
			6 "not eligible";
			label values _intrk10 intrk10; tab _intrk10;
			#delimit cr 


	* generate _intrk06

		cap drop _intrk06
		gen _intrk06 = .

		replace _intrk06 = 1 if Kiwwave == 1 & Kalive == 1        /*in the analytical sample*/
		replace _intrk06 = 2 if !mi(Kiwwave) & Kalive == 5        /*known died since 2004 */
		replace _intrk06 = 3 if Kiwwave == 0 & Kalive < 5         /* evaded since previous wave: refused, not found, removed) */


		replace _intrk06 = 4 if mi(Kiwwave) & inlist(Jalive,5,6)  /* known to be dead in 2004*/
		replace _intrk06 = 4 if Kalive == 6                       /* known to be dead in 2004*/
		replace _intrk06 = 5 if mi(Kiwwave) & inlist(Kinsamp,6,8) /*(evaded pre 2004, not known dead) */
		replace _intrk06 = 6 if inlist(Kinsamp, 2,3,4)            /* should not appear in this wave */ 


		tab _intrk06, m


			#delimit ; 
 			cap label define intrk06  
			1 "in analytical sample"
			2 "dead since 04"
			3 "evaded since 04"
			4 "died pre 04"
			5 "evaded pre 04"
			6 "not eligible";
			label values _intrk06 intrk06 ;
			tab _intrk06;
			#delimit cr 





								*********************
								*  Age 6 categories
								********************


			#delimit ;

			cap label define age6 
			1 "Below 50" 
			2 "50 to 54"
			3 "55 to 59"
			4 "60 to 64"
			5 "65 to 69"
			6 "70 and above";
			#delimit cr


		cap drop Aage6

		gen Aage6 = 1 if Aage < 50 
		replace Aage6 = 2 if Aage>= 50 & Aage < 55
		replace Aage6 = 3 if Aage>= 55 & Aage < 60
		replace Aage6 = 4 if Aage>= 60 & Aage < 65
		replace Aage6 = 5 if Aage>= 65 & Aage < 70
		replace Aage6 = 6 if Aage >= 70 & Aage < 996

		label values Aage6 age6

		cap drop Lage6
		gen Lage6 = 1 if Lage < 50 
		replace Lage6 = 2 if Lage>= 50 & Lage < 55
		replace Lage6 = 3 if Lage>= 55 & Lage < 60
		replace Lage6 = 4 if Lage>= 60 & Lage < 65
		replace Lage6 = 5 if Lage>= 65 & Lage < 70
		replace Lage6 = 6 if Lage >= 70 & Lage < 996

		label values Lage6 age6

		cap drop Mage6
		gen Mage6 = 1 if Mage < 50 
		replace Mage6 = 2 if Mage>= 50 & Mage < 55
		replace Mage6 = 3 if Mage>= 55 & Mage < 60
		replace Mage6 = 4 if Mage>= 60 & Mage < 65
		replace Mage6 = 5 if Mage>= 65 & Mage < 70
		replace Mage6 = 6 if Mage >= 70 & Mage < 996

		label values Mage6 age6


		cap drop Jage6
		gen Jage6 = 1 if Jage < 50 
		replace Jage6 = 2 if Jage>= 50 & Jage < 55
		replace Jage6 = 3 if Jage>= 55 & Jage < 60
		replace Jage6 = 4 if Jage>= 60 & Jage < 65
		replace Jage6 = 5 if Jage>= 65 & Jage < 70
		replace Jage6 = 6 if Jage >= 70 & Jage < 996

		label values Jage6 age6

						*********************************
						* Variables for current analysis
						*********************************



 	** 2006 retirement  and working status dummies using preload:
 
 				cap drop retired06
 				gen retired06 = LZ124
  
  			 	#delimit ; 
			 	cap label drop yesno1;
  
			 	label define yesno1   
			 	1  "yes" 
			 	5  "no"; 
			 	#delimit cr

				label values retired06 yesno1  
  
 	** 2006 working variable using preload:
 
 				gen working06 = LZ123 
 				label values working06 yesno1
   
   ** Jstatus06 - retirement and working status from 06 preload:

 				cap drop jstatus06
 				gen jstatus06 = .
 				replace jstatus06 = 1 if working06 == 1 & retired06 == 1
 				replace jstatus06 = 2 if working06 == 5 & retired06 == 1
 				replace jstatus06 = 3 if working06 == 1 & retired06 == 5
 				replace jstatus06 = 4 if working06 == 5 & retired06 == 5
 				
  ** 2008 retirement and working status dummies using Jfile:
  	
				cap drop working08 
				gen working08 = LJ020
				label values working08 yesno1
				
				cap drop retired08
				egen retired08 = anymatch(LJ005*), v(5)
				replace retired08 = . if _intrk08 != 1
				replace retired08 = 5 if retired08 == 0
				
				
	** Jstatus08 - retirement and working status in 08			
				cap drop jstatus08
				gen jstatus08 = .
				replace jstatus08 = 1 if working08 ==1 & retired08 == 1
				replace jstatus08 = 2 if working08 ==5 & retired08 == 1
				replace jstatus08 = 3 if working08 ==1 & retired08 == 5
				replace jstatus08 = 4 if working08 ==5 & retired08 == 5
				tab jstatus08 if _intrk08 == 1, m

				
	** LJ021 - self/else employed 2008			
				
				gen selfelse08 =  LJ021
				#delimit ; 
			 	cap label drop selfelse08;
  
			 	label define selfelse08   
				1 "else"
          	    2 "self"
                8 "dk" 
                9 "rf"; 
				#delimit cr

				label values selfelse08 selfelse08 
				

	** LZ136 - self /else employed from preload 2006
				
				tab LZ136 if _intrk08 == 1, m
				tab LZ136 working06 if _intrk08 == 1, m
				gen selfelse06 = LZ136
			    label values selfelse06 selfelse08 

				
	** LJ045 - change jobs since previous wave
					
				#delimit ;
 				cap label drop LJ045;
 				label define LJ045 
 				1 "yes"
 				3 "yes, new ownership"
 				4  "no, new ownership"
				5  "no"
			    7  "denies working for prev emp"
 				8  "dk"
 				9  "rf"; 
 				#delimit cr
 				label values LJ045 LJ045
 				

	** previous wave R had pension on job: 
	
				gen jobpension06 = LZ133
				label values jobpension06 yesno1
				
	** pension block 1 - indicator variable if respondent has a block 1 pension - will be missing 
	** if respondent did not get pension block 1
	
				cap drop penblock1
				gen penblock1 = .
				replace penblock1 = 1 if LJ084 == 1
				replace penblock1 = 0 if inlist(LJ084,5,8,9)
				
    ** pension block 2 - indicator variable if respondent has a block 2 pension - will be missing 
	** if respondent did not get pension block 2
				
				
				cap drop penblock2

				gen penblock2 = .  
				replace penblock2 = 1 if (LJ848 == 1 & LJ849 == 1) 
				replace penblock2 = 0 if LJ848 == 1 & inlist(LJ849,5,8,9)  
				replace penblock2 = 1 if LJ324 == 1
				replace penblock2 = 0 if (inlist(LJ324,5,8,9) | inlist(LJ848,5,8,9))



	* deltastatus - dummy variable indicating change in working situation between 2006 & 2008
	
	/*	- working -> not working
		- self employed -> else employed
		- else employed -> self employed
		- change jobs		*/
	
				cap drop deltastatus
				gen deltastatus = 0 if _intrk08 == 1
				replace deltastatus = 1 if working06 ==1 & working08 == 5              /* working in 06, not working in 08 */
				replace deltastatus = 1 if working06 == 1 & working08 == 1 & inlist(LJ045, 4, 5)   /* working 06, 08, changed jobs*/
				replace deltastatus = 1 if selfelse06 != selfelse08 & !mi(selfelse06) & !mi(selfelse08)    /* change self to else employed or vice versa */ 
	
	
	** everybody who changed status between 06 and 08 gets penblock 1 UNLESS they didn't have a pension in 06: 
	
	tab deltastatus	penblock1 if _intrk08 == 1, m
	tab deltastatus jobpension06 if mi(penblock1) & _intrk08 ==1, m
 	tab deltastatus penblock1 if jobpension06 == 5 & _intrk08 == 1, m



	tab jstatus08 penblock2 if _intrk08 == 1, m
	tab penblock1 penblock2 if _intrk08 == 1, m
	tab penblock1 penblock2 if deltastatus == 1 & _intrk08 == 1, m

	tab penblock2 if deltastatus == 1 & _intrk08 == 1, m



	** com0608 - combination status variable incorporating deltastatus
		gen comb0608=.
		replace comb0608=1 if working06==1 & selfelse06==2 & working08==1 & selfelse08==2
		replace comb0608=2 if working06==1 & selfelse06==2 & working08==1 & selfelse08==1
		replace comb0608=3 if working06==1 & selfelse06==2 & working08==5
		replace comb0608=4 if working06==1 & selfelse06==1 & working08==1 & selfelse08==2
		replace comb0608=5 if working06==1 & selfelse06==1 & working08==1 & selfelse08==1 & (LJ045==1 | LJ045==3)
		replace comb0608=6 if working06==1 & selfelse06==1 & working08==1 & selfelse08==1 & (LJ045==4 | LJ045==5)
		replace comb0608=7 if working06==1 & selfelse06==1 & working08==5
		replace comb0608=8 if working06==5 & working08==1 & selfelse08==2
		replace comb0608=9 if working06==5 & working08==1 & selfelse08==1
		replace comb0608=10 if working06==5 & working08==5

		label define comb0608 1 "06s 08s" 2 "06s 08e" 3 "06s 08u" 4 "06e 08s" 5 "06e 08eo" 6 "06e 08en" 7 "06e 08u" 8 "06u 08s" 9 "06u 08e" 10 "06u 08u"

		label values comb0608 comb0608

		tab comb0608

	** generate pb1miss, equal to 1 if respondent appears to have changed status between 06&08 
	** (deltastatus ==1) but is missing pensionblock1 n == 126:

		gen pb1miss = 0 if _intrk08 == 1 
		replace pb1miss= 1 if mi(penblock1) & deltastatus == 1


		tab comb0608 pb1miss if mi(penblock1) & _intrk08==1,m
		
		/*
	    Why missing from penblock1? lapses in employment status, respondent 
	    negates preloads, no  preloaded employer name, etc:

 			1 - deny working for self in previous IW (LJ023 ==97)
		    2 - complication in self employment status 96 on LJ023 & 5 on LJ028
 			3 - when asked why status changed, responds that status did not change 
 				J063 = 92, 93, 97 94 ( last one is confusing, because then J021 shoulod have been recoded...)
			Other complications that end up not being problematic:
 			 --  no job title from previous wave: LJ684 == 0 ( this is J058 branchpoint in survey) 
  			 --  LJ045 == 7, 8,9 ( denies working from previous employer, dk, rf)
  			 -- LJ683 ==1 ( I think this is JW186 == 7 - denies working for employer which is named in preload
		*/
		
	** generate whypb1miss = tags observation s that are missing from PB1 for the above explained reasons:	
	
		cap drop whypb1miss
		gen whypb1miss = 0 if _intrk08 ==1
		replace whypb1miss = 1 if LJ023 == 97
		replace whypb1miss = 2 if LJ023 == 96 & LJ028 == 5
		replace whypb1miss = 3 if inlist(LJ063,92,93,94,97)

		tab pb1miss penblock2 if mi(penblock1) & _intrk08==1,m
		
		
	** do these guys who are skipped out of penblock 1 all get penblock2? not necessarily:
	
		tab whypb1miss penblock2 if mi(penblock1) & _intrk08==1,m
		tab comb0608 penblock1 if _intrk08==1,m

		** 72 observations get neither pension block

	** everybody who works for pay in 08 gets penblock2:
		tab comb0608 penblock2 if _intrk08 == 1, m
	
	
	
	** who gets neither pension block? mostly not working, retired. What do we know about their retirement status?

	/* update comb0608 to break down longer term unemployed:
		- LJ705 is a combo variable == 1 if not working in 04, 06, 08 
		NOTE: there are 10 observations tagged with this variable who actually report working in 08...
		Also update to include category for over 70.5 OR in nursing home
		 
	*/
		
		tab LJ705 if _intrk08 ==1, m		
		tab LJ020 LJ705 if _intrk08 ==1, m
		
		cap drop comb0608_2
		gen comb0608_2 = comb0608
		replace comb0608_2 = 11 if LJ705 == 1
		replace comb0608_2 = 12 if LA019 > 71 & !mi(LA019)
		replace comb0608_2 = 12 if (LA028 == 1 & LA070 == 5)
		label define comb0608  11 "UU" 12 "old&NH", add
		label values comb0608_2 comb0608 
		tab comb0608_2
		
		cap drop oldNH
		gen oldNH = 1 if (LA019 > 71 & !mi(LA019)) 
		replace oldNH = 1 if (LA028 == 1 & LA070 == 5)
		tab oldNH
	* aside exploration into who is missing from comb variable: 
		tab comb0608_2 if mi(penblock1) & mi(penblock2) & _intrk06 ==1 & _intrk08 == 1, m
		tab comb0608_2 if _intrk06 ==1 & _intrk08 == 1, m
		list working06 selfelse06 working08 selfelse08 if  _intrk08 == 1 & _intrk06 == 1 & mi(comb0608_2), noobs


	
	 ** try to generate 2010 preload using 2008 variables:

		cap drop PZ133
		gen PZ133 = 0 if _intrk08 == 1 & _intrk10 == 1                       /* identify the inverse of people who would appear in 2010 preload */
		replace PZ133 = 5 if inlist(working08,5,8,9)                         /* if not working in 08, won't report pensions on job */
		replace PZ133 = 1 if working08 == 1 &  penblock2 == 1
		replace PZ133 = 5 if working08 == 1 &  penblock2 == 0

		tab PZ133 MZ133 if _intrk08 == 1 & _intrk10 == 1, m

	* who are 29 missings?
		tab comb0608_2 working08 if PZ133 == 0 & _intrk08 == 1, m
	
	
	* who are mismatches? --> all appear to be missclassificaitons.
	** 6 who in lower left
  		tab comb0608_2 working08 if PZ133 == 5  & MZ133 == 1 & _intrk08 == 1, m

  		tab penblock2  if PZ133 == 5  & MZ133 == 1 & _intrk08 == 1, m

  		tab LJ848  LJ849 if PZ133 == 5  & MZ133 == 1 & _intrk08 == 1, m
  		tab LJ324 if PZ133 == 5  & MZ133 == 1 & _intrk08 == 1, m

	** 8 in upper right:
	
  		tab comb0608_2 working08 if PZ133 == 1  & MZ133 == 5 & _intrk08 == 1, m
 
  		tab penblock2 if PZ133 == 1  & MZ133 == 5 & _intrk08 == 1, m
		tab LJ848  LJ849 if PZ133 == 1  & MZ133 == 5 & _intrk08 == 1, m
  		tab LJ324 if PZ133 == 1  & MZ133 == 5 & _intrk08 == 1, m

************
*Jan 20 14**
************


	** accounting for all respondents pension blocks: 
	
		* generate penblock 4 variable. 
		cap drop penblock4
		gen penblock4 = 1 if inlist(LJw066, 1, 2) 
		replace penblock4 = 0 if inlist(LJw066, 5,8,9)
		
		* who gets penblock 4? under 70.5 and not permanently in a nursing home
  		tab comb0608_2 penblock4 if _intrk08 ==1, m


	*5 options for pension blocks:

		** breakdown LJ393 into A, B, or both: 
			tab LJ393_1, m

			#delimit ;
			label drop pentype;
			label define pentype 
			0 "NA"
			1 "A"
			2 "B"
			3 "A&B"
			8 "DK/RF";
#delimit cr


tab LJ335 penblock2 if _intrk08 ==1, m



	* 1. report on the job pension in 06. Everybody who was in the sample in o6 and 
	* 08 has this value - will be 0 if not working in 06

		tab LZ133 if _intrk08 ==1, m
	
	* 2. penblock1: asked of most of those those who changed Job status between 06 and 08 
	* so refers to a job they had previous to 06
		tab penblock1 if _intrk08 ==1, m
		
		
		
		cap drop penblock1type 
		gen penblock1type = 0 if !mi(penblock1)
		replace penblock1type = 1 if inlist(LJw082a, 3, 12, 16)
		replace penblock1type = 2 if inlist(LJw082a, 1,2,4,5,6,7,8,9,10,11,13,14)
		replace penblock1type = 3 if LJw082a == 15
		replace penblock1type = 8 if inlist(LJw082a, 97, 98, 99)
		tab penblock1type if _intrk08 == 1, m


		replace penblock1type  = 1 if penblock1type == 8 & LJw001a == 1
		replace penblock1type  = 2 if penblock1type == 8 & LJw001a == 2
		replace penblock1type  = 3 if penblock1type == 8 & LJw001a == 3

		label values penblock1type pentype
		tab penblock1type if _intrk08 == 1, m

		tab penblock1type penblock1 if _intrk08 == 1, m

		** what happened to the pension? 
		tab LJw097m1a LJ085 if penblock1 == 1 & _intrk08 == 1, m  
		 /* 37 guys say none, or deny being included in pension plan
  		  	or refuse, ans so get skipped out of being asked what 
			happened with the plan. Should we recode them as penblock1 == 0? */
	
		/* generate  penblock1 result which is set to 1 if pension is still active - i.e. 
  			receiving benefits, left in the plan, transferred to new employer, 0 if rolled over 
  			or converted  */	
   
		tab LJw097m1a LJ085 if penblock1 == 1 & _intrk08 == 1, m  
		cap drop penblock1result
		egen penblock1result = anymatch(LJw097m1a LJw097m2a LJw097m3a LJw097m4a), v(8 3 5 7)
		replace penblock1result = . if _intrk08 != 1								 
		
		tab penblock1type penblock1result if _intrk08 ==1, m

	*3. penblock 2:  asked of everybody who reports working for pay in 08
		tab penblock2 if _intrk08==1
		
		
		tab LJ393_1  /* type of plan 1*/
		tab LJ338_1  /* type of plan 1*/ 

		cap drop penblock2type 
		gen penblock2type = 0 if !mi(penblock2)
		replace penblock2type = 1 if inlist(LJ393_1, 3, 12, 16)
		replace penblock2type = 2 if inlist(LJ393_1, 1,2,4,5,6,7,8,9,10,11,13,14)
		replace penblock2type = 3 if LJ393_1 == 15
		replace penblock2type = 8 if inlist(LJ393_1, 97, 98, 99)
		tab penblock2type if _intrk08 == 1, m


		tab LJ338_1 if penblock2type > 96 & !mi(penblock2type) 

		replace penblock2type  = 1 if penblock2type == 8 & LJ338_1 == 1
		replace penblock2type  = 2 if penblock2type == 8 & LJ338_1 == 2
		replace penblock2type  = 3 if penblock2type == 8 & LJ338_1 == 3

		label values penblock2type pentype
		tab penblock2type if _intrk08 == 1, m


	**4. penblock 4 asked of everybody ( regardless of working status in 08 who is under 70.5 and not
	** living full time in a nursing home. we don't know anything about result or status. 
		tab penblock4 if _intrk08==1
		tab penblock4 Jw069_1, m
		
	** 5. Previously reported pension, know type, and asked about status:	
		tab LZ140_1 if _intrk08 ==1, m
		cap drop pastpenblock
		gen pastpenblock  =1 if !mi(LZ140_1) 
		tab pastpenblock
		
		cap drop pastpenblocktype
		gen pastpenblocktype = 1 if inlist(LZ140_1, 1, 3) 
		replace pastpenblocktype = 2 if inlist(LZ140_1, 2, 4) 
		label values pastpenblocktype pentype
		tab pastpenblocktype
		
		
		/* past pen block result --> 1 if still expecting to or currently recieving  benefits
  		 0 if cashed out, rolled over, lost, or record innacurate */

		tab LJ434_1m1 LZ140_1 if _intrk08 ==1, m /* what are you doing with the type A account*/
		tab LJ450_1m1 LZ140_1 if _intrk08 ==1, m /* what are you doing with the type B account  */

		egen pastpenblockresult = anymatch(LJ434_1m1 LJ450_1m1), v(1 2)
		replace pastpenblockresult = . if _intrk08 != 1
		label variable pastpenblockresult pastpenblockresult
		tab pastpenblockresult





		** See who doesnt get any pension block, or for whom we have no info:
		cap drop penblockmiss
		egen penblockmiss = rowmiss(pastpenblock LZ133 penblock1 penblock2 penblock4) if _intrk08 == 1
		tab penblockmiss if _intrk08 == 1
		
		cap drop penblockmiss2
		egen penblockmiss2 = rowmiss(pastpenblock penblock1 penblock2 penblock4) if _intrk08 == 1
		tab penblockmiss2 if _intrk08 == 1
 	** look at number of pension by status -- makes sense..	
		tab comb0608_2 penblockmiss2 if _intrk08 ==1, m 
		tab Lage6 penblockmiss2 if _intrk08 ==1, m
		tab gender penblockmiss2 if _intrk08 ==1, m

	** Just LZ133 (only pension info we have is from the preload) or Just penblock4 (only pension info 
	**we have is from the penblock4):
		cap drop onlypen*
		gen onlypen1 = 1 if penblockmiss==3 & !mi(LZ133)
		gen onlypen4 = 1 if penblockmiss==3 & !mi(penblock4)

		tab onlypen1 onlypen4 if _intrk08 == 1, m


		tab comb0608_2 LZ140_1 if _intrk08 == 1 & onlypen == 1, m
		tab Lage6 onlypen1 if _intrk08 == 1, m

		tab LZ140_1 onlypen1 if Lage>70 & _intrk08 ==1, m


		tab LZ140_1 if LZ133 == 5
		tab LZ140_1 penblock4 if LZ133 == 5

	** number of pensions by age:
	
	tab Lage6 penblockmiss if _intrk08 == 1, m

	** unorganized exploration
		tab LZ133 LZ140_1 if _intrk08== 1 & _intrk06 == 1, m
		tab LZ133 LZ140_2 if _intrk08== 1 & _intrk06 == 1, m


		tab comb0608_2 penblock4 if _intrk08 == 1 & Lage < 71, m 


		tab LZ133 working08  if _intrk08 ==1, m



** pension count
	
	cap drop pencount*
	gen pencount1 = (pastpenblock*pastpenblockresult) if _intrk08 == 1
	tab pencount1
	gen pencount2 = penblock1*penblock1result if _intrk08 == 1
	replace 
	tab pencount2
	gen pencount3 = penblock2 if _intrk08 == 1
	tab pencount3
	gen pencount4 = penblock4 if _intrk08 == 1

	
	* penblock1result) + penblock2 + penblock4
	list  pastpenblock pastpenblockresult penblock1  penblock1result penblock2 penblock4 in 1/10, noobs
	list  pastpenblock pastpenblockresult penblock1  penblock1result penblock2 penblock4 if !mi(pencount), noobs

		
