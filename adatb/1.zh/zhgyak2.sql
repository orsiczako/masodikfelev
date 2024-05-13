--1
--List�zza ki az �gyfelek azonos�t�j�t, teljes nev�t,
--valamint a megrendel�seik azonos�t�j�t!
--Azok az �gyfelek is szerepeljenek az eredm�nyben,
--akik soha nem adtak le megrendel�seket.
--A lista legyen vezet�kn�v, azon bel�l megrendel�s azonos�t�ja szerint rendezve
SELECT ugyfel_id, CONCAT(vezeteknev,CONCAT(' ',keresztnev)) AS "Teljes n�v",megrendeles_id
FROM HAJO.S_UGYFEL ugyf
LEFT OUTER JOIN
HAJO.S_MEGRENDELES rend
ON ugyf.ugyfel_id=rend.ugyfel
ORDER BY vezeteknev,megrendeles_id;

--2.
--List�zza ki a haj�t�pusok azonos�t�j�t �s nev�t, 
--valamint az adott t�pus� haj�k azonos�t�j�t �s nev�t! 
--A haj�t�pusok nev�t tartalmaz� oszlop
--'t�pusn�v', a haj�k nev�t tartalmaz� oszlop pedig 'haj�n�v' legyen! 
--Azok a haj�t�pusok is jelenjenek meg, amelyhez egyetlen haj� sem tartzoik.
--A lista legyen a haj�t�pus neve, azon bel�l a haj� neve alapj�n rendezve.
SELECT hajo_tipus_id,tip.nev tipusnev,hajo_id,haj.nev hajonev
FROM HAJO.S_HAJO_TIPUS tip
LEFT OUTER JOIN
HAJO.S_HAJO haj
ON tip.hajo_tipus_id=haj.hajo_tipus
ORDER BY tip.nev,haj.nev;

--3.
/*List�zza ki a 15 tonn�t meghalad� rakom�nnya r
endelkez? kont�nerek teljes azonos�t�j�t
(megrendel�sazonos�t� �s kont�nerazonos�t�),
valamint a rakom�nys�lyt is 2 tizedesjegyre kerek�tve! Rendezze az eredm�nyr a pontos 
rakom�nys�ly szerint n�vekv? sorrendbe*/
SELECT ROUND(rakomanysuly,2),megrendeles|| ' '||kontener
FROM HAJO.S_HOZZARENDEL
WHERE rakomanysuly>=15
ORDER BY rakomanysuly ASC;

--5.
--List�zza ki Magyarorsz�g�n�l kisebb lakoss�ggal rendelkez? orsz�gok nev�t,
--lakoss�g�t, valamint a f?v�rosuk nev�t. Azokat az orsz�gokat is
--list�zza, amelyeknek nem ismerj�k a f?v�ros�t.
--Ezen orsz�gok eset�ben a f?v�ros hely�n "nem ismert" sztring szerepeljen.
--Rendezze az orsz�gokat
--a lakoss�g szerint cs�kken? sorrendben.
SELECT orsz.orszag,orsz.lakossag,COALESCE(helysegnev,'nem ismert')
FROM HAJO.S_ORSZAG orsz
LEFT OUTER JOIN
HAJO.S_HELYSEG helys
ON orsz.orszag=helys.orszag
WHERE helys.helyseg_id IN(SELECT fovaros
                        FROM HAJO.S_ORSZAG
                        WHERE lakossag<(SELECT lakossag
                                        FROM HAJO.S_ORSZAG
                                        WHERE orszag='Magyarorsz�g'))
ORDER BY orsz.lakossag DESC;

--6 
--List�zza ki azoknak az �gyfeleknek az azonos�t�j�t �s teljes nev�t,
--akik adtak m�r fel olasz- orsz�gi kik�t?b?l indul� sz�ll�t�sra vonatkoz� megrendel�st! 
--Egy �gyf�l csak egyszer szere- peljen az eredm�nyben!
SELECT ugyfel_id, CONCAT(vezeteknev,CONCAT(' ',keresztnev))
FROM HAJO.S_UGYFEL
WHERE  ugyfel_id IN(SELECT ugyfel
                    FROM HAJO.S_MEGRENDELES
                    WHERE indulasi_kikoto IN(SELECT kikoto_id
                                            FROM HAJO.S_KIKOTO
                                            WHERE helyseg IN(SELECT helyseg_id
                                                            FROM HAJO.S_HELYSEG
                                                            WHERE orszag='Olaszorsz�g')));
                                                            
--7
--List�zza ki azoknak a haj�knak az azonos�t�j�t �s nev�t, 
--amelyek egyetlen �t c�l�llom�sak�nt sem k�t�ttek ki francia kik�t?kben
SELECT hajo_id,nev
FROM HAJO.S_HAJO 
WHERE hajo_id NOT IN(SELECT hajo
                    FROM HAJO.S_UT
                    WHERE erkezesi_kikoto IN(SELECT kikoto_id
                                            FROM HAJO.S_KIKOTO
                                            WHERE helyseg IN(SELECT helyseg_id
                                                            FROM HAJO.S_HELYSEG
                                                            WHERE orszag='Franciaorsz�g')));
                                                            
--8.
--List�zza ki azoknak a helys�geknek az azonos�t�j�t, orsz�g�t �s nev�t, 
--amelyeknek valamelyik kik�t?j�b?l
--indult m�r �tra az SC Bella nev? haj�! Egy helys�g csak egyszer szerepeljen
SELECT DISTINCT(helyseg_id),orszag,helysegnev
FROM HAJO.S_HELYSEG
WHERE helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_KIKOTO
                    WHERE kikoto_id IN(SELECT indulasi_kikoto
                                        FROM HAJO.S_UT
                                        WHERE hajo IN(SELECT hajo_id
                                                    FROM HAJO.S_HAJO
                                                    WHERE nev='SC Bella')));
                                                    
--9.
--List�zza ki azokat a mmegrendel�seket (azonos�t�) amelyek�rt t�bbet fizettek, 
--mint a 2021. �prilis�ban leadott megrendel�sek
--B�rmelyik��rt. A fizetett �sszeget is t�ntesse fel!
SELECT megrendeles_id,fizetett_osszeg
FROM HAJO.S_MEGRENDELES 
WHERE fizetett_osszeg>(SELECT MAX(fizetett_osszeg)
                        FROM HAJO.S_MEGRENDELES
                        WHERE to_char(megrendeles_datuma,'yyyy.mm.')='2021.04.');
                        
--10.
--List�zza ki azokat a megrendel�seknek az azonosit�j�t 
--amelyekben ugyanannyi kont�ner ig�nyeltek, mint valamelyik
--2021 feb. leadott megrendel�sben! 
--A megrendel�sek azonosit�juk mellet t�ntesse fel az ig�nyelt kont�nerek sz�m�t is.
SELECT megrendeles_id,igenyelt_kontenerszam
FROM HAJO.S_MEGRENDELES
WHERE igenyelt_kontenerszam IN(SELECT igenyelt_kontenerszam
                                FROM HAJO.S_MEGRENDELES
                                WHERE to_char(megrendeles_datuma,'yyyy.mm.')='2021.02.');
                                        
--11
--List�zza ki azoknak a haj�knak a nev�t, a maxim�lis s�lyterhel�s�t, 
--valamint a tipus�nak a nev�t, amely egyetlen utat sem teljes�tett.
--A haj� nev�t megad� oszlop neve a 'haj�n�v' a tipusnev�t a 'tipusn�v'.
SELECT haj.nev hajonev,max_sulyterheles,tip.nev tipusnev
FROM HAJO.S_HAJO_TIPUS tip
INNER JOIN
HAJO.S_HAJO haj
ON tip.hajo_tipus_id=haj.hajo_tipus
WHERE hajo_id NOT IN(SELECT hajo
                    FROM HAJO.S_UT);
                    
--12.
--List�zza ki azoknak az �gyfeleknek a teljes nev�t �s sz�rmaz�si orsz�g�t, 
--akiknek nincs 1milli�n�l nagyobb �rt�k? rendel�se!
--Azok is szerepeljenek, akiknek nem ismerj�k a sz�rmaz�s�t. 
--Rendezze az eredm�nyt vezet�kn�v, azon bel�l keresztn�v szerint
SELECT CONCAT(vezeteknev,CONCAT(' ',keresztnev)) AS "Teljes n�v",orszag
FROM HAJO.S_HELYSEG helys
RIGHT OUTER JOIN
HAJO.S_UGYFEL ugyf
ON helys.helyseg_id=ugyf.helyseg
WHERE ugyfel_id NOT IN(SELECT ugyfel
                    FROM HAJO.S_MEGRENDELES
                    WHERE fizetett_osszeg>1000000)
ORDER BY vezeteknev,keresztnev;

--13
--List�zza ki �b�c�rendben azoknak a hajok az azonos�t�j�t, 
--amelyekbe vagy teljes�tett egy utat az It_Cat azonos�t�j� kik�t?b?l, 
--vagy c�lpontja egy, az It_Cat
--azonos�t�j? kik�t?j? megrendel�snek!
--ez a feladat alapb�l h�ly�n van/volt megfogalmazva de szerintem arra gondolt a k�lt?,hogy
--a haj�k neveit k�ne list�zni, amelyek teljes�tettek egy utat az it_cat-be vagy 
--terveznek menni,vagyis �n �gy csin�ltam
SELECT hajo_id
FROM HAJO.S_HAJO
WHERE hajo_id IN(SELECT hajo
                FROM HAJO.S_UT 
                WHERE indulasi_kikoto='It_Cat')
OR hajo_id IN(SELECT hajo
                FROM HAJO.S_UT
                WHERE erkezesi_kikoto IN(SELECT kikoto_id
                                        FROM HAJO.S_KIKOTO
                                        WHERE kikoto_id IN(SELECT erkezesi_kikoto
                                                            FROM HAJO.S_MEGRENDELES
                                                            WHERE erkezesi_kikoto='It_Cat')))
ORDER BY hajo_id;
--�rdemes ink�bb unionnal:
--13
--List�zza ki �b�c�rendben azoknak a hajok az azonos�t�j�t, 
--amelyekbe vagy teljes�tett egy utat az It_Cat azonos�t�j� kik�t?b?l, 
--vagy c�lpontja egy, az It_Cat
--azonos�t�j? kik�t?j? megrendel�snek!
SELECT ut.hajo
FROM HAJO.S_UT ut
WHERE ut.indulasi_kikoto='It_Cat'
UNION
SELECT utt.hajo
FROM HAJO.S_MEGRENDELES rend
LEFT OUTER JOIN
HAJO.S_KIKOTO kikot
ON rend.erkezesi_kikoto=kikoto_id
LEFT OUTER JOIN
HAJO.S_UT utt
ON kikot.kikoto_id=utt.erkezesi_kikoto
WHERE rend.erkezesi_kikoto='It_Cat'
ORDER BY hajo;
--14.
--List�zza ki �b�c�rendben azoknak a kik�t?knek az azonos�t�j�t, 
--melyekbe legal�bb egy haj� teljes�tett utat
--Az 'It_Cat' azonos�t�j� kik�t?b?l �s c�lpontja legal�bb egy, 
--az 'It_Cat' kik�t?b?l indul� megrendel�snek. A kik�t? csak egyszer
--Szerepeljen a lek�rdez�sben.                
SELECT erkezesi_kikoto
FROM HAJO.S_UT 
WHERE indulasi_kikoto='It_Cat'
INTERSECT
SELECT indulasi_kikoto
FROM HAJO.S_MEGRENDELES 
WHERE erkezesi_kikoto='It_Cat'
GROUP BY erkezesi_kikoto,indulasi_kikoto;

--15. 
--List�zza ki �b�c�rendben azoknak a helys�geknek az azonos�t�j�t, 
--orsz�g�t �s nev�t, ahonnan sz�rmaznak �gyfeleink, vagy ahol vannak kik�t?k!
--Egy helys�g csak egyszer szerepeljen az eredm�nyben! 
--A lista legyen orsz�gn�v, azon bel�l helys�gn�v szerint rendezett.
SELECT DISTINCT(helyseg_id),orszag,helysegnev
FROM HAJO.S_HELYSEG
WHERE helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_KIKOTO)
OR helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_UGYFEL)
ORDER BY orszag,helysegnev;

--16
--List�zza ki �b�c�rendben azoknak a kik�t?vel rendelkez? helys�geknek az azonos�t�j�t,
--orsz�g�t �s nev�t, ahonnan legal�bb egy �gyfel�nk is sz�rmazik! 
--Egy helys�g csak egyszer szerepeljen az eredm�nyben! 
--A lista legyen orsz�gn�v, azon bel�l helys�gn�v szerint rendezve!
SELECT DISTINCT(helyseg_id),orszag,helysegnev
FROM HAJO.S_HELYSEG
WHERE helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_KIKOTO)
OR helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_UGYFEL)
ORDER BY orszag,helysegnev;

--19.
--List�zza ki n�vekv? sorrendben azoknak a megrendel�seknek az azonos�t�j�t, 
--amelyek�rt legal�bb k�tmilli�t fizetett
--Egy Yiorgos keresztnev? �gyf�l, �s m�g nem t�rt�nt meg a sz�ll�t�suk
SELECT megrendeles_id
FROM HAJO.S_MEGRENDELES
WHERE fizetett_osszeg>=2000000
AND ugyfel IN(SELECT ugyfel_id
                FROM HAJO.S_UGYFEL
                WHERE keresztnev='Yiorgos')
AND megrendeles_id NOT IN(SELECT megrendeles
                        FROM HAJO.S_HOZZARENDEL
                        WHERE (megrendeles,kontener) IN(SELECT megrendeles,kontener
                                            FROM HAJO.S_SZALLIT
                                            WHERE ut IN(SELECT ut_id
                                                        FROM HAJO.S_UT)))
ORDER BY megrendeles_id ASC;
--20
--List�zza ki azoknak a helys�geknek az azonos�t�j�t, 
--orsz�g�t �s nev�t, amelyek lakoss�ga meghaladja az egymilli� f?t, �s azok�t is, 
--ahonnan sz�rmazik 50 �vesn�l id?sebb �gyfel�nk! 
--Egy helys�g csak egyszer szerepeljen az eredm�nyben!
--A lista legyen orsz�gn�v, azon bel�l helys�gn�v szerint rendezve!
SELECT DISTINCT(helyseg_id),orszag,helysegnev
FROM HAJO.S_HELYSEG
WHERE lakossag>=1000000
OR helyseg_id IN(SELECT helyseg
                FROM HAJO.S_UGYFEL
                WHERE MONTHS_BETWEEN(sysdate,szul_dat)/12>50)
ORDER BY orszag,helysegnev;   

--22.
--Melyik h�rom orsz�g kik�t?j�b?l indul� sz�ll�t�sokra adt�k le a legt�bb megrendel�st?
--Az orsz�gnevek mellett t�ntesse fel az onnan indul� megrendel�sek sz�m�t is
SELECT orszag,COUNT(megrendeles_id)
FROM HAJO.S_HELYSEG helys
INNER JOIN
HAJO.S_KIKOTO kikot
ON helys.helyseg_id=kikot.helyseg
INNER JOIN 
HAJO.S_MEGRENDELES rend
ON kikot.kikoto_id=rend.indulasi_kikoto
GROUP BY indulasi_kikoto,orszag
ORDER BY COUNT(megrendeles_id) DESC
FETCH FIRST 3 ROW WITH TIES;

--24.
--Adja meg  a k�t legkevesebb utat teljse�t? olyan haj� nev�t ,amelyik legal�bb egy utat teljes�tett,
--�s legjeljebb 10 kont�nert tud egyszerre sz�ll�tani.
--A haj�k neve mellet t�ntesse fel az �ltaluk teljes�tett utak sz�m�t is.
SELECT nev,COUNT(hajo)
FROM HAJO.S_HAJO haj
LEFT OUTER JOIN
HAJO.S_UT ut
ON haj.hajo_id=ut.hajo
WHERE max_kontener_dbszam<=10
GROUP BY nev
ORDER BY COUNT(hajo)
FETCH FIRST 2 ROW WITH TIES;

--25
--List�zza ki a t�z legt�bb ig�nyelt kont�nert tartalmaz�
--megrendel�st lead� �gyf�l teljes nev�t, 
--a megrendel�s azonos�t�j�t �s az ig�nyelt kont�nerek sz�m�t!
SELECT CONCAT(vezeteknev,CONCAT(' ',keresztnev)),megrendeles_id,igenyelt_kontenerszam
FROM HAJO.S_UGYFEL ugyf
INNER JOIN
HAJO.S_MEGRENDELES rend
ON ugyf.ugyfel_id=rend.ugyfel
GROUP BY CONCAT(vezeteknev,CONCAT(' ',keresztnev)),megrendeles_id,igenyelt_kontenerszam
ORDER BY igenyelt_kontenerszam DESC
FETCH FIRST 10 ROW WITH TIES;

--26
--Adja meg az SC Nina nev? haj�val megtett 3 leghosszabb ideig tart� �t indul�si 
--�s �rkez�si kik�t?j�nek az azonos�t�j�t.
SELECT erkezesi_kikoto,indulasi_kikoto
FROM HAJO.S_UT ut
WHERE hajo IN(SELECT hajo_id
            FROM HAJO.S_HAJO
            WHERE nev='SC Nina')
ORDER BY erkezesi_ido-indulasi_ido DESC NULLS LAST
FETCH FIRST 3 ROW WITH TIES;

--27
--Adja meg a h�rom legt�bb utat teljes�t? haj� nev�t!
--A haj�k neve mellett t�ntesse fel az �ltaluk teljes�tett utak sz�m�t is
SELECT nev,COUNT(hajo)
FROM HAJO.S_HAJO haj
INNER JOIN
HAJO.S_UT ut
ON haj.hajo_id=ut.hajo
GROUP BY nev
ORDER BY COUNT(hajo) DESC
FETCH FIRST 3 ROW WITH TIES;

--28
-- Az 'It Cat' azonos�t�j� kik�t?b?l indul� utak k�z�l melyik 
--n�gyen sz�ll�tott�k a legkevesebb kont�nert?
--Csak azokat az utakat vegye figyelembe, 
--amelyeken legal�bb egy kont�nert sz�ll�tottak!
--Az utakat az azonos�t�jukkal adja meg, 
--�s t�ntesse fel a sz�ll�tott kont�nerek sz�m�t is!!
SELECT ut_id,COUNT(kontener)
FROM HAJO.S_UT ut
INNER JOIN 
HAJO.S_SZALLIT sza
ON ut.ut_id=sza.ut
WHERE indulasi_kikoto='It_Cat'
GROUP BY ut_id
ORDER BY COUNT(kontener) ASC NULLS LAST
FETCH FIRST 4 ROW WITH TIES;

--29
--Adja meg a n�gy legt�bb rendel�st lead� teljes nev�t �s a megrendel�sek sz�m�t
SELECT CONCAT(vezeteknev,CONCAT(' ',keresztnev)),COUNT(ugyfel)
FROM HAJO.S_UGYFEL ugyf
INNER JOIN
HAJO.S_MEGRENDELES rend
ON ugyf.ugyfel_id=rend.ugyfel
GROUP BY CONCAT(vezeteknev,CONCAT(' ',keresztnev))
ORDER BY COUNT(ugyfel) DESC NULLS LAST
FETCH FIRST 4 ROW ONLY;

--30.
/*List�zza ki azoknak az utaknak az adatait(d�tumokat id?ponttal egy�tt),amelyek
nem eg�sz percben indultak!Rendezze az eredm�nyt az indul�si id? szerint n�vekv? 
sorrendbe*/
SELECT ut_id,to_char(indulasi_ido,'yyyy.mm.dd.hh24:mi:ss'),to_char(erkezesi_ido,'yyyy.mm.dd.hh24:mi:ss'),indulasi_kikoto,
erkezesi_kikoto,hajo
FROM HAJO.S_UT
WHERE to_char(indulasi_ido,'yyyy.mm.dd.hh24:mi:ss') NOT LIKE '____.__.__.__:__:00'
ORDER BY indulasi_ido ASC;

--31.
--Hozzon l�tre egy s_szemelyzet nevu tablat, 
--amelyben a haj�kon dolgoz� szem�lyzet adatai tal�lhat�ak. 
--Minden szerel?nek van azonos�t�ja
--Pontosan 10 karakteres sztring. Ez az els?dleges kulcs is. 
--Vezet�k �s keresztneve mindkett? 50-50 karakteres sztring. 
--Sz�let�si d�tuma, egy telefonsz�ma
--(20 jegy? eg�sz sz�m). �s hogy melyik haj� szem�lyzet�hez tartozik 
--(max 10 karakteres sztring), �s ezt egy hivatkoz�ssal az s_haj� t�bl�ra hozzuk l�tre.
--A telefonsz�mot legyen k�telez? megadni. Minden megszor�t�st nevezzen el
CREATE TABLE SZEMELY1(
azon CHAR(10),
vezeteknev VARCHAR2(50),
keresztnev VARCHAR2(50),
szul_dat DATE,
tel NUMBER(20) NOT NULL,
hajo_id VARCHAR2(10),
CONSTRAINT az_pk PRIMARY KEY (azon),
CONSTRAINT haj_ref FOREIGN KEY (hajo_id) REFERENCES HAJO.S_HAJO(hajo_id));

--33
--Hozzon l�tre egy 's_kikoto_email' nev? t�bl�t, 
--amelyben a kik�t?k e-mail c�m�t t�roljuk! Legyen benne egy kikoto_id nev? oszlop
--(maximum 10 karakteres string), amely hivatkozik az s_kikoto t�bl�ra.
--Valamint egy email c�m, ami egy maximum 200 karakteres string!
--Egy kik�t?nek t�bb email c�me lehet, ez�rt a t�bla els?dleges kulcs�t
--a k�t oszlop egy�ttesen alkossa!
--Minden megszor�t�st nevezzen el!
CREATE TABLE EMAIL(
kikoto_id VARCHAR2(10),
email VARCHAR2(200),
CONSTRAINT ki_ref FOREIGN KEY (kikoto_id) REFERENCES HAJO.S_KIKOTO(kikoto_id),
CONSTRAINT id_pk PRIMARY KEY(kikoto_id,email));

--35.
--Hozzon l�tre egy s_hajo_javitas t�bl�t, ami a haj�k jav�t�si adatait tartalmazza! Legyen benne a jav�tott haj� azonos�t�ja, amely az s_haj� t�bl�ra hivatkozik, legfeljebb
--10 karakter hossz� sztring �s ne legyen null. Jav�t�s kezdete �s v�ge_ d�rumok. Jav�t�s �ra: egy legfeljebb 10 jegy? val�s sz�m, k�t tizedesjeggyel, valamint a hiba
--le�r�sa, 200 karakteres sztring (legfeljebb).
--A t�bla els?dleges kulcsa �s a jav�t�s kezd?d�tuma els?dlegesen alkossa. Tov�bbi megk�t�s, hogy a jav�t�s v�ge csak a jav�t�s kezdete
--n�l k�s?bbi d�tum lehet.

--43
--T�r�lje az s_hajo �s az s_hajo tipus t�bl�kat! 
--Vegye figyelembe az egyes t�bl�kra hivatkoz� k�ls? kulcsokat.
CREATE TABLE HAJO AS
SELECT * FROM HAJO.S_HAJO
WHERE 1=0;

CREATE TABLE HAJO_TIPUS AS
SELECT * FROM HAJO.S_HAJO_TIPUS
WHERE 1=0;

ALTER TABLE HAJO_TIPUS
ADD CONSTRAINT haj_pk PRIMARY KEY(hajo_tipus_id);

ALTER TABLE HAJO
ADD CONSTRAINT id_pk FOREIGN KEY (hajo_tipus) REFERENCES HAJO_TIPUS(hajo_tipus_id);

ALTER TABLE HAJO DROP CONSTRAINT id_pk;
ALTER TABLE HAJO_TIPUS DROP CONSTRAINT haj_pk;
DROP TABLE HAJO_TIPUS;
DROP TABLE HAJO;

--42
-- A helys�gek lakoss�gi adata nem fontos sz�munkra.
--T�r�lje az 's_helyseg' t�bla 'lakossag' oszlop�t! 
ALTER TABLE HELYSEG 
ADD lakossag NUMBER(8);

ALTER TABLE HELYSEG DROP COLUMN lakossag;

----44
--T�r�lje az 's_kikoto_telefon' t�bla els?dleges kulcs megszor�t�s�t!
--h�t na fingom nincs mi a neve annak a megszor�t�snak de vhogy �gy n�zne ki:
ALTER TABLE S_KIKOTO_TELEFON
DROP CONSTRAINT megszor_neve;

--49.
--az s_kik�t? telefon t�bl�t egy email nev?, amx 200 karakter hossz� sztringel, 
--melyben alap�rtelmezetten a 'nem ismert' sztring legyen
ALTER TABLE TESZT
ADD email VARCHAR2(200) DEFAULT 'nem ismert';

--50.
--M�dos�tsa az s_ugyfel t�bla email oszlop�nak maxim�lis hossz�t 50 karakterre, 
--az utca_hsz oszlop hossz�t pedig 100 karakterre!
ALTER TABLE TESZT
MODIFY email VARCHAR2(50);

--53
--Sz�rja be a haj� s�m�b�l a saj�t s�m�j�nak s_ugyfel t�bl�j�ba 
--az olaszorsz�gi �gyfeleket!
INSERT INTO UGYFEL(ugyfel_id,vezeteknev,keresztnev,telefon,email,szul_dat,helyseg,utca_hsz)
SELECT ugyfel_id,vezeteknev,keresztnev,telefon,email,szul_dat,helyseg,utca_hsz
FROM HAJO.S_UGYFEL 
WHERE helyseg IN(SELECT helyseg_id
                FROM HAJO.S_HELYSEG
                WHERE orszag='Olaszorsz�g');
                
--54
--Sz�rja be a gaj� s�m�b�l a saj�t s�m�j�nak 
--s:haj� t�bl�j�ba a small feeder tipus� haj�k k�z�l azokat,
--amelyeknek nett� s�lya legal�bb 250 tonna
INSERT INTO HAJO.S_HAJO(hajo_id,nev,netto_suly,max_kontener_dbszam,max_sulyterheles,hajo_tipus)
SELECT hajo_id,nev,netto_suly,max_kontener_dbszam,max_sulyterheles,hajo_tipus
FROM HAJO.S_HAJO
WHERE hajo_tipus IN(SELECT hajo_tipus_id
                    FROM HAJO.S_HAJO_TIPUS
                    WHERE nev='Small feeder')
AND netto_suly>=250;

--55.
--Sz�rja be a 'haj�' s�m�b�l a saj�t s�m�j�nak s_hajo t�bl�j�ba azokat a 'Small Feeder"' t�pus� hja�kat, amelyek legfeljebb 10 kont�nert
--tudnak sz�ll�tani egyszerre;
INSERT INTO HAJO.S_HAJO(hajo_id,nev,netto_suly,max_kontener_dbszam,max_sulyterheles,hajo_tipus)
SELECT hajo_id,nev,netto_suly,max_kontener_dbszam,max_sulyterheles,hajo_tipus
FROM HAJO.S_HAJO
WHERE hajo_tipus IN(SELECT hajo_tipus_id
                    FROM HAJO.S_HAJO_TIPUS
                    WHERE nev='Small feeder')
AND max_kontener_dbszam<=10;

--57
--T�r�lje a sz�razdokkal rendelkez? olaszorsz�gi �s ib�riai kik�t?ket! 
--Azok a kik�t?k rendelkeznek sz�razdokkal, amelyeknek a le�r�s�ban
--szerepel a sz�razdokk sz�.
DELETE FROM KIKOTO
WHERE kikoto_id IN(
SELECT kikoto_id
FROM HAJO.S_KIKOTO kikot
INNER JOIN
HAJO.S_HELYSEG helys
ON kikot.helyseg=helys.helyseg_id
WHERE leiras LIKE '%sz�razdokk%'
AND orszag IN('Olaszorsz�g','Ib�ria'));

--59.
--T�r�lje azokata 2021 j�n. indul� utakat,amelyeken 20 n�l kevesebb 
--kont�nert sz�ll�tott a haj�.
DELETE FROM HAJO.S_UT
WHERE ut_id IN(
SELECT ut
FROM HAJO.S_UT ut
LEFT OUTER JOIN
HAJO.S_SZALLIT sza
ON ut.ut_id=sza.ut
WHERE to_char(indulasi_ido,'yyyy.mm.')='2021.07.'
GROUP BY ut
HAVING COUNT(kontener)<20);

--61
--M�dos�tsa a nagy termin�lter�lettel rendelkez? kik�t?k le�r�s�t �gy, 
--hogy az az elej�n tar- talmazza a kik�t? helys�g�t is, 
--amelyet egy vessz?vel �s egy sz?k�zzel v�lasszon el a le�r�s jelenlegi tartalm�t�l! 
--A nagy termin�lter�lettel rendelkez? kik�t?k le�r�s�ban szerepel a 'termin�lter�let: nagy, sztring. 
--(Figyeljen a vessz?re, a nagyon nagy" ter�let? kik�t?ket nem szeretn�nk m�dos�tani!) 
UPDATE KIKOTO kikot
SET leiras= (SELECT helysegnev
            FROM HAJO.S_HELYSEG helys
            WHERE kikot.helyseg=helys.helyseg_id)|| ', '|| leiras
WHERE leiras LIKE ('%termin�lter�let: nagy%');

--62
--Alak�tsa csuba nagybet?ss� azon �gyfelek vezet�knev�t, 
--akik eddig a legt�bbet fizett�k �sszesen a megrendel�seik�rt
UPDATE UGYFEL
SET vezeteknev=UPPER(vezeteknev)
WHERE ugyfel_id IN(SELECT ugyfel
                    FROM HAJO.S_MEGRENDELES
                    GROUP BY ugyfel
                    ORDER BY SUM(fizetett_osszeg) DESC NULLS LAST
                    FETCH FIRST ROW WITH TIES);
                    
--68
--A n�pess�gi adataink elavultak. 
--A friss�t�s�k egyik l�p�sek�nt n�velje meg 5%-kal az 
--�zsiai orsz�gok telep�l�seinek lakoss�g�t! 
CREATE TABLE HELYSEG AS
SELECT * FROM HAJO.S_ORSZAG
WHERE 1=0;

UPDATE HELYSEG
SET lakossag=lakossag*0.5
WHERE orszag IN(SELECT orszag
                FROM HAJO.S_ORSZAG
                WHERE foldresz='�zsia');

--69
--Egy puszt�t� v�rus szedte �ldozatait Afrika nagyv�rosaiban. 
--Felezze meg azon afrikai telep�l�sek lakoss�g�t, amelyeknek aktu�lis
--lakoss�ga meghaladja a f�lmilli� f?t!
UPDATE HELYSEG
SET lakossag=lakossag/2
WHERE orszag IN(SELECT orszag
                FROM HAJO.S_ORSZAG
                WHERE foldresz='Afrika')
AND lakossag>=1500000;                


--70.
--C�g�nk adminisztr�tora elk�vetett egy nagy hib�t. 
--A 2021 j�lius�ban Algeciras kik�t?j�b?l indul� utakat t�vesen
--Vitte be az adatb�zisba, mintha azok Valenci�b�l indultak volna. 
--Val�ban Valenci�b�l egyetlen �t sem indult a k�rd�ses id?pontban
--Korrig�lja az adminisztr�tor hib�j�t! 
--Az egyszer?s�g kedv��rt felt�telezz�k, hogy 1-1 ilyen v�ros l�tezik, egy kik�t?vel

--r�viden: vki Algeciras helyett Valenci�t �rt �s azt kell �t�rni
UPDATE HAJO.S_HELYSEG
SET helysegnev='Algeciras'
WHERE helyseg_id IN(
SELECT helyseg_id
FROM HAJO.S_UT ut
INNER JOIN
HAJO.S_KIKOTO kikot
ON ut.indulasi_kikoto=kikot.kikoto_id
INNER JOIN
HAJO.S_HELYSEG helys
ON kikot.helyseg=helys.helyseg_id
WHERE helysegnev='Valencia'
AND to_char(indulasi_ido,'yyyy.mm.')='2021.07.');

--71.
--Hozzon l�tre n�zetet, amely list�zza az utak minden attrib�tum�t, 
--kieg�sz�tve az indul�si �s �rkez�si kik�t? helys�g �s orsz�gnev�vel.
CREATE VIEW VALAMII AS(
SELECT ut_id,to_char(indulasi_ido,'yyyy.mm.dd.hh24:mi:ss')ido1,to_char(erkezesi_ido,'yyyy.mm.dd.hh24:mi:ss')ido2,indulasi_kikoto,erkezesi_kikoto,hajo,helysegnev,orszag
FROM HAJO.S_UT ut
INNER JOIN 
HAJO.S_KIKOTO kiot
ON ut.indulasi_kikoto=kiot.kikoto_id
INNER JOIN
HAJO.S_HELYSEG helys
ON kiot.helyseg=helyseg_id);

--75
--Hozzon l�tre n�zetet, amely list�zza, hogy az egyes haj�t�pusokhoz tartoz� haj�k 
--�sszesen h�ny utat teljes�tettek! 
--A list�ban szerepeljen a haj�t�pusok azonos�t�ja, 
--neve �s a teljes�tett utak sz�ma! 
--Azokat a haj�t�pusokat is t�ntesse fel az eredm�nyben, 
--amelyekhez egyetlen haj� sem tartozik, 
--�s azokat is, amelyekhez tartoz� haj�k egyetlen utat sem teljes�tettek! 
--A lista legyen a haj�t�pus neve szerint rendezett!
CREATE VIEW CSINALDMARMEGBAZDMEG AS
SELECT tip.hajo_tipus_id ,tip.nev ,COUNT(hajo) utak
FROM HAJO.S_HAJO_TIPUS tip
LEFT OUTER JOIN
HAJO.S_HAJO haj
ON tip.hajo_tipus_id=haj.hajo_tipus
LEFT OUTER JOIN
HAJO.S_UT ut
ON haj.hajo_id=ut.hajo
GROUP BY tip.hajo_tipus_id,tip.nev
ORDER BY tip.nev;

--76.
--Hozzon l�tre n�zetet, amely list�zza, hogy az egyes kik�t?knek h�ny telefonsz�ma van. 
--A lista tartalmazza a kik�t?k azonos�t�j�t,
--a helys�g nev�t �s osz�g�t �s a telefonok sz�m�t. 
--Azokat is t�ntess�k fel, aminek nincs telefonsz�ma
CREATE VIEW CSINALDMEG AS(
SELECT kikot.kikoto_id,helysegnev,orszag,COUNT(telefon) szama
FROM HAJO.S_HELYSEG helys
INNER JOIN
HAJO.S_KIKOTO kikot 
ON helys.helyseg_id=kikot.helyseg
LEFT OUTER JOIN
HAJO.S_KIKOTO_TELEFON tel
ON kikot.kikoto_id=tel.kikoto_id
GROUP BY kikot.kikoto_id,helysegnev,orszag);

--81. 
--Hozzon l�tre n�zetet, amely megadja a legnagyobb forgalm� kik�t?(k) azonos�t�j�t, 
--helys�gnev�t �s orsz�g�t! A legnagyobb
--forgalm� kik�t? az, amelyik a legt�bb �t indul�si vagy �rkez�si kik�t?je volt.
CREATE VIEW LEGNAGYOBB AS(
SELECT kikoto_id,COUNT(indulasi_kikoto)+COUNT(erkezesi_kikoto)
FROM HAJO.S_HELYSEG helys
INNER JOIN
HAJO.S_KIKOTO kikot
ON helys.helyseg_id=kikot.helyseg
INNER JOIN
HAJO.S_UT ut
ON kikot.kikoto_id =ut.indulasi_kikoto
GROUP BY kikoto_id
ORDER BY COUNT(indulasi_kikoto)+COUNT(erkezesi_kikoto) DESC
FETCH FIRST ROW WITH TIES);

--82
--Hozzon l�tre n�zetet, amely megadja annak a haj�nak az azonos�t�j�t �s nev�t, 
--amelyik a legnagyobb �sszs�lyt sz�ll�totta a 2021 m�jus�ban indul� utakon! 
--Ha t�bb ilyen haj� is van, akkor mindegyiket list�zza!

SELECT hajo_id,nev,SUM(rakomanysuly)
FROM HAJO.S_HAJO haj
INNER JOIN
HAJO.S_UT ut
ON haj.hajo_id=ut.hajo
INNER JOIN 
HAJO.S_SZALLIT sza
ON ut.ut_id=sza.ut
INNER JOIN 
HAJO.S_HOZZARENDEL rend
ON sza.kontener=rend.kontener
AND sza.megrendeles=rend.megrendeles
WHERE TO_CHAR(indulasi_ido,'yyyy.mm.')='2021.05.'
GROUP BY hajo_id,nev
ORDER BY SUM(rakomanysuly) DESC
FETCH FIRST ROW WITH TIES;

--83
--Hozzon l�tre n�zetet, ami megadja a kik�t? azonos�t�j�t, helys�gnev�t, 
--orsz�g�t, amelykb?l kiindul� utakon
--sz�ll�tott kont�nerek �sszes�lya  a legnagyobb. 
--Ha t�bb ilyen van, akkor mindegyiket list�zza
CREATE VIEW LEGTOBB AS
SELECT kikoto_id,SUM(rakomanysuly)
FROM HAJO.S_HELYSEG helys
INNER JOIN
HAJO.S_KIKOTO kikot
ON helys.helyseg_id=kikot.helyseg
INNER JOIN
HAJO.S_UT ut
ON kikot.kikoto_id=ut.indulasi_kikoto
INNER JOIN
HAJO.S_SZALLIT sza
ON ut.ut_id=sza.ut
INNER JOIN
HAJO.S_HOZZARENDEL rend
ON sza.kontener=rend.kontener
AND sza.megrendeles=rend.megrendeles
GROUP BY kikoto_id
ORDER BY SUM(rakomanysuly)DESC NULLS LAST
FETCH FIRST ROW WITH TIES;

--85.
--Hozzon l�tre n�zetet amely megadja azoknak az utaknak az adatait, 
--amelyeken a rakom�ny s�lya (a sz�ll�tott kont�nerek �s a
--rakom�nyaik �sszs�lya) meghaladja  a haj� maxim�lis s�lyterhel�s�t! 
--Az �t adatai mellett t�ntesse fel a haj� nev�t �s maxim�lis s�lyterhel�s�t
--Valamint a rakom�ny s�ly�t is
CREATE VIEW TULMEGY AS
SELECT ut_id ut_id,to_char(indulasi_ido,'yyyy.mm.dd.hh24:mi:ss')indulasi_ido,to_char(erkezesi_ido,'yyyy.mm.dd.hh24:mi:ss')erkezesi_ido,indulasi_kikoto indulasi_kikoto,erkezesi_kikoto erkezesi_kikoto,hajo,haj.nev,max_sulyterheles,SUM(rend.kontener+rend.rakomanysuly) rakomanysuly
FROM HAJO.S_HAJO haj
INNER JOIN
HAJO.S_UT ut
ON haj.hajo_id=ut.hajo
INNER JOIN
HAJO.S_SZALLIT sza
ON ut.ut_id=sza.ut
INNER JOIN
HAJO.S_HOZZARENDEL rend
ON sza.megrendeles=rend.megrendeles
AND sza.kontener=rend.kontener
GROUP BY rend.megrendeles,ut_id,erkezesi_ido,indulasi_ido,indulasi_kikoto,erkezesi_kikoto,hajo,haj.nev,max_sulyterheles
HAVING SUM(rend.kontener+rend.rakomanysuly)>max_sulyterheles
ORDER BY ut_id;

--86. 
--Hozzon l�tre n�zetet amely megadja azoknak az utaknak az adatait, amelyeken a rakom�ny s�lya (a sz�ll�tott kont�nerek �s a
--rakom�nyaik �sszs�lya) nem haladja meg a haj� maxim�lis s�lyterhel�s�nek a fel�t! Az �t adatai mellett t�ntesse fel a haj� nev�t �s maxim�lis s�lyterhel�s�t
--Valamint a rakom�ny s�ly�t is
CREATE VIEW FELETMEGHALADJA AS
SELECT ut_id ut_id,to_char(indulasi_ido,'yyyy.mm.dd.hh24:mi:ss')indulasi_ido,to_char(erkezesi_ido,'yyyy.mm.dd.hh24:mi:ss')erkezesi_ido,indulasi_kikoto indulasi_kikoto,erkezesi_kikoto erkezesi_kikoto,hajo,haj.nev,(max_sulyterheles/2)max_suly,SUM(rend.kontener+rend.rakomanysuly) rakomanysuly
FROM HAJO.S_HAJO haj
INNER JOIN
HAJO.S_UT ut
ON haj.hajo_id=ut.hajo
INNER JOIN
HAJO.S_SZALLIT sza
ON ut.ut_id=sza.ut
INNER JOIN
HAJO.S_HOZZARENDEL rend
ON sza.megrendeles=rend.megrendeles
AND sza.kontener=rend.kontener
GROUP BY rend.megrendeles,ut_id,erkezesi_ido,indulasi_ido,indulasi_kikoto,erkezesi_kikoto,hajo,haj.nev,max_sulyterheles
HAVING SUM(rend.kontener+rend.rakomanysuly)<max_sulyterheles/2
ORDER BY ut_id;

--88.
--Hozzon l�tre n�zetet, amely megadja annak a megrendel�snek az adatait, 
--amelynek a teljes�t�s�hez a legt�bb �tra volt sz�ks�g! Ha t�bb
--Ilyen megrendel�s is van, akkor mindegyiket list�zza!
SELECT megrendeles_id, rend.indulasi_kikoto,rend.erkezesi_kikoto,to_char(megrendeles_datuma,'yyyy.mm.dd.hh24:mi:ss'),ugyfel,fizetett_osszeg,igenyelt_kontenerszam,COUNT(ut_id)
FROM HAJO.S_MEGRENDELES rend
INNER JOIN
HAJO.S_HOZZARENDEL rendel
ON rend.megrendeles_id=rendel.megrendeles
INNER JOIN
HAJO.S_SZALLIT sza
ON rendel.kontener=sza.kontener
AND rendel.megrendeles=sza.megrendeles
INNER JOIN
HAJO.S_UT ut
ON sza.ut=ut.ut_id
GROUP BY  megrendeles_id, rend.indulasi_kikoto,rend.erkezesi_kikoto,to_char(megrendeles_datuma,'yyyy.mm.dd.hh24:mi:ss'),ugyfel,fizetett_osszeg,igenyelt_kontenerszam
ORDER BY COUNT(ut_id)DESC
FETCH FIRST ROW WITH TIES;

--92.
--Adjon hivatkoz�si jogosults�got panovicsnak az �n s_ut t�bl�j�nak indulasi_ido �s hajo oszlopaiba
GRANT REFERENCE ON HAJO.S_UT(indulasi_ido,hajo) TO panovics;

--94
--Adjon m�dos�t�si jogosults�got a 'panovics' felhaszn�l�nak az 
--�n s_ugyfel t�bl�j�nak vezet�k �s keresztn�v oszlopaira
GRANT UPDATE ON HAJO.S_UGYFEL(vezeteknev,keresztnev) TO panovics;

--95
--Adjon besz�r�si jogosults�got minden felhaszn�l�nak 
--az �n 's_kikoto' t�bl�j�nak a 'kikoto_id' �s 'helyseg' oszlopaira!
--CREATE TABLE kikoto AS
--SELECT * FROM HAJO.S_KIKOTO;
GRANT INSERT (kikoto_id,helyseg)ON HAJO.S_KIKOTO TO PUBLIC;

--96
--Vonja vissza a lek�rdez�si jogosults�got a 'panovics' felhaszn�l�t�l az �n s_ut t�bl�j�b�l
REVOKE SELECT ON hajo.s_ut FROM panovics;

--98
--Vonja vissza a t�rl�si �s m�dos�t�si jogosults�got a 'panovics' nev? felhaszn�l�t�l az �n s_kikoto t�bl�j�r�l
REVOKE DELETE,UPDATE ON hajo.s_kikoto FROM panovics;


--99
--Vonja vissza a t�rl�si jogot 'panovics' felhaszn�l�t�l az �n s_orszag t�bl�j�r�l
REVOKE DELETE ON hajo.s_orszag FROM panovics;
--100
--Vonja vissza a besz�r�si jogosults�got minden felhaszn�l�t�l az �n s_megrendel�s t�bl�j�r�l

GRANT INSERT ON teszt TO PUBLIC;
REVOKE INSERT ON teszt FROM PUBLIC;






         


                    
                


                                        








