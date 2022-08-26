select 
	A.CREATE_DATE as 日期,
	A.ITEM_ID as 商品ID,
	A.ROUTE_QTY as 可用库存数量,
	A.STOCK_QTY as 实际库存数量,
	A.CURRENCY as 币种,
	A.ITEM_CODE as 商品货号,
	A.ITEM_NAME as 商品名称,
	B.ORG_CODE as 组织编码,
	B.ORG_NAME as 组织名称,
	B.SUB_COMPANY_NAME as 分公司,
	B.BRAND_NAME as 品牌
from
(select 
	A.CREATE_DATE,
	A.ITEM_ID,
	A.ROUTE_QTY,
	A.STOCK_QTY,
	A.CURRENCY,
	B.ORG_ID,
	C.ITEM_CODE,
 	C.ITEM_NAME
from	
	VBI_IT_STOCK A
left join 
	VBI_STORAGE B
on
	A.STORAGE_ID = B.STORAGE_ID
left join
	DIM_ITEM_INFO_ALL C
on 
	A.ITEM_ID = C.ITEM_ID
and A.CURRENCY = C.CURRENCY
where A.CURRENCY = '人民币'
and A.CREATE_DATE = trunc(sysdate-1)
) A
left join 	
	DIM_SHOP B	
on 
	A.ORG_ID = B.ORG_ID
WHERE 
A.ITEM_CODE ='${ITEM_CODE}'
and B.BRAND_NAME = '${brand}'
AND A.CURRENCY = '${currency}'
and B.SUB_COMPANY_NAME = '${sub_company_name}'

SELECT * FROM VBI_ITEM_INFO_PIC
WHERE ITEM_CODE = '${ITEM_CODE}'

SELECT item_code,item_name,sale_price,SPEC,CURRENCY
FROM DIM_ITEM_INFO_ALL 
WHERE 
ITEM_CODE ='${ITEM_CODE}'
AND CURRENCY = '${currency}'

select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}
and SUB_COMPANY_NAME in 
(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND  a,FR_T_USER  b
  where a.USER_ID=to_char(b.id) and b.username='${fr_username}'
)
-- 分公司维度

SELECT DISTINCT CURRENCY FROM VBI_CURRENCY

select distinct 
  b.BRAND_NAME as BRAND_NAME 
from 
(
  select 
    BRAND_NAME 
  from FILL_USER_BRAND  a,FR_T_USER  b
  where a.USER_ID=to_char(b.id) 
  ${if(len(fr_username)==0 || fr_username='admin',"","AND username IN ('"+fr_username+"')")} )  a,VBI_BRAND  b
where a.BRAND_NAME=b.BRAND_NAME 
-- 品牌维度

SELECT distinct item_code,item_name
FROM DIM_ITEM_INFO_ALL 

