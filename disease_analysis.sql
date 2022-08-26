select 
a.area_code,
a.area_name,
c.UNION_AREA_NAME,
sum(TAX_AMOUNT) 总销售,
sum(TAX_AMOUNT-TAX_COST) 总毛利
from (
select distinct area_code,area_name,cus_code,cus_name,
TAX_AMOUNT,TAX_COST,TRAN_NUM,MONTHID,INSIDERID
from dm_vip_sale_month a
where monthid>='${date_from}' 
and monthid<='${date_to}'
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
${if(len(chronic)=0,""," and a.CHRONIC in ('"+chronic+"')")}
and ILL_TYPE='N'
) a ,dim_cus b,dim_region c ,(select * from USER_AUTHORITY) d
where 1=1
and (c.UNION_AREA_NAME=d.UNION_AREA_NAME or d.UNION_AREA_NAME='ALL') 
and ${"d.user_id='"+$fr_username+"'"}
and a.area_code=c.area_code and a.area_code=b.area_code and a.cus_code=b.cus_code
 
${if(len(UNION_AREA)=0,""," and c.union_area_name in ('"+UNION_AREA+"')")}
${if(len(attribute)=0,""," and b.attribute in ('"+attribute+"')")}

group by a.area_code,
a.area_name,c.UNION_AREA_NAME,c.sorted
order by c.sorted

select 
      dr.area_name
      ,dr.area_code
      ,sum(fs.TAX_AMOUNT) TAX_AMOUNT
      
  from fact_sale fs,
       dim_region dr,
       dim_cus dc,
       dim_goods dg,
       DIM_ILLNESS_CATALOGUE dic
 where fs.AREA_CODE=dr.area_code
   and fs.AREA_CODE=dc.area_code
   and fs.CUS_CODE=dc.cus_code
   --and dc.attribute='直营'
   and fs.GOODS_CODE=dg.goods_code
   and fs.GOODS_CODE=dic.goods_code
   and fs.VIP='是'
   and fs.SALE_DATE between add_months(to_date('${date_from}', 'yyyy-mm-dd'),-12) and add_months(to_date('${date_to}', 'yyyy-mm-dd'),-12)
   and ${if(len(AREA) = 0, "1=1", "  fs.AREA_CODE in ('"+AREA+"')")}
   and ${if(len(UNION_AREA) = 0, "1=1", "  dr.union_area_name in ('"+UNION_AREA+"')")}
   
   and ${if(len(attribute) = 0, "1=1", " dc.attribute in ('"+attribute+"')")}
   and ${if(len(chronic) = 0, "1=1", "  dic.ill_type in ('"+chronic+"')") }
 group by dr.area_name,dr.area_code

select a.area_code,
sum(TAX_AMOUNT) DIR_TAX_AMOUNT
from DM_MONTHLY_COMPANY a,dim_region c
where a.attribute='直营' 
and a.area_code=c.area_code
and sale_date between to_date('${date_from}','yyyy-MM') and add_months(to_date('${date_to}','yyyy-MM'),1)
and ${if(len(AREA) = 0, "1=1", "  a.AREA_CODE in ('"+AREA+"')") }
   and ${if(len(UAREA) = 0, "1=1", "  c.union_area_name in ('"+UAREA+"')")}
and dtp='否'
group by a.area_code

select 
      dr.area_name
      ,dr.area_code
      ,sum(fs.TAX_AMOUNT) TAX_AMOUNT
      
  from fact_sale fs,
       dim_region dr,
       dim_cus dc,
       dim_goods dg,
       DIM_ILLNESS_CATALOGUE dic
 where fs.AREA_CODE=dr.area_code
   and fs.AREA_CODE=dc.area_code
   and fs.CUS_CODE=dc.cus_code
   --and dc.attribute='直营'
   and fs.GOODS_CODE=dg.goods_code
   and fs.GOODS_CODE=dic.goods_code
   and fs.VIP='是'
   and fs.SALE_DATE between to_date('${date_from}', 'yyyy-mm-dd') and to_date('${date_to}', 'yyyy-mm-dd')
   and ${if(len(AREA) = 0, "1=1", "  fs.AREA_CODE in ('"+AREA+"')") }
   and ${if(len(UNION_AREA) = 0, "1=1", "  dr.union_area_name in ('"+UNION_AREA+"')")}
   and ${if(len(attribute) = 0, "1=1", "  dc.attribute in ('"+attribute+"')") }
   and ${if(len(chronic) = 0, "1=1", "  dic.ill_type in ('"+chronic+"')") }
 group by dr.area_name,dr.area_code


select distinct dic.ill_type from DIM_ILLNESS_CATALOGUE dic

select distinct area_code,area_name,union_area_name from dim_region  where 1=1
--${if(len(AREA) = 0, "1=1", "  zro.area_code in ('"+AREA+"')") }
 ${if(len(UNION_AREA)==0,""," and union_area_name in ('"+UNION_AREA+"')")}

select 
a.area_code,
a.area_name,
sum(TAX_AMOUNT) 总销售,
sum(TAX_AMOUNT-TAX_COST) 总毛利
from dm_vip_sale_month a ,dim_cus b,dim_region c 
where monthid>='${date_from}'
and monthid<='${date_to}'
and a.area_code=c.area_code and a.area_code=b.area_code and a.cus_code=b.cus_code

${if(len(chronic)=0,""," and a.CHRONIC in ('"+chronic+"')")}
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
${if(len(UNION_AREA)=0,""," and c.union_area_name in ('"+UNION_AREA+"')")}
${if(len(attribute)=0,""," and b.attribute in ('"+attribute+"')")}
and ILL_TYPE<>'N'

group by a.area_code,
a.area_name

select 
 area_code,
 area_name,
sum(总销售) 总销售,
sum(总毛利) 总毛利
from
(
select 
a.area_code,
a.area_name,
a.INSIDERID,
sum(TRAN_NUM)TRAN_NUM,
sum(TAX_AMOUNT) 总销售,
sum(TAX_AMOUNT-TAX_COST) 总毛利
from dm_vip_sale_month a ,dim_cus b,dim_region c 
where monthid>='${date_from}'
and monthid<='${date_to}'
and a.area_code=c.area_code and a.area_code=b.area_code and a.cus_code=b.cus_code
${if(len(chronic)=0,""," and a.CHRONIC in ('"+chronic+"')")}
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
${if(len(UNION_AREA)=0,""," and c.union_area_name in ('"+UNION_AREA+"')")}
${if(len(attribute)=0,""," and b.attribute in ('"+attribute+"')")}
and ILL_TYPE <>'N'

group by a.area_code,
a.area_name,a.INSIDERID
)where TRAN_NUM>2
group by  area_code,
 area_name


select 
 area_code,
 area_name,
sum(总销售) 总销售,
sum(总毛利) 总毛利
from
(
select 
a.area_code,
a.area_name,
a.INSIDERID,
sum(TRAN_NUM)TRAN_NUM,
sum(TAX_AMOUNT) 总销售,
sum(TAX_AMOUNT-TAX_COST) 总毛利
from (
select distinct area_code,area_name,cus_code,cus_name,
TAX_AMOUNT,TAX_COST,TRAN_NUM,MONTHID,INSIDERID
from dm_vip_sale_month a
where monthid>='${date_from}' 
and monthid<='${date_to}'
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
${if(len(chronic)=0,""," and a.CHRONIC in ('"+chronic+"')")}
and ILL_TYPE='N'
) a ,dim_cus b,dim_region c 
where 1=1
and a.area_code=c.area_code and a.area_code=b.area_code and a.cus_code=b.cus_code
${if(len(UNION_AREA)=0,""," and c.union_area_name in ('"+UNION_AREA+"')")}
${if(len(attribute)=0,""," and b.attribute in ('"+attribute+"')")}
 
group by a.area_code,
a.area_name,a.INSIDERID
)where TRAN_NUM>2
group by  area_code,
 area_name

select 
a.area_code,
a.area_name,
c.UNION_AREA_NAME,
sum(TAX_AMOUNT) 总销售,
sum(TAX_AMOUNT-TAX_COST) 总毛利
from (
select distinct area_code,area_name,cus_code,cus_name,
TAX_AMOUNT,TAX_COST,TRAN_NUM,MONTHID,INSIDERID
from dm_vip_sale_month a
where monthid>=to_char(add_months(to_date('${date_from}','yyyy-MM'),-12),'yyyy-MM')
and monthid<=to_char(add_months(to_date('${date_to}','yyyy-MM'),-12),'yyyy-MM')
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
${if(len(chronic)=0,""," and a.CHRONIC in ('"+chronic+"')")}
and ILL_TYPE='N'
) a ,dim_cus b,dim_region c  
where 1=1
and a.area_code=c.area_code and a.area_code=b.area_code and a.cus_code=b.cus_code
 
${if(len(UNION_AREA)=0,""," and c.union_area_name in ('"+UNION_AREA+"')")}
${if(len(attribute)=0,""," and b.attribute in ('"+attribute+"')")}
 group by a.area_code,
a.area_name,c.UNION_AREA_NAME,c.sorted
order by c.sorted


select 
 area_code,
 area_name,
sum(总销售) 总销售,
sum(总毛利) 总毛利
from
(
select 
a.area_code,
a.area_name,
a.INSIDERID,
sum(TRAN_NUM)TRAN_NUM,
sum(TAX_AMOUNT) 总销售,
sum(TAX_AMOUNT-TAX_COST) 总毛利
from (
select distinct area_code,area_name,cus_code,cus_name,
TAX_AMOUNT,TAX_COST,TRAN_NUM,MONTHID,INSIDERID
from dm_vip_sale_month a
where monthid>=to_char(add_months(to_date('${date_from}','yyyy-MM'),-12),'yyyy-MM')
and monthid<=to_char(add_months(to_date('${date_to}','yyyy-MM'),-12),'yyyy-MM')
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
${if(len(chronic)=0,""," and a.CHRONIC in ('"+chronic+"')")}
and ILL_TYPE='N'
) a ,dim_cus b,dim_region c 
where 1=1
and a.area_code=c.area_code and a.area_code=b.area_code and a.cus_code=b.cus_code
${if(len(UNION_AREA)=0,""," and c.union_area_name in ('"+UNION_AREA+"')")}
${if(len(attribute)=0,""," and b.attribute in ('"+attribute+"')")}
 
group by a.area_code,
a.area_name,a.INSIDERID
)where TRAN_NUM>2
group by  area_code,
 area_name

select 
a.area_code,
a.area_name,
sum(TAX_AMOUNT) 总销售,
sum(TAX_AMOUNT-TAX_COST) 总毛利
from dm_vip_sale_month a ,dim_cus b,dim_region c 
where monthid>=to_char(add_months(to_date('${date_from}','yyyy-MM'),-12),'yyyy-MM')
and monthid<=to_char(add_months(to_date('${date_to}','yyyy-MM'),-12),'yyyy-MM')
and a.area_code=c.area_code and a.area_code=b.area_code and a.cus_code=b.cus_code

${if(len(chronic)=0,""," and a.CHRONIC in ('"+chronic+"')")}
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
${if(len(UNION_AREA)=0,""," and c.union_area_name in ('"+UNION_AREA+"')")}
${if(len(attribute)=0,""," and b.attribute in ('"+attribute+"')")}
and ILL_TYPE <>'N'

group by a.area_code,
a.area_name

select 
 area_code,
 area_name,
sum(总销售) 总销售,
sum(总毛利) 总毛利
from
(
select 
a.area_code,
a.area_name,
a.INSIDERID,
sum(TRAN_NUM)TRAN_NUM,
sum(TAX_AMOUNT) 总销售,
sum(TAX_AMOUNT-TAX_COST) 总毛利
from dm_vip_sale_month a ,dim_cus b,dim_region c 
where monthid>=to_char(add_months(to_date('${date_from}','yyyy-MM'),-12),'yyyy-MM')
and monthid<=to_char(add_months(to_date('${date_to}','yyyy-MM'),-12),'yyyy-MM')
and a.area_code=c.area_code and a.area_code=b.area_code and a.cus_code=b.cus_code
${if(len(chronic)=0,""," and a.CHRONIC in ('"+chronic+"')")}
${if(len(AREA)=0,""," and a.area_code in ('"+AREA+"')")}
${if(len(UNION_AREA)=0,""," and c.union_area_name in ('"+UNION_AREA+"')")}
${if(len(attribute)=0,""," and b.attribute in ('"+attribute+"')")}
and ILL_TYPE <>'N'

group by a.area_code,
a.area_name,a.INSIDERID
)where TRAN_NUM>2
group by  area_code,
 area_name

select a.area_code,
sum(TAX_AMOUNT) DIR_TAX_AMOUNT
from DM_MONTHLY_COMPANY a,dim_region c
where a.attribute='直营' 
and a.area_code=c.area_code
and sale_date between add_months(to_date('${date_from}','yyyy-MM'),-12) 
and add_months(add_months(to_date('${date_to}','yyyy-MM'),1),-12)
and ${if(len(AREA) = 0, "1=1", "  a.AREA_CODE in ('"+AREA+"')") }
   and ${if(len(UAREA) = 0, "1=1", "  c.union_area_name in ('"+UAREA+"')")}
and dtp='否'
group by a.area_code

select distinct  union_area_name from dim_region

select sum (TAX_AMOUNT) 总销售,sum(a.TAX_AMOUNT-a.TAX_COST) 总毛利,d.area_name,d.area_code 
from 
fact_sale_vip a ,dim_cus b ,dim_region d 
where a.cus_code=b.cus_code and a.area_code=d.area_code
and a.sale_date between date'${date_from}' and date'${date_to}' 
${if(len(AREA)=0,""," and b.area_code in ('"+AREA+"')")}
${if(len(UAREA)=0,""," and d.union_area_name in ('"+UAREA+"')")}
${if(len(attribute)=0,""," and b.attribute in ('"+attribute+"')")}
and exists
(select 'Y' from dm_vip_chronic_detail v where a.insiderid = v.insiderid 
${if(len(chronic)=0,""," and v.chronic in ('"+chronic+"')")}
)
group by d.area_name,d.area_code having count(distinct a.sale_date) >0

