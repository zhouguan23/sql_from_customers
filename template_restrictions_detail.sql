SELECT 
*
FROM 
fine_intelli_focus_point
where 
time >= '${startdate1}'
and
time <='${enddate1}'
and
id= 'FR-F4002' 
and
title='template restriction'
and
text='${tname}'

