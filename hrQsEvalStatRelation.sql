SELECT T.ID, T. LEV, T2.NAME
  FROM (SELECT T.ID, T.INDEX_ID, LEVEL AS LEV
          FROM HR_QS_INDEX_CFG T
         WHERE T.ITEM_ID = '${itemId}'
         START WITH PARENT_ID = '${itemId}'
        CONNECT BY PRIOR ID = PARENT_ID) T,
       HR_QS_EVALUATION_INDEX T2
 WHERE T2.ID = T.INDEX_ID
 ORDER BY T.LEV

select t2.*,
       t.index_cfg_id,
       t.score,
       t4.code,
       t4.name,
       t4.period_date,
       t5.name eval_relation
  from hr_qs_stat_eval_archive_score t
  left join (select t1.*,
                    t2.station_seq,
                    t3.name        station_seq_text_view,
                    t4.score       total_score,
                    nvl(t4.eval_relation,'1') eval_relation
               from hr_qs_eval_body t1
               left join hr_humanarchive t2
                 on t2.id = t1.archive_id
               left join v_sa_dictionary t3
                 on t3.code = 'positionSequence'
                and t3.value = t2.station_seq
               left join hr_qs_stat_eval_archive_score t4
                 on t4.eval_archive_id = t1.archive_id
                and t4.index_cfg_id = 'root'
                and t4.eval_item_id = '${itemId}'
               where t1.source_id='${itemId}') t2
    on t.eval_archive_id = t2.archive_id
  left join hr_qs_evaluation_item t4
    on t4.id = t.eval_item_id
  left join v_sa_dictionary t5
    on t5.code = 'qsEvalRelation'
   and t5.value = t.eval_relation
 where t.eval_item_id = '${itemId}'
 and t2.eval_relation=nvl(t.eval_relation,'1')
 order by t5.sequence,t5.name
 	${param1}
	${param2}
	${param3}
	${param4}
	${param5}
	${param6}
	

