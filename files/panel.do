
********************************************************************************
*		a simulated data to illustrate panel data approach					   *
********************************************************************************

*****part1: simulate a dataset*****
//set up parameters
global gamsim=8 //control for correlation between a and x; zero means no correlation
global b=6 //control for the effect of x on y

//initialize a panel structure, N=2000,T=5
drop _all
set obs 10000
egen id=seq(), block(5)
bys id: gen time=2000+_n

//generate: observed, explantory variables
set seed 2803
gen x = rbinomial(11, 0.5) 

//generate: unobserved, individual heterogeneity; ui=gamsim*xsqbar+asim_random
gen xsq=x*x
bys id: egen xsqbar=mean(xsq) //create an arbitrary sort of relationship between  x and a
gen asim_correlated=${gamsim}*xsqbar
gen rannum = runiform()
bys id: egen asim_random = mean(rannum) 
	//note this is not constructed to be zero mean, so no need to include constant in generating y
gen asim=asim_correlated+asim_random

//generate: unobserved, idiosyncratic error (assuming standard normal)
gen usim = rnormal() 

//generate: y=b*x+asim+usim
gen y=${b}*x+asim+usim

//check out correlation between a and x
corr asim x

*****part2: estimate using alternative estimators. compare with true value=b*****
//1: OLS estimator
reg y x

//2: FD estimator
xtset id time //declare panel structure
reg d.y d.x, nocons

//3: FE (Within) estimator
xtset id time //declare panel structure
xtreg y x,fe //the last line reports F test for H0: ui=0 (for all i)
 
//4: dummy estimator
reg y x i.id //good for small N sample; otherwise takes long time
reghdfe y x, absorb(id) //computationally more efficient for large N sample.

//5: RE estimator
xtset id time //declare panel structure
xtreg y x,re

//6: CRE estimator
xtset id time //declare panel structure
bys id: egen xbar=mean(x) //step1: create xbar
xtreg y x xbar, re //step2: include xbar in the regression

//test1: presence of individual heterogeneity? 
xtreg y x,fe //the last line automatically reports F test for H0: ui=0 (for all i)

//test2: FE or RE?
//approach 1: Hausman test
xtreg y x, re //RE estimate
est store re //store the results 
xtreg y x, fe //FE estimate 
est store fe //store the results
hausman fe re // hausman test; H0:bfe=bre, so rejection means fe is better

//approach 2: test after CRE
xtreg y x xbar, re 
	//H0: gamma=0 for all x, so rejection means fe is better
	//if multiple xbar, e.g., x1bar, x2bar, then it's a joint hypothesis test





















