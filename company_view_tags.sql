SELECT 
LEFT(tags_code,1) AS tags_code_1,
CASE WHEN tags_code like '%-%' THEN substring_index(tags_code,"-",1) ELSE tags_code END AS tags_code_2,
CASE WHEN tags_code like '%-%' THEN tags_code ELSE "" END AS tags_code_3
FROM cust_company
LEFT JOIN dict_tags ON concat(',',com_tags,',') regexp concat(',',tags_code,',')
WHERE com_id = '${comid}' and length(tags_code) > 0
/*测试公司id:8c17f8df-3a08-43bf-9bf8-1ac5bbfd651f*/

SELECT count(com_id) AS num FROM cust_company
where com_verified = 'valid'
and com_id <> '${comid}'
${if(len(tags)=0,"and 1=2","and (concat(com_tags,',') regexp trim('"+tags+",')
or concat(com_tags,'-') regexp trim('"+replace(tags,',','-')+"-'))")}

