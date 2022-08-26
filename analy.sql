SELECT * FROM fine_record_execute where 
time > ${start} 
and time <= ${end} 
${if(len(tname) == 0, '', "and tname = '" + tname + "'")}
order by time desc

SELECT * FROM fine_record_execute where 
time > 1596236400000
order by time desc

