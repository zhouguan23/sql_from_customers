select sum(t.cdwatt) cdwatt,
          sum(t.hfswatt) hfswatt,
          sum(t.hfdwatt) hfdwatt,
          sum(t.ahwatt) ahwtt
  from (select g.code,
               sum(decode(g.code, '1007', decode(instr(f.materiel_name, '单晶'),0,null,t1.watt)))cdwatt,
           sum(decode(g.code, '1015', decode(instr(f.materiel_name, '单晶'),0,null,t1.watt)))hfswatt,
           sum(decode(g.code, '1015', decode(instr(f.materiel_name, '多晶'),0,null,t1.watt)))hfdwatt,
          sum(decode(g.code, '1016', decode(instr(f.materiel_name, '单晶'),0,null,t1.watt)))ahwatt
          from st_cell_stock_start        t1,
               view_com_materiel_all_info f,
               sa_oporg                   g,
               st_storage                 s
         where t1.grade_id = 1
           and t1.materiel_id = f.id
           and t1.organ_id = g.id
           and t1.storage_id =s.id
           and s.code!='52'
         group by g.code) t
 where 1 = 1

select sum(t.cdwatt) cdwatt,
       sum(t.hfswatt) hfswatt,
       sum(t.hfdwatt) hfdwatt,
       sum(t.ahwatt) ahwtt
  from (select sum(decode(g.code, '1007', decode(instr(f.materiel_name, '单晶'),0,null,t.watt)))cdwatt,
                     sum(decode(g.code, '1015', decode(instr(f.materiel_name, '单晶'),0,null,t.watt)))hfswatt,
                     sum(decode(g.code, '1015', decode(instr(f.materiel_name, '多晶'),0,null,t.watt)))hfdwatt,
                     sum(decode(g.code, '1016', decode(instr(f.materiel_name, '单晶'),0,null,t.watt)))ahwatt
          from (select d.organ_id, t1.materiel_id, sum(t1.watt) watt
                  from st_cell_in_dtl t1, st_cell_in d, st_operation_type p,st_storage s
                 where t1.main_id = d.id
                   and t1.storage_id is not null
                   and trunc(d.fillin_date) between to_date('2019-01-01', 'yyyy-mm-dd')      and to_date('${endDate}','yyyy-mm-dd')
                   and d.status = 2000
                   and t1.grade_id = 1
                   and d.operation_type_id = p.id
                   and p.business_code IN (3, 42, 122, 58, 9, 31)
                   and t1.storage_id=s.id
                   and s.code!='52'
                 group by d.organ_id, t1.materiel_id
                union all
                select d.organ_id, t1.materiel_id, sum(-t1.watt) as in_watt
                  from st_cell_out_dtl t1, st_cell_out d, st_operation_type p,st_storage s
                 where t1.main_id = d.id
                   and t1.storage_id is not null
                   and trunc(d.fillin_date) between to_date('2019-01-01', 'yyyy-mm-dd') and to_date('${endDate}','yyyy-mm-dd')
                   and d.status = 2000
                   and t1.grade_id = 1
                   and d.operation_type_id = p.id
                   and p.business_code in (30, 4)
                   and t1.storage_id=s.id
                   and s.code!='52'
                 group by d.organ_id, t1.materiel_id) t,
               view_com_materiel_all_info f,
               sa_oporg g
         where t.organ_id = g.id
           and t.materiel_id = f.id
         group by g.code) t
 where 1 = 1

select sum(decode(g.code, '1007', decode(instr(f.materiel_name, '单晶'),0,null,t1.watt)))cdwatt,
          sum(decode(g.code, '1015', decode(instr(f.materiel_name, '单晶'),0,null,t1.watt)))hfswatt,
          sum(decode(g.code, '1015', decode(instr(f.materiel_name, '多晶'),0,null,t1.watt)))hfdwatt,
          sum(decode(g.code, '1016', decode(instr(f.materiel_name, '单晶'),0,null,t1.watt)))ahwatt
  from st_cell_out_dtl            t1,
       st_cell_out                d,
       st_operation_type          p,
       st_storage                 s,
       view_com_materiel_all_info f,
       sa_oporg                   g
 where t1.main_id = d.id
   and t1.storage_id is not null
   and trunc(d.fillin_date) between to_date('2019-01-01', 'yyyy-mm-dd') and to_date('${endDate}','yyyy-mm-dd')
   and d.status = 2000
   and t1.grade_id = 1
   and d.operation_type_id = p.id
   and p.business_code in (12, 49, 35, 121, 127, 51，32, 18, 13)
    and t1.storage_id=s.id
    and s.code!='52'
   and t1.materiel_id = f.id
   and d.organ_id = g.id

select sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s1), 0, null, t.qty))) cd1,
       sum(decode(t.code, '1015', decode(decode(t.s,0,0,t.s1), 0, null, t.qty))) hf1,
       sum(decode(t.code, '1016', decode(decode(t.s,0,0,t.s1), 0, null, t.qty))) ah1,
       sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s2), 0, null, t.qty))) cd2,
       sum(decode(t.code, '1016', decode(decode(t.s,0,0,t.s2), 0, null, t.qty))) ah2,
       sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s3), 0, null, t.qty))) cd3,
       sum(decode(t.code, '1015', decode(decode(t.p,0,0,t.p), 0, null, t.qty))) hfd,
       sum(decode(t.code, '1007', decode(t.z, 0, null, t.qty))) cdsilve,
       sum(decode(t.code, '1015', decode(t.z, 0, null, t.qty))) hfsilve,
       sum(decode(t.code, '1016', decode(t.z, 0, null, t.qty))) ahsilve
  from (select g.code,
               f.materiel_code,
               f.materiel_name,
               f.spec,
               t1.qty,
               instr(f.materiel_name, '多晶') p,
               instr(f.materiel_name, '单晶') s,
               instr(f.spec, '156.75') s1,
               instr(f.spec, '158.75') s2,
               instr(f.spec, '166') s3,
               instr(f.materiel_name, '正银') z
          from st_mate_stock_start        t1,
               view_com_materiel_all_info f,
               sa_oporg                   g,
               st_storage                 s
         where t1.materiel_id = f.id
           and t1.organ_id = g.id
           and t1.storage_id = s.id
           and s.storage_attr = 1
           and (f.materiel_code like '12.%' or f.materiel_code like '13.10%')
           and (f.materiel_name like '%硅片%' or f.materiel_name like '%正银%')) t

select sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s1), 0, null, t.qty))) cd1,
       sum(decode(t.code, '1015', decode(decode(t.s,0,0,t.s1), 0, null, t.qty))) hf1,
       sum(decode(t.code, '1016', decode(decode(t.s,0,0,t.s1), 0, null, t.qty))) ah1,
       sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s2), 0, null, t.qty))) cd2,
       sum(decode(t.code, '1016', decode(decode(t.s,0,0,t.s2), 0, null, t.qty))) ah2,
       sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s3), 0, null, t.qty))) cd3,
       sum(decode(t.code, '1015', decode(decode(t.p,0,0,t.p), 0, null, t.qty))) hfd,
       sum(decode(t.code, '1007', decode(t.z, 0, null, t.qty))) cdsilve,
       sum(decode(t.code, '1015', decode(t.z, 0, null, t.qty))) hfsilve,
       sum(decode(t.code, '1016', decode(t.z, 0, null, t.qty))) ahsilve
  from (select g.code,
               f.materiel_code,
               f.materiel_name,
               f.spec,
               d.qty,
               instr(f.materiel_name, '多晶') p,
               instr(f.materiel_name, '单晶') s,
               instr(f.spec, '156.75') s1,
               instr(f.spec, '158.75') s2,
               instr(f.spec, '166') s3,
               instr(f.materiel_name, '正银') z
          from st_mate_in        t1,
          st_mate_in_dtl d,
               view_com_materiel_all_info f,
               sa_oporg                   g,
               st_storage                 s
         where t1.id=d.main_id
         and d.materiel_id = f.id
           and t1.organ_id = g.id
           and t1.storage_id = s.id
           and s.storage_attr = 1
           and  trunc(d.fn_date) between to_date('2019-01-01', 'yyyy-mm-dd') and to_date('${endDate}','yyyy-mm-dd')
           and (f.materiel_code like '12.%' or f.materiel_code like '13.10%')
           and (f.materiel_name like '%硅片%' or f.materiel_name like '%正银%')) t

select sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s1), 0, null, t.qty))) cd1,
       sum(decode(t.code, '1015', decode(decode(t.s,0,0,t.s1), 0, null, t.qty))) hf1,
       sum(decode(t.code, '1016', decode(decode(t.s,0,0,t.s1), 0, null, t.qty))) ah1,
       sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s2), 0, null, t.qty))) cd2,
       sum(decode(t.code, '1016', decode(decode(t.s,0,0,t.s2), 0, null, t.qty))) ah2,
       sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s3), 0, null, t.qty))) cd3,
       sum(decode(t.code, '1015', decode(decode(t.p,0,0,t.p), 0, null, t.qty))) hfd,
       sum(decode(t.code, '1007', decode(t.z, 0, null, t.qty))) cdsilve,
       sum(decode(t.code, '1015', decode(t.z, 0, null, t.qty))) hfsilve,
       sum(decode(t.code, '1016', decode(t.z, 0, null, t.qty))) ahsilve
  from (select g.code,
               d.materiel_code,
               d.materiel_name,
               d.spec,
               d.qty,
               instr(d.materiel_name, '多晶') p,
               instr(d.materiel_name, '单晶') s,
               instr(d.spec, '156.75') s1,
               instr(d.spec, '158.75') s2,
               instr(d.spec, '166') s3,
               instr(d.materiel_name, '正银') z
          from st_mate_out        t1,
          st_mate_out_dtl d,
               --view_com_materiel_all_info f,
               sa_oporg                   g,
               st_operation_type          p,
               st_storage                 s
         where t1.id=d.main_id
      --   and d.materiel_id = f.id
           and t1.organ_id = g.id
           and t1.storage_id = s.id
           and s.storage_attr = 1
           and t1.status>1
           and t1.operation_type_id=p.id
           and p.business_code!=99
           and  trunc(t1.fillin_date) between to_date('2019-01-01', 'yyyy-mm-dd') and to_date('${endDate}','yyyy-mm-dd')
           and (d.materiel_code like '12.%' or d.materiel_code like '13.10%')
           and (d.materiel_name like '%硅片%' or d.materiel_name like '%正银%')) t

select sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s1), 0, null, t.qty))) cdqty1,
       sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s1), 0, null, t.amount))) cdamount1,
       sum(decode(t.code, '1015', decode(decode(t.s,0,0,t.s1), 0, null, t.qty))) hf1,
       sum(decode(t.code, '1015', decode(decode(t.s,0,0,t.s1), 0, null, t.amount))) hfamount1,
       sum(decode(t.code, '1016', decode(decode(t.s,0,0,t.s1), 0, null, t.qty))) ah1,
       sum(decode(t.code, '1016', decode(decode(t.s,0,0,t.s1), 0, null, t.amount))) ahamount1,
       sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s2), 0, null, t.qty))) cd2,
       sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s2), 0, null, t.amount))) cdamount2,
       sum(decode(t.code, '1016', decode(decode(t.s,0,0,t.s2), 0, null, t.qty))) ah2,
       sum(decode(t.code, '1016', decode(decode(t.s,0,0,t.s2), 0, null, t.amount))) ahamount2,
       sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s3), 0, null, t.qty))) cd3,
       sum(decode(t.code, '1007', decode(decode(t.s,0,0,t.s3), 0, null, t.amount))) cdamount3,
       sum(decode(t.code, '1015', decode(decode(t.p,0,0,t.p), 0, null, t.qty))) hfd,
       sum(decode(t.code, '1015', decode(decode(t.p,0,0,t.p), 0, null, t.amount))) hfdamount,
       sum(decode(t.code, '1007', decode(t.z, 0, null, t.qty))) cdsilve,
       sum(decode(t.code, '1007', decode(t.z, 0, null, t.amount))) cdsilveamount,
       sum(decode(t.code, '1015', decode(t.z, 0, null, t.qty))) hfsilve,
       sum(decode(t.code, '1015', decode(t.z, 0, null, t.amount))) hfsilveamount,
       sum(decode(t.code, '1016', decode(t.z, 0, null, t.qty))) ahsilve,
       sum(decode(t.code, '1016', decode(t.z, 0, null, t.amount))) ahsilveamount
  from (select g.code,
               f.materiel_code,
               f.materiel_name,
               f.spec,
               (nvl(t.start_qty,0)+nvl(t.in_qty,0)-nvl(t.out_qty,0)) qty,
               (nvl(t.start_amount,0)+nvl(t.in_amount,0)-nvl(t.out_amount,0)) amount,
               instr(f.materiel_name, '多晶') p,
               instr(f.materiel_name, '单晶') s,
               instr(f.spec, '156.75') s1,
               instr(f.spec, '158.75') s2,
               instr(f.spec, '166') s3,
               instr(f.materiel_name, '正银') z
          from  fn_st_in_out_end t,
               view_com_materiel_all_info f,
               sa_oporg                   g
         where t.materiel_id = f.id
           and t.organ_id = g.id
           and  t.yearmonth=substr('${endDate}',0,7)
           and (f.materiel_code like '12.%' or f.materiel_code like '13.10%')
           and (f.materiel_name like '%硅片%' or f.materiel_name like '%正银%')) t

select sum(decode(t.organ_code, '1007', t.cell_cost)) cd_cell_cost,
       sum(decode(t.organ_code, '1015', t.cell_cost)) hf_cell_cost,
       sum(decode(t.organ_code, '1016', t.cell_cost)) ah_cell_cost,
       sum(decode(t.organ_code, '1007', t.cell_mark_cost)) cd_cell_mark_cost,
       sum(decode(t.organ_code, '1015', t.cell_mark_cost)) hf_cell_mark_cost,
       sum(decode(t.organ_code, '1016', t.cell_mark_cost)) ah_cell_mark_cost,
       sum(decode(t.organ_code, '1015', t.po_cell_cost)) hf_po_cell_cost,
       sum(decode(t.organ_code, '1015', t.po_cell_mark_cost)) hf_po_cell_mark_cost,
       sum(decode(t.organ_code, '1007', t.si_cost_1)) cd_si_cost_1,
       sum(decode(t.organ_code, '1015', t.si_cost_1)) hf_si_cost_1,
       sum(decode(t.organ_code, '1016', t.si_cost_1)) ah_si_cost_1,
       sum(decode(t.organ_code, '1007', t.si_cost_2)) cd_si_cost_2,
       sum(decode(t.organ_code, '1015', t.si_cost_2)) hf_si_cost_2,
       sum(decode(t.organ_code, '1016', t.si_cost_2)) ah_si_cost_2,
       sum(decode(t.organ_code, '1007', t.si_cost_3)) cd_si_cost_3,
       sum(decode(t.organ_code, '1015', t.po_si_mark_cost)) hf_po_si_mark_cost,
       sum(decode(t.organ_code, '1007', t.silve)) cd_silve,
       sum(decode(t.organ_code, '1015', t.silve)) hf_silve,
       sum(decode(t.organ_code, '1016', t.silve)) ah_silve,
       sum(decode(t.organ_code, '1015', t.sc_mod_cost)) sc_mod_cost,
       sum(decode(t.organ_code, '1015', t.po_mod_cost)) po_mod_cost,
       sum(decode(t.organ_code, '1015', t.it_mod_cost)) it_mod_cost,
       sum(decode(t.organ_code, '1015', t.sc_mod_mark_cost)) sc_mod_mark_cost,
       sum(decode(t.organ_code, '1015', t.po_mod_mark_cost)) po_mod_mark_cost,
       sum(decode(t.organ_code, '1015', t.it_mod_mark_cost)) it_mod_mark_cost
  from fn_weekly_profit t
 where t.yearmonth = trunc(to_date('${endDate}','yyyy-mm-dd'),'mm')

select nvl(sum(decode(g.code, '1007',decode(instr(t.materiel_name, '单晶'), 0, null, t.watt)))/1000000,0) cdwatt,
       nvl(sum(decode(g.code, '1015',decode(instr(t.materiel_name, '单晶'), 0, null, t.watt)))/1000000,0) hfswatt,
       nvl(sum(decode(g.code, '1015',decode(instr(t.materiel_name, '多晶'), 0, null, t.watt)))/1000000,0) hfdwatt,
       nvl(sum(decode(g.code, '1016',decode(instr(t.materiel_name, '单晶'), 0, null, t.watt)))/1000000,0) ahwatt
  from (select d.organ_id, t1.materiel_name, t1.watt
          from st_cell_in_dtl t1, st_cell_in d, st_operation_type p
         where t1.main_id = d.id
           and t1.storage_id is not null
           and t1.grade_id=1
           and d.fillin_date between trunc(to_date('${endDate}','yyyy-mm-dd'),'mm') and to_date('${endDate}','yyyy-mm-dd')
           and d.status = 2000
           and d.operation_type_id = p.id
           and p.business_code = 3
        union all
        select d.organ_id, t1.materiel_name, -t1.watt
          from st_cell_out_dtl t1, st_cell_out d, st_operation_type p
         where t1.main_id = d.id
           and t1.storage_id is not null
           and t1.grade_id=1
           and d.fillin_date between trunc(to_date('${endDate}','yyyy-mm-dd'),'mm') and to_date('${endDate}','yyyy-mm-dd')+1
           and d.status = 2000
           and d.operation_type_id = p.id
           and p.business_code = 30) t,
       sa_oporg g
 where t.organ_id = g.id


select sum(decode(instr(t.materiel_name, '单晶'), 0,null,decode(instr(t.materiel_name,'叠瓦'),0, null, t.watt)))/1000000 hfdwwatt,
       sum(decode(instr(t.materiel_name, '单晶'), 0,null,decode(instr(t.materiel_name,'叠瓦'),0, t.watt, null)))/1000000 as hfsjwatt,
       sum(decode(instr(t.materiel_name, '多晶'),0,null, t.watt))/1000000 as hfdjwatt 
  from (select d.organ_id, t1.materiel_name, t1.watt
          from st_module_in_dtl t1, st_module_in d, st_operation_type p
         where t1.main_id = d.id
           and t1.storage_id is not null
           and d.fillin_date between trunc(to_date('${endDate}','yyyy-mm-dd'),'mm') and to_date('${endDate}','yyyy-mm-dd')
           and d.status = 2000
           and d.operation_type_id = p.id
           and p.business_code = 3
        union all
        select d.organ_id, t1.materiel_name, -t1.watt
          from st_module_out_dtl t1, st_module_out d, st_operation_type p
         where t1.main_id = d.id
           and t1.storage_id is not null
           and d.fillin_date between trunc(to_date('${endDate}','yyyy-mm-dd'),'mm') and to_date('${endDate}','yyyy-mm-dd')
           and d.status = 2000
           and d.operation_type_id = p.id
           and p.business_code = 30) t
 where 1=1

select sum(decode(instr(f.materiel_name, '单晶'),0,null, decode(instr(f.materiel_name,'叠瓦'),0, null, t.watt)))/1000000 hfdwwatt,
       sum(decode(instr(f.materiel_name, '单晶'),0,null, decode(instr(f.materiel_name,'叠瓦'),0, t.watt, null)))/1000000 as hfsjwatt,
       sum(decode(instr(f.materiel_name, '多晶'),0,null, t.watt))/1000000 as hfdjwatt 
          from st_module_stock_start        t,
               view_com_materiel_all_info f,
               st_storage                 s
         where t.grade_id = 1
           and t.materiel_id = f.id
           and t.storage_id =s.id
           and s.code!='52'

select sum(decode(instr(f.materiel_name, '单晶'), 0,null,decode(instr(f.materiel_name,'叠瓦'),0, null, t.watt)))/1000000 hfdwwatt,
       sum(decode(instr(f.materiel_name, '单晶'), 0,null,decode(instr(f.materiel_name,'叠瓦'),0, t.watt, null)))/1000000 as hfsjwatt,
       sum(decode(instr(f.materiel_name, '多晶'),0,null, t.watt))/1000000 as hfdjwatt 
          from (select d.organ_id, t1.materiel_id, t1.watt
                  from st_module_in_dtl t1, st_module_in d, st_operation_type p,st_storage s
                 where t1.main_id = d.id
                   and t1.storage_id is not null
                   and trunc(d.fillin_date) between to_date('2019-01-01', 'yyyy-mm-dd')      and to_date('${endDate}','yyyy-mm-dd')
                   and d.status = 2000
                   and t1.grade_id = 1
                   and d.operation_type_id = p.id
                   and p.business_code IN (3, 42, 122, 58, 9, 31)
                   and t1.storage_id=s.id
                   and s.code!='52'

                union all
                select d.organ_id, t1.materiel_id, -t1.watt
                  from st_module_out_dtl t1, st_module_out d, st_operation_type p,st_storage s
                 where t1.main_id = d.id
                   and t1.storage_id is not null
                   and trunc(d.fillin_date) between to_date('2019-01-01', 'yyyy-mm-dd') and to_date('${endDate}','yyyy-mm-dd')
                   and d.status = 2000
                   and t1.grade_id = 1
                   and d.operation_type_id = p.id
                   and p.business_code in (30, 4)
                   and t1.storage_id=s.id
                   and s.code!='52') t,
               view_com_materiel_all_info f
         where 1=1
           and t.materiel_id = f.id

select  sum(decode(instr(f.materiel_name, '单晶'),0,null, decode(instr(f.materiel_name,'叠瓦'),0, null, t1.watt)))/1000000 hfdwwatt,
       sum(decode(instr(f.materiel_name, '单晶'),0,null, decode(instr(f.materiel_name,'叠瓦'),0, t1.watt, null)))/1000000 as hfsjwatt,
       sum(decode(instr(f.materiel_name, '多晶'),0,null, t1.watt))/1000000 as hfdjwatt 
  from st_module_out_dtl            t1,
       st_module_out                d,
       st_operation_type          p,
       st_storage                 s,
       view_com_materiel_all_info f
 where t1.main_id = d.id
   and t1.storage_id is not null
   and trunc(d.fillin_date) between to_date('2019-01-01', 'yyyy-mm-dd') and to_date('${endDate}','yyyy-mm-dd')
   and d.status = 2000
   and t1.grade_id = 1
   and d.operation_type_id = p.id
   and p.business_code in (12, 49, 35, 121, 127, 51，32, 18, 13)
    and t1.storage_id=s.id
    and s.code!='52'
   and t1.materiel_id = f.id

