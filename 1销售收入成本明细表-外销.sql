SELECT FF.*,FF.数量*FF.成本价 成本金额,ff.收入确认月份 结转月份,' ' 销售成本结转凭证号 from (
SELECT  F.FCY_0 地点,F.INVTYP_0 发票类别,D.YBPCPOH_0 合同号,C.ORDDAT_0 合同日期,F.BPR_0 客户代码,A1.BPCNAM_0 客户全称,e1.Eecict_0 交货方式,e.ITMREF_0 产品代码,B1.itmwei_0 单重,
B1.ITMDES1_0 产品型号,B1.ITMDES3_0 产品名称,B2.shodes_0 产品大类,e.QTY_0 数量,f.Cur_0 货币,f.ratmlt_0 汇率,e.Netpri_0 含税单价,e.Netprinot_0 不含税价,
case when f.INVTYP_0=2 then -e.AMTATILIN_0 else e.AMTATILIN_0 end 含税金额,case when f.INVTYP_0=2 then -e.AMTNOTLIN_0 else e.AMTNOTLIN_0 end 不含税额,
e.QTY_0*e.Netpri_0*f.ratmlt_0 人民币金额,e.Yshiplin_0 行运费,e.Discrgval1_0 行运费1,E1.INVDTAAMT_0 运费合计,
case when F.INVTYP_0=2 then p1.Rtndat_0 ELSE a.DLVDAT_0 END 发货日,
case when F.INVTYP_0=2 then p1.srhnum_0 else A.SDHNUM_0 END 发货单号,F.ACCDAT_0 开票日期,F.NUM_0 系统发票号,F.YSIH_0 纸质发票号,
F.YBGRQ_0 报关日期,F.YBGDH_0 报关单号,F.YTDH_0 提单号,F.YTDRQ_0 提单日期,
  TO_CHAR(F.ACCDAT_0,'MM')  收入确认月份,G.NUM_0 收入确认凭证号,b3.Y2MPRI_0 成本价 FROM SINVOICE F --销售发票表头
LEFT JOIN SINVOICEV E1 ON F.NUM_0=E1.NUM_0 ---销售发票成本
LEFT JOIN SINVOICED E ON F.NUM_0=E.NUM_0 AND F.cpy_0=E.cpy_0 --销售发票明细表
LEFT JOIN GACCENTRY G ON E.NUM_0=G.NUM_0--凭证表头
--LEFT JOIN GACCENTRYD G1 ON G.NUM_0=G1.NUM_0 AND (G1.ACC_0='600101' OR G1.ACC_0='600102' OR G1.ACC_0='600103' OR G1.ACC_0='600104' OR G1.ACC_0='605101' OR G1.ACC_0='605102')  --凭证明细
LEFT JOIN SDELIVERYD B ON E.SDHNUM_0=B.SDHNUM_0 AND E.SDDLIN_0=B.SDDLIN_0 AND E.ITMREF_0=B.ITMREF_0 --发货明细表
LEFT JOIN SDELIVERY A ON B.SDHNUM_0=A.SDHNUM_0--发货表头
LEFT JOIN YSDHTAB AA ON aa.Ytuonum_0=a.ytuonum_0 --打托发运
LEFT JOIN SRETURND P ON P.SRHNUM_0=E.srhnum_0 and p.srdlin_0=E.srdlin_0 and p.itmref_0=E.itmref_0  --销售退货明细
LEFT JOIN SRETURN P1 ON P.SRHNUM_0=P1.SRHNUM_0                                                     --销售退货主表
LEFT JOIN SORDERQ D ON B.SOHNUM_0=D.SOHNUM_0 AND B.SOPLIN_0=D.SOPLIN_0 AND B.ITMREF_0=D.ITMREF_0 --订单明细表
LEFT JOIN SORDER C ON D.SOHNUM_0=C.SOHNUM_0 --订单表头
LEFT JOIN BPCUSTOMER A1 ON F.BPR_0=A1.BPCNUM_0  --客户表
LEFT JOIN ITMMASTER B1 ON E.ITMREF_0=B1.ITMREF_0--产品表
LEFT JOIN YAID1101 B2 ON B1.YCP01_0=B2.code_0
left join YXSFBCBB B3 ON E.SALFCY_0=B3.SALFCY_0 AND E.NUM_0=B3.NUM_0 AND E.SIDLIN_0=B3.SIDLIN_0) FF-- 大类
WHERE FF.地点='S0601' AND TO_CHAR(FF.开票日期,'YYYYMM') BETWEEN '${起}' and '${止}'
order by FF.地点,FF.开票日期,FF.客户代码,ff.合同号



