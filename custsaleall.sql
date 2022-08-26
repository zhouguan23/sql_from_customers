select  aa.cust_id,cust_name,busi_addr,order_tel,factname,zp,itemname,guige,um,pri_sale,sl,je,c.note from 
(
select a.cust_id, factname,'正品' zp,itemname ,a.guige,a.um,a.pri_sale,sum(sl)sl ,sum(je) je ,'' note
from ddsal a,factory f,item i 
 where a.item_id=i.id and a.fact_id=f.factid  
 and substr(a.cust_id,1,6)='${dpt}' and dd_id>'201506300000000000000000000000'
 group by a.cust_id ,factname,itemname,a.guige,a.um,a.pri_sale having sum(sl)<>0
 union 
 select a.cust_id, factname,'货补' zp,itemname ,i.guige,i.um,i.pri_sale, sl,0  je,a.note
from  ddsal_bh a,factory f,item_bh i 
 where a.item_id=i.id and substr(a.item_id,1,3)=f.factid  and  dd_id>'201506300000000000000000000000'
 and substr(a.cust_id,1,6)='${dpt}' and (sl<>0 or a.note is not null)

 ) c,yao_cust aa where c.cust_id=aa.license_code order by aa.cust_id,zp desc


select * from dw

