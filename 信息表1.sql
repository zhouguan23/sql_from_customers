SELECT
a.ID,a.NAME,b.tname,d.pname,e.pname2
from 
(
SELECT DISTINCT ID,NAME from FR_USER2
)a
LEFT JOIN 
(
SELECT ID,
WM_CONCAT(TNAME) tname
from FR_TYPE
GROUP BY ID
) b on a.ID = b.id
LEFT JOIN 
(
SELECT id,
WM_CONCAT(project_name) pname
from fr_project
GROUP BY id
 )d
on  a.ID = d.id
LEFT JOIN 
(
SELECT user_id,
WM_CONCAT(properson_name) pname2
from fr_properson
GROUP BY user_id
)e on a.ID = e.user_id
where 1=1
 ${if(len(name)==0,""," and  a.ID ='"+name+"'")}
 ${if(len(type)==0,"","and a.ID in(SELECT id from fr_type where tid ='"+type+"')")}
 ${if(len(pname)==0,"","and a.ID in (SELECT id from fr_project where project_id ='"+pname+"')")}
 ${if(len(properson)==0,"","and a.ID in (SELECT user_id from fr_properson where  properson_id ='"+properson+"')")}

