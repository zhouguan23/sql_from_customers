select fact_id,substr(fact_name,1,4) factname,i.item_id,item_name,qichushang,tzshang,qichuxia,tzxia,pri_wsale,kind from 
item i ,factory f,item_goujin a,item_com ic

 where f.fact_id=i.factory and i.item_id=a.item_id 　and years='2013'
and ic.item_id=i.item_id 

${if(len(fact)==0,"", " and fact_id in ('"+fact+"')")}


order by fact_name desc ,pri_wsale desc



 select i.item_id,item_name,i.item_id||'-'||item_name from item i,item_com ic
where i.item_id=ic.item_id and i.is_mrb=1

${if(len(fact)==0,"", " and factory in ('"+fact+"')")}
and ( i.item_id like '6%' or i.item_id like '8%' or i.item_id like '4%') 
  order by i.factory


select i.item_id,item_name,qtycomfirm from item i ,itemgoujin_list a
where a.item_id=i.item_id and crt_date='${crtdate}'

${if(len(fact)==0,"", " and factory in ('"+fact+"')")}
order by factory 

