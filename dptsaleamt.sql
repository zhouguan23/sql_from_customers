select f.factid,factname,
 a.item_name,a.guige,a.um,a.pri_sale,sum(a.sl) al,sum(a.je) amt
 from  ddsal a,factory f,item i 
where a.item_id=i.id and i.factid=f.factid 
and dd_id>'201506300000000000000000000000'
${if(len(dpt)==0,""," and substr(a.cust_id,1,6) in ('"+dpt+"')") }

group by f.factid,factname,
 a.item_name,a.guige,a.um,a.pri_sale
having sum(sl)<>0




select f.factid,factname,
 i.itemname,i.guige,i.um,i.pri_sale,sum(a.sl) sl, a.note
 from  ddsal_bh a,factory f,item_bh i 
where a.item_id=i.id and i.factid=f.factid  and (a.sl<>0 or a.note is not null)
 and substr(dd_id,1,8)>'20150630' AND SUBSTR(DD_ID,1,8)<'20151030' 
${if(len(dpt)==0,""," and substr(a.cust_id,1,6) in ('"+dpt+"')") }
and dd_id>'201506300000000000000000000000'
group by f.factid,factname,
 i.itemname,i.guige,i.um,i.pri_sale,a.note
 

select item_id,itemname,guige,um,sum(a.sl) qty,a.note from 
ddsal_bh a,item_bh b
 
where a.item_id=b.id and dd_id>'201506300000000000000000000000'
and substr(cust_id,1,6)=(select cant_id from dw where dw_id='${dpt}')
and substr(dd_id,1,8)>'20150630' AND SUBSTR(DD_ID,1,8)<'20151030'
and ( a.sl<>0 or a.note is not null)
and b.factid='${factid}' group by item_id,itemname,guige,um,a.note  having sum(a.sl)<>0 order by   item_id

select * from factory order by factname

select * from dw

