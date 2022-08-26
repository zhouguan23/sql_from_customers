SELECT
	so.DAYID,
	so.ALIPAY_FLOW 支付宝流水号,
	ifnull(str_to_date(so.TB_CREATE_TIME,'%Y-%m-%d %H:%i:%s'),str_to_date(so.SO_CREATE_TIME,'%Y-%m-%d %H:%i:%s')) 原订单创建时间,
	so.shop_id 店铺ID,
	so.SALES_MODEL 经营模式,
	so.DIRECTION 出入库类型,
	str_to_date(so.OUT_TIME,'%Y-%m-%d %H:%i:%s') 出库时间,
	so.ORDER_ID 订单号,
	so.TB_ORDER_ID TB订单号,
	so.PLATFORM_ID 平台订单号,
	so.ooc_source 原始平台订单号,
	so.BAR_CODE 条形码,
	so.SKU_ID,
	str_to_date(so.TB_PAYMENT_TIME,'%Y-%m-%d %H:%i:%s') 淘宝付款时间,
	so.PAYMENTTYPE 付款方式,
	so.SKU_SIZE sku尺寸,
	so.PRODUCT_ID 商品TD,
	so.PRODUCT_NAME 商品名称,
	CASE WHEN so.Direction IN ( 'r_in', 'chg_in' ) THEN
		0- so.REQUESTED_QTY 
		ELSE so.REQUESTED_QTY END AS 商品购买数量,
	case when so.direction in ('s','chg_out') and so.dayid>='20200716'   then so.line_total 
	     when so.direction in ('r_in','chg_in') and so.dayid>='20200716' then 0 - so.line_total end 行总计,
	so.PRICE 金额,
	case when so.PAYMENTTYPE='货到付款' then 1 else 0 end 是否COD,
	substr(
		so.SKU_KEY_PROPERTIES,
		instr( so.SKU_KEY_PROPERTIES, ',' ) + 1,
		length(so.SKU_KEY_PROPERTIES ) 
	) SKU尺码,
	so.K3_CUSTOMER_CODE 大客户编码,
	so.RETURN_CODE 退货申请编码,
	so.ORDER_SORT 订单类型,
	so.SKU_FOB 商品成本,
	so.SKU_COLOR SKU颜色,
	case when so.line_no = 1 then ifnull(so.ACTUAL_TRANSFER_FEE,0) else 0 end 运费,
	case when so.line_no = 1 then ifnull(bb.affiliated_amount,0) else 0 end 包装费,
	so.K3_CUSTOMER_NAME 大客户名字,
	so.SUPPLIER_SKU_CODE 货号,
    so.TOTAL_POINT_USED 积分,
	so.SKUCODE 商品编码,
	so.JMSKU_CODE 宝尊商品编码,
	so.DISTRICT 区域,
	so.PROVINCE 省份,
	so.CITY 城市,
	so.SKU_COLOR SKU颜色1,
	so.SO_MEMBER_ID,
	so.SKU_EXT_CODE2 外围编码,
	so.SKU_NAME,
	so.SHOP_NAME 店铺名,	
	so.LIST_PRICE 初始吊牌价,
	so.UNIT_PRICE 吊牌价,
	str_to_date(so.CREATE_TIME,'%Y-%m-%d %H:%i:%s') OMS创建时间,
	so.ACTIVITY_SOURCE,
	so.TRANS_CODE 快递单号,
	so.TRANSPORTATOR_NAME 快递公司,
	so.COST_CENTER_CODE 成本中心代码,
	so.WH_NAME 发货仓,
	so.so_line_SALES_MODEL 订单行经营模式,
	so.REF_RH_CODE,
	so.INVOCIE_TYPE,
	CASE WHEN so.DIRECTION = 's' THEN so.TB_ORDER_ID
	ELSE so.RETURN_CODE END 销售退换编码,
	CASE WHEN so.so_line_SALES_MODEL = '0' THEN '付款经销' 
		 WHEN so.so_line_SALES_MODEL = '1' THEN '代销' 
		 WHEN so.so_line_SALES_MODEL = '2' THEN '结算经销' 
		 WHEN so.so_line_SALES_MODEL = '3' THEN '结算经销+代销' 
		 ELSE so.so_line_SALES_MODEL END AS translate_model,
	CASE WHEN so.DIRECTION = 's' THEN '销售出库' 
		WHEN so.DIRECTION = 'r_in' THEN '退货入库' 
		WHEN so.DIRECTION = 'chg_in' THEN '换货入库' 
		WHEN so.DIRECTION = 'chg_out' THEN '换货出库' 
		ELSE so.DIRECTION END AS 出入库类型_trans,
    case when gift.is_gift=1 then 'Y' else 'N' end is_gift,
   so.buyer_memo as 买家备注,
   so.seller_memo as 卖家备注,
   so.inner_product_brand_enname as 内部产品品牌英文名称,
   so.inner_product_brand_name as 内部产品品牌名称 ,
   so.wms_outbound_time as wms出入库时间,
   case when ifnull(so.self_pickup_type,0) =0 then '否' else '是' end  是否自提,
   case when kv_self_pickup_type.option_value is null then '不需要自提' 
        else  kv_self_pickup_type.option_value end as 自提点类型,
  so.size_desc SizeDESCRIPTION,
  so.SN,
  sku.list_price 实际吊牌价
  FROM db_dw.t01_day_order_detail so
  left join db_dw.t01_order_gift gift on gift.order_id= so.order_id
  left join (select so_id,
             sum(affiliated_amount) as affiliated_amount 
             from  db_ods.pac_t_so_platform_sl_packing_info p
             where ifnull(affiliated_amount,0) <> 0
             group by so_id) bb on so.order_id = bb.so_id
  left join db_dw.t00_report_kv_info kv_self_pickup_type 
           on so.self_pickup_type = kv_self_pickup_type.option_key
           and kv_self_pickup_type.group_code = 'common_self_pickup_type'
  left join db_ods.pac_ma_sku_cost sku on so.product_id = sku.id
  WHERE so.SHOP_ID IN ( '${replace(shop_id,",","','")}') 
		AND so.OUT_TIME >='${startTime}'
        and so.OUT_TIME < '${endTime}'
	    ${if(len(DIRECTION) == 0,"","and so.DIRECTION in ('" + replace(DIRECTION,",","','") + "')")}  
        ${if(len(order_code) == 0,"","and 	(CASE WHEN so.DIRECTION = 's' THEN
			    so.TB_ORDER_ID ELSE so.RETURN_CODE 
		        END)  in ('" + replace(order_code,",","','") + "')")
		} 
		${if(len(ooc_source) == 0,"","and so.ooc_source  in ('" + replace(ooc_source,",","','") + "')")}  
	    ${if(len(sku_code) == 0,"","and 	so.SUPPLIER_SKU_CODE  in ('" + replace(sku_code,",","','") + "')")}  				


       ${if(p1=="1","","limit "+t+",50;")}
 




select  's' DIRECTION,'销售出库' 出入库类型_trans

union
select	    'r_in' DIRECTION,'退货入库' 出入库类型_trans
union
select		 'chg_in' DIRECTION,'换货入库' 出入库类型_trans
		 union
select	 'chg_out' DIRECTION,'换货出库'  出入库类型_trans

