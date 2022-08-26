select
--基本属性
${if(find('matnr,zh_maktx',基本属性)!=0,'matnr,zh_maktx,','')}  --物料号
${if(find('ersda',基本属性)!=0,'ersda,','')}  --创建日期
${if(find('ernam,ernam_des',基本属性)!=0,'ernam,ernam_des,','')}  --创建工厂
${if(find('marc_werks,marc_werks_des',基本属性)!=0,'marc_werks,marc_werks_des,','')}  --使用工厂
${if(find('laeda',基本属性)!=0,'laeda,','')}  --最后修改日期
${if(find('first_gstrp',基本属性)!=0,'first_gstrp,','')}  --首次生产日期
${if(find('last_gstrp',基本属性)!=0,'last_gstrp,','')}  --最后生产日期
${if(find('meins,meins_des',基本属性)!=0,'meins,meins_des,','')}  --单位
${if(find('matkl,matkl_des',基本属性)!=0,'matkl,matkl_des,','')}  --物料组
${if(find('lgort,lgort_des',基本属性)!=0,'lgort,lgort_des,','')}  --库存地点
${if(find('if_has_stock',基本属性)!=0,'if_has_stock,','')}  --有无库存
${if(find('prdha,prdha_des',基本属性)!=0,'prdha,prdha_des,','')}  --产品层次
${if(find('mtpos_mara,mtpos_mara_des',基本属性)!=0,'mtpos_mara,mtpos_mara_des,','')}  --普通项目类别组
${if(find('pic1_status',基本属性)!=0,'pic1_status,','')}  --图片1状态
${if(find('pic2_status',基本属性)!=0,'pic2_status,','')}  --图片2状态
${if(find('pic3_status',基本属性)!=0,'pic3_status,','')}  --图片3状态
${if(find('bismt,ot_maktx',基本属性)!=0,'bismt,ot_maktx,','')}  --旧物料号
${if(find('mtart,mtart_des',基本属性)!=0,'mtart,mtart_des,','')}  --物料类型
${if(find('mara_lvorm',基本属性)!=0,'mara_lvorm,','')}  --集团级删除标记
${if(find('marc_lvorm',基本属性)!=0,'marc_lvorm,','')}  --工厂级删除标记
${if(find('mard_lvorm',基本属性)!=0,'mard_lvorm,','')}  --库存地点级删除标记
${if(find('plcode,plname',基本属性)!=0,'plcode,plname,','')}  --品类hybris
${if(find('zccode,zcname',基本属性)!=0,'zccode,zcname,','')}  --法规hybris
${if(find('xlcode,plname',基本属性)!=0,'xlcode,plname,','')}  --系列hybris
${if(find('sabc',基本属性)!=0,'sabc,','')}  --SABChybris
${if(find('jzcode,jzname',基本属性)!=0,'jzcode,jzname,','')}  -- 机种hybris
${if(find('cxcode,cxname',基本属性)!=0,'cxcode,cxname,','')}  --车型hybris
${if(find('pzcode,pzname',基本属性)!=0,'pzcode,pzname,','')}  --配置hybris
${if(find('zcolor',基本属性)!=0,'zcolor,','')}  --颜色
${if(find('zbrake_type,zbrake_type_des',基本属性)!=0,'zbrake_type,zbrake_type_des,','')}  --制动类型
${if(find('enhance_werks,enhance_werks_des',基本属性)!=0,'enhance_werks,enhance_werks_des,','')}  --产地
${if(find('zversion,zversion_des',基本属性)!=0,'zversion,zversion_des,','')}  --版本
${if(find('zecar_model_real',基本属性)!=0,'zecar_model_real,','')}  --车型
${if(find('zserial,zserial_des',基本属性)!=0,'zserial,zserial_des,','')}  --系列
${if(find('zelectrical,zelectrical_des',基本属性)!=0,'zelectrical,zelectrical_des,','')}  --电机
${if(find('zvoltage,zvoltage_des',基本属性)!=0,'zvoltage,zvoltage_des,','')}  --电压
${if(find('zfacadeid',基本属性)!=0,'zfacadeid,','')}  --外观
${if(find('zecar_model,',基本属性)!=0,'zecar_model,','')}  --车型型号
${if(find('znotice_ecar_model',基本属性)!=0,'znotice_ecar_model,','')}  --公告车型 
${if(find('zmotorcycle_type',基本属性)!=0,'zmotorcycle_type,','')}  -- 摩托车类型
${if(find('ztail_box_status',基本属性)!=0,'ztail_box_status,','')}  --尾箱状态
${if(find('zbattery_type,zbattery_type_des',基本属性)!=0,'zbattery_type,zbattery_type_des,','')}  --电池类型
${if(find('zbrake_staut,zbrake_staut_des',基本属性)!=0,'zbrake_staut,zbrake_staut_des,','')}  --刹车状态
${if(find('zvol,zvol_des',基本属性)!=0,'zvol,zvol_des,','')}  --电池型式
${if(find('zshzy,zshzy_des',基本属性)!=0,'zshzy,zshzy_des,','')}  --合格证格式
${if(find('zspeed,zspeed_des',基本属性)!=0,'zspeed,zspeed_des,','')}  --车辆速度
${if(find('zsjgc',基本属性)!=0,'zsjgc,','')}  --世界工厂
${if(find('zdcpp',基本属性)!=0,'zdcpp,','')}  --电池品牌
${if(find('zcdqpp',基本属性)!=0,'zcdqpp,','')}  --充电器品牌
${if(find('zprotect_bar_type,zprotect_bar_type_des',基本属性)!=0,'zprotect_bar_type,zprotect_bar_type_des,','')}  --护杠状态
${if(find('zmiddle_axle_status,zmiddle_axle_status_des',基本属性)!=0,'zmiddle_axle_status,zmiddle_axle_status_des,','')}  --中轴状态
${if(find('zdmod',基本属性)!=0,'zdmod,','')}  --驱动方式
${if(find('zdjfl,zdjfl_des',基本属性)!=0,'zdjfl,zdjfl_des,','')}  --等级分类
${if(find('spec_code,spec_name',基本属性)!=0,'spec_code,spec_name,','')}  --裸车尺寸
${if(find('battery_code,battery_name',基本属性)!=0,'battery_code,battery_name,','')}  --电池
${if(find('theftproof_code,theftproof_name',基本属性)!=0,'theftproof_code,theftproof_name,','')}  --防盗系统
${if(find('controller_code,controller_name',基本属性)!=0,'controller_code,controller_name,','')}  --控制系统
${if(find('trunk_code,trunk_name',基本属性)!=0,'trunk_code,trunk_name,','')}  --尾箱
${if(find('hubs_code,hubs_name',基本属性)!=0,'hubs_code,hubs_name,','')}  --轮毂
${if(find('tire_code,tire_name',基本属性)!=0,'tire_code,tire_name,','')}  --轮胎
${if(find('forks_code,forks_name',基本属性)!=0,'forks_code,forks_name,','')}  --前叉
${if(find('brakesys_code,brakesys_name',基本属性)!=0,'brakesys_code,brakesys_name,','')}  --制动方式
${if(find('motor_code,motor_name',基本属性)!=0,'motor_code,motor_name,','')}  --电机
${if(find('product_ison',基本属性)!=0,'product_ison,','')}  --上下架状态
--销售属性
${if(find('销售',视图选择)!=0,'dwerk,dwerk_des,','')}  --交货工厂
${if(find('销售',视图选择)!=0,'taxm1,taxm1_des,','')}  --税分类
${if(find('销售',视图选择)!=0,'vkorg,vkorg_des,','')}  --销售组织
${if(find('销售',视图选择)!=0,'vtweg,vtweg_des,','')}  --分销渠道
${if(find('销售',视图选择)!=0,'mtpos_mvke,mtpos_mvke_des,','')}  --项目类别组
${if(find('销售',视图选择)!=0,'spart,spart_des,','')}  --产品组
${if(find('销售',视图选择)!=0,'mvgr1,mvgr1_des,','')}  --物料组1
${if(find('销售',视图选择)!=0,'mvgr2,mvgr2_des,','')}  --物料组2
${if(find('销售',视图选择)!=0,'mvgr3,mvgr3_des,','')}  --物料组3
${if(find('销售',视图选择)!=0,'mtvfp,mtvfp_des,','')}  --可用性检查
${if(find('销售',视图选择)!=0,'tragr,tragr_des,','')}  --运输组
${if(find('销售',视图选择)!=0,'ladgr,ladgr_des,','')}  --装载组
${if(find('销售',视图选择)!=0,'stawn,stawn_des,','')}  --商品进口代码
${if(find('销售',视图选择)!=0,'herkl,herkl_des,','')}  --原产地国
${if(find('销售',视图选择)!=0,'herkr,herkr_des,','')}  --货源地
${if(find('销售',视图选择)!=0,'kbetr,','')}  --定价
--采购属性
${if(find('采购',视图选择)!=0,'ekgrp,ekgrp_des,','')}  --采购组
--生产属性
${if(find('生产',视图选择)!=0,'marc_disgr,marc_disgr_des,','')}  --MRP组
${if(find('生产',视图选择)!=0,'marc_dismm,marc_dismm_des,','')}  --MRP类型
${if(find('生产',视图选择)!=0,'marc_dispo,marc_dispo_des,','')}  --MRP控制者
${if(find('生产',视图选择)!=0,'marc_disls,marc_disls_des,','')}  --批量大小
${if(find('生产',视图选择)!=0,'berid,berid_des,','')}  --MRP范围(MRP区域)
${if(find('生产',视图选择)!=0,'mdma_disgr,mdma_disgr_des,','')}  --MRP组(MRP区域)
${if(find('生产',视图选择)!=0,'mdma_dismm,mdma_dismm_des,','')}  --MRP类型(MRP区域)
${if(find('生产',视图选择)!=0,'mdma_dispo,mdma_dispo_des,','')}  --MRP控制者(MRP区域)
${if(find('生产',视图选择)!=0,'mdma_disls,mdma_disls_des,','')}  --批量大小(MRP区域)
${if(find('生产',视图选择)!=0,'mdma_lgpro,mdma_lgpro_des,','')}  --生产仓储地点(MRP区域)
${if(find('生产',视图选择)!=0,'mdma_lgfsb,mdma_lgfsb_des,','')}  --外部采购仓储地点(MRP区域)
${if(find('生产',视图选择)!=0,'beskz,beskz_des,','')}  --采购类型
${if(find('生产',视图选择)!=0,'marc_lgpro,marc_lgpro_des,','')}  --生产仓储地点
${if(find('生产',视图选择)!=0,'marc_lgfsb,marc_lgfsb_des,','')}  --外部采购仓储地点
${if(find('生产',视图选择)!=0,'dzeit,','')}  --自制生产时间
${if(find('生产',视图选择)!=0,'plifz,','')}  --计划交货时间
${if(find('生产',视图选择)!=0,'miskz,miskz_des,','')}  --综合MRP
${if(find('生产',视图选择)!=0,'sbdkz,sbdkz_des,','')}  --独立集中
--财务属性
${if(find('财务',视图选择)!=0,'bwkey,','')}  --评估范围
${if(find('财务',视图选择)!=0,'bklas,bklas_des,','')}  --评估分类
${if(find('财务',视图选择)!=0,'mlast,mlast_des,','')}  --价格确定
${if(find('财务',视图选择)!=0,'vprsv,vprsv_des,','')}  --价格控制
${if(find('财务',视图选择)!=0,'pprdl,','')}  --成本估算期间
${if(find('财务',视图选择)!=0,'pdatl,','')}  --成本估算年度
${if(find('财务',视图选择)!=0,'peinh,','')}  --价格单位
${if(find('财务',视图选择)!=0,'stprs,','')}  --标准价格
${if(find('财务',视图选择)!=0,'verpr,','')}  --移动平均价
row_number()over() as rowid
from
hive.dm.dm_product_info
where
(
${if(isnull(维护是否有误),"1=1","1=0")}
${if(find("项目类别-错",维护是否有误)=0,"","or if_mtpos_error = '错'")}
${if(find("项目类别-对",维护是否有误)=0,"","or if_mtpos_error = '对'")}
${if(find("物料组1/2/3-错",维护是否有误)=0,"","or if_mvgr_error = '错'")}
${if(find("物料组1/2/3-对",维护是否有误)=0,"","or if_mvgr_error = '对'")}
${if(find("产品组-错",维护是否有误)=0,"","or if_spart_error = '错'")}
${if(find("产品组-对",维护是否有误)=0,"","or if_spart_error = '对'")}
${if(find("颜色-错",维护是否有误)=0,"","or if_color_error = '错'")}
${if(find("颜色-对",维护是否有误)=0,"","or if_color_error = '对'")}
)
${if(len(最后修改日期起)=0,'',"and laeda >= '"+最后修改日期起+"'")}
${if(len(最后修改日期止)=0,'',"and laeda <= '"+最后修改日期止+"'")}
${if(len(首次生产日期起)=0,'',"and first_gstrp >= '"+首次生产日期起+"'")}
${if(len(首次生产日期止)=0,'',"and first_gstrp <= '"+首次生产日期止+"'")}
${if(len(最后生产日期起)=0,'',"and last_gstrp >= '"+最后生产日期起+"'")}
${if(len(最后生产日期止)=0,'',"and last_gstrp <= '"+最后生产日期止+"'")}
${if(len(创建日期起)=0,'',"and ersda >= '"+创建日期起+"'")}
${if(len(创建日期止)=0,'',"and ersda <= '"+创建日期止+"'")}
${if(len(创建工厂)=0,'',"and ernam in ('"+创建工厂+"')")}
${if(len(使用工厂)=0,'',"and marc_werks in ('"+使用工厂+"')")}
${if(len(物料号)=0,'',"and matnr in ('"+物料号+"')")}
${if(len(物料组)=0,'',"and matkl in ('"+物料组+"')")}
${if(len(库存地点)=0,'',"and lgort in ('"+库存地点+"')")}
${if(len(有无库存)=0,'',"and if_has_stock in ('"+有无库存+"')")}
${if(len(产品层次)=0,'',"and prdha in ('"+产品层次+"')")}
${if(len(普通项目类别组)=0,'',"and mtpos_mara in ('"+普通项目类别组+"')")}
${if(len(单位)=0,'',"and meins in ('"+单位+"')")}
${if(len(侧面图)=0,'',"and pic1_status in ('"+侧面图+"')")}
${if(len(斜面图)=0,'',"and pic2_status in ('"+斜面图+"')")}
${if(len(正面图)=0,'',"and pic3_status in ('"+正面图+"')")}
${if(len(旧物料号)=0,'',"and bismt in ('"+旧物料号+"')")}
${if(len(物料类型)=0,'',"and mtart in ('"+物料类型+"')")}
${if(len(集团级删除标记)=0,'',"and mara_lvorm in ('"+集团级删除标记+"')")}
${if(len(工厂级删除标记)=0,'',"and marc_lvorm in ('"+工厂级删除标记+"')")}
${if(len(库存地点级删除标记)=0,'',"and mard_lvorm in ('"+库存地点级删除标记+"')")}
${if(len(品类hybris)=0,'',"and plcode in ('"+品类hybris+"')")}
${if(len(法规hybris)=0,'',"and zccode in ('"+法规hybris+"')")}
${if(len(系列hybris)=0,'',"and xlcode in ('"+系列hybris+"')")}
${if(len(SABChybris)=0,'',"and sabc in ('"+SABChybris+"')")}
${if(len(机种hybris)=0,'',"and jzcode in ('"+机种hybris+"')")}
${if(len(车型hybris)=0,'',"and cxcode in ('"+车型hybris+"')")}
${if(len(配置hybris)=0,'',"and pzcode in ('"+配置hybris+"')")}
--颜色
${if(len(颜色hybris)=0,'',"and zcolor in ('"+颜色hybris+"')")}
${if(len(制动类型)=0,'',"and zbrake_type in ('"+制动类型+"')")}
${if(len(产地)=0,'',"and enhance_werks in ('"+产地+"')")}
${if(len(颜色)=0,'',"and zcolor in ('"+颜色+"')")}
${if(len(电机)=0,'',"and zelectrical in ('"+电机+"')")}
${if(len(电压)=0,'',"and zvoltage in ('"+电压+"')")}
${if(len(外观)=0,'',"and zfacadeid in ('"+外观+"')")}
${if(len(车型型号)=0,'',"and zecar_model in ('"+车型型号+"')")}
${if(len(公告车型)=0,'',"and znotice_ecar_model in ('"+公告车型+"')")}
${if(len(摩托车类型)=0,'',"and zmotorcycle_type in ('"+摩托车类型+"')")}
${if(len(尾箱状态)=0,'',"and ztail_box_status in ('"+尾箱状态+"')")}
${if(len(电池类型)=0,'',"and zbattery_type in ('"+电池类型+"')")}
${if(len(刹车状态)=0,'',"and zbrake_staut in ('"+刹车状态+"')")}
${if(len(电池型式)=0,'',"and zvol in ('"+电池型式+"')")}
${if(len(合格证格式)=0,'',"and zshzy in ('"+合格证格式+"')")}
${if(len(车辆速度)=0,'',"and zspeed in ('"+车辆速度+"')")}
${if(len(世界工厂)=0,'',"and zsjgc in ('"+世界工厂+"')")}
${if(len(电池品牌)=0,'',"and zdcpp in ('"+电池品牌+"')")}
${if(len(充电器品牌)=0,'',"and zcdqpp in ('"+充电器品牌+"')")}
${if(len(护杠状态)=0,'',"and zprotect_bar_type in ('"+护杠状态+"')")}
${if(len(中轴状态)=0,'',"and zmiddle_axle_status in ('"+中轴状态+"')")}
${if(len(驱动方式)=0,"","and zdmod in ('"+驱动方式+"')")}
${if(len(等级分类)=0,"","and zdjfl in ('"+等级分类+"')")}
${if(len(裸车尺寸)=0,"","and spec_code in ('"+裸车尺寸+"')")}
${if(len(电池)=0,"","and battery_code in ('"+电池+"')")}
${if(len(防盗系统)=0,"","and theftproof_code in ('"+防盗系统+"')")}
${if(len(控制系统)=0,"","and controller_code in ('"+控制系统+"')")}
${if(len(尾箱)=0,"","and trunk_code in ('"+尾箱+"')")}
${if(len(轮毂)=0,"","and hubs_code in ('"+轮毂+"')")}
${if(len(轮胎)=0,"","and tire_code in ('"+轮胎+"')")}
${if(len(前叉)=0,"","and forks_code in ('"+前叉+"')")}
${if(len(制动方式)=0,"","and brakesys_code in ('"+制动方式+"')")}
${if(len(电机)=0,"","and motor_code in ('"+电机+"')")}   --电机
${if(len(上下架状态)=0,"","and product_ison in ('"+上下架状态+"')")}
${if(len(基本属性)=0,"","group by "+基本属性+"")}
${if(find("销售",视图选择)=0,"",",dwerk,dwerk_des,taxm1,taxm1_des,vkorg,vkorg_des,vtweg,vtweg_des,mtpos_mvke,mtpos_mvke_des,spart,spart_des,mvgr1,mvgr1_des,mvgr2,mvgr2_des,mvgr3,mvgr3_des,mtvfp,mtvfp_des,tragr,tragr_des,ladgr,ladgr_des,stawn,stawn_des,herkl,herkl_des,herkr,herkr_des,kbetr")}
${if(find("采购",视图选择)=0,"",",ekgrp,ekgrp_des")}
${if(find("生产",视图选择)=0,"",",marc_disgr,marc_disgr_des,marc_dismm,marc_dismm_des,marc_dispo,marc_dispo_des,marc_disls,marc_disls_des,berid,berid_des,mdma_disgr,mdma_disgr_des,mdma_dismm,mdma_dismm_des,mdma_dispo,mdma_dispo_des,mdma_disls,mdma_disls_des,mdma_lgpro,mdma_lgpro_des,mdma_lgfsb,mdma_lgfsb_des,beskz,beskz_des,marc_lgpro,marc_lgpro_des,marc_lgfsb,marc_lgfsb_des,dzeit,plifz,miskz,miskz_des,sbdkz,sbdkz_des")}
${if(find("财务",视图选择)=0,"",",bwkey,bklas,bklas_des,mlast,mlast_des,vprsv,vprsv_des,pprdl,pdatl,peinh,stprs,verpr")}

select
distinct ernam_des
from
hive.dm.dm_product_info
where 1=1
${if(len(创建日期起)=0,'',"and ersda >= '"+创建日期起+"'")}
${if(len(创建日期止)=0,'',"and ersda <= '"+创建日期止+"'")}
order by 1

select
distinct matnr,
concat(matnr,'|',zh_maktx) as zh_maktx
from
hive.dm.dm_product_info
where 1=1
${if(len(创建工厂)=0,'',"and ernam in ('"+创建工厂+"')")}
${if(len(使用工厂)=0,'',"and marc_werks in ('"+使用工厂+"')")}
${if(len(库存地点)=0,'',"and lgort in ('"+库存地点+"')")}
${if(len(物料组)=0,"","and matkl in ('"+物料组+"')")}
order by 1

select
distinct code,
concat(code,'|',name) as name
from
hive.dict_product_t023t
order by 1

select
distinct bismt
from
hive.dm.dm_product_info
order by 1

select
distinct plcode,
concat(plcode,'|',plname)
from
hive.dm.dm_product_info
order by 1

select
distinct xlcode,
concat(xlcode,'|',xlname) as xlname
from
hive.dm.dm_product_info
where 1=1
${if(len(品类hybris)=0,'',"and plcode in ('"+品类hybris+"')")}
${if(len(法规hybris)=0,'',"and zccode in ('"+法规hybris+"')")}
order by 1

select
distinct jzcode,
concat(jzcode,'|',jzname)
from
hive.dm.dm_product_info
where 1=1
${if(len(品类hybris)=0,'',"and plcode in ('"+品类hybris+"')")}
${if(len(法规hybris)=0,'',"and zccode in ('"+法规hybris+"')")}
${if(len(系列hybris)=0,'',"and xlcode in ('"+系列hybris+"')")}
${if(len(SABChybris)=0,'',"and sabc in ('"+SABChybris+"')")}
order by 1

select
distinct sabc
from
hive.dm.dm_product_info
where 1=1
${if(len(品类hybris)=0,'',"and plcode in ('"+品类hybris+"')")}
${if(len(法规hybris)=0,'',"and zccode in ('"+法规hybris+"')")}
${if(len(系列hybris)=0,'',"and xlcode in ('"+系列hybris+"')")}
order by 1

select
distinct cxcode,
concat(cxcode,'|',cxname) as cxname
from
hive.dm.dm_product_info
where 1=1
${if(len(品类hybris)=0,'',"and plcode in ('"+品类hybris+"')")}
${if(len(法规hybris)=0,'',"and zccode in ('"+法规hybris+"')")}
${if(len(系列hybris)=0,'',"and xlcode in ('"+系列hybris+"')")}
${if(len(SABChybris)=0,'',"and sabc in ('"+SABChybris+"')")}
${if(len(机种hybris)=0,'',"and jzcode in ('"+机种hybris+"')")}
order by 1

select
distinct pzcode,
concat(pzcode,'|',pzname) as pzname
from
hive.dm.dm_product_info
where 1=1
${if(len(品类hybris)=0,'',"and plcode in ('"+品类hybris+"')")}
${if(len(法规hybris)=0,'',"and zccode in ('"+法规hybris+"')")}
${if(len(系列hybris)=0,'',"and xlcode in ('"+系列hybris+"')")}
${if(len(SABChybris)=0,'',"and sabc in ('"+SABChybris+"')")}
${if(len(机种hybris)=0,'',"and jzcode in ('"+机种hybris+"')")}
${if(len(车型hybris)=0,'',"and cxcode in ('"+车型hybris+"')")}
order by 1

select
distinct enhance_werks,
concat(enhance_werks,'|',enhance_werks_des) as enhance_werks_des
from
hive.dm.dm_product_info
order by 1

select
distinct zversion,
concat(zversion,'|',zversion_des) as zversion_des
from
hive.dm.dm_product_info
order by 1

select
distinct zecar_model_real
from
hive.dm.dm_product_info
order by 1

select
distinct zserial,
concat(zserial,'|',zserial_des) as zserial_des
from
hive.dm.dm_product_info
order by 1


select
distinct zcolor
from
hive.dm.dm_product_info
where 1=1
${if(len(品类hybris)=0,'',"and plcode in ('"+品类hybris+"')")}
${if(len(法规hybris)=0,'',"and zccode in ('"+法规hybris+"')")}
${if(len(系列hybris)=0,'',"and xlcode in ('"+系列hybris+"')")}
${if(len(SABChybris)=0,'',"and sabc in ('"+SABChybris+"')")}
${if(len(机种hybris)=0,'',"and jzcode in ('"+机种hybris+"')")}
${if(len(车型hybris)=0,'',"and cxcode in ('"+车型hybris+"')")}
${if(len(配置hybris)=0,'',"and pzcode in ('"+配置hybris+"')")}
order by 1


select
distinct zfacadeid
from
hive.dm.dm_product_info
order by 1

select
distinct code
from
hive.dict_product_zecar_model
order by 1

select
distinct code
from
hive.dict_product_znotice_ecar_model
order by 1

select
distinct code
from
hive.dict_product_zmotorcycle_type
order by 1

select
distinct zbrake_type,
concat(zbrake_type,'|',zbrake_type_des) as zbrake_type_des
from
hive.dm.dm_product_info
order by 1

select
distinct code
from
hive.dict_product_ztail_box_status
order by 1

select
distinct zbattery_type,
concat(zbattery_type,'|',zbattery_type_des) as zbattery_type_des
from
hive.dm.dm_product_info
order by 1

select
distinct code,
concat(code,'|',name) as name
from
hive.dict_product_zbrake_staut
order by 1

select
distinct zvol,
concat(zvol,'|',zvol_des) as zvol_des
from
hive.dm.dm_product_info
order by 1

select
distinct code,
concat(code,'|',name) as name
from
hive.dict_product_zshzy
order by 1

select
distinct zspeed,
concat(zspeed,'|',zspeed_des) as zspeed_des
from
hive.dm.dm_product_info
order by 1

select
distinct zsjgc
from
hive.dm.dm_product_info
order by 1

select
distinct zprotect_bar_type,
concat(zprotect_bar_type,'|',zprotect_bar_type_des) as zprotect_bar_type_des
from
hive.dm.dm_product_info
order by 1

select
distinct zmiddle_axle_status,
concat(zmiddle_axle_status,'|',zmiddle_axle_status_des) as zmiddle_axle_statusrks_des
from
hive.dm.dm_product_info
order by 1


select
distinct zdmod
from
hive.dm.dm_product_info
order by 1

select
distinct zdjfl,
concat(zdjfl,'|',zdjfl_des) as zdjfl_des
from
hive.dm.dm_product_info
order by 1

select
distinct battery_code,
concat(battery_code,'|',battery_name) as battery_name
from
hive.dm.dm_product_info
order by 1

select
distinct trunk_code,
concat(trunk_code,'|',trunk_name) as trunk_name
from
hive.dm.dm_product_info
order by 1

select
distinct hubs_code,
concat(hubs_code,'|',hubs_name) as hubs_name
from
hive.dm.dm_product_info
order by 1


select
distinct tire_code,
concat(tire_code,'|',tire_name) as tire_name
from
hive.dm.dm_product_info
order by 1

select
distinct forks_code,
concat(forks_code,'|',forks_name) as forks_name
from
hive.dm.dm_product_info
order by 1

select
distinct motor_code,
concat(motor_code,'|',motor_name) as motor_name
from
hive.dm.dm_product_info
order by 1

select
distinct zvoltage,
concat(zvoltage,'|',zvoltage_des) as zvoltage_des
from
hive.dm.dm_product_info
order by 1

select
distinct spec_code,
concat(spec_code,'|',spec_name) as spec_name
from
hive.dm.dm_product_info
order by 1

select
distinct theftproof_code,
concat(theftproof_code,'|',theftproof_name) as theftproof_name
from
hive.dm.dm_product_info
order by 1

select
distinct controller_code,
concat(controller_code,'|',controller_name) as controller_name
from
hive.dm.dm_product_info
order by 1

select
distinct brakesys_code,
concat(brakesys_code,'|',brakesys_name) as brakesys_name
from
hive.dm.dm_product_info
order by 1

select
distinct product_ison
from
hive.dm.dm_product_info

select
distinct mara_lvorm
from
hive.dm.dm_product_info

select
distinct marc_lvorm
from
hive.dm.dm_product_info

select
distinct mard_lvorm
from
hive.dm.dm_product_info

select
distinct code,
concat(code,'|',name) as name
from
hive.dict_product_werks
order by 1

select
distinct lgort,
concat(lgort,'|',lgort_des) as lgort_des
from
hive.dict_product_werks_lgort
where 1=1
${if(len(使用工厂)=0,'',"and werks in ('"+使用工厂+"')")}
order by 1

select
distinct zccode,
concat(zccode,'|',zcname) as zcname
from
hive.dm.dm_product_info
where 1=1
${if(len(品类hybris)=0,'',"and plcode in ('"+品类hybris+"')")}
order by 1

select
max(etl_date)as etl_date
from
hive.dm_all_table_etl_date
where name = 'dm_product_info'

select
distinct if_has_stock
from
hive.dm.dm_product_info

