select sum(ztxsdc) ztxsdc, --总体销售达成    
       sum(ztmldc) ztmldc, --总体毛利额达成  
       sum(zyxsdc) zyxsdc, --直营销售达成    
       sum(zymldc) zymldc, --直营毛利额达成  
       sum(jcxsdc) jcxsdc, --集采销售达成    
       sum(jcmldc) jcmldc, --集采毛利额达成  
       sum(zlxsdc) zlxsdc, --战略销售达成    
       sum(zlmldc) zlmldc, --战略毛利达成    
       sum(ppgmxs) ppgmxs, --品牌高毛销售达成
       sum(ppgmml) ppgmml, --品牌高毛毛利达成
       sum(syjcxs) syjcxs, --所有集采销售达成
       sum(syjcml) syjcml, --所有集采毛利达成
       sum(dtpxsdc) dtpxsdc, --DTP销售达成
       sum(dtpmldc) dtpmldc, --DTP毛利达成
       sum(dtpzyxs) dtpzyxs, --DTP直营销售
       sum(dtpzyml) dtpzyml, --DTP直营毛利       
       sum(jmpfpsje) jmpfpsje, --加盟&批发配送金额
       sum(jmpfpsml) jmpfpsml, --加盟&批发配送毛利       
       sum(tcdtpztxsdc) tcdtpztxsdc, --剔除DTP总体销售达成
       sum(tcdtpztmldc) tcdtpztmldc, --剔除DTP总体毛利达成       
       sum(tcdtpzyxsdc) tcdtpzyxsdc, --剔除DTP直营销售达成    
       sum(tcdtpzymldc) tcdtpzymldc, --剔除DTP直营毛利额达成 
       sum(tcdtpjmpfpsje) tcdtpjmpfpsje, --加盟&批发配送金额
       sum(tcdtpjmpfpsml) tcdtpjmpfpsml, --加盟&批发配送毛利 
       sum(dcxs) dcxs, --地采销售
       sum(dcml) dcml, --地采毛利 
       sum(zyxscb) zyxscb, --直营销售成本
       sum(jmpfpscb) jmpfpscb, --加盟店配送成本
       sum(otoxs) otoxs, --OTO销售
       sum(otoml) otoml, --OTO毛利
       sum(ztcgywxs) ztcgywxs, --总体常规业务销售
       sum(ztcgywml) ztcgywml, --总体常规业务毛利  
       sum(zycgywxs) zycgywxs, --直营常规业务销售
       sum(zycgywml) zycgywml, --直营常规业务毛利  
       sum(jcdtpxs) jcdtpxs, --集采DTP销售
       sum(jcdtpml) jcdtpml, --集采DTP毛利  
       sum(dcdtpxs) dcdtpxs, --地采DTP销售
       sum(dcdtpml) dcdtpml, --地采DTP毛利         
       sum(pfpsje) pfpsje, --批发配送金额 
       sum(pfpsml) pfpsml,  --批发配送毛利      
       sum(jmpsje) jmpsje,  --加盟配送金额
       sum(jmpsml) jmpsml,  --加盟配送毛利
 sum(tcdtppfpsje)  tcdtppfpsje,   --剔除dtp批发配送金额       
 sum(tcdtppfpsml)  tcdtppfpsml,   --剔除dtp批发配送毛利       
 sum(tcdtpjmpsje)  tcdtpjmpsje,   --剔除dtp加盟配送金额       
 sum(tcdtpjmpsml)  tcdtpjmpsml,   --剔除dtp加盟配送毛利       
 sum(dczyxs) dczyxs,  --地采直营销售              
 sum(dczyml) dczyml,  --地采直营毛利              
 sum(jczyxs) jczyxs,  --集采直营销售              
 sum(jczyml) jczyml,   --集采直营毛利
       B.UNION_AREA_NAME area_code
  from dm_data_support A, DIM_REGION B
 where 
 A.AREA_CODE = B.AREA_CODE
 AND 
 to_char(sale_date,'yyyy-mm-dd') between '${start_date}' and '${end_date}'
 AND 
 1=1
${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME IN('"+UNION_AREA+"') ")}
${if(len(AREA)=0,""," and A.AREA_CODE IN('"+AREA+"') ")} 
 group by B.UNION_AREA_NAME

select * from dim_region
WHERE  
 1=1
${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME IN('"+UNION_AREA+"') ")}
${if(len(AREA)=0,""," and AREA_CODE IN('"+AREA+"') ")} 
 order by 2

SELECT DISTINCT 
UNION_AREA_NAME 
FROM　　　　
DIM_REGION

SELECT DISTINCT 

AREA_CODE,
AREA_NAME 
FROM　　　　
DIM_REGION
WHERE 

1=1 
${if(len(UNION_AREA)=0,""," and UNION_AREA_NAME IN('"+UNION_AREA+"') ")}


