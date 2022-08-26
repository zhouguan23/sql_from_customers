select ld.deliver_id,pi.item_id,pi.item_name,sum(li.qty*pi.t_size)/10000   
from ldm_dist  ld,ldm_dist_item li,plm_item pi,plm_item_com pc
where  li.dist_num=ld.dist_num
and li.item_id=pi.item_id
and li.item_id=pc.item_id
and ld.dist_date>='20211101'
and ld.dist_date<='20211130'
and deliver_id='17090100'
${if(deliver_id='17040100' ,"and ld.rut_id<>'170400303'","")}
group by  ld.deliver_id,pi.item_id,pi.item_name

select ld.deliver_id,pi.item_id,pi.item_name,sum(li.qty*pi.t_size)/10000 
from ldm_dist  ld,ldm_dist_item li,plm_item pi,plm_item_com pc
where  li.dist_num=ld.dist_num
and li.item_id=pi.item_id
and li.item_id=pc.item_id
and ld.dist_date>='${starttime}'
and ld.dist_date<='${endtime}'
${if(deliver_id='17010100', "and (deliver_id='"+deliver_id+"' or ld.rut_id='170400303')","and deliver_id='"+deliver_id+"'")}
${if(deliver_id='17040100', "and  deliver_id='"+deliver_id+"' and ld.rut_id<>'170400303'","and deliver_id='"+deliver_id+"'")}
--${if(len(deliver_id)==0,"","and deliver_id='"+deliver_id+"'")}

group by  ld.deliver_id,pi.item_id,pi.item_name




select  pi.item_id,pi.item_name,sum(li.qty*pi.t_size)/10000   
from ldm_dist  ld,ldm_dist_item li,plm_item pi,plm_item_com pc
where  li.dist_num=ld.dist_num
and li.item_id=pi.item_id
and li.item_id=pc.item_id
and ld.dist_date>='${starttime}'
and ld.dist_date<='${endtime}'
and ld.deliver_id<>'17010100'
and ld.rut_id<>'170400303'
group by  pi.item_id,pi.item_name


