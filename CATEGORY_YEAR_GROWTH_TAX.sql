select distinct sub_category from dim_goods where sub_category is not null
and sub_category!='/'
and 1=1 ${if(len(cate)=0,"","and  sub_CATEGORY in ('"+cate+"')")}


select distinct attribute from DM_CATEGORY_YEAR_SALE

select * from DIM_REGION
where 1=1  ${if(len(UNION)=0,"","and union_area_name in ('"+UNION+"')")}


select substr(SALE_DATE,6,7) as sale_date,CATEGORY,sum(TAX_AMOUNT) as "sum(NO_TAX_AMOUNT)" from 

DM_CATEGORY_YEAR_SALE

where 1=1 ${if(dtp=0," and DTP='否' ","")} and substr(sale_date,1,4) = '${year}'
and 1=1 ${if(len(region)=0,"","and area_code in ('"+region+"')")}
and 1=1 ${if(len(cate)=0,"","and category in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and attribute in ('"+attr+"')")}
and accountname='直营常规'
group by sale_date,category

select substr(SALE_DATE,6,7) as sale_date,CATEGORY,sum(TAX_AMOUNT) as "sum(NO_TAX_AMOUNT)" from 

DM_CATEGORY_YEAR_SALE

where 1=1 ${if(dtp=0," and DTP='否' ","")} and substr(sale_date,1,4) = to_char(add_months(to_date('${year}','yyyy'),-12),'yyyy') and 1=1 ${if(len(region)=0,"","and area_code in ('"+region+"')")}
and 1=1 ${if(len(cate)=0,"","and category in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and attribute in ('"+attr+"')")}
and accountname='直营常规'
group by sale_date,category

select substr(SALE_DATE,6,7) as sale_date,CATEGORY,sum(TAX_AMOUNT) as "sum(NO_TAX_AMOUNT)" from 

DM_CATEGORY_YEAR_SALE

where 1=1 ${if(dtp=0," and DTP='否' ","")} and substr(sale_date,1,4) = '${year}'
and 1=1 ${if(len(region)=0,"","and area_code in ('"+region+"')")}
and 1=1 ${if(len(cate)=0,"","and category in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and attribute in ('"+attr+"')")}
and accountname='直营常规'
and attribute!='地采'
group by sale_date,category

select substr(SALE_DATE,6,7) as sale_date,CATEGORY,sum(TAX_AMOUNT) as "sum(NO_TAX_AMOUNT)" from 

DM_CATEGORY_YEAR_SALE

where 1=1 ${if(dtp=0," and DTP='否' ","")} and substr(sale_date,1,4) = to_char(add_months(to_date('${year}','yyyy'),-12),'yyyy')
and 1=1 ${if(len(region)=0,"","and area_code in ('"+region+"')")}
and 1=1 ${if(len(cate)=0,"","and category in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and attribute in ('"+attr+"')")}
and accountname='直营常规'
and attribute!='地采'
group by sale_date,category

select substr(SALE_DATE,6,7) as sale_date,CATEGORY,sum(TAX_AMOUNT) as "sum(NO_TAX_AMOUNT)" from 

DM_CATEGORY_YEAR_SALE

where 1=1 ${if(dtp=0," and DTP='否' ","")} and substr(sale_date,1,4) = '${year}'
and 1=1 ${if(len(region)=0,"","and area_code in ('"+region+"')")}
and 1=1 ${if(len(cate)=0,"","and category in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and attribute in ('"+attr+"')")}
group by sale_date,category

select substr(SALE_DATE,6,7) as sale_date,CATEGORY,sum(TAX_AMOUNT) as "sum(NO_TAX_AMOUNT)" from 

DM_CATEGORY_YEAR_SALE

where 1=1 ${if(dtp=0," and DTP='否' ","")} and substr(sale_date,1,4) = to_char(add_months(to_date('${year}','yyyy'),-12),'yyyy') and 1=1 ${if(len(region)=0,"","and area_code in ('"+region+"')")}
and 1=1 ${if(len(cate)=0,"","and category in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and attribute in ('"+attr+"')")}
group by sale_date,category

select substr(SALE_DATE,6,7) as sale_date,CATEGORY,sum(TAX_AMOUNT) as "sum(NO_TAX_AMOUNT)" from 

DM_CATEGORY_YEAR_SALE

where 1=1 ${if(dtp=0," and DTP='否' ","")} and substr(sale_date,1,4) = '${year}'
and 1=1 ${if(len(region)=0,"","and area_code in ('"+region+"')")}
and 1=1 ${if(len(cate)=0,"","and category in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and attribute in ('"+attr+"')")}
and attribute!='地采'
group by sale_date,category

select substr(SALE_DATE,6,7) as sale_date,CATEGORY,sum(TAX_AMOUNT) as "sum(NO_TAX_AMOUNT)" from 

DM_CATEGORY_YEAR_SALE

where 1=1 ${if(dtp=0," and DTP='否' ","")} and substr(sale_date,1,4) = to_char(add_months(to_date('${year}','yyyy'),-12),'yyyy')
and 1=1 ${if(len(region)=0,"","and area_code in ('"+region+"')")}
and 1=1 ${if(len(cate)=0,"","and category in ('"+cate+"')")}
and 1=1 ${if(len(attr)=0,"","and attribute in ('"+attr+"')")}
and attribute!='地采'
group by sale_date,category

select * from (select union_area_name from dim_region
where 1=1 ${if(len(region)=0,"","and area_code in ('"+region+"')")}
union
select '全国' from dual)
order by replace(union_area_name,'全国'，100) 


select distinct YEAR_ID from DIM_DAY order by YEAR_ID   asc

select distinct sub_category from dim_goods where sub_category is not null
and sub_category!='/'

