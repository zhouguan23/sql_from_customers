select *
  from (select l.*,
               (case
                 when regexp_like(l.lot, '^[a-zA-Z]A') then
                  substr(l.lot,
                         0,
                         instr(translate(l.lot, '0123456789', '&&&&&&&&&&'),
                               '&') - 1)
                 else
                  null
               end) s_supplier,
               sd.value s_thickness,
               (case
                 when l.lot like '%S-%' or
                      (l.lot like '%P-%' and sd.value = '160' and
                      l.lot not like '%掺硼') then
                  '掺镓'
                 when l.lot like '%P-%' then
                  '掺硼'
                 when l.lot like '%X-%' then
                  '鑫单晶'
               end) s_wafer,
               r.resistance_type,
               g.main_gear
          from (select m.full_id,
                       m.person_member_id,
                       m.prod_dept_name,
                       m.prod_date,
                       d.*,
                       decode(instr(d.lot, '-', 1, 2),
                              0,
                              '',
                              substr(d.lot, instr(d.lot, '-', 1, 2) + 1, 7)) s_electrical_resistivity,
                       s.long_name
                  from tm_gears m, tm_gears_dtl d, sa_oporg s
                 where m.id = d.main_id
                   and m.organ_id = s.id
                   and m.status = 2000
                   and m.organ_id = '${organId}'
                   and (m.prod_dept_id = '${prodDeptId}' or
                       '${prodDeptId}' is null)
                   and (m.prod_date >=
                       to_date('${prodDateBegin}', 'yyyy-mm-dd') or
                       '${prodDateBegin}' is null)
                   and (m.prod_date <=
                       to_date('${prodDateEnd}', 'yyyy-mm-dd') or
                       '${prodDateEnd}' is null)
                 order by s.long_name,
                          m.prod_date desc,
                          m.prod_dept_name,
                          d.shift,
                          d.model_name,
                          d.lot) l
          left join (select *
                      from tm_resistance_rate
                     where organ_id = '${organId}') r
            on l.s_electrical_resistivity = r.resistance_rate
          left join (select *
                      from tm_model_gear
                     where organ_id = '${organId}') g
            on l.model_name = g.model_name
          left join (select *
                      from v_sa_dictionary
                     where code = 'cellThickness') sd
            on l.lot like '%-' || sd.name || '%') t
 where 1 = 1 ${authority}

