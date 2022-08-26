select b.id ogn_dept_id,
       b.ogn_name,
       b.name,
       tt.station,
       vd.name station_name,
       tt.duty,
       b.full_sequence,
       sum(tt.personnel_quota_num) personnel_quota_num,
       sum(tt.dept_person_qty) dept_person_qty,
       sum(tt.organization_person_qty) organization_person_qty,
       sum(tt.personnel_quota_num) - sum(tt.dept_person_qty) less_dept_person_qty,
       sum(tt.personnel_quota_num) - sum(tt.organization_person_qty) less_organization_person_qty,
       sum(tt.leaveing_person_qty) leaveing_person_qty,
       decode(sum(tt.personnel_quota_num),
              0,
              null,
              round(sum(tt.dept_person_qty) / sum(tt.personnel_quota_num) * 100,
                    2)) dept_person_rate,
       decode(sum(tt.personnel_quota_num),
              0,
              null,
              round((sum(tt.dept_person_qty) - sum(tt.leaveing_person_qty)) /
                    sum(tt.personnel_quota_num) * 100,
                    2)) leaving_rate
  from (select nvl(sd.target_dept_id, th.dept_id) dept_id,
               th.station,
               th.duty,
               nvl(th.personnel_quota_num, 0) personnel_quota_num,
               nvl(th.person_qty, 0) dept_person_qty,
               nvl(ts.person_qty, 0) organization_person_qty,
               nvl(td.leaveing_person_qty, 0) leaveing_person_qty
          from (select dept_id,
                       station,
                       duty,
                       sum(personnel_quota_num) personnel_quota_num,
                       sum(person_qty) person_qty
                  from (select q.dept_id,
                               q.station,
                               ds.duty,
                               sum(nvl(q.adjust_personnel_quota_num,
                                       q.personnel_quota_num)) personnel_quota_num,
                               0 person_qty
                          from v_sa_oporgproperty           dp,
                               hr_personnel_quota           q,
                               hr_depart_post_information   di,
                               hr_depart_information_depdtl dd,
                               hr_depart_information_stadtl ds
                         where dp.id = q.dept_id
                           and di.id = dd.main_id
                           and di.id = ds.main_id
                           and q.dept_id = dd.dept_id
                           and q.station = ds.station
                           and dp.property_name = 'deptBusinessFormat'
                           and q.year_month =
                               trunc(to_date('${queryDate}', 'yyyy-mm-dd'),
                                     'mm')
                        --部门业态
                         ${if(len(deptBusiness) == 0, "", "and dp.property_value = '" + deptBusiness + "'") }
                         group by q.dept_id, q.station, ds.duty
                        union all
                        select hb.dept_id,
                               hb.station,
                               hb.duty,
                               0 personnel_quota_num,
                               count(*) person_qty
                          from v_sa_oporgproperty      dp,
                               hr_humanarchive_bak_all hb
                         where dp.id = hb.dept_id
                           and hb.bak_date >=
                               to_date('${queryDate}', 'yyyy-mm-dd')
                           and hb.bak_date <
                               to_date('${queryDate}', 'yyyy-mm-dd') + 1
                           and (hb.belonging_company is null or
                               hb.belonging_company = '5')
                           and dp.property_name = 'deptBusinessFormat'
                        --部门业态
                         ${if(len(deptBusiness) == 0, "", "and dp.property_value = '" + deptBusiness + "'") }
                         group by hb.dept_id, hb.station, hb.duty)
                 group by dept_id, station, duty) th,
               (select hb.organization_org_id,
                       hb.station,
                       hb.duty,
                       count(*) person_qty
                  from hr_humanarchive_bak_all hb
                 where hb.bak_date >= to_date('${queryDate}', 'yyyy-mm-dd')
                   and hb.bak_date <
                       to_date('${queryDate}', 'yyyy-mm-dd') + 1
                   and (hb.belonging_company is null or
                       hb.belonging_company = '5')
                 group by hb.organization_org_id, hb.station, hb.duty) ts,
               (select dept_id, station, duty, count(*) leaveing_person_qty
                  from (select td.archive_id,
                               td.station_name station,
                               td.duty,
                               td.dept_id,
                               nvl(dh.attendance_check_date, td.leave_date_exp) leave_date,
                               row_number() over(partition by td.archive_id, td.dept_id order by td.leave_date_exp desc) rn
                          from hr_dm_dimission          td,
                               hr_humanarchive          hh,
                               hr_dm_dimission_handover dh
                         where td.archive_id = hh.id
                           and td.id = dh.source_id(+)
                           and td.status >= 0
                           and (hh.belonging_company is null or
                               hh.belonging_company = '5'))
                 where leave_date >= to_date('${queryDate}', 'yyyy-mm-dd')
                   and rn = 1
                 group by dept_id, station, duty) td,
               hr_sm_hcm_dept_ownership sd
         where th.dept_id = ts.organization_org_id(+)
           and th.station = ts.station(+)
           and th.duty = ts.duty(+)
           and th.dept_id = td.dept_id(+)
           and th.station = td.station(+)
           and th.duty = td.duty(+)
           and th.dept_id = sd.source_dept_id(+)) tt,
       view_hr_base_org b,
       v_sa_dictionary vd
 where tt.dept_id = b.org_id
   and tt.station = vd.value
   and vd.code = 'station'
--基地
 ${if(len(ognName) == 0, "", "and b.ogn_name like '%" + ognName + "%'") }
--部门
 ${if(len(deptName) == 0, "", "and b.name like '%" + deptName + "%'") }
--岗位
 ${if(len(stationName) == 0, "", "and vd.name like '%" + stationName + "%'") }
--职等
 ${if(len(duty) == 0, "", "and tt.duty in (select column_value from (table(split('" + duty + "'))))") }
 group by b.id,
          b.ogn_name,
          b.name,
          b.full_sequence,
          tt.station,
          vd.name,
          tt.duty
 order by full_sequence asc, duty desc, station asc


