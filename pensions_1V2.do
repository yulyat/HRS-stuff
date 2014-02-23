
* this do file is first in the pensions workflow - it uses dataset $track_preload_J08
* and creates the first round of variables for the analysis [ this is anything not
* included in the actual counting of pension block and types]
** Latest version (V2): 2-23-14


clear
set more off

use $track_preload_J08Working
save "$track_preload_J08Working", replace


	
		*  _intrk08 
		******************


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



    	*Age 6 categories
		*****************


			#delimit ;
			cap label drop age6; 
			label define age6 
			1 "Below 50" 
			2 "50 to 54"
			3 "55 to 59"
			4 "60 to 64"
			5 "65 to 69"
			6 "70 and above";
			#delimit cr


		cap drop Lage6
		gen Lage6 = 1 if Lage < 50 
		replace Lage6 = 2 if Lage>= 50 & Lage < 55
		replace Lage6 = 3 if Lage>= 55 & Lage < 60
		replace Lage6 = 4 if Lage>= 60 & Lage < 65
		replace Lage6 = 5 if Lage>= 65 & Lage < 70
		replace Lage6 = 6 if Lage >= 70 & Lage < 996

		label values Lage6 age6
		** create gender label for later:

			#delimit ;
			cap label drop gender;
			label define gender 
			1 "male" 
			2 "female";
			#delimit cr
		label values gender gender

	 	*Comb0608 
	 	**********

	 	/* first create working and retirement status dummies for each wave, 
	 	   then combine.  */
			#delimit ;						
 			cap label drop yesno;						
 			label define yesno1 						
 			1  "yes"						
 			5  "no";						
 			#delimit cr		

	 	 	*2006 retirement and working status dummies using preload:
 
 			cap drop retired06
 			gen retired06 = LZ124						
			label values retired06 yesno1  
  
 			cap drop working06
 			gen working06 = LZ123 
 			label values working06 yesno1
   
   
 		 	* 2008 retirement and working status dummies using Jfile:
  	
			cap drop working08 
			gen working08 = LJ020
			label values working08 yesno1
			
			cap drop retired08
			egen retired08 = anymatch(LJ005*), v(5)
			replace retired08 = . if _intrk08 != 1
			replace retired08 = 5 if retired08 == 0
			
			*Additional imputations
			replace working08=1 if retired08==5 & working08==9
			replace working08=5 if retired08==1 & working08==9
				
			* Jstatus08 - retirement and working status in 08			
			cap drop jstatus08
			gen jstatus08 = .
			replace jstatus08 = 1 if working08 ==1 & retired08 == 1
			replace jstatus08 = 2 if working08 ==5 & retired08 == 1
			replace jstatus08 = 3 if working08 ==1 & retired08 == 5
			replace jstatus08 = 4 if working08 ==5 & retired08 == 5
			

			#delimit ; 
			cap label drop jstatus08;
			label define jstatus08   
			1 "working, retired"
          	2 "not working,retired"
            3 "working, not retired" 
            4 "not working, not retired"; 
			#delimit cr
			label values jstatus08 jstatus08 
				
			* LJ021 - self/else employed 2008			
			cap drop selfelse08	
			gen selfelse08 =  LJ021
			
			*Additional imputations
			replace selfelse08=1 if selfelse==8

			#delimit ; 
			cap label drop selfelse08;
			label define selfelse08   
			1 "else"
          	2 "self"
            8 "dk" 
            9 "rf"; 
			#delimit cr
			label values selfelse08 selfelse08 
				

			* LZ136 - self /else employed from preload 2006
			cap drop selfelse06	
			gen selfelse06 = LZ136
			label values selfelse06 selfelse08 

				
			* LJ045 - change jobs since previous wave
					
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
			
			*Additional imputations
			gen LJ045n=LJ045
			label values LJ045n LJ045
			replace LJ045n=1 if LJ045==7 | LJ045==8 | LJ045==9
			

		* previous wave R had pension on job: 
				cap drop jobpension06
				gen jobpension06 = LZ133
				label values jobpension06 yesno1
				



		** comb0608 
		***********

	 	/*	combination status variable */
	 	cap drop comb0608
		gen comb0608=.
		replace comb0608=1 if working06==1 & selfelse06==2 & working08==1 & selfelse08==2
		replace comb0608=2 if working06==1 & selfelse06==2 & working08==1 & selfelse08==1
		replace comb0608=3 if working06==1 & selfelse06==2 & working08==5
		replace comb0608=4 if working06==1 & selfelse06==1 & working08==1 & selfelse08==2
		replace comb0608=5 if working06==1 & selfelse06==1 & working08==1 & selfelse08==1 & (LJ045n==1 | LJ045n==3)
		replace comb0608=6 if working06==1 & selfelse06==1 & working08==1 & selfelse08==1 & (LJ045n==4 | LJ045n==5)
		replace comb0608=7 if working06==1 & selfelse06==1 & working08==5
		replace comb0608=8 if working06==5 & working08==1 & selfelse08==2
		replace comb0608=9 if working06==5 & working08==1 & selfelse08==1
		replace comb0608=10 if working06==5 & working08==5
		replace comb0608=11 if LJ705 == 1
		replace comb0608=12 if LA019 > 70 & !mi(LA019) &comb0608 >9
		replace comb0608=12 if (LA028 == 1 & LA070 == 5) &comb0608 >9

			#delimit ;
			cap label drop comb0608;
			label define comb0608
			1 "06s 08s" 
			2 "06s 08e" 
			3 "06s 08u" 
			4 "06e 08s" 
			5 "06e 08eo" 
			6 "06e 08en" 
			7 "06e 08u" 
			8 "06u 08s" 
			9 "06u 08e" 
			10 "06u 08u"
			11 "UU" 
			12 "old&NH";
			#delimit cr
			label values comb0608 comb0608
	
	
		
		* oldNH - dummy set to 1 if respondent is over 71 or a fulltime nursing home resident
		cap drop oldNH
		gen oldNH = 1 if (LA019 > 70 & !mi(LA019)) 
		replace oldNH = 1 if (LA028 == 1 & LA070 == 5)
		tab oldNH

save "$track_preload_J08Working", replace

	
