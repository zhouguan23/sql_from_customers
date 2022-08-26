SELECT subject,subject_name,group_id,group_name,group_sort,major,major_name,knowledge_id,knowledge_name,parent_knowledge_id,knowledge_level,knowledge_order_idx,sum_judge_score,score_rate,student_id,student_name,is_absent  FROM 
(
SELECT subject,subject_name,group_id,group_name,group_sort,major,major_name,knowledge_id,knowledge_name,parent_knowledge_id,knowledge_level,knowledge_order_idx,sum_judge_score,score_rate,student_id,student_name,is_absent  FROM  "DWH_FINE"."STUDENT_KNOWLEDGE_REPORT"
where exam_no='${exam_no}'
and subject in (${subject_list})
and group_id in (${group_list})
union all
SELECT subject,subject_name,group_id,group_name,group_sort,major,major_name,knowledge_id,knowledge_name,parent_knowledge_id,knowledge_level,knowledge_order_idx,avg_score as sum_judge_score,score_rate,group_sort as student_id,group_name as student_name ,0 as is_absent  FROM  "DWH_FINE"."GROUP_KNOWLEDGE_REPORT"
where exam_no='${exam_no}'
and subject in (${subject_list})
and group_id  in (${group_list})
)
order by subject,knowledge_order_idx,group_sort,is_absent  asc ,student_id desc



SELECT * FROM "DWH_FINE"."GROUP_KNOWLEDGE_REPORT"
where exam_no='${exam_no}'
and subject=1
and parent_knowledge_id=10238150

