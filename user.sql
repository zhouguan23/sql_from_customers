SELECT * FROM "ZJTX2"."FR_USER2"
WHERE 1=1
${if(len(org_id)==0,"","and ORG_ID in ('"+org_id+"')")}
${if(len(id)==0,"","and ID in ('"+id+"')")}

SELECT ID,NAME FROM "ZJTX2"."FR_USER2"
WHERE 1=1
${if(len(org_id)==0,"","and ORG_ID in ('"+org_id+"')")}

SELECT "ZJTX2"."FR_USER2".ORG_ID,"ZJTX2"."ORG2".NAME 
FROM "ZJTX2"."FR_USER2" 
INNER JOIN "ZJTX2"."ORG2" 
ON ("ZJTX2"."FR_USER2".ORG_ID = "ZJTX2"."ORG2".ID)

