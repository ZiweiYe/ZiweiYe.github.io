*******************************************************************************
*     	program: a sample do-file											  *
*		author:  Z.Y.														  *
*		created: 09/03/2023													  *
*		updated: 09/06/2023													  *
*******************************************************************************

/*需要用好几行的长说明可以放这里。
关于stata软件使用，更多的内容请见https://www.stata.com
关于stata入门指南，更多的内容请输入help gsm*/

cd "/Users/eleven/Desktop" //设定工作路径
capture log close //关闭正在运行的工作日志(如果有的话)
log using "sample_log", replace text //创建一个新的名叫“sample_log”的工作日志，从这里开始作记录


//打开数据
sysuse auto
*use "saved.dta", clear


//使用summarize命令进行数据分析
summarize price
su price

summarize price if make=="BMW 320i" 
summarize price if make=="BMW 320i", detail
bysort rep78: summarize price 

summarize price if rep78==2
display r(N)

//保存数据:路径+文件名
save "saved.dta", replace 

//保存工作日志并退出
log close
exit
