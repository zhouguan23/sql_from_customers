-- 每个项目单条查询
-- projectId 项目id
-- startTime 统计周期开始
-- endTime 统计周期截止
-- onLineTime 上线时间

SELECT 
a.projectid,c.projectname,date(b.createtime)createtime,
# 本周内情况
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and reporttime is not null THEN 1 ELSE 0 END) AS report_num, -- 报备成交客户
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and reporttime is not null and freshcardtime is not null THEN 1 ELSE 0 END) AS report_fresh_num, -- 报备刷证客户
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and reporttime is not null and freshcardtime is null AND riskapprovestatus <> 'null' THEN 1 ELSE 0 END) AS report_no_fresh_approve_num, -- 报备成交漏刷证已复核
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and reporttime is not null and freshcardtime is null AND riskapprovestatus = 'null' THEN 1 ELSE 0 END) AS report_no_fresh_no_approve_num, -- 报备成交漏刷证未复核
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and riskstatus = 'RISK' THEN 1 ELSE 0 END) AS risk_count, -- 疑似风险
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and riskstatus  = 'RISK' AND riskapprovestatus = 'null' THEN 1 ELSE 0 END) AS judge_no_approve, -- 待复核
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and riskstatus = 'RISK' AND riskapprovestatus = 'NORMAL' THEN 1 ELSE 0 END) AS approve_normal_count, -- 复核为正常
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and riskstatus = 'RISK' AND riskapprovestatus = 'RISK' THEN 1 ELSE 0 END) as approve_risk_count, -- 确认风险
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and riskstatus = 'NORMAL' AND riskapprovestatus = 'RISK' THEN 1 ELSE 0 END) as normal_approve_risk_count, -- 初判正常确认风险
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') THEN 1 ELSE 0 END) as unknown_count, -- 未知客户总数
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') AND riskapprovestatus = 'NORMAL' THEN 1 ELSE 0 END) as unknown_approve_normal_count, -- 未知客户复核为正常
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') AND riskapprovestatus = 'RISK' THEN 1 ELSE 0 END) as unknown_approve_risk_count, -- 未知客户复核为风险

sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') and freshcardtime is not null and firstphototime is null and riskapprovestatus = 'NORMAL' THEN 1 ELSE 0 END) as unknown_fresh_no_snap_approve_normal_count, -- 未知客户已刷证无抓拍复核为正常
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') and freshcardtime is not null and firstphototime is null and riskapprovestatus = 'RISK' THEN 1 ELSE 0 END) as unknown_fresh_no_snap_approve_risk_count, -- 未知客户已刷证无抓拍复核为风险
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') and freshcardtime is not null and firstphototime is null and riskapprovestatus = 'null' THEN 1 ELSE 0 END) as unknown_fresh_no_snap_no_approve_count, -- 未知客户已刷证无抓拍未复核
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') and freshcardtime is null and riskapprovestatus = 'NORMAL' THEN 1 ELSE 0 END) as unknown_no_fresh_approve_normal_count, -- 未知客户无刷证记录复核为正常
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') and freshcardtime is null and riskapprovestatus = 'RISK' THEN 1 ELSE 0 END) as unknown_no_fresh_approve_risk_count, -- 未知客户无刷证记录复核为风险
sum(CASE WHEN date(finishTime) BETWEEN '${sdate}' AND '${edate}' and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') and freshcardtime is null and riskapprovestatus = 'null' THEN 1 ELSE 0 END) as unknown_no_fresh_no_approve_count, -- 未知客户无刷证记录未复核

# 累计情况（自上线开始统计）																				
sum(CASE WHEN date(finishTime) > date(b.createtime) and reporttime is not null THEN 1 ELSE 0 END) AS total_report, -- 累计报备成交客户
sum(CASE WHEN date(finishTime) > date(b.createtime) and reporttime is not null and freshcardtime is not null THEN 1 ELSE 0 END) AS total_report_fresh, -- 累计报备刷证客户
sum(CASE WHEN date(finishTime) > date(b.createtime) and reporttime is not null and freshcardtime is null and riskapprovestatus <> 'null' THEN 1 ELSE 0 END) AS total_report_no_fresh_approve, -- 累计报备成交漏刷证客户已复核
sum(CASE WHEN date(finishTime) > date(b.createtime) and reporttime is not null and freshcardtime is null and riskapprovestatus = 'null' THEN 1 ELSE 0 END) AS total_report_no_fresh_no_approve, -- 累计报备成交漏刷证客户未复核
sum(CASE WHEN date(finishTime) > date(b.createtime) and riskstatus = 'RISK' THEN 1 ELSE 0 END) AS total_risk, -- 累计 疑似风险
sum(CASE WHEN date(finishTime) > date(b.createtime) and riskstatus = 'RISK' and  riskapprovestatus = 'null' THEN 1 ELSE 0 END) AS total_risk_no_approve, -- 累计 待复核疑似风险客户总数
sum(CASE WHEN date(finishTime) BETWEEN date(b.createtime) and DATE_SUB(NOW(), INTERVAL 7 DAY) and  riskstatus = 'RISK' and  riskapprovestatus = 'null' THEN 1 ELSE 0 END) AS 7_days_risk_no_approve, -- 累计 待复核疑似风险客户，其中超过7天
sum(CASE WHEN date(finishTime) > date(b.createtime) and riskstatus = 'RISK' and riskapprovestatus = 'NORMAL' THEN 1 ELSE 0 END) AS total_approve_normal, -- 累计 基于疑似风险复核为正常
sum(CASE WHEN date(finishTime) > date(b.createtime) and riskstatus = 'RISK' and riskapprovestatus = 'RISK' THEN 1 ELSE 0 END) AS total_approve_risk, -- 累计 基于疑似风险确认风险
sum(CASE WHEN date(finishTime) > date(b.createtime) and riskstatus = 'NORMAL' AND riskapprovestatus = 'RISK' THEN 1 ELSE 0 END) AS total_normal_approve_risk_num,  -- 累计初判正常确认风险
sum(CASE WHEN date(finishTime) > date(b.createtime) and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') THEN 1 ELSE 0 END) as total_unknown_count, -- 累计未知客户总数
sum(CASE WHEN date(finishTime) > date(b.createtime) and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') AND riskapprovestatus = 'NORMAL' THEN 1 ELSE 0 END) as total_unknown_approve_normal_count, -- 累计未知客户复核为正常
sum(CASE WHEN date(finishTime) > date(b.createtime) and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') AND riskapprovestatus = 'RISK' THEN 1 ELSE 0 END) as total_unknown_approve_risk_count, -- 累计未知客户复核为风险
sum(CASE WHEN date(finishTime) > date(b.createtime) and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') AND riskapprovestatus = 'NORMAL' and freshcardtime is not null and firstphototime is null THEN 1 ELSE 0 END) as total_unknown_fresh_no_snap_approve_normal_count, -- 累计未知客户已刷证无抓拍复核为正常
sum(CASE WHEN date(finishTime) > date(b.createtime) and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') AND riskapprovestatus = 'RISK' and freshcardtime is not null and firstphototime is null THEN 1 ELSE 0 END) as total_unknown_fresh_no_snap_approve_risk_count, -- 累计未知客户已刷证无抓拍复核为风险
sum(CASE WHEN date(finishTime) > date(b.createtime) and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') AND riskapprovestatus = 'null' and freshcardtime is not null and firstphototime is null THEN 1 ELSE 0 END) as total_unknown_fresh_no_snap_no_approve_count, -- 累计未知客户已刷证无抓拍未复核
sum(CASE WHEN date(finishTime) > date(b.createtime) and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') AND riskapprovestatus = 'NORMAL' and freshcardtime is null THEN 1 ELSE 0 END) as total_unknown_no_fresh_approve_normal_count, -- 累计未知客户无刷证复核为正常
sum(CASE WHEN date(finishTime) > date(b.createtime) and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') AND riskapprovestatus = 'RISK' and freshcardtime is null THEN 1 ELSE 0 END) as total_unknown_no_fresh_approve_risk_count, -- 累计未知客户无刷证复核为风险
sum(CASE WHEN date(finishTime) > date(b.createtime) and (riskstatus = 'UNKNOWN' or riskstatus ='NULL') AND riskapprovestatus = 'null' and freshcardtime is null THEN 1 ELSE 0 END) as total_unknown_no_fresh_no_approve_count -- 累计未知客户无刷证未复核

from f_risk_facedetectcustomer a
left join (select distinct projectid,createtime from f_risk_facedetectbaseconfig) b on a.projectid = b.projectid
left join (select distinct id,name projectname from f_risk_project )c on a.projectid = c.id
where 1=1 
-- AND right(b.projectId,1)<>'_'
-- and c.projectname is not null
group by 
a.projectid,c.projectname,date(b.createtime)

