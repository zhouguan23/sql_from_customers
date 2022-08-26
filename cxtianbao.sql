select substr(BRDOWNER_name,1,4) factname ,a.item_id,item_name,pri_wsale,yuce
from plm_item p,item_com ic,hztianbao a,PLM_BRANDOWNER@hzyx f
where p.item_id=ic.item_id and ic.item_id=a.item_id and p.brdowner_id=f.brdowner_id
and a.sale_dept_id='11371703' and date1='${date1}'
and status='01'  and p.item_kind=1 order by f.brdowner_id,pri_wsale desc

