select sub_category,substr(sale_date,6,7), sum(TAX_AMOUNT) as "sum(No_TAX_AMOUNT)" from DM_PURCHASE_RATE
where 1=1 
${if(len(dtp)=0,"","and dtp ='"+dtp+"'")}
and 1=1 ${if(len(ACODE)=0,"","and AREA_CODE IN ('"+ACODE+"')")}
and substr(sale_date,1,4)='${YEAR}'
AND ATTRIBUTE='销售直营'
group by sub_category,substr(sale_Date,6,7)

select sub_category,substr(sale_date,6,7), sum(TAX_AMOUNT) as "sum(No_TAX_AMOUNT)" from DM_PURCHASE_RATE
where 1=1 
${if(len(dtp)=0,"","and dtp ='"+dtp+"'")}
and 1=1 ${if(len(ACODE)=0,"","and AREA_CODE IN ('"+ACODE+"')")}
and substr(sale_date,1,4)='${YEAR}'-1
AND ATTRIBUTE='销售直营'
group by sub_category,substr(sale_Date,6,7)

select sub_category,substr(sale_date,6,7), sum(TAX_AMOUNT) as "sum(No_TAX_AMOUNT)" from DM_PURCHASE_RATE
where 
1=1 ${if(len(ACODE)=0,"","and AREA_CODE IN ('"+ACODE+"')")} AND
1=1 ${if(len(GATH)=0,"","and Gather IN ('"+GATH+"')")}
AND
1=1 
${if(len(dtp)=0,"","and dtp ='"+dtp+"'")}
and substr(sale_date,1,4)='${YEAR}'
AND ATTRIBUTE='销售直营'
group by sub_category,substr(sale_Date,6,7)

select sub_category,substr(sale_date,6,7), sum(TAX_AMOUNT) as "sum(No_TAX_AMOUNT)" from DM_PURCHASE_RATE
where 
1=1 ${if(len(ACODE)=0,"","and AREA_CODE IN ('"+ACODE+"')")} AND
1=1 ${if(len(GATH)=0,"","and Gather IN ('"+GATH+"')")}
AND
1=1 
${if(len(dtp)=0,"","and dtp ='"+dtp+"'")}
and substr(sale_date,1,4)='${YEAR}'-1
AND ATTRIBUTE='销售直营'
group by sub_category,substr(sale_Date,6,7)

Select distinct sub_category from DM_PURCHASE_RATE 
union
select 'NONE' from DUAL

select * from DIM_REGION
where 1=1 ${if(UNION='全国',"","and union_area_name='"+UNION+"'")}

select case when gather ='否' then '地采' else gather end as gather_look,gather from (select distinct gather from DM_PURCHASE_RATE)

select sub_category,substr(sale_date,6,7), sum(TAX_AMOUNT) as "sum(No_TAX_AMOUNT)" from DM_PURCHASE_RATE
where 
1=1 ${if(len(ACODE)=0,"","and AREA_CODE IN ('"+ACODE+"')")} AND
1=1 ${if(len(GATH)=0,"","and Gather IN ('"+GATH+"')")}
and RELATED_PARTY_TRNSACTION = '否'
AND
1=1 
${if(len(dtp)=0,"","and dtp ='"+dtp+"'")}
and substr(sale_date,1,4)='${YEAR}'
group by sub_category,substr(sale_Date,6,7)

select sub_category,substr(sale_date,6,7), sum(TAX_AMOUNT) as "sum(No_TAX_AMOUNT)" from DM_PURCHASE_RATE
where 1=1 
${if(len(dtp)=0,"","and dtp ='"+dtp+"'")}
and RELATED_PARTY_TRNSACTION = '否'
and 1=1 ${if(len(ACODE)=0,"","and AREA_CODE IN ('"+ACODE+"')")}
and substr(sale_date,1,4)='${YEAR}'
group by sub_category,substr(sale_Date,6,7)

select sub_category,substr(sale_date,6,7), sum(TAX_AMOUNT) as "sum(No_TAX_AMOUNT)" from DM_PURCHASE_RATE
where 1=1 
${if(len(dtp)=0,"","and dtp ='"+dtp+"'")}
and RELATED_PARTY_TRNSACTION = '否'
and 1=1 ${if(len(ACODE)=0,"","and AREA_CODE IN ('"+ACODE+"')")}
and substr(sale_date,1,4)='${YEAR}'-1
group by sub_category,substr(sale_Date,6,7)

select sub_category,substr(sale_date,6,7), sum(TAX_AMOUNT) as "sum(No_TAX_AMOUNT)" from DM_PURCHASE_RATE
where 
1=1 ${if(len(ACODE)=0,"","and AREA_CODE IN ('"+ACODE+"')")} AND
1=1 ${if(len(GATH)=0,"","and Gather IN ('"+GATH+"')")}
and RELATED_PARTY_TRNSACTION = '否'
AND
1=1 
${if(len(dtp)=0,"","and dtp ='"+dtp+"'")}
and substr(sale_date,1,4)='${YEAR}'-1
group by sub_category,substr(sale_Date,6,7)

select * from (select union_area_name from dim_region
union
select '全国' from dual)
order by replace(union_area_name,'全国'，100) 

select distinct YEAR_ID from DIM_DAY order by YEAR_ID   asc

