SELECT  warehouse,
	GI_DATE,
	Packlist_No,
	Extern_Order_Key,
        Ext_Code,
	Order_Type,
	Buyer_Po,
	Wh_Code,
	ETD,
	ETA,
	Customer_Code,
	Customer_Name,
	Cust_Addr,
	Carton_No,
	IsCarton,
	GPC,
	Style,
	Color,
	Dimension,
	Quality,
	EA,
	Size,
	UPC,
	Qty_Shipped,
	Label_No,
	Nike_Order_No,
	Mark_For_Code,
	Mark_For_Name,
	Division,
	Transport_Code,
	CRD,
	Weight
FROM(
		SELECT  wh.name as warehouse,
			DATE_FORMAT( odo.outbound_time, '%Y-%m-%d %H:%i:%s' ) as GI_DATE,
			odo.ext_code2 as Packlist_No,
			case when instr(odo.ext_code,'-') > 0 then left(odo.ext_code,instr(odo.ext_code,'-')-1)
                     when instr(odo.ext_code,'_') > 0 then left(odo.ext_code,instr(odo.ext_code,'_')-1)				 
                     else odo.ext_code end AS Extern_Order_Key,
                        odo.ext_code as Ext_Code,
			'' AS Order_Group,
			odo.ext_odo_type AS Order_Type,
			SUBSTR( odol.ext_props, POSITION( 'f17' IN odol.ext_props ) + 6, 17 ) AS Buyer_PO,
			'1039' AS Wh_Code,
			DATE_FORMAT( mgmt.plan_deliver_goods_time, '%Y-%m-%d' ) AS ETD,
			DATE_FORMAT( mgmt.print_crd, '%Y-%m-%d' ) AS ETA,
			addr.ship_target_code AS Customer_Code,
			addr.ship_target_name AS Customer_Name,
			addr.distribution_target_address AS Cust_Addr,
			box.carton_index AS Carton_No,
			CASE
					WHEN (box.outbound_checking_sku = 1 or (box.outbound_checking_sku = 2 and  box.picking_mode=3)) THEN '散箱'
					WHEN box.outbound_checking_sku = 2 THEN '整箱'
			ELSE box.outbound_checking_sku
			END AS IsCarton,
			skuext.sku_type1 AS GPC,
			LEFT ( sku.style, 6 ) AS Style,
			sku.color as Color,
			'00' AS Dimension,
			CASE boxl.inv_status 
					WHEN 1 THEN '01000'
					WHEN 3 THEN '02000'
					WHEN 2 THEN '01RTN'
			END AS Quality,
			SUBSTR( odol.ext_props, POSITION( 'f1' IN odol.ext_props ) + 5, 2 ) AS EA,
			sku.size AS Size,
			sku.ext_code2 AS UPC,
			(boxl.qty * skuext.du) AS Qty_Shipped,
			box.outboundbox_code AS Label_No,
			SUBSTR( odol.ext_props, POSITION( 'f12' IN odol.ext_props ) + 6, 10 ) AS Nike_Order_No,
			'' AS Mark_For_Code,
			'' AS Mark_For_Name,
			case 
					when skuext.sku_type1 in('10','02','服','服饰') then '10'
					when skuext.sku_type1 in('20','01','鞋','鞋子') then '20'
					when skuext.sku_type1 in('30','03','配','配件') then '30'
			else null
			end as Division,
			box.transport_code as Transport_Code,
			DATE_FORMAT( mgmt.print_crd, '%Y-%m-%d' ) as CRD,
			round(pac.actual_weight/1000000,2) as Weight
		FROM t_wh_odo odo
			LEFT JOIN t_wh_outboundbox box ON odo.ou_id = box.ou_id and box.odo_id = odo.id and box.status = '10'
			LEFT JOIN t_wh_outboundbox_line boxl ON box.id = boxl.wh_outboundbox_id and box.ou_id = boxl.ou_id	
		  LEFT JOIN t_wh_odo_line odol ON odo.ou_id = odol.ou_id and odo.id = odol.odo_id and boxl.odo_line_id = odol.id	
			LEFT JOIN t_wh_sku sku ON boxl.sku_code = sku.`code` AND boxl.ou_id = sku.ou_id
			LEFT JOIN t_wh_sku_extattr skuext ON sku.id = skuext.sku_id AND sku.ou_id = skuext.ou_id
			LEFT JOIN t_wh_odo_transport_mgmt mgmt ON odo.id = mgmt.odo_id and odo.ou_id = mgmt.ou_id
			LEFT JOIN t_wh_odo_package_info pac ON pac.outboundbox_code = box.outboundbox_code and pac.ou_id = odo.ou_id and pac.odo_id = odo.id
			LEFT JOIN t_wh_odo_address addr ON odo.id = addr.odo_id and odo.ou_id = addr.ou_id 
			LEFT JOIN t_bi_warehouse wh ON odo.ou_id = wh.id
			LEFT JOIN t_bi_store sto on odo.store_id = sto.id
		WHERE
			odo.ou_id in ( 173 , 275)
			AND odo.odo_type  in ('${replace(odo_type,",","','")}') 
			AND odo.odo_status = 100
			AND odo.merge_order_flag = 1
			AND sto.store_code in ('${replace(store_code,",","','")}')
			AND odo.outbound_time between  '${startDate}' AND '${endDate}'
			${if(len(ExtCode) == 0,""," and case when instr(odo.ext_code,'-') > 0 then left(odo.ext_code,instr(odo.ext_code,'-')-1)
                     when instr(odo.ext_code,'_') > 0 then left(odo.ext_code,instr(odo.ext_code,'_')-1)				 
                     else odo.ext_code end in ('" + replace(ExtCode,",","','") + "')")}
	  UNION ALL
			SELECT  wh.name as warehouse,
			DATE_FORMAT( group_odo.outbound_time, '%Y-%m-%d %H:%i:%s' ) as GI_DATE,
			odo.ext_code2 AS Packlist_No,
			case when instr(odo.ext_code,'-') = 0 then odo.ext_code else left(odo.ext_code,instr(odo.ext_code,'-')-1) end AS Extern_Order_Key,
                        odo.ext_code as Ext_Code,
			'' AS Order_Group,
			odo.ext_odo_type AS Order_Type,
			SUBSTR( odol.ext_props, POSITION( 'f17' IN odol.ext_props ) + 6, 17 ) AS Buyer_PO,
			'1039' AS Wh_Code,
			DATE_FORMAT( mgmt.plan_deliver_goods_time, '%Y-%m-%d' ) AS ETD,
			DATE_FORMAT( mgmt.print_crd, '%Y-%m-%d' ) AS ETA,
			addr.ship_target_code AS Customer_Code,
			addr.ship_target_name AS Customer_Name,
			addr.distribution_target_address AS Cust_Addr,
			box.carton_index AS Carton_No,
			CASE
					WHEN (box.outbound_checking_sku = 1 or (box.outbound_checking_sku = 2 and  box.picking_mode=3)) THEN '散箱'
					WHEN box.outbound_checking_sku = 2 THEN '整箱'
			ELSE box.outbound_checking_sku
			END AS IsCarton,
			skuext.sku_type1 AS GPC,
			LEFT ( sku.style, 6 ) AS Style,
			sku.color as Color,
			'00' AS Dimension,
			CASE boxl.inv_status 
					WHEN 1 THEN '01000'
					WHEN 3 THEN '02000'
					WHEN 2 THEN '01RTN'
			END AS Quality,
			SUBSTR( odol.ext_props, POSITION( 'f1' IN odol.ext_props ) + 5, 2 ) AS EA,
			sku.size AS Size,
			sku.ext_code2 AS UPC,
			(boxl.qty * skuext.du) AS Qty_Shipped,
			box.outboundbox_code AS Label_No,
			SUBSTR( odol.ext_props, POSITION( 'f12' IN odol.ext_props ) + 6, 10 ) AS Nike_Order_No,
			'' AS Mark_For_Code,
			'' AS Mark_For_Name,
			case 
					when skuext.sku_type1 in('10','02','服','服饰') then '10'
					when skuext.sku_type1 in('20','01','鞋','鞋子') then '20'
					when skuext.sku_type1 in('30','03','配','配件') then '30'
			else null
			end as Division,
			box.transport_code as Transport_Code,
			DATE_FORMAT( mgmt.print_crd, '%Y-%m-%d' ) as CRD,
			round(pac.actual_weight/1000000,2) as Weight
		FROM t_wh_odo group_odo
			LEFT JOIN t_wh_outboundbox box ON group_odo.ou_id = box.ou_id and box.odo_id = group_odo.id and box.status = '10'
			LEFT JOIN t_wh_outboundbox_line boxl ON box.id = boxl.wh_outboundbox_id and box.ou_id = boxl.ou_id
			LEFT JOIN t_wh_odo_line odol on boxl.ou_id = odol.ou_id and boxl.odo_line_id = odol.id and boxl.odo_id = odol.odo_id
			LEFT JOIN t_wh_sku sku ON boxl.sku_code = sku.`code` AND boxl.ou_id = sku.ou_id
			LEFT JOIN t_wh_sku_extattr skuext ON sku.id = skuext.sku_id AND sku.ou_id = skuext.ou_id
			LEFT JOIN t_wh_odo odo on odol.ou_id = odo.ou_id and odol.original_odo_code = odo.odo_code
			LEFT JOIN t_wh_odo_transport_mgmt mgmt ON odo.id = mgmt.odo_id and odo.ou_id = mgmt.ou_id
			LEFT JOIN t_wh_odo_package_info pac ON pac.outboundbox_code = box.outboundbox_code and pac.ou_id = group_odo.ou_id and pac.odo_id = group_odo.id
			LEFT JOIN t_wh_odo_address addr ON odo.id = addr.odo_id and odo.ou_id = addr.ou_id 
			LEFT JOIN t_bi_warehouse wh ON group_odo.ou_id = wh.id
			LEFT JOIN t_bi_store sto on odo.store_id = sto.id
		WHERE
			group_odo.ou_id in ( 173 , 275)
			AND group_odo.odo_type IN ('${replace(odo_type,",","','")}') 
			AND group_odo.odo_status = 100
			AND group_odo.merge_order_flag = 3
			AND sto.store_code in ('${replace(store_code,",","','")}')
			AND group_odo.outbound_time between '${startDate}' AND '${endDate}'
			${if(len(ExtCode) == 0,""," and case when instr(odo.ext_code,'-') > 0 then left(odo.ext_code,instr(odo.ext_code,'-')-1)
       when instr(odo.ext_code,'_') > 0 then left(odo.ext_code,instr(odo.ext_code,'_')-1)				 
       else odo.ext_code end in ('" + replace(ExtCode,",","','") + "')")}
		) x
ORDER BY
	GI_DATE

