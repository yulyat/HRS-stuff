cap drop weight
gen weight = round(N_type/n_type, .1) if insample == 1

tab Lage6 if insample == 1 [aw=weight]
