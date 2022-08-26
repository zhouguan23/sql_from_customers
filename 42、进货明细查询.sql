select * from (select distinct 
  Tbd_StkReg.leid,Tbd_StkReg.lename,
  Tbb_Article.ArtiCode,Tbb_Article.ArtiName||'/'||
        Tbb_Article.ArtiSpec||'/'||Tbb_Article.ArtiUnit||'/'||
        Tbb_Article.Manufactory artiinfo,
        Tbl_ProvInfo.ProvCode||'/'||Tbl_ProvInfo.ProvName ProvName,
        Tbd_StkReg.ProvId,
        Tbd_StkReg.ArtiQty, 
        Tbd_StkReg.InvArtiQty,
     Tbd_StkReg.StkDate ,
        Tbd_StkReg.UnTaxPrice,Tbd_StkReg.TaxPrice, 
        Tbd_StkReg.RetailPrice,Tbd_StkReg.ITaxRate,
        Tbd_StkReg.CostAmt,Tbd_StkReg.TaxAmt,
        Tbd_StkReg.InvCostAmt,Tbd_StkReg.InvTaxAmt,
        Tbd_StkReg.RegBatchCode,Tbd_StkReg.RegValidDay,
        Tbd_StkReg.RegChkId,Tbd_StkReg.StkRegId,
        Tbd_StkReg.invoice_no,
       Tbd_StkReg.memo || '(' || to_char(Tbd_StkReg.receiver_date,'yyyy-mm-dd' ) || ')' as memo
from    Tbd_StkReg,
      Tbl_ProvInfo,
    Tbb_Article
    inner join wx_prod.SYS_GOODS_ORG_MAPPING sgo on Tbb_Article.ArtiId = sgo.com_goods_id
${if(len(ls_articlasscode)==0,"","," + "Tbc_UncArtiClassRela Tbc_UncArtiClassRela ")}
${if(len(ls_provclasscode)==0,"","," + "Tbc_UncProvClassRela Tbc_UncProvClassRela ")}

where Tbd_StkReg.ArtiId=Tbb_Article.ArtiId
and   Tbd_StkReg.ProvId=Tbl_ProvInfo.ProvId
${if(len(leid)==0,"","and Tbd_StkReg.leid="+leid)}
${if(len(ldt_begin) == 0,""," and Tbd_StkReg.StkDate>=to_date('" + ldt_begin + "','yyyy-mm-dd')")}
${if(len(ldt_end) == 0,""," and Tbd_StkReg.StkDate<to_date('" + ldt_end + "','yyyy-mm-dd') + 1")}
${if(len(leid)==0,"","and Tbd_StkReg.DeptId="+leid)}
${if(len(ls_articode)==0,""," and (Tbb_Article.statcode like'"+ls_articode+"%' or Tbb_Article.ArtiCode like'"+ls_articode+"%' or Tbb_Article.ArtiSpell  like'%"+upper(ls_articode)+"%' or Tbb_Article.ArtiName like '%" + ls_articode + "%')")}
${if(len(ls_provcode)==0,"","and (Tbl_ProvInfo.ProvCode like'"+ls_provcode+"%'or Tbl_ProvInfo.ProvName  like'%"+upper(ls_provcode)+"%') ")}
${if(len(ls_articlasscode)==0,"","and Tbb_Article.ArtiId=Tbc_UncArtiClassRela.ArtiId")}
${if(len(ls_articlasscode)==0,"","and Tbc_UncArtiClassRela.UncArtiClassCode in ('"+ls_articlasscode+"')")}
${if(len(ls_provclasscode)==0,"","and Tbl_ProvInfo.ProvId=Tbc_UncProvClassRela.ProvId")}
${if(len(ls_provclasscode)==0,"","and Tbc_UncProvClassRela.UncProvClassCode like '"+ls_provclasscode+"%'")}
${if(len(ls_batchcode)==0,""," and Tbd_StkReg.RegBatchCode = '" + ls_batchcode + "'")}
${if(len(ls_sysManageAreaId)==0,""," and exists( select 1 from wx_prod.SYS_MANAGE_AREA t where t.sys_manage_area_id =sgo.sys_manage_area_id and t.sys_manage_area_id in(" + ls_sysManageAreaId + "))")}
order by Tbd_StkReg.StkDate,Tbb_Article.ArtiCode
) a 
where 1=1 

select com_party_id,party_name from wx_prod.com_party 
where 1=1
${if(len(ouId) == 0,"","and com_party_id = " + "'" + ouId + "'")}

