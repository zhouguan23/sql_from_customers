SELECT 
xh 编码,
case when len(xh) > 2 then  left(xh,2) 	 	
else '1'  end 上级id,
xl 系列名字
FROM BI_XLBM c


SELECT c.xh,a.xilie2,sum(a.touchanliang) touchanliang,sum(a.A) A,sum(a.B) B,
sum(a.C) C,sum(a.DZP) DZP,sum(a.xpbaofei) xpbaofei,sum(a.qjgbaofei) qjgbaofei,
sum(a.qxbaofei) qxbaofei,sum(a.zzbaofei) zzbaofei,sum(a.zmbaofei) zmbaofei,sum(a.zdxbaofei) zdxbaofei,sum(a.csxbaofei) csxbaofei,
sum(a.A)/sum(a.touchanliang)Apbl,sum(a.B)/sum(a.touchanliang)Bpbl,sum(a.C)/sum(a.touchanliang)Cpbl,sum(a.DZP)/sum(a.touchanliang)DZPpbl,sum(a.xpbaofei)/sum(a.touchanliang)xpbl,sum(a.qjgbaofei)/sum(a.touchanliang)qjgbl,sum(a.qxbaofei)/sum(a.touchanliang)qxbl,sum(a.zzbaofei)/sum(a.touchanliang)zzbl,sum(a.zmbaofei)/sum(a.touchanliang)zmbl,sum(a.zdxbaofei)/sum(a.touchanliang)zdxbl,sum(a.csxbaofei)/sum(a.touchanliang)csxbl

FROM BI_SCSGB a
LEFT join BI_XLBM  c on a.xilie2 = c.xl
where 1=1
 ${IF(LEN(年份)==0,''," AND a.year IN( '"+年份+"')")}
 ${IF(LEN(月份)==0,''," AND a.month IN( '"+月份+"')")}
 ${IF(LEN(系列)==0,''," AND a.xilie2 IN( '"+系列+"')")}
 and a.touchanleixing = '正常投产'
group by c.xh,a.xilie2

SELECT distinct YEAR 年份
FROM BI_SCSGB a


SELECT distinct month 月份
FROM BI_SCSGB a
where 1=1 
${IF(LEN(年份)==0,''," AND YEAR IN( '"+年份+"')")}
ORDER BY 月份 ASC

SELECT xilie2 系列 
 FROM BI_SCSGB c
 where 1=1   
  ${IF(LEN(年份)==0,''," AND c.year IN( '"+年份+"')")}
 ${IF(LEN(月份)==0,''," AND c.month IN( '"+月份+"')")}



SELECT xh,xl,zb
  FROM BI_XLBM
  LEFT join BI_SCSGB  on xl = xilie2

    SELECT  b.xuhao,b.shengchanxilie,
      sum(iQuantity) iQuantity
      ,sum(iNatSum)/sum(iQuantity)*7 iprice
      ,sum(iNatSum) iNatSum
     -- ,[cMemoVenName]A
    --  ,[hebingxilie]A
       FROM [Speed]A.[dbo]A.[BI_PO]A a
       left join BI_INV_BASE b on a.cInvCode = b.SpeedCode
      where dPODate between DATEADD("month",-3,getdate()) and GETDATE()and LEFT(cInvCode,4)='AA01' and dingdanleixing = '正常单'
     group by  b.shengchanxilie,b.xuhao
     
     union all
     SELECT  b.xuhao,b.shengchanxilie,
      sum(iQuantity) iQuantity
      ,sum(iNatSum)/sum(iQuantity)*7 iprice
      ,sum(iNatSum) iNatSum
     -- ,[cMemoVenName]A
    --  ,[hebingxilie]A
       FROM [Speed]A.[dbo]A.[BI_PO]A a
       left join BI_INV_BASE b on a.cInvCode = b.SpeedCode
      where dPODate between DATEADD("month",-12,getdate()) and GETDATE()and LEFT(cInvCode,4)='AA01' and dingdanleixing = '正常单'
      and cinvcode not in 
      (SELECT [cInvCode]A
       FROM [Speed]A.[dbo]A.[BI_PO]A 
      where dPODate between DATEADD("month",-3,getdate()) and GETDATE()and LEFT(cInvCode,4)='AA01' and dingdanleixing = '正常单'
     )
     group by  b.shengchanxilie,b.xuhao

     	 union all
	 select distinct
	 a.xuhao
			,a.shengchanxilie
			,0 iQuantity
			,b.khj
			,0 iNatSum
from BI_INV_BASE a
left join bi_xlbm b on b.xh=a.xuhao
where a.SpeedCode not in(
SELECT [cInvCode]A
       FROM [Speed]A.[dbo]A.[BI_PO]A 
      where dPODate between DATEADD("month",-3,getdate()) and GETDATE()and LEFT(cInvCode,4)='AA01' and dingdanleixing = '正常单'
union all
SELECT [cInvCode]A
       FROM [Speed]A.[dbo]A.[BI_PO]A 
      where dPODate between DATEADD("month",-12,getdate()) and GETDATE()and LEFT(cInvCode,4)='AA01' and dingdanleixing = '正常单'
)

with c as(
SELECT  b.xuhao,b.shengchanxilie
      ,sum(iNatSum)/sum(iQuantity)*7 iprice
     -- ,[cMemoVenName]A
    --  ,[hebingxilie]A
       FROM [Speed]A.[dbo]A.[BI_PO]A a
       left join BI_INV_BASE b on a.cInvCode = b.SpeedCode
      where dPODate between DATEADD("month",-3,getdate()) and GETDATE()and LEFT(cInvCode,4)='AA01' and dingdanleixing = '正常单'
     group by  b.shengchanxilie,b.xuhao
)
,d as(
SELECT  b.xuhao,b.shengchanxilie
      ,sum(iNatSum)/sum(iQuantity)*7 iprice
     -- ,[cMemoVenName]A
    --  ,[hebingxilie]A
       FROM [Speed]A.[dbo]A.[BI_PO]A a
       left join BI_INV_BASE b on a.cInvCode = b.SpeedCode
      where dPODate between DATEADD("month",-12,getdate()) and GETDATE()and LEFT(cInvCode,4)='AA01' and dingdanleixing = '正常单'
	and b.xuhao not in(select xuhao FROM c)
     group by  b.shengchanxilie,b.xuhao
		 )
,e as(
select xh,xl,khj from  bi_xlbm where xh not in(select xuhao from c union all select xuhao from d)
)
,f as(
select c.xuhao,c.shengchanxilie,c.iprice from c
union all
select d.xuhao,d.shengchanxilie,d.iprice from d
union all
select e.xh,e.xl,e.khj from e
)
,g as(SELECT b.xh
,a.xilie2
,sum(a.DZP) DZP
FROM BI_SCSGB a
LEFT join BI_XLBM b on a.xilie2 = b.xl
where 1=1
 ${IF(LEN(年份)==0,''," AND a.year IN( '"+年份+"')")}
 ${IF(LEN(月份)==0,''," AND a.month IN( '"+月份+"')")}
 ${IF(LEN(系列)==0,''," AND a.xilie2 IN( '"+系列+"')")}
 and a.touchanleixing = '正常投产'
group by b.xh,a.xilie2
)
select left(g.xh,2) xl
,sum(g.DZP*f.iprice) je
from g left join f on g.xh=f.xuhao
group by left(g.xh,2)

