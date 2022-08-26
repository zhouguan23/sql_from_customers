select km,qtfs,substr(ny,3) ny,yjzjs,yjkjs,rcyl1,rcyl, round(zhhs,2) zhhs,round(ly,2) ly, round(cmd) cmd  from ytkf_ydkcqx_yj  where km='${km}' and qtfs='${qtfs}' and ny between '${ny1}' and '${ny2}' order by ny

select km,substr(ny,3) ny,sjzjs,sjkjs,round(rzsl) rzsl, qtfs  from ytkf_ydkcqx_sj  where km='${km}' and qtfs='${qtfs}' and ny between '${ny1}' and '${ny2}' order by ny


select a.km,a.qtfs,substr(a.ny,3) ny,round(a.rcyl1) jkyl, round(b.zzzrcye) zzzrcye from ytkf_ydkcqx_yj a
  left join (select km, ny, zzzrcye, '全区' qtfs from ytkf_ydkcqx_zzz) b on a.km = b.km  and a.ny=b.ny and a.QTFS =b.qtfs where a.km='${km}' and a.qtfs='${qtfs}' and a.ny between '${ny1}' and '${ny2}'

select a.km,a.qtfs,substr(a.ny,3) ny,round(a.rcyl) jky, round(b.sjy) sjy from ytkf_ydkcqx_yj a
  left join  （select ny,km,decode(qtfs,'水驱'，'水驱','三采','三采','合计','全区',qtfs) qtfs,sjy from ytkf_ydkcqx_sjy） b on a.km = b.km  and a.ny=b.ny and a.QTFS =b.qtfs where a.km='${km}' and a.qtfs='${qtfs}' and a.ny between '${ny1}' and '${ny2}' order by ny

select km,qtfs,substr(ny,3) ny,round(zcb,2) zcb from  ytkf_ydkcqx_zcb  where km='${km}' and qtfs='${qtfs}' and ny between '${ny1}' and '${ny2}' order by ny

