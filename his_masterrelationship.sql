select a.snapshotyear 年,a.snapshotmonth 月,re.regionname 省,b.orgcode 客户编码,b.orgname 客户名称,
c.prodcode 产品编码,d.prdn 产品名称,e.areacode 地区编码,e.areaname 地区,
g.username 员工编码,g.employeename 员工姓名,
h.valuename 是否目标,i.valuename 经营模式
from his_masterrelationship a 
left join organization b on a.orgid=b.orgid
left join region re on b.regioncode=re.regioncode and re.languagecode='cn'
left join product c on a.prodid=c.prodid
left join productlang d on a.prodid=d.prodid and d.languagecode='cn'
left join businessarea e on a.businessareaid=e.areaid
left join usr g on a.userid=g.userid 
left join dictionary h on a.istarget=h.value and h.type='YesOrNo' and h.languagecode='cn'
left join dictionary i on a.saleschannelid=i.value and i.type='BusinessModelQZ' and i.languagecode='cn'
where 1=1  --a.snapshotyear=${年} and a.snapshotmonth=${月} and re.regionname ='${省}'
 ${IF(LEN(客户编码)==0,""," and b.orgcode ='"+客户编码+"'")}
 ${IF(LEN(客户名称)==0,""," and b.orgname like '%"+客户名称+"%'")}
 ${IF(LEN(产品编码)==0,""," and c.prodcode = '"+产品编码+"'")}
order by b.orgcode,c.prodcode


