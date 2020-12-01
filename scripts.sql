
--UPDATE KORONA_REMEK SET VP_OMS='4' WHERE UPPER(VP_OMS)='A';
--SELECT lengthOfTreatment(a.DATE_OPEN,a.DATE_ZAK) as LENGTH_TREAT,a.DATE_OPEN, a.DATE_ZAK from KORONA_REMEK a
--WHERE isSuperLong(a.DATE_OPEN, a.DATE_ZAK, a.US_KOD)
--LIMIT 30;

/*select abs(julianday(date('2020-06-03 00:00:00.000'))-julianday(date('2020-06-03 00:00:00.000')))*/


/*тест функции getKoeffUr*/
SELECT b.LEV as lev,
        (SELECT CASE 
                 WHEN b.LEV='1' THEN c.TAR_LVL_1
                 WHEN b.LEV='2' THEN c.TAR_LVL_2
                 WHEN b.LEV='3' THEN c.TAR_LVL_3
                 ELSE c.TAR_LVL_0
                 END )
         as CALC_TARIF,
         a.TARIF, a.S_ALL, 
         (ROUND(a.S_ALL/(SELECT CASE 
                 WHEN b.LEV='1' THEN c.TAR_LVL_1
                 WHEN b.LEV='2' THEN c.TAR_LVL_2
                 WHEN b.LEV='3' THEN c.TAR_LVL_3
                 ELSE c.TAR_LVL_0
                 END),4) ) as RATIO , 
         a.LPU, a.DATE_OPEN, a.DATE_ZAK, a.US_KOD, a.DS1, a.DS2, a.DS, a.FAM, a.IM, a.DR, a.OT, a.SPOLIS, a.NPOLIS, a.NHISTORY, a.* 
FROM i2010 a
LEFT JOIN NSI_FIN_LPU b
ON julianday(a.date_zak)>=julianday(b.DAT_BEG) and
   julianday(a.date_zak)<=julianday(b.DAT_END) and
   TRIM(a.lpu)=TRIM(b.LPU) and
   TRIM(a.VP_OMS)=TRIM(b.USL_OK)
LEFT JOIN R_NSI_TARIF_POLIKL_2017 c
ON julianday(a.date_zak)>=julianday(c.DAT_BEG) and
   julianday(a.date_zak)<=julianday(c.DAT_END) and  
   TRIM(a.US_KOD)=TRIM(c.US_KOD)
WHERE a.vp_oms = '3' and a.TARIF<>CALC_TARIF and a.S_ALL<>CALC_TARIF  AND a.us_kod not like '65%';


/*БАЛУЮСЬ: У записей с TARIF'ом не равным прасчетному поситчал во сколько раз и выделил,такие 
  у которых это отношение среди остальных отношений встречается только раз :)                */
/*CREATE TABLE RATIONS_POLICLINIC AS
SELECT (ROUND(a.S_ALL/(SELECT CASE 
                 WHEN b.LEV='1' THEN c.TAR_LVL_1
                 WHEN b.LEV='2' THEN c.TAR_LVL_2
                 WHEN b.LEV='3' THEN c.TAR_LVL_3
                 ELSE c.TAR_LVL_0
                 END),4) ) as RATION
FROM KORONA_REMEK a
LEFT JOIN NSI_FIN_LPU b
ON julianday(a.date_zak)>=julianday(b.DAT_BEG) and
   julianday(a.date_zak)<=julianday(b.DAT_END) and
   TRIM(a.lpu)=TRIM(b.LPU) and
   TRIM(a.VP_OMS)=TRIM(b.USL_OK)
LEFT JOIN R_NSI_TARIF_POLIKL_2017 c
ON julianday(a.date_zak)>=julianday(c.DATE_BEG) and
   julianday(a.date_zak)<=julianday(c.DATE_END) and  
   TRIM(a.US_KOD)=TRIM(c.US_KOD)
WHERE a.vp_oms = '3' and a.TARIF<>(SELECT CASE 
                 WHEN b.LEV='1' THEN c.TAR_LVL_1
                 WHEN b.LEV='2' THEN c.TAR_LVL_2
                 WHEN b.LEV='3' THEN c.TAR_LVL_3
                 ELSE c.TAR_LVL_0
                 END)
GROUP BY RATION
HAVING COUNT(RATION)=1;


/*SELECT (ROUND(a.S_ALL/(SELECT CASE 
                 WHEN b.LEV='1' THEN c.TAR_LVL_1
                 WHEN b.LEV='2' THEN c.TAR_LVL_2
                 WHEN b.LEV='3' THEN c.TAR_LVL_3
                 ELSE c.TAR_LVL_0
                 END),4) ) as RATION, a.*
FROM KORONA_REMEK a, RATIONS_POLICLINIC r
LEFT JOIN NSI_FIN_LPU b
ON julianday(a.date_zak)>=julianday(b.DAT_BEG) and
   julianday(a.date_zak)<=julianday(b.DAT_END) and
   TRIM(a.lpu)=TRIM(b.LPU) and
   TRIM(a.VP_OMS)=TRIM(b.USL_OK)
LEFT JOIN R_NSI_TARIF_POLIKL_2017 c
ON julianday(a.date_zak)>=julianday(c.DATE_BEG) and
   julianday(a.date_zak)<=julianday(c.DATE_END) and  
   TRIM(a.US_KOD)=TRIM(c.US_KOD)
WHERE a.vp_oms = '3' and r.RATION=ROUND((SELECT CASE 
                 WHEN b.LEV='1' THEN c.TAR_LVL_1
                 WHEN b.LEV='2' THEN c.TAR_LVL_2
                 WHEN b.LEV='3' THEN c.TAR_LVL_3
                 ELSE c.TAR_LVL_0
                 END),4);*/















/*SELECT getLevel(a.DATE_ZAK,a.VP_OMS,a.LPU), a.lpu, date(a.DATE_ZAK),a.* from KORONA_REMEK a
WHERE a.vp_oms = '3';*/

/*перекодируем VP_OMS*/
--UPDATE KORONA_REMEK
--SET VP_OMS='1' 
--WHERE UPPER(TRIM(VP_OMS))='S';

--SELECT a.* FROM TARIFS.NSI_FIN_LPU a
--WHERE julianday('2020-06-10 00:00:00.000')>=julianday(a.DAT_BEG) and
--       julianday('2020-06-10 00:00:00.000')<=julianday(a.DAT_END) and
--       TRIM('330326')=TRIM(a.LPU) and
--       TRIM('1')=TRIM(a.USL_OK) and
--       TRIM('2.1')=TRIM(a.LEV);


select count(UKL) from KORONA_REMEK WHERE VP_OMS='1';
       
/*рассчитываем базовый тариф*/
CREATE TABLE _KORONA_REMEK_STAC_BASETARIF AS 
SELECT a.*, k_ze.KZE, k_ur.KOEF_UR,k_ur_onko_hmp_covid.KOEF_UR as k_ur1,
       (SELECT CASE
                   WHEN NOT (studies.TAR_LVL_0 IS NULL) 
                       THEN  studies.TAR_LVL_0
                   WHEN NOT (k_ur_onko_hmp_covid.KOEF_UR IS NULL)
                       THEN  22708.36*k_ze.KZE*k_ur_onko_hmp_covid.KOEF_UR               
                   WHEN (k_ze.UROV<>'N') or (k_ze.UROV IS NULL)
                       THEN  22708.36*k_ze.KZE*k_ur.KOEF_UR
                   ELSE  22708.36*k_ze.KZE
               END) as BASE_TARIF, a.date_open, a.date_zak
FROM KORONA_REMEK a 

LEFT JOIN NSI_KSG_STAT k_ze
ON    upper(a.us_kod)=upper(k_ze.N_KSG) and
      (date(a.date_zak) BETWEEN date(k_ze.DAT_BEG ) and date(k_ze.DAT_END ))

LEFT JOIN NSI_FIN_LPU k_ur
ON    a.LPU=k_ur.LPU and
      (date(a.date_zak) BETWEEN date(k_ur.DAT_BEG ) and date(k_ur.DAT_END ))
      and k_ur.USL_OK='1' 

LEFT JOIN LEV_NKO_HMP_COVID k_ur_onko_hmp_covid
ON    upper(a.lpu)=upper(k_ur_onko_hmp_covid.LPU) and
      (date(a.date_zak) BETWEEN date(k_ur_onko_hmp_covid.DAT_BEG ) and date(k_ur_onko_hmp_covid.DAT_END )) AND
      (instr(k_ur_onko_hmp_covid.C_OTD,'|'||a.C_OTD||'|')>0)
      
LEFT JOIN R_NSI_TARIF_POLIKL_2017 studies
ON    upper(a.us_kod)=upper(studies.US_KOD) and
      (date(a.date_zak) BETWEEN date(studies.DAT_BEG ) and date(studies.DAT_END ))

WHERE UPPER(a.vp_oms)='1' 
 
      
ORDER BY a.LPU;


--применяем коэфф.сверхдлительности, там где он нужен и записываем в новую таблицу
CREATE TABLE _KORONA_REMEK_STAC_BASETARIF_SL AS
SELECT getSuperLongKoeff(a.date_open, a.date_zak, a.us_kod)*a.BASE_TARIF as BASE_TARIF_SL, a.BASE_TARIF, getSuperLongKoeff(a.date_open, a.date_zak, a.us_kod) as KOEFF_SL, a.* from _KORONA_REMEK_STAC_BASETARIF a
WHERE UPPER(a.vp_oms)='1'; 


--рассчитываем пофикшенный тариф
CREATE TABLE _KORONA_REMEK_STAC_FIXEDTARIF_SL AS 
SELECT
  isSurgeOperation(us_kod,vid_vme) as OPERATION, 
  (SELECT CASE
               WHEN (isSurgeOperation(us_kod,vid_vme) AND ((UPPER(vid_vme) like 'A16%') OR (UPPER(vid_vme) like 'A16%'))) AND
                    lengthOfTreatment(date_open,date_zak)<=3 and
                    isExcludeKSG(us_kod) 
               THEN BASE_TARIF_SL
               WHEN (isSurgeOperation(us_kod,vid_vme) AND ((UPPER(vid_vme) like 'A16%') OR (UPPER(vid_vme) like 'A16%'))) AND
                    lengthOfTreatment(date_open,date_zak)<=3 AND
                    NOT isExcludeKSG(us_kod) 
               THEN BASE_TARIF_SL*0.8
               WHEN (isSurgeOperation(us_kod,vid_vme) AND ((UPPER(vid_vme) like 'A16%') OR (UPPER(vid_vme) like 'A16%'))) AND
                    lengthOfTreatment(date_open,date_zak)>3 and
                    isLethal(res_g) 
               THEN BASE_TARIF_SL
               WHEN (isSurgeOperation(us_kod,vid_vme) AND ((UPPER(vid_vme) like 'A16%') OR (UPPER(vid_vme) like 'A16%'))) AND
                    lengthOfTreatment(date_open,date_zak)>3 and
                    NOT isLethal(res_g) 
               THEN BASE_TARIF_SL*0.8
               WHEN NOT (isSurgeOperation(us_kod,vid_vme) AND ((UPPER(vid_vme) like 'A16%') OR (UPPER(vid_vme) like 'A16%'))) AND
                    lengthOfTreatment(date_open,date_zak)<=3 
               THEN BASE_TARIF_SL*0.5
               WHEN NOT (isSurgeOperation(us_kod,vid_vme) AND ((UPPER(vid_vme) like 'A16%') OR (UPPER(vid_vme) like 'A16%'))) AND
                    lengthOfTreatment(date_open,date_zak)>3 and
                    isLethal(res_g) 
              THEN BASE_TARIF_SL*0.9      
              WHEN (NOT (isSurgeOperation(us_kod,vid_vme) AND ((UPPER(vid_vme) like 'A16%') OR (UPPER(vid_vme) like 'A16%'))) AND
                    lengthOfTreatment(date_open,date_zak)>3 and
                    NOT isLethal(res_g) ) 
                    AND NOT
                    (TARIF=BASE_TARIF_SL OR TARIF=S_ALL)
              THEN BASE_TARIF_SL*0.7  
              ELSE BASE_TARIF_SL 
   END   
  ) AS FIXED_TARIF,TARIF,S_ALL, DATE_OPEN, DATE_ZAK, US_KOD,VID_VME,*
  FROM _KORONA_REMEK_STAC_BASETARIF_SL
  WHERE UPPER(VP_OMS)='1'; 

SELECT a.* from _KORONA_REMEK_STAC_FIXEDTARIF_SL a
WHERE not(abs(a.FIXED_TARIF-a.TARIF)>10) and (ABS(a.FIXED_TARIF-a.S_ALL)>10);

UPDATE _KORONA_REMEK_STAC_FIXEDTARIF_SL 
SET FIXED_TARIF=ROUND(FIXED_TARIF,2);




--просто проба пера по конкатенции строк, преобразованиям типов и функции поиска подстроки
select ';'||C_OTD||';' a2, instr(';5;87;28;1702;67;','8;'||C_OTD||';') as a1,* from KORONA_REMEK 
WHERE C_OTD='1702';
--WHERE ';28;32;56;' like '%'+a.CD_OTD+'%';

--всякие прикидки, чтобы оценить что получили по пересечениям
SELECT SMO_S,  DATE_ZAK_S,  LPU_S, N_SH_LPU_S,  COUNT(S_ALL_S), SUM(S_ALL_S) 
FROM crossing_errors
GROUP BY SMO_S, DATE_ZAK_S,  LPU_S, N_SH_LPU_S
ORDER BY SMO_S, DATE_ZAK_S,  LPU_S, N_SH_LPU_S;

--SELECT SUM(NUM_SH), SUM(SUM_SH) from gen_statistics;

SELECT * from crossing_errors
WHERE SMO_S='33004' and UKL_S='202004';


SELECT s.SMONAME, m.sname, a.* FROM  crossing_errors a

LEFT JOIN DIC_SMO s
ON a.SMO=s.SMOID

LEFT JOIN DIC_MO_SHORT m
ON TRIM(a.LPU)=TRIM(m.LPU)


       



