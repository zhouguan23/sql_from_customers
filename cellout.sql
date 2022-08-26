select t.type,
       t.organ_name,
       t.outstorageid,
       t.relino,
       t.billno,
       t.billdate,
       t.valid_date,
       t.stoperationname,
       t.qty,
       t.watt
  from view_st_cell_in_out t
 where 1=1
   ${if(len(pType)=0,"","and t.type_id='"+pType+"'")}
   ${if(len(organName)=0,"","and t.organ_name like'%"+organName+"%'")}
   ${if(len(billCode)=0,"","and t.billno like'%"+billCode+"%'")}
   ${if(len(starttime)=0,"","and t.valid_date>=to_date('"+starttime+"','yyyy-mm-dd')")}
   ${if(len(endtime)=0,"","  and t.valid_date<=to_date('"+endtime+"','yyyy-mm-dd')")}
   ${if(len(stoperationname)=0,"","and t.stoperationname like'%"+stoperationname+"%'")}

select t.relino, t.qty, t.watt
  from view_st_cell_module_out t
 where 1=1
   and t.relino ='${A4}'


select t.type,
       t.organ_name,
       t.outstorageid,
       t.relino,
       t.billno,
       t.billdate,
       t.valid_date,
       t.stoperationname,
       t.qty,
       t.watt
  from view_st_cell_in_out t
 where 1=1
   ${if(len(pType)=0,"","and t.type_id='"+pType+"'")}
   ${if(len(organName)=0,"","and t.organ_name like'%"+organName+"%'")}
   ${if(len(billCode)=0,"","and t.billno like'%"+bill_code+"%'")}
   ${if(len(starttime)=0,"","and t.valid_date>=to_date('"+starttime+"','yyyy-mm-dd')")}
   ${if(len(endtime)=0,"","  and t.valid_date<=to_date('"+endtime+"','yyyy-mm-dd')")}
   ${if(len(stoperationname)=0,"","and t.stoperationname like'%"+stoperationname+"%'")}

select t.type,
       t.organ_name,
       t.outstorageid,
       t.relino,
       t.billno,
       t.billdate,
       t.valid_date,
       t.stoperationname,
       t.qty,
       t.watt
  from view_st_cell_in_out t
 where 1=1
   ${if(len(pType)=0,"","and t.type_id='"+pType+"'")}
   ${if(len(organName)=0,"","and t.organ_name like'%"+organName+"%'")}
   ${if(len(billCode)=0,"","and t.billno like'%"+billCode+"%'")}
   ${if(len(starttime)=0,"","and t.valid_date>=to_date('"+starttime+"','yyyy-mm-dd')")}
   ${if(len(endtime)=0,"","  and t.valid_date<=to_date('"+endtime+"','yyyy-mm-dd')")}
   ${if(len(stoperationname)=0,"","and t.stoperationname like'%"+stoperationname+"%'")}

