--多晶电池
select t.tyear, sum(t.in_watt) - sum(t.out_watt) as watt
  from (select to_char(t.fillin_date, 'yyyy') as tyear,
               d.watt as in_watt,
               0 as out_watt
          from st_cell_in t, st_cell_in_dtl d, st_operation_type p
         where t.id = d.main_id
           and t.operation_type_id = p.id
           and p.business_code = '3' -- 生产入库
           and d.materiel_code like '11.10%' -- 多晶电池
        union all
        
        select to_char(t.fillin_date, 'yyyy') as tyear,
               0 as in_watt,
               d.watt as out_watt
          from st_cell_out t, st_cell_out_dtl d, st_operation_type p
         where t.id = d.main_id
           and t.operation_type_id = p.id
           and p.business_code = '30' -- 生产出库
           and d.materiel_code like '11.10%' -- 多晶电池
        ) t
 group by t.tyear


--单晶电池
select t.tyear, sum(t.in_watt) - sum(t.out_watt) as watt
  from (select to_char(t.fillin_date, 'yyyy') as tyear,
               d.watt as in_watt,
               0 as out_watt
          from st_cell_in t, st_cell_in_dtl d, st_operation_type p
         where t.id = d.main_id
           and t.operation_type_id = p.id
           and p.business_code = '3' -- 生产入库
           and d.materiel_code like '11.11%' -- 单晶电池
        union all
        
        select to_char(t.fillin_date, 'yyyy') as tyear,
               0 as in_watt,
               d.watt as out_watt
          from st_cell_out t, st_cell_out_dtl d, st_operation_type p
         where t.id = d.main_id
           and t.operation_type_id = p.id
           and p.business_code = '30' -- 生产出库
           and d.materiel_code like '11.11%' -- 单晶电池
        ) t
 group by t.tyear


--类单晶电池
select t.tyear, sum(t.in_watt) - sum(t.out_watt) as watt
  from (select to_char(t.fillin_date, 'yyyy') as tyear,
               d.watt as in_watt,
               0 as out_watt
          from st_cell_in t, st_cell_in_dtl d, st_operation_type p
         where t.id = d.main_id
           and t.operation_type_id = p.id
           and p.business_code = '3' -- 生产入库
           and d.materiel_code like '11.12%' -- 类单晶电池
        union all
        
        select to_char(t.fillin_date, 'yyyy') as tyear,
               0 as in_watt,
               d.watt as out_watt
          from st_cell_out t, st_cell_out_dtl d, st_operation_type p
         where t.id = d.main_id
           and t.operation_type_id = p.id
           and p.business_code = '30' -- 生产出库
           and d.materiel_code like '11.12%' -- 类单晶电池
        ) t
 group by t.tyear


-- 多晶电池 组件领料
select to_char(t.fillin_date, 'yyyy') as tyear,
       sum(d.watt) watt
  from st_cell_out                t,
       st_cell_out_dtl            d,
       sa_oporgproperty           b,
       sa_oporgpropertydefinition a
 where t.id = d.main_id
   and t.operation_code = 'consumeOutDtl'
   and a.id = b.property_definition_id
   and a.name = 'workshopType'
   and b.property_value = '2' --组件车间
   and t.use_dept_id = b.org_id
   and d.materiel_code like '11.10%'-- 多晶电池
   and (t.out_type != 3 or t.out_type is null) -- 排除代销
 group by to_char(t.fillin_date, 'yyyy')


-- 单晶电池 组件领料
select to_char(t.fillin_date, 'yyyy') as tyear,
       sum(d.watt) watt
  from st_cell_out                t,
       st_cell_out_dtl            d,
       sa_oporgproperty           b,
       sa_oporgpropertydefinition a
 where t.id = d.main_id
   and t.operation_code = 'consumeOutDtl'
   and a.id = b.property_definition_id
   and a.name = 'workshopType'
   and b.property_value = '2' --组件车间
   and t.use_dept_id = b.org_id
   and d.materiel_code like '11.11%'-- 单晶电池
   and (t.out_type != 3 or t.out_type is null) -- 排除代销
 group by to_char(t.fillin_date, 'yyyy')

-- 类单晶电池外销
select to_char(t.fillin_date, 'yyyy') as tyear,
       sum(d.watt) watt
  from st_cell_out                t,
       st_cell_out_dtl            d,
       sa_oporgproperty           b,
       sa_oporgpropertydefinition a
 where t.id = d.main_id
   and t.operation_code = 'consumeOutDtl'
   and a.id = b.property_definition_id
   and a.name = 'workshopType'
   and b.property_value = '2' --组件车间
   and t.use_dept_id = b.org_id
   and d.materiel_code like '11.12%'-- 类单晶电池
   and (t.out_type != 3 or t.out_type is null) -- 排除代销
 group by to_char(t.fillin_date, 'yyyy')

-- 多晶电池外销
select h.tyear, sum(h.sale_watt) - sum(h.receive_watt) as watt
  from (select to_char(t.fillin_date, 'yyyy') as tyear,
               0 as receive_watt,
               d.watt as sale_watt
          from st_cell_out                t,
               st_cell_out_dtl            d
         where t.id = d.main_id
           and t.operation_code = 'saleOutDtl' -- 销售
              and d.materiel_code like '11.10%' -- 多晶电池
              and (t.out_type != 3 or t.out_type is null) -- 排除代销
        union all
        select to_char(t.fillin_date, 'yyyy') as tyear,
               d.watt as receive_watt,
               0 as sale_watt
          from st_cell_out                t,
               st_cell_out_dtl            d
         where t.id = d.main_id
           and t.operation_code = 'receiveProductApply' -- 退库
           and d.materiel_code like '11.10%' -- 多晶电池
           and (t.out_type != 3 or t.out_type is null) -- 排除代销
        ) h
 group by tyear


-- 单晶电池外销
select h.tyear, sum(h.sale_watt) - sum(h.receive_watt) as watt
  from (select to_char(t.fillin_date, 'yyyy') as tyear,
               0 as receive_watt,
               d.watt as sale_watt
          from st_cell_out                t,
               st_cell_out_dtl            d
         where t.id = d.main_id
           and t.operation_code = 'saleOutDtl' -- 销售
              and d.materiel_code like '11.11%' -- 单晶电池
              and (t.out_type != 3 or t.out_type is null) -- 排除代销
        union all
        select to_char(t.fillin_date, 'yyyy') as tyear,
               d.watt as receive_watt,
               0 as sale_watt
          from st_cell_out                t,
               st_cell_out_dtl            d
         where t.id = d.main_id
           and t.operation_code = 'receiveProductApply' -- 退库
           and d.materiel_code like '11.11%' -- 单晶电池
           and (t.out_type != 3 or t.out_type is null) -- 排除代销
        ) h
 group by tyear


-- 类单晶电池外销
select h.tyear, sum(h.sale_watt) - sum(h.receive_watt) as watt
  from (select to_char(t.fillin_date, 'yyyy') as tyear,
               0 as receive_watt,
               d.watt as sale_watt
          from st_cell_out                t,
               st_cell_out_dtl            d
         where t.id = d.main_id
           and t.operation_code = 'saleOutDtl' -- 销售
              and d.materiel_code like '11.12%' -- 类单晶电池
              and (t.out_type != 3 or t.out_type is null) -- 排除代销
        union all
        select to_char(t.fillin_date, 'yyyy') as tyear,
               d.watt as receive_watt,
               0 as sale_watt
          from st_cell_out                t,
               st_cell_out_dtl            d
         where t.id = d.main_id
           and t.operation_code = 'receiveProductApply' -- 退库
           and d.materiel_code like '11.12%' -- 类单晶电池
           and (t.out_type != 3 or t.out_type is null) -- 排除代销
        ) h
 group by tyear


select to_char(t.fillin_date, 'yyyy') as tyear, sum(d.watt) watt
  from st_module_in t, st_module_in_dtl d
 where t.id = d.main_id
 group by to_char(t.fillin_date, 'yyyy')

select to_char(t.fillin_date, 'yyyy') as tyear,
       sum(d.watt) watt
  from st_module_out t, st_module_out_dtl d, st_operation_type p
 where t.id = d.main_id
   and t.operation_type_id = p.id
   and p.business_code = 12 -- 销售
 group by to_char(t.fillin_date, 'yyyy')

select to_char(t.fillin_date, 'yyyy') as year
  from st_cell_out t
 group by to_char(t.fillin_date, 'yyyy')
 order by to_char(t.fillin_date, 'yyyy') desc

select to_char(t.fillin_date, 'yyyy') as tyear,
       sum(d.tax_amount) tax_amount -- 含税金额
  from st_module_out t, st_module_out_dtl d, st_operation_type p
 where t.id = d.main_id
   and t.operation_type_id = p.id
   and p.business_code = 12 -- 销售
   and d.storage_name not like '%代工客退%'
 group by to_char(t.fillin_date, 'yyyy')

-- 多晶电池销售金额
select h.tyear,
       sum(h.sale_tax_amount) - sum(h.receive_tax_amount) as tax_amount
  from (select to_char(t.fillin_date, 'yyyy') as tyear,
               0 as receive_tax_amount,
               d.tax_amount as sale_tax_amount
          from st_cell_out t, st_cell_out_dtl d
         where t.id = d.main_id
           and t.operation_code = 'saleOutDtl' -- 销售
           and d.materiel_code like '11.10%' -- 多晶电池
        union all
        select to_char(t.fillin_date, 'yyyy') as tyear,
               d.tax_amount as receive_tax_amount,
               0 as sale_tax_amount
          from st_cell_out t, st_cell_out_dtl d
         where t.id = d.main_id
           and t.operation_code = 'receiveProductApply' -- 退库
           and d.materiel_code like '11.10%' -- 多晶电池
        ) h
 group by tyear


-- 类单晶电池销售金额
select h.tyear, sum(h.sale_tax_amount) - sum(h.receive_tax_amount) as tax_amount
  from (select to_char(t.fillin_date, 'yyyy') as tyear,
               0 as receive_tax_amount,
               d.tax_amount as sale_tax_amount
          from st_cell_out                t,
               st_cell_out_dtl            d
         where t.id = d.main_id
           and t.operation_code = 'saleOutDtl' -- 销售
            and d.materiel_code like '11.12%' -- 类单晶电池
        union all
        select to_char(t.fillin_date, 'yyyy') as tyear,
               d.tax_amount as receive_tax_amount,
               0 as sale_tax_amount
          from st_cell_out                t,
               st_cell_out_dtl            d
         where t.id = d.main_id
           and t.operation_code = 'receiveProductApply' -- 退库
           and d.materiel_code like '11.12%' -- 类单晶电池
        ) h
 group by tyear


-- 单晶电池销售金额
select h.tyear,
       sum(h.sale_tax_amount) - sum(h.receive_tax_amount) as tax_amount
  from (select to_char(t.fillin_date, 'yyyy') as tyear,
               0 as receive_tax_amount,
               d.tax_amount as sale_tax_amount
          from st_cell_out t, st_cell_out_dtl d
         where t.id = d.main_id
           and t.operation_code = 'saleOutDtl' -- 销售
           and d.materiel_code like '11.11%' -- 单晶电池
        union all
        select to_char(t.fillin_date, 'yyyy') as tyear,
               d.tax_amount as receive_tax_amount,
               0 as sale_tax_amount
          from st_cell_out t, st_cell_out_dtl d
         where t.id = d.main_id
           and t.operation_code = 'receiveProductApply' -- 退库
           and d.materiel_code like '11.11%' -- 单晶电池
        ) h
 group by tyear


select '通威太阳能' || to_char(min(t.fillin_date), 'yyyy') || '-' ||
       to_char(max(t.fillin_date), 'yyyy') || '年出货信息汇总' as title
  from st_cell_out t 

