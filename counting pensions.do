** counting pensions:
** block 1

tab penblock1 if _intrk08 ==1, m

** how many pensions 
tab LJ085 penblock1 if _intrk08 ==1 ,m
tab LJ086 penblock1 if LJ085 == 98 & _intrk08 ==1 ,m

* generate penblk1_report = in pension block 1, how many pensions do peopel REPORT having
cap drop penblk1_report
gen penblk1_report = LJ085 
replace penblk1_report = 0 if LJ085 == 95
replace penblk1_report = 1 if LJ085 == 98 & LJ086 == 1
replace penblk1_report = 0 if LJ085 == 98 & inlist(LJ086, 8,9)

tab penblk1_report penblock1 if _intrk08 == 1, m


* generate penblk1_list  - how many pensions do people LIST ( actually describe)

tab LJw082a 
tab LJw082b 

LJw082c LJw082d
LJw001a LJw001b LJw001c LJw001d

cap drop penblk1_list
gen penblk1_list = 0 if penblock1 ==1
local rounds a b c d
foreach n of local rounds {
	replace penblk1_list = penblk1_list + 1 if inlist(LJw082`n', 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,15,97)
	replace penblk1_list = penblk1_list + 1 if inlist(LJw082`n',98,99) & inlist(LJw001`n', 1,2,3 ,8)  
	}
	
tab penblk1_list	 

tab penblk1_report penblk1_list if penblock1 == 1, m


** how many of each type: 

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
