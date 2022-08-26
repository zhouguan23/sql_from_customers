with hxj as 
(
select 
    customer_id,
    customer_name,
    customer_root,
    customer_upcustname,
    customer_owner,
    customer_dept,
    customer_park,
    customer_bpbj,
    customer_devicecount,
    customer_size,
    customer_contractcount,
    customer_bndhzcs,
    customer_zjychz,
    customer_zjycfk,
    customer_zjycsw,
    customer_zjycgc,
    customer_whk,
    customer_ysk,
    customer_zzxsje,
    customer_dbsje,
    customer_zbhte,
    customer_province,
    customer_city,
    customer_area,
    customer_upcustid,
    customer_grade1,
    customer_grade2,
    customer_type1,
    customer_type2,
    customer_industry1,
    customer_industry2,
    customer_bpbjhte,
    customer_contracthte
from edw_customer_all
where customer_id
in(
    select 
    customer_downid
    from edw_customer_downcustid
    where customer_id
    in(
        select 
        customer_id
        from edw_customer_all a
        where 1=1
${if(OR(au_customer_alldata='999',fr_username='admin'),"","and (regexp_instr(a.au_dept,'"+au_customer_dept+"')>0 or regexp_instr(a.au_area_dc,'"+au_customer_area_dc+"')>0 or regexp_instr(a.au_customer,'"+au_customer_customer+"')>0 or regexp_instr(a.au_industry,'"+au_customer_industry+"')>0  or regexp_instr(a.au_product_device,'"+au_customer_product_device+"')>0)")}        ${if(len(customer_province)==0,"and 1=1","and customer_province in ('"+customer_province+"')")}
        ${if(len(customer_city)==0,"and 1=1","and customer_city in ('"+customer_city+"')")}
        ${if(len(customer_area)==0,"and 1=1","and customer_area in ('"+customer_area+"')")}
        ${if(sel_ysj='true',"and select_ysj=1","and 1=1")}
        ${if(sel_ywhk='true',"and select_ywhk=1","and 1=1")}
        ${if(sel_state='true',"and select_state in (1,2)","and select_state in (2)")}
        ${if(sel_qdght='true',"and select_qdght=1","and 1=1")}
        ${if(sel_bndhzg='true',"and select_bndhzg=1","and 1=1")}
        ${if(sel_jsnwhz='true',"and select_jsnwhz=1","and 1=1")}
        ${if(sel_jsywswjc='true',"and select_jsywswjc=1","and 1=1")}
        ${if(sel_jsywgcjc='true',"and select_jsywgcjc=1","and 1=1")}
        ${if(sel_bnwfk='true',"and select_bnwfk=1","and 1=1")}
        ${if((sel_park1='false'&&sel_park2='true'),"and select_park=0",
          if((sel_park1='true'&&sel_park2='false'),"and select_park=1","and 1=1"))}
        ${if(len(customer_owner)==0,"and 1=1","and customer_owner in ('"+customer_owner+"')")}
        ${if(len(customer_name)==0,"and 1=1","and customer_name in ('"+customer_name+"')")}
        ${if(len(customer_dept)==0,"and 1=1","and customer_dept in ('"+customer_dept+"')")}
        ${if(len(customer_grade1)==0,"and 1=1","and customer_grade1 in ('"+customer_grade1+"')")}
        ${if(len(customer_grade2)==0,"and 1=1","and customer_grade2 in ('"+customer_grade2+"')")}
        ${if(len(customer_type1)==0,"and 1=1","and (customer_type1 LIKE '%" +REPLACE(customer_type1,"','","%' OR customer_type1 LIKE '%")+"%')")}
        ${if(len(customer_type2)==0,"and 1=1","and (customer_type2 LIKE '%" +REPLACE(customer_type2,"','","%' OR customer_type2 LIKE '%")+"%')")}
        ${if(len(customer_park)==0,"and 1=1","and customer_park in ('"+customer_park+"')")}
        ${if(len(customer_industry1)==0,"and 1=1","and (customer_industry1 LIKE '%" +REPLACE(customer_industry1,"','","%' OR customer_industry1 LIKE '%")+"%')")}
        ${if(len(customer_industry2)==0,"and 1=1","and (customer_industry2 LIKE '%" +REPLACE(customer_industry2,"','","%' OR customer_industry2 LIKE '%")+"%')")}
        ${if(len(link_area)==0,"and 1=1","and (customer_bu in ('"+link_area+"') or customer_province in ('"+link_area+"'))")}
        ${if(len(link_industry1)==0,"and 1=1","and customer_industry1 in ('"+link_industry1+"')")}
        ${if(len(link_industry2)==0,"and 1=1","and customer_industry2 in ('"+link_industry2+"')")}
        ${if(len(link_type1)==0,"and 1=1","and customer_type1 in ('"+link_type1+"')")}
        ${if(len(link_type2)==0,"and 1=1","and customer_type2 in ('"+link_type2+"')")}
        ${if(len(link_grade1)==0,"and 1=1","and customer_grade1 in ('"+link_grade1+"')")}
        ${if(len(link_grade2)==0,"and 1=1","and customer_grade2 in ('"+link_grade2+"')")}
        ${if(len(customer_bu)==0,"and 1=1","and customer_bu in ('"+customer_bu+"')")}
        ${if(len(link_park)==0,"and 1=1","and customer_park in ('"+link_park+"')")}
        ${if(len(link_qdght)==0,"and 1=1","and select_qdght in ('"+link_park+"')")}
      )
  )
),
bhxj as
(
select 
    customer_id,
    customer_name,
    customer_root,
    customer_upcustname,
    customer_owner,
    customer_dept,
    customer_park,
    customer_bpbj,
    customer_devicecount,
    customer_size,
    customer_contractcount,
    customer_bndhzcs,
    customer_zjychz,
    customer_zjycfk,
    customer_zjycsw,
    customer_zjycgc,
    customer_whk,
    customer_ysk,
    customer_zzxsje,
    customer_dbsje,
    customer_zbhte,
    customer_province,
    customer_city,
    customer_area,
    customer_upcustid,
    customer_grade1,
    customer_grade2,
    customer_type1,
    customer_type2,
    customer_industry1,
    customer_industry2,
    customer_bpbjhte,
    customer_contracthte
        from edw_customer_all a
        where 1=1
${if(OR(au_customer_alldata='999',fr_username='admin'),"","and (regexp_instr(a.au_dept,'"+au_customer_dept+"')>0 or regexp_instr(a.au_area_dc,'"+au_customer_area_dc+"')>0 or regexp_instr(a.au_customer,'"+au_customer_customer+"')>0 or regexp_instr(a.au_industry,'"+au_customer_industry+"')>0  or regexp_instr(a.au_product_device,'"+au_customer_product_device+"')>0)")}        
${if(len(customer_province)==0,"and 1=1","and customer_province in ('"+customer_province+"')")}
        ${if(len(customer_city)==0,"and 1=1","and customer_city in ('"+customer_city+"')")}
        ${if(len(customer_area)==0,"and 1=1","and customer_area in ('"+customer_area+"')")}
        ${if(sel_ysj='true',"and select_ysj=1","and 1=1")}
        ${if(sel_ywhk='true',"and select_ywhk=1","and 1=1")}
        ${if(sel_state='true',"and select_state in (1,2)","and select_state in (2)")}
        ${if(sel_qdght='true',"and select_qdght=1","and 1=1")}
        ${if(sel_bndhzg='true',"and select_bndhzg=1","and 1=1")}
        ${if(sel_jsnwhz='true',"and select_jsnwhz=1","and 1=1")}
        ${if(sel_jsywswjc='true',"and select_jsywswjc=1","and 1=1")}
        ${if(sel_jsywgcjc='true',"and select_jsywgcjc=1","and 1=1")}
        ${if(sel_bnwfk='true',"and select_bnwfk=1","and 1=1")}
        ${if((sel_park1='false'&&sel_park2='true'),"and select_park=0",
          if((sel_park1='true'&&sel_park2='false'),"and select_park=1","and 1=1"))}
        ${if(len(customer_owner)==0,"and 1=1","and customer_owner in ('"+customer_owner+"')")}
        ${if(len(customer_name)==0,"and 1=1","and customer_name in ('"+customer_name+"')")}
        ${if(len(customer_dept)==0,"and 1=1","and customer_dept in ('"+customer_dept+"')")}
        ${if(len(customer_grade1)==0,"and 1=1","and customer_grade1 in ('"+customer_grade1+"')")}
        ${if(len(customer_grade2)==0,"and 1=1","and customer_grade2 in ('"+customer_grade2+"')")}
        ${if(len(customer_type1)==0,"and 1=1","and (customer_type1 LIKE '%" +REPLACE(customer_type1,"','","%' OR customer_type1 LIKE '%")+"%')")}
        ${if(len(customer_type2)==0,"and 1=1","and (customer_type2 LIKE '%" +REPLACE(customer_type2,"','","%' OR customer_type2 LIKE '%")+"%')")}
        ${if(len(customer_park)==0,"and 1=1","and customer_park in ('"+customer_park+"')")}
        ${if(len(customer_industry1)==0,"and 1=1","and (customer_industry1 LIKE '%" +REPLACE(customer_industry1,"','","%' OR customer_industry1 LIKE '%")+"%')")}
        ${if(len(customer_industry2)==0,"and 1=1","and (customer_industry2 LIKE '%" +REPLACE(customer_industry2,"','","%' OR customer_industry2 LIKE '%")+"%')")}
        ${if(len(link_area)==0,"and 1=1","and (customer_bu in ('"+link_area+"') or customer_province in ('"+link_area+"'))")}
        ${if(len(link_industry1)==0,"and 1=1","and customer_industry1 in ('"+link_industry1+"')")}
        ${if(len(link_industry2)==0,"and 1=1","and customer_industry2 in ('"+link_industry2+"')")}
        ${if(len(link_type1)==0,"and 1=1","and customer_type1 in ('"+link_type1+"')")}
        ${if(len(link_type2)==0,"and 1=1","and customer_type2 in ('"+link_type2+"')")}
        ${if(len(link_grade1)==0,"and 1=1","and customer_grade1 in ('"+link_grade1+"')")}
        ${if(len(link_grade2)==0,"and 1=1","and customer_grade2 in ('"+link_grade2+"')")}
        ${if(len(customer_bu)==0,"and 1=1","and customer_bu in ('"+customer_bu+"')")}
        ${if(len(link_park)==0,"and 1=1","and customer_park in ('"+link_park+"')")}
        ${if(len(link_qdght)==0,"and 1=1","and select_qdght in ('"+link_park+"')")}
)
select * from
${if(select_inclu="true","hxj","bhxj")}

select distinct customer_province 
from EDW_CUSTOMER_ALL a 
${if(OR(au_customer_alldata='999',fr_username='admin'),"","and (regexp_instr(a.au_dept,'"+au_customer_dept+"')>0 or regexp_instr(a.au_area_dc,'"+au_customer_area_dc+"')>0 or regexp_instr(a.au_customer,'"+au_customer_customer+"')>0 or regexp_instr(a.au_industry,'"+au_customer_industry+"')>0  or regexp_instr(a.au_product_device,'"+au_customer_product_device+"')>0)")}${if(len(customer_bu)==0,"where 1=1","where customer_bu in ('"+customer_bu+"')")}
order by customer_province

select distinct customer_name 
from EDW_CUSTOMER_ALL a
${if(OR(au_customer_alldata='999',fr_username='admin'),"","and (regexp_instr(a.au_dept,'"+au_customer_dept+"')>0 or regexp_instr(a.au_area_dc,'"+au_customer_area_dc+"')>0 or regexp_instr(a.au_customer,'"+au_customer_customer+"')>0 or regexp_instr(a.au_industry,'"+au_customer_industry+"')>0  or regexp_instr(a.au_product_device,'"+au_customer_product_device+"')>0)")}order by customer_name 

select distinct customer_owner from EDW_CUSTOMER_ALL a
where 1=1
${if(OR(au_customer_alldata='999',fr_username='admin'),"","and (regexp_instr(a.au_dept,'"+au_customer_dept+"')>0 or regexp_instr(a.au_area_dc,'"+au_customer_area_dc+"')>0 or regexp_instr(a.au_customer,'"+au_customer_customer+"')>0 or regexp_instr(a.au_industry,'"+au_customer_industry+"')>0  or regexp_instr(a.au_product_device,'"+au_customer_product_device+"')>0)")}order by customer_owner

select distinct customer_dept from EDW_CUSTOMER_ALL a
where 1=1
${if(OR(au_customer_alldata='999',fr_username='admin'),"","and (regexp_instr(a.au_dept,'"+au_customer_dept+"')>0 or regexp_instr(a.au_area_dc,'"+au_customer_area_dc+"')>0 or regexp_instr(a.au_customer,'"+au_customer_customer+"')>0 or regexp_instr(a.au_industry,'"+au_customer_industry+"')>0  or regexp_instr(a.au_product_device,'"+au_customer_product_device+"')>0)")}order by customer_dept

select
C.code_value as customer_type2
from
(select 
(case when length(code_layrec)=17
          then to_number(substr(code_layrec,1,8))
     else code_id
     end
) as code_id1,
(case when length(code_layrec)=17
          then to_number(substr(code_layrec,10,8))
     else code_id
     end
) as code_id2
from DW_DIM_SYSTEM_CODE
where code_type='CRMCustType'
and code_id!='21574484'
and code_id!='21573165'
)A,
DW_DIM_SYSTEM_CODE B,
DW_DIM_SYSTEM_CODE C
where A.code_id1=B.code_id
and A.code_id2=C.code_id
${if(len(customer_type1)==0,"and 1=1","and B.code_value in ('"+customer_type1+"')")}

select distinct
customer_grade1 
from EDW_CUSTOMER_ALL a
where customer_grade1 is not null
${if(OR(fr_username='admin',fr_username='admin'),"","and (regexp_instr(a.AU_DEPT,'"+au_dept+"')>0 or regexp_instr(a.AU_AREA_DC,'"+au_area_dc+"')>0 or regexp_instr(a.AU_INDUSTRY,'"+au_industry+"')>0 or regexp_instr(a.AU_CUSTOMER,'"+au_customer+"')>0 or regexp_instr(a.AU_PRODUCT_DEVICE,'"+au_product_device+"')>0)")}

select distinct
customer_grade2 
from EDW_CUSTOMER_ALL a
where customer_grade2 is not null
${if(OR(au_customer_alldata='999',fr_username='admin'),"","and (regexp_instr(a.au_dept,'"+au_customer_dept+"')>0 or regexp_instr(a.au_area_dc,'"+au_customer_area_dc+"')>0 or regexp_instr(a.au_customer,'"+au_customer_customer+"')>0 or regexp_instr(a.au_industry,'"+au_customer_industry+"')>0  or regexp_instr(a.au_product_device,'"+au_customer_product_device+"')>0)")}${if(len(customer_grade1)==0,"and 1=1","and customer_grade1 in ('"+customer_grade1+"')")}

select
code_value
from DW_DIM_SYSTEM_CODE
where code_type='CRMIndustry'
and code_layno=1

select
customer_industry2
from
((select
show_systemcode(show_up_systemcode(','||code_code||',')) as customer_industry1,
code_value as customer_industry2
from DW_DIM_SYSTEM_CODE
where code_type='CRMIndustry'
and code_layno=2)
union all
(select
'食品饮料' as customer_industry1,
'食品饮料' as customer_industry2
from dual)
union all
(select
'教学科研咨询（学校、研究院所、设计院、工程公司等）' as customer_industry1,
'教学科研咨询（学校、研究院所、设计院、工程公司等）' as customer_industry2
from dual)
union all
(select
'其他' as customer_industry1,
'其他' as customer_industry2
from dual))
${if(len(customer_industry1)==0,"where 1=1","where customer_industry1 in ('"+customer_industry1+"')")}
order by customer_industry1


select distinct
park_name
from
EDW_PARK
${if(len(customer_province)==0,"where 1=1","where park_province in ('"+customer_province+"')")}
order by park_name

select distinct
customer_bu
from edw_customer_all a
where 1=1
${if(OR(fr_username='admin',fr_username='admin'),"","and (regexp_instr(a.AU_DEPT,'"+au_dept+"')>0 or regexp_instr(a.AU_AREA_DC,'"+au_area_dc+"')>0 or regexp_instr(a.AU_INDUSTRY,'"+au_industry+"')>0 or regexp_instr(a.AU_CUSTOMER,'"+au_customer+"')>0 or regexp_instr(a.AU_PRODUCT_DEVICE,'"+au_product_device+"')>0)")}

(select 
    customer_id,
    customer_name,
    customer_root,
    (case when customer_upcustname is null then customer_park
    else customer_upcustname end) as customer_upcustname,
    customer_owner,
    customer_dept,
    customer_park,
    customer_bpbj,
    customer_devicecount,
    customer_size,
    customer_contractcount,
    customer_bndhzcs,
    customer_zjychz,
    customer_zjycfk,
    customer_zjycsw,
    customer_zjycgc,
    customer_whk,
    customer_ysk,
    customer_zzxsje,
    customer_dbsje,
    customer_zbhte,
    customer_province,
    customer_city,
    customer_area,
    customer_upcustid,
    customer_grade1,
    customer_grade2,
    customer_type1,
    customer_type2,
    customer_industry1,
    customer_industry2,
    customer_bpbjhte,
    customer_contracthte
from edw_customer_all a
where customer_park is not null
${if(OR(au_customer_alldata='999',fr_username='admin'),"","and (regexp_instr(a.au_dept,'"+au_customer_dept+"')>0 or regexp_instr(a.au_area_dc,'"+au_customer_area_dc+"')>0 or regexp_instr(a.au_customer,'"+au_customer_customer+"')>0 or regexp_instr(a.au_industry,'"+au_customer_industry+"')>0  or regexp_instr(a.au_product_device,'"+au_customer_product_device+"')>0)")})
union all
(select 
    park_id as customer_id,
    park_name as customer_name,
    null as customer_root,
    null as customer_upcustname,
    null as customer_owner,
    null as customer_dept,
    null as customer_park,
    null as customer_bpbj,
    null as customer_devicecount,
    null as customer_size,
    null as customer_contractcount,
    null as customer_bndhzcs,
    null as customer_zjychz,
    null as customer_zjycfk,
    null as customer_zjycsw,
    null as customer_zjycgc,
    null as customer_whk,
    null as customer_ysk,
    null as customer_zzxsje,
    null as customer_dbsje,
    null as customer_zbhte,
    park_province as customer_province,
    park_city as customer_city,
    park_area as customer_area,
    null as customer_upcustid,
    null as customer_grade1,
    null as customer_grade2,
    null as customer_type1,
    null as customer_type2,
    null as customer_industry1,
    null as customer_industry2,
    null as customer_bpbjhte,
    null as customer_contracthte
from edw_park
)

