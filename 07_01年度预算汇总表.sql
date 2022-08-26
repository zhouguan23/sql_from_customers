select proj.projguid,proj.projname 
 from DIM_MASTER_PROJECT proj
inner join DIM_MASTER_BUILDING building on building.projguid = proj.projguid
inner join dim_company company on proj.buguid = company.buguid
where 1=1  
${if(len(p_companyid)=0,"and 1=2"," and company.buguid2 in ("+"'"+treelayer(p_companyid,true,"\',\'")+"'"+")")}
  and proj.projguid in
       (select projectguid
          from (select 'xincheng\' || aduser as aduser, projectguid
                  from USER_PRIVILEGE
                union all
                select aduser, projectguid
                  from my_user_project
               )
         where 1 = 1 ${if(fr_username = 'admin',
                    "",
                    " and aduser = '" + fr_username + "'") })
group by proj.projguid,proj.projname,proj.projcode,company.bucode
order by company.bucode,proj.projcode

select 
	  dc.parentbuguid,
	  dc.parentname,
	  dc.buguid2  公司编号,
       dc.buname2  公司名称,
       dc.buname2 公司简称，
       dp.projguid 项目编号,
       dp.projname 项目全称,
       dp.parentprojguid 父级项目代码,
       dp.parentprojname 项目名称,
       dp.projshortname 分期名称,
       rp.productguid 产品编号,
       rp.productname 产品名称,
       prod.productname 产品类型名称,
       rp.equity 权益比例,
       rp.producttype  业态,
       case rp.producttype when 1 then '住宅' when 2 then '商业' when 3 then '车位' when 4 then '公寓' end 业态名称,
       rp.deliverdate 交付日期,
       rpn.producttypeid  产品类型编号,
       rp.vatlevytype 增值税计征方式,
       ap.operatetype 操盘类型,
       dgcbd.SALENUM 可售套数,
	     dgcbd.gcbldguid 楼栋编号,
       dgcbd.gcbldname 楼栋名称,
       dgcbd.SaleArea 可售面积,
       dgcbd.KPDATE 开盘日期，
       dgcbd.YEARAVGPRICE 年度销售均价
  from table(get_company('')) dc
 inner join Dim_master_Project dp
    on dp.buguid = dc.buguid
 left join dim_project_append ap
    on dp.projguid = ap.projguid
    and ap.operatetype = '非操盘'
  left join dim_project_product rp
    on rp.projguid = dp.projguid
  left join DIM_PRODUCT_PRODUCTTYPE rpn
    on rpn.productguid = rp.productguid 
 left join dim_gc_building dgcbd
    on dgcbd.producttypeguid = rpn.producttypeid
   and  dgcbd.projguid = dp.projguid
  left join dim_project_append ap
    on ap.projguid = dp.projguid
 left join dim_product prod
   on rpn.producttypeid = prod.productguid
 where  dgcbd.productguid IS NOT NULL 
and ap.projguid is null
 ${if(len(p_projguid) == 0,
            "",
            " and dp.projguid in ('" + p_projguid + "')")
 }
 order by dc.parentbuguid,dc.buguid2,dp.projcode,rp.producttype,rp.productguid,dgcbd.gcbldname

SELECT 
b.BldGUID 楼栋编号,
t.PRODUCTTYPECODE 产品代码,
t.PRODUCTNAME 产品名称,
--sum( b.FactSaleNum) 实际套数,
--sum(b.FactSaleArea) 实际面积,
--sum(b.FactSaleAmount) 实际金额,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleNum ELSE  b.planSaleNum END ) 实际套数,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleArea ELSE  b.planSaleArea END ) 实际面积,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleAmount ELSE  b.planSaleAmount END ) 实际金额
FROM FACT_BUDGET_ACTUAL_SALES b,DIM_MASTER_PRODUCT p,jd_GCBuilding bld,DIM_PRODUCT t
WHERE substr(b.PlanMonth,1,4)<'${ysyear}'
AND b.BldGUID=bld.BldGUID
AND bld.ProductGUID=p.ProductGUID
AND p.PRODUCTTYPECODE=t.PRODUCTTYPECODE
${if(len(p_projguid) == 0, " ", "  and b.PROJGUID in ('" + p_projguid + "')")} 
GROUP BY b.BldGUID,t.PRODUCTNAME,t.PRODUCTTYPECODE


SELECT 
b.BldGUID 楼栋编号,
t.PRODUCTTYPECODE 产品代码,
t.PRODUCTNAME 产品名称,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleNum ELSE  b.planSaleNum END ) 预算套数,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleArea ELSE  b.planSaleArea END ) 预算面积,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleAmount ELSE  b.planSaleAmount END ) 预算金额,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleAmountnotax ELSE  b.planSaleAmountnotax END ) 预计签约不含税金额
FROM FACT_BUDGET_ACTUAL_SALES b,DIM_MASTER_PRODUCT p,jd_GCBuilding bld,DIM_PRODUCT t
WHERE substr(b.PlanMonth,1,4)='${ysyear}'
AND b.BldGUID=bld.BldGUID
AND bld.ProductGUID=p.PRODUCTGUID
 ${if(len(p_projguid) == 0, " ", "  and b.PROJGUID in ('" + p_projguid + "')")} 
AND p.PRODUCTTYPECODE=t.PRODUCTTYPECODE
GROUP BY b.BldGUID,t.PRODUCTNAME,t.PRODUCTTYPECODE

with rate as (select rate.*, rank() over(partition by rate.productguid
 order by rate.year desc) rn
  from FACT_PRODUCT_RATE rate
 where rate.year <= '${ysyear}')
select pd.projguid      项目编号,
       p2.producttypeid 产品类型编号,
       pd.equity        权益比例,
       pd.VATLEVYTYPE   增值税计征方式,
       p1.year          年度,
       cbdfbhlxjfwf,
       cbdfzbhlx,
       cbdffwf,
       yysjjfj,
       xsfl,
       glfl,
       cwfl,
       tzsl,
       fjs,
       fjssfl,
       gqyj
  from dim_project_product pd
  left join rate p1
    on pd.productguid = p1.productguid
    and pd.projguid=p1.projguid
   and p1.rn = 1,
 dim_product_producttype p2
 where pd.productguid = p2.productguid
 ${if(len(p_projguid) == 0,
            " ",
            "  and pd.PROJGUID in ('" + p_projguid + "')") }

select t.operatetype,t.projguid from DIM_PROJECT_APPEND t
where 1=1   ${if(len(p_projguid) == 0, " ", "  and t.PROJGUID in ('" + p_projguid + "')")} 

 select A.*,
 TOTALSALEAMOUNT*10000 AS TOTAL_SALEAMOUNT ,
 PLANSALEAMOUNT*10000 AS PLAN_SALEAMOUNT,
 B.BUNAME,C.PARENTPRODUCTNAME,
 b.parentname,
 b.parentbuguid
 from FACT_PROJECT_PLAN_YEAR A
 INNER JOIN table(get_company('')) B
 ON A.BUGUID=B.BUGUID
 AND A.YEARNO=${ysyear}
 INNER JOIN DIM_PRODUCT C
 ON A.PRODUCTGUID=C.PRODUCTGUID
 where 1=1  
${if(len(p_companyid)=0,"and 1=2"," and a.buguid in ("+"'"+treelayer(p_companyid,true,"\',\'")+"'"+")")}

order by b.parentbuguid,b.buguid2

select c.buguid2          公司ID,
       c.buname2          公司名称,
       c.parentname      区域,
       c.parentbuguid    父公司ID,
       p.parentprojguid  项目ID,
       p.parentprojname  项目名称,
       a.projguid        分期ID,
       p.projshortname   分期名称,
       ap.operatetype	操盘类型,
       a.equity          权益比例,
       a.producttype     业态,
       case a.producttype when 1 then '住宅' when 2 then '商业' when 3 then '车位' when 4 then '公寓' end 业态名称,
       a.deliverdate     交付日期,
       a.vatlevytype     增值税计征方式,
       a.productguid     产品ID,
       a.productname     产品名称,
       d.producttypeid   产品类型ID,
       pro.productname 产品类型名称,
       b.cbdfbhlxjfwf    成本单方不含利息及服务费,
       b.cbdfzbhlx       成本单方资本化利息,
       b.cbdffwf         成本单方服务费,
       b.yysjjfj         营业税金及附加,
       b.xsfl            销售费率,
       b.glfl            管理费率,
       b.cwfl            财务费率,
       b.tzsl            土增税率清算口径,
       b.fjs             附加税,
       b.fjssfl          附加税税负率,
       b.gqyj            股权溢价
  from DIM_PROJECT_PRODUCT a
  left join （select rate.*, rank() over(partition by rate.productguid
 order by rate.year desc) rn
  from FACT_PRODUCT_RATE rate
 where rate.year <= '${ysyear}'）b on a.productguid = b.productguid
   and a.projguid=b.projguid
   and b.rn = 1
 inner join DIM_PRODUCT_PRODUCTTYPE d
    on a.productguid = d.productguid
 inner join dim_master_project p
    on a.projguid = p.projguid
 inner join table(get_company('')) c
    on p.buguid = c.buguid
 inner join Dim_Project_append ap
    on a.projguid=ap.projguid
    and ap.operatetype = '非操盘'
 inner join dim_product pro
    on pro.productguid = d.producttypeid
 where 1 = 1
${if(len(p_projguid) == 0,
           "",
           " and a.projguid in ('" + p_projguid + "')") }
 order by p.projcode,p.parentprojguid,p.projguid, a.productguid, a.producttype

select c.parentprojname,
       a.PROJGUID 项目ID,
       c.PROJNAME 项目名称,
       a.producttypeguid 产品类型ID,
       d.PRODUCTNAME 产品名称,
       sum(a.salenum) 预计签约套量,
       sum(a.SALEAREA) 预计签约面积,
       sum(nvl(a.SALEAMOUNT,0))*10000 预计签约金额,
       sum(nvl(a.salenottaxamount,0))*10000 预计签约不含税金额
from (select projguid,producttypeguid,salenum,salearea,saleamount,salenottaxamount
      from fact_factsales_fill_month
      where  (yearno<substr('${smonth}',1,4)
          or (yearno=substr('${smonth}',1,4) and monthno<substr('${smonth}',1,4)+100-100)) 
       ${if(len(p_projguid) == 0,
            "and 1=1",
            " and PROJGUID in ('" + p_projguid + "')") }
      union all
      select projguid,producttypeguid,salenum,salearea,saleamount,salenottaxamount
      from fact_budgetsales_month
      where (yearno>substr('${smonth}',1,4)
          or (yearno=substr('${smonth}',1,4) and monthno>=substr('${smonth}',1,4)+100-100))
      ${if(len(p_projguid) == 0,
            "and 1=1",
            " and PROJGUID in ('" + p_projguid + "')") })a
 inner join dim_project c on a.PROJGUID = c.PROJGUID
  inner join dim_product d on a.producttypeguid = d.PRODUCTGUID
  inner join Dim_Project_append ap
  on c.projguid=ap.projguid
  and ap.operatetype='非操盘'
 group by c.parentprojname,
          a.PROJGUID,
          c.PROJNAME,
          a.producttypeguid,
          d.PRODUCTNAME

select b.gcbldguid 楼栋编号,
      b.producttypecode 产品代码,
      b.productname 产品名称,
      sum(t.salenum) 预算套数,
      sum(t.salearea) 预算面积,
      sum(t.saleamount)*10000 预算金额
from (select projguid,productguid,yearno,monthno,salenum,salearea,saleamount
      from fact_factsales_fill_month
      where projguid in ('${p_projguid}')
      and yearno=${ysyear}
      and (yearno<${yearno}
          or (yearno=${yearno} and monthno<${monthno}))
      union all
      select projguid,productguid,yearno,monthno,salenum,salearea,saleamount
      from fact_budgetsales_month
      where projguid in ('${p_projguid}')
      and yearno=${ysyear}
      and (yearno>${yearno}
          or (yearno=${yearno} and monthno>=${monthno})))t
inner join dim_gc_building b
on t.productguid=b.productguid
and t.projguid=b.projguid
group by b.gcbldguid,b.producttypecode,b.productname

SELECT 
b.projguid 项目分析,
b.BldGUID 楼栋编号,
t.PRODUCTTYPECODE 产品代码,
t.PRODUCTNAME 产品名称,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleNum ELSE  b.planSaleNum END ) 预算套数,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleArea ELSE  b.planSaleArea END ) 预算面积,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleAmount ELSE  b.planSaleAmount END ) 预算金额
FROM FACT_BUDGET_ACTUAL_SALES b,DIM_MASTER_PRODUCT p,jd_GCBuilding bld,DIM_PRODUCT t
WHERE b.BldGUID=bld.BldGUID
AND bld.ProductGUID=p.PRODUCTGUID
 ${if(len(p_projguid) == 0, " ", "  and b.PROJGUID in ('" + p_projguid + "')")} 
AND p.PRODUCTTYPECODE=t.PRODUCTTYPECODE
GROUP BY b.projguid,b.BldGUID,t.PRODUCTNAME,t.PRODUCTTYPECODE

SELECT 
b.projguid 分期id,
b.BldGUID 楼栋编号,
t.PRODUCTTYPECODE 产品代码,
'${ysyear}'-1 year,
--sum( b.FactSaleNum) 实际套数,
--sum(b.FactSaleArea) 实际面积,
--sum(b.FactSaleAmount) 实际金额,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleNum ELSE  b.planSaleNum END ) 实际套数,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleArea ELSE  b.planSaleArea END ) 实际面积,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleAmount ELSE  b.planSaleAmount END ) 实际金额
FROM FACT_BUDGET_ACTUAL_SALES b,DIM_MASTER_PRODUCT p,jd_GCBuilding bld,DIM_PRODUCT t
WHERE substr(b.PlanMonth,1,4)<'${ysyear}'-1
AND b.BldGUID=bld.BldGUID
AND bld.ProductGUID=p.ProductGUID
AND p.PRODUCTTYPECODE=t.PRODUCTTYPECODE
${if(len(p_projguid) == 0, " ", "  and b.PROJGUID in ('" + p_projguid + "')")} 
GROUP BY b.projguid,b.BldGUID,t.PRODUCTNAME,t.PRODUCTTYPECODE


SELECT 
b.projguid 分期id,
b.BldGUID 楼栋编号,
t.PRODUCTTYPECODE 产品代码,
substr('${smonth}',1,4)+1 year,
--sum( b.FactSaleNum) 实际套数,
--sum(b.FactSaleArea) 实际面积,
--sum(b.FactSaleAmount) 实际金额,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleNum ELSE  b.planSaleNum END ) 实际套数,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleArea ELSE  b.planSaleArea END ) 实际面积,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleAmount ELSE  b.planSaleAmount END ) 实际金额
FROM FACT_BUDGET_ACTUAL_SALES b,DIM_MASTER_PRODUCT p,jd_GCBuilding bld,DIM_PRODUCT t
WHERE substr(b.PlanMonth,1,4)<'${ysyear}'+2
and substr(b.PlanMonth,1,4)>'${ysyear}'
AND b.BldGUID=bld.BldGUID
AND bld.ProductGUID=p.ProductGUID
AND p.PRODUCTTYPECODE=t.PRODUCTTYPECODE
${if(len(p_projguid) == 0, " ", "  and b.PROJGUID in ('" + p_projguid + "')")} 
GROUP BY b.projguid,b.BldGUID,t.PRODUCTNAME,t.PRODUCTTYPECODE


SELECT 
b.projguid 项目分析,
b.BldGUID 楼栋编号,
t.PRODUCTTYPECODE 产品代码,
t.PRODUCTNAME 产品名称,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleNum ELSE  0 END ) 预算套数,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleArea ELSE  0 END ) 预算面积,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleAmount ELSE  0 END ) 预算金额
FROM FACT_BUDGET_ACTUAL_SALES b,DIM_MASTER_PRODUCT p,jd_GCBuilding bld,DIM_PRODUCT t
WHERE b.BldGUID=bld.BldGUID
and b.PlanMonth<'${smonth}'
and substr(b.PlanMonth,1,4)='${ysyear}'-1
AND bld.ProductGUID=p.PRODUCTGUID
 ${if(len(p_projguid) == 0, " ", "  and b.PROJGUID in ('" + p_projguid + "')")} 
AND p.PRODUCTTYPECODE=t.PRODUCTTYPECODE
GROUP BY b.projguid,b.BldGUID,t.PRODUCTNAME,t.PRODUCTTYPECODE

select * from fr_plan_saletime 
where 1=1
${if(len(p_projguid) == 0, " ", "  and PROJGUID in ('" + p_projguid + "')")} 

select * from (select c.parentprojname,
       a.PROJGUID 项目ID,
       c.PROJNAME 项目名称,
       a.PRODUCTGUID 产品类型ID,
       d.PRODUCTNAME 产品名称,
       a.bldguid,
       a.PLANMONTH,
       sum(case when a.PLANMONTH>=to_char(sysdate,'yyyy-mm') then a.PLANSALENUM else a.FACTSALENUM end) 预计签约套量,
       sum(case when a.PLANMONTH>=to_char(sysdate,'yyyy-mm') then a.PLANSALEAREA else a.FACTSALEAREA end) 预计签约面积,
       sum(case when a.PLANMONTH>=to_char(sysdate,'yyyy-mm') then a.PLANSALEAMOUNT else a.FACTSALEAMOUNT end) 预计签约金额,
       sum(case when a.PLANMONTH>=to_char(sysdate,'yyyy-mm') then a.PLANSALEAMOUNTNOTAX else a.FACTSALEAMOUNTNOTAX end) 预计签约不含税金额
  from FACT_BUDGET_ACTUAL_SALES a
  inner join dim_project c on a.PROJGUID = c.PROJGUID
  inner join dim_product d on a.PRODUCTGUID = d.PRODUCTGUID
  left join Dim_Project_append ap
    on c.projguid=ap.projguid
    and ap.operatetype='非操盘'
 where ap.projguid is null
 and case when substr(a.PLANMONTH, 1, 4)<='2016' then '2016' else substr(a.PLANMONTH, 1, 4) end = '${ysyear}'
${if(len(p_projguid) == 0,
            "and 1=1",
            " and a.PROJGUID in ('" + p_projguid + "')") }
 group by c.parentprojname,
          a.PROJGUID,
          c.PROJNAME,
          a.PRODUCTGUID,
          d.PRODUCTNAME,
          a.bldguid,
          a.PLANMONTH
union all
select c.parentprojname,
       a.PROJGUID 项目ID,
       c.PROJNAME 项目名称,
       d.PRODUCTGUID 产品类型ID,
       d.PRODUCTNAME 产品名称,
       a.producttypeguid 楼栋, --虚拟出来的楼栋
       yearmonth,
       sum(a.salenum) 预计签约套量,
       sum(a.SALEAREA) 预计签约面积,
       sum(nvl(a.SALEAMOUNT,0))*10000 预计签约金额,
       sum(nvl(a.salenottaxamount,0))*10000 预计签约不含税金额
from (select projguid,producttypeguid,yearno||'-'||substr(monthno+100,2,2) yearmonth,salenum,salearea,saleamount,salenottaxamount
      from fact_budgetsales_month
      where yearno='${ysyear}'
      ${if(len(p_projguid) == 0,
            "and 1=1",
            " and PROJGUID in ('" + p_projguid + "')") })a
 inner join dim_project c on a.PROJGUID = c.PROJGUID
  inner join dim_product d on a.producttypeguid = d.PRODUCTGUID
  inner join Dim_Project_append ap
  on c.projguid=ap.projguid
  and ap.operatetype='非操盘'
 group by c.parentprojname,
          a.PROJGUID,
          c.PROJNAME,
          a.producttypeguid,
          d.PRODUCTNAME,
          a.yearmonth,
          d.PRODUCTGUID) order by 项目ID,产品类型ID,bldguid,PLANMONTH

select c.parentprojname,
       a.PROJGUID 项目ID,
       c.PROJNAME 项目名称,
       a.producttypeguid 产品类型ID,
       d.PRODUCTNAME 产品名称,
       sum(a.salenum) 预计签约套量,
       sum(a.SALEAREA) 预计签约面积,
       sum(nvl(a.SALEAMOUNT,0))*10000 预计签约金额,
       sum(nvl(a.salenottaxamount,0))*10000 预计签约不含税金额
from (select projguid,producttypeguid,salenum,salearea,saleamount,salenottaxamount
      from fact_factsales_fill_month
      where  (yearno<substr('${smonth}',1,4)
          or (yearno=substr('${smonth}',1,4) and monthno<substr('${smonth}',6,2)+100-100)) 
       ${if(len(p_projguid) == 0,
            "and 1=1",
            " and PROJGUID in ('" + p_projguid + "')") }
      union all
      select projguid,producttypeguid,salenum,salearea,saleamount,salenottaxamount
      from fact_budgetsales_month
      where (yearno>substr('${smonth}',1,4)
          or (yearno=substr('${smonth}',1,4) and monthno>=substr('${smonth}',6,2)+100-100))
      ${if(len(p_projguid) == 0,
            "and 1=1",
            " and PROJGUID in ('" + p_projguid + "')") })a
 inner join dim_project c on a.PROJGUID = c.PROJGUID
  inner join dim_product d on a.producttypeguid = d.PRODUCTGUID
  inner join Dim_Project_append ap
  on c.projguid=ap.projguid
  and ap.operatetype='非操盘'
 group by c.parentprojname,
          a.PROJGUID,
          c.PROJNAME,
          a.producttypeguid,
          d.PRODUCTNAME

select c.parentprojname,
       a.PROJGUID 项目ID,
       c.PROJNAME 项目名称,
       a.producttypeguid 产品类型ID,
       d.PRODUCTNAME 产品名称,
       sum(a.salenum) 预计签约套量,
       sum(a.SALEAREA) 预计签约面积,
       sum(nvl(a.SALEAMOUNT,0))*10000 预计签约金额,
       sum(nvl(a.salenottaxamount,0))*10000 预计签约不含税金额
from (select projguid,producttypeguid,salenum,salearea,saleamount,salenottaxamount
      from fact_factsales_fill_month
      where  yearno<'${ysyear}'-1
       ${if(len(p_projguid) == 0,
            "and 1=1",
            " and PROJGUID in ('" + p_projguid + "')") })a
 inner join dim_project c on a.PROJGUID = c.PROJGUID
  inner join dim_product d on a.producttypeguid = d.PRODUCTGUID
  inner join Dim_Project_append ap
  on c.projguid=ap.projguid
  and ap.operatetype='非操盘'
 group by c.parentprojname,
          a.PROJGUID,
          c.PROJNAME,
          a.producttypeguid,
          d.PRODUCTNAME

select c.parentprojname,
       a.PROJGUID 项目ID,
       c.PROJNAME 项目名称,
       a.producttypeguid 产品类型ID,
       d.PRODUCTNAME 产品名称,
       sum(a.salenum) 预计签约套量,
       sum(a.SALEAREA) 预计签约面积,
       sum(nvl(a.SALEAMOUNT,0))*10000 预计签约金额,
       sum(nvl(a.salenottaxamount,0))*10000 预计签约不含税金额
from (select projguid,producttypeguid,salenum,salearea,saleamount,salenottaxamount
      from fact_factsales_fill_month
      where yearno='${ysyear}'-1 and monthno<substr('${smonth}',6,2)+100-100
       ${if(len(p_projguid) == 0,
            "and 1=1",
            " and PROJGUID in ('" + p_projguid + "')") })a
 inner join dim_project c on a.PROJGUID = c.PROJGUID
  inner join dim_product d on a.producttypeguid = d.PRODUCTGUID
  inner join Dim_Project_append ap
  on c.projguid=ap.projguid
  and ap.operatetype='非操盘'
 group by c.parentprojname,
          a.PROJGUID,
          c.PROJNAME,
          a.producttypeguid,
          d.PRODUCTNAME

select c.parentprojname,
       a.PROJGUID 项目ID,
       c.PROJNAME 项目名称,
       a.producttypeguid 产品类型ID,
       d.PRODUCTNAME 产品名称,
       yearmonth,
       sum(a.salenum) 预计签约套量,
       sum(a.SALEAREA) 预计签约面积,
       sum(nvl(a.SALEAMOUNT,0))*10000 预计签约金额,
       sum(nvl(a.salenottaxamount,0))*10000 预计签约不含税金额
from (select projguid,producttypeguid,yearno||'-'||substr(monthno+100,2,2) yearmonth,salenum,salearea,saleamount,salenottaxamount
      from fact_budgetsales_month
      where yearno=substr('${smonth}',1,4)
      ${if(len(p_projguid) == 0,
            "and 1=1",
            " and PROJGUID in ('" + p_projguid + "')") })a
 inner join dim_project c on a.PROJGUID = c.PROJGUID
  inner join dim_product d on a.producttypeguid = d.PRODUCTGUID
  inner join Dim_Project_append ap
  on c.projguid=ap.projguid
  and ap.operatetype='非操盘'
 group by c.parentprojname,
          a.PROJGUID,
          c.PROJNAME,
          a.producttypeguid,
          d.PRODUCTNAME,
          a.yearmonth

select c.parentprojname,
       a.PROJGUID 项目ID,
       c.PROJNAME 项目名称,
       a.producttypeguid 产品类型ID,
       d.PRODUCTNAME 产品名称,
       sum(a.salenum) 预计签约套量,
       sum(a.SALEAREA) 预计签约面积,
       sum(nvl(a.SALEAMOUNT,0))*10000 预计签约金额,
       sum(nvl(a.salenottaxamount,0))*10000 预计签约不含税金额
from (select projguid,producttypeguid,salenum,salearea,saleamount,salenottaxamount
      from fact_factsales_fill_month
      where case when YEARNO<=2016 then 2016 else YEARNO end='${ysyear}'
      and (yearno<to_char(sysdate,'yyyy')
          or (yearno=to_char(sysdate,'yyyy') and monthno<to_number(to_char(sysdate,'mm'))))
       ${if(len(p_projguid) == 0,
            "and 1=1",
            " and PROJGUID in ('" + p_projguid + "')") }
       union all     
            select projguid,producttypeguid,salenum,salearea,saleamount,salenottaxamount
      from fact_budgetsales_month
      where case when YEARNO<=2016 then 2016 else YEARNO end='${ysyear}'
      and (yearno>to_char(sysdate,'yyyy')
          or (yearno=to_char(sysdate,'yyyy') and monthno>=to_number(to_char(sysdate,'mm'))))
      ${if(len(p_projguid) == 0,
            "and 1=1",
            " and PROJGUID in ('" + p_projguid + "')") })a
 inner join dim_project c on a.PROJGUID = c.PROJGUID
  inner join dim_product d on a.producttypeguid = d.PRODUCTGUID
  inner join Dim_Project_append ap
  on c.projguid=ap.projguid
  and ap.operatetype='非操盘'
 group by c.parentprojname,
          a.PROJGUID,
          c.PROJNAME,
          a.producttypeguid,
          d.PRODUCTNAME

select c.parentprojname,
       a.PROJGUID 项目ID,
       c.PROJNAME 项目名称,
       a.producttypeguid 产品类型ID,
       d.PRODUCTNAME 产品名称,
       sum(a.salenum) 预计签约套量,
       sum(a.SALEAREA) 预计签约面积,
       sum(nvl(a.SALEAMOUNT,0))*10000 预计签约金额,
       sum(nvl(a.salenottaxamount,0))*10000 预计签约不含税金额
from (select projguid,producttypeguid,yearno||'-'||substr(monthno+100,2,2) yearmonth,salenum,salearea,saleamount,salenottaxamount
      from fact_budgetsales_month
      where yearno='${ysyear}'+1
      ${if(len(p_projguid) == 0,
            "and 1=1",
            " and PROJGUID in ('" + p_projguid + "')") })a
 inner join dim_project c on a.PROJGUID = c.PROJGUID
  inner join dim_product d on a.producttypeguid = d.PRODUCTGUID
  inner join Dim_Project_append ap
  on c.projguid=ap.projguid
  and ap.operatetype='非操盘'
 group by c.parentprojname,
          a.PROJGUID,
          c.PROJNAME,
          a.producttypeguid,
          d.PRODUCTNAME

with rate as (select * from 
(select a.*,rank() over(partition by a.tyear order by a.year desc) rn
from (select rate.*,rate.productguid||'_'||y.year tyear,y.year as yyear 
from 
fact_product_rate rate 
left join (select distinct to_char(2011+rownum-1) as year from dual
connect by rownum>='${ysyear}'+11-2011) y
on rate.year <= y.year) a
)b
where rn=1)
select pd.projguid      项目编号,
       p2.producttypeid 产品类型编号,
       pd.equity        权益比例,
       pd.VATLEVYTYPE   增值税计征方式,
       p1.year          年度,
       cbdfbhlxjfwf,
       cbdfzbhlx,
       cbdffwf,
       yysjjfj,
       xsfl,
       glfl,
       cwfl,
       tzsl,
       fjs,
       fjssfl,
       gqyj
  from dim_project_product pd
  left join rate p1
    on pd.productguid = p1.productguid,
 dim_product_producttype p2
 where pd.productguid = p2.productguid
 ${if(len(p_projguid) == 0,
            " ",
            "  and pd.PROJGUID in ('" + p_projguid + "')") }

SELECT 
b.projguid 项目分析,
b.BldGUID 楼栋编号,
t.PRODUCTTYPECODE 产品代码,
t.PRODUCTNAME 产品名称,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleNum ELSE  b.plansalenum END ) 预算套数,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleArea ELSE  b.plansalearea END ) 预算面积,
sum( CASE WHEN PlanMonth<'${smonth}'  THEN b.FactSaleAmount ELSE  b.plansaleamount END ) 预算金额
FROM FACT_BUDGET_ACTUAL_SALES b,DIM_MASTER_PRODUCT p,jd_GCBuilding bld,DIM_PRODUCT t
WHERE b.BldGUID=bld.BldGUID
and b.PlanMonth>='${smonth}'
and substr(b.PlanMonth,1,4)='${ysyear}'-1
AND bld.ProductGUID=p.PRODUCTGUID
 ${if(len(p_projguid) == 0, " ", "  and b.PROJGUID in ('" + p_projguid + "')")} 
AND p.PRODUCTTYPECODE=t.PRODUCTTYPECODE
GROUP BY b.projguid,b.BldGUID,t.PRODUCTNAME,t.PRODUCTTYPECODE

select c.parentprojname,
       a.PROJGUID 项目ID,
       c.PROJNAME 项目名称,
       a.producttypeguid 产品类型ID,
       d.PRODUCTNAME 产品名称,
       sum(a.salenum) 预计签约套量,
       sum(a.SALEAREA) 预计签约面积,
       sum(nvl(a.SALEAMOUNT,0))*10000 预计签约金额,
       sum(nvl(a.salenottaxamount,0))*10000 预计签约不含税金额
from (
      select projguid,producttypeguid,salenum,salearea,saleamount,salenottaxamount
      from fact_budgetsales_month
      where (yearno=substr('${ysyear}',1,4)-1 and monthno>=substr('${smonth}',6,2)+100-100)
      ${if(len(p_projguid) == 0,
            "and 1=1",
            " and PROJGUID in ('" + p_projguid + "')") })a
 inner join dim_project c on a.PROJGUID = c.PROJGUID
  inner join dim_product d on a.producttypeguid = d.PRODUCTGUID
  inner join Dim_Project_append ap
  on c.projguid=ap.projguid
  and ap.operatetype='非操盘'
 group by c.parentprojname,
          a.PROJGUID,
          c.PROJNAME,
          a.producttypeguid,
          d.PRODUCTNAME

select * from Fact_ys_SetBuildJzRule
where 1=1
${if(len(p_projguid) == 0, " ", "  and PROJGUID in ('" + p_projguid + "')")} 

select * from Fact_ys_SetSalePlanBld
where 1=1
${if(len(p_projguid) == 0, " ", "  and PROJGUID in ('" + p_projguid + "')")} 

select gcbd.gcBLDGUID,CASE WHEN B.TASK_REALENDTIME IS NULL THEN to_char(B.NODE_TASK_PLANENDTIME,'yyyy-mm-dd') ELSE to_char(B.TASK_REALENDTIME,'yyyy-mm-dd') END 取预售证时间 
from fl_plan a inner join 
FL_PLAN_NODETASK B 
on a.plan_id = b.plan_id
inner join Mid_RelevantKey MR
          ON MR.PLATFORMSKEY = B.COLUMN9
       INNER JOIN dim_master_building BD
          ON MR.MYKEY = BD.Bldguid
       INNER JOIN DIM_MASTER_PROJECT PRO
          ON BD.PROJGUID = PRO.PROJGUID
       inner join dim_gc_building gcbd
          on bd.bldguid = gcbd.masterbldguid
       where B.Task_Name like '%获取预售证%'
       and pro.projguid in ('${p_projguid}')
       and a.status = 2

