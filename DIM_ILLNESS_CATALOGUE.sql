select a.*,g.SPECIFICATION,g.MANUFACTURER from DIM_ILLNESS_CATALOGUE a
left join dim_goods g
on a.goods_code=g.goods_code
where 
1=1
${if(len(code) = 0, "", " and a.goods_code in ('" + code + "')")}
${if(len(ill) = 0, "", " and a.ill_type in ('" + ill + "')")}
${if(len(core) = 0, "", " and a.IS_CORE='" + core + "'")}
${if(len(contact) = 0, "", " and a.IS_CONTACT='" + contact + "'")}
order by a.goods_code

select distinct ill_type from DIM_ILLNESS_CATALOGUE

select distinct goods_code from DIM_ILLNESS_CATALOGUE

select distinct goods_code,goods_name from dim_goods

select * from user_authority
where  ${"user_id='"+$fr_username+"'"}
and  edit_authority=1

