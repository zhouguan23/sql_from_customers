select sum(plugin_price*(pro_amount/pro_price))amount from sale_contract_info
left join sale_contract_of_product on pro_contract=ctr_id
left join cust_company on com_id=ctr_company
join `product_plugins` on pro_plugins regexp plugin_pluginid /*and plugin_pluginid regexp "com.tptj.plugin."*/
where year(ctr_signdate)=2019

select sum(plugin_price*(pro_amount/pro_price))amount from sale_contract_info
left join sale_contract_of_product on pro_contract=ctr_id
left join cust_company on com_id=ctr_company
join `product_plugins` on pro_plugins regexp plugin_pluginid /*and plugin_pluginid regexp "com.tptj.plugin."*/
where year(ctr_signdate)=2019
and plugin_pluginid in (${id})

SELECT count(*)/*CONCAT("SLN-",issuenum)jirakey,summary,it.pname,pn.STRINGVALUE,date(ks.DATEVALUE) kstart,date(ke.DATEVALUE) kend,date(ys.DATEVALUE) ystart,date(ye.DATEVALUE) yend,date(tt.DATEVALUE)ttime,TIMEORIGINALESTIMATE pretime*/
from jira.jiraissue j
LEFT JOIN jira.customfieldvalue ks on j.id=ks.ISSUE and ks.CUSTOMFIELD=10302/*开发开始时间*/
LEFT JOIN jira.customfieldvalue ke on j.id=ke.ISSUE and ke.CUSTOMFIELD=10303
/*开发完成时间*/
LEFT JOIN jira.customfieldvalue ys on j.id=ys.ISSUE and ys.CUSTOMFIELD=11315
/*预估开始时间（二开专用）*/
LEFT JOIN jira.customfieldvalue ye on j.id=ye.ISSUE and ye.CUSTOMFIELD=10904
/*开发截止时间*/
LEFT JOIN jira.customfieldvalue pn on j.id=pn.ISSUE and pn.CUSTOMFIELD=10441
/*项目id*/
LEFT JOIN jira.customfieldvalue tt on j.id=tt.ISSUE and tt.CUSTOMFIELD=10819
/*统一完成时间*/
LEFT JOIN jira.nodeassociation on j.id=SOURCE_NODE_ID and sink_node_entity="Component"
LEFT JOIN jira.issuestatus it on issuestatus=it.ID
where PROJECT=10303 and SINK_NODE_ID=11122
and year(tt.DATEVALUE)=2019
and it.pname ='验收完成'
ORDER BY issuenum desc

select sum(unit_price) from fr_shop_uc_order_info where order_state=4 and year(timestmap)=2019

select sum(unit_price) from fr_shop_uc_order_info where order_state=4 and seller_id not in (1,66,67) and year(timestmap)=2019

SELECT a.*,key_id,customer_id,opportunity_name,concat(E.user_name,"(",E.user_username,")")salesman,projectmanager,prj_number,com_name from product_outspays a
LEFT JOIN project_opportunity1 on prouts_project=key_id
left join hr_user E on prj_salesman=E.user_username
left join cust_company on customer_id=com_id
where prj_createdate>='2019-01-01' and  prj_createdate<='2019-12-31'

SELECT CONCAT("SLN-",issuenum)jirakey,summary,it.pname,pn.STRINGVALUE,date(ks.DATEVALUE) kstart,date(ke.DATEVALUE) kend,date(ys.DATEVALUE) ystart,date(ye.DATEVALUE) yend,date(tt.DATEVALUE)ttime,TIMEORIGINALESTIMATE pretime from jira.jiraissue j
LEFT JOIN jira.customfieldvalue ks on j.id=ks.ISSUE and ks.CUSTOMFIELD=10302
LEFT JOIN jira.customfieldvalue ke on j.id=ke.ISSUE and ke.CUSTOMFIELD=10303
LEFT JOIN jira.customfieldvalue ys on j.id=ys.ISSUE and ys.CUSTOMFIELD=11315
LEFT JOIN jira.customfieldvalue ye on j.id=ye.ISSUE and ye.CUSTOMFIELD=10904
LEFT JOIN jira.customfieldvalue pn on j.id=pn.ISSUE and pn.CUSTOMFIELD=10441
LEFT JOIN jira.customfieldvalue tt on j.id=tt.ISSUE and tt.CUSTOMFIELD=10819

LEFT JOIN jira.nodeassociation on j.id=SOURCE_NODE_ID and sink_node_entity="Component"
LEFT JOIN jira.issuestatus it on issuestatus=it.ID
where PROJECT=10303 and SINK_NODE_ID=11122 and pname='验收完成'

select count(*) from jira.jiraissue a left join jira.nodeassociation b on a.id=b.SOURCE_NODE_ID 
left join jira.component c on c.id=b.sink_node_id where c.cname='第三方插件'  
and issuetype=10402

select *,month(datevalue) month from
(select *,case when ((year(datevalue)=2017 and month(datevalue)>=6 or year(datevalue)>2017)and jira_keys not in ("SLN-158","SLN-157","SLN-155","SLN-303")) and label="已开发完成" then 3000 when label="现场开发" then 5000  else 1500  end price from(
select CONCAT("SLN-",issuenum)jira_keys,TIMEORIGINALESTIMATE/3600/8 day,if(b.STRINGVALUE ='jack.zhu',"jack",if(b.STRINGVALUE ="justin@finereport.com","justin",if(b.STRINGVALUE ="michael.jiang","michael",if(b.STRINGVALUE ="kelak.lu","kelak",b.STRINGVALUE)))) salesman,d.STRINGVALUE com_id,date(e.datevalue) datevalue,f.STRINGVALUE kaifa,c.label,date(created) startdate,finish_date2 from  jira.jiraissue a
LEFT JOIN jira.customfieldvalue b on a.id=b.issue
LEFT JOIN jira.customfieldvalue d on a.id=d.issue
LEFT JOIN jira.customfieldvalue e on a.id=e.issue
LEFT JOIN jira.customfieldvalue f on a.id=f.issue
LEFT JOIN jira.label c on a.id=c.issue and label in ('开发者联盟')
left join (select max(CREATED) finish_date2,issueid from jira.changeitem
left join jira.changegroup on changegroup.ID=groupid
where field="status" and newstring="验收完成" and oldstring="二次开发验收"
group by issueid)g on g.issueid=a.id
where project=10303 
and b.CUSTOMFIELD=10439 and d.CUSTOMFIELD=10504 and e.CUSTOMFIELD=10303 and f.CUSTOMFIELD=10435 
and c.label is not null
)s
where 1=1 
and date(finish_date2)>='2019-01-01'
and date(finish_date2)<='2019-12-31'
)ss
order by salesman

select *,concat(scd_year,if(scd_season=4,"-","-0"),scd_season*3)ym from finan_second_cost


select bug_id,fr_system_id,bugtitle,bugscene,bugkind,bugmodule,creator,createdate,history,ifconsider,demand_mark,charger,bugstatus from fr_t_system1 as s 
left join fr_t_p_demand as d on s.FR_SYSTEM_ID=d.bugid
where 1=1
and (d.categoryid is null or d.categoryid="")
and (s.BUGSTATUS in('周期设置','需求仓库-产品组','客户需求沟通','进入需求规划','产品待处理','需求仓库',"") or s.BUGSTATUS is null)
and (s.jira_keys is null or s.jira_keys="")
 and s.BUGKIND = '客户需求'
and s.BUGMODULE in ("报表","图表","平台")
and bugstatus in('需求仓库','进入需求规划') 
and year(CREATEDATE)=2019

select count(*) from (SELECT a.*
FROM `func_file_upload` a 
left join func_use_log b on a.file_id=b.fileid 
left join func_msg c on b.funcid=c.funcid 
where c.funcstyle=2/*插件*/ and year(usetime)=2019
group by file_company
)a

SELECT ftp.user_id,fp.pluginid,fp.name,fp.sellerid,ftp.download_time,ftp.price,product_id,ftp.state
FROM fr_t_psdownloadrecord AS ftp 
LEFT JOIN fr_t_product AS fp ON ftp.product_id = fp.id
WHERE user_id is not null and fp.price>0 and sellerid not in (1,66,67)
and year(download_time)=2019
UNION
SELECT purchaser_id,fp.pluginid,name,fp.sellerid,timestmap,unit_price,product_id,1 AS state
FROM fr_shop_uc_order_info AS fs
LEFT JOIN fr_t_product AS fp ON fp.id = fs.product_id 
WHERE order_state>=4 and sellerid not in (1,66,67)
and year(timestmap)=2019

select uid,mobile from pre_common_member_profile  where mobile is not null and mobile <>'' 
and mobile in (${mobile})


select sum(commission) total_price from (SELECT b.commission,b.effectiveDate,b.userID,b.workload,c.name,a.* FROM `secdevosproject` a
left join secdevosbiddetails b on b.winningBid = 1 and a.slnNum = b.slnNum
LEFT JOIN secdevosuser c on b.userID = c.userID
where a.status = '完成' and year(b.effectiveDate)=2019
order by a.slnNum asc)aa

