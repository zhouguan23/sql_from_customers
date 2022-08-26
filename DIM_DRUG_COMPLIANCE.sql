select a.* from DIM_ILLNESS_CATALOGUE a
where 
1=1
${if(len(code) = 0, "", " and a.goods_code in ('" + code + "')")}
${if(len(ill) = 0, "", " and a.ill_type in ('" + ill + "')")}
${if(len(core) = 0, "", " and a.IS_CORE='" + core + "'")}
${if(len(contact) = 0, "", " and a.IS_CONTACT='" + contact + "'")}
order by goods_code

select distinct ill_type from DIM_ILLNESS_CATALOGUE

select distinct goods_code from DIM_DRUG_COMPLIANCE

select distinct goods_code,goods_name,SPECIFICATION,MANUFACTURER from dim_goods

select a.* from DIM_DRUG_COMPLIANCE a
where 
1=1
${if(len(code) = 0, "", " and a.goods_code in ('" + code + "')")}
order by goods_code

