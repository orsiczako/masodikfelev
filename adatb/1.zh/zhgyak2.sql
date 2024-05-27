--1
--Listázza ki az ügyfelek azonosítóját, teljes nevét,
--valamint a megrendeléseik azonosítóját!
--Azok az ügyfelek is szerepeljenek az eredményben,
--akik soha nem adtak le megrendeléseket.
--A lista legyen vezetéknév, azon belül megrendelés azonosítója szerint rendezve
SELECT ugyfel_id, CONCAT(vezeteknev,CONCAT(' ',keresztnev)) AS "Teljes név", megrendeles_id
FROM HAJO.S_UGYFEL ugyf
LEFT OUTER JOIN
HAJO.S_MEGRENDELES rend
ON ugyf.ugyfel_id=rend.ugyfel
ORDER BY vezeteknev,megrendeles_id;

--2.
--Listázza ki a hajótípusok azonosítóját és nevét, 
--valamint az adott típusú hajók azonosítóját és nevét! 
--A hajótípusok nevét tartalmazó oszlop
--'típusnév', a hajók nevét tartalmazó oszlop pedig 'hajónév' legyen! 
--Azok a hajótípusok is jelenjenek meg, amelyhez egyetlen hajó sem tartzoik.
--A lista legyen a hajótípus neve, azon belül a hajó neve alapján rendezve.
SELECT tip.nev tipusnev,hajo_tipus_id,haj.nev hajonev,hajo_id
FROM HAJO.S_HAJO_TIPUS tip
LEFT OUTER JOIN
HAJO.S_HAJO haj
ON tip.hajo_tipus_id=haj.hajo_tipus
ORDER BY tip.nev,haj.nev;

--3.
/*Listázza ki a 15 tonnát meghaladó rakománnya r
endelkez? konténerek teljes azonosítóját
(megrendelésazonosító és konténerazonosító),
valamint a rakománysúlyt is 2 tizedesjegyre kerekítve! Rendezze az eredményr a pontos 
rakománysúly szerint növekv? sorrendbe*/
SELECT megrendeles||' '||kontener,ROUND(rakomanysuly,2)
FROM HAJO.S_HOZZARENDEL 
WHERE rakomanysuly>=15
ORDER BY rakomanysuly ASC;

--5
--Listázza ki Magyarországénál kisebb lakossággal rendelkez? országok nevét,
--lakosságát, valamint a f?városuk nevét. Azokat az országokat is
--listázza, amelyeknek nem ismerjük a f?városát.
--Ezen országok esetében a f?város helyén "nem ismert" sztring szerepeljen.
--Rendezze az országokat
--a lakosság szerint csökken? sorrendben.
SELECT orsz.lakossag,orsz.orszag,COALESCE(helysegnev,'Nem ismert')
FROM HAJO.S_ORSZAG orsz
LEFT OUTER JOIN
HAJO.S_HELYSEG helys
ON orsz.fovaros=helys.helyseg_id
WHERE orsz.lakossag <(SELECT lakossag
                        FROM HAJO.S_ORSZAG 
                        WHERE orszag='Magyarország')
ORDER BY orsz.lakossag DESC;

--6 
--Listázza ki azoknak az ügyfeleknek az azonosítóját és teljes nevét,
--akik adtak már fel olasz- országi kiköt?b?l induló szállításra vonatkozó megrendelést! 
--Egy ügyfél csak egyszer szere- peljen az eredményben!
SELECT ugyfel_id, CONCAT(vezeteknev,CONCAT(' ',keresztnev)) AS "Teljes név"
FROM HAJO.S_UGYFEL
WHERE ugyfel_id IN(SELECT ugyfel
                    FROM HAJO.S_MEGRENDELES
                    WHERE indulasi_kikoto IN(SELECT kikoto_id
                                            FROM HAJO.S_KIKOTO
                                            WHERE helyseg IN(SELECT helyseg_id
                                                            FROM HAJO.S_HELYSEG WHERE orszag='Olaszország')));

--7
--Listázza ki azoknak a hajóknak az azonosítóját és nevét, 
--amelyek egyetlen út célállomásaként sem kötöttek ki francia kiköt?kben
SELECT hajo_id,nev
FROM HAJO.S_HAJO 
WHERE hajo_id NOT IN(SELECT hajo
                    FROM HAJO.S_UT
                    WHERE erkezesi_kikoto IN(SELECT kikoto_id
                                            FROM HAJO.S_KIKOTO 
                                            WHERE helyseg IN(SELECT helyseg_id
                                                            FROM HAJO.S_HELYSEG
                                                            WHERE orszag='Franciaország')));

--egy másik lehetséges megoldás:
SELECT hajo_id,nev
FROM HAJO.S_HAJO
WHERE hajo_id NOT IN(
SELECT hajo
FROM HAJO.S_UT ut
INNER JOIN
HAJO.S_KIKOTO kikot
ON ut.erkezesi_kikoto=kikot.kikoto_id
INNER JOIN HAJO.S_HELYSEG helys
ON kikot.helyseg=helys.helyseg_id
WHERE orszag='Franciaország');

--8.
--Listázza ki azoknak a helységeknek az azonosítóját, országát és nevét, 
--amelyeknek valamelyik kiköt?jéb?l
--indult már útra az SC Bella nev? hajó! Egy helység csak egyszer szerepeljen
SELECT helyseg_id,orszag,helysegnev
FROM HAJO.S_HELYSEG
WHERE helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_KIKOTO
                    WHERE kikoto_id IN(SELECT indulasi_kikoto
                                        FROM HAJO.S_UT
                                        WHERE hajo IN(SELECT hajo_id
                                                    FROM HAJO.S_HAJO
                                                    WHERE nev='SC Bella')));
                                                    
--9.
--Listázza ki azokat a mmegrendeléseket (azonosító) amelyekért többet fizettek, 
--mint a 2021. áprilisában leadott megrendelések
--Bármelyikéért. A fizetett összeget is tüntesse fel!
SELECT megrendeles_id,fizetett_osszeg
FROM HAJO.S_MEGRENDELES
WHERE fizetett_osszeg>(SELECT MAX(fizetett_osszeg)
                        FROM HAJO.S_MEGRENDELES
                        WHERE to_char(megrendeles_datuma,'yyyy.mm.')='2021.04.');
                        
--10.
--Listázza ki azokat a megrendeléseknek az azonositóját 
--amelyekben ugyanannyi konténer igényeltek, mint valamelyik
--2021 feb. leadott megrendelésben! 
--A megrendelések azonositójuk mellet tüntesse fel az igényelt konténerek számát is
SELECT megrendeles_id,igenyelt_kontenerszam
FROM HAJO.S_MEGRENDELES
WHERE igenyelt_kontenerszam IN(SELECT igenyelt_kontenerszam
                                FROM HAJO.S_MEGRENDELES
                                WHERE to_char(megrendeles_datuma,'yyyy.mm.')='2021.02.');
                                
--11
--Listázza ki azoknak a hajóknak a nevét, a maximális súlyterhelését, 
--valamint a tipusának a nevét, amely egyetlen utat sem teljesített.
--A hajó nevét megadó oszlop neve a 'hajónév' a tipusnevét a 'tipusnév'.
SELECT haj.nev,max_sulyterheles,tip.nev
FROM HAJO.S_HAJO_TIPUS tip
INNER JOIN
HAJO.S_HAJO haj
ON tip.hajo_tipus_id=haj.hajo_tipus
WHERE hajo_id NOT IN(SELECT hajo
                    FROM HAJO.S_UT);
                    
--12.
--Listázza ki azoknak az ügyfeleknek a teljes nevét és származási országát, 
--akiknek nincs 1milliónál nagyobb érték? rendelése!
--Azok is szerepeljenek, akiknek nem ismerjük a származását. 
--Rendezze az eredményt vezetéknév, azon belül keresztnév szerint
SELECT CONCAT(vezeteknev,CONCAT(' ',keresztnev)) AS "Teljes név",orszag
FROM HAJO.S_HELYSEG helys
RIGHT OUTER JOIN
HAJO.S_UGYFEL ugyf
ON helys.helyseg_id=ugyf.helyseg
WHERE ugyfel_id NOT IN(SELECT ugyfel
                    FROM HAJO.S_MEGRENDELES
                    WHERE fizetett_osszeg>1000000)
ORDER BY vezeteknev,keresztnev;                    

--13
--Listázza ki ábécérendben azoknak a hajoknak az azonosítóját, 
--amelyekbe vagy teljesített egy utat az It_Cat azonosítójú kiköt?b?l, 
--vagy célpontja egy, az It_Cat
--azonosítój? kiköt?j? megrendelésnek!
SELECT hajo
FROM HAJO.S_UT 
WHERE indulasi_kikoto='It_Cat'
UNION
SELECT haj.hajo_id
FROM HAJO.S_HAJO haj
LEFT OUTER JOIN
HAJO.S_UT ut
ON haj.hajo_id=ut.hajo
INNER JOIN
HAJO.S_KIKOTO kikot
ON ut.erkezesi_kikoto=kikot.kikoto_id
INNER JOIN
HAJO.S_MEGRENDELES rend
ON kikot.kikoto_id=rend.erkezesi_kikoto
WHERE rend.erkezesi_kikoto='It_Cat'
AND rend.erkezesi_kikoto NOT IN(SELECT erkezesi_kikoto
                                FROM HAJO.S_UT);

--14.
--Listázza ki ábécérendben azoknak a kiköt?knek az azonosítóját, 
--melyekbe legalább egy hajó teljesített utat
--Az 'It_Cat' azonosítójú kiköt?b?l és célpontja legalább egy, 
--az 'It_Cat' kiköt?b?l induló megrendelésnek. A kiköt? csak egyszer
--Szerepeljen a lekérdezésben.
SELECT erkezesi_kikoto
FROM HAJO.S_UT
WHERE indulasi_kikoto='It_Cat'
INTERSECT
SELECT erkezesi_kikoto
FROM HAJO.S_MEGRENDELES
WHERE indulasi_kikoto='It_Cat'
GROUP BY erkezesi_kikoto;

--15. 
--Listázza ki ábécérendben azoknak a helységeknek az azonosítóját, 
--országát és nevét, ahonnan származnak ügyfeleink, vagy ahol vannak kiköt?k!
--Egy helység csak egyszer szerepeljen az eredményben! 
--A lista legyen országnév, azon belül helységnév szerint rendezett.
SELECT DISTINCT(helyseg_id),orszag,helysegnev
FROM HAJO.S_HELYSEG
WHERE helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_UGYFEL)
OR helyseg_id IN(SELECT helyseg
                FROM HAJO.S_KIKOTO)
ORDER BY orszag,helysegnev;  

--16
--Listázza ki ábécérendben azoknak a kiköt?vel rendelkez? helységeknek az azonosítóját,
--országát és nevét, ahonnan legalább egy ügyfelünk is származik! 
--Egy helység csak egyszer szerepeljen az eredményben! 
--A lista legyen országnév, azon belül helységnév szerint rendezve!
SELECT DISTINCT(helyseg_id),orszag,helysegnev
FROM HAJO.S_HELYSEG
WHERE helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_UGYFEL)
AND helyseg_id IN(SELECT helyseg
                FROM HAJO.S_KIKOTO)
ORDER BY orszag,helysegnev;

--19.
--Listázza ki növekv? sorrendben azoknak a megrendeléseknek az azonosítóját, 
--amelyekért legalább kétmilliót fizetett
--Egy Yiorgos keresztnev? ügyfél, és még nem történt meg a szállításuk
SELECT megrendeles_id
FROM HAJO.S_MEGRENDELES
WHERE fizetett_osszeg>=2000000
AND ugyfel IN(SELECT ugyfel_id
                FROM HAJO.S_UGYFEL
                WHERE keresztnev='Yiorgos')
AND megrendeles_id NOT IN(SELECT megrendeles
                            FROM HAJO.S_SZALLIT 
                            WHERE ut IN(SELECT ut_id
                                        FROM HAJO.S_UT))
ORDER BY megrendeles_id ASC;

--Listázza ki azoknak a helységeknek az azonosítóját, 
--országát és nevét, amelyek lakossága meghaladja az egymillió f?t, és azokét is, 
--ahonnan származik 50 évesnél id?sebb ügyfelünk! 
--Egy helység csak egyszer szerepeljen az eredményben!
--A lista legyen országnév, azon belül helységnév szerint rendezve!
SELECT helyseg_id,orszag,helysegnev
FROM HAJO.S_HELYSEG
WHERE lakossag>=1000000
OR helyseg_id IN (SELECT helyseg
                    FROM HAJO.S_UGYFEL
                    WHERE MONTHS_BETWEEN(sysdate,szul_dat)/12>50)
ORDER BY orszag,helysegnev;                    
                                
--22.
--Melyik három ország kiköt?jéb?l induló szállításokra adták le a legtöbb megrendelést?
--Az országnevek mellett tüntesse fel az onnan induló megrendelések számát is
SELECT orszag,COUNT(megrendeles_id)
FROM HAJO.S_HELYSEG helys
INNER JOIN
HAJO.S_KIKOTO kikot
ON helys.helyseg_id=kikot.helyseg
INNER JOIN
HAJO.S_MEGRENDELES rend
ON kikot.kikoto_id=rend.indulasi_kikoto
GROUP BY orszag
ORDER BY COUNT(megrendeles_id) DESC
FETCH FIRST 3 ROW WITH TIES;

--24.
--Adja meg  a két legkevesebb utat teljseít? olyan hajó nevét ,amelyik legalább egy utat teljesített,
--és legjeljebb 10 konténert tud egyszerre szállítani.
--A hajók neve mellet tüntesse fel az általuk teljesített utak számát is.
SELECT nev,COUNT(ut_id)
FROM HAJO.S_HAJO haj
INNER JOIN
HAJO.S_UT ut
ON haj.hajo_id=ut.hajo
WHERE max_kontener_dbszam=10
GROUP BY nev
ORDER BY COUNT(ut_id) ASC
FETCH FIRST 2 ROW WITH TIES;

--25
--Listázza ki a tíz legtöbb igényelt konténert tartalmazó
--megrendelést leadó ügyfél teljes nevét, 
--a megrendelés azonosítóját és az igényelt konténerek számát!
SELECT megrendeles_id,CONCAT(vezeteknev,CONCAT(' ',keresztnev)) AS "Teljes név", igenyelt_kontenerszam
FROM HAJO.S_UGYFEL ugy
INNER JOIN
HAJO.S_MEGRENDELES rend
ON ugy.ugyfel_id=rend.ugyfel
GROUP BY megrendeles_id,CONCAT(vezeteknev,CONCAT(' ',keresztnev)),igenyelt_kontenerszam
ORDER BY igenyelt_kontenerszam DESC
FETCH FIRST 10 ROW WITH TIES;

--26
--Adja meg az SC Nina nev? hajóval megtett 3 leghosszabb ideig tartó út indulási 
--és érkezési kiköt?jének az azonosítóját.
SELECT indulasi_kikoto,erkezesi_kikoto
FROM HAJO.S_HAJO haj
INNER JOIN
HAJO.S_UT ut
ON haj.hajo_id=ut.hajo
WHERE nev='SC Nina'
ORDER BY erkezesi_ido-indulasi_ido DESC
FETCH FIRST 3 ROW WITH TIES;

--27
--Adja meg a három legtöbb utat teljesít? hajó nevét!
--A hajók neve mellett tüntesse fel az általuk teljesített utak számát is
SELECT nev,COUNT(ut_id)
FROM HAJO.S_HAJO haj
INNER JOIN
HAJO.S_UT ut
ON haj.hajo_id=ut.hajo
GROUP BY nev
ORDER BY COUNT(ut_id)DESC
FETCH FIRST 3 ROW WITH TIES;

--28
-- Az 'It Cat' azonosítójú kiköt?b?l induló utak közül melyik 
--négyen szállították a legkevesebb konténert?
--Csak azokat az utakat vegye figyelembe, 
--amelyeken legalább egy konténert szállítottak!
--Az utakat az azonosítójukkal adja meg, 
--és tüntesse fel a szállított konténerek számát is!!
SELECT ut_id,COUNT(kontener)
FROM HAJO.S_UT ut
INNER JOIN
HAJO.S_SZALLIT sza
ON ut.ut_id=sza.ut
WHERE indulasi_kikoto='It_Cat'
GROUP BY ut_id
ORDER BY COUNT(kontener) ASC
FETCH FIRST 4 ROW WITH TIES;

--29
--Adja meg a négy legtöbb rendelést leadó teljes nevét és a megrendelések számát
SELECT CONCAT(vezeteknev,CONCAT(' ' ,keresztnev)) AS "Teljes név",COUNT(megrendeles_id)
FROM HAJO.S_UGYFEL ugyf
INNER JOIN
HAJO.S_MEGRENDELES rend
ON ugyf.ugyfel_id=rend.ugyfel
GROUP BY CONCAT(vezeteknev,CONCAT(' ' ,keresztnev))
ORDER BY COUNT(megrendeles_id) DESC
FETCH FIRST 4 ROW WITH TIES;

--30
--Listázza ki az öt legidősebb olaszországi ügyfelünk teljes nevét és születési dátumát!
SELECT CONCAT(vezeteknev,CONCAT(' ',keresztnev)) AS "Teljes név",to_char(szul_dat,'yyyy.mm.dd.hh24:mi:ss')
FROM HAJO.S_UGYFEL ugyf
INNER JOIN
HAJO.S_HELYSEG helys
ON ugyf.helyseg=helys.helyseg_id
WHERE orszag='Olaszország'
ORDER BY szul_dat ASC NULLS LAST
FETCH FIRST 5 ROW WITH TIES;

--31.
--Hozzon létre egy s_szemelyzet nevu tablat, 
--amelyben a hajókon dolgozó személyzet adatai találhatóak. 
--Minden szerel?nek van azonosítója
--Pontosan 10 karakteres sztring. Ez az els?dleges kulcs is. 
--Vezeték és keresztneve mindkett? 50-50 karakteres sztring. 
--Születési dátuma, egy telefonszáma
--(20 jegy? egész szám). És hogy melyik hajó személyzetéhez tartozik 
--(max 10 karakteres sztring), és ezt egy hivatkozással az s_hajó táblára hozzuk létre.
--A telefonszámot legyen kötelez? megadni. Minden megszorítást nevezzen el
CREATE TABLE S_HAJO AS
SELECT * FROM HAJO.S_HAJO WHERE 0=1;
ALTER TABLE S_HAJO
ADD CONSTRAINT hajo_id_pk PRIMARY KEY(hajo_id);

CREATE TABLE S_SZEMELYZET(
azon CHAR(10),
vezeteknev VARCHAR2(50),
keresztnev VARCHAR2(50),
szul_dat DATE,
tel NUMBER(20) NOT NULL,
hajo VARCHAR(10),
CONSTRAINT azon_pk PRIMARY KEY(azon),
CONSTRAINT hajo_ref FOREIGN KEY(hajo) REFERENCES S_HAJO(hajo_id));

--33
--Hozzon létre egy 's_kikoto_email' nev? táblát, 
--amelyben a kiköt?k e-mail címét tároljuk! Legyen benne egy kikoto_id nev? oszlop
--(maximum 10 karakteres string), amely hivatkozik az s_kikoto táblára.
--Valamint egy email cím, ami egy maximum 200 karakteres string!
--Egy kiköt?nek több email címe lehet, ezért a tábla els?dleges kulcsát
--a két oszlop együttesen alkossa!
--Minden megszorítást nevezzen el!
CREATE TABLE S_KIKOTO AS
SELECT * FROM HAJO.S_KIKOTO WHERE 0=1;
ALTER TABLE S_KIKOTO
ADD CONSTRAINT id_pk PRIMARY KEY(kikoto_id);

CREATE TABLE S_KIKOTO_EMAIL(
kikoto_id VARCHAR2(10),
email VARCHAR2(200),
CONSTRAINT em_pk PRIMARY KEY(kikoto_id,email),
CONSTRAINT id_ref FOREIGN KEY(kikoto_id) REFERENCES S_KIKOTO(kikoto_id));

--35.
--Hozzon létre egy s_hajo_javitas táblát, ami a hajók javítási adatait tartalmazza! 
--Legyen benne a javított hajó azonosítója, 
--amely az s_hajó táblára hivatkozik, legfeljebb
--10 karakter hosszú sztring és ne legyen null. Javítás kezdete és vége_ dárumok. 
--Javítás ára: 
--egy legfeljebb 10 jegy? valós szám, két tizedesjeggyel, valamint a hiba
--leírása, 200 karakteres sztring (legfeljebb).
--A tábla els?dleges kulcsa és a javítás kezd?dátuma els?dlegesen alkossa. 
--További megkötés, hogy a javítás 
--vége csak a javítás kezdete
--nél kés?bbi dátum lehet.
CREATE TABLE S_HAJO_JAVITAS(
hajo_id VARCHAR2(10) NOT NULL,
jav_kezdet DATE,
jav_vege DATE,
ar NUMBER(10,2),
leiras VARCHAR2(200),
CONSTRAINT jav_pk PRIMARY KEY(jav_kezdet,jav_vege),
CONSTRAINT veg_ck CHECK(jav_vege>jav_kezdet),
CONSTRAINT haj_ref FOREIGN KEY(hajo_id) REFERENCES S_HAJO(hajo_id));

--Nevezze át az s_hozzarendel táblát, az új név: s_kontener legyen!
CREATE TABLE S_HOZZARENDEL AS
SELECT * FROM HAJO.S_HOZZARENDEL;

ALTER TABLE S_HOZZARENDEL
RENAME TO S_KONTENER;
--vagy
RENAME S_KONTENER TO S_HOZZARENDEL;

--43
--Törölje az s_hajo és az s_hajo tipus táblákat! 
--Vegye figyelembe az egyes táblákra hivatkozó küls? kulcsokat.
CREATE TABLE S_HAJO AS
SELECT * FROM HAJO.S_HAJO WHERE 0=1;


CREATE TABLE S_HAJO_TIPUS AS
SELECT * FROM HAJO.S_HAJO_TIPUS WHERE 0=1;
ALTER TABLE S_HAJO_TIPUS
ADD CONSTRAINT tip_pk PRIMARY KEY(hajo_tipus_id);

ALTER TABLE S_HAJO
ADD CONSTRAINT az_ref FOREIGN KEY (hajo_tipus) REFERENCES S_HAJO_TIPUS(hajo_tipus_id);

DROP TABLE S_HAJO;
DROP TABLE S_HAJO_TIPUS;

--42
-- A helységek lakossági adata nem fontos számunkra.
--Törölje az 's_helyseg' tábla 'lakossag' oszlopát! 
CREATE TABLE S_HELYSEG AS
SELECT * FROM HAJO.S_HELYSEG WHERE 0=1;

ALTER TABLE S_HELYSEG
DROP COLUMN lakossag;

----44
--Törölje az 's_kikoto_telefon' tábla els?dleges kulcs megszorítását!
--hát na fingom nincs mi a neve annak a megszorításnak de vhogy így nézne ki:
ALTER TABLE S_KIKOTO_TELEFON
DROP CONSTRAINT const_name;

--50.
--Módosítsa az s_ugyfel tábla email oszlopának maximális hosszát 50 karakterre, 
--az utca_hsz oszlop hosszát pedig 100 karakterre!
CREATE TABLE S_UGYFEL AS
SELECT * FROM HAJO.S_UGYFEL WHERE 0=1;  

ALTER TABLE S_UGYFEL
MODIFY email VARCHAR2(100)
MODIFY utca_hsz VARCHAR2(100);

--53
--Szúrja be a hajó sémából a saját sémájának s_ugyfel táblájába 
--az olaszországi ügyfeleket!
INSERT INTO S_UGYFEL
SELECT *
FROM HAJO.S_UGYFEL
WHERE helyseg IN(SELECT helyseg_id
                FROM HAJO.S_HELYSEG
                WHERE orszag='Olaszország');
                
--54
--Szúrja be a hajó sémából a saját sémájának 
--s_hajó táblájába a small feeder tipusú hajók közül azokat,
--amelyeknek nettó súlya legalább 250 tonna
INSERT INTO S_HAJO
SELECT *
FROM HAJO.S_HAJO
WHERE hajo_tipus IN(SELECT hajo_tipus_id
                    FROM HAJO.S_HAJO_TIPUS
                    WHERE nev='Small feeder')
AND netto_suly>=250;

--55.
--Szúrja be a 'hajó' sémából a saját sémájának s_hajo táblájába azokat a 'Small Feeder"' típusú hjaókat, 
--amelyek legfeljebb 10 konténert
--tudnak szállítani egyszerre;
INSERT INTO S_HAJO
SELECT *
FROM HAJO.S_HAJO
WHERE hajo_tipus IN(SELECT hajo_tipus_id
                    FROM HAJO.S_HAJO_TIPUS
                    WHERE nev='Small feeder')
AND max_kontener_dbszam=10;

--57
--Törölje a szárazdokkal rendelkez? olaszországi és ibériai kiköt?ket! 
--Azok a kiköt?k rendelkeznek szárazdokkal, amelyeknek a leírásában
--szerepel a szárazdokk szó.
DELETE FROM S_KIKOTO
WHERE helyseg IN(SELECT helyseg_id
                FROM HAJO.S_HELYSEG
                WHERE orszag='Olaszország'
                OR orszag='Ibéria')
AND leiras LIKE '%szárazdokk%';

--59.
--Törölje azokata 2021 jún. induló utakat,amelyeken 20 nál kevesebb 
--konténert szállított a hajó.
DELETE FROM S_UT
WHERE to_char(indulasi_ido,'yyyy.mm.')='2021.06.'
AND ut_id IN(SELECT ut
            FROM HAJO.S_UT
            GROUP BY ut
            HAVING COUNT(kontener)<20);
            
--61
--Módosítsa a nagy terminálterülettel rendelkez? kiköt?k leírását úgy, 
--hogy az az elején tar- talmazza a kiköt? helységét is, 
--amelyet egy vessz?vel és egy sz?közzel válasszon el a leírás jelenlegi tartalmától! 
--A nagy terminálterülettel rendelkez? kiköt?k leírásában szerepel a 'terminálterület: nagy, sztring. 
--(Figyeljen a vessz?re, a nagyon nagy" terület? kiköt?ket nem szeretnénk módosítani!) 
UPDATE S_KIKOTO kikot
SET leiras=(SELECT helysegnev
            FROM HAJO.S_HELYSEG he
            WHERE kikot.helyseg=he.helyseg_id)||' '||leiras
WHERE leiras LIKE '%terminálterület: nagy%'
AND leiras NOT LIKE '%terminálterület: nagyon nagy%';   

--62
--Alakítsa csuba nagybet?ssé azon ügyfelek vezetéknevét, 
--akik eddig a legtöbbet fizették összesen a megrendeléseikért
UPDATE S_UGYFEL
SET vezeteknev=UPPER(vezeteknev)
WHERE ugyfel_id IN(SELECT ugyfel
                    FROM HAJO.S_MEGRENDELES
                    GROUP BY ugyfel
                    ORDER BY SUM(fizetett_osszeg) DESC
                    FETCH FIRST ROW WITH TIES);
                    
--68
--A népességi adataink elavultak. 
--A frissítésük egyik lépéseként növelje meg 5%-kal az 
--ázsiai országok településeinek lakosságát! 
UPDATE S_HELYSEG
SET lakossag=lakossag*1.05
WHERE orszag IN(SELECT orszag
                FROM HAJO.S_ORSZAG
                WHERE foldresz='Ázsia');
                
--69
--Egy pusztító vírus szedte áldozatait Afrika nagyvárosaiban. 
--Felezze meg azon afrikai települések lakosságát, amelyeknek aktuális
--lakossága meghaladja a félmillió f?t!
UPDATE S_HELYSEG
SET lakossag=lakossag/2
WHERE orszag IN(SELECT orszag
                FROM HAJO.S_ORSZAG
                WHERE foldresz='Afrika')
AND lakossag>=500000;

--70.
--Cégünk adminisztrátora elkövetett egy nagy hibát. 
--A 2021 júliusában Algeciras kiköt?jéb?l induló utakat tévesen
--Vitte be az adatbázisba, mintha azok Valenciából indultak volna. 
--Valóban Valenciából egyetlen út sem indult a kérdéses id?pontban
--Korrigálja az adminisztrátor hibáját! 
--Az egyszer?ség kedvéért feltételezzük, hogy 1-1 ilyen város létezik, egy kiköt?vel
UPDATE S_HELYSEG
SET helysegnev='Algeciras'
WHERE helyseg_id IN(SELECT helyseg_id
                    FROM HAJO.S_HELYSEG
                    WHERE helysegnev='Valencia'
                    AND helyseg_id IN(SELECT helyseg
                                        FROM HAJO.S_KIKOTO 
                                        WHERE kikoto_id IN(SELECT indulasi_kikoto
                                                            FROM HAJO.S_UT 
                                                            WHERE to_char(indulasi_ido,'yyyy.mm.')='2021.07.')));
                                                            
--71.
--Hozzon létre nézetet, amely listázza az utak minden attribútumát, 
--kiegészítve az indulási és érkezési kiköt? helység és országnevével.
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
--Hozzon létre nézetet, amely listázza, hogy az egyes hajótípusokhoz tartozó hajók 
--összesen hány utat teljesítettek! 
--A listában szerepeljen a hajótípusok azonosítója, 
--neve és a teljesített utak száma! 
--Azokat a hajótípusokat is tüntesse fel az eredményben, 
--amelyekhez egyetlen hajó sem tartozik, 
--és azokat is, amelyekhez tartozó hajók egyetlen utat sem teljesítettek! 
--A lista legyen a hajótípus neve szerint rendezett!
CREATE VIEW TIPUSOK AS
SELECT hajo_tipus_id,tip.nev,COUNT(ut_id) utak
FROM HAJO.S_HAJO_TIPUS tip
LEFT OUTER JOIN
HAJO.S_HAJO haj
ON tip.hajo_tipus_id=haj.hajo_tipus
LEFT OUTER JOIN
HAJO.S_UT ut
ON haj.hajo_id=ut.hajo
GROUP BY hajo_tipus_id,tip.nev
ORDER BY tip.nev;

--76.
--Hozzon létre nézetet, amely listázza, hogy az egyes kiköt?knek hány telefonszáma van. 
--A lista tartalmazza a kiköt?k azonosítóját,
--a helység nevét és oszágát és a telefonok számát. 
--Azokat is tüntessük fel, aminek nincs telefonszáma
CREATE VIEW TEL AS
SELECT kikot.kikoto_id,helysegnev,orszag,COUNT(telefon) telszam
FROM HAJO.S_KIKOTO_TELEFON tel
RIGHT OUTER JOIN
HAJO.S_KIKOTO kikot
ON tel.kikoto_id=kikot.kikoto_id
INNER JOIN
HAJO.S_HELYSEG helys
ON kikot.helyseg=helys.helyseg_id
GROUP BY kikot.kikoto_id,helysegnev,orszag;

--Hozzon létre nézetet, amely listázza az ügyfeleink vezeték- és keresztnevét, 
--a származási helységük nevét és országát, valamint a megrendeléseik számát!
--Azok az ügyfelek is szerepeljenek az eredményben, akiknek nem ismert a származása 
--és azok is, akik sosem adtak le megrendelést
SELECT CONCAT(vezeteknev,CONCAT(' ',keresztnev)) AS "Teljes név", helysegnev, orszag,COUNT(megrendeles_id)
FROM HAJO.S_HELYSEG helys
RIGHT OUTER JOIN
HAJO.S_UGYFEL ugyf
ON helys.helyseg_id=ugyf.helyseg
LEFT OUTER JOIN
HAJO.S_MEGRENDELES rend
ON ugyf.ugyfel_id=rend.ugyfel
GROUP BY CONCAT(vezeteknev,CONCAT(' ',keresztnev)), helysegnev, orszag;



--81. 
--Hozzon létre nézetet, amely megadja a legnagyobb forgalmú kiköt?(k) azonosítóját, 
--helységnevét és országát! A legnagyobb
--forgalmú kiköt? az, amelyik a legtöbb út indulási vagy érkezési kiköt?je volt.
SELECT indulasi_kikoto,helysegnev,orszag
FROM HAJO.S_UT ut
INNER JOIN
HAJO.S_KIKOTO kikot
ON ut.indulasi_kikoto=kikot.kikoto_id
INNER JOIN
HAJO.S_HELYSEG helys
ON kikot.helyseg=helys.helyseg_id
WHERE indulasi_kikoto IN(
SELECT indulasi_kikoto
FROM HAJO.S_UT 
GROUP BY indulasi_kikoto
ORDER BY COUNT(indulasi_kikoto) DESC
FETCH FIRST ROW WITH TIES)
GROUP BY indulasi_kikoto,helysegnev,orszag
UNION
SELECT erkezesi_kikoto,helysegnev,orszag
FROM HAJO.S_UT ut
INNER JOIN
HAJO.S_KIKOTO kikot
ON ut.erkezesi_kikoto=kikot.kikoto_id
INNER JOIN
HAJO.S_HELYSEG helys
ON kikot.helyseg=helys.helyseg_id
WHERE erkezesi_kikoto IN(
SELECT erkezesi_kikoto
FROM HAJO.S_UT 
GROUP BY erkezesi_kikoto
ORDER BY COUNT(erkezesi_kikoto) DESC
FETCH FIRST ROW WITH TIES)
GROUP BY erkezesi_kikoto,helysegnev,orszag;

--82
--Hozzon létre nézetet, amely megadja annak a hajónak az azonosítóját és nevét, 
--amelyik a legnagyobb összsúlyt szállította a 2021 májusában induló utakon! 
--Ha több ilyen hajó is van, akkor mindegyiket listázza!

SELECT hajo_id,nev,COUNT(rend.kontener)*2+SUM(rakomanysuly)
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
WHERE to_char(indulasi_ido,'yyyy.mm.')='2021.05.'
GROUP BY hajo_id,nev
ORDER BY COUNT(rend.kontener)*2+SUM(rakomanysuly) DESC
FETCH FIRST ROW WITH TIES;

--83
--Hozzon létre nézetet, ami megadja a kiköt? azonosítóját, helységnevét, 
--országát, amelykb?l kiinduló utakon
--szállított konténerek összesúlya  a legnagyobb. 
--Ha több ilyen van, akkor mindegyiket listázza

SELECT indulasi_kikoto,helysegnev,orszag
FROM HAJO.S_HELYSEG helys
INNER JOIN
HAJO.S_KIKOTO kikot
ON helys.helyseg_id=kikot.helyseg
INNER JOIN
HAJO.S_UT ut
ON kikot.kikoto_id=indulasi_kikoto
INNER JOIN
HAJO.S_SZALLIT sza
ON ut.ut_id=sza.ut
GROUP BY indulasi_kikoto,helysegnev,orszag
ORDER BY COUNT(kontener)*2 DESC
FETCH FIRST ROW WITH TIES;

--84
----Listázza azokat a megrendeléseknek az adatit, amelyeket egyetlen hajó teljesített úgy, 
--hogy több helyen is megállt(azaz több úttal)
--EGY HAJÓ:
SELECT megrendeles
FROM HAJO.S_SZALLIT sza
INNER JOIN
HAJO.S_UT ut
ON sza.ut=ut.ut_id
GROUP BY megrendeles
HAVING COUNT(DISTINCT(hajo))=1;

--TÖBB ÚT
SELECT megrendeles
FROM HAJO.S_SZALLIT sza
INNER JOIN
HAJO.S_UT ut
ON sza.ut=ut.ut_id
GROUP BY megrendeles
HAVING COUNT(ut_id)>1;

SELECT *
FROM HAJO.S_MEGRENDELES
WHERE megrendeles_id IN(SELECT megrendeles
                    FROM HAJO.S_SZALLIT sza
                    INNER JOIN
                    HAJO.S_UT ut
                    ON sza.ut=ut.ut_id
                    GROUP BY megrendeles
                    HAVING COUNT(ut_id)>1)
AND megrendeles_id IN(SELECT megrendeles
                    FROM HAJO.S_SZALLIT sza
                    INNER JOIN
                    HAJO.S_UT ut
                    ON sza.ut=ut.ut_id
                    GROUP BY megrendeles
                    HAVING COUNT(DISTINCT(hajo))=1);                    

--85.
--Hozzon létre nézetet amely megadja azoknak az utaknak az adatait, 
--amelyeken a rakomány súlya (a szállított konténerek és a
--rakományaik összsúlya) meghaladja  a hajó maximális súlyterhelését! 
--Az út adatai mellett tüntesse fel a hajó nevét és maximális súlyterhelését
--Valamint a rakomány súlyát is
SELECT ut_id,haj.nev,max_sulyterheles,COUNT(rend.kontener)*2+SUM(rakomanysuly)
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
GROUP BY ut_id,haj.nev,max_sulyterheles
HAVING COUNT(rend.kontener)*2+SUM(rakomanysuly)>max_sulyterheles;

--86. 
--Hozzon létre nézetet amely megadja azoknak az utaknak az adatait, amelyeken a rakomány súlya (a szállított konténerek és a
--rakományaik összsúlya) nem haladja meg a hajó maximális súlyterhelésének a felét! Az út adatai mellett tüntesse fel a hajó nevét és maximális súlyterhelését
--Valamint a rakomány súlyát is
SELECT ut_id,haj.nev,max_sulyterheles,COUNT(rend.kontener)*2+SUM(rakomanysuly)
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
GROUP BY ut_id,haj.nev,max_sulyterheles
HAVING COUNT(rend.kontener)*2+SUM(rakomanysuly)<max_sulyterheles/2;

--88.
--Hozzon létre nézetet, amely megadja annak a megrendelésnek az adatait, 
--amelynek a teljesítéséhez a legtöbb útra volt szükség! Ha több
--Ilyen megrendelés is van, akkor mindegyiket listázza!
SELECT megrendeles_id,COUNT(ut)
FROM HAJO.S_MEGRENDELES rend
INNER JOIN
HAJO.S_HOZZARENDEL rendel
ON rend.megrendeles_id=rendel.megrendeles
INNER JOIN
HAJO.S_SZALLIT sza
ON rendel.megrendeles=sza.megrendeles
AND rendel.kontener=sza.kontener
GROUP BY megrendeles_id
ORDER BY COUNT(ut) DESC
FETCH FIRST ROW WITH TIES;

--92.
--Adjon hivatkozási jogosultságot panovicsnak az ön s_ut táblájának indulasi_ido é
--s hajo oszlopaiba
GRANT REFERENCES (indulasi_ido,hajo) ON S_UT TO panovics;

--93.
--Vonja vissza sortörlési és módosítási jogosultságot a panovics nevű felhasználótól
--az s_kikoto táblájáról!
REVOKE DELETE,UPDATE ON S_KIKOTO FROM panovics;

--94
--Adjon módosítási jogosultságot a 'panovics' felhasználónak az 
--ön s_ugyfel táblájának vezeték és keresztnév oszlopaira
GRANT UPDATE (vezeteknev,keresztnev) ON S_UGYFEL TO panovics;

--95
--Adjon beszúrási jogosultságot minden felhasználónak 
--az ön 's_kikoto' táblájának a 'kikoto_id' és 'helyseg' oszlopaira!
GRANT INSERT (kikoto_id,helyseg) ON S_KIKOTO TO PUBLIC;

--96
--Vonja vissza a lekérdezési jogosultságot 
--a 'panovics' felhasználótól az ön s_ut táblájából
GRANT SELECT ON S_UT TO panovics;
REVOKE SELECT ON S_UT FROM panovics;

--98
--Vonja vissza a törlési és módosítási jogosultságot a 'panovics' nev? 
--felhasználótól az ön s_kikoto táblájáról
GRANT DELETE,UPDATE ON S_KIKOTO TO panovics;
REVOKE DELETE,UPDATE ON S_KIKOTO FROM panovics;

--99
--Vonja vissza a törlési jogot 'panovics' felhasználótól az ön s_orszag táblájáról
GRANT DELETE ON S_ORSZAG TO panovics;
REVOKE DELETE ON S_ORSZAG FROM panovics;

--100
--Vonja vissza a beszúrási jogosultságot minden felhasználótól az ön s_megrendelés táblájáról
REVOKE INSERT ON S_MEGRENDELES FROM PUBLIC;
                    
                                      
                                                                                                       
                                                
