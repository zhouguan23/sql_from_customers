with tmp as (
select DISTINCT * from (
select DISTINCT a.PROVINCE,a.PRODUCTCODE,a.CUSTOMNAME,a.PRODUCTNAME,a.CUSTOMCODE,a.CUSTOMTYPE,a.sale,a.snjh,a.swjh,b.qcstock,c.qmstock,b.ncstock,min(e.ddate) DDATE
from(
select PROVINCE,PRODUCTCODE,CUSTOMNAME,PRODUCTNAME,CUSTOMCODE,CUSTOMTYPE,sum(sale) sale,sum(snjh) snjh,sum(swjh) swjh from target_inventory2
where 1=1
${IF(LEN(start_date)=0,"","AND SDATE>='"+start_date+"'")}
${IF(LEN(end_date)=0,"","AND SDATE<='"+end_date+"'")}
${IF(LEN(start_date)=0,"","AND SDATE>='"+start_date+"'")}
${IF(LEN(end_date)=0,"","AND SDATE<='"+end_date+"'")}
group by 
PROVINCE,PRODUCTCODE,CUSTOMNAME,PRODUCTNAME,CUSTOMCODE,CUSTOMTYPE) a
left join target_inventory2 b on  a.CUSTOMCODE=b.CUSTOMCODE and a.PRODUCTCODE=b.PRODUCTCODE 
${IF(LEN(start_date)=0,"","AND B.SDATE='"+start_date+"'")}
left join target_inventory2 c on  a.CUSTOMCODE=c.CUSTOMCODE and a.PRODUCTCODE=c.PRODUCTCODE 
${IF(LEN(end_date)=0,"","AND C.SDATE='"+end_date+"'")}
left join target_inventory2 e on  a.CUSTOMCODE=e.CUSTOMCODE and a.PRODUCTCODE=e.PRODUCTCODE 
${IF(LEN(start_date)=0,"","AND e.SDATE>='"+start_date+"'")}
${IF(LEN(end_date)=0,"","AND e.SDATE<='"+end_date+"'")}
group by a.PROVINCE,a.PRODUCTCODE,a.CUSTOMNAME,a.PRODUCTNAME,a.CUSTOMCODE,a.CUSTOMTYPE,a.sale,a.snjh,a.swjh,b.qcstock,c.qmstock,b.ncstock
) a
LEFT JOIN PRODUCT f ON A.PRODUCTCODE=f.PRODCODE
ORDER BY a.PROVINCE,a.CUSTOMCODE,a.PRODUCTCODE
),
tmp_org as (SELECT * FROM organization)

select a.*,sum(a.累计协议额) over(partition by a.customer_code order by a.customer_code)as 总协议额
from(
SELECT distinct
	row_number() over(partition by m.CUSTOMER_CODE,m.PRODUCT_CODE,m."YEAR" ORDER BY m.year) rn,
	sum(AGR_AMOUNT) over(partition by customer_code,PRODUCT_CODE)as 累计协议额，
	--sum(AGR_AMOUNT) over(partition by customer_code)as 协议额，
	m.*,dept.areaname,to_number(substr(m.month,2)) as mon,p.catn,p.prdn,p.smallpacknum,p.prdpd,ti.qcstock,rc.erp_code, org.orgname,t_org1.orgname t1,t_org2.orgname t2,	ti.SNJH,ti.SWJH,ti.sale,ti.qmstock,ti.ncstock,
	nvl(r.Q1_PAYMENT,0)+nvl(r.Q2_PAYMENT,0)+nvl(r.Q3_PAYMENT,0)+nvl(r.Q4_PAYMENT,0) as 累计支付  --sum(agr_amount) as 累计协议额
--region.regionname,org.attr5,ti.sdate,fd.je,
--je：商业销量  catn:产品名称 attr5:erp客户编码
FROM
	AGREEMENT_KA_VIEW m
--left join region on m.regioncode=region.regioncode --省
left join businessarea@CMILINK dept on m.areacode=dept.areacode --业务区域
left join organization org on m.customer_code=org.orgcode  --客户
left join REBATE_CUSTOMER rc on m.customer_code=rc.cmi_code
left join product p on m.product_code=p.prodcode   --产品
--LEFT JOIN FLOW_DETAIL fd ON m.CUSTOMER_CODE=fd.ORGCODE2 and m.product_code=fd.prodcode and fd.valuename='分销商' and to_char(fd.salesdate,'yyyy-mm')>='${start_date}'and to_char(fd.salesdate,'yyyy-mm')<='${end_date}'
--流向
LEFT JOIN tmp ti on m.CUSTOMER_CODE=ti.CUSTOMCODE and m.product_code=ti.PRODUCTCODE --and ti.sdate>='${start_date}' and ti.sdate<='${end_date}'   --一级进销存表
LEFT JOIN FR_REBATE_AGREEMENT r ON m.CUSTOMER_CODE=r.CUSTOMER and m.product_code=r.PRODCODE
left join tmp_org t_org1 on m.supplier1_code=t_org1.orgcode
left join tmp_org t_org2 on m.supplier2_code=t_org2.orgcode

WHERE
m.CLASS='KA' and m.year=to_char(TO_DATE ('${start_date}', 'yyyy-mm'),'yyyy') 
AND to_number(substr(m.month,2))>=to_char(to_date('${start_date}','yyyy-mm'),'mm') 
and to_number(substr(m.month,2))<=to_char(to_date('${end_date}','yyyy-mm'),'mm')
--AND ti.sdate>='2020-01' and ti.sdate<='2020-04'
${if(len(dept)=0,"","and m.areacode in ('"+dept+"')")}
${if(len(regioncode)=0,"","and m.regioncode in ('"+regioncode+"')")}
${if(len(prodcode)=0,"","and m.product_code in ('"+SUBSTITUTE(prodcode,",","','")+"')" ) }
${if(len(orgcode)=0,"","and m.customer_code in ('"+orgcode+"')")} 
order by m.customer_code,m.product_code,mon desc
)a
where rn=1

select distinct org.orgcode,org.orgcode||'-'||org.orgname codename
from AGREEMENT_KA_VIEW m
left join organization org on m.customer_code=org.orgcode --客户
where m.year=to_char(TO_DATE ('${start_date}', 'yyyy-mm'),'yyyy')
and m.class='KA'
order by org.orgcode

select distinct region.regioncode,region.regionname
from agreement m
left join region on m.regioncode=region.regioncode --省
where m.year=to_char(TO_DATE ('${start_date}', 'yyyy-mm'),'yyyy') and m.class='KA'
order by region.regioncode

SELECT m.orgcode,m.orgname,m.prodcode,m.prdn,m.qty as 期末库存,m.datelastupdated,month
FROM
  (select DISTINCT row_number()over(PARTITION BY orgcode,prodcode,to_char(DATELASTUPDATED,'mm') order BY datelastupdated desc) rn,
  sdate,DAQU,DIQU,REGIONNAME,CITYNAME,SELLERID,ORGCODE,ORGNAME,CUSTOMTYPE,GRADE,PRODCODE,PRODID,PRDN,CREATEDATE,CREATEDATE,DATELASTUPDATED,
		CATEGORYID,CATN,QTY,PRICE,to_number(to_char(DATELASTUPDATED,'mm')) month
	--to_date(to_char(CREATEDATE,'yyyy-mm-dd'),'yyyy-mm-dd') CREATEDATE,
	--to_date(to_char(DATELASTUPDATED,'yyyy-mm-d'),'yyyy-mm-dd') DATELASTUPDATED
	from V_STOCK where customtype like '%KA%'	
  ORDER BY datelastupdated DESC ) m
WHERE rn =1 AND
	to_char(m.datelastupdated,'yyyy-mm')>='${start_date}' --'2020-06'
  and to_char(m.datelastupdated,'yyyy-mm')<='${end_date}'  --'2020-07'
	--and prodcode='06006000101'
	--and orgcode='BZJ000005'
${if(len(prodcode)=0,"","and m.prodcode in ('"+SUBSTITUTE(prodcode,",","','")+"')")}
${if(len(orgcode)=0,"","and m.orgcode in ('"+orgcode+"')")}

--select * from V_STOCK where ROWNUM<10



SELECT distinct
PRODCODE as 产品编码,PRDN as 产品名称,ORGCODE1 as 客户编码,ORGNAME1 as 客户名称,sum(JE) as 金额  ,to_number(to_char(postdate,'mm')) as 月份--,to_char(SALESDATE, 'ww') as 周数--POSTDATE as 日期,
FROM FLOW_DETAIL
where 
VALUENAME like '%KA%' 
--and (TO_CHAR (TO_DATE (POSTDATE, 'yyyy-mm'),'yyyy-mm')>='2020-01' and TO_CHAR (TO_DATE (POSTDATE, 'yyyy-mm'),'yyyy-mm')<='2020-04')
and to_char(POSTDATE,'yyyy-mm')>='${start_date}' and to_char(POSTDATE,'yyyy-mm')<='${end_date}'

${if(len(prodcode)=0,"","and PRODCODE in ('"+SUBSTITUTE(prodcode,",","','")+"')")}
${if(len(orgcode)=0,"","and ORGCODE1 in ('"+orgcode+"')")} 
group by PRODCODE,PRDN,ORGCODE1,ORGNAME1,to_number(to_char(postdate,'mm'))

WITH tmp as(
select 
--LX.SALESDATE,lx.SELLERID,SORG.ORGCODE sorgcode,SORG.ORGNAME sorgname,lx.BUYERID,borg.orgcode borgcode,borg.orgname borgname,LX.PRODID,PROD.prodcode prodcode,LX.ORIGINALPRODCODE,LX.ORIGINALPRODNAME,LX.PRICE,lx.QTY ,
LX.*,SORG.ORGCODE sorgcode,SORG.ORGNAME sorgname,borg.orgcode borgcode,borg.orgname borgname,PROD.prodcode prodcode,
to_char(LX.SALESDATE,'yyyy')as year ,to_number(to_char(LX.SALESDATE,'mm'))as month,to_char(LX.SALESDATE,'yyyy-mm')as year_mon --,ORG.ORGCODE as 客户编码,ORG.ORGNAME as 客户名称,prod.prodcode as 产品编码  --LX.*,
from HISTORYOFMONTHSALES lx        --流向销售表
LEFT JOIN organization sorg on LX.SELLERID=sORG.ORGID
LEFT JOIN organization borg on LX.BUYERID=bORG.ORGID
LEFT JOIN PRODUCT prod on lx.PRODID=PROD.prodid
where  sorg.orgcode in ( SELECT DISTINCT SUPPLIER1_CODE FROM AGREEMENT@FR_LINK where class='KA' ) 
or sorg.orgcode in (SELECT DISTINCT SUPPLIER2_CODE  FROM AGREEMENT@FR_LINK where class='KA')
 --where borg.orgcode='BAH000013'
--and (SORG.ORGCODE='BAH000004' or SORG.ORGCODE='BAH000006')
)
select a.*,sum(a.实际进货额) over(PARTITION by a.borgcode order by a.borgcode )as 总进货额
from(
SELECT sorgcode,sorgname,borgcode,borgname,prodcode,ORIGINALPRODNAME,sum(qty),price,year_mon,sum(qty)*price 月实际进货额,sum(sum(qty)*price) over(PARTITION BY borgcode,prodcode) 实际进货额
--month,
from tmp 
where year_mon>='${start_date}' and year_mon<='${end_date}'
--and borgcode='BAH000013'
--AND prodcode='06001000301'
${if(len(prodcode)=0,"","and prodcode in ('"+SUBSTITUTE(prodcode,",","','")+"')" ) }
${if(len(orgcode)=0,"","and borgcode in ('"+orgcode+"')")} 
GROUP BY sorgcode,sorgname,borgcode,borgname,prodcode,ORIGINALPRODNAME,price,year_mon  --,month
ORDER BY year_mon DESC
)a
ORDER BY prodcode,year_mon



