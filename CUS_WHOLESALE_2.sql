SELECT AREA_CODE,
       cus_code,
       attribute,
       SUM(无税销售额) AS 无税销售额,
       SUM(无税毛利额) AS 无税毛利额,
       sum(毛利率) as 毛利率,
       SUM(无税成本) as 无税成本
  from (
SELECT 
AREA_CODE,
               nvl((select to_char(wf_customer_id)
                     from wf_customer
                    where to_char(wf_customer_id) = substr(cus_code, 1, 6)),
                   cus_code) cus_code,
ATTRIBUTE,
SUM(NO_TAX_AMOUNT) AS 无税销售额,
SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST) AS 无税毛利额,
CASE WHEN 
SUM(NO_TAX_AMOUNT)  = 0 
THEN 0
ELSE
(SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST))/ SUM(NO_TAX_AMOUNT) 
END AS 毛利率,
SUM(NO_TAX_COST) AS 无税成本,
related_party_trnsaction
FROM 
(         select a.no_tax_amount,
                a.cus_code,
                a.no_tax_cost,
                a.area_code,
                a.sale_date,
                a.dtp,
                b.vip,
                '加盟' attribute,
                related_party_trnsaction
           from dm_delivery_tmp a, dim_cus b
          where a.area_code = b.area_code
            and a.cus_code = b.cus_code
            and b.attribute = '加盟'
            and delivery_type = '加盟'
         union all
         select a.no_tax_amount,
                a.cus_code,
                a.no_tax_cost,
                a.area_code,
                a.sale_date,
                a.dtp,
                b.vip,
                '批发' attribute,
                related_party_trnsaction
           from dm_delivery_tmp a, dim_cus b
          where a.area_code = b.area_code
            and a.cus_code = b.cus_code
            and b.attribute = '批发'
            and delivery_type = '批发')
WHERE 
1=1
${if(len(VIP)=0,""," and nvl(vip,'否') IN ('"+VIP+"') ")}
${if(len(dtp)=0,"","and dtp ='"+dtp+"'")}
${if(len(ATTRIBUTE)=0,"","and ATTRIBUTE IN ('"+ATTRIBUTE+"')")}
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}
${if(len(relation)=0,""," and nvl(related_party_trnsaction,'否') in ('"+relation+"')")}
AND 
SALE_DATE >= date'${BEFORE1}'
AND 
SALE_DATE <= date'${BEFORE2}'
GROUP BY
AREA_CODE,
cus_code,
ATTRIBUTE,
related_party_trnsaction
ORDER BY 
AREA_CODE
)
 GROUP BY AREA_CODE, cus_code, attribute
 ORDER BY AREA_CODE

SELECT AREA_CODE,
       cus_code,
       attribute,
       SUM(无税销售额) AS 无税销售额,
       SUM(无税毛利额) AS 无税毛利额,
       sum(毛利率) as 毛利率,
       SUM(无税成本) as 无税成本
  from (select AREA_CODE,
               nvl((select to_char(wf_customer_id)
                     from wf_customer
                    where to_char(wf_customer_id) = substr(cus_code, 1, 6)),
                   cus_code) cus_code,
               attribute,
               SUM(NO_TAX_AMOUNT) AS 无税销售额,
               SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST) AS 无税毛利额,
               CASE
                 WHEN SUM(NO_TAX_AMOUNT) = 0 THEN
                  0
                 ELSE
                  (SUM(NO_TAX_AMOUNT) - SUM(NO_TAX_COST)) /
                  SUM(NO_TAX_AMOUNT)
               END AS 毛利率,
               SUM(NO_TAX_COST) AS 无税成本,
               related_party_trnsaction
          FROM (select a.no_tax_amount,
                       a.cus_code,
                       a.no_tax_cost,
                       a.area_code,
                       a.sale_date,
                       a.dtp,
                       b.vip,
                       '加盟' attribute,
                       related_party_trnsaction
                  from dm_delivery_tmp a, dim_cus b
                 where a.area_code = b.area_code
                   and a.cus_code = b.cus_code
                   and b.attribute = '加盟'
                   and delivery_type = '加盟'
                union all
                select a.no_tax_amount,
                       a.cus_code,
                       a.no_tax_cost,
                       a.area_code,
                       a.sale_date,
                       a.dtp,
                       b.vip,
                       '批发' attribute,
                       related_party_trnsaction
                  from dm_delivery_tmp a, dim_cus b
                 where a.area_code = b.area_code
                   and a.cus_code = b.cus_code
                   and b.attribute = '批发'
                   and delivery_type = '批发')
         WHERE 1 = 1
${if(len(VIP)=0,""," and nvl(vip,'否') IN ('"+VIP+"') ")}
${if(len(dtp)=0,"","and dtp ='"+dtp+"'")}
${if(len(ATTRIBUTE)=0,"","and ATTRIBUTE IN ('"+ATTRIBUTE+"')")}
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}
${if(len(relation)=0,""," and nvl(related_party_trnsaction,'否') in ('"+relation+"')")}
AND 
SALE_DATE >= date'${AFTER1}'
AND 
SALE_DATE <=date'${AFTER2}'
         GROUP BY AREA_CODE, cus_code, attribute,related_party_trnsaction
         ORDER BY AREA_CODE)
 GROUP BY AREA_CODE, cus_code, attribute
 ORDER BY AREA_CODE

SELECT DISTINCT 
AREA_CODE,
AREA_NAME 
FROM 
DIM_REGION
ORDER BY 
AREA_CODE

select distinct cus_code, cus_name, area_code, attribute
  from (select distinct cus_code, cus_name, area_code, attribute
          from dim_cus
          where attribute in ('批发','加盟')
        union all
        select distinct substr(a.cus_code, 1, 6) cus_code,
                        b.wf_customer_name,
                        a.area_code,
                        a.attribute
          from dim_cus a, wf_customer b
         where substr(a.cus_code, 1, 6) = to_char(b.wf_customer_id)
           and not exists (select *
                  from dim_cus c
                 where substr(a.cus_code, 1, 6) = c.cus_code
                   and a.area_code = c.area_code))
 where 1 = 1
${if(len(area)=0,""," and area_Code in ('"+area+"')")}
${if(len(cus)=0,""," and cus_code in ('"+cus+"')")}
${if(len(ATTRIBUTE)=0,"","and ATTRIBUTE IN ('"+ATTRIBUTE+"')")}
order by 3,1

