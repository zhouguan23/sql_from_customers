
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
    butxt as \"????????????\",
    LTRIM( A.vbeln,'0' ) AS \"?????????\",
    LTRIM( A.posnr,'0' ) AS \"????????????\",
    A.erdat as \"????????????\",
    A.FKDAT as \"????????????\",
    A.VTEXT as \"??????\",
    A.zywymc as \"?????????\",
    A.name_last as \"?????????\",
    A.lgobe as \"??????\",
    LTRIM( A.kunag,'0' ) AS \"????????????\",
    A.name1 as \"????????????\",
    LTRIM( A.kunnr,'0' ) AS \"??????????????????\",
    A.name2 as \"??????????????????\",
    A.zname as \"????????????\", 
    LTRIM( A.matnr,'0' ) AS \"????????????\",
    A.ztext1 as \"????????????\",
    A.EXTWG as \"??????\",
    A.ZMODEL AS \"??????\",
    A.zscn AS \"????????????\",
    A.MSEHL AS \"??????\",
    A.ZDL as \"??????\",
    A.ZZL as \"??????\",
    A.ZXL as \"??????\",
    A.fkimg as \"??????\",
    A.kzwi1 as \"????????????\",
    round((kzwi1 / fkimg ),2) as \"????????????\",
    A.NETWR as \"????????????\",
    round((NETWR / fkimg ),2) as \"????????????\",
    A.MWSBP as \"??????\",
    A.WAVWR as \"????????????????????????\",
    round((WAVWR / fkimg ),2) as \"????????????\",
    (NETWR - WAVWR ) as \"?????????(??????)\",
    round(((NETWR - WAVWR ) / NETWR ),2)as \"?????????(??????)\"
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
    butxt as \"????????????\",
    LTRIM( A.vbeln,'0' ) AS \"?????????\",
    LTRIM( A.posnr,'0' ) AS \"????????????\",
    A.erdat as \"????????????\",
    A.FKDAT as \"????????????\",
    A.VTEXT as \"??????\",
    A.zywymc as \"?????????\",
    A.name_last as \"?????????\",
    A.lgobe as \"??????\",
    LTRIM( A.kunag,'0' ) AS \"????????????\",
    A.name1 as \"????????????\",
    LTRIM( A.kunnr,'0' ) AS \"??????????????????\",
    A.name2 as \"??????????????????\",
    A.zname as \"????????????\", 
    LTRIM( A.matnr,'0' ) AS \"????????????\",
    A.ztext1 as \"????????????\",
    A.EXTWG as \"??????\",
    A.ZMODEL AS \"??????\",
    A.zscn AS \"????????????\",
    A.MSEHL AS \"??????\",
    A.ZDL as \"??????\",
    A.ZZL as \"??????\",
    A.ZXL as \"??????\",
    A.fkimg as \"??????\",
    A.kzwi1 as \"????????????\",
    round((kzwi1 / fkimg ),2) as \"????????????\",
    A.NETWR as \"????????????\",
    round((NETWR / fkimg ),2) as \"????????????\",
    A.MWSBP as \"??????\"
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
    A.butxt as "????????????",
    LTRIM( A.vbeln,'0' ) AS "?????????",
    LTRIM( A.posnr,'0' ) AS "????????????",
    A.erdat as "????????????",
    A.FKDAT as "????????????",
    A.VTEXT as "??????",
    A.zywymc as "?????????",
    A.name_last as "?????????",
    A.lgobe as "??????",
    LTRIM( A.kunag,'0' ) AS "????????????",
    A.name1 as "????????????",
    LTRIM( A.kunnr,'0' ) AS "??????????????????",
    A.name2 as "??????????????????",
    A.zname as "????????????", 
    LTRIM( A.matnr,'0' ) AS "????????????",
    A.ztext1 as "????????????",
    A.EXTWG as "??????",
    A.ZMODEL AS "??????",
    A.zscn AS "????????????",
    A.MSEHL AS "??????",
    A.ZDL as "??????",
    A.ZZL as "??????",
    A.ZXL as "??????",
    A.fkimg as "??????",
    A.kzwi1 as "????????????",
    round((kzwi1 / fkimg ),2) as "????????????",
    A.NETWR as "????????????",
    round((NETWR / fkimg ),2) as "????????????",
    A.MWSBP as "??????",
    A.WAVWR as "????????????????????????",
    round((WAVWR / fkimg ),2) as "????????????",
    (NETWR - WAVWR ) as "?????????(??????)",
    round(((NETWR - WAVWR ) / NETWR ),2)as "?????????(??????)"
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

