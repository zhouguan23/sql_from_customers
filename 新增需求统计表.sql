select * from f_report_summary
where 1=1
${if(len(module)=0,"","and module in ('"+module+"')")}
${if(len(sdate)=0,"","and pull_time >= '"+sdate+"'")}
${if(len(edate)=0,"","and pop_time <= '"+edate+"'")}

select distinct module from f_report_summary

