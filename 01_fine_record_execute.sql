select *,todate(time) ddate from fine_record_execute
where userrole !='superusers'
order by time desc

select tname,displayName,todate(time) ddate,username,userrole from fine_record_execute
where userrole !='superusers'
order by time desc

