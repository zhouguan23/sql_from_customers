SELECT * FROM FINE_USER_POWER

select username,realname
from
fine_user
where 1=1
${if(len(user)=0,"","and username  in('"+user+"') ")}



