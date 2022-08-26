SELECT otb.*,ntb.counts,group_concat(c.tag_username)username,d.group_name
FROM hr_tags_group otb
JOIN  (SELECT tags_group_year,department_id,industry_id,product_id,region_id,stage,
    COUNT(*) AS counts
    FROM hr_tags_group 
    GROUP BY tags_group_year,department_id,industry_id,product_id,region_id,stage) ntb 
ON otb.tags_group_year=ntb.tags_group_year
AND otb.department_id=ntb.department_id
AND IFNUll(otb.industry_id,'NA')=IFNULL(ntb.industry_id,'NA')
AND IFNULL(otb.product_id,'NA')=IFNULL(ntb.product_id,'NA')
AND IFNULL(otb.region_id,'NA')=IFNUll(ntb.region_id,'NA')
and IFNULL(otb.stage,'NA')=IFNUll(ntb.stage,'NA')
left join hr_user b on user_department=otb.department_id
left join hr_user_tags c on b.user_username=c.tag_username 
and (c.tag_industry_id=ifnull(otb.industry_id,43) or otb.industry_id is null or LENGTH(otb.industry_id)=0) 
and (c.tag_product_id=ifnull(otb.product_id,44) or otb.product_id is null or LENGTH(otb.product_id)=0)
and (c.tag_region_id=ifnull(otb.region_id,45)or otb.region_id is null or LENGTH(otb.region_id)=0)
and (c.tag_stage_id=ifnull(otb.stage,45)or otb.stage is null or LENGTH(otb.stage)=0)
left join hr_group d on d.group_id=otb.group_id
WHERE   user_state='在职'
${if(len(y)=0,""," and otb.tags_group_year in('"+y+"')")}
${if(len(d)=0,""," and otb.department_id in("+d+")")}
${if(len(g)=0,""," and otb.group_id in("+g+")")}
${if(len(i)=0,""," and otb.industry_id in("+i+")")}
${if(len(p)=0,""," and otb.product_id in("+p+")")}
${if(len(r)=0,""," and otb.region_id in("+r+")")}
group by otb.tags_group_id
ORDER BY group_id,department_id

SELECT year(curdate())y union
SELECT year(curdate())-1 union
SELECT year(curdate())-2

SELECT * 
FROM hr_group
WHERE group_verified='valid'

SELECT *
FROM hr_tags
WHERE tags_type='行业'

SELECT *
FROM hr_tags
WHERE tags_type='产品线'

SELECT *
FROM hr_tags
WHERE tags_type='区域'

SELECT * FROM hr_tags where tags_type='阶段'

