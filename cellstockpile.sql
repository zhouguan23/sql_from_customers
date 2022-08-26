select * from view_st_cell_stockpile t where 1=1
   ${if(len(organName)=0,"","and t.organ_name like'%"+organName+"%'")}
      ${if(len(storagename)=0,"","and t.storagename like'%"+storagename+"%'")}
   ${if(len(materielcode)=0,"","and t.materielcode like'%"+materielcode+"%'")}
   ${if(len(materielname)=0,"","and t.materielname like'%"+materielname+"%'")}
   ${if(len(spec)=0,"","and p.spec like'%"+spec+"%'")}

select t.id,t.materiel_code,t.qty,t.watt from st_cell_stock t where 1=1 and t.id ='${id}'

select * from view_st_cell_stockpile t where 1=1
   ${if(len(organName)=0,"","and t.organ_name like'%"+organName+"%'")}
      ${if(len(storagename)=0,"","and t.storagename like'%"+storagename+"%'")}
   ${if(len(materielcode)=0,"","and t.materielcode like'%"+materielcode+"%'")}
   ${if(len(materielname)=0,"","and t.materielname like'%"+materielname+"%'")}
   ${if(len(spec)=0,"","and p.spec like'%"+spec+"%'")}

select * from view_st_cell_stockpile t where 1=1
   ${if(len(organName)=0,"","and t.organ_name like'%"+organName+"%'")}
      ${if(len(storagename)=0,"","and t.storagename like'%"+storagename+"%'")}
   ${if(len(materielcode)=0,"","and t.materielcode like'%"+materielcode+"%'")}
   ${if(len(materielname)=0,"","and t.materielname like'%"+materielname+"%'")}
   ${if(len(spec)=0,"","and p.spec like'%"+spec+"%'")}

