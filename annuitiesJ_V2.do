clear
use $track_preload_J08Working



** pensions reported converted to annuities from pen1
* annuJ1 = pension mentioned in pen1 that was reported converted to an annuity:
	cap drop __00000*
	cap drop annuJ1_round*

	forvalues n = 1/4 {
		gen annuJ1_round`n' = inlist(pen1_round`n', 1,11, 2, 22) if !mi(pen1indicator)
	}

	local i = 1
		forvalues n = 1/4 {
			tempvar pbstat
					
			if (`i' == 1)  {
					
				egen `pbstat' = anymatch(LJ450_`n'm1 LJ450_`n'm2 LJ450_`n'm3 LJ450_`n'm4 LJ450_`n'm5), v(4)
				}
			else if (`i' == 2) {
				egen `pbstat' = anymatch( LJ450_`n'm1 LJ450_`n'm2 LJ450_`n'm3 ), v(4)
				}
			else if `i' == 3   {
				egen `pbstat' = anymatch(LJ450_`n'm1 LJ450_`n'm2 LJ450_`n'm3), v(4)
				}
			else if `i' == 4   {
				egen `pbstat' = anymatch(LJ450_`n'm1 LJ450_`n'm2), v(4)
				}

			replace annuJ1_round`n' = 0 if  annuJ1_round`n' == 1 & `pbstat' != 1   /* set to 1 if pension turned into annuity*/
			local i = `i' + 1
			tab annuJ1_round`n'
			}

			cap drop __00000*

** pensions coverted to annuities from pen2:
* annuJ2 = pension mentioned in pen2 converted into :
/*
recall pen2_roundn is the type of pension in round n of pen2. pen2_roundnact 
identifies if that pensions is active. use same strategy to identify those 
pensions in each round that have been converted to annuities ( dont care what type) */
		
		cap drop annuJ2_round*

		local rounds a b c d
		foreach n of local rounds {
			gen annuJ2_round`n' = inlist(pen2_round`n', 1, 2, 3, 4, 11, 22, 33, 44) if !mi(pen2indicator)
		} 

		
		
		local i = 1
		local rounds a b c d
		foreach n of local rounds {
		tempvar pnstat

			if (`i' == 1 | `i' == 2) {
				egen `pnstat' = anymatch(LJw097m1`n' LJw097m2`n' LJw097m3`n' LJw097m4`n'), v(4)
				}
			else if `i' == 3 {
				egen `pnstat' = anymatch(LJw097m1`n' LJw097m2`n' LJw097m3`n'), v(4)
				}
			else if `i' == 4 {
				egen `pnstat' = anymatch(LJw097m1`n' LJw097m2`n'), v(4)
				}
			replace annuJ2_round`n' = 0  if annuJ2_round`n' == 1 & `pnstat' != 1 /* set to 0 if pension was NOT turned into annuity (so only annuity pensions survive)*/
			local i = `i' + 1
			}

			cap drop __00000*


	* add 'em up:

	cap drop annuJ1_total
	egen annuJ1_total = anycount(annuJ1_round*), v(1)
	replace annuJ1_total = . if (pen1indicator!=1 | pen1==-1)
	la var annuJ1_total "pen1 pensions converted to annuities"
	

	cap drop annuJ2_total
	egen annuJ2_total = anycount(annuJ2_round*), v(1)
	replace annuJ2_total = . if (pen2indicator!=1 | pen2==-1)
	la var annuJ2_total "pen2 pensions converted to annuities"
	




save $track_preload_J08Working, replace









