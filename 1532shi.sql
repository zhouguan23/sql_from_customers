select   cust_name,factname,co.id,itemname,guige,co.um,qty_ord,pri_puh,qty_ord*pri_puh qtycaiguo
,pri_saletocust, qty_ord*pri_saletocust qtycust

from drf_factory f,drf_co co ,drf_item aa where f.factid=co.factid 
and co.id=aa.id 
 ${if(len(ccid)==0,""," and substr(co.custid,1,2)='"+ccid+"'")}
${if(len(cid)==0,""," and co.custid='"+cid+"'")}
  ${if(len(factid)==0,""," and co.factid='"+factid+"'")}


 order by cust_name,f.factid,aa.id

select distinct custid,custid||'-'||cust_name from drf_co
${if(len(ccid)==0 ,""," where  substr(custid,1,2)='"+ccid+"'")}


select a.custid,cust_name,dd.factid,factname,policy,a.note from  drf_factory dd,drf_policy a,
(select distinct custid,cust_name from drf_co)  d
where   a.factid=dd.factid and a.custid=d.custid

 ${if(len(ccid)==0,""," and substr(a.custid,1,2)='"+ccid+"'")}
  ${if(len(cid)==0,""," and a.custid='"+cid+"'")}
  ${if(len(factid)==0,""," and dd.factid='"+factid+"'")}


select factid,factname from drf_factory 
 
 where factid in
 (select distinct factid from drf_co where custid='${cid}' ) order by factid

