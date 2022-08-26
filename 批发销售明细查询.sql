 select a.DeptId,
  a.leid,a.lename,
  distid,
  rightno,
  b.ARTICODE,
  b.ARTISPEC||'/'||
  b.ARTIUNIT as goodsinfo,
  b.MANUFACTORY artiinfo,
  b.ARTINAME,
  b.ARTISPEC,
  b.ARTIUNIT,
  a.batchcode,
  -a.artiqty as artiqty,
  a.outdate,
  d.DEPTID,
  d.DEPTNO,
  d.DEPTNAME,
  -a.saleamt as saleamt,
  -a.taxamt as taxamt,
  a.retailprice,
  -a.costamt as costamt,
  a.reqshtno,
  case 
    when a.Bulksaleprice = 0 then 0 
    else  round(a.Saleprice/a.Bulksaleprice*100,2) 
  end  kl,
  a.procdate,
  a.validdate,
  a.saleprice,
  a.taxsaleprice,
  a.staxrate,
  e.EMPNAME,
  a.stklocid,
 a.taxprice,--含税成本价
  a.untaxprice, --无税成本价
  f.stkcellno, 
  '' as dismode,
  '' as CheckName,
  h.PROVCODE,
  h.PROVNAME,
  a.note as note,
  a.outdate as SHIFTDATE,
  ORDER_NO,
  PCLASS_CODE,
  PCLASS_NAME,
  a.order_source_name,
  t2.party_name as goodsManager,
  a.print_date,
  com_goods.sale_holder,
  scg.is_gpo,
  decode(scg.is_gpo,'TRUE','是','FALSE','否') as gpoFlag,
  cgm.sale_kind,
  com_goods.zs,
  com_goods.indications,
  com_goods.ingredient,
  s.price
from Tbd_Distribute  a
inner join Tbb_Article b on a.artiid = b.artiid 
left join Tbl_Dept d on a.deptid = d.deptid
left join Tbl_Employee e on a.outid = e.empid
left join tbd_stkcell f on a.stkcellid = f.stkcellid
left join Tbl_Provinfo h on a.provid = h.provid
left join wx_prod.com_goods com_goods on b.articode = com_goods.goods_opcode

left join wx_prod.COM_GOODS_MANAGE_KIND cgm on cgm.com_goods_manage_kind_id = com_goods.com_goods_manage_kind_id
${if(len(ls_articlasscode)==0,""," inner join Tbc_UncArtiClassRela artirela on artirela.artiid = a.artiid and artirela.uncarticlasscode in ('"+ls_articlasscode+"')")}
${if(len(ls_deptclasscode)==0,""," inner join Tbc_UncDeptClassRela deptrela on a.DeptId = deptrela.DeptId and deptrela.UncDeptClassCode like '"+ls_deptclasscode+"%'")}
left join wx_prod.sys_client_goods_ref scg on scg.com_goods_id =
com_goods.com_goods_id and scg.inv_owner=a.leid and scg.com_client_id=a.deptid
left join wx_prod.sys_planer_duty t1 on a.artiid = t1.com_goods_id and a.leid = t1.ou_id
left join wx_prod.com_party t2 on t1.emp_party_id = t2.com_party_id
left join wx_prod.sys_goods_prices s on s.ou_id= a.leid and s.com_goods_id=a.artiid and s.sys_price_type_id=20
where  1=1
--a.OutDate >=d('${ldt_begin}') and a.OutDate <d('${ldt_end}') + 1

${if(len(ldt_begin)==0,""," and a.OutDate >= to_date('" + ldt_begin + "','yyyy-mm-dd')")}
${if(len(ls_manage_kind_id)==0,""," and com_goods.COM_GOODS_MANAGE_KIND_ID = "+ls_manage_kind_id+"")}
${if(len(ls_zs)==0,""," and com_goods.zs like '%"+ls_zs+"%'")}
${if(len(ls_indications)==0,""," and com_goods.indications like '%"+ls_indications+"%'")}
${if(len(ls_ingredient)==0,""," and com_goods.ingredient like '%"+ls_ingredient+"%'")}
${if(len(ldt_end)==0,""," and a.OutDate < to_date('" + ldt_end + "','yyyy-mm-dd')+1")}
${if(len(print_begin_date)==0,""," and a.print_date >= to_date('" + print_begin_date + "','yyyy-mm-dd')")}
${if(len(print_end_date)==0,""," and a.print_date < to_date('" + print_end_date + "','yyyy-mm-dd')+1")}
${if(len(ls_arti)==0,"","and (b.ArtiCode like'%"+ls_arti+"%' or b.ArtiName like '%" + ls_arti + "%' or b.ArtiSpell like '%" + ls_arti + "%' or b.Manufactory like '%" + ls_arti + "%')" )} 
${if(len(ls_rightno)==0,""," and rightno like '"+ls_rightno+"%'")}
${if(len(ls_lot)==0,""," and a.batchcode like '%"+ls_lot+"%'")}
${if(len(ls_dept)==0,"","and (d.DeptName like'%"+ls_dept+"%' or d.DeptSpell like '%" + ls_dept + "%' or d.DeptNo like '%" + ls_dept + "%')" )} 
${if(len(ls_prov)==0,"","and (h.provname like'%"+ls_prov+"%' or h.provname  like '%" + ls_prov+ "%' or h.provcode  like '%" + ls_prov+ "%')" )} 
${if(len(ls_storage)==0,""," and a.storageid= "+ls_storage)}
${if(len(ls_salerid)==0,""," and a.outid='"+ls_salerid+"'")}
${if(ls_rig==0," and rightno is null","")}
${if(ls_rig==1," and rightno is not null","")}
${if(len(web_distdcid)==0,""," and a.distdcid = " + web_distdcid)}
${if(len(ll_order_no)==0,""," and a.order_no = " + ll_order_no)}
${if(len(ls_note)==0,""," and a.note like '%" + ls_note+"%'")}
${if(len(ls_sys_order_source_id )==0,""," and a.order_source_id ='"+ls_sys_order_source_id+"'")}
${if(len(ls_goods_manager)==0,""," and t2.party_name = '" + ls_goods_manager + "'")}

${if(len(special_medicine) == 0,""," and ( com_goods.is_special_medicine like " + "'%" + special_medicine + "%' or com_goods.is_coldchain like " + "'%" + special_medicine + "%')")}

${if(len(ls_sysManageAreaId)==0,""," and com_goods.sys_manage_code in ("+ ls_sysManageAreaId +")")}


${if(len(ls_uncdeptclasscode)==0,""," and exists(select 1 from tbc_uncdeptclassrela  tt where tt.deptid = a.deptid 
and tt.uncdeptclasscode in ('" + ls_uncdeptclasscode + "'))" )}


${if(len(company_a)==0,""," and exists(select  1
   from wx_prod.sys_party_sets_lines g
  inner join wx_prod.sys_party_sets h
     on g.sys_party_sets_id = h.sys_party_sets_id
     
  where a.deptid =g.com_party_id  and  h.sys_party_sets_id  in (" + company_a + "))" )}


order by a.leid,a.OutDate,d.DeptName,b.ArtiCode

select tbd_stkstorage.storageid,tbd_stkstorage.storagename from tbd_stkstorage 

select Tbl_Employee.Empid,Tbl_Employee.Empname 
from Tbl_Employee 


select DeptId,DeptNo,DeptName from Tbl_Dept 
where 1 = 1
--DeptId in (select BussDeptId from Tbl_Deptstorage)

select UncArtiClassCode,'['||UncArtiClassCode||']A'||UncArtiClassName UncArtiClassname 
from Tbc_UncArtiClass
where 1 = 1
${if(len(ll_ou_id) == 0,""," and OU_ID = " + ll_ou_id)}
order by UncArtiClassname

select UncDeptClassCode,'['||UncDeptClassCode||']A'||UncDeptClassName UncDeptClassname 
from Tbc_UncDeptClass
where 1 = 1
${if(len(ll_ou_id) == 0,""," and OU_ID = " + ll_ou_id)}
order by UncDeptClassname

select
  a.leid,a.lename,
  distid,
  c.rightno,
  b.ARTICODE,
  b.ARTINAME||'/'||
  b.ARTISPEC||'/'||
  b.ARTIUNIT||'/'||
  b.MANUFACTORY artiinfo,
  a.batchcode,
  -a.artiqty as artiqty,
  a.outdate,
  d.DEPTID,
  d.DEPTNO,
  d.DEPTNAME,
  -a.saleamt as saleamt,
  -a.taxamt as taxamt,
  a.retailprice,
  -a.costamt as costamt,
  a.reqshtno,
  case 
    when a.Bulksaleprice = 0 then 0 
    else  round(a.Saleprice/a.Bulksaleprice*100,2) 
  end  kl,
  a.procdate,
  a.validdate,
  a.saleprice,
  a.taxsaleprice,
  a.staxrate,
  e.EMPNAME,
  a.stklocid,
  f.stkcellno, 
  '' as dismode,
  '' as CheckName,
  h.PROVCODE,
  h.PROVNAME,
  '' as note,
  a.outdate as SHIFTDATE,
  ORDER_NO
from Tbd_Distribute_sum a
inner join Tbb_Article b on a.artiid = b.artiid
left join Tbf_Bulkinvoice c on a.invid = c.invid
left join Tbl_Dept d on a.deptid = d.deptid
left join Tbl_Employee e on a.outid = e.empid
left join tbd_stkcell f on a.stkcellid = f.stkcellid
left join Tbl_Provinfo h on a.provid = h.provid
${if(len(ls_articlasscode)==0,""," inner join Tbc_UncArtiClassRela artirela on artirela.artiid = a.artiid and artirela.uncarticlasscode like '"+ls_articlasscode+"%'")}
${if(len(ls_deptclasscode)==0,""," inner join Tbc_UncDeptClassRela deptrela on a.DeptId = deptrela.DeptId and deptrela.UncDeptClassCode like '"+ls_deptclasscode+"%'")}
where  a.OutDate >=d('${ldt_begin}')
and a.OutDate <d('${ldt_end}') + 1
${if(len(ls_rightno)==0,""," and c.RightNo like '"+ls_rightno+"%'")}
${if(len(ls_arti)==0,"","and (b.ArtiCode like'"+ls_arti+"%' or b.ArtiName like '%" + ls_arti + "%' or b.ArtiSpell like '%" + ls_arti + "%' or b.Manufactory like '%" + ls_arti + "%')" )} 
${if(len(ls_dept)==0,"","and (d.DeptName like'%"+ls_dept+"%' or d.DeptSpell like '%" + ls_dept + "%' or d.DeptNo like '%" + ls_dept + "%')" )} 
${if(len(ls_prov)==0,"","and (h.provname like'%"+ls_prov+"%' or h.provname  like '%" + ls_prov+ "%' or h.provcode  like '%" + ls_prov+ "%')" )} 
${if(len(ls_storage)==0,""," and tbd_stkstorage.storageid='"+ls_storage+"'")}
${if(len(ls_salerid)==0,""," and a.outid='"+ls_salerid+"'")}
${if(ls_rig==0," and c.RightNo is null","")}
${if(ls_rig==1," and c.RightNo is not null","")}
${if(len(web_distdcid)==0,""," and a.distdcid = " + web_distdcid)}
${if(len(ll_order_no)==0,""," and a.order_no = " + ll_order_no)}
and 1=2
order by a.leid,a.OutDate,d.DeptName,b.ArtiCode

select order_source_id ,
order_source_id || '-' || order_source_name from  wx_prod.sys_order_source where status= 'TRUE'

select distinct SUBSTR(is_special_medicine,1,2) AS is_special_medicine from wx_prod.com_goods where is_special_medicine is not null

SELECT CK.COM_GOODS_MANAGE_KIND_ID ,CK.SALE_KIND
FROM COM_GOODS_MANAGE_KIND  CK 
INNER JOIN COM_GOODS CG ON CG.COM_GOODS_MANAGE_KIND_ID =CK.COM_GOODS_MANAGE_KIND_ID 
GROUP BY CK.COM_GOODS_MANAGE_KIND_ID,CK.SALE_KIND order by COM_GOODS_MANAGE_KIND_ID asc

select 
  a.sys_manage_area_id,
  a.sys_manage_code,
  a.sys_manage_name
from sys_manage_area a
order by a.sys_manage_code

select sys_party_sets_id,'('||uncpartyclasscode||') '||party_set_name as party_set_name from sys_party_sets
  where PARTY_SET_STATUS = 'TRUE' 
  ${if(len(ouId) == 0,"","and ("+"IS_PRIVATE"+" = 'GLOBAL' or "+"private_org"+" like " + "'" + ouId + "')")} order by party_set_name

