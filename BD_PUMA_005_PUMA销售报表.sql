select 
  decode(storeCode,'6986','Tmall','6989','官方商城','6990','JD') platform , --所属平台
  t.transactionNo ,                                                         --pacs订单号
  t.slipCode ,                                                              --外部平台订单号
  t.upc ,                                                                   --upc
  t.unitPrice,                                                              --行单价（吊牌价）
  t.actualPrice,                                                            --行单价（实际价格）
  t.qty,                                                                    --数量
  t.lineTotal  ,                                                            --行总价
  to_char(T.deliveryDate, 'yyyy-mm-dd hh24:mi:ss')                          --确认销售日期（发货日期）
from (select 
                  so.code transactionNo,
                  to_char(so.delivery_time, 'yyyymmdd') transactionDate,
                  to_char(so.delivery_time, 'hh24miss')  transactionTime,
                  shop.id storeCode,
                  so.outer_order_code slipCode,
                  '0' type,
                  row_number() over(partition by so.code order by so.delivery_time desc) lineNo,
                  bisku.ext_code2 upc,
                  sol.sku_list_price unitPrice,
                  sol.actual_price actualPrice,
                  sol.requested_qty as qty,
                  decode(sol.sku_list_price,0,0,(sol.sku_list_price-sol.actual_price)) discount ,
                  sol.total lineTotal,
                  so.taobao_id customerId,
                  r.member_email email,
                  r.receiver name,
                  r.mobile telephone,
                  r.Receiver_Phone mobile,
                  so.payment_type paymentType,
                  so.Total_Point_Used   totalPointUsed,
                  so.actual_transfer_fee logisticFee,
                  bisku.code skuCode,
                  bisku.supplier_code supplierCode,
                  tp.ean barcode,
                  tp.sku alu,
                  tp.style_description styleDescription,
                  tp.color_description colorDescription,
                  tp.gender,
                  tp.size_information sizeInformation,
                  tp.season,
                  tp.article_group articleGroup,
                  tp.activity_group_trans_grp agtg,
                  tp.article_type articleType,
                  tp.product_division productDivision,
                  tp.Reporting_Category  reportingCategory,
                  tp.Reporting_Line  reportingLine,
                  tp.concept,
                  tp.line_name lineName,
                  tp.Body_Style bodyStyle,
                  tp.Assortment_Grade assortmentGrade,
              so.delivery_time deliveryDate,
              trans.platform_code platformCode
             from pacs.t_so_sales_order   so                                         
                    join  pacs.T_SO_SO_MEMBER r on (so.id=r.id)
                    join  pacs.t_so_so_line sol on( so.id=sol.so_id)
                    join  pacs.t_ma_tb_shop_info shop on(shop.id = so.shop_id)
                    join  pacs.t_ma_inv_sku bisku on (bisku.code=sol.jmsku_code and sol.sku_code=bisku.jm_code)
                    join  pacs.t_ma_sku pro on  bisku.product_id = pro.id
                    LEFT jOIN (SELECT max(id) id, tp.sku FROM pacs.T_PUMA_MASTER_SKU_DATA tp group by tp.sku) ta on bisku.ext_code2 = ta.sku
                          LEFT join  pacs.T_PUMA_MASTER_SKU_DATA tp on tp.sku = ta.sku and tp.id = ta.id
                    left join pacs.T_MA_TRANSPORTATOR trans on(r.transportator_id=trans.id) 
             where   so.rtn_request_id is null 
             and (so.status = 6 or so.status = 15 or so.status=12)
             and nvl(pro.is_gift,0)<>1
             and so.delivery_time >=to_date('${startTime}','yyyy-MM-dd hh24:mi:ss') and so.delivery_time<to_date('${endTime}','yyyy-MM-dd hh24:mi:ss')
             and shop.id in (6986,6989,6990)
            union all
                   select 
                    rr.code transactionNo,
                    to_char(rr.inbound_time, 'yyyymmdd') transactionDate,
                    to_char(rr.inbound_time, 'hh24miss')  transactionTime,
                    info.id storeCode,
                    rootSo.Outer_Order_Code slipCode,
                    '2' type,
                    row_number() over(partition by rr.code order by rr.inbound_time desc) lineNo,
                    bisku.ext_code2 upc,
                    soline.sku_list_price unitPrice,
                    soline.actual_price actualPrice,
                    0-rl.requested_qty as qty,
                    decode(soline.sku_list_price,0,0,(soline.sku_list_price-soline.actual_price)) discount ,
                    soline.actual_price*rl.requested_qty lineTotal,
                    '' customerId,
                    '' email,
                    r.receiver name,
                    '' telephone,
                    '' mobile,
                    rootSo.payment_type  paymentType,
                    rootSo.Total_Point_Used totalPointUsed,
                    0  logisticFee,
                    bisku.code skuCode,
                    bisku.supplier_code supplierCode,
                    tp.ean barcode,
                    tp.sku alu,
                    tp.style_description styleDescription,
                    tp.color_description colorDescription,
                    tp.gender,
                    tp.size_information sizeInformation,
                    tp.season,
                    tp.article_group articleGroup,
                    tp.activity_group_trans_grp agtg,
                    tp.article_type articleType,
                    tp.product_division productDivision,
                    tp.Reporting_Category  reportingCategory,
                    tp.Reporting_Line  reportingLine,
                    tp.concept,
                    tp.line_name lineName,
                    tp.Body_Style bodyStyle,
                    tp.Assortment_Grade assortmentGrade,
                    rr.inbound_time deliveryDate,
                    trans.platform_code platformCode
              from pacs.t_so_return_request rr
                    join pacs.t_so_return_request_line rl on rl.rr_id = rr.id
                    join pacs.t_so_sales_order rootSo on rootSo.id = rr.so_id
                    join  pacs.T_SO_SO_MEMBER r on (rootSo.id=r.id)
                    join pacs.t_so_so_line soline on soline.id=rl.so_line_id
                    join  pacs.t_ma_inv_sku bisku on (bisku.code=rl.jmsku_code and bisku.jm_code=rl.sku_code)
                    join  pacs.t_ma_sku pro on  bisku.product_id = pro.id
                    join pacs.t_ma_tb_shop_info info on info.id = rootSo.shop_id
                    LEFT jOIN (SELECT max(id) id, tp.sku FROM pacs.T_PUMA_MASTER_SKU_DATA tp group by tp.sku) ta on bisku.ext_code2 = ta.sku
                          LEFT join  pacs.T_PUMA_MASTER_SKU_DATA tp on tp.sku = ta.sku and tp.id = ta.id
                    left join pacs.T_MA_TRANSPORTATOR trans on(r.transportator_id=trans.id)
             where     
                  (rr.status = 20 or rr.status=17 or rr.status=16)  
                  and info.id in (6986,6989,6990)
                  and nvl(pro.is_gift,0)<>1
                  and rr.inbound_time >=to_date('${startTime}','yyyy-MM-dd hh24:mi:ss') and rr.inbound_time<to_date('${endTime}','yyyy-MM-dd hh24:mi:ss')
            union all             
             select  
                    rr.code || 'S' transactionNo,
                    to_char(rr.outbound_time, 'yyyymmdd') transactionDate,
                    to_char(rr.outbound_time, 'hh24miss')  transactionTime,
                    info.id storeCode,
                    newSo.Outer_Order_Code slipCode,
                    '0' type,
                    row_number() over(partition by rr.code order by rr.outbound_time desc) lineNo,
                    bisku.ext_code2 upc,
                    soline.sku_list_price unitPrice,
                    soline.actual_price actualPrice,
                    rl.requested_qty as qty,
                    decode(soline.sku_list_price,0,0,(soline.sku_list_price-soline.actual_price))  discount ,
                    soline.actual_price*rl.requested_qty lineTotal,
                    newSo.taobao_id customerId,
                    r.member_email email,
                    r.receiver name,
                    r.mobile telephone,
                    r.Receiver_Phone mobile,
                    newSo.payment_type  paymentType,
                    newSo.Total_Point_Used totalPointUsed,
                    0  logisticFee,
                    bisku.code skuCode,
                    bisku.supplier_code supplierCode,
                    tp.ean barcode,
                    tp.sku alu,
                    tp.style_description styleDescription,
                    tp.color_description colorDescription,
                    tp.gender,
                    tp.size_information sizeInformation,
                    tp.season,
                    tp.article_group articleGroup,
                    tp.activity_group_trans_grp agtg,
                    tp.article_type articleType,
                    tp.product_division productDivision,
                    tp.Reporting_Category  reportingCategory,
                    tp.Reporting_Line  reportingLine,
                    tp.concept,
                    tp.line_name lineName,
                    tp.Body_Style bodyStyle,
                    tp.Assortment_Grade assortmentGrade,
                rr.outbound_time deliveryDate,
                trans.platform_code platformCode
            from pacs.t_so_ro ro
                  join pacs.t_so_return_request rr on rr.id = ro.rr_id
                  join pacs.t_so_return_request_line rl on rl.rr_id = rr.id
                  join pacs.t_so_sales_order newSo on newSo.id=ro.new_so_id
                  join  pacs.T_SO_SO_MEMBER r on (newSo.id=r.id)
                  join pacs.t_so_so_line soline on soline.id=rl.so_line_id
                  join pacs.t_ma_tb_shop_info info on info.id = newSo.Shop_Id
                  join  pacs.t_ma_inv_sku bisku on (bisku.code=rl.chg_jmsku_code and bisku.jm_code=rl.chg_sku_code)
                  join  pacs.t_ma_sku pro on  bisku.product_id = pro.id
                  LEFT jOIN (SELECT max(id) id, tp.sku FROM pacs.T_PUMA_MASTER_SKU_DATA tp group by tp.sku) ta on bisku.ext_code2 = ta.sku
                        LEFT join  pacs.T_PUMA_MASTER_SKU_DATA tp on tp.sku = ta.sku and tp.id = ta.id
                  left join pacs.T_MA_TRANSPORTATOR trans on(r.transportator_id=trans.id)
            where 
                    rr.type = 2 
                   and info.id in (6986,6989,6990)
                   and (rr.status = 20 or rr.status=17)
                   and nvl(pro.is_gift,0)<>1
                   and rr.outbound_time>=to_date('${startTime}','yyyy-MM-dd hh24:mi:ss') and rr.outbound_time<to_date('${endTime}','yyyy-MM-dd hh24:mi:ss')
             
            union all  
            select  
                    re.code transactionNo,
                    to_char(re.executed_time, 'yyyymmdd') transactionDate,
                    to_char(re.executed_time, 'hh24miss')  transactionTime,
                    re.company_shop_id storeCode,
                    so.Outer_Order_Code slipCode,
                    '2' type,
                    row_number() over(partition by re.code order by re.executed_time desc) lineNo,
                    bisku.ext_code2 upc,
                    cost1.list_price unitPrice,
                    rol.actual_price actualPrice,
                    0-rol.qty as qty,
                    decode(cost1.list_price,0,0,(cost1.list_price-rol.actual_price)) discount ,
                    rol.sku_total lineTotal,
                    '' customerId,
                    '' email,
                    r.receiver name,
                    '' telephone,
                    '' mobile,
                    re.return_way  paymentType,
                    so.Total_Point_Used totalPointUsed,
                    0  logisticFee,
                    bisku.code skuCode,
                    bisku.supplier_code supplierCode,
                    tp.ean barcode,
                    tp.sku alu,
                    tp.style_description styleDescription,
                    tp.color_description colorDescription,
                    tp.gender,
                    tp.size_information sizeInformation,
                    tp.season,
                    tp.article_group articleGroup,
                    tp.activity_group_trans_grp agtg,
                    tp.article_type articleType,
                    tp.product_division productDivision,
                    tp.Reporting_Category  reportingCategory,
                    tp.Reporting_Line  reportingLine,
                    tp.concept,
                    tp.line_name lineName,
                    tp.Body_Style bodyStyle,
                    tp.Assortment_Grade assortmentGrade,
                re.executed_time deliveryDate,
                trans.platform_code platformCode
            from pacs.T_SO_REFUND_APPLICATION re
                  left join pacs.T_SO_REFUND_APPLICATION_LINE rol on rol.rf_id = re.id
                  left join pacs.t_so_sales_order so on re.so_id = so.id
                  left join pacs.t_ma_inv_sku bisku on bisku.code=rol.sku_code
                  left join pacs.T_SO_SO_MEMBER r on (so.id=r.id)
                  left join pacs.t_ma_sku pro on  bisku.product_id = pro.id
                  left join pacs.t_ma_sku_cost cost1 on cost1.id = pro.id
                  LEFT jOIN (SELECT max(id) id, tp.sku FROM pacs.T_PUMA_MASTER_SKU_DATA tp group by tp.sku) ta on bisku.ext_code2 = ta.sku
                        LEFT join pacs.T_PUMA_MASTER_SKU_DATA tp on tp.sku = ta.sku and tp.id = ta.id
                  left join pacs.T_MA_TRANSPORTATOR trans on(r.transportator_id=trans.id)
            where 
                   re.company_shop_id in (6986,6989,6990)
                   and re.refund_reason_type = 2
                   and re.status = 10
                   and nvl(pro.is_gift,0)<>1
                 and re.executed_time>=to_date('${startTime}','yyyy-MM-dd hh24:mi:ss') and re.executed_time<to_date('${endTime}','yyyy-MM-dd hh24:mi:ss')
            union all
            select  
                    re.code||'S' transactionNo,
                    to_char(re.executed_time, 'yyyymmdd') transactionDate,
                    to_char(re.executed_time, 'hh24miss')  transactionTime,
                    re.company_shop_id storeCode,
                    so.Outer_Order_Code slipCode,
                    '0' type,
                    row_number() over(partition by re.code order by re.executed_time desc) lineNo,
                    bisku.ext_code2 upc,
                    cost1.list_price unitPrice,
                    decode(rol.actual_price,0,0,(rol.actual_price-decode(rol.refund_amount,'',0,(rol.refund_amount/rol.qty)))) actualPrice,
                    rol.qty as qty,
                    decode(cost1.list_price,0,0,(cost1.list_price-decode(rol.actual_price,0,0,(rol.actual_price-decode(rol.refund_amount,'',0,rol.refund_amount/rol.qty))))) discount ,
                    decode(rol.sku_total,0,0,decode(rol.refund_amount,'',rol.sku_total,rol.sku_total-rol.refund_amount)) lineTotal,
                    so.taobao_id customerId,
                    r.member_email email,
                    r.receiver name,
                    r.mobile telephone,
                    r.Receiver_Phone mobile,
                    re.return_way  paymentType,
                    so.Total_Point_Used totalPointUsed,
                    0  logisticFee,
                    bisku.code skuCode,
                    bisku.supplier_code supplierCode,
                    tp.ean barcode,
                    tp.sku alu,
                    tp.style_description styleDescription,
                    tp.color_description colorDescription,
                    tp.gender,
                    tp.size_information sizeInformation,
                    tp.season,
                    tp.article_group articleGroup,
                    tp.activity_group_trans_grp agtg,
                    tp.article_type articleType,
                    tp.product_division productDivision,
                    tp.Reporting_Category  reportingCategory,
                    tp.Reporting_Line  reportingLine,
                    tp.concept,
                    tp.line_name lineName,
                    tp.Body_Style bodyStyle,
                    tp.Assortment_Grade assortmentGrade,
                re.executed_time deliveryDate,
                trans.platform_code platformCode
            from pacs.T_SO_REFUND_APPLICATION re
                  left join pacs.T_SO_REFUND_APPLICATION_LINE rol on rol.rf_id = re.id
                  left join pacs.t_so_sales_order so on re.so_id = so.id
                  left join pacs.t_ma_inv_sku bisku on bisku.code=rol.sku_code
                  left join pacs.T_SO_SO_MEMBER r on (so.id=r.id)
                  left join pacs.t_ma_sku pro on  bisku.product_id = pro.id
                  left join pacs.t_ma_sku_cost cost1 on cost1.id = pro.id
                  LEFT jOIN (SELECT max(id) id, tp.sku FROM pacs.T_PUMA_MASTER_SKU_DATA tp group by tp.sku) ta on bisku.ext_code2 = ta.sku
                        LEFT join  pacs.T_PUMA_MASTER_SKU_DATA tp on tp.sku = ta.sku and tp.id = ta.id
                  left join pacs.T_MA_TRANSPORTATOR trans on(r.transportator_id=trans.id)
            where 
                   re.company_shop_id in (6986,6989,6990)
                   and re.refund_reason_type = 2
                   and re.status = 10
                   and nvl(pro.is_gift,0)<>1
                 and re.executed_time>=to_date('${startTime}','yyyy-MM-dd hh24:mi:ss') and re.executed_time<to_date('${endTime}','yyyy-MM-dd hh24:mi:ss')) t order by t.deliveryDate desc

