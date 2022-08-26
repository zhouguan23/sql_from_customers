select  t.ou_id,
		t.inv_owner,
		t.com_goods_stock_id,
        t.sys_inv_safe_type_id,
        t.com_goods_id,
        g.goods_opcode,
        g.goods_name,
        g.goods_desc,
        pur_remind,
        (
    	select count(gr.vender_party_id) 
    	from SYS_VENDER_GOODS_REF gr 
    	where gr.com_goods_id = t.COM_GOODS_ID 
    		and gr.INV_OWNER = R.INV_OWNER
    		and gr.status = 'TRUE'
		) as vendercount,
		t.GOODS_UPLMT_QTY,
        t.day_dist_qty,
        nvl(g.package_num,1) package_num,
        nvl(g.mid_package_num,1)mid_package_num,
        nvl(g.package_num,1)||'/'||nvl(g.mid_package_num,1) package_num_info,
        g.PRODUCT_LOCATION,
        g.PARTY_NAME as  factory_name,
        g.UNIT_NAME,
        t.pur_remind,
        nvl(op_lines.onhand,0) onhand,
        op_lines.onavailable,
        nvl((select sum(receive_qty-locate_qty) onsend
			from ssc_receive_interface_lines l
			inner join ssc_receive_interface i
			on i.ssc_receive_interface_id = l.ssc_receive_interface_id
			where i.valid_end_timestamp >= trunc(sysdate)
			and l.com_goods_id = t.com_goods_id
			and i.inv_owner_id = t.inv_owner
			and nvl(l.sys_channel_id,0) = nvl(t.sys_channel_id,0)
		),0) onsend,
        op_lines.onlook,
        t.rtl_receiv_qty,
        t.goods_lowerlmt_qty,
        t.goods_uplmt_qty,
        t.sale180_qty,
        t.sale60_qty,
        t.sale30_qty,
        t.cm_pf_sale30_qty,
        t.cm_pf_sale60_qty,
        t.sx_sale30_qty,
        t.sx_sale60_qty,
        t.foreign_sale30_qty,
        t.foreign_sale60_qty,
        t.retail_sale30_qty,
        t.retail_sale60_qty,
        t.sum_pf30_qty,
        t.sum_pf60_qty,
        t.hos_sale30_qty,
        t.hos_sale60_qty,
        t.shop_sale30_qty,
        t.shop_sale60_qty,
        t.wholesale_price,
        t.retail_price,
        nvl(req_lines.VENDER_ID,R.vender_party_id) vender_party_id,
        nvl(req_lines.VENDER_ID,'') orig_vender_id,
        com_party.party_name,
        com_party.party_opcode vender_Party_Opcode,
        round(R.DEFAULT_PRICE / (1+g.pur_tax_rate),6) pur_free_price,
        R.DEFAULT_PRICE pur_price,
        g.pur_tax_rate tax_rate,
        t.last_price,
        t.bidprice,
        t.person_buyer,
        t.person_goods_maneger,
        t.person_order,
        t.day_sale_qty,
        t.is_purch,
        t.purch_suggested_qty,
        nvl(req_lines.qty,t.purch_suggested_qty) AS QTY,
        t.retail_stk_qty,
        t.up_days,
        t.up_limit,
        t.lower_days,
        t.lower_limit,
        t.inv_owner,
        t.channel_name,
        t.sys_channel_id,
        t.ssc_inventory_safe_id,
        t.retialsale_price,
        t.foreign_wholesale_quantity,
         (select cp1.party_name from com_party cp1 where cp1.com_party_id = spd.emp_party_id) as buhuo,
        (select cp.party_name from com_party cp where cp.com_party_id = sbd.emp_id) as pls,
        decode(t.DAY_DIST_QTY,0,9999,round(op_lines.onhand/t.DAY_DIST_QTY,0)) turnover_days,
        t.retail_days,
        (select r.meet_period from SYS_VENDER_GOODS_REF r where r.com_goods_id=t.com_goods_id  AND ROWNUM=1) as meet_period,
        '库存合理' AS REPLENISHUR_ANALYSIS,
        t.buss_tips,
        round(retail_sale60_qty / 60.0,0) sale_Day,
        req_lines.ssc_apply_goods_req_id,
        req_lines.ssc_apply_goods_req_lines_id,
        t.retail_stk_qty,
        sis.reminder,
	   t.sx_sale_qty
        from com_goods_stock t
        inner join SYS_VENDER_GOODS_REF R on t.com_goods_id = R.com_goods_id 
        	and R.IS_PRIMARY = 'TRUE' and R.ou_id = ${invOwner}
        	and r.ou_id = t.OU_ID
        	and R.STATUS  ='TRUE'
        
        inner join sys_vender_org_mapping m on m.ou_id = t.OU_ID
		   and m.com_party_id = R.VENDER_PARTY_ID
		   and m.status = 'TRUE'
	   left join ssc_inventory_safe sis on sis.com_goods_id = t.com_goods_id
        left join v_SSC_APPLY_GOODS_REQ_LINES req_lines on t.com_goods_id = req_lines.com_goods_id 
     			and t.inv_owner = req_lines.inv_owner  
        inner join com_party on com_party.com_party_id = nvl(req_lines.VENDER_ID,R.vender_party_id)
 		inner join v_goods_info g on t.com_goods_id = g.com_goods_id 
 		left join         
        (SELECT com_inv_op_lines.inv_owner,nvl(com_inv_op_lines.sys_channel_id, 0)sys_channel_id, com_inv_op_lines.com_goods_id, sum(decode(com_inventory_type_id, 1, onhand, 0)) onhand,
                 sum(decode(com_inventory_type_id, 1, onavailable, 0)) onavailable,
                 sum(decode(com_inventory_type_id, 1, onsend, 0)) onsend,
                 sum(decode(com_inventory_type_id, 1, 0, onlook)) onlook
            FROM com_inv_op_lines
           where com_inventory_type_id = 1
             group by com_inv_op_lines.inv_owner,nvl(com_inv_op_lines.sys_channel_id, 0), com_inv_op_lines.com_goods_id
        ) op_lines on op_lines.inv_owner = t.inv_owner
             and op_lines.com_goods_id = t.com_goods_id
             and  op_lines.sys_channel_id = nvl(t.sys_channel_id,0)
 		left join sys_planer_duty spd on spd.com_goods_id = g.COM_GOODS_ID and spd.ou_id = ${invOwner}
       	left join sys_buyer_duty sbd on sbd.vender_party_id = r.vender_party_id and sbd.pos_keyword = 'PLANER' and sbd.OU_ID = ${invOwner}
  		where  t.ou_id = ${invOwner}
  		and t.sys_channel_id = 0
  		and t.inv_owner =${invOwner}
  		and exists(select 1 from sys_buyer_duty D
	         WHERE D.pos_KEYWORD='PLANER'
	         and D.OU_ID =${invOwner}
	         and D.VENDER_PARTY_ID = R.VENDER_PARTY_ID
        )
  		and PAK_VIEW_PARA.F_SET_INV_OWNER(${invOwner}) = 1  		 
   		AND NOT EXISTS (SELECT 0
	        FROM Sys_Pur_Goods_Sum S
	        WHERE S.COM_GOODS_ID = T.COM_GOODS_ID
	        and s.INV_OWNER = ${invOwner}) 
	        and exists (select 1 from sys_goods_org_mapping ss where
	        ss.com_goods_id=t.com_goods_id and ss.OU_ID=${invOwner}
	        and  ss.pur_status <> 'FALSE' 
        )
${if(len(ls_comGoodsId)==0,""," and g.goods_opcode in('" + ls_comGoodsId + "')")}
${if(len(ls_vender)==0,""," and com_party.party_name like '%" + ls_vender + "%'")} 
${if(len(ls_comGoodsName)==0,""," and g.GOODS_NAME like '%" + ls_comGoodsName + "%'")} 
   

