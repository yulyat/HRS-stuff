
do "$dofile_repository/mergeQtoMaster.do"


* frequencies of Assets, annuities, from Q and J file:


tab IRA_Q, m
tab annu1_Q, m
tab annu2_Q, m

tab annuJ1_total, m
tab annuJ2_total, m
