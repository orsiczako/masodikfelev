/*1.Listázza ki a 15 tonnát meghaladó rakománnyal rendelkez? konténerek
teljes azonosítóját, valamint a rakománysúlyt is 2 tizedesjegyre kerekítve! Rendezze az eredményt a pontos rakománysúly szerint növekv? sorrendbe!*/
SELECT megrendeles,kontener,round(rakomanysuly,2)
FROM HAJO.S_HOZZARENDEL
WHERE rakomanysuly>=15
ORDER BY rakomanysuly ASC;

/*2.Listázza ki a kis méret? mobil darukkal rendelkez? kiköt?k adatait! Ezeknek a kiköt?knek a leírásában megtalálható a 'kiköt?méret: kicsi', illetve
a 'mobil daruk' sztring (nem feltétlenül ebben a sorrendben)*/
SELECT *
FROM HAJO.S_KIKOTO
WHERE leiras LIKE ('%kiköt?méret: kicsi%')AND leiras LIKE '%mobil daruk%';

/*3.Listázza ki azoknak az utaknak az adatait, dátummal együtt, amelyek nem egész percben indultak! 
Rendezze az eredményt az indulási id? szerint növekv? sorrendbe!*/
SELECT to_char(indulasi_ido,'yyyy.mm.dd.hh24:mi:ss'),to_char(erkezesi_ido,'yyyy.mm.dd.hh24:mi:ss'),ut_id,indulasi_kikoto,erkezesi_kikoto,hajo
FROM HAJO.S_UT 
WHERE to_char(indulasi_ido,'yyyy.mm.dd.hh24:mi:ss') NOT LIKE ('____.__.__.__:00:__');

/*4.Hány 500 tonnánál nagyobb maximális súlyterhelés? hajó tartozik az egyes hajótípusokhoz?
A hajótípusokat az azonosítójukkal adja meg!*/

SELECT tip.nev,COUNT(hajo_id)
FROM HAJO.S_HAJO haj
INNER JOIN 
HAJO.S_HAJO_TIPUS tip
ON haj.hajo_tipus=tip.hajo_tipus_id
WHERE max_sulyterheles>500
GROUP BY tip.nev;

/*5.Mely hónapokban (év,hónap) adtak le legalább 6 megrendelést? A lista legyen id?rendben!*/
SELECT to_char(megrendeles_datuma,'yyyy.mm'),COUNT(megrendeles_datuma)
FROM HAJO.S_MEGRENDELES 
GROUP BY to_char(megrendeles_datuma,'yyyy.mm')
HAVING COUNT(megrendeles_datuma)>=6;

/*6.Listázza ki a szíriai ügyfelek teljes nevét és telefonszámát!*/
SELECT CONCAT(vezeteknev,CONCAT(' ',keresztnev)) AS "Teljes név", telefon
FROM HAJO.S_UGYFEL ugyf
INNER JOIN
HAJO.S_HELYSEG helys
ON ugyf.helyseg=helys.helyseg_id
WHERE orszag='Szíria';

/*7.Mennyi az egyes hajótípusokhoz tartozó hajók legkisebb nettó súlya?
A hajótípusokat nevükkel adja meg! Csak azokat a hajótípusokat listázza, amelyekhez van hajónk!*/
SELECT tip.nev,netto_suly
FROM HAJO.S_HAJO_TIPUS tip
INNER JOIN
HAJO.S_HAJO haj
ON tip.hajo_tipus_id=haj.hajo_tipus
GROUP BY tip.nev,netto_suly
HAVING netto_suly IN (SELECT MIN(netto_suly)
                        FROM HAJO.S_HAJO
                        GROUP BY hajo_tipus);
                        
/*8.Melyik ázsiai településeken található kiköt?? Az eredményben az ország és helységneveket adja meg,országnév azon belül helységnév szerint rendezve*/
SELECT helys.orszag,helys.helysegnev
FROM HAJO.S_ORSZAG orsz
LEFT OUTER JOIN 
HAJO.S_HELYSEG helys
ON orsz.orszag=helys.orszag
WHERE foldresz='Ázsia'
AND helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_KIKOTO)
ORDER BY helys.orszag,helys.helysegnev;

/*9.Melyik hajó indult útra utoljára? Listázza ki ezekneka hajóknak a nevét, azonosítóját, az indulási és érkezési kiköt?k azonosítóját, valamint indulás 
dátumát és idejét!*/
SELECT to_char(indulasi_ido,'yyyy.mm.dd.hh24:mi:ss'),nev,hajo_id,indulasi_kikoto,erkezesi_kikoto
FROM HAJO.S_UT ut
INNER JOIN
HAJO.S_HAJO haj
ON ut.hajo=haj.hajo_id
WHERE indulasi_ido IN (SELECT MAX(indulasi_ido)
                        FROM HAJO.S_HAJO);
                        
                        
/*10.Az 'It_Cat' azonosítójú kiköt?b?l induló legkorábbi út melyik kiköt?be tartottak? Adja meg az érkezési kiköt? azonosítóját valamint a helységénel és országánal
a nevét*/
SELECT kikoto_id,orszag,helysegnev
FROM HAJO.S_UT ut
INNER JOIN
HAJO.S_KIKOTO kikot
ON ut.indulasi_kikoto=kikot.kikoto_id
INNER JOIN 
HAJO.S_HELYSEG helys
ON kikot.helyseg=helys.helyseg_id
WHERE indulasi_ido IN (SELECT MIN(indulasi_ido)
                        FROM HAJO.S_UT
                        WHERE indulasi_kikoto='It_Cat')





                        












