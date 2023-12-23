
//OLS
reg lwage educ exper expersq black smsa smsa66 south 
	
//2SLS, manually - not recommended
reg educ nearc4 nearc2 exper expersq black smsa smsa66 south 
predict educhat, xb	
	//first stage 

reg lwage educhat exper expersq black smsa smsa66 south 
	//second stage, but incorrect standard error

//2SLS, using package - recommended
ivregress 2sls lwage exper expersq black smsa smsa66 south (educ=nearc2 nearc4)
estat endogenous    //endogeneity test (H0:suspected endogenous variables is exogenous?) 
					//results: endogenous at 10% significance level
estat overid   		//overidentification test (H0:IVs are exogenous?) 
					//results: endogenous at 10% significance level
estat firststage    //weak instrument test （chi-square) (H0:IVs are weak?) 
					//results: relatively weak (F only slightly greater than 25% critical value)
