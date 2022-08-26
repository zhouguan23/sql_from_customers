select t1.emp_no,
       t1.emp_name,
       t1.organ_name,
       t1.dept_name,
       t1.business_group_name,
       t1.duty,
	  t1.person_id,
       t2.full_id,
       t5.name station_seq,
	  t3.id evaluation_item_id,
       t3.code evaluation_item_code,
       t3.name evaluation_item_name,
       t3.period_date,
       t6.name eval_relation,
	  t1.eval_archive_id,
	  t4.name||'('||t4.employeeno||')' employee_name,
       t4.employeeno,
       t4.name,
       t1.answer_start_time,
       t1.answer_end_time,
       t1.answer_duration,
       t7.name is_valid,
       t1.max_answer_proportion
  from hr_qs_eval_rela_job t1
  left join hr_humanarchive t2
    on t2.id = t1.archive_id
  left join hr_qs_evaluation_item t3
    on t3.id = t1.eval_item_id
  left join hr_humanarchive t4
    on t4.id = t1.eval_archive_id
  left join v_sa_dictionary t5
    on t5.code='positionSequence' 
    and t5.value=t2.station_seq
  left join v_sa_dictionary t6
    on t6.code='qsEvalRelation'
    and t6.value=t1.eval_relation
  left join v_sa_dictionary t7
    on t7.code='yesorno'
    and t7.value=t1.is_valid
 where t3.id = '${itemId}'
 and t1.status = 1
 and t1.eval_status = 3
	${param1}
	${param2}
	${param3}
	${param4}
	${param5}
	${param6}
	${param7}
	${param8}
	${param9}
	${param10}
	${param11}
	${param12}
	${param13}
	${param14}
	${param15}
 order by t1.emp_name

select *
  from (select t1.title, t1.sequence, t2.*
          from hr_qs_topic t1
          left join (select t1. eval_item_id,
                           t1.eval_head_id,
                           t1.eval_archive_id,
                           t1.person_id,
                           t1.topic_id,
                           to_char(sum(t2.op_score)) op_content
                      from hr_qs_eval_rela_job_option t1, hr_qs_option t2
                     where t2.id = t1.option_id
                     group by t1.eval_archive_id,
                              t1.eval_head_id,
                              t1.eval_item_id,
                              t1.person_id,
                              t1.topic_id) t2
            on t1.id = t2.topic_id
         where t2.eval_item_id = '${itemId}'
           and t1.qs_type != '3'
        union all
        select t1.title,
               t1.sequence,
               t2.eval_item_id,
               t2.eval_head_id,
               t2.eval_archive_id,
               t2.person_id,
               t2.topic_id,
               t2.topic_value op_content
          from hr_qs_topic t1
          left join hr_qs_eval_rela_job_option t2
            on t1.id = t2.topic_id
         where t2.eval_item_id = '${itemId}'
           and t1.qs_type = '3') t
 order by t.sequence


