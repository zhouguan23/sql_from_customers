select *from 
(
select
a.area_code,
c.area_name,
c.UNION_AREA_NAME,
0 flag,
sum(nvl(NO_TAX_AMOUNT,0)) as NO_TAX_AMOUNT,
sum(nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0)) as SALE_ML,
--新店
sum(case when to_char(open_date,'YYYY')=substr('${DATE1}', 1, 4) and open_date<date'${DATE1}'
then nvl(NO_TAX_AMOUNT,0) end)  as new_NO_TAX_AMOUNT,
sum(case when to_char(open_date,'YYYY')=substr('${DATE1}', 1, 4) and open_date<date'${DATE1}'
then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0)  end)  as new_sale_ml,
count(distinct case when to_char(open_date,'YYYY')=substr('${DATE1}', 1, 4) and open_date<date'${DATE1}'
then a.CUS_CODE end) new_cus_cnt,
--次新店
sum(case when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)=-1
then nvl(NO_TAX_AMOUNT,0) end)  as b_new_NO_TAX_AMOUNT,
sum(case when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)=-1
then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0)  end)  as b_new_sale_ml,
count(distinct case when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)=-1
then a.CUS_CODE end) b_new_cus_cnt,
--老店
sum(case when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)<-1
then nvl(NO_TAX_AMOUNT,0) end)  as old_NO_TAX_AMOUNT,
sum(case when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)<-1
then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0)  end)  as old_sale_ml,
count(distinct case when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)<-1
then a.CUS_CODE end) old_cus_cnt,
--收购门店
sum(case when d.AGE_STORE='直营收购' 
then nvl(NO_TAX_AMOUNT,0) end)  as SG_NO_TAX_AMOUNT,
sum(case when d.AGE_STORE='直营收购' 
then nvl(NO_TAX_AMOUNT,0)-nvl(NO_TAX_COST,0)  end)  as SG_sale_ml,
count(distinct case when d.AGE_STORE='直营收购' 
then a.CUS_CODE end) SG_cus_cnt

from dim_cus b,dim_region c ,DM_SALE_TMP a 
left join AGE_STORE d 
on a.area_code=d.area_code and a.cus_code=d.cus_code and to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.DATE1   
where SALE_DATE>=date'${DATE1}' and SALE_DATE<=date'${DATE2}'
${if(len(dtp)=0,"","and a.DTP ='"+dtp+"'")}
${if(len(o2o)=0,"","and a.oto ='"+o2o+"'")}
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}
${if(len(UNIONAREA)=0,""," and c.UNION_AREA_NAME in ('"+UNIONAREA+"')")}
and a.area_code=b.area_code and a.cus_code=b.cus_code
and a.area_code=c.area_code
and b.attribute='直营'
group by 
a.area_code,
c.area_name,
c.UNION_AREA_NAME


union all

select
a.area_code,
c.area_name,
c.UNION_AREA_NAME,
1 flag,
sum(nvl(TAX_AMOUNT,0)) as TAX_AMOUNT,
sum(nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0)) as SALE_ML,
--新店
sum(case when to_char(open_date,'YYYY')=substr('${DATE1}', 1, 4) and open_date<date'${DATE1}'
then nvl(TAX_AMOUNT,0) end)  as new_TAX_AMOUNT,
sum(case when to_char(open_date,'YYYY')=substr('${DATE1}', 1, 4) and open_date<date'${DATE1}'
then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0)  end)  as new_sale_ml,
count(distinct case when to_char(open_date,'YYYY')=substr('${DATE1}', 1, 4) and open_date<date'${DATE1}'
then a.CUS_CODE end) new_cus_cnt,
--次新店
sum(case when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)=-1
then nvl(TAX_AMOUNT,0) end)  as b_new_TAX_AMOUNT,
sum(case when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)=-1
then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0)  end)  as b_new_sale_ml,
count(distinct case when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)=-1
then a.CUS_CODE end) b_new_cus_cnt,
--老店
sum(case when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)<-1
then nvl(TAX_AMOUNT,0) end)  as old_TAX_AMOUNT,
sum(case when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)<-1
then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0)  end)  as old_sale_ml,
count(distinct case when to_char(open_date,'YYYY')-substr('${DATE1}', 1, 4)<-1
then a.CUS_CODE end) old_cus_cnt,
--收购门店
sum(case when d.AGE_STORE='直营收购' 
then nvl(TAX_AMOUNT,0) end)  as SG_TAX_AMOUNT,
sum(case when d.AGE_STORE='直营收购' 
then nvl(TAX_AMOUNT,0)-nvl(TAX_COST,0)  end)  as SG_sale_ml,
count(distinct case when d.AGE_STORE='直营收购' 
then a.CUS_CODE end) SG_cus_cnt

from dim_cus b,dim_region c ,DM_SALE_TMP a 
left join AGE_STORE d 
on a.area_code=d.area_code and a.cus_code=d.cus_code and to_char(ADD_MONTHS(a.SALE_DATE,-1),'YYYY-MM')=d.DATE1 
where SALE_DATE>=date'${DATE1}' and SALE_DATE<=date'${DATE2}'
${if(len(dtp)=0,"","and a.DTP ='"+dtp+"'")}
${if(len(o2o)=0,"","and a.oto ='"+o2o+"'")}
${if(len(AREA)=0,""," and a.AREA_CODE in ('"+AREA+"')")}
${if(len(UNIONAREA)=0,""," and c.UNION_AREA_NAME in ('"+UNIONAREA+"')")}
and a.area_code=b.area_code and a.cus_code=b.cus_code
and a.area_code=c.area_code
and b.attribute='直营'
group by 
a.area_code,
c.area_name,
c.UNION_AREA_NAME
)where 1=1
${if(len(flag)=0,"","and flag ='"+flag+"'")}
order by area_code






select distinct
UNION_AREA_NAME,
area_code,
area_name
from dim_region
where 1=1
${if(len(UNIONAREA)=0,""," and UNION_AREA_NAME in ('"+UNIONAREA+"')")}
order by area_code

select distinct
UNION_AREA_NAME
from dim_region
order by  UNION_AREA_NAME

select distinct union_area_name,area_name，area_code,trans_party_relation from dim_region
where 1=1 ${if(len(area)=0, "", " and area_code in ('" + area + "')")}
and 1=1 ${if(len(UNIONAREA)=0,"","and UNION_AREA_NAME in('"+UNIONAREA+"')")}
order by area_code

