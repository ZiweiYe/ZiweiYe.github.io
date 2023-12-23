
//OLS estimation
reg hours lwage educ age kidslt6 nwifeinc
reg lwage hours educ exper expersq

//test for rank condition
reg hours educ age kidslt6 nwifeinc exper expersq
test (exper=0)(expersq=0)
	//rejection. so (exper expersq) are good for rank condition
	//hours equation can be identified.

reg lwage educ exper expersq age kidslt6 nwifeinc
test (age=0)(kidslt6=0)(nwifeinc=0)
	//fail to reject. so (age kidslt6 nwifeinc) are not good for rank condition
	//lwage equation cannot be identified.
	
//2SLS estimation
reg hours educ exper expersq age kidslt6 nwifeinc
predict hourshat,xb
reg lwage hourshat educ exper expersq

