select convert(float,max(BillNumber ))+1 BillNumber  from 
(select distinct BillNumber from 
TBTRANSPORTBILL)a
union all 
select distinct BillNumber from 
TBTRANSPORTBILL 
where billnumber<>'2017123600000'


select * from TBTRANSPORTBILL
where BillNumber='${djh}' 

select a.NodeCode,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(b.NodeName,'合力连锁' ,''),'合力' ,''),'中天' ,''),'祥龙商贸' ,''),'常驰广场' ,''),'中山' ,''),'文城逸都' ,'二'),'麒龙缤纷城' ,'二'),'地标广场' ,''),'七众奥莱' ,'二'),'希望城' ,'')nodename,
a.Address
   from 
[000]A .TBDEPARTMENT a ,[000]A .tbNode b 
where	 a.NodeCode =b.NodeCode  and left(a.NodeCode,1) between 1 and 2 
and a.State=0 and b.NodeType=0

