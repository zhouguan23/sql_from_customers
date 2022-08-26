select * from fr_t_p_category where 1=1 ${if(mod>0,"and id like concat(LPAD("+mod+",3,0),'%')", "")} 
${if(len(cate)=0,"", " and id ='"+cate+"'")} 
order by parent

SELECT id as categoryid,categoryid as categoryid1, count(bugid) as allnum, 
sum(a.BUGKIND = '客户需求') as cdnum, 
count(distinct a.COMPANY) as ccnum, 
sum(POW(3,(a.BUGKIND = '客户需求') + (6-priority2) - 2) * (((a.BUGKIND = '客户需求') + 6 - priority2) > 1)) as pri from 
(
select bug_id,bugid,priority,categoryid,bugkind,company,bugstatus,ifnull(priority,3)priority2,c.id,name FROM fr_t_p_demand t1 
left join fr_t_system1 t2 on (t1.bugid = t2.FR_SYSTEM_ID) 
left join fr_t_p_category c on concat(",",categoryid,",") regexp concat(",",c.id,",")
where (bugkind = '客户需求' or bugkind = '一般需求') and categoryid is not null and length(categoryid)>0 and 
(t2.bugstatus not in ('创建者验收','创建者补充','被否决','验收完成','已解决','关闭','BUG已解决') or t2.bugstatus is null)
${if(mod>0,"and categoryid like concat(LPAD("+mod+",3,0),'%') and categoryid != LPAD("+mod+",3,0)", "")} 
${if(len(ifconsider)=0||ifconsider=0,""," and find_in_set(ifconsider,'"+ifconsider+"')")}
${if(ifconsider=0," and (ifconsider is null or length(ifconsider)=0)","")}
)a
group by id 
order by pri


select * from fr_t_p_category where 1=1  ${if(mod>0,"and id like concat(LPAD("+mod+",3,0),'%') ", "")} order by parent

(select concat("在当前 ",version,"版本 计划中")consider from ver_devplan where project=${if(mod="6"||mod="10","'BI'",if(mod="9","'移动端'","'报表'"))} order by startdate desc limit 1,1)
UNION
(select concat("在下一个 ",version,"版本 待考虑列表内") from ver_devplan where project=${if(mod="6"||mod="10","'BI'",if(mod="9","'移动端'","'报表'"))} order by startdate desc limit 1)
UNION
(select "6个月后可能考虑")
UNION
(select "1年内不考虑")

select "3" val,"FR图表"name
union
select "10","BI图表"
union
select "7","报表"
union
select "6","BI"
union
select "9","移动端"
union
select "11","平台"


