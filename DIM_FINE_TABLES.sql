select a.displayname,b.dept,b.catalogue,a.path from gygd_fine.fine_authority_object  a
left join  fine_report_list b
on to_char(a.path)=b.path
where devicetype<>'0'
and nvl(a.path,'mob')  not like 'mob%'
and upper(a.path)  not like '%DIM%'
and a.path not like '%国大药房驾驶舱%'
and to_char(a.path) not in ('GYGD/DISPLAY/SALE/Mom_Business_Situation.cpt','tmp/offline_data_check.cpt','tmp/userinfo.cpt')
and 1=1
${if(len(dept) = 0, "", " and nvl(b.dept,'空') in ('" + dept + "')")}


select distinct nvl(dept,'空') dept from fine_report_list

