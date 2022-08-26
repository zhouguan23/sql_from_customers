SELECT 
DISTINCT (CODE) AS CODE
FROM `users_product_lists`
WHERE CODE <> ''
and QRGANIZATION_CODE IN ( 'IV_BUKRS' )
${if(len(IV_NAME)  == 0,"","and NAME IN ('" + IV_NAME + "')")}
${if(len(IV_ATTRIBUTE)  == 0,"","and ATTRIBUTE IN ('" + IV_ATTRIBUTE + "')")}
${if(len(IV_PRODUCT_GROUP)  == 0,"","and PRODUCT_GROUP IN ('" + IV_PRODUCT_GROUP + "')")}

SELECT a.id,a.username,a.realname,b.roleid,c.description,
       D.BUKRS,D.WERKS,D.price
FROM fine_user a
INNER JOIN fine_user_role_middle b on a.id = b.userid
inner join fine_custom_role c on c.id = b.roleid
left join PUBLIC.CUSTOM_ROLE_PARAMETER as d on d.role_id = c.name 
where a.username='${fine_username}'
AND D.BUKRS <> ''
order by d.bukrs

SELECT bukrs,BUTXT 
FROM "SAPHANADB"."T001" 
WHERE BUKRS >= '1000' AND BUKRS <= '9999' 
and bukrs IN ( '${IV_BUKRS_c}' )

SELECT 
DISTINCT(PROJECT_NAME) AS PROJECT_NAME
FROM users_company
WHERE PROJECT_NAME <> ''
AND QRGANIZATION_CODE IN ('${IV_BUKRS}')


SELECT 
DISTINCT (NAME) AS NAME
FROM users_company
WHERE NAME <> ''
and QRGANIZATION_CODE IN ( '${IV_BUKRS}' )



SELECT QRGANIZATION_CODE, CODE, G_NAME, product_desc, PRODUCT_GROUP, ATTRIBUTE,
       COST_PRICE, NOW_PRICE, STORAGE, QYGPRICE
  FROM users_product_lists
 WHERE QRGANIZATION_CODE IN ( '${IV_BUKRS}' ) AND CODE <> ''
${if(len(IV_PROJECTNAME) == 0,"","and PROJECT_NAME IN ( '" + IV_PROJECTNAME + "' )")}
${if(len(IV_NAME) == 0,"","and NAME IN ( '" + IV_NAME + "' )")}
${if(len(IV_CODE) == 0,"","and CODE IN ( '" + IV_CODE + "' )")}
${if(len(IV_PRODUCT_GROUP) == 0,"","and PRODUCT_GROUP IN ( '" + IV_PRODUCT_GROUP + "' )")}
${if(len(IV_ATTRIBUTE) == 0,"","and ATTRIBUTE IN ( '" + IV_ATTRIBUTE + "' )")}

SELECT
QRGANIZATION_CODE,
CODE,
CONCAT_WS('-',NAME,PROJECT_NAME) AS UNICODE,
PRICE
FROM users_product_lists
WHERE QRGANIZATION_CODE IN ( '${IV_BUKRS}' )
AND CODE <> ''
${if(len(IV_PROJECTNAME) == 0,"","and PROJECT_NAME IN ( '" + IV_PROJECTNAME + "' )")}
${if(len(IV_NAME) == 0,"","and NAME IN ( '" + IV_NAME + "' )")}
${if(len(IV_CODE) == 0,"","and CODE IN ( '" + IV_CODE + "' )")}
${if(len(IV_PRODUCT_GROUP) == 0,"","and PRODUCT_GROUP IN ( '" + IV_PRODUCT_GROUP + "' )")}
${if(len(IV_ATTRIBUTE) == 0,"","and ATTRIBUTE IN ( '" + IV_ATTRIBUTE + "' )")}

SELECT 
DISTINCT (PRODUCT_GROUP) AS PRODUCT_GROUP
FROM `users_product_lists`
WHERE PRODUCT_GROUP <> ''
and QRGANIZATION_CODE IN ( '${IV_BUKRS}' )
${if(len(IV_NAME)  == 0,"","and NAME IN ('" + IV_NAME + "')")}
${if(len(IV_ATTRIBUTE)  == 0,"","and NAME IN ('" + IV_ATTRIBUTE + "')")}

SELECT 
DISTINCT (ATTRIBUTE) AS ATTRIBUTE
FROM `users_product_lists`
WHERE ATTRIBUTE <> ''
and QRGANIZATION_CODE IN ( '${IV_BUKRS}' )
${if(len(IV_NAME)  == 0,"","and NAME IN ('" + IV_NAME + "')")}
${if(len(IV_PRODUCT_GROUP)  == 0,"","and PRODUCT_GROUP IN ('" + IV_PRODUCT_GROUP + "')")}

