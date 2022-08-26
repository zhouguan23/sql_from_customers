select  sp.GoodsCode ,GoodsName,ProdArea ,GoodsSpec ,BaseMeasureUnit ,WholePackRate ,BaseBarCode,gys.SupplierCode+' '+SupplierName SupplierName,ht.ContractNumber,js
,
case when deletebz='0' then '0' else zhcsku end zhcsku,
case when deletebz='0' then '0' else bcsku end bcsku,
case when deletebz='0' then '0' else dsqsku end dsqsku,
case when deletebz='0' then '0' else xsqsku end xsqsku,
case when deletebz='0' then '0' else bldsu end bldsu,
deletebz
from (

select sp.CategoryCode,sp.GoodsCode ,GoodsName,ProdArea ,GoodsSpec ,BaseMeasureUnit ,WholePackRate ,BaseBarCode,zhcsku,bcsku,dsqsku,xsqsku,bldsu,deletebz 
 from tbaowkxgoods a,"000" .tbGoods sp
where a.goodscode =sp.GoodsCode )sp 
left join
 (select a.GoodsCode ,ContractNumber,COUNT(ContractNumber) js from "000".tbGoodsSupp a,
(select GoodsCode from "000".tbGoodsSupp group by GoodsCode having COUNT(*)=1) b 
where a.GoodsCode =b.GoodsCode 
group by a.GoodsCode ,ContractNumber
union
select GoodsCode ,MAX(s.ContractNumber),COUNT(ht.ContractNumber) js from "000".tbGoodsSupp s,
(select distinct ContractNumber from "000".tbContract where ContractState=1 and convert(varchar(8),dateadd(dd,0,GETDATE()),112) between BeginDate and EndDate ) ht 
 where s.ContractNumber=ht.ContractNumber 
and GoodsCode not in 
(select GoodsCode from "000".tbGoodsSupp group by GoodsCode having COUNT(*)=1)
group by GoodsCode ) ht
on sp.GoodsCode =ht.GoodsCode 
left join
"000" .tbGoodsSupp supp
on ht.GoodsCode =supp.GoodsCode  and ht.ContractNumber =supp.ContractNumber 
left join 
"000" .tbSupplier gys
on supp.SuppCode=gys.SupplierCode 


where   1=1 ${if(len(fl) == 0,   "",   "and left(sp.CategoryCode,2) in ('" + replace(fl,",","','")+"')") }
and 1=1 ${if(len(sp) == 0,   "",   "and sp.goodscode in ('" + replace(sp,",","','")+"')") }
and 1=1 ${if(len(gys) == 0,   "",   "and gys.SupplierCode in ('" + replace(gys,",","','")+"')") }


order by sp.GoodsCode

