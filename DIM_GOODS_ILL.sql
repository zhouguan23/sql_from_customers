SELECT A.GOODS_CODE,A.GOODS_CODE||'|'||b.GOODS_NAME GOODS_NAME,b.goods_name goods_name1,b.item_desc_secondary,SPECIFICATION,MANUFACTURER,PRODUCT_PLACE,b.approval_num,a.gather,a.purchaser,a.retail_price,a.type FROM dIm_goods_ill A  left JOIN DIM_GOODS B 
ON A.GOODS_CODE=B.GOODS_CODE

where 1=1 
${if(len(GOODS_CODE)=0,"","and A.GOODS_CODE in ('"+GOODS_CODE+"')")}


