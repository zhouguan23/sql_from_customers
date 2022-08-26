select * from 
(select ${ll_groupby},a.trantypeid,a.trantypename,
       b.party_opcode as provcode,b.party_name as provname,e.catagory,
       a.artiid,a.articode,a.artiabbr,a.artiname,a.artiunit,a.artispec,
       a.manufactory,a.articlassname,a.pl,sum(a.artiqty) as artiqty,
       sum(a.untaxsaleamt) as untaxsaleamt,sum(retailamt) as retailamt,
       sum(a.saleamt) as saleamt,sum(a.untaxgrossamt) as untaxgrossamt,
       case sum(a.untaxsaleamt)
         when 0 then 0
         else sum(a.untaxgrossamt)/sum(a.untaxsaleamt) end as grossrate,
       min(inv.stkqty) as stkqty,
       min(inv.insureqty) as insureqty,
       (select g.empname from sys_planer_duty f,org_employee g
         where a.artiid = f.com_goods_id and f.ou_id = 170000
           and f.emp_party_id = g.empid) as planer,
       sum(a.couponamt) as couponamt,sum(a.untaxcostamt)  as  uncostamt
  from storesale_detail_v a,
       com_party b,
       com_goods_batch c,
       com_party d,
       com_goods_catagory e,
       (select st.storageid,st.artiid,
               sum(case sc.stkcelltypeid when 180 then 0 else st.stkqty end) as stkqty,
               sum(case sc.stkcelltypeid when 180 then st.stkqty else 0 end) as insureqty
          from tbd_stkloc st,tbd_stkcell sc
         where st.stkcellid = sc.stkcellid
           and st.stkqty > 0
         group by st.storageid,st.artiid) inv
 where a.provid = b.com_party_id(+)
   and a.com_goods_batch_id = c.com_goods_batch_id(+)
   and c.vender_id = d.com_party_id(+)
   and a.parent_catagory_id = e.com_goods_catagory_id(+)
   and a.storageid = inv.storageid(+)
   and a.artiid = inv.artiid(+)
   ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
  ${if(len(ls_date)==0,""," and a.trandate >= to_date('"+ ls_date +"','yyyy-mm-dd')")}
    ${if(len(ls_end)==0,""," and a.trandate < to_date('"+ ls_end +"','yyyy-mm-dd')+1")}
  ${if(len(ll_nextdate)==0,""," and a.nextdate >= to_date('"+ ll_nextdate +"','yyyy-mm-dd')")}
    ${if(len(ll_enddate)==0,""," and a.nextdate < to_date('"+ ll_enddate +"','yyyy-mm-dd')+1")}
${if(len(ll_parentorg)==0,""," and a.parentorgid ="+ ll_parentorg)}
 ${if(len(ll_deptid)==0,""," and a.deptid ="+ ll_deptid)}
 ${if(len(ll_storetype)==0,""," and a.depttype = '"+ ll_storetype +"'")}
 ${if(len(ll_areaid)==0,""," and a.areaid = "+ ll_areaid)}
${if(len(ll_storageid)==0,""," and a.storageid = "+ ll_storageid)}
 ${if(len(ll_articode)==0,"", "and a.articode = '"+ll_articode+"'")}
 ${if(len(ll_artiname)==0,"", "and (instr(a.artiabbr,'"+ll_artiname+"')>0
or instr(a.artiname,'"+ll_artiname+"')>0 ) ")}
 ${if(len(ll_artispell)==0,"", "and a.artispell like upper('"+ll_artispell+"%')")}
${if(len(ll_stkcellid)==0,"","and a.stkcellid in ("+ll_stkcellid+")")}
${if(len(ll_provid)==0,"","and a.provid in ("+ll_provid+")")}
${if(len(ll_oriprovid)==0,"","and c.vender_id = "+ll_oriprovid)}
${if(len(ll_FACTORY_ID)==0,"","and a.FACTORY_ID in ("+ll_FACTORY_ID+")")}
${if(len(ls_uncarticlasscode)==0,""," and exists(select 1 from tbc_uncarticlassrela_view v where v.artiid=a.artiid 
and v.uncarticlasscode like '"+ls_uncarticlasscode+"%') ")}
${if(len(ll_busstype)==0,"","and a.busstype ='"+ll_busstype+"'")}
${if(len(ll_trantype)==0,"","and a.trantypeid in ("+ll_trantype+")")}
${if(len(ll_catagory)==0,"","and e.com_goods_catagory_id in ("+ll_catagory+")")}
 ${if(len(ll_zs)==0,"", "and instr(a.pl,'"+ll_zs+"')>0")}
 ${if(len(ll_planer)==0,"","and exists(select 1
              from sys_planer_duty f,org_employee g
             where a.artiid = f.com_goods_id and f.ou_id = 170000
               and f.emp_party_id = g.empid
               and instr(g.empname,'"+ll_planer+"')>0)")}
 ${if(len(ll_retailprice)==0,""," and a.retailprice >="+ ll_retailprice)}
 ${if(len(ll_retailprice)==0,""," and a.retailprice < trunc("+ ll_retailprice +",1)+0.1")}
 group by ${ll_groupby},b.party_opcode,b.party_name,
          a.trantypeid,a.trantypename,a.articlassname,a.artiid,a.articode,
          a.artiabbr,a.artiname,a.artiunit,a.artispec,a.manufactory,a.pl,
          e.catagory
)
 order by ${ll_columns} ${ll_sort}

select b.storageid,a.deptname ||'-'|| b.storagename as storagename
  from com_store_v a,tbd_stkstorage b
 where a.deptid = b.deptid
 ${if(len(ll_deptid)==0,"","and a.deptid ="+ ll_deptid)} 
 ${if(len(ll_orgid)==0,"",
" and (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}

select a.uncarticlasscode,
       a.uncarticlasscode||'-'||a.uncarticlassname as uncarticlassname
  from sys_uncarticlass a
 where a.is_private = 'GLOBAL'
 ${if(len(ll_orgid)==0,"",
" or (a.is_private = 'OU' and instr(a.private_org,(select ouid from com_store_v where deptid = "+ ll_orgid +"))>0)
  or not exists(select 1 from com_retail_store st where st.com_party_id = "+ ll_orgid +")")}
 order by a.uncarticlasscode

select distinct b.provid,b.provname
  from Tbl_Provinfo b
 order by b.provid,b.provname

select b.stkcellid,a.deptname ||'-'|| b.stkcellno as stkcellname
  from com_store_v a,tbd_stkcell b
 where a.deptid = b.deptid
 ${if(len(ll_deptid)==0,""," and a.deptid ="+ ll_deptid)}
 ${if(len(ll_storageid)==0,""," and b.storageid ="+ ll_storageid)}
 order by b.stkareaid,b.stkcelltypeid,b.stkcellno

					 select distinct FACTORY_ID,manufactory from   TBB_ARTICLE_INFORMATION


select trantypeid,trantypename from tbv_trantype
${if(len(ll_busstype)==0,""," where busstype ='"+ll_busstype+"'")}
order by busstype,trantypeid

select com_goods_catagory_id,catagory_no ||' '|| catagory as catagoryname
  from com_goods_catagory
 where is_root_catagory = 'TRUE'
 order by catagory_no

select distinct a.parentorgid,a.parentorgname
  from com_store_v a
 ${if(len(ll_orgid)==0,"",
" where (exists(select 1 from com_retail_store st1 where a.deptid = st1.com_party_id and st1.com_party_id = "+ ll_orgid +")
   or not exists(select 1 from com_retail_store st2 where st2.com_party_id = "+ ll_orgid +"))")}
  order by a.parentorgid

select com_retail_area_id as areaid,retail_area_name as areaname
  from com_retail_area
 order by area_opcode

