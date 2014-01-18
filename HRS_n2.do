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


tab comb0608 if _intrk08 == 1, m
tab comb0608 penblock1 if _intrk08==1,m

tab comb0608 penblock1 if mi(penblock1) & _intrk08==1,m


tab comb0608 pb1miss if mi(penblock1) & _intrk08==1,m

** generate pb1miss, equal to 1 if respondent changed status between 06&08 ( deltastatus ==1) but is missing pensionblock1:

gen pb1miss = 0 if _intrk08 == 1 
replace pb1miss= 1 if mi(penblock1) & deltastatus == 1

tab LZ133 if pb1miss == 1

tab penblock2 if pb1miss == 1 & _intrk08 == 1,m



/*
** Why missing from penblock1? lapses in employment status, respondent negates preloads, no  preloaded employer name,e tc

 1 -  deny working for self in previous IW (LJ023 ==97)
 2 - complication in self employment status 96 on LJ023 & 5 on LJ028
 3  when asked why status changed, responds that status did not change - J063 = 92, 93, 97 94 ( last one is confusing, because then J021 shoulod have been recoded...)

  --  no job title from previous wave: LJ684 == 0 ( this is J058 branchpoint in survey) // this one does not seem to be a problem, so not included
  --  LJ045 == 7, 8,9 ( denies working from previous employer, dk, rf) - this is also not an issue
  --- LJ683 ==1 ( I think this is JW186 == 7 - denies working for employer which is named in preload - also not an issue

*/
cap drop whypb1miss
gen whypb1miss = 0 if _intrk08 ==1
replace whypb1miss = 1 if LJ023 == 97
replace whypb1miss = 2 if LJ023 == 96 & LJ028 == 5
replace whypb1miss = 3 if inlist(LJ063,92,93,94,97)

tab pb1miss penblock2 if mi(penblock1) & _intrk08==1,m

tab whypb1miss penblock2 if mi(penblock1) & _intrk08==1,m

***  past pension block
tab comb0608 LJw066 if _intrk08==1,m

***  preload
tab comb0608 LZ133 if _intrk08==1,m

tab comb0608 MZ133 if _intrk08==1,m

tab comb0608 deltastatus if _intrk08 ==1 , m

**   what variables make up the preload? 
tab MZ133 if _intrk08 == 1 & _intrk10 == 1, m

*** generate pretend 2010 preload:

cap drop PZ133

gen PZ133 = 0 if _intrk08 == 1 & _intrk10 == 1
replace PZ133 = 5 if inlist(working08,5,8,9)
replace PZ133 = 1 if working08 == 1 &  penblock2 == 1
replace PZ133 = 5 if working08 == 1 &  penblock2 == 0

tab PZ133 MZ133 if _intrk08 == 1 & _intrk10 == 1, m

tab comb0608_2 working08 if PZ133 == 0 & _intrk08 == 1, m

tab comb0608_2 working08 if  _intrk08 == 1 & _intrk06 == 1, m
tab selfelse06 selfelse08 if  _intrk08 == 1 & _intrk06 == 1 & mi(comb0608_2), m

list working06 selfelse06 working08 selfelse08 if  _intrk08 == 1 & _intrk06 == 1 & mi(comb0608_2), noobs

gen test = working08
tab working08 test, m
cap drop test

cap drop PZ133
gen PZ133 = .
replace PZ133 = LJ084 /* from penblock1*/
replace PZ133 = 1 if (LJ848 == 1 & LJ849 == 1) 
replace PZ133 = 5 if LJ848 == 1 & inlist(LJ849,5,8,9)
replace PZ133 = 1 if LJ324 == 1 /*from penblock2 */
replace PZ133 = 5 if (inlist(LJ324,5,8,9) | inlist(LJ848,5,8,9))
replace PZ133 = 10 if LJ705 ==1  /* not working previous 2 waves (04, 06, 08 */
replace PZ133 = 11 if previra ==1  /* previous wave reports IRA*/


tab PZ133 MZ133 if _intrk08 == 1 & _intrk10 == 1, m
tab comb0608 if mi(PZ133) & MZ133 == 5 & _intrk08 == 1 & _intrk10 == 1, m 
tab penblock1 if mi(PZ133) & MZ133 == 5 & _intrk08 == 1 & _intrk10 == 1, m 
tab LZ140_1 if mi(PZ133) & MZ133 == 5 & _intrk08 == 1 & _intrk10 == 1, m 

tab LJw066 previra if mi(PZ133) & MZ133 == 5 & _intrk08 == 1 & _intrk10 == 1, m 


gen previra = 1 if LZ169 > 0 &!mi(LZ169) & _intrk08 ==1
tab previra LJw066



tab LJ005m1
tab LJw066 penblock1 

tab LJ705 LZ211

tab LZ133 MZ133 if deltastatus == 1
tab LZ133 MZ133 if deltastatus == 0

tab comb0608 LJ705 if _intrk08 == 1, m 

tab comb0608 LJ703 if _intrk08 == 1, m 
tab MZ133 LJ705 if _intrk08 == 1 & _intrk10 ==1, m

tab penblock1 penblock2 if _intrk08 == 1 & _intrk10 == 1, m




 * who gets last pen block?
 
 tab comb0608_2 LJw066 if _intrk08 ==1, m
  tab comb0608_2 LJw066 if _intrk08 ==1 & Lage > 71, m
    tab comb0608_2 LJw066 if _intrk08 ==1 & Lage <70 , m
tab LJw066 if _intrk08, m

cap drop penblock4
gen penblock4 = 1 if inlist(LJw066, 1, 2) 
replace penblock4 = 0 if inlist(LJw066, 5,8,9)



***


*4 options for pension blocks:

* 1. report on the job pension in 06. Everybody who was in the sample in o6 and 
* 08 has this value - will be 0 if not working in 06

tab LZ133 if _intrk08 ==1, m

* 2. penblock1: asked of most of those those who changed Job status between 06 and 08 
* so refers to a job they had previous to 06
tab penblock1 if _intrk08 ==1, m

*3. penblock 2:  asked of everybody who reports working for pay in 08
tab penblock2 if _intrk08==1

**4. penblock 4 asked of everybody ( regardless of working status in 08 who is under 70.5 and not
** living full time in a nursing home. 
tab penblock4 if _intrk08==1


** See who doesnt get any pension block, or for whom we have no info:
cap drop penblockmiss
egen penblockmiss = rowmiss(LZ133 penblock1 penblock2 penblock4) if _intrk08 == 1
tab penblockmiss 

tab LZ133 LZ140_1 if _intrk08== 1 & _intrk06 == 1, m
tab LZ133 LZ140_2 if _intrk08== 1 & _intrk06 == 1, m


tab comb0608_2 penblock4 if _intrk08 == 1 & Lage < 71, m 


tab LZ133 working08  if _intrk08 ==1, m






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

** penblock 2
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



* Penblock1: 

tab LJw082a penblock1 if _intrk08 ==1, m


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
tab LJw082a if penblock1type == 0 & penblock1 == 1




