select
    CONCAT_WS('/',b2.ERP_BAS_ID,IFNULL(b3.PK_CORP,''),IFNULL(b2.line_name,'')) uuid, 
    b2.line_code,
    b2.line_name,
    b2.ERP_BAS_ID,
    b2.`NAME`,
    b3.PK_CORP,
	b3.`NAME` as orgname,
    sum(b1.unpurnum)/1000 unpurnum,sum(b1.undelnum)/1000 undelnum,sum(b1.onwaynum)/1000 onwaynum
from (select org.PK_CORP,org.NAME,a1.mate_id,sum(if(a1.con_num<ifnull(a1.order_num,0),0,a1.con_num-ifnull(a1.order_num,0))) unpurnum,
        0 undelnum,0 onwaynum
        from (select t1.id,t1.com_id,t1.mate_id,(if(t1.con_num<ifnull(sum(t2.con_num),0),0,t1.con_num-ifnull(sum(t2.con_num),0))) con_num,t1.order_num from (SELECT
																																								t_cot_main.`code`,
																																								t_cot_main.up_cot_code,
																																								t_cot_main.id,
																																								t_cot_main.up_cot_id,
																																								t_cot_main.state,
																																								t_cot_main.com_id,
																																								t_cot_mate.mate_id,
																																								t_cot_mate.con_num,
																																								sum(t_tra_purchase_lines.order_num) order_num
																																							FROM
																																								t_cot_main
																																							INNER JOIN t_cot_mate ON t_cot_main.id = t_cot_mate.con_id
																																							LEFT JOIN t_tra_purchase_lines ON t_cot_mate.id = t_tra_purchase_lines.con_mate_id AND t_tra_purchase_lines.is_deleted = 0
																																							where t_cot_main.IS_DELETED = 0 and t_cot_mate.is_deleted = 0
																																								and t_cot_main.sign_date >= DATE_FORMAT(DATE_SUB(CURDATE(),INTERVAL 1 year),'%Y-%m-%d %H:%i:%s')
																																							/*    and t_cot_main.sign_date <= DATE_FORMAT(DATE_ADD(CURDATE(),INTERVAL 1 month),'%Y-%m-%d %H:%i:%s')*/
																																								${if(len(invs)=0,"","AND t_cot_mate.mate_id in (SELECT invb.ID FROM t_arc_inventory_base AS invb WHERE invb.IS_DELETED = 0 AND invb.ERP_BAS_ID in ('"+invs+"'))")}
																																							group by t_cot_main.`code`,
																																									t_cot_main.up_cot_code,
																																									t_cot_main.id,
																																									t_cot_main.up_cot_id,
																																									t_cot_main.state,
																																									t_cot_main.com_id,
																																									t_cot_mate.mate_id,
																																									t_cot_mate.con_num) t1
                left join (SELECT
								t_cot_main.`code`,
								t_cot_main.up_cot_code,
								t_cot_main.id,
								t_cot_main.up_cot_id,
								t_cot_main.state,
								t_cot_main.com_id,
								t_cot_mate.mate_id,
								t_cot_mate.con_num,
								sum(t_tra_purchase_lines.order_num) order_num
							FROM
								t_cot_main
							INNER JOIN t_cot_mate ON t_cot_main.id = t_cot_mate.con_id
							LEFT JOIN t_tra_purchase_lines ON t_cot_mate.id = t_tra_purchase_lines.con_mate_id AND t_tra_purchase_lines.is_deleted = 0
							where t_cot_main.IS_DELETED = 0 and t_cot_mate.is_deleted = 0
								and t_cot_main.sign_date >= DATE_FORMAT(DATE_SUB(CURDATE(),INTERVAL 1 year),'%Y-%m-%d %H:%i:%s')
							/*    and t_cot_main.sign_date <= DATE_FORMAT(DATE_ADD(CURDATE(),INTERVAL 1 month),'%Y-%m-%d %H:%i:%s')*/
								${if(len(invs)=0,"","AND t_cot_mate.mate_id in (SELECT invb.ID FROM t_arc_inventory_base AS invb WHERE invb.IS_DELETED = 0 AND invb.ERP_BAS_ID in ('"+invs+"'))")}
							group by t_cot_main.`code`,
									t_cot_main.up_cot_code,
									t_cot_main.id,
									t_cot_main.up_cot_id,
									t_cot_main.state,
									t_cot_main.com_id,
									t_cot_mate.mate_id,
									t_cot_mate.con_num) t2 on t2.up_cot_id=t1.id and t2.mate_id=t1.mate_id
                where t1.state in ('useful','approved','approve')
                group by t1.id,t1.com_id,t1.mate_id,t1.con_num) a1
            inner JOIN t_cot_main AS cm on cm.id=a1.id and cm.IS_DELETED=0
            right JOIN t_org_company_relation AS org ON a1.com_id=org.com_id and org.IS_DELETED=0
            where 1=1
            and org.pk_corp is not null and org.sealflag = 0
                /*????*/
                ${if(len(orgs)=0,"","AND org.PK_CORP in ('"+REPLACE(orgs, ",", "','")+"')")}
                /*??????*/
                ${if(jctype=0,"AND cm.post_flg=0","")}
            group by org.PK_CORP,org.NAME,a1.mate_id
        union
        select PK_CORP,NAME,pur.mate_id,0 unpurnum,sum(pur.undelnum) undelnum,0 onwaynum from (SELECT
																									tpl.delivery_com,
																									org.PK_CORP,
																									org.NAME,
																									tpl.mate_id,
																									sum(if(tpl.order_num<IFNULL(tpl.send_cnt,0),0,tpl.order_num-IFNULL(tpl.send_cnt,0))) undelnum
																								FROM
																									t_tra_purchase AS tp
																								INNER JOIN t_tra_purchase_lines AS tpl ON tp.id = tpl.pur_id
																								inner JOIN t_cot_main AS cm ON tp.con_id=cm.id and cm.IS_DELETED=0
																								right JOIN t_org_company_relation AS org ON tpl.delivery_com=org.com_id and org.IS_DELETED=0
																								where tp.is_deleted = 0 and tpl.is_deleted = 0
																										and tp.order_date >= DATE_FORMAT(DATE_SUB(CURDATE(),INTERVAL 1 year),'%Y-%m-%d')
																										and tp.status <> 'closed'
																										and org.pk_corp is not null and org.sealflag = 0
																										and org.PK_CORP not in ('1003','2125','2170')
																										/*????*/
																										${if(len(orgs)=0,"","AND org.PK_CORP in ('"+REPLACE(orgs, ",", "','")+"')")}
																										/*??????*/
																										${if(jctype=0,"AND cm.post_flg=0","")}
																										${if(len(invs)=0,"","AND tpl.mate_id in (SELECT invb.ID FROM t_arc_inventory_base AS invb WHERE invb.IS_DELETED = 0 AND invb.ERP_BAS_ID in ('"+invs+"'))")}
																								group by tpl.delivery_com,
																											org.PK_CORP,
																											org.NAME,
																											tpl.mate_id) pur group by PK_CORP,NAME,pur.mate_id
        union
        select PK_CORP,NAME,onway.mate_id,0 unpurnum,0 undelnum,sum(onway.onwaynum) onwaynum from (select a1.pk_corp,a1.NAME,a1.mate_id,sum(a1.onwaynum) onwaynum
																										from (SELECT
																											oh.deliver_code,
																											oh.con_code,
																											oh.send_date,
																											oh.delivery_com,
																											org.PK_CORP,
																											org.NAME,
																											oh.status,
																											ob.mate_id,
																											ob.send_cnt,
																											sum(os.storage_cnt) storage_cnt,
																											if(ob.send_cnt<IFNULL(sum(os.storage_cnt),0),0,ob.send_cnt-IFNULL(sum(os.storage_cnt),0)) onwaynum
																										FROM
																											t_tra_order AS oh
																										INNER JOIN t_tra_order_mates AS ob ON oh.id = ob.deliver_id
																										inner JOIN t_cot_main AS cm on cm.code=oh.con_code and cm.IS_DELETED=0
																										right JOIN t_org_company_relation AS org ON oh.delivery_com=org.com_id and org.IS_DELETED=0
																										LEFT JOIN t_tra_storage AS os ON oh.arrival_id = os.arrive_id AND os.is_deleted = 0
																										WHERE
																											oh.is_deleted = 0 AND
																											ob.is_deleted = 0
																											and org.pk_corp is not null and org.sealflag = 0
																											and oh.send_date >= DATE_SUB(curdate(),interval 30 day)
																											and oh.status not in ('set','CLOSED')
																											/*????*/
																											${if(len(orgs)=0,"","AND org.PK_CORP in ('"+REPLACE(orgs, ",", "','")+"')")}
																											/*??????*/
																											${if(jctype=0,"AND cm.post_flg=0","")}
																											${if(len(invs)=0,"","AND ob.mate_id in (SELECT invb.ID FROM t_arc_inventory_base AS invb WHERE invb.IS_DELETED = 0 AND invb.ERP_BAS_ID in ('"+invs+"'))")}
																										GROUP BY oh.deliver_code,
																												oh.con_code,
																												oh.send_date,
																												oh.delivery_com,
																												oh.status,
																												ob.mate_id,
																												ob.send_cnt) a1
																										group by a1.pk_corp,a1.NAME,a1.mate_id) onway group by PK_CORP,NAME,onway.mate_id) b1
inner join (
			SELECT
				invb.ID,
				invb.ERP_BAS_ID,
				invb.`CODE`,
				invb.`NAME`,
				lb.line_code,
				lb.line_name
			FROM
				t_arc_inventory_base AS invb
			INNER JOIN t_arc_inventory AS inv ON invb.ID = inv.BASE_ID
			left JOIN t_arc_business_base AS lb ON inv.BUSINESS_LINE = lb.id AND lb.is_deleted = 0
			WHERE
				invb.IS_DELETED = 0 AND
				inv.IS_DELETED = 0
				AND lb.line_name in ('???','???','????','????','???','???'/* ,'?????' *//* ,'???' */,'??','??-?????','??-?????','??-?????','??！???','??！????','??！???','????','????'/* ,'????-??' *//*,'????-??'*//* ,'??' */)
				/*????*/
				${if(len(lines)=0,"","AND lb.line_code in ('"+lines+"')")}
				/*????*/
				${if(len(invs)=0,"","AND invb.ERP_BAS_ID in ('"+invs+"')")}
			order by lb.line_code,lb.line_name,invb.`NAME`) b2 on b2.ID=b1.mate_id
inner join t_org_company_relation b3 on b3.pk_corp is not null and b3.sealflag = 0 and b3.is_deleted=0 and b1.pk_corp=b3.pk_corp
where 1=1
and exists (select 1 from org_to_scm ots where b3.pk_corp=ots.pk_corp)
group by b2.line_code,
        b2.line_name,
        b2.ERP_BAS_ID,
        b2.`NAME`,b3.PK_CORP,b3.`NAME`
having sum(b1.unpurnum)/1000 <> 0 or sum(b1.undelnum)/1000<>0 or sum(b1.onwaynum)/1000 <> 0
order by b2.line_code,
        b2.line_name,
        b2.ERP_BAS_ID,
        b2.`NAME`,b3.PK_CORP,b3.`NAME`

with /*????-????*/ plan as (SELECT
    t1.PK_CORP,
    t1.ITEM_ID,/* ??nc?? */
    t1.PLAN_QTY,/* ???? */
    t1.PLAN_QTY*t2.MONTH_DAYS MONTH_DAYS/* ???? */,
    t1.PLAN_QTY/to_number(to_char(last_day(TO_DATE('${edate}','YYYY-MM-DD')),'dd')) dayoutplan
FROM (
    /* ????????plan_stage????? */
    SELECT
        PK_CORP,
        ITEM_ID,/* ??nc?? */
        PLAN_QTY/* ???? */
    FROM(
        SELECT
            PK_CORP,
            ITEM_ID,/* ??nc?? */
            SUM(PLAN_QTY) PLAN_QTY,/* ???? */
            ROW_NUMBER() OVER(partition by PK_CORP,ITEM_ID order by plan_stage desc) rk /* ?PK_CORP,ITEM_ID???plan_stage??????????? */
        FROM NCZB.T_MRP_EXPEND_PLAN@slncbi a,NCZB.T_MRP_EXPEND_PLAN_LINE@slncbi b
        where
            a.plan_ym = substr('${edate}', 0, 7) /* ???????????? */
            and a.id =b.plan_id
        GROUP BY PK_CORP,ITEM_ID,plan_stage
    )
    WHERE rk = 1 /* ????????? */
)t1
LEFT JOIN (
    /* ????????plan_stage????? */
    SELECT
        PK_CORP,
        ITEM_ID,/* ??nc?? */
        MONTH_DAYS/* ???? */
    FROM(
        SELECT
            PK_CORP,
            ITEM_ID,/* ??nc?? */
            MONTH_DAYS,/* ???? */
            ROW_NUMBER() OVER(partition by PK_CORP,ITEM_ID order by plan_stage desc) rk /* ?PK_CORP,ITEM_ID???plan_stage??????????? */
        FROM NCZB.T_MRP_STRATEGY_PLAN@slncbi a,NCZB.T_MRP_STRATEGY_PLAN_LINE@slncbi b
        where
            a.plan_ym = substr('${edate}', 0, 7) /* ???????????? */
            and a.id =b.plan_id
    )
    WHERE rk = 1 /* ????????? */
)t2 ON t2.PK_CORP = t1.PK_CORP AND t2.ITEM_ID = t1.ITEM_ID),
/*????-????-????*/ NCstore as (
SELECT
    t2.PK_CORP,
    t2.pk_invbasdoc,
    round(sum(startnum) + SUM(NINNUM) - SUM(NOUTNUM),2) qmnum, /*????*/
    round(sum(buyout),2) buyout, /*??????*/
    sum(buyin) buyin,
    decode((to_number(to_char(TO_DATE('${edate}','YYYY-MM-DD'),'dd'))-1),0,0,sum(buyout1)/(to_number(to_char(TO_DATE('${edate}','YYYY-MM-DD'),'dd'))-1)) dayouthy
FROM (
    SELECT
        t1.PK_CORP,
        t1.pk_invbasdoc,
        sum(startnum) STARTNUM,
        SUM(NINNUM) NINNUM,
        SUM(NOUTNUM) NOUTNUM,
        SUM(buyout) buyout,
		SUM(buyout1) buyout1,
        sum(buyin) buyin
    FROM (
        SELECT
            PK_CORP,
            pk_invbasdoc,
            sum(qcnum) STARTNUM,
            SUM(NINNUM) NINNUM,
            SUM(NOUTNUM) NOUTNUM,
            SUM(buyout) buyout,
			SUM(buyout1) buyout1,
            sum(buyin) buyin
        FROM (
            /* ?????? */
            SELECT
                pk_corp,
                pk_invbasdoc,
                qcnum,
                0 NINNUM,
                0 NOUTNUM,
                0 buyout,
				0 buyout1,
                0 buyin
            FROM t_accountnum
            where edate = substr('${sdate}',0,7)

            union all

            /* ????????? */
            SELECT
                T1.PK_CORP,
                T1.CINVBASID,
                0 qcnum,
                sum(NVL(T1.NINNUM, 0)) innum,
                sum(NVL(T1.NOUTNUM, 0)) outnum,
                sum(case when t1.cbodybilltypecode = '4D' then NVL(T1.NOUTNUM, 0) else 0 end) buyout,
				sum(case when t1.cbodybilltypecode = '4D' and t1.dbizdate between '${sdate}' and to_char(TO_DATE('${edate}','YYYY-MM-DD')-1,'YYYY-MM-DD') then NVL(T1.NOUTNUM, 0) else 0 end) buyout1,
                sum(case when t1.cbodybilltypecode = '45' then NVL(T1.NINNUM, 0) else 0 end) buyin
            FROM NCZB.IC_GENERAL_B T1
            where
                t1.dr = 0
                and t1.dbizdate between '${sdate}' and '${edate}'
            GROUP BY T1.PK_CORP, T1.CINVBASID
        )
        GROUP BY PK_CORP, pk_invbasdoc
    ) t1
    group by t1.PK_CORP,t1.pk_invbasdoc
) t2
group by t2.PK_CORP,t2.pk_invbasdoc
having SUM(NINNUM) != 0 or SUM(NOUTNUM) != 0 or sum(startnum) != 0),
/*??????*/ dayoutnum as (
select 
PK_CORP,
CINVBASID,
BUYOUT90/90 dayout90,
BUYOUT60/60 dayout60,
BUYOUT30/30 dayout30,
decode(BUYOUT30,0,decode(BUYOUT60,0,nvl(BUYOUT90,0)/90,BUYOUT60/60),BUYOUT30/30) dayout30s,
BUYOUT15/15 dayout15,
decode(BUYOUT15,0,decode(BUYOUT30,0,decode(BUYOUT60,0,nvl(BUYOUT90,0)/90,BUYOUT60/60),BUYOUT30/30),BUYOUT15/15) dayout15s
from (SELECT T1.PK_CORP, T1.CINVBASID,
sum(case when t1.dbizdate between
to_char(to_date('${edate}', 'yyyy-mm-dd') - 90, 'yyyy-mm-dd') and
'${edate}' then NVL(T1.NOUTNUM, 0) else 0 end) buyout90,
sum(case when t1.dbizdate between
to_char(to_date('${edate}', 'yyyy-mm-dd') - 60, 'yyyy-mm-dd') and
'${edate}' then NVL(T1.NOUTNUM, 0) else 0 end) buyout60,
sum(case when t1.dbizdate between
to_char(to_date('${edate}', 'yyyy-mm-dd') - 30, 'yyyy-mm-dd') and
'${edate}' then NVL(T1.NOUTNUM, 0) else 0 end) buyout30,
sum(case when t1.dbizdate between
to_char(to_date('${edate}', 'yyyy-mm-dd') - 15, 'yyyy-mm-dd') and
'${edate}' then NVL(T1.NOUTNUM, 0) else 0 end) buyout15
FROM NCZB.IC_GENERAL_B T1
where t1.dr = 0
and t1.cbodybilltypecode = '4D'
and t1.dbizdate between
to_char(to_date('${edate}', 'yyyy-mm-dd') - 90, 'yyyy-mm-dd') and
'${edate}'
GROUP BY T1.PK_CORP, T1.CINVBASID))
/*result*/
select (b1.ITEM_ID||'/'||b1.PK_CORP||'/'||b2.LINE_NAME) uuid,
		b1.PK_CORP,
		b1.ITEM_ID,
		sum(PLAN_QTY)/1000 PLAN_QTY,
		sum(MONTH_DAYS)/1000 MONTH_DAYS,
		sum(qmnum)/1000 qmnum,
		sum(buyout)/1000 buyout,
		sum(buyin)/1000 buyin,
		sum(dayout)/1000 dayout
from (select T1.PK_CORP,t1.ITEM_ID,sum(PLAN_QTY) PLAN_QTY,sum(t1.MONTH_DAYS) MONTH_DAYS,0 qmnum,0 buyout,0 buyin, 0 dayout  from plan t1
		group by T1.PK_CORP,t1.ITEM_ID
		union
		select T2.PK_CORP,t2.pk_invbasdoc,0 PLAN_QTY,0 MONTH_DAYS,sum(qmnum) qmnum,sum(buyout) buyout,sum(buyin) buyin,0 dayout from NCstore t2
		group by T2.PK_CORP,t2.pk_invbasdoc
		union
		select T3.PK_CORP,T3.ITEM_ID,0 PLAN_QTY,0 MONTH_DAYS,0 qmnum,0 buyout,0 buyin,sum(dayout) dayout from
		(select PK_CORP,ITEM_ID,
		/*????*/
		${switch(hytype,0,"decode(sum(dayoutplan),0,decode(sum(dayouthy),0,sum(dayout30s),sum(dayouthy)),sum(dayoutplan)) dayout",
						1,"decode(sum(dayouthy),0,decode(sum(dayoutplan),0,sum(dayout30s),sum(dayoutplan)),sum(dayouthy)) dayout",
						2,"sum(dayout15s) dayout",
						3,"sum(dayout30s) dayout")}
			from (select PK_CORP,ITEM_ID,dayoutplan,0 dayouthy,0 dayout15s,0 dayout30s from plan
					union 
					select PK_CORP,pk_invbasdoc, 0 dayoutplan,dayouthy,0 dayout15s,0 dayout30s from NCstore
					union
					select PK_CORP,CINVBASID,0 dayoutplan,0 dayouthy,dayout15s,dayout30s from dayoutnum) group by pk_corp,item_id) t3
		group by T3.PK_CORP,T3.ITEM_ID) b1
inner join scm_inv_business@zbnm b2 on b1.item_id=b2.PK_INVBASDOC
where 1=1
and b2.line_name in ('???','???','????','????','???','???'/* ,'?????' *//* ,'???' */,'??','??-?????','??-?????','??-?????','??！???','??！????','??！???','????','????'/* ,'????-??' *//*,'????-??'*//* ,'??' */)
/*????*/
${if(len(orgs)=0,"","AND b1.PK_CORP in ('"+REPLACE(orgs, ",", "','")+"')")}
/*????*/
${if(len(lines)=0,"","AND exists (select 1 from zbnm.scm_inv_business@zbnm t where t.PK_INVBASDOC=b1.ITEM_ID and t.LINE_CODE in ('"+lines+"'))")}
/*????*/
${if(len(invs)=0,"","AND b1.ITEM_ID in ('"+invs+"')")}
and exists ( select pk_corp from (select a1.FID,
										   a1.FNAME,
										   a1.FCODE,
										   a1.pk_corp,
										   a1.PARENTID,
										   a2.orgname pfname,
										   a2.orgcode pfcode,
										   a1.FLEVEL
									  from (SELECT t1.pk_zbesb_org FID,
												   orgname         FNAME,
												   orgcode         FCODE,
												   pk_parent       PARENTID,
												   LEVEL           FLEVEL,
												   t2.link_corp    pk_corp
											  FROM nczb.zbesb_org t1
											  left join nczb.zbesb_org_b t2 on t1.pk_zbesb_org =
																					t2.pk_zbesb_org
																				and nvl(t2.dr, 0) = 0 and t2.link_corp is not null
											 WHERE nvl(t1.dr, 0) = 0
											   and sealflag = 'N'
											 start with t1.pk_zbesb_org = '0001211000000016L62I' /*?????(??)*/
											CONNECT BY PRIOR t1.pk_zbesb_org = pk_parent) a1
									  left join nczb.zbesb_org a2 on a2.pk_zbesb_org = a1.PARENTID
																	  and nvl(a2.dr, 0) = 0
																	  and sealflag = 'N'
									  order by fcode) org where org.pk_corp =b1.pk_corp )
group by b1.PK_CORP,b2.LINE_NAME,b1.ITEM_ID
having sum(PLAN_QTY) <> 0 
		or sum(MONTH_DAYS) <> 0
		or sum(qmnum) <> 0
		or sum(buyout) <> 0
		or sum(buyin) <> 0
		or sum(dayout) <> 0
order by b1.PK_CORP,b2.LINE_NAME,b1.ITEM_ID

select lb.line_name,lb.line_code from t_arc_business_base AS lb
WHERE
    lb.is_deleted = 0
    AND lb.line_name in ('???','???','????','????','???','???'/* ,'?????' *//* ,'???' */,'??','??-?????','??-?????','??-?????','??！???','??！????','??！???','????','????'/* ,'????-??' *//*,'????-??'*//* ,'??' */)
order by lb.line_code    

select '1020801' FCODE,'????' FNAME,'1003' LINK_CORP from dual 
union
select * from
(SELECT distinct t1.FCODE, t1.FNAME,t1.LINK_CORP
    FROM V_ORG02_LEVEL t1
      where exists (SELECT 1
          FROM (SELECT t1.user_id, t1.user_name, t1.org_id
                  FROM sys_user t1
                 WHERE t1.status = 0
                   and t1.user_name = '${fr_username}'
                union
                SELECT t1.user_id, t1.user_name, t2.org_id
                  FROM sys_user t1
                 inner join sys_user_org t2
                    on t1.user_id = t2.user_id
                 WHERE t1.status = 0
                   and t1.user_name = '${fr_username}')t3 where t3.org_id = t1.LINK_CORP)
                   and t1.LINK_CORP<>'1316' 
order by t1.FCODE)                               

SELECT ORB.LINK_CORP PK_CORP,
       ORG.ORGCODE,
       ORG.ORGNAME,
       ORG.PK_ZBESB_ORG,
       t1.unitname
  FROM NCZB.ZBESB_ORG@SLNC   ORG,
       NCZB.ZBESB_ORG_B@SLNC ORB,
       NCZB.BD_CORP@SLNC     T1
 WHERE ORG.DR = 0
       AND ORB.DR = 0
       AND ORG.SEALFLAG = 'N'
       AND ORB.LINK_CORP IS NOT NULL
       AND ORG.PK_ZBESB_ORG = ORB.PK_ZBESB_ORG
       AND T1.PK_CORP = ORB.LINK_CORP
       AND ORG.ORGCODE LIKE '102%'
 ORDER BY ORG.ORGCODE

