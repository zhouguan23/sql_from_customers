select d.factid,d.factname,di.id,itemname,di.guige,a.um,sum(qty_ord) qty, a.pri_puh,sum(pri_puh*qty_ord) amtcaigou,
pri_saletocust,sum(qty_ord*pri_saletocust) amtcust from drf_co a,drf_factory d,drf_item di

where a.id=di.id and a.factid=d.factid  and a.factid='${factid}'
 ${if(len(dptid)==0,""," and substr(a.custid,1,2)='"+dptid+"'")}
group by d.factid,d.factname,di.id,itemname,di.guige,a.um,a.pri_puh,pri_saletocust

select factid,factname from drf_factory order by factid

select a.factid,factname,b.custid,cust_name,policy,a.note from drf_policy a,drf_factory ff,
(
select distinct custid,cust_name from drf_co 
) b
where a.custid=b.custid and a.factid=ff.factid
and ff.factid='${factid}'  
 ${if(len(dptid)==0,""," and substr(b.custid,1,2)='"+dptid+"'")}
order by ff.factid

