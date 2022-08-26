select m.userid, u.username, u.employeename, m.businessareaid deptid, dept.areaname,m.orgid, org.orgcode, org.orgname, org.customerproperty, region.regioncode,region.regionname,city.citycode,city.cityname,
m.prodid, p.prodcode, cl.categoryid, cl.catn, pl.prdn, p.spec,
m.saleschannelid,m.istarget
from masterrelationship m --五者关系
left join usr u on m.userid=u.userid --用户
left join businessarea dept on m.businessareaid=dept.areaid --业务区域
left join organization org on m.orgid=org.orgid --客户
left join region on org.regioncode=region.regioncode --省
left join city on org.citycode=city.citycode --市
left join product p on m.prodid=p.prodid --产品
left join categorylang cl on p.categoryid=cl.categoryid and cl.languagecode='cn' --产品大类
left join productlang pl on m.prodid=pl.prodid and pl.languagecode='cn' --产品语言
where --u.username='${fine_username}' 
1=1 --and m.businessareaid='${dept}' 
${if(len(dept)=0,"","and m.businessareaid in ('"+dept+"')")}
${if(len(regioncode)=0,"","and region.regioncode in ('"+regioncode+"')")}
--and region.regioncode='${regioncode}' 
${if(len(citycode)=0,"","and city.citycode in ('"+citycode+"')")}
${if(len(prodcode)=0,"","and p.prodcode in ('"+prodcode+"')")}
--and m.saleschannelid in ('${saleschannelid}')
${if(len(istarget)=0,"","and m.istarget in ('"+istarget+"')")} 
${if(len(orgcode)=0,"","and org.orgcode in ('"+orgcode+"')")} 
order by org.orgcode,p.prodcode

select m.userid, u.username, u.employeename, m.businessareaid deptid, dept.areaname,m.orgid, org.orgcode, org.orgname, org.globalpccode, region.regionname,region.regioncode, city.cityname
from masterrelationship m --五者关系
left join usr u on m.userid=u.userid --用户
left join businessarea dept on m.businessareaid=dept.areaid --业务区域
left join organization org on m.orgid=org.orgid --客户
left join region on org.regioncode=region.regioncode --省
left join city on org.citycode=city.citycode --市
--where u.username='${fine_username}' and m.businessareaid='${dept}'
order by region.regioncode

select m.userid, u.username, u.employeename, m.businessareaid deptid, dept.areaname,m.orgid, org.orgcode, org.orgname, org.globalpccode, region.regionname,city.citycode, city.cityname
from masterrelationship m --五者关系
left join usr u on m.userid=u.userid --用户
left join businessarea dept on m.businessareaid=dept.areaid --业务区域
left join organization org on m.orgid=org.orgid --客户
left join region on org.regioncode=region.regioncode --省
left join city on org.citycode=city.citycode --市
--where u.username='${fine_username}' and m.businessareaid='${dept}' and region.regioncode in ('${regioncode}')
order by city.citycode

select orgcode,orgname,orgcode||'_'||orgname from organization

