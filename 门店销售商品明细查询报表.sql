select * from 
(SELECT case a.busstype
         when '201001' then '线上'
         when '201002' then '线下' end as busstype,
       a.parentorgname,
       a.areaname,
       a.deptid,
       a.deptno,
       a.deptname,
       a.shortname,
       case a.depttype
         when 'DIRSALES' then '直营'
         when 'LEASALES' then '加盟' end as depttype,
       a.nextdate,
       a.trandate,
       a.artiid,
       a.articode,
       a.artiabbr,
       a.artiname,
       a.artispec,
       a.artiunit,
       a.manufactory,
       a.artiqty,
       a.lotno,
       a.procdate,
       a.validdate,
       a.stkcellid,
       a.stkcellno,
       a.stkcelltypeid,
       a.stkcelltypename,
       a.clerker,
       a.staxrate/100 as staxrate,
       a.retailprice,
       a.retailamt,
       a.saleprice,
       a.untaxsaleamt,
       a.saleamt,
       a.couponamt,
       a.stklocid,
       a.untaxprice,
       a.untaxcostamt,
       a.untaxgrossamt,
       a.grossamt,
       a.grossrate,
       case a.trantype
         when 1 then '销售'
         when 2 then '销退' end as trantype,
       a.trantypename,
       a.tranid,
       a.saleno,
       a.memcardno,
       a.cashier,
       b.catagory as articlassname,
       a.permitid,
       a.relatranid,                
       a.prou_lincense_no,
       d.empname as orderchecker,
       nvl(trim(c.order_note),trim(c.order_source_no)) as ordernote
  from storesale_detail_v a
       left join tbo_external_order c on a.saleno = to_char(c.order_no)
       left join org_employee d on c.checker = d.empid,
       com_goods_catagory b
 where a.parent_catagory_id = b.com_goods_catagory_id
   and a.trandate>=to_date('${ls_trandate_start}','yyyy-mm-dd hh24:mi:ss')
   and a.trandate<to_date('${ls_trandate_end}','yyyy-mm-dd hh24:mi:ss')+1
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_deptid)==0,"","and a.deptid ="+ ll_deptid)}
 ${if(len(ll_parentorg)==0,"","and a.parentorgid ="+ ll_parentorg)}
 ${if(len(ll_tranid)==0,"","and a.tranid ="+ ll_tranid)}
 ${if(len(ll_articode)==0,"","and a.articode = '"+ ll_articode +"'")}
 ${if(len(ll_artiname)==0,"","and (instr(a.artiabbr,'"+ ll_artiname +"')>0 or instr(a.artiname,'"+ ll_artiname +"')>0)")}
 ${if(len(ll_artispell)==0,"","and a.artispell like upper('"+ll_artispell+"%')")}
  ${if(len(ll_lotno)==0,"","and a.lotno = '"+ ll_lotno +"'")}
${if(len(ls_nextdate_start)==0,"","and a.nextdate>=to_date('"+ls_nextdate_start+"','yyyy-mm-dd')")}
${if(len(ls_nextdate_end)==0,"","and a.nextdate<to_date('"+ls_nextdate_end+"','yyyy-mm-dd')+1")}
${if(len(ll_trantype)==0,"","and a.trantype ="+ll_trantype)} 
${if(len(ll_celltypeid)==0,"","and a.stkcelltypeid in ("+ll_celltypeid+")")}
${if(len(ll_stkcellid)==0,"","and a.stkcellid in ("+ ll_stkcellid +")")} 
${if(len(ll_storetype)==0,"","and a.depttype ='"+ll_storetype+"'")}
${if(len(ll_busstype)==0,"","and a.busstype = '"+ ll_busstype +"'")}
${if(len(ll_trantypeid)==0,"","and a.trantypeid in ("+ll_trantypeid+")")}
 ${if(len(ll_saleno)==0,"","and a.saleno = '"+ ll_saleno +"'")}
 ${if(len(ll_mtel)==0,"","and a.mobilephone = '"+ ll_mtel +"'")}
 ${if(len(ll_promoid)==0,"","and nvl(a.permitid,-1) ="+ll_promoid)}
 ${if(len(ll_retailprice)==0,""," and a.retailprice >="+ ll_retailprice)}
 ${if(len(ll_retailprice)==0,""," and a.retailprice < trunc("+ ll_retailprice +",1)+0.1")}
 ${if(len(ll_discount)==0,""," and a.discountrate <= "+ ll_discount)}
 ${if(len(ll_manufactory)==0,"","and instr(a.manufactory,'"+ ll_manufactory +"')>0")}
 ${if(len(ls_articlasscode)==0,""," and exists(select 1 from Tbc_Uncarticlassrela_View tbc where a.ArtiId=tbc.ArtiId and tbc.UncArtiClassCode in ( '"+ls_articlasscode+"'))")}
)
 order by ${ll_columns} ${ll_sort}

select c.stkcelltypeid,c.stkcelltypename
  from tbd_stkstorage a,tbd_stkcell b,tbd_stkcelltype c
 where a.storageid = b.storageid
   and b.stkcelltypeid = c.stkcelltypeid
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_deptid)==0,""," and a.deptid = "+ ll_deptid)}

select trantypeid,trantypename
  from tbv_trantype
 where usestatus = 0
 ${if(len(ll_busstype)==0,""," and busstype = '"+ll_busstype+"'")}
 order by busstype,trantypeid

select distinct a.parentorgid,a.parentorgname
  from com_store_v a
 ${if(len(ll_orgid)==0,"",
" where (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
  order by a.parentorgid

select UncArtiClassCode, '['||rtrim(UncArtiClassCode)||']A'||UncArtiClassName as classname
from Tbc_Uncarticlass_View
order by UncArtiClassCode

select b.uncarticlasscode, b.uncarticlasscode ||'-'|| b.uncarticlassname as uncarticlassname
  from com_store_v a,sys_uncarticlass b
 where instr(nvl(b.private_org,'GLOBAL'),case b.is_private when 'OU' then to_char(a.ouid) when 'GLOBAL' then 'GLOBAL' else 'NULL' end) > 0
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_deptid)==0,""," and a.deptid = "+ ll_deptid)}

select b.stkcellid,b.stkcellno
  from tbd_stkstorage a,tbd_stkcell b
 where a.storageid = b.storageid
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
 ${if(len(ll_deptid)==0,""," and a.deptid = "+ ll_deptid)}
 ${if(len(ll_celltypeid)==0,""," and b.stkcelltypeid in ("+ ll_celltypeid +")")}

