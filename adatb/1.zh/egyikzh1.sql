--7. **Mennyi egyes konténereknek a maximum súlya?

SELECT kontener, MAX(rakomanysuly) AS maximum_suly
FROM hajo.s_hozzarendel
GROUP BY kontener
ORDER BY kontener;


/*Listázza ki azoknak az ügyfeleknek az azonosítóját és teljes nevét, akik adtak már fel olaszországi kiköt?b?l induló szállításra
vonatkozó megrendelést! Egy ügyfél csak egyszer szerepeljen az eredményben!*/
SELECT ugyfel_id,vezeteknev,keresztnev
FROM HAJO.S_UGYFEL ugyf
INNER JOIN
HAJO.S_HELYSEG h
ON ugyf.helyseg=h.helyseg_id
WHERE orszag='Olaszország'
GROUP BY ugyfel_id,vezeteknev,keresztnev;

/*Listázza ki abc sorrendben azoknak a kiköt?vel rendelkez? helységeknek az azonosítóját,országát és nevét, ahonnan legalább egy ügyfelünk is származik!
Egy helység csak egyszer szerepeljen! A lista legyen országnév, azon belül helységnév szerint rendezve!*/
SELECT helyseg_id,orszag,helysegnev
FROM HAJO.S_HELYSEG 
WHERE helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_KIKOTO)
AND helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_UGYFEL)
GROUP BY helyseg_id,helysegnev,orszag
ORDER BY orszag,helysegnev;

/*Az 'It_Cat' azonosítójú kiköt?b?l induló utak közül melyik négyen szállították a legkevesebb konténert? Csak azokat az utakat vegye figyelembe,
amelyeken legalább egy konténert szállítottak! Az utakat az azonosítójukkal adja meg és tüntesse fel a szállított konténerek számát!*/
SELECT ut_id,COUNT(ut)
FROM HAJO.S_UT ut
INNER JOIN 
HAJO.S_SZALLIT sza
ON ut.ut_id=sza.ut
WHERE ut_id IN(SELECT ut
                FROM HAJO.S_SZALLIT
                GROUP BY ut
                ORDER BY COUNT(*)
                FETCH FIRST 4 ROWS WITH TIES)
GROUP BY ut_id,ut;

/*Listázza ki a 7 és 14 tonna közé es? rakománnyal rendelkez? konténerek teljes azonosítóját, valamint a rakománysúly t is 2 tozedesjegyre kerekítve
Rendezze az eredményt a pontos rakománysúly szerint csökken? sorrendbe!*/
SELECT kontener,ROUND(rakomanysuly,2)
FROM HAJO.S_HOZZARENDEL
WHERE rakomanysuly BETWEEN 7 AND 14
ORDER BY rakomanysuly DESC;

/*Listázza ki azoknak az ügyfeleknek a teljes nevét vessz?vel és szóközzel elválasztva akikr?l nem tudjuk melyik településen laknak 
de azt igen hogy a keresztnevük 5 karakterb?l áll! a LISTA LEGYEN VEZETÉKNÉV ALAPJÁN CSÖKKEN? SORRENDBE RENDEZVE/*/
SELECT CONCAT(vezeteknev,CONCAT(', ',keresztnev)) AS "Teljes név",helyseg
FROM HAJO.S_UGYFEL 
WHERE helyseg IS NULL
AND LENGTH(keresztnev)=5
ORDER BY vezeteknev DESC;

/*Listázza ki a 2021 februárjában és áprilisában leadott megrendelések dátumát és id?pontját, az indulási
és érkezési kiköt?k azonosítóját, valamint a fizetett összeget, ez utóbbi szerint csökken? sorrendben!*/
SELECT to_char(megrendeles_datuma,'yyyy.mm.dd.hh24:mi:ss'),indulasi_kikoto,erkezesi_kikoto,fizetett_osszeg
FROM HAJO.S_MEGRENDELES
WHERE to_char(megrendeles_datuma,'yyyy')=2021
AND to_char(megrendeles_datuma,'mm') IN(02,04)
ORDER BY fizetett_osszeg DESC;

/*Mekkora az egyes földrészek területe(országok területének összege)? Rendezze az eredményt a területek csökken? sorrendjébe!
A "nem ismert földrész" ne jelenjen meg!*/
SELECT SUM(terulet),foldresz
FROM HAJO.S_ORSZAG
WHERE foldresz IS NOT NULL
GROUP BY foldresz
ORDER BY SUM(terulet) DESC;

/*Mely ügyfelek rendeltek összesen legalább 10 millió értékben és mekkora ez az érték? Az ügyfeleket
az azonosítójukkal adja meg*/
SELECT ugyfel_id,fizetett_osszeg
FROM HAJO.S_UGYFEL ugyf
INNER JOIN
HAJO.S_MEGRENDELES rend
ON ugyf.ugyfel_id=rend.ugyfel
WHERE fizetett_osszeg>10000000;

/*Listázza ki azoknak a hajótípusoknak a nevét, amilyen típusó hajókkal rendelkezik a cégünk! Egy típusnév
csak egyszer szerepeljen az eredményben!*/
SELECT nev
FROM HAJO.S_HAJO_TIPUS
WHERE hajo_tipus_id IN (SELECT hajo_tipus
                        FROM HAJO.S_HAJO);
                    
/*Adja meg, hogy egyes hónapokban (év,hónap)hány olyan megrednelést adtak le, amely mobil darukkal rendelkez? kiköt?be irányult! Rendezze az eredményt darabszám
szerint csökken? sorrendbe!*/
SELECT to_char(megrendeles_datuma,'yyyy.mm.'),COUNT(*)
FROM HAJO.S_MEGRENDELES rend
LEFT OUTER JOIN
HAJO.S_KIKOTO kikot
ON rend.indulasi_kikoto=kikot.kikoto_id
WHERE leiras LIKE '%mobil daruk%'
GROUP BY to_char(megrendeles_datuma,'yyyy.mm.')
ORDER BY COUNT(*) DESC;

/*Listázza ki növekv? sorrendben az 'Asterix' nev? hajó által az 'It_Cat' azonosítójú kiköt?be szállított megrendelések azonosítóit mindegyiket csak
egyszer*/
SELECT megrendeles
FROM HAJO.S_SZALLIT sza
INNER JOIN
HAJO.S_UT ut
ON sza.ut=ut.ut_id
INNER JOIN
HAJO.S_HAJO haj
On ut.hajo=haj.hajo_id
WHERE erkezesi_kikoto='It_Cat'
AND nev='Asterix'
GROUP BY megrendeles;

/*Írja ki
az utoljára leadott megrendeléseknek az azonosítóját, dátumát és idejét, az indulási és érkezési kiköt?k azonosítóját, és ügyfél teljes nevét*/
SELECT megrendeles_id,to_char(megrendeles_datuma,'yyyy.mm.dd.hh24:mi:ss'),indulasi_kikoto,erkezesi_kikoto,
CONCAT(vezeteknev,CONCAT(' ',keresztnev)) AS "Teljes név"
FROM HAJO.S_MEGRENDELES rend
LEFT OUTER JOIN 
HAJO.S_UGYFEL ugyf
ON rend.ugyfel=ugyf.ugyfel_id
WHERE megrendeles_datuma IN(SELECT megrendeles_datuma
                            FROM HAJO.S_MEGRENDELES
                            ORDER BY megrendeles_datuma ASC
                            FETCH FIRST ROW WITH TIES);