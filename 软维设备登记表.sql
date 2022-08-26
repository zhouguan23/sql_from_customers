select * from 
TB软维设备登记表
where  1=1 ${if(len(bm)==0,"","and 部门编码 in ('"+replace(bm,",","','")+"')")} 

select nodecode,nodecode+' '+nodename node from 
[000]A.tbnode

