select distinct sub_category from dim_goods where sub_category is not null
and sub_category!='/'
and 1=1 ${if(len(cate)=0,"","and  sub_CATEGORY in ('"+cate+"')")}

select SUBSTR(sale_date,6,7) as sale_date,CATEGORY,sum(TAX_AMOUNT) as "sum(NO_TAX_AMOUNT)" from DM_CATEGORY_YEAR_SALE
where 
accountname = '直营常规' 
and substr(sale_date,1,4)='${year}'
and 1=1 ${if(len(cate)=0,"","and  CATEGORY in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and  attribute in ('"+attr+"')")}
and 1=1 ${if(len(dtp)=0,"","and  DTP ='"+dtp+"'")}
and 1=1 ${if(len(region)=0,"","and  area_code in ('"+region+"')")}
group by  SUBSTR(sale_date,6,7),CATEGORY

select distinct attribute from DM_CATEGORY_YEAR_SALE

select SUBSTR(sale_date,6,7) as sale_date,CATEGORY,sum(TAX_AMOUNT) as "sum(NO_TAX_AMOUNT)" from DM_CATEGORY_YEAR_SALE
where 
accountname = '加盟' 
and substr(sale_date,1,4)='${year}'
and 1=1 ${if(len(cate)=0,"","and  CATEGORY in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and  attribute in ('"+attr+"')")}
and 1=1 ${if(len(dtp)=0,"","and  DTP ='"+dtp+"'")}
and 1=1 ${if(len(region)=0,"","and  area_code in ('"+region+"')")}
group by  SUBSTR(sale_date,6,7),CATEGORY

select SUBSTR(sale_date,6,7) as sale_date,CATEGORY,sum(TAX_AMOUNT) as "sum(NO_TAX_AMOUNT)" from DM_CATEGORY_YEAR_SALE
where 
accountname = '批发' 
and substr(sale_date,1,4)='${year}'
and 1=1 ${if(len(cate)=0,"","and  CATEGORY in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and  attribute in ('"+attr+"')")}
and 1=1 ${if(len(dtp)=0,"","and  DTP ='"+dtp+"'")}
and 1=1 ${if(len(region)=0,"","and  area_code in ('"+region+"')")}
group by  SUBSTR(sale_date,6,7),CATEGORY

select SUBSTR(sale_date,6,7) as sale_date,CATEGORY,sum(TAX_AMOUNT) as "sum(NO_TAX_AMOUNT)" from DM_CATEGORY_YEAR_SALE
where 
accountname in ( '直营常规','加盟'）  
and substr(sale_date,1,4)='${year}'
and 1=1 ${if(len(cate)=0,"","and  CATEGORY in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and  attribute in ('"+attr+"')")}
and 1=1 ${if(len(dtp)=0,"","and  DTP ='"+dtp+"'")}
and 1=1 ${if(len(region)=0,"","and  area_code in ('"+region+"')")}
group by  SUBSTR(sale_date,6,7),CATEGORY



select SUBSTR(sale_date,6,7) as sale_date,CATEGORY,sum(TAX_AMOUNT) as "sum(NO_TAX_AMOUNT)" from DM_CATEGORY_YEAR_SALE
where 
accountname in ( '直营常规','批发','加盟'）  
and substr(sale_date,1,4)='${year}'
and 1=1 ${if(len(cate)=0,"","and  CATEGORY in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and  attribute in ('"+attr+"')")}
and 1=1 ${if(len(dtp)=0,"","and  DTP ='"+dtp+"'")}
and 1=1 ${if(len(region)=0,"","and  area_code in ('"+region+"')")}
group by  SUBSTR(sale_date,6,7),CATEGORY



select * from DIM_REGION
where 1=1 ${if(len(UNION)=0,"","and  union_area_name in ('"+UNION+"')")}


select * from (select union_area_name from dim_region
union
select '全国' from dual)
order by replace(union_area_name,'全国'，100) 

select distinct YEAR_ID from DIM_DAY order by YEAR_ID   asc

select distinct sub_category from dim_goods where sub_category is not null


