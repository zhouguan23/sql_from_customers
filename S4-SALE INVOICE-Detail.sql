
select 
    LTRIM( A.vbeln,'0' ) AS VBELN,
    LTRIM( A.posnr,'0' ) AS POSNR,
    LTRIM( A.matnr,'0' ) AS MATNR,
    A.butxt as bukrs,
    A.erdat,
    A.FKDAT,
    A.ernam,
    A.name_last,
    LTRIM( A.kunag,'0' ) AS kunag,
    A.name1,
    LTRIM( A.kunnr,'0' ) AS kunnr,
    A.name2,
    A.lgort,
    A.lgobe,
    A.MSEHL AS vrkme,
    A.fkimg,
    A.matkl,
    A.kzwi1,
    A.NETWR,
    A.MWSBP,
    A.WAVWR,
    A.VTEXT,
    A.zywymc,
    A.ztext1,
    A.zscn AS ZPPU,
    A.ZMODEL AS ZSCN,
    A.EXTWG,
    A.ZDL,
    A.ZZL,
    A.ZXL,
    LTRIM( A.zxmbh,'0' ) AS ZXMBH,
    A.zname  
   from "SAPHANADB"."ZSDV_FR_VBELN_VF" AS A
   where A.BUKRS IN ( '${IV_BUKRS}' ) 
     ${if(type  == 'A',"and A.FKDAT >= '" + BEGINDATE + "'" + " and A.FKDAT <= '" + ENDDATE + "'","and A.ERDAT >= '" + BEGINDATE + "'" + " and A.ERDAT <= '" + ENDDATE + "'")}
     ${if(len(IV_KUNNR)  == 0,"","and LTRIM( A.kunnr,'0' ) = '" + IV_KUNNR + "'")} 
     ${if(len(IV_KUNAG)  == 0,"","and LTRIM( A.kunag,'0' ) = '" + IV_KUNAG + "'")} 
     ${if(len(IV_NAME1)  == 0,"","and A.NAME1 = '" + IV_NAME1 + "'")} 
     ${if(len(IV_NAME2)  == 0,"","and A.NAME2 = '" + IV_NAME2 + "'")} 
     ${if(len(IV_VTEXT)  == 0,"",if(len(IV_VTEXT2)  == 0," AND A.VTEXT IS NULL","and A.VTEXT = '" + IV_VTEXT + "'"))} 
     ${if(len(IV_YWY)  == 0,"","and A.ZYWYMC = '" + IV_YWY + "'")} 
     ${if(len(IV_MATNR)  == 0,"","and LTRIM( A.matnr,'0' ) = '" + IV_MATNR + "'")} 
     ${if(len(IV_MATKL)  == 0,"","and A.ZTEXT1 = '" + IV_MATKL + "'")} 
     ${if(len(IV_VBELN)  == 0,"","and LTRIM( A.vbeln,'0' ) = '" + IV_VBELN + "'")} 
     ${if(len(IV_ZDR)  == 0,"","and A.name_last = '" + IV_ZDR + "'")} 
     ${if(len(IV_ZXMBH)  == 0,"","and LTRIM( A.zxmbh,'0' ) = '" + IV_ZXMBH + "'")} 
     ${if(len(IV_ZNAME)  == 0,"","and A.zname = '" + IV_ZNAME + "'")} 
     ${if(len(IV_LGORT)  == 0,"","and A.lgobe IN ( '" + IV_LGORT + "' )")}
     ${if(len(IV_DL)  == 0,"","and A.ZDL IN ( '" + IV_DL + "' )")} 
     ${if(len(IV_ZL)  == 0,"","and A.ZZL = '" + IV_ZL + "'")} 
     ${if(len(IV_XL)  == 0,"","and A.ZXL = '" + IV_XL + "'")} 


SELECT C.LGOBE 
FROM "SAPHANADB"."T001K" AS A 
INNER JOIN "SAPHANADB"."T001W" AS B 
ON A.bwkey = B.bwkey
INNER JOIN "SAPHANADB"."T001L" AS C 
ON B.werks = C.werks
WHERE A.BUKRS IN ( '${IV_BUKRS}' ) 
AND  A.bwmod = '8000'

SELECT 
DISTINCT ( ZDL )
FROM "SAPHANADB"."ZMM_V_MATKL"

SELECT a.id,a.username,a.realname,b.roleid,c.description,
       left(c.description,4) as bukrs2,
       right(c.description,1) as price_autho2,
       D.BUKRS,D.WERKS,D.price
FROM fine_user a
INNER JOIN fine_user_role_middle b on a.id = b.userid
inner join fine_custom_role c on c.id = b.roleid
left join PUBLIC.CUSTOM_ROLE_PARAMETER as d on d.role_id = c.name 
where a.username='${fine_username}'

SELECT bukrs,BUTXT 
FROM "SAPHANADB"."T001" 
WHERE BUKRS IN ( '${IV_BUKRS2}' ) 

${
if(PRICE = true,
"select 
    butxt as \"公司名称\",
    LTRIM( A.vbeln,'0' ) AS \"单据号\",
    LTRIM( A.posnr,'0' ) AS \"单据行号\",
    A.erdat as \"订单日期\",
    A.FKDAT as \"发票日期\",
    A.VTEXT as \"部门\",
    A.zywymc as \"业务员\",
    A.name_last as \"制单员\",
    A.lgobe as \"仓库\",
    LTRIM( A.kunag,'0' ) AS \"客户编号\",
    A.name1 as \"客户名称\",
    LTRIM( A.kunnr,'0' ) AS \"终端客户编号\",
    A.name2 as \"终端客户名称\",
    A.zname as \"项目名称\", 
    LTRIM( A.matnr,'0' ) AS \"商品编码\",
    A.ztext1 as \"商品名称\",
    A.EXTWG as \"品牌\",
    A.ZMODEL AS \"规格\",
    A.zscn AS \"包装数量\",
    A.MSEHL AS \"单位\",
    A.ZDL as \"大类\",
    A.ZZL as \"中类\",
    A.ZXL as \"小类\",
    A.fkimg as \"数量\",
    A.kzwi1 as \"含税金额\",
    round((kzwi1 / fkimg ),2) as \"含税单价\",
    A.NETWR as \"未税金额\",
    round((NETWR / fkimg ),2) as \"未税单价\",
    A.MWSBP as \"税额\",
    A.WAVWR as \"成本金额（未税）\",
    round((WAVWR / fkimg ),2) as \"成本单价\",
    (NETWR - WAVWR ) as \"毛利额(未税)\",
    round(((NETWR - WAVWR ) / NETWR ),2)as \"毛利率(未税)\"
    from \"SAPHANADB\".\"ZSDV_FR_VBELN_VF\" AS A
    where BUKRS IN ( '"+IV_BUKRS+"' ) "+
      "AND FKIMG <> 0" +
      if(type  == 'A'," and FKDAT >= '" + BEGINDATE + "'" + " and FKDAT <= '" + ENDDATE + "'"," and ERDAT >= '" + BEGINDATE + "'" + " and ERDAT <= '" + ENDDATE + "'") + 
     if(len(IV_KUNAG)  == 0,""," and LTRIM( A.kunag,'0' ) = '" + IV_KUNAG + "'") + 
     if(len(IV_KUNNR)  == 0,""," and LTRIM( A.kunnr,'0' ) = '" + IV_KUNNR + "'") + 
     if(len(IV_NAME1)  == 0,""," and A.NAME1 = '" + IV_NAME1 + "'") + 
     if(len(IV_NAME2)  == 0,""," and A.NAME2 = '" + IV_NAME2 + "'") + 
     if(len(IV_VTEXT)  == 0,"",if(len(IV_VTEXT2)  == 0," AND A.VTEXT IS NULL "," and A.VTEXT = '" + IV_VTEXT + "'")) +
     if(len(IV_YWY)  == 0,""," and A.ZYWYMC = '" + IV_YWY + "'") +
     if(len(IV_MATNR)  == 0,""," and LTRIM( A.matnr,'0' ) = '" + IV_MATNR + "'") +
     if(len(IV_MATKL)  == 0,""," and A.ZTEXT1 = '" + IV_MATKL + "'") + 
     if(len(IV_VBELN)  == 0,""," and LTRIM( A.vbeln,'0' ) = '" + IV_VBELN + "'") + 
     if(len(IV_ZDR)  == 0,""," and A.name_last = '" + IV_ZDR + "'") + 
     if(len(IV_ZXMBH)  == 0,""," and LTRIM( A.ZXMBH,'0' ) = '" + IV_ZXMBH + "'") + 
     if(len(IV_ZNAME)  == 0,""," and A.ZNAME = '" + IV_ZNAME + "'") + 
     if(len(IV_LGORT)  == 0,""," and A.lgobe IN ( '" + IV_LGORT + "' )") +
     if(len(IV_DL)  == 0,""," and A.ZDL IN ( '" + IV_DL + "' )") +
     if(len(IV_ZL)  == 0,""," and A.ZZL IN ( '" + IV_ZL + "' )") +
     if(len(IV_XL)  == 0,""," and A.ZXL IN ( '" + IV_XL + "' )") +
"order by BUTXT,werks,lgort,vbeln"
  ,
"select 
    butxt as \"公司名称\",
    LTRIM( A.vbeln,'0' ) AS \"单据号\",
    LTRIM( A.posnr,'0' ) AS \"单据行号\",
    A.erdat as \"订单日期\",
    A.FKDAT as \"发票日期\",
    A.VTEXT as \"部门\",
    A.zywymc as \"业务员\",
    A.name_last as \"制单员\",
    A.lgobe as \"仓库\",
    LTRIM( A.kunag,'0' ) AS \"客户编号\",
    A.name1 as \"客户名称\",
    LTRIM( A.kunnr,'0' ) AS \"终端客户编号\",
    A.name2 as \"终端客户名称\",
    A.zname as \"项目名称\", 
    LTRIM( A.matnr,'0' ) AS \"商品编码\",
    A.ztext1 as \"商品名称\",
    A.EXTWG as \"品牌\",
    A.ZMODEL AS \"规格\",
    A.zscn AS \"包装数量\",
    A.MSEHL AS \"单位\",
    A.ZDL as \"大类\",
    A.ZZL as \"中类\",
    A.ZXL as \"小类\",
    A.fkimg as \"数量\",
    A.kzwi1 as \"含税金额\",
    round((kzwi1 / fkimg ),2) as \"含税单价\",
    A.NETWR as \"未税金额\",
    round((NETWR / fkimg ),2) as \"未税单价\",
    A.MWSBP as \"税额\"
    from \"SAPHANADB\".\"ZSDV_FR_VBELN_VF\" AS A
    where BUKRS IN ( '"+IV_BUKRS+"' ) "+
      "AND FKIMG <> 0" +
      if(type  == 'A'," and FKDAT >= '" + BEGINDATE + "'" + " and FKDAT <= '" + ENDDATE + "'"," and ERDAT >= '" + BEGINDATE + "'" + " and ERDAT <= '" + ENDDATE + "'") + 
     if(len(IV_KUNAG)  == 0,""," and LTRIM( A.kunag,'0' ) = '" + IV_KUNAG + "'") + 
     if(len(IV_KUNNR)  == 0,""," and LTRIM( A.kunnr,'0' ) = '" + IV_KUNNR + "'") + 
     if(len(IV_NAME1)  == 0,""," and A.NAME1 = '" + IV_NAME1 + "'") + 
     if(len(IV_NAME2)  == 0,""," and A.NAME2 = '" + IV_NAME2 + "'") + 
     if(len(IV_VTEXT)  == 0,"",if(len(IV_VTEXT2)  == 0," AND A.VTEXT IS NULL "," and A.VTEXT = '" + IV_VTEXT + "'")) +
     if(len(IV_YWY)  == 0,""," and A.ZYWYMC = '" + IV_YWY + "'") +
     if(len(IV_MATNR)  == 0,""," and LTRIM( A.matnr,'0' ) = '" + IV_MATNR + "'") +
     if(len(IV_MATKL)  == 0,""," and A.ZTEXT1 = '" + IV_MATKL + "'") + 
     if(len(IV_VBELN)  == 0,""," and LTRIM( A.vbeln,'0' ) = '" + IV_VBELN + "'") + 
     if(len(IV_ZDR)  == 0,""," and A.name_last = '" + IV_ZDR + "'") + 
     if(len(IV_ZXMBH)  == 0,""," and LTRIM( A.ZXMBH,'0' ) = '" + IV_ZXMBH + "'") + 
     if(len(IV_ZNAME)  == 0,""," and A.ZNAME = '" + IV_ZNAME + "'") + 
     if(len(IV_LGORT)  == 0,""," and A.lgobe IN ( '" + IV_LGORT + "' )") +
     if(len(IV_DL)  == 0,""," and A.ZDL IN ( '" + IV_DL + "' )") +
     if(len(IV_ZL)  == 0,""," and A.ZZL IN ( '" + IV_ZL + "' )") +
     if(len(IV_XL)  == 0,""," and A.ZXL IN ( '" + IV_XL + "' )") +
"order by BUTXT,werks,lgort,vbeln" )}

select 
    A.butxt as "公司名称",
    LTRIM( A.vbeln,'0' ) AS "单据号",
    LTRIM( A.posnr,'0' ) AS "单据行号",
    A.erdat as "订单日期",
    A.FKDAT as "发票日期",
    A.VTEXT as "部门",
    A.zywymc as "业务员",
    A.name_last as "制单员",
    A.lgobe as "仓库",
    LTRIM( A.kunag,'0' ) AS "客户编号",
    A.name1 as "客户名称",
    LTRIM( A.kunnr,'0' ) AS "终端客户编号",
    A.name2 as "终端客户名称",
    A.zname as "项目名称", 
    LTRIM( A.matnr,'0' ) AS "商品编码",
    A.ztext1 as "商品名称",
    A.EXTWG as "品牌",
    A.ZMODEL AS "规格",
    A.zscn AS "包装数量",
    A.MSEHL AS "单位",
    A.ZDL as "大类",
    A.ZZL as "中类",
    A.ZXL as "小类",
    A.fkimg as "数量",
    A.kzwi1 as "含税金额",
    round((kzwi1 / fkimg ),2) as "含税单价",
    A.NETWR as "未税金额",
    round((NETWR / fkimg ),2) as "未税单价",
    A.MWSBP as "税额",
    A.WAVWR as "成本金额（未税）",
    round((WAVWR / fkimg ),2) as "成本单价",
    (NETWR - WAVWR ) as "毛利额(未税)",
    round(((NETWR - WAVWR ) / NETWR ),2)as "毛利率(未税)"
   from "SAPHANADB"."ZSDV_FR_VBELN_VF" AS A
   where A.BUKRS IN ( '${IV_BUKRS}' ) 
   and fkimg <> 0
     ${if(type  == 'A',"and A.FKDAT >= '" + BEGINDATE + "'" + " and A.FKDAT <= '" + ENDDATE + "'","and A.ERDAT >= '" + BEGINDATE + "'" + " and A.ERDAT <= '" + ENDDATE + "'")}
     ${if(len(IV_KUNNR)  == 0,"","and LTRIM( A.kunnr,'0' ) = '" + IV_KUNNR + "'")} 
     ${if(len(IV_KUNAG)  == 0,"","and LTRIM( A.kunag,'0' ) = '" + IV_KUNAG + "'")} 
     ${if(len(IV_NAME1)  == 0,"","and A.NAME1 = '" + IV_NAME1 + "'")} 
     ${if(len(IV_NAME2)  == 0,"","and A.NAME2 = '" + IV_NAME2 + "'")} 
     ${if(len(IV_VTEXT)  == 0,"",if(len(IV_VTEXT2)  == 0," AND A.VTEXT IS NULL","and A.VTEXT = '" + IV_VTEXT + "'"))} 
     ${if(len(IV_YWY)  == 0,"","and A.ZYWYMC = '" + IV_YWY + "'")} 
     ${if(len(IV_MATNR)  == 0,"","and LTRIM( A.matnr,'0' ) = '" + IV_MATNR + "'")} 
     ${if(len(IV_MATKL)  == 0,"","and A.ZTEXT1 = '" + IV_MATKL + "'")} 
     ${if(len(IV_VBELN)  == 0,"","and LTRIM( A.vbeln,'0' ) = '" + IV_VBELN + "'")} 
     ${if(len(IV_ZDR)  == 0,"","and A.name_last = '" + IV_ZDR + "'")} 
     ${if(len(IV_ZXMBH)  == 0,"","and LTRIM( A.zxmbh,'0' ) = '" + IV_ZXMBH + "'")} 
     ${if(len(IV_ZNAME)  == 0,"","and A.zname = '" + IV_ZNAME + "'")} 
     ${if(len(IV_LGORT)  == 0,"","and A.lgobe IN ( '" + IV_LGORT + "' )")}
     ${if(len(IV_DL)  == 0,"","and A.ZDL IN ( '" + IV_DL + "' )")} 
     ${if(len(IV_ZL)  == 0,"","and A.ZZL = '" + IV_ZL + "'")} 
     ${if(len(IV_XL)  == 0,"","and A.ZXL = '" + IV_XL + "'")} 
order by BUKRS,werks,lgort,vbeln

