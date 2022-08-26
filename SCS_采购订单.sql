select SM_Sy.butxt, SM_S4.id, SM_S4.code, SM_S4.sale_id, SM_S4.salecode, 
       SM_S4.LIFNR, SM_S4.LIFNRname,
       sm_DD.vbeln, SM_S4.Created_at, SM_S4.EBELN, 
       case SM_S4.status when 0 then '草稿'
                         when 1 then '已发货'
			          when 2 then '已确认收货'
					when 3 then '已完成'
					when 4 then '待处理'
					when 5 then '待发货'
					when 6 then '问题单'
					when 7 then '审核通过'
					when 8 then '审核不通过'
					when 9 then '已取消'
					when 10 then '已关闭'
					when 11 then '对账中'
					when 12 then '已付款'
					else '其它'
	  end as status,
       SM_S4.bsart, SM_ST.batxt, sm_s4.ekgrp, SM_sG.eknam,
       sm_s4.LGORT, sM_sC.lgobe, sm_s4.ernam,
       sm_s4.total_price,
	  SM_S4.MEMO
  from sm_s4order as SM_S4
	left join sm_s4purordtype as sm_sT on SM_S4.BSART=sm_sT.bsart 
	left join sm_s4purgroup as sm_sG on sm_s4.ekgrp=sm_sG.ekgrp and sm_sG.BUKRS=sm_s4.BUKRS
	left join sm_s4comwar as sm_sC on sm_s4.LGORT=sm_sc.LGORT and sm_sC.BUKRS=sm_s4.BUKRS
	left join (select distinct vbeln, sid from sm_s4saleorderdetail where VBELN <> '') as sm_DD on SM_S4.sale_id = sm_DD.sid
	left join sm_s4company sm_sy on SM_S4.bukrs = SM_Sy.bukrs
 where SM_S4.BUKRS IN ('${IV_BUKRS}')      
       and date(SM_S4.created_at)>='${IV_BEGINDATE}' and date(SM_S4.created_at)<='${IV_ENDDATE}'
       ${if(len(IV_MATNR)==0,""," and SM_S4.id in (select o_id from sm_s4orderproduct where MATNR = '"+IV_MATNR+"')")} 
       ${if(len(IV_MATKL) == 0,"","and SM_S4.id in (select a.o_id from sm_s4orderproduct a, sm_products_sap B where a.MATNR = B.itemcode and b.frgnname like '%"+IV_MATKL+"%')")}
       ${if(len(IV_OrderType) == 0,"","and SM_S4.BSART in ('" + IV_OrderType + "')")} 
       ${if(len(IV_PurGroup) == 0,"","and SM_S4.ekgrp in ('" + IV_PurGroup + "')")} 
       ${if(len(IV_Stock) == 0,"","and SM_S4.LGORT in ('" + IV_Stock + "')")} 
       ${if(len(IV_BillStatus) == 0,"","and SM_S4.status in ('" + IV_BillStatus + "')")} 
       ${if(len(IV_BillNo) == 0,"","and (SM_S4.code = '"+IV_BillNo+"' or SM_S4.salecode = '"+IV_BillNo+"' or sm_DD.vbeln = '"+IV_BillNo+"' or SM_S4.EBELN = '"+IV_BillNo+"')")}
	  and SM_S4.deleted_at is null        
 order by id desc      

select distinct psp.zefirstattrname  
  from sm_products_sap_private psp 
 where psp.BUKRS IN ('${IV_BUKRS}')   

SELECT bsart as "编码", batxt as "描述" 
FROM sm_s4purordtype 


SELECT ekgrp, eknam 
  FROM sm_s4purgroup 
 WHERE BUKRS IN ('${IV_BUKRS}')   

select s4c.LGORT, s4c.lgobe
 from sm_s4comwar as s4c
where s4c.BUKRS IN ('${IV_BUKRS}')   

SELECT b.bukrs, b.butxt
  FROM sm_s4comorg a,
       sm_s4company b
 where a.bukrs = b.bukrs and EKORG = ('${EKORG}') 

