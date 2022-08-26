select distinct 
  b.BRAND_NAME as BRAND_NAME 
from 
(
  select 
    BRAND_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id 
  ${if(len(fr_username)==0 || fr_username='admin',"","AND username IN ('"+fr_username+"')")} ) as a,VBI_BRAND as b
where a.BRAND_NAME=b.BRAND_NAME 
-- 品牌维度

select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}
and SUB_COMPANY_NAME in 
(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
)
-- 分公司维度

SELECT WEEK_ALL,MIN(DAY_ID) AS DAY_ID
FROM DIM_DAY
group by WEEK_ALL

select  min(DAY_ID) AS DAY_ID from DIM_DAY where WEEK_ALL=(
select WEEK_ALL from DIM_DAY where DAY_SHORT_DESC =DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 7 DAY),'%Y-%m-%d %H:%i:%S'))

SELECT
	A.ITEM_ID,
	J.DISCOUNT,		-- 折扣率
	C.ITEM_ID AS POPULAR,-- 畅销品
	B.ITEM_ID AS NEW,	-- 新品
	A.LARGE_CATE_CODE,  -- 大类
	A.SMALL_CATE_CODE,	-- 类别
	A.ITEM_CODE,		-- 货号
	A.ITEM_NAME,		-- 名称
	J.BRAND_NAME,		-- 品牌
	J.SUB_COMPANY_CODE,	-- 分公司编号
	J.SUB_COMPANY_NAME,	-- 分公司
	A.CUSTOM_CODE,		-- 自编码
	A.SMALL_CATE_NAME,	-- 小类名称
	A.ITEM_STATUS_NAME,	-- 状态
	A.MATERIAL_NAME,	-- 材质
	A.SUP_NAME,		-- 供应商
	A.SUP_ITEM_CODE,	-- 供应商货号
	A.SALE_PRICE,		-- 零售价
	A.CREATE_DATE,		-- 创建时间
	A.SEASON_NAME,		-- 季节
	A.ATTRI_COMEDATE,	-- 上市时间
	A.CONSUM_OBJECT_NAME,	-- 消费对象
	A.SERIES_NAME,		-- 系列
	A.SPEC,			-- 规格
	G.CREATE_DATE as RECENT_SALE_DATE,		-- 最近销售时间
	J.PROFIT,			-- 毛利
	J.ORGI_PROFIT,
	E.STORE_NUM	,	-- 动销店铺数
	K.SUM_AMOUNT as SHOP_AMOUNT,  -- 店铺库存
	L.SUM_AMOUNT as STOR_AMOUNT,  -- 虚拟仓库存
	M.ROUTE_AMOUNT,               -- 可用库存
	T.ROUTE_AMOUNT as GJ_ROUTE_AMOUNT,                -- 国际仓
	U.ROUTE_AMOUNT as YW_ROUTE_AMOUNT,               -- 义乌仓
	V.ROUTE_AMOUNT as HB_ROUTE_AMOUNT,               -- 华北仓
	W.ROUTE_AMOUNT as DG_ROUTE_AMOUNT,               -- 东莞仓
	N.STORE_NUM  ,                 -- 库存店铺数
	J.REAL_AMOUNT, -- 周销售额
	O.REAL_QTY as ON_QTY,
	O.SHOP_NUM as ON_SHOP_NUM,
	P.REAL_QTY as NO_QTY,
	Q.REAL_QTY as UN_QTY,
	A.FIRST_IN_DATE,	-- 首次入仓蜀将
	A.LAST_IN_DATE	,	-- 最近到总仓时间
	R.SUM_QTY as FLOW_QTY,
	S.SUM_QTY as ACM_FLOW_QTY,
	left(X.DDATE19,10) as DDATE_1,
	X.REAL_QTY_19 as REAL_QTY_1,
	X.REAL_AMOUNT_19 as REAL_AMOUNT_1,
	left(X.DDATE20,10) as DDATE_2,
	X.REAL_QTY_20 as REAL_QTY_2,
	X.REAL_AMOUNT_20 as REAL_AMOUNT_2,
	left(X.DDATE21,10) as DDATE_3,
	X.REAL_QTY_21 as REAL_QTY_3,
	X.REAL_AMOUNT_21 as REAL_AMOUNT_3,
	left(X.DDATE22,10) as DDATE_4,
	X.REAL_QTY_22 as REAL_QTY_4,
	X.REAL_AMOUNT_22 as REAL_AMOUNT_4,
	left(X.DDATE23,10) as DDATE_5,
	X.REAL_QTY_23 as REAL_QTY_5,
	X.REAL_AMOUNT_23 as REAL_AMOUNT_5,
	left(X.DDATE24,10) as DDATE_6,
	X.REAL_QTY_24 as REAL_QTY_6,
	X.REAL_AMOUNT_24 as REAL_AMOUNT_6,
	left(X.DDATE25,10) as DDATE_7,
	X.REAL_QTY_25 as REAL_QTY_7,
	X.REAL_AMOUNT_25 as REAL_AMOUNT_7,
	left(X.DDATE26,10) as DDATE_8,
	X.REAL_QTY_26 as REAL_QTY_8,
	X.REAL_AMOUNT_26 as REAL_AMOUNT_8,
	left(AF.DDATE8,10) as DDATE_9,
	AF.REAL_QTY_8 as REAL_QTY_9,
	AF.REAL_AMOUNT_8 as REAL_AMOUNT_9,
	left(AF.DDATE9,10) as DDATE_10,
	AF.REAL_QTY_9 as REAL_QTY_10,
	AF.REAL_AMOUNT_9 as REAL_AMOUNT_10,
	left(AF.DDATE10,10) as DDATE_11,
	AF.REAL_QTY_10 as REAL_QTY_11,
	AF.REAL_AMOUNT_10 as REAL_AMOUNT_11,
	left(AF.DDATE11,10) as DDATE_12,
	AF.REAL_QTY_11 as REAL_QTY_12,
	AF.REAL_AMOUNT_11 as REAL_AMOUNT_12,
	left(AF.DDATE12,10) as DDATE_13,
	AF.REAL_QTY_12 as REAL_QTY_13,
	AF.REAL_AMOUNT_12 as REAL_AMOUNT_13,
	left(AF.DDATE13,10) as DDATE_14,
	AF.REAL_QTY_13 as REAL_QTY_14,
	AF.REAL_AMOUNT_13 as REAL_AMOUNT_14,
	left(AF.DDATE14,10) as DDATE_15,
	AF.REAL_QTY_14 as REAL_QTY_15,
	AF.REAL_AMOUNT_14 as REAL_AMOUNT_15,
	AM.REAL_AMOUNT as SUM_AMOUNT,
	greatest(X.REAL_QTY_19,X.REAL_QTY_20,X.REAL_QTY_21,X.REAL_QTY_22,X.REAL_QTY_23,X.REAL_QTY_24,X.REAL_QTY_25,X.REAL_QTY_26) as REAL_QTY_MAX,
	greatest(X.REAL_AMOUNT_19,X.REAL_AMOUNT_20,X.REAL_AMOUNT_21,X.REAL_AMOUNT_22,X.REAL_AMOUNT_23,X.REAL_AMOUNT_24,X.REAL_AMOUNT_25,X.REAL_AMOUNT_26) as REAL_AMOUNT_MAX
	
FROM
	-- 基本内容
	(SELECT  
		H.ITEM_ID,		-- ID
		A.LARGE_CATE_CODE,  -- 大类
		A.SMALL_CATE_CODE,	-- 类别
		A.SMALL_CATE_NAME,	-- 小类名称
		A.ITEM_CODE,		-- 货号
		A.ITEM_NAME,		-- 名称	
		A.CUSTOM_CODE,		-- 自编码
		A.ITEM_STATUS_NAME,	-- 状态
		A.MATERIAL_NAME,	-- 材质
		A.SUP_NAME,		-- 供应商
		A.SUP_ITEM_CODE,	-- 供应商货号
		A.SALE_PRICE,		-- 零售价
		A.CREATE_DATE,		-- 创建时间
		A.SEASON_NAME,		-- 季节
		A.ATTRI_COMEDATE,	-- 上市时间
		A.CONSUM_OBJECT_NAME,	-- 消费对象
		A.SERIES_NAME,		-- 系列
		A.SPEC,			-- 规格
		A.FIRST_IN_DATE,	-- 首次入仓蜀将
		A.LAST_IN_DATE		-- 最近到总仓时间
	FROM
		DIM_ITEM_INFO_ALL A,
		FACT_SALE_SUB_WEEK H,
		(
		select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
		) as d
	WHERE 
		A.ITEM_ID = H.ITEM_ID
		and H.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
	AND H.WEEK_ALL ='${ddate}'
	AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	AND (H.CURRENCY = '${currency}' ${IF(currency='人民币',"OR H.CURRENCY IS NULL","")})
	${if(len(brand)=0,""," AND H.BRAND_NAME ='"+brand+"'")}
	${if(len(SUB_COMPANY_NAME)=0,"","AND H.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
	${if(len(ITEM)=0,""," AND H.ITEM_ID IN ('"+ITEM+"')")}
	${if(len(large_cate)=0,""," AND A.LARGE_CATE_CODE in('"+large_cate+"')")}
	${if(len(regular)=0,""," AND A.REGULAR_CODE in('"+regular+"')")}
	union 
		select   
		A.ITEM_ID,		-- ID
		A.LARGE_CATE_CODE,  -- 大类
		A.SMALL_CATE_CODE,	-- 类别
		A.SMALL_CATE_NAME,	-- 小类名称
		A.ITEM_CODE,		-- 货号
		A.ITEM_NAME,		-- 名称		
		A.CUSTOM_CODE,		-- 自编码
		A.ITEM_STATUS_NAME,	-- 状态
		A.MATERIAL_NAME,	-- 材质
		A.SUP_NAME,		-- 供应商
		A.SUP_ITEM_CODE,	-- 供应商货号
		A.SALE_PRICE,		-- 零售价
		A.CREATE_DATE,		-- 创建时间
		A.SEASON_NAME,		-- 季节
		A.ATTRI_COMEDATE,	-- 上市时间
		A.CONSUM_OBJECT_NAME,	-- 消费对象
		A.SERIES_NAME,		-- 系列
		A.SPEC,			-- 规格
		A.FIRST_IN_DATE,	-- 首次入仓蜀将
		A.LAST_IN_DATE		-- 最近到总仓时间
		from 
		DIM_ITEM_INFO_ALL  as A,FACT_STOCK_GENERAL as B
	WHERE 
	(A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	and B.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
	${if(len(large_cate)=0,""," AND A.LARGE_CATE_CODE in ('"+large_cate+"')")}
	${if(len(regular)=0,""," AND A.REGULAR_CODE in ('"+regular+"')")}
	${if(len(brand)=0,""," AND A.BRAND_NAME ='"+brand+"'")}
	and (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
	${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
	and A.ITEM_ID=B.ITEM_ID
	union 
		select   
		A.ITEM_ID,		-- ID
		A.LARGE_CATE_CODE,  -- 大类
		A.SMALL_CATE_CODE,	-- 类别
		A.SMALL_CATE_NAME,	-- 小类名称
		A.ITEM_CODE,		-- 货号
		A.ITEM_NAME,		-- 名称		
		A.CUSTOM_CODE,		-- 自编码
		A.ITEM_STATUS_NAME,	-- 状态
		A.MATERIAL_NAME,	-- 材质
		A.SUP_NAME,		-- 供应商
		A.SUP_ITEM_CODE,	-- 供应商货号
		A.SALE_PRICE,		-- 零售价
		A.CREATE_DATE,		-- 创建时间
		A.SEASON_NAME,		-- 季节
		A.ATTRI_COMEDATE,	-- 上市时间
		A.CONSUM_OBJECT_NAME,	-- 消费对象
		A.SERIES_NAME,		-- 系列
		A.SPEC,			-- 规格
		A.FIRST_IN_DATE,	-- 首次入仓蜀将
		A.LAST_IN_DATE		-- 最近到总仓时间
		from 
		DIM_ITEM_INFO_ALL  as A,VBI_STOCK_STOR B,VBI_ORG C, VBI_STORAGE D,
		(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
) as f
	WHERE 
	(A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	and B.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
	${if(len(large_cate)=0,""," AND A.LARGE_CATE_CODE in ('"+large_cate+"')")}
	${if(len(regular)=0,""," AND A.REGULAR_CODE in ('"+regular+"')")}
	${if(len(brand)=0,""," AND A.BRAND_NAME ='"+brand+"'")}
	and (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
	${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
	AND C.ORG_NAME NOT LIKE "%加盟%"
	and C.ORG_NAME=f.SUB_COMPANY_NAME
	and A.ITEM_ID=B.ITEM_ID
	and B.TARGET_TYPE = 0
	${if(len(SUB_COMPANY_NAME)=0,""," AND C.ORG_NAME = '"+SUB_COMPANY_NAME+"'")}
	and B.STORAGE_ID = D.STORAGE_ID
	and B.TARGET_ID = C.ORG_ID
	union 
	select  
		A.ITEM_ID,		-- ID
		A.LARGE_CATE_CODE,  -- 大类
		A.SMALL_CATE_CODE,	-- 类别
		A.SMALL_CATE_NAME,	-- 小类名称
		A.ITEM_CODE,		-- 货号
		A.ITEM_NAME,		-- 名称		
		A.CUSTOM_CODE,		-- 自编码
		A.ITEM_STATUS_NAME,	-- 状态
		A.MATERIAL_NAME,	-- 材质
		A.SUP_NAME,		-- 供应商
		A.SUP_ITEM_CODE,	-- 供应商货号
		A.SALE_PRICE,		-- 零售价
		A.CREATE_DATE,		-- 创建时间
		A.SEASON_NAME,		-- 季节
		A.ATTRI_COMEDATE,	-- 上市时间
		A.CONSUM_OBJECT_NAME,	-- 消费对象
		A.SERIES_NAME,		-- 系列
		A.SPEC,			-- 规格
		A.FIRST_IN_DATE,	-- 首次入仓蜀将
		A.LAST_IN_DATE		-- 最近到总仓时间
	from 
		DIM_ITEM_INFO_ALL  as A,FACT_STOCK_SUB_ITEM as B,
			(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
) as f
	WHERE 
	(A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	and B.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
	${if(len(large_cate)=0,""," AND A.LARGE_CATE_CODE in ('"+large_cate+"')")}
	${if(len(regular)=0,""," AND A.REGULAR_CODE in ('"+regular+"')")}
	${if(len(brand)=0,""," AND A.BRAND_NAME ='"+brand+"'")}
	${if(len(SUB_COMPANY_NAME)=0,"","AND B.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
	and (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
	${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
	and B.SUB_COMPANY_NAME=f.SUB_COMPANY_NAME
	and A.ITEM_ID=B.ITEM_ID
    union 
	SELECT
		b.ITEM_ID,		-- ID
		b.LARGE_CATE_CODE,  -- 大类
		b.SMALL_CATE_CODE,	-- 类别
		b.SMALL_CATE_NAME,	-- 小类名称
		b.ITEM_CODE,		-- 货号
		b.ITEM_NAME,		-- 名称		
		b.CUSTOM_CODE,		-- 自编码
		b.ITEM_STATUS_NAME,	-- 状态
		b.MATERIAL_NAME,	-- 材质
		b.SUP_NAME,		-- 供应商
		b.SUP_ITEM_CODE,	-- 供应商货号
		b.SALE_PRICE,		-- 零售价
		b.CREATE_DATE,		-- 创建时间
		b.SEASON_NAME,		-- 季节
		b.ATTRI_COMEDATE,	-- 上市时间
		b.CONSUM_OBJECT_NAME,	-- 消费对象
		b.SERIES_NAME,		-- 系列
		b.SPEC,			-- 规格
		b.FIRST_IN_DATE,	-- 首次入仓蜀将
		b.LAST_IN_DATE		-- 最近到总仓时间
		from VBI_ORGI_NO_ARR as a,DIM_ITEM_INFO_ALL as b,
			(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
) as f    
		where  a.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})
		and a.ITEM_ID=b.ITEM_ID
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,"","AND a.ORG_NAME  = '"+SUB_COMPANY_NAME+"'")}
		${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in ('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND b.REGULAR_CODE in ('"+regular+"')")}
	     and a.ORG_NAME=f.SUB_COMPANY_NAME
	     union 
	     SELECT
		c.ITEM_ID,		-- ID
		c.LARGE_CATE_CODE,  -- 大类
		c.SMALL_CATE_CODE,	-- 类别
		c.SMALL_CATE_NAME,	-- 小类名称
		c.ITEM_CODE,		-- 货号
		c.ITEM_NAME,		-- 名称		
		c.CUSTOM_CODE,		-- 自编码
		c.ITEM_STATUS_NAME,	-- 状态
		c.MATERIAL_NAME,	-- 材质
		c.SUP_NAME,		-- 供应商
		c.SUP_ITEM_CODE,	-- 供应商货号
		c.SALE_PRICE,		-- 零售价
		c.CREATE_DATE,		-- 创建时间
		c.SEASON_NAME,		-- 季节
		c.ATTRI_COMEDATE,	-- 上市时间
		c.CONSUM_OBJECT_NAME,	-- 消费对象
		c.SERIES_NAME,		-- 系列
		c.SPEC,			-- 规格
		c.FIRST_IN_DATE,	-- 首次入仓蜀将
		c.LAST_IN_DATE		-- 最近到总仓时间
		from FACT_ON_PASSAGE_ITEM_SUB as a,DIM_ITEM_INFO_ALL as c,
			(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
) as f   
		where 
		 a.CREATE_DATE = DATE_ADD('2010-12-26',INTERVAL ${ddate} WEEK)
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}  
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (c.CURRENCY = '${currency}' ${IF(currency='人民币',"OR c.CURRENCY IS NULL","")})
		and a.ITEM_ID=c.ITEM_ID
		${if(len(brand)=0,""," AND c.BRAND_NAME ='"+brand+"'")}
	   ${if(len(SUB_COMPANY_NAME)=0,"","AND a.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
		${if(len(large_cate)=0,""," AND c.LARGE_CATE_CODE in ('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND c.REGULAR_CODE in ('"+regular+"')")}
	     and a.SUB_COMPANY_NAME=f.SUB_COMPANY_NAME
	     union 
	      SELECT 
		c.ITEM_ID,		-- ID
		c.LARGE_CATE_CODE,  -- 大类
		c.SMALL_CATE_CODE,	-- 类别
		c.SMALL_CATE_NAME,	-- 小类名称
		c.ITEM_CODE,		-- 货号
		c.ITEM_NAME,		-- 名称		
		c.CUSTOM_CODE,		-- 自编码
		c.ITEM_STATUS_NAME,	-- 状态
		c.MATERIAL_NAME,	-- 材质
		c.SUP_NAME,		-- 供应商
		c.SUP_ITEM_CODE,	-- 供应商货号
		c.SALE_PRICE,		-- 零售价
		c.CREATE_DATE,		-- 创建时间
		c.SEASON_NAME,		-- 季节
		c.ATTRI_COMEDATE,	-- 上市时间
		c.CONSUM_OBJECT_NAME,	-- 消费对象
		c.SERIES_NAME,		-- 系列
		c.SPEC,			-- 规格
		c.FIRST_IN_DATE,	-- 首次入仓蜀将
		c.LAST_IN_DATE		-- 最近到总仓时间
		from FACT_UNPREPARE_ITEM_SUB as a,DIM_ITEM_INFO_ALL as c,
			(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
) as f    
		where 
		 a.CREATE_DATE = DATE_ADD('2010-12-26',INTERVAL ${ddate} WEEK)
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,"","AND a.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}  
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (c.CURRENCY = '${currency}' ${IF(currency='人民币',"OR c.CURRENCY IS NULL","")})
		and a.ITEM_ID=c.ITEM_ID
		${if(len(brand)=0,""," AND c.BRAND_NAME ='"+brand+"'")}
		${if(len(large_cate)=0,""," AND c.LARGE_CATE_CODE in ('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND c.REGULAR_CODE in ('"+regular+"')")}
	     and a.SUB_COMPANY_NAME=f.SUB_COMPANY_NAME
		union 
	     SELECT   
		C.ITEM_ID,		-- ID
		C.LARGE_CATE_CODE,  -- 大类
		C.SMALL_CATE_CODE,	-- 类别
		C.SMALL_CATE_NAME,	-- 小类名称
		C.ITEM_CODE,		-- 货号
		C.ITEM_NAME,		-- 名称		
		C.CUSTOM_CODE,		-- 自编码
		C.ITEM_STATUS_NAME,	-- 状态
		C.MATERIAL_NAME,	-- 材质
		C.SUP_NAME,		-- 供应商
		C.SUP_ITEM_CODE,	-- 供应商货号
		C.SALE_PRICE,		-- 零售价
		C.CREATE_DATE,		-- 创建时间
		C.SEASON_NAME,		-- 季节
		C.ATTRI_COMEDATE,	-- 上市时间
		C.CONSUM_OBJECT_NAME,	-- 消费对象
		C.SERIES_NAME,		-- 系列
		C.SPEC,			-- 规格
		C.FIRST_IN_DATE,	-- 首次入仓蜀将
		C.LAST_IN_DATE		-- 最近到总仓时间
		FROM FACT_IT_FLOW_WEEK A,DIM_ITEM_INFO_ALL as C
		WHERE A.WEEK_ALL='${ddate}'
		AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	
      	and A.ITEM_ID=C.ITEM_ID		
		AND (C.CURRENCY = '${currency}' ${IF(currency='人民币',"OR C.CURRENCY IS NULL","")})
		${if(len(large_cate)=0,""," AND C.LARGE_CATE_CODE in ('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND C.REGULAR_CODE in ('"+regular+"')")}
	     ${if(len(brand)=0,""," AND C.BRAND_NAME ='"+brand+"'")}
	     ${if(len(ITEM)=0,""," AND C.ITEM_ID in ('"+ITEM+"')")}
	
	) A
	-- 新品信息
	LEFT JOIN (select a.ITEM_ID 
		FROM DIM_ITEM_NEW as a,DIM_ITEM_INFO_ALL as b
		WHERE a.WEEK_ALL = '${ddate}'
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		and a.ITEM_ID=b.ITEM_ID
		and b.CURRENCY='人民币'
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
	     ${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in('"+large_cate+"')")}
	      ${if(len(regular)=0,""," AND b.REGULAR_CODE in('"+regular+"')")}
	) B ON A.ITEM_ID = B.ITEM_ID
	-- 畅销品信息
	LEFT JOIN (select distinct a.ITEM_ID 
		FROM DIM_ITEM_POPULAR as a,DIM_ITEM_INFO_ALL as b
		WHERE a.WEEK_ALL = '${ddate}'
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		and a.ITEM_ID=b.ITEM_ID
		and b.CURRENCY='人民币'
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
	     ${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in('"+large_cate+"')")}
	      ${if(len(regular)=0,""," AND b.REGULAR_CODE in('"+regular+"')")}	)C
	      ON A.ITEM_ID = C.ITEM_ID
	-- 动销店铺数	
	LEFT JOIN (SELECT A.ITEM_ID,
		SUM(A.SHOP_NUM) as STORE_NUM
		FROM DIM_CROSS_SHOP_NUMBER as A,DIM_ITEM_INFO_ALL as B,
			(
		select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
		) as d
		WHERE A.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		 AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
		AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
		${if(len(brand)=0,""," AND A.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,"","AND A.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
		AND A.ITEM_ID=B.ITEM_ID
		and A.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
		${if(len(large_cate)=0,""," AND B.LARGE_CATE_CODE in('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND B.REGULAR_CODE in('"+regular+"')")}
		${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
		GROUP BY A.ITEM_ID) E ON A.ITEM_ID = E.ITEM_ID
	
	LEFT JOIN VBI_SALE_RECENT_DATE G ON A.ITEM_ID = G.ITEM_ID
	LEFT JOIN 
	(
	SELECT
		H.ITEM_ID,		-- ID
		1-SUM(H.TRANS_AMOUNT)/SUM(H.REAL_AMOUNT) as PROFIT,
		1-SUM(H.TRANS_AMOUNT)/SUM(H.ORGI_AMOUNT) as ORGI_PROFIT,
		SUM(H.REAL_AMOUNT)/SUM(H.ORGI_AMOUNT) as DISCOUNT,
		H.BRAND_NAME,		-- 品牌
		B.SUB_COMPANY_CODE,	-- 分公司编号
		H.SUB_COMPANY_NAME,	-- 分公司
		sum(H.REAL_QTY) as REAL_AMOUNT -- 周销售额
	FROM
		DIM_ITEM_INFO_ALL A,
		DIM_SUB B,
		FACT_SALE_SUB_WEEK H,
			(
		select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
		) as d
	WHERE 
		A.ITEM_ID = H.ITEM_ID
	AND
		B.SUB_COMPANY_NAME = H.SUB_COMPANY_NAME
	AND
		B.BRAND_NAME = H.BRAND_NAME
		and B.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
	AND 
		H.WEEK_ALL ='${ddate}'
	AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	AND (H.CURRENCY = '${currency}' ${IF(currency='人民币',"OR H.CURRENCY IS NULL","")})
	${if(len(brand)=0,""," AND H.BRAND_NAME ='"+brand+"'")}
	${if(len(SUB_COMPANY_NAME)=0,"","AND H.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
	${if(len(ITEM)=0,""," AND H.ITEM_ID IN ('"+ITEM+"')")}
	${if(len(large_cate)=0,""," AND A.LARGE_CATE_CODE in('"+large_cate+"')")}
	${if(len(regular)=0,""," AND A.REGULAR_CODE in('"+regular+"')")}
	GROUP BY H.ITEM_ID
	) as J on A.ITEM_ID=J.ITEM_ID
	left join 
		(SELECT 
			ITEM_ID,
			SUM(STOCK_QTY) AS SUM_AMOUNT
		FROM FACT_STOCK_SUB_ITEM_BAK as a,
			(
		select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
		) as d
		WHERE CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
		${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
		and a.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
		${if(len(SUB_COMPANY_NAME)=0,"","AND a.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
		${if(len(ITEM)=0,""," AND ITEM_ID IN ('"+ITEM+"')")}
		GROUP BY ITEM_ID
		) as K on A.ITEM_ID=K.ITEM_ID
	left join
		(SELECT
			D.ITEM_ID,
			SUM(D.SUM_STOCK_QTY) AS SUM_AMOUNT
		FROM DIM_ITEM_INFO_ALL C,
			(select 
				(A.STOCK_QTY+A.LIEN_QTY+IFNULL(A.SUB_STOCK_QTY,0)) AS SUM_STOCK_QTY,
				B.ORG_NAME,
				A.ITEM_ID,
				E.BRAND_NAME
			FROM VBI_STOCK_STOR A,VBI_ORG B, VBI_STORAGE E,
				(
		select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}) as d
			WHERE A.TARGET_TYPE = 0
			AND A.TARGET_ID = B.ORG_ID
			AND A.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
			AND B.ORG_NAME NOT LIKE "%加盟%"
			AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
			${if(len(SUB_COMPANY_NAME)=0,""," AND B.ORG_NAME = '"+SUB_COMPANY_NAME+"'")}
			${if(len(brand)=0,""," AND E.BRAND_NAME ='"+brand+"'")}
			and B.ORG_NAME=d.SUB_COMPANY_NAME
			${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
			AND A.STORAGE_ID = E.STORAGE_ID) D
		WHERE D.ITEM_ID = C.ITEM_ID
		AND (C.CURRENCY = '${currency}' ${IF(currency='人民币',"OR C.CURRENCY IS NULL","")})
		GROUP BY D.ITEM_ID) as L on A.ITEM_ID=L.ITEM_ID
	left join 
		(SELECT 
			A.ITEM_ID,
			A.ROUTE_QTY as ROUTE_AMOUNT
		FROM FACT_STOCK_GENERAL as A,DIM_ITEM_INFO_ALL as B
		WHERE A.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
		${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
		${if(len(large_cate)=0,""," AND B.LARGE_CATE_CODE in('"+large_cate+"')")}
	      ${if(len(regular)=0,""," AND B.REGULAR_CODE in('"+regular+"')")}
	      and A.ITEM_ID=B.ITEM_ID
	     AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
		) as M on A.ITEM_ID=M.ITEM_ID
	left join
	(SELECT 
		ITEM_ID,
		SUM(SHOP_NUMBER) AS STORE_NUM
	FROM FACT_STOCK_SUB_ITEM_SHOP_NUMBER as a,
		(
		select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
		) as d
	WHERE CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
	AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
	${if(len(brand)=0,""," AND BRAND_NAME ='"+brand+"'")}
	and a.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
	${if(len(SUB_COMPANY_NAME)=0,"","AND a.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
	${if(len(ITEM)=0,""," AND ITEM_ID IN ('"+ITEM+"')")}
	GROUP BY ITEM_ID
	) as N on A.ITEM_ID=N.ITEM_ID
	left join 
(
select 
			a.ITEM_ID,
			sum(a.REAL_QTY) as REAL_QTY,
			a.SHOP_NUM
		from FACT_ON_PASSAGE_ITEM_SUB as a,DIM_ITEM_INFO_ALL as c ,
			(
		select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
		) as d   
		where 
		 a.CREATE_DATE = DATE_ADD('2010-12-26',INTERVAL ${ddate} WEEK)
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(brand)=0,""," AND c.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,"","AND a.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (c.CURRENCY = '${currency}' ${IF(currency='人民币',"OR c.CURRENCY IS NULL","")})
		and a.item_id=c.item_id
		and a.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
		${if(len(large_cate)=0,""," AND c.LARGE_CATE_CODE in('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND c.REGULAR_CODE in('"+regular+"')")}
		group by a.ITEM_ID
) as O
on A.ITEM_ID=O.ITEM_ID
left join
(
select 
			a.ITEM_ID,
			sum(a.REAL_QTY) as REAL_QTY
		from VBI_ORGI_NO_ARR as a,DIM_ITEM_INFO_ALL as b ,
			(
		select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
		) as d   
		where  a.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})
		and a.ITEM_ID=b.ITEM_ID
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,"","AND a.ORG_NAME  = '"+SUB_COMPANY_NAME+"'")}
		and a.ORG_NAME=d.SUB_COMPANY_NAME
		${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in ('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND b.REGULAR_CODE in ('"+regular+"')")}
		group by a.ITEM_ID
) as P
on A.ITEM_ID=P.ITEM_ID
left join
(
select 
			a.ITEM_ID,
			sum(a.REAL_QTY) as REAL_QTY 
		from FACT_UNPREPARE_ITEM_SUB as a,DIM_ITEM_INFO_ALL as c ,
			(
		select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
		) as d   
		where 
	 a.CREATE_DATE = DATE_ADD('2010-12-26',INTERVAL ${ddate} WEEK)
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(brand)=0,""," AND c.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,"","AND a.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (c.CURRENCY = '${currency}' ${IF(currency='人民币',"OR c.CURRENCY IS NULL","")})
		and a.item_id=c.item_id
		and a.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
		${if(len(large_cate)=0,""," AND c.LARGE_CATE_CODE in('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND c.REGULAR_CODE in('"+regular+"')")}
		group by a.ITEM_ID
) as Q on A.ITEM_ID=Q.ITEM_ID
left join
(
SELECT 
			A.ITEM_ID,
			SUM(A.REAL_QTY) AS SUM_QTY,
			SUM(A.REAL_QTY*C.SALE_PRICE) AS SUM_AMOUNT
			FROM FACT_IT_FLOW_WEEK A,DIM_ITEM_INFO_ALL as C
			WHERE A.WEEK_ALL='${ddate}'
		AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
		AND (C.CURRENCY = '${currency}' ${IF(currency='人民币',"OR C.CURRENCY IS NULL","")})
			
			and A.ITEM_ID=C.ITEM_ID
			${if(len(ITEM)=0,""," AND C.ITEM_ID IN ('"+ITEM+"')")}
			${if(len(large_cate)=0,""," AND C.LARGE_CATE_CODE in('"+large_cate+"')")}
	          ${if(len(regular)=0,""," AND C.REGULAR_CODE in('"+regular+"')")} 
			 GROUP BY A.ITEM_ID
) as R on A.ITEM_ID=R.ITEM_ID
left join 
(
SELECT 
			A.ITEM_ID,
			SUM(A.REAL_QTY) AS SUM_QTY,
			SUM(A.REAL_QTY*C.SALE_PRICE) AS SUM_AMOUNT
			FROM FACT_IT_FLOW_WEEK_ALL A,DIM_ITEM_INFO_ALL as C
			WHERE 
          (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
		AND (C.CURRENCY = '${currency}' ${IF(currency='人民币',"OR C.CURRENCY IS NULL","")})
			and A.ITEM_ID=C.ITEM_ID
			${if(len(ITEM)=0,""," AND C.ITEM_ID IN ('"+ITEM+"')")}
			${if(len(large_cate)=0,""," AND C.LARGE_CATE_CODE in('"+large_cate+"')")}
	          ${if(len(regular)=0,""," AND C.REGULAR_CODE in('"+regular+"')")} 
			 GROUP BY A.ITEM_ID
) as S on A.ITEM_ID=S.ITEM_ID
left join 
		(SELECT 
			ITEM_ID,
			ROUTE_QTY as ROUTE_AMOUNT
		FROM FACT_STOCK_GENERAL_TYPE
		WHERE CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
		${if(len(ITEM)=0,""," AND ITEM_ID IN ('"+ITEM+"')")}
		and STORAGE_TYPE='国际仓'
		) as T on A.ITEM_ID=T.ITEM_ID
left join 
		(SELECT 
			ITEM_ID,
			ROUTE_QTY as ROUTE_AMOUNT
		FROM FACT_STOCK_GENERAL_TYPE
		WHERE CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
		${if(len(ITEM)=0,""," AND ITEM_ID IN ('"+ITEM+"')")}
		and STORAGE_TYPE='义乌仓'
		) as U on A.ITEM_ID=U.ITEM_ID
		left join 
		(SELECT 
			ITEM_ID,
			ROUTE_QTY as ROUTE_AMOUNT
		FROM FACT_STOCK_GENERAL_TYPE
		WHERE CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
		${if(len(ITEM)=0,""," AND ITEM_ID IN ('"+ITEM+"')")}
		and STORAGE_TYPE='华北仓'
		) as V on A.ITEM_ID=V.ITEM_ID
		left join 
		(SELECT 
			ITEM_ID,
			ROUTE_QTY as ROUTE_AMOUNT
		FROM FACT_STOCK_GENERAL_TYPE
		WHERE CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
		${if(len(ITEM)=0,""," AND ITEM_ID IN ('"+ITEM+"')")}
		and STORAGE_TYPE='东莞仓'
		) as W on A.ITEM_ID=W.ITEM_ID
		left join
		(SELECT a.ITEM_ID,
        DATE_FORMAT(DATE_SUB(a.DDATE_19,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE19,
       SUM(a.REAL_AMOUNT_19) AS REAL_AMOUNT_19,
        SUM(a.REAL_QTY_19) AS REAL_QTY_19,
        DATE_FORMAT(DATE_SUB(a.DDATE_20,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE20,
       SUM(a.REAL_AMOUNT_20) AS REAL_AMOUNT_20,
        SUM(a.REAL_QTY_20) AS REAL_QTY_20,
        DATE_FORMAT(DATE_SUB(a.DDATE_21,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE21,
       SUM(a.REAL_AMOUNT_21) AS REAL_AMOUNT_21,
        SUM(a.REAL_QTY_21) AS REAL_QTY_21,
        DATE_FORMAT(DATE_SUB(a.DDATE_22,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE22,
       SUM(a.REAL_AMOUNT_22) AS REAL_AMOUNT_22,
        SUM(a.REAL_QTY_22) AS REAL_QTY_22,
        DATE_FORMAT(DATE_SUB(a.DDATE_23,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE23,
       SUM(a.REAL_AMOUNT_23) AS REAL_AMOUNT_23,
        SUM(a.REAL_QTY_23) AS REAL_QTY_23,
        DATE_FORMAT(DATE_SUB(a.DDATE_24,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE24,
       SUM(a.REAL_AMOUNT_24) AS REAL_AMOUNT_24,
        SUM(a.REAL_QTY_24) AS REAL_QTY_24,
        DATE_FORMAT(DATE_SUB(a.DDATE_25,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE25,
       SUM(a.REAL_AMOUNT_25) AS REAL_AMOUNT_25,
        SUM(a.REAL_QTY_25) AS REAL_QTY_25,
        DATE_FORMAT(DATE_SUB(a.DDATE_26,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE26,
       SUM(a.REAL_AMOUNT_26) AS REAL_AMOUNT_26,
        SUM(a.REAL_QTY_26) AS REAL_QTY_26
		FROM FACT_SALE_SUB_WEEK_LONG as a,DIM_ITEM_INFO_ALL as b,
			(
		select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}
and SUB_COMPANY_NAME in 
(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
)
		) as d
		WHERE a.WEEK_ALL = ${ddate}
		
	AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})	
	AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})	
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,""," AND a.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}

		and a.ITEM_ID=b.ITEM_ID
		and a.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
		${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND b.REGULAR_CODE in('"+regular+"')")}
		GROUP BY a.ITEM_ID
		) as X
		on A.ITEM_ID=X.ITEM_ID
	
		left join
		(SELECT a.ITEM_ID,
        DATE_FORMAT(DATE_SUB(a.DDATE_8,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE8,
       SUM(a.REAL_AMOUNT_8) AS REAL_AMOUNT_8,
        SUM(a.REAL_QTY_8) AS REAL_QTY_8,
        DATE_FORMAT(DATE_SUB(a.DDATE_9,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE9,
       SUM(a.REAL_AMOUNT_9) AS REAL_AMOUNT_9,
        SUM(a.REAL_QTY_9) AS REAL_QTY_9,
        DATE_FORMAT(DATE_SUB(a.DDATE_10,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE10,
       SUM(a.REAL_AMOUNT_10) AS REAL_AMOUNT_10,
        SUM(a.REAL_QTY_10) AS REAL_QTY_10,
        DATE_FORMAT(DATE_SUB(a.DDATE_11,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE11,
       SUM(a.REAL_AMOUNT_11) AS REAL_AMOUNT_11,
        SUM(a.REAL_QTY_11) AS REAL_QTY_11,
        DATE_FORMAT(DATE_SUB(a.DDATE_12,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE12,
       SUM(a.REAL_AMOUNT_12) AS REAL_AMOUNT_12,
        SUM(a.REAL_QTY_12) AS REAL_QTY_12,
        DATE_FORMAT(DATE_SUB(a.DDATE_13,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE13,
       SUM(a.REAL_AMOUNT_13) AS REAL_AMOUNT_13,
        SUM(a.REAL_QTY_13) AS REAL_QTY_13,
        DATE_FORMAT(DATE_SUB(a.DDATE_14,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE14,
       SUM(a.REAL_AMOUNT_14) AS REAL_AMOUNT_14,
        SUM(a.REAL_QTY_14) AS REAL_QTY_14
		FROM FACT_CROSS_SALE_SUB_LONG as a,DIM_ITEM_INFO_ALL as b,
				(
		select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
		) as d 
		WHERE 
		a.WEEK_ALL = '${ddate}'
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,"","AND a.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		and a.ITEM_ID=b.ITEM_ID
		${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND b.REGULAR_CODE in('"+regular+"')")}
	     and a.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
	     ${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
		GROUP BY a.ITEM_ID
		) as AF
		on A.ITEM_ID=AF.ITEM_ID
		left JOIN 
	(
	SELECT
		A.ITEM_ID,		-- ID
		sum(H.REAL_AMOUNT) as REAL_AMOUNT -- 半年销售额
	FROM
		
		DIM_SUB B,
		
			(
		select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
  ${if(len(brand)==0,""," AND a.BRAND_NAME ='"+brand+"'")}
		) as d,
		DIM_ITEM_INFO_ALL A
		inner join 
		FACT_SALE_SUB_HALF H
		
	on 
		A.ITEM_ID = H.ITEM_ID
	where 
		B.SUB_COMPANY_NAME = H.SUB_COMPANY_NAME
	AND
		B.BRAND_NAME = H.BRAND_NAME
		and B.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
	AND 
		H.WEEK_ALL ='${ddate}'
	AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	AND (H.CURRENCY = '${currency}' ${IF(currency='人民币',"OR H.CURRENCY IS NULL","")})
	${if(len(brand)=0,""," AND H.BRAND_NAME ='"+brand+"'")}
	${if(len(SUB_COMPANY_NAME)=0,"","AND H.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
	${if(len(ITEM)=0,""," AND H.ITEM_ID IN ('"+ITEM+"')")}
	${if(len(large_cate)=0,""," AND A.LARGE_CATE_CODE in('"+large_cate+"')")}
	${if(len(regular)=0,""," AND A.REGULAR_CODE in('"+regular+"')")}
	GROUP BY A.ITEM_ID
	) as AM on A.ITEM_ID=AM.ITEM_ID
		
				

SELECT
		B.ITEM_ID,
		A.ITEM_CODE
	FROM
		DIM_ITEM_INFO_ALL A,
		FACT_SALE_SUB_WEEK B
	WHERE 
		A.ITEM_ID = B.ITEM_ID
	AND 
		B.WEEK_ALL ='${ddate}'
	AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
	${if(len(brand)=0,""," AND B.BRAND_NAME ='"+brand+"'")}
	${if(len(sub_company_name)=0,"","AND B.SUB_COMPANY_NAME  = '"+sub_company_name+"'")}
	${if(len(large_cate)=0,""," AND A.LARGE_CATE_CODE in('"+large_cate+"')")}
	${if(len(regular)=0,""," AND A.REGULAR_CODE in('"+regular+"')")}

SELECT
	A.ITEM_ID,
	J.DISCOUNT,		-- 折扣率
	C.ITEM_ID AS POPULAR,-- 畅销品
	B.ITEM_ID AS NEW,	-- 新品
	A.LARGE_CATE_CODE,  -- 大类
	A.SMALL_CATE_CODE,	-- 类别
	A.ITEM_CODE,		-- 货号
	A.ITEM_NAME,		-- 名称
	A.BRAND_NAME,		-- 品牌
	0 AS SUB_COMPANY_CODE,	-- 分公司编号
	0 AS SUB_COMPANY_NAME,	-- 分公司
	A.CUSTOM_CODE,		-- 自编码
	A.SMALL_CATE_NAME,	-- 小类名称
	A.ITEM_STATUS_NAME,	-- 状态
	A.MATERIAL_NAME,	-- 材质
	A.SUP_NAME,		-- 供应商
	A.SUP_ITEM_CODE,	-- 供应商货号
	A.SALE_PRICE,		-- 零售价
	A.CREATE_DATE,		-- 创建时间
	A.SEASON_NAME,		-- 季节
	A.ATTRI_COMEDATE,	-- 上市时间
	A.CONSUM_OBJECT_NAME,	-- 消费对象
	A.SERIES_NAME,		-- 系列
	A.SPEC,			-- 规格
	G.CREATE_DATE as RECENT_SALE_DATE,
	J.PROFIT,			-- 毛利
	J.ORGI_PROFIT,
	E.STORE_NUM,		-- 动销店铺数
	K.SUM_AMOUNT as SHOP_AMOUNT,  -- 店铺库存
	L.SUM_AMOUNT as STOR_AMOUNT,  -- 虚拟仓库存
	M.ROUTE_AMOUNT,               -- 可用库存
	T.ROUTE_AMOUNT as GJ_ROUTE_AMOUNT,                -- 国际仓
	U.ROUTE_AMOUNT as YW_ROUTE_AMOUNT,               -- 义乌仓
	V.ROUTE_AMOUNT as HB_ROUTE_AMOUNT,               -- 华北仓
	W.ROUTE_AMOUNT as DG_ROUTE_AMOUNT,               -- 东莞仓
	N.STORE_NUM  ,                 -- 库存店铺数
	J.REAL_AMOUNT, -- 周销售额
	O.REAL_QTY as ON_QTY,
	O.SHOP_NUM as ON_SHOP_NUM,
	P.REAL_QTY as NO_QTY,
	Q.REAL_QTY as UN_QTY,
	A.FIRST_IN_DATE,	-- 首次入仓蜀将
	A.LAST_IN_DATE,		-- 最近到总仓时间
	R.SUM_QTY as FLOW_QTY,
	S.SUM_QTY as ACM_FLOW_QTY,
	left(X.DDATE19,10) as DDATE_1,
	X.REAL_QTY_19 as REAL_QTY_1,
	X.REAL_AMOUNT_19 as REAL_AMOUNT_1,
	left(X.DDATE20,10) as DDATE_2,
	X.REAL_QTY_20 as REAL_QTY_2,
	X.REAL_AMOUNT_20 as REAL_AMOUNT_2,
	left(X.DDATE21,10) as DDATE_3,
	X.REAL_QTY_21 as REAL_QTY_3,
	X.REAL_AMOUNT_21 as REAL_AMOUNT_3,
	left(X.DDATE22,10) as DDATE_4,
	X.REAL_QTY_22 as REAL_QTY_4,
	X.REAL_AMOUNT_22 as REAL_AMOUNT_4,
	left(X.DDATE23,10) as DDATE_5,
	X.REAL_QTY_23 as REAL_QTY_5,
	X.REAL_AMOUNT_23 as REAL_AMOUNT_5,
	left(X.DDATE24,10) as DDATE_6,
	X.REAL_QTY_24 as REAL_QTY_6,
	X.REAL_AMOUNT_24 as REAL_AMOUNT_6,
	left(X.DDATE25,10) as DDATE_7,
	X.REAL_QTY_25 as REAL_QTY_7,
	X.REAL_AMOUNT_25 as REAL_AMOUNT_7,
	left(X.DDATE26,10) as DDATE_8,
	X.REAL_QTY_26 as REAL_QTY_8,
	X.REAL_AMOUNT_26 as REAL_AMOUNT_8,
	left(AF.DDATE8,10) as DDATE_9,
	AF.REAL_QTY_8 as REAL_QTY_9,
	AF.REAL_AMOUNT_8 as REAL_AMOUNT_9,
	left(AF.DDATE9,10) as DDATE_10,
	AF.REAL_QTY_9 as REAL_QTY_10,
	AF.REAL_AMOUNT_9 as REAL_AMOUNT_10,
	left(AF.DDATE10,10) as DDATE_11,
	AF.REAL_QTY_10 as REAL_QTY_11,
	AF.REAL_AMOUNT_10 as REAL_AMOUNT_11,
	left(AF.DDATE11,10) as DDATE_12,
	AF.REAL_QTY_11 as REAL_QTY_12,
	AF.REAL_AMOUNT_11 as REAL_AMOUNT_12,
	left(AF.DDATE12,10) as DDATE_13,
	AF.REAL_QTY_12 as REAL_QTY_13,
	AF.REAL_AMOUNT_12 as REAL_AMOUNT_13,
	left(AF.DDATE13,10) as DDATE_14,
	AF.REAL_QTY_13 as REAL_QTY_14,
	AF.REAL_AMOUNT_13 as REAL_AMOUNT_14,
	left(AF.DDATE14,10) as DDATE_15,
	AF.REAL_QTY_14 as REAL_QTY_15,
	AF.REAL_AMOUNT_14 as REAL_AMOUNT_15,
	AM.REAL_AMOUNT as SUM_AMOUNT,
	greatest(X.REAL_QTY_19,X.REAL_QTY_20,X.REAL_QTY_21,X.REAL_QTY_22,X.REAL_QTY_23,X.REAL_QTY_24,X.REAL_QTY_25,X.REAL_QTY_26) as REAL_QTY_MAX,
	greatest(X.REAL_AMOUNT_19,X.REAL_AMOUNT_20,X.REAL_AMOUNT_21,X.REAL_AMOUNT_22,X.REAL_AMOUNT_23,X.REAL_AMOUNT_24,X.REAL_AMOUNT_25,X.REAL_AMOUNT_26) as REAL_AMOUNT_MAX
	
FROM
	-- 基本内容
	(SELECT    
		A.ITEM_ID,		-- ID
		A.LARGE_CATE_CODE,  -- 大类
		A.SMALL_CATE_CODE,	-- 类别
		A.SMALL_CATE_NAME,	-- 小类名称
		A.ITEM_CODE,		-- 货号
		A.ITEM_NAME,		-- 名称
		A.BRAND_NAME,		-- 品牌
		A.CUSTOM_CODE,		-- 自编码
		A.ITEM_STATUS_NAME,	-- 状态
		A.MATERIAL_NAME,	-- 材质
		A.SUP_NAME,		-- 供应商
		A.SUP_ITEM_CODE,	-- 供应商货号
		A.SALE_PRICE,		-- 零售价
		A.CREATE_DATE,		-- 创建时间
		A.SEASON_NAME,		-- 季节
		A.ATTRI_COMEDATE,	-- 上市时间
		A.CONSUM_OBJECT_NAME,	-- 消费对象
		A.SERIES_NAME,		-- 系列
		A.SPEC,			-- 规格
		A.FIRST_IN_DATE,	-- 首次入仓蜀将
		A.LAST_IN_DATE		-- 最近到总仓时间
	FROM
		DIM_ITEM_INFO_ALL A,
		FACT_SALE_BRAND_WEEK H
	WHERE 
		A.ITEM_ID = H.ITEM_ID
	AND 
		H.WEEK_ALL ='${ddate}'
	AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	AND (H.CURRENCY = '${currency}' ${IF(currency='人民币',"OR H.CURRENCY IS NULL","")})
	${if(len(brand)=0,""," AND H.BRAND_NAME ='"+brand+"'")}
	${if(len(ITEM)=0,""," AND H.ITEM_ID IN ('"+ITEM+"')")}
	${if(len(large_cate)=0,""," AND A.LARGE_CATE_CODE in('"+large_cate+"')")}
	${if(len(regular)=0,""," AND A.REGULAR_CODE in('"+regular+"')")}
	union  
     select  
		A.ITEM_ID,		-- ID
		A.LARGE_CATE_CODE,  -- 大类
		A.SMALL_CATE_CODE,	-- 类别
		A.SMALL_CATE_NAME,	-- 小类名称
		A.ITEM_CODE,		-- 货号
		A.ITEM_NAME,		-- 名称
		A.BRAND_NAME,		-- 品牌
		A.CUSTOM_CODE,		-- 自编码
		A.ITEM_STATUS_NAME,	-- 状态
		A.MATERIAL_NAME,	-- 材质
		A.SUP_NAME,		-- 供应商
		A.SUP_ITEM_CODE,	-- 供应商货号
		A.SALE_PRICE,		-- 零售价
		A.CREATE_DATE,		-- 创建时间
		A.SEASON_NAME,		-- 季节
		A.ATTRI_COMEDATE,	-- 上市时间
		A.CONSUM_OBJECT_NAME,	-- 消费对象
		A.SERIES_NAME,		-- 系列
		A.SPEC,			-- 规格
		A.FIRST_IN_DATE,	-- 首次入仓蜀将
		A.LAST_IN_DATE		-- 最近到总仓时间
	from 
		DIM_ITEM_INFO_ALL  as A,FACT_STOCK_GENERAL as B
	WHERE 
	(A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	and B.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
	${if(len(large_cate)=0,""," AND A.LARGE_CATE_CODE in ('"+large_cate+"')")}
	${if(len(regular)=0,""," AND A.REGULAR_CODE in ('"+regular+"')")}
	${if(len(brand)=0,""," AND A.BRAND_NAME ='"+brand+"'")}
	and (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
	${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
	and A.ITEM_ID=B.ITEM_ID
	union 
	select 
		A.ITEM_ID,		-- ID
		A.LARGE_CATE_CODE,  -- 大类
		A.SMALL_CATE_CODE,	-- 类别
		A.SMALL_CATE_NAME,	-- 小类名称
		A.ITEM_CODE,		-- 货号
		A.ITEM_NAME,		-- 名称
		A.BRAND_NAME,		-- 品牌
		A.CUSTOM_CODE,		-- 自编码
		A.ITEM_STATUS_NAME,	-- 状态
		A.MATERIAL_NAME,	-- 材质
		A.SUP_NAME,		-- 供应商
		A.SUP_ITEM_CODE,	-- 供应商货号
		A.SALE_PRICE,		-- 零售价
		A.CREATE_DATE,		-- 创建时间
		A.SEASON_NAME,		-- 季节
		A.ATTRI_COMEDATE,	-- 上市时间
		A.CONSUM_OBJECT_NAME,	-- 消费对象
		A.SERIES_NAME,		-- 系列
		A.SPEC,			-- 规格
		A.FIRST_IN_DATE,	-- 首次入仓蜀将
		A.LAST_IN_DATE		-- 最近到总仓时间
	from 
		DIM_ITEM_INFO_ALL  as A,VBI_STOCK_STOR B,VBI_ORG C, VBI_STORAGE D
	WHERE 
	(A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	and B.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
	${if(len(large_cate)=0,""," AND A.LARGE_CATE_CODE in ('"+large_cate+"')")}
	${if(len(regular)=0,""," AND A.REGULAR_CODE in ('"+regular+"')")}
	${if(len(brand)=0,""," AND A.BRAND_NAME ='"+brand+"'")}
	and (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
	${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
	AND C.ORG_NAME NOT LIKE "%加盟%"
	and A.ITEM_ID=B.ITEM_ID
	and B.TARGET_TYPE = 0
	${if(len(SUB_COMPANY_NAME)=0,""," AND C.ORG_NAME = '"+SUB_COMPANY_NAME+"'")}
	and B.STORAGE_ID = D.STORAGE_ID
	and B.TARGET_ID = C.ORG_ID
     union 
	select  
		A.ITEM_ID,		-- ID
		A.LARGE_CATE_CODE,  -- 大类
		A.SMALL_CATE_CODE,	-- 类别
		A.SMALL_CATE_NAME,	-- 小类名称
		A.ITEM_CODE,		-- 货号
		A.ITEM_NAME,		-- 名称
		A.BRAND_NAME,		-- 品牌
		A.CUSTOM_CODE,		-- 自编码
		A.ITEM_STATUS_NAME,	-- 状态
		A.MATERIAL_NAME,	-- 材质
		A.SUP_NAME,		-- 供应商
		A.SUP_ITEM_CODE,	-- 供应商货号
		A.SALE_PRICE,		-- 零售价
		A.CREATE_DATE,		-- 创建时间
		A.SEASON_NAME,		-- 季节
		A.ATTRI_COMEDATE,	-- 上市时间
		A.CONSUM_OBJECT_NAME,	-- 消费对象
		A.SERIES_NAME,		-- 系列
		A.SPEC,			-- 规格
		A.FIRST_IN_DATE,	-- 首次入仓蜀将
		A.LAST_IN_DATE		-- 最近到总仓时间
	from 
		DIM_ITEM_INFO_ALL  as A,FACT_STOCK_BRAND_ITEM as B
	WHERE 
	(A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	and B.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
	${if(len(large_cate)=0,""," AND A.LARGE_CATE_CODE in ('"+large_cate+"')")}
	${if(len(regular)=0,""," AND A.REGULAR_CODE in ('"+regular+"')")}
	${if(len(brand)=0,""," AND A.BRAND_NAME ='"+brand+"'")}
	${if(len(SUB_COMPANY_NAME)=0,"","AND B.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
	and (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
	${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
	and A.ITEM_ID=B.ITEM_ID
	union 
	SELECT
		 distinct 
		b.ITEM_ID,		-- ID
		b.LARGE_CATE_CODE,  -- 大类
		b.SMALL_CATE_CODE,	-- 类别
		b.SMALL_CATE_NAME,	-- 小类名称
		b.ITEM_CODE,		-- 货号
		b.ITEM_NAME,		-- 名称
		b.BRAND_NAME,		-- 品牌
		b.CUSTOM_CODE,		-- 自编码
		b.ITEM_STATUS_NAME,	-- 状态
		b.MATERIAL_NAME,	-- 材质
		b.SUP_NAME,		-- 供应商
		b.SUP_ITEM_CODE,	-- 供应商货号
		b.SALE_PRICE,		-- 零售价
		b.CREATE_DATE,		-- 创建时间
		b.SEASON_NAME,		-- 季节
		b.ATTRI_COMEDATE,	-- 上市时间
		b.CONSUM_OBJECT_NAME,	-- 消费对象
		b.SERIES_NAME,		-- 系列
		b.SPEC,			-- 规格
		b.FIRST_IN_DATE,	-- 首次入仓蜀将
		b.LAST_IN_DATE		-- 最近到总仓时间
		from VBI_ORGI_NO_ARR as a,DIM_ITEM_INFO_ALL as b    
		where  a.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})
		and a.ITEM_ID=b.ITEM_ID
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,"","AND a.ORG_NAME  = '"+SUB_COMPANY_NAME+"'")}
		${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in ('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND b.REGULAR_CODE in ('"+regular+"')")}
	     union 
	     SELECT
		 distinct 
		c.ITEM_ID,		-- ID
		c.LARGE_CATE_CODE,  -- 大类
		c.SMALL_CATE_CODE,	-- 类别
		c.SMALL_CATE_NAME,	-- 小类名称
		c.ITEM_CODE,		-- 货号
		c.ITEM_NAME,		-- 名称
		c.BRAND_NAME,		-- 品牌
		c.CUSTOM_CODE,		-- 自编码
		c.ITEM_STATUS_NAME,	-- 状态
		c.MATERIAL_NAME,	-- 材质
		c.SUP_NAME,		-- 供应商
		c.SUP_ITEM_CODE,	-- 供应商货号
		c.SALE_PRICE,		-- 零售价
		c.CREATE_DATE,		-- 创建时间
		c.SEASON_NAME,		-- 季节
		c.ATTRI_COMEDATE,	-- 上市时间
		c.CONSUM_OBJECT_NAME,	-- 消费对象
		c.SERIES_NAME,		-- 系列
		c.SPEC,			-- 规格
		c.FIRST_IN_DATE,	-- 首次入仓蜀将
		c.LAST_IN_DATE		-- 最近到总仓时间
		from FACT_ON_PASSAGE_ITEM_SUB as a,DIM_ITEM_INFO_ALL as c    
		where 
		 a.CREATE_DATE = DATE_ADD('2010-12-26',INTERVAL ${ddate} WEEK)
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}  
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (c.CURRENCY = '${currency}' ${IF(currency='人民币',"OR c.CURRENCY IS NULL","")})
		and a.ITEM_ID=c.ITEM_ID
		${if(len(brand)=0,""," AND c.BRAND_NAME ='"+brand+"'")}
	   ${if(len(SUB_COMPANY_NAME)=0,"","AND b.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
		${if(len(large_cate)=0,""," AND c.LARGE_CATE_CODE in ('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND c.REGULAR_CODE in ('"+regular+"')")}
	     union 
	      SELECT 
		c.ITEM_ID,		-- ID
		c.LARGE_CATE_CODE,  -- 大类
		c.SMALL_CATE_CODE,	-- 类别
		c.SMALL_CATE_NAME,	-- 小类名称
		c.ITEM_CODE,		-- 货号
		c.ITEM_NAME,		-- 名称
		c.BRAND_NAME,		-- 品牌
		c.CUSTOM_CODE,		-- 自编码
		c.ITEM_STATUS_NAME,	-- 状态
		c.MATERIAL_NAME,	-- 材质
		c.SUP_NAME,		-- 供应商
		c.SUP_ITEM_CODE,	-- 供应商货号
		c.SALE_PRICE,		-- 零售价
		c.CREATE_DATE,		-- 创建时间
		c.SEASON_NAME,		-- 季节
		c.ATTRI_COMEDATE,	-- 上市时间
		c.CONSUM_OBJECT_NAME,	-- 消费对象
		c.SERIES_NAME,		-- 系列
		c.SPEC,			-- 规格
		c.FIRST_IN_DATE,	-- 首次入仓蜀将
		c.LAST_IN_DATE		-- 最近到总仓时间
		from FACT_UNPREPARE_ITEM_SUB as a,DIM_ITEM_INFO_ALL as c    
		where 
		 a.CREATE_DATE = DATE_ADD('2010-12-26',INTERVAL ${ddate} WEEK)
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,"","AND a.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}  
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (c.CURRENCY = '${currency}' ${IF(currency='人民币',"OR c.CURRENCY IS NULL","")})
		and a.ITEM_ID=c.ITEM_ID
		${if(len(brand)=0,""," AND c.BRAND_NAME ='"+brand+"'")}
		${if(len(large_cate)=0,""," AND c.LARGE_CATE_CODE in ('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND c.REGULAR_CODE in ('"+regular+"')")}
		union 
	     SELECT   
		C.ITEM_ID,		-- ID
		C.LARGE_CATE_CODE,  -- 大类
		C.SMALL_CATE_CODE,	-- 类别
		C.SMALL_CATE_NAME,	-- 小类名称
		C.ITEM_CODE,		-- 货号
		C.ITEM_NAME,		-- 名称
		C.BRAND_NAME,		-- 品牌
		C.CUSTOM_CODE,		-- 自编码
		C.ITEM_STATUS_NAME,	-- 状态
		C.MATERIAL_NAME,	-- 材质
		C.SUP_NAME,		-- 供应商
		C.SUP_ITEM_CODE,	-- 供应商货号
		C.SALE_PRICE,		-- 零售价
		C.CREATE_DATE,		-- 创建时间
		C.SEASON_NAME,		-- 季节
		C.ATTRI_COMEDATE,	-- 上市时间
		C.CONSUM_OBJECT_NAME,	-- 消费对象
		C.SERIES_NAME,		-- 系列
		C.SPEC,			-- 规格
		C.FIRST_IN_DATE,	-- 首次入仓蜀将
		C.LAST_IN_DATE		-- 最近到总仓时间
		FROM FACT_IT_FLOW_WEEK A,DIM_ITEM_INFO_ALL as C
		WHERE A.WEEK_ALL='${ddate}'
		AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	
      	and A.ITEM_ID=C.ITEM_ID		
		AND (C.CURRENCY = '${currency}' ${IF(currency='人民币',"OR C.CURRENCY IS NULL","")})
		${if(len(large_cate)=0,""," AND C.LARGE_CATE_CODE in ('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND C.REGULAR_CODE in ('"+regular+"')")}
	     ${if(len(brand)=0,""," AND C.BRAND_NAME ='"+brand+"'")}
	     ${if(len(ITEM)=0,""," AND C.ITEM_ID in ('"+ITEM+"')")}
	
	) A
	-- 新品信息
	LEFT JOIN (select a.ITEM_ID 
		FROM DIM_ITEM_NEW as a,DIM_ITEM_INFO_ALL as b
		WHERE a.WEEK_ALL = '${ddate}'
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		and a.ITEM_ID=b.ITEM_ID
		and b.CURRENCY='人民币'
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
	     ${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in('"+large_cate+"')")}
	      ${if(len(regular)=0,""," AND b.REGULAR_CODE in('"+regular+"')")}
	) B ON A.ITEM_ID = B.ITEM_ID
	-- 畅销品信息
	LEFT JOIN (select distinct a.ITEM_ID 
		FROM DIM_ITEM_POPULAR as a,DIM_ITEM_INFO_ALL as b
		WHERE a.WEEK_ALL = '${ddate}'
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		and a.ITEM_ID=b.ITEM_ID
		and b.CURRENCY='人民币'
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
	     ${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in('"+large_cate+"')")}
	      ${if(len(regular)=0,""," AND b.REGULAR_CODE in('"+regular+"')")}	)C
	      ON A.ITEM_ID = C.ITEM_ID
	
	-- 动销店铺数	
	LEFT JOIN (SELECT A.ITEM_ID,
		SUM(A.SHOP_NUM) as STORE_NUM
		FROM DIM_CROSS_SHOP_NUMBER as A,DIM_ITEM_INFO_ALL as B
		WHERE A.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		 AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
		AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
		${if(len(brand)=0,""," AND A.BRAND_NAME ='"+brand+"'")}
		${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
		${if(len(large_cate)=0,""," AND B.LARGE_CATE_CODE in('"+large_cate+"')")}
	    ${if(len(regular)=0,""," AND B.REGULAR_CODE in('"+regular+"')")}
		and A.ITEM_ID=B.ITEM_ID
		GROUP BY A.ITEM_ID
	) E ON A.ITEM_ID = E.ITEM_ID
	
	LEFT JOIN VBI_SALE_RECENT_DATE G ON A.ITEM_ID = G.ITEM_ID
	LEFT join 
	(
     SELECT
		H.ITEM_ID,		-- ID
		1-SUM(H.TRANS_AMOUNT)/SUM(H.REAL_AMOUNT) as PROFIT,
		1-SUM(H.TRANS_AMOUNT)/SUM(H.ORGI_AMOUNT) as ORGI_PROFIT,
		SUM(H.REAL_AMOUNT)/SUM(H.ORGI_AMOUNT) as DISCOUNT,
		SUM(REAL_QTY) as REAL_AMOUNT
	
	FROM
		DIM_ITEM_INFO_ALL A,
		FACT_SALE_BRAND_WEEK H
	WHERE 
		A.ITEM_ID = H.ITEM_ID
	AND 
		H.WEEK_ALL ='${ddate}'
	AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	AND (H.CURRENCY = '${currency}' ${IF(currency='人民币',"OR H.CURRENCY IS NULL","")})
	${if(len(brand)=0,""," AND H.BRAND_NAME ='"+brand+"'")}
	${if(len(ITEM)=0,""," AND H.ITEM_ID IN ('"+ITEM+"')")}
	${if(len(large_cate)=0,""," AND A.LARGE_CATE_CODE in('"+large_cate+"')")}
	${if(len(regular)=0,""," AND A.REGULAR_CODE in('"+regular+"')")}
	GROUP BY H.ITEM_ID
	) as J
	on A.ITEM_ID=J.ITEM_ID
	left join 
		(SELECT 
			A.ITEM_ID,
			SUM(A.STOCK_QTY) AS SUM_AMOUNT
		FROM FACT_STOCK_BRAND_ITEM as A,DIM_ITEM_INFO_ALL as B
		
		WHERE A.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
		${if(len(brand)=0,""," AND A.BRAND_NAME ='"+brand+"'")}
		${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
		 ${if(len(large_cate)=0,""," AND B.LARGE_CATE_CODE in('"+large_cate+"')")}
	      ${if(len(regular)=0,""," AND B.REGULAR_CODE in('"+regular+"')")}
	      and A.ITEM_ID=B.ITEM_ID
	     AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
		GROUP BY A.ITEM_ID
		) as K on A.ITEM_ID=K.ITEM_ID
	left join
		(SELECT
			D.ITEM_ID,
			SUM(D.SUM_STOCK_QTY) AS SUM_AMOUNT
		FROM DIM_ITEM_INFO_ALL C,
			(select 
				(A.STOCK_QTY+A.LIEN_QTY+IFNULL(A.SUB_STOCK_QTY,0)) AS SUM_STOCK_QTY,
				B.ORG_NAME,
				A.ITEM_ID,
				E.BRAND_NAME
			FROM VBI_STOCK_STOR A,VBI_ORG B, VBI_STORAGE E
			WHERE A.TARGET_TYPE = 0
			AND A.TARGET_ID = B.ORG_ID
			AND A.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
			AND B.ORG_NAME NOT LIKE "%加盟%"
			AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
			${if(len(SUB_COMPANY_NAME)=0,""," AND B.ORG_NAME = '"+SUB_COMPANY_NAME+"'")}
			${if(len(brand)=0,""," AND E.BRAND_NAME ='"+brand+"'")}
			${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
			AND A.STORAGE_ID = E.STORAGE_ID) D
		WHERE D.ITEM_ID = C.ITEM_ID
		AND (C.CURRENCY = '${currency}' ${IF(currency='人民币',"OR C.CURRENCY IS NULL","")})
		GROUP BY D.ITEM_ID) as L on A.ITEM_ID=L.ITEM_ID
	left join 
		(SELECT 
			A.ITEM_ID,
			A.ROUTE_QTY as ROUTE_AMOUNT
		FROM FACT_STOCK_GENERAL as A,DIM_ITEM_INFO_ALL as B
		WHERE A.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
		${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
		${if(len(large_cate)=0,""," AND B.LARGE_CATE_CODE in('"+large_cate+"')")}
	      ${if(len(regular)=0,""," AND B.REGULAR_CODE in('"+regular+"')")}
	      and A.ITEM_ID=B.ITEM_ID
	     AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
		) as M on A.ITEM_ID=M.ITEM_ID
	left join
	(SELECT 
		A.ITEM_ID,
		SUM(A.SHOP_NUMBER) AS STORE_NUM
	FROM FACT_STOCK_SUB_ITEM_SHOP_NUMBER as A,DIM_ITEM_INFO_ALL as B
	WHERE A.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
	AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	${if(len(brand)=0,""," AND A.BRAND_NAME ='"+brand+"'")}
	${if(len(SUB_COMPANY_NAME)=0,"","AND A.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
	${if(len(ITEM)=0,""," AND A.ITEM_ID IN ('"+ITEM+"')")}
	${if(len(large_cate)=0,""," AND B.LARGE_CATE_CODE in('"+large_cate+"')")}
	${if(len(regular)=0,""," AND B.REGULAR_CODE in('"+regular+"')")}
	and A.ITEM_ID=B.ITEM_ID
	AND (B.CURRENCY = '${currency}' ${IF(currency='人民币',"OR B.CURRENCY IS NULL","")})
	GROUP BY A.ITEM_ID
	) as N on A.ITEM_ID=N.ITEM_ID
left join 
(
select 
			a.ITEM_ID,
			sum(a.REAL_QTY) as REAL_QTY,
			a.SHOP_NUM
		from FACT_ON_PASSAGE_ITEM_SUB as a,DIM_ITEM_INFO_ALL as c     
		where  a.CREATE_DATE = DATE_ADD('2010-12-26',INTERVAL ${ddate} WEEK)
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(brand)=0,""," AND c.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,"","AND a.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (c.CURRENCY = '${currency}' ${IF(currency='人民币',"OR c.CURRENCY IS NULL","")})
		and a.item_id=c.item_id
		${if(len(large_cate)=0,""," AND c.LARGE_CATE_CODE in('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND c.REGULAR_CODE in('"+regular+"')")}
		group by a.ITEM_ID
) as O
on A.ITEM_ID=O.ITEM_ID
left join
(
select 
			a.ITEM_ID,
			sum(a.REAL_QTY) as REAL_QTY
		from VBI_ORGI_NO_ARR as a,DIM_ITEM_INFO_ALL as b    
		where  a.CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})
		and a.ITEM_ID=b.ITEM_ID
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,"","AND a.ORG_NAME  = '"+SUB_COMPANY_NAME+"'")}
		${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in ('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND b.REGULAR_CODE in ('"+regular+"')")}
		group by a.ITEM_ID
) as P
on A.ITEM_ID=P.ITEM_ID
left join
(
select 
			a.ITEM_ID,
			sum(a.REAL_QTY) as REAL_QTY
		from FACT_UNPREPARE_ITEM_SUB as a,DIM_ITEM_INFO_ALL as c     
		where  a.CREATE_DATE = DATE_ADD('2010-12-26',INTERVAL ${ddate} WEEK)
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(brand)=0,""," AND c.BRAND_NAME ='"+brand+"'")}
	${if(len(SUB_COMPANY_NAME)=0,"","AND a.SUB_COMPANY_NAME  = '"+SUB_COMPANY_NAME+"'")}
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (c.CURRENCY = '${currency}' ${IF(currency='人民币',"OR c.CURRENCY IS NULL","")})
		and a.item_id=c.item_id
		${if(len(large_cate)=0,""," AND c.LARGE_CATE_CODE in('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND c.REGULAR_CODE in('"+regular+"')")}
		group by a.ITEM_ID
) as Q on A.ITEM_ID=Q.ITEM_ID
left join
(
SELECT 
			A.ITEM_ID,
			SUM(A.REAL_QTY) AS SUM_QTY,
			SUM(A.REAL_QTY*C.SALE_PRICE) AS SUM_AMOUNT
			FROM FACT_IT_FLOW_WEEK A,DIM_ITEM_INFO_ALL as C
			WHERE A.WEEK_ALL='${ddate}'
		AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
		AND (C.CURRENCY = '${currency}' ${IF(currency='人民币',"OR C.CURRENCY IS NULL","")})
			
			and A.ITEM_ID=C.ITEM_ID
			${if(len(ITEM)=0,""," AND C.ITEM_ID IN ('"+ITEM+"')")}
			${if(len(large_cate)=0,""," AND C.LARGE_CATE_CODE in('"+large_cate+"')")}
	          ${if(len(regular)=0,""," AND C.REGULAR_CODE in('"+regular+"')")} 
			 GROUP BY A.ITEM_ID
) as R on A.ITEM_ID=R.ITEM_ID
left join 
(
SELECT 
			A.ITEM_ID,
			SUM(A.REAL_QTY) AS SUM_QTY,
			SUM(A.REAL_QTY*C.SALE_PRICE) AS SUM_AMOUNT
			FROM FACT_IT_FLOW_WEEK_ALL A,DIM_ITEM_INFO_ALL as C
			WHERE 
          (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
		AND (C.CURRENCY = '${currency}' ${IF(currency='人民币',"OR C.CURRENCY IS NULL","")})
			and A.ITEM_ID=C.ITEM_ID
			${if(len(ITEM)=0,""," AND C.ITEM_ID IN ('"+ITEM+"')")}
			${if(len(large_cate)=0,""," AND C.LARGE_CATE_CODE in('"+large_cate+"')")}
	          ${if(len(regular)=0,""," AND C.REGULAR_CODE in('"+regular+"')")} 
			 GROUP BY A.ITEM_ID
) as S on A.ITEM_ID=S.ITEM_ID
left join 
		(SELECT 
			ITEM_ID,
			ROUTE_QTY as ROUTE_AMOUNT
		FROM FACT_STOCK_GENERAL_TYPE
		WHERE CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
		${if(len(ITEM)=0,""," AND ITEM_ID IN ('"+ITEM+"')")}
		and STORAGE_TYPE='国际仓' 
		) as T on A.ITEM_ID=T.ITEM_ID
left join 
		(SELECT 
			ITEM_ID,
			ROUTE_QTY as ROUTE_AMOUNT
		FROM FACT_STOCK_GENERAL_TYPE
		WHERE CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
		${if(len(ITEM)=0,""," AND ITEM_ID IN ('"+ITEM+"')")}
		and STORAGE_TYPE='义乌仓' 
		) as U on A.ITEM_ID=U.ITEM_ID
		left join 
		(SELECT 
			ITEM_ID,
			ROUTE_QTY as ROUTE_AMOUNT
		FROM FACT_STOCK_GENERAL_TYPE
		WHERE CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
		${if(len(ITEM)=0,""," AND ITEM_ID IN ('"+ITEM+"')")}
		and STORAGE_TYPE='华北仓' 
		) as V on A.ITEM_ID=V.ITEM_ID
		left join 
		(SELECT 
			ITEM_ID,
			ROUTE_QTY as ROUTE_AMOUNT
		FROM FACT_STOCK_GENERAL_TYPE
		WHERE CREATE_DATE = DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND (CURRENCY = '${currency}' ${IF(currency='人民币',"OR CURRENCY IS NULL","")})
		${if(len(ITEM)=0,""," AND ITEM_ID IN ('"+ITEM+"')")}
		and STORAGE_TYPE='东莞仓' 
		) as W on A.ITEM_ID=W.ITEM_ID
		left join
		(
		SELECT a.ITEM_ID,
        DATE_FORMAT(DATE_SUB(a.DDATE_19,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE19,
       SUM(a.REAL_AMOUNT_19) AS REAL_AMOUNT_19,
        SUM(a.REAL_QTY_19) AS REAL_QTY_19,
        DATE_FORMAT(DATE_SUB(a.DDATE_20,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE20,
       SUM(a.REAL_AMOUNT_20) AS REAL_AMOUNT_20,
        SUM(a.REAL_QTY_20) AS REAL_QTY_20,
        DATE_FORMAT(DATE_SUB(a.DDATE_21,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE21,
       SUM(a.REAL_AMOUNT_21) AS REAL_AMOUNT_21,
        SUM(a.REAL_QTY_21) AS REAL_QTY_21,
        DATE_FORMAT(DATE_SUB(a.DDATE_22,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE22,
       SUM(a.REAL_AMOUNT_22) AS REAL_AMOUNT_22,
        SUM(a.REAL_QTY_22) AS REAL_QTY_22,
        DATE_FORMAT(DATE_SUB(a.DDATE_23,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE23,
       SUM(a.REAL_AMOUNT_23) AS REAL_AMOUNT_23,
        SUM(a.REAL_QTY_23) AS REAL_QTY_23,
        DATE_FORMAT(DATE_SUB(a.DDATE_24,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE24,
       SUM(a.REAL_AMOUNT_24) AS REAL_AMOUNT_24,
        SUM(a.REAL_QTY_24) AS REAL_QTY_24,
        DATE_FORMAT(DATE_SUB(a.DDATE_25,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE25,
       SUM(a.REAL_AMOUNT_25) AS REAL_AMOUNT_25,
        SUM(a.REAL_QTY_25) AS REAL_QTY_25,
        DATE_FORMAT(DATE_SUB(a.DDATE_26,INTERVAL 6 DAY),'%Y-%m-%d')  AS DDATE26,
       SUM(a.REAL_AMOUNT_26) AS REAL_AMOUNT_26,
        SUM(a.REAL_QTY_26) AS REAL_QTY_26
		FROM FACT_SALE_BRAND_WEEK_LONG as a,DIM_ITEM_INFO_ALL as b
		WHERE a.WEEK_ALL = ${ddate}
	AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})	
	AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})	
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
		and a.ITEM_ID=b.ITEM_ID
		${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND b.REGULAR_CODE in('"+regular+"')")}
		GROUP BY a.ITEM_ID
		) as X 
		on A.ITEM_ID=X.ITEM_ID
		left join
		(
		SELECT    a.ITEM_ID,
        DATE_FORMAT(DATE_SUB(a.DDATE_8,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE8,
       SUM(a.REAL_AMOUNT_8) AS REAL_AMOUNT_8,
        SUM(a.REAL_QTY_8) AS REAL_QTY_8,
        DATE_FORMAT(DATE_SUB(a.DDATE_9,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE9,
       SUM(a.REAL_AMOUNT_9) AS REAL_AMOUNT_9,
        SUM(a.REAL_QTY_9) AS REAL_QTY_9,
        DATE_FORMAT(DATE_SUB(a.DDATE_10,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE10,
       SUM(a.REAL_AMOUNT_10) AS REAL_AMOUNT_10,
        SUM(a.REAL_QTY_10) AS REAL_QTY_10,
        DATE_FORMAT(DATE_SUB(a.DDATE_11,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE11,
       SUM(a.REAL_AMOUNT_11) AS REAL_AMOUNT_11,
        SUM(a.REAL_QTY_11) AS REAL_QTY_11,
        DATE_FORMAT(DATE_SUB(a.DDATE_12,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE12,
       SUM(a.REAL_AMOUNT_12) AS REAL_AMOUNT_12,
        SUM(a.REAL_QTY_12) AS REAL_QTY_12,
        DATE_FORMAT(DATE_SUB(a.DDATE_13,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE13,
       SUM(a.REAL_AMOUNT_13) AS REAL_AMOUNT_13,
        SUM(a.REAL_QTY_13) AS REAL_QTY_13,
        DATE_FORMAT(DATE_SUB(a.DDATE_14,INTERVAL 0 DAY),'%Y-%m-%d')  AS DDATE14,
       SUM(a.REAL_AMOUNT_14) AS REAL_AMOUNT_14,
        SUM(a.REAL_QTY_14) AS REAL_QTY_14
		FROM FACT_CROSS_SALE_BRAND_LONG as a,DIM_ITEM_INFO_ALL as b
		WHERE 
		a.WEEK_ALL='${ddate}'
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
         	${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		and a.ITEM_ID=b.ITEM_ID
		AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})
		${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND b.REGULAR_CODE in('"+regular+"')")}
		GROUP BY a.ITEM_ID
		) as AF 
		on A.ITEM_ID=AF.ITEM_ID
	
		left join 
	(
     SELECT
		A.ITEM_ID,		
		SUM(H.REAL_AMOUNT) as REAL_AMOUNT
	FROM
		DIM_ITEM_INFO_ALL A inner join
		FACT_SALE_BRAND_HALF H
	on 
		A.ITEM_ID = H.ITEM_ID
	where  
		H.WEEK_ALL ='${ddate}'
	AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
	AND (H.CURRENCY = '${currency}' ${IF(currency='人民币',"OR H.CURRENCY IS NULL","")})
	${if(len(brand)=0,""," AND H.BRAND_NAME ='"+brand+"'")}
	${if(len(ITEM)=0,""," AND H.ITEM_ID IN ('"+ITEM+"')")}
	${if(len(large_cate)=0,""," AND A.LARGE_CATE_CODE in('"+large_cate+"')")}
	${if(len(regular)=0,""," AND A.REGULAR_CODE in('"+regular+"')")}
	GROUP BY A.ITEM_ID
	) as AM
	on A.ITEM_ID=AM.ITEM_ID
		

select * from (
select distinct 
         c.large_cate_code,
         concat(c.large_cate_code,c.large_cate_name) as large_cate_name 
      from 
        FILL_USER_POST as a,
        finedb.FR_T_USER as b,
        DIM_ITEM as c
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST not in('买手','买手助理','大买手','商品AD')
      union 
      select distinct 
         d.large_cate_code,
         concat(d.large_cate_code,d.large_cate_name) as large_cate_name  
      from 
        FILL_USER_POST as a,
        finedb.FR_T_USER as b,
        DIM_SMALL_BUYER as c,
        DIM_ITEM as d
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST in('买手','买手助理')
      and c.STAFF_POSITION in ('买手','大买手')
      and b.id=c.BUYER_ID
      and c.small_cate_code=d.small_cate_code
  
      union 
      select distinct 
        d.large_cate_code,
         concat(d.large_cate_code,d.large_cate_name) as large_cate_name 
      from 
        FILL_USER_POST as a,
        finedb.FR_T_USER as b,
        DIM_SMALL_BUYER as c,
        DIM_ITEM as d
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST ='商品AD'
      and c.STAFF_POSITION ='商品AD'
      and b.id=c.BUYER_ID
      and c.small_cate_code=d.small_cate_code
) as a where large_cate_code in 
(
select distinct 
  large_cate_code
from 
DIM_ITEM_INFO_ALL 
where BRAND_NAME='${brand}'
)


-- 大类维度

select * from (
select distinct 
         c.REGULAR_CODE,
         concat(c.REGULAR_CODE,c.REGULAR_NAME) as REGULAR_NAME 
      from 
        FILL_USER_POST as a,
        finedb.FR_T_USER as b,
        DIM_ITEM as c
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST not in('买手','买手助理','大买手','商品AD')
      union 
      select distinct 
        d.REGULAR_CODE,
        concat(d.REGULAR_CODE,d.REGULAR_NAME) as REGULAR_NAME   
      from 
        FILL_USER_POST as a,
        finedb.FR_T_USER as b,
        DIM_SMALL_BUYER as c,
        DIM_ITEM as d
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST in('买手','买手助理')
      and c.STAFF_POSITION in ('买手','大买手')
      and b.id=c.BUYER_ID
      and c.small_cate_code=d.small_cate_code
 
      union 
      select distinct 
        d.REGULAR_CODE,
        concat(d.REGULAR_CODE,d.REGULAR_NAME) as REGULAR_NAME  
      from 
        FILL_USER_POST as a,
        finedb.FR_T_USER as b,
        DIM_SMALL_BUYER as c,
        DIM_ITEM as d
      where 
      b.ID=a.USER_ID 
      and b.username='${fr_username}'
      and a.POST ='商品AD'
      and c.STAFF_POSITION ='商品AD'
      and b.id=c.BUYER_ID
      and c.small_cate_code=d.small_cate_code
) as a where REGULAR_CODE in 
(
select distinct 
  REGULAR_CODE
from 
DIM_ITEM_INFO_ALL 
WHERE 1=1
${if(len(large_cate)=0,""," AND LARGE_CATE_CODE in('"+large_cate+"')")}
${if(len(brand)=0,""," AND BRAND_NAME in('"+brand+"')")}
)

-- 规整类维度（大类下规整类别）

SELECT DISTINCT CURRENCY FROM VBI_CURRENCY


SELECT 
			A.ITEM_ID,
			SUM(A.REAL_QTY) AS SUM_QTY,
			SUM(A.REAL_AMOUNT) AS SUM_AMOUNT
			FROM FACT_ACM_IT_FLOW A,VBI_STORAGE B,DIM_ITEM_INFO_ALL as C
			WHERE 
			 A.STORAGE_ID=B.STORAGE_ID 
		AND (A.CURRENCY = '${currency}' ${IF(currency='人民币',"OR A.CURRENCY IS NULL","")})
		AND (C.CURRENCY = '${currency}' ${IF(currency='人民币',"OR C.CURRENCY IS NULL","")})
			and 
			A.STORAGE_ID 
		in ('10000951','10001038','10000370','10001041','10000007','10000206','10000401','10001264','10001316','10001963')
			and (B.ORG_ID='10000001'  or B.ORG_ID = '10000005')
			and A.ITEM_ID=C.ITEM_ID
			${if(len(ITEM)=0,""," AND C.ITEM_ID IN ('"+ITEM+"')")}
			${if(len(large_cate)=0,""," AND C.LARGE_CATE_CODE in('"+large_cate+"')")}
	          ${if(len(regular)=0,""," AND C.REGULAR_CODE in('"+regular+"')")} 
			 GROUP BY A.ITEM_ID

SELECT a.ITEM_ID,
       DATE_SUB(a.CREATE_DATE,INTERVAL 6 DAY) AS DDATE,
       SUM(a.REAL_AMOUNT) AS REAL_AMOUNT,
        SUM(a.REAL_QTY) AS REAL_QTY
		FROM FACT_SALE_BRAND_WEEK as a,DIM_ITEM_INFO_ALL as b
		WHERE a.WEEK_ALL <= ${ddate}
		AND a.WEEK_ALL > (${ddate}-8)
	AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})	
	AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})	
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		and a.ITEM_ID=b.ITEM_ID
		${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND b.REGULAR_CODE in('"+regular+"')")}
		GROUP BY a.ITEM_ID,a.CREATE_DATE
		order by a.CREATE_DATE asc

SELECT a.ITEM_ID,
       DATE_SUB(a.CREATE_DATE,INTERVAL 6 DAY) AS DDATE,
       SUM(a.REAL_AMOUNT) AS REAL_AMOUNT,
       SUM(a.REAL_QTY) AS REAL_QTY
		FROM FACT_SALE_SUB_WEEK as a,DIM_ITEM_INFO_ALL as b,
			(
		select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}
and SUB_COMPANY_NAME in 
(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
)
		) as d
		WHERE a.WEEK_ALL <= ${ddate}
		AND a.WEEK_ALL > (${ddate}-8)
	AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})	
	AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})	
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,""," AND a.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		and a.ITEM_ID=b.ITEM_ID
		and a.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
		${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND b.REGULAR_CODE in('"+regular+"')")}
		GROUP BY a.ITEM_ID,a.CREATE_DATE
		order by a.CREATE_DATE asc

select c.`name` from finedb.FR_T_Department_Post_User as a,finedb.FR_T_USER as b,finedb.FR_T_DEPARTMENT as c
where a.Userid=b.id and a.Departmentid=c.id
and b.username='${fr_username}'

SELECT a.ITEM_ID,
       DATE_SUB(a.CREATE_DATE,INTERVAL 6 DAY) AS DDATE,
       SUM(a.REAL_AMOUNT) AS REAL_AMOUNT
		FROM FACT_SALE_SUB_WEEK as a,DIM_ITEM_INFO_ALL as b
		WHERE a.WEEK_ALL <= ${ddate}
		AND a.WEEK_ALL > (${ddate}-26)
	AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})	
	AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})	
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
		${if(len(SUB_COMPANY_NAME)=0,""," AND a.SUB_COMPANY_NAME ='"+SUB_COMPANY_NAME+"'")}
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		and a.ITEM_ID=b.ITEM_ID
		${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE ='"+large_cate+"'")}
	     ${if(len(regular)=0,""," AND b.REGULAR_CODE ='"+regular+"'")}
		GROUP BY a.ITEM_ID,a.CREATE_DATE
		order by a.CREATE_DATE asc

SELECT    left(a.CREATE_DATE,10) AS DDATE,a.ITEM_ID,SUM(REAL_QTY) AS REAL_AMOUNT
		FROM FACT_CROSS_SALE_BRAND as a,DIM_ITEM_INFO_ALL as b
		WHERE a.CREATE_DATE <= DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND 
		a.CREATE_DATE >= DATE_SUB(DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK),INTERVAL 6 DAY)
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
		${if(len(ITEM)=0,""," AND ITEM_ID IN ('"+ITEM+"')")}
		and a.ITEM_ID=b.ITEM_ID
		AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})
		${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND b.REGULAR_CODE in('"+regular+"')")}
		GROUP BY a.ITEM_ID,a.CREATE_DATE
		order by a.CREATE_DATE ASC

SELECT a.ITEM_ID,left(a.CREATE_DATE,10) AS DDATE,SUM(a.REAL_QTY) AS REAL_AMOUNT
		FROM FACT_CROSS_SALE_SUB as a,DIM_ITEM_INFO_ALL as b,
				(
		select DISTINCT 
  SUB_COMPANY_NAME 
from DIM_S_SHOP 
WHERE 1=1
${if(len(brand)==0,""," AND BRAND_NAME ='"+brand+"'")}
and SUB_COMPANY_NAME in 
(
  select 
    SUB_COMPANY_NAME 
  from FILL_USER_BRAND as a,finedb.FR_T_USER as b
  where a.USER_ID=b.id and b.username='${fr_username}'
)
		) as d 
		WHERE a.CREATE_DATE <= DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK)
		AND 
		a.CREATE_DATE >= DATE_SUB(DATE_ADD('2010-12-26 00:00:00',INTERVAL ${ddate} WEEK),INTERVAL 6 DAY)
		AND (a.CURRENCY = '${currency}' ${IF(currency='人民币',"OR a.CURRENCY IS NULL","")})
		AND (b.CURRENCY = '${currency}' ${IF(currency='人民币',"OR b.CURRENCY IS NULL","")})
		${if(len(brand)=0,""," AND a.BRAND_NAME ='"+brand+"'")}
		${if(len(sub_company_name)=0,"","AND a.SUB_COMPANY_NAME  = '"+sub_company_name+"'")}
		${if(len(ITEM)=0,""," AND a.ITEM_ID IN ('"+ITEM+"')")}
		and a.ITEM_ID=b.ITEM_ID
		${if(len(large_cate)=0,""," AND b.LARGE_CATE_CODE in('"+large_cate+"')")}
	     ${if(len(regular)=0,""," AND b.REGULAR_CODE in('"+regular+"')")}
	     and a.SUB_COMPANY_NAME=d.SUB_COMPANY_NAME
	     ${if(len(brand)=0,""," AND b.BRAND_NAME ='"+brand+"'")}
		GROUP BY a.ITEM_ID,a.CREATE_DATE

