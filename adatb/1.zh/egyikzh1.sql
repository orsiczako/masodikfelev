--7. **Mennyi egyes kont�nereknek a maximum s�lya?

SELECT kontener, MAX(rakomanysuly) AS maximum_suly
FROM hajo.s_hozzarendel
GROUP BY kontener
ORDER BY kontener;


/*List�zza ki azoknak az �gyfeleknek az azonos�t�j�t �s teljes nev�t, akik adtak m�r fel olaszorsz�gi kik�t?b?l indul� sz�ll�t�sra
vonatkoz� megrendel�st! Egy �gyf�l csak egyszer szerepeljen az eredm�nyben!*/
SELECT ugyfel_id,vezeteknev,keresztnev
FROM HAJO.S_UGYFEL ugyf
INNER JOIN
HAJO.S_HELYSEG h
ON ugyf.helyseg=h.helyseg_id
WHERE orszag='Olaszorsz�g'
GROUP BY ugyfel_id,vezeteknev,keresztnev;

/*List�zza ki abc sorrendben azoknak a kik�t?vel rendelkez? helys�geknek az azonos�t�j�t,orsz�g�t �s nev�t, ahonnan legal�bb egy �gyfel�nk is sz�rmazik!
Egy helys�g csak egyszer szerepeljen! A lista legyen orsz�gn�v, azon bel�l helys�gn�v szerint rendezve!*/
SELECT helyseg_id,orszag,helysegnev
FROM HAJO.S_HELYSEG 
WHERE helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_KIKOTO)
AND helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_UGYFEL)
GROUP BY helyseg_id,helysegnev,orszag
ORDER BY orszag,helysegnev;

/*Az 'It_Cat' azonos�t�j� kik�t?b?l indul� utak k�z�l melyik n�gyen sz�ll�tott�k a legkevesebb kont�nert? Csak azokat az utakat vegye figyelembe,
amelyeken legal�bb egy kont�nert sz�ll�tottak! Az utakat az azonos�t�jukkal adja meg �s t�ntesse fel a sz�ll�tott kont�nerek sz�m�t!*/
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

/*List�zza ki a 7 �s 14 tonna k�z� es? rakom�nnyal rendelkez? kont�nerek teljes azonos�t�j�t, valamint a rakom�nys�ly t is 2 tozedesjegyre kerek�tve
Rendezze az eredm�nyt a pontos rakom�nys�ly szerint cs�kken? sorrendbe!*/
SELECT kontener,ROUND(rakomanysuly,2)
FROM HAJO.S_HOZZARENDEL
WHERE rakomanysuly BETWEEN 7 AND 14
ORDER BY rakomanysuly DESC;

/*List�zza ki azoknak az �gyfeleknek a teljes nev�t vessz?vel �s sz�k�zzel elv�lasztva akikr?l nem tudjuk melyik telep�l�sen laknak 
de azt igen hogy a keresztnev�k 5 karakterb?l �ll! a LISTA LEGYEN VEZET�KN�V ALAPJ�N CS�KKEN? SORRENDBE RENDEZVE/*/
SELECT CONCAT(vezeteknev,CONCAT(', ',keresztnev)) AS "Teljes n�v",helyseg
FROM HAJO.S_UGYFEL 
WHERE helyseg IS NULL
AND LENGTH(keresztnev)=5
ORDER BY vezeteknev DESC;

/*List�zza ki a 2021 febru�rj�ban �s �prilis�ban leadott megrendel�sek d�tum�t �s id?pontj�t, az indul�si
�s �rkez�si kik�t?k azonos�t�j�t, valamint a fizetett �sszeget, ez ut�bbi szerint cs�kken? sorrendben!*/
SELECT to_char(megrendeles_datuma,'yyyy.mm.dd.hh24:mi:ss'),indulasi_kikoto,erkezesi_kikoto,fizetett_osszeg
FROM HAJO.S_MEGRENDELES
WHERE to_char(megrendeles_datuma,'yyyy')=2021
AND to_char(megrendeles_datuma,'mm') IN(02,04)
ORDER BY fizetett_osszeg DESC;

/*Mekkora az egyes f�ldr�szek ter�lete(orsz�gok ter�let�nek �sszege)? Rendezze az eredm�nyt a ter�letek cs�kken? sorrendj�be!
A "nem ismert f�ldr�sz" ne jelenjen meg!*/
SELECT SUM(terulet),foldresz
FROM HAJO.S_ORSZAG
WHERE foldresz IS NOT NULL
GROUP BY foldresz
ORDER BY SUM(terulet) DESC;

/*Mely �gyfelek rendeltek �sszesen legal�bb 10 milli� �rt�kben �s mekkora ez az �rt�k? Az �gyfeleket
az azonos�t�jukkal adja meg*/
SELECT ugyfel_id,fizetett_osszeg
FROM HAJO.S_UGYFEL ugyf
INNER JOIN
HAJO.S_MEGRENDELES rend
ON ugyf.ugyfel_id=rend.ugyfel
WHERE fizetett_osszeg>10000000;

/*List�zza ki azoknak a haj�t�pusoknak a nev�t, amilyen t�pus� haj�kkal rendelkezik a c�g�nk! Egy t�pusn�v
csak egyszer szerepeljen az eredm�nyben!*/
SELECT nev
FROM HAJO.S_HAJO_TIPUS
WHERE hajo_tipus_id IN (SELECT hajo_tipus
                        FROM HAJO.S_HAJO);
                    
/*Adja meg, hogy egyes h�napokban (�v,h�nap)h�ny olyan megrednel�st adtak le, amely mobil darukkal rendelkez? kik�t?be ir�nyult! Rendezze az eredm�nyt darabsz�m
szerint cs�kken? sorrendbe!*/
SELECT to_char(megrendeles_datuma,'yyyy.mm.'),COUNT(*)
FROM HAJO.S_MEGRENDELES rend
LEFT OUTER JOIN
HAJO.S_KIKOTO kikot
ON rend.indulasi_kikoto=kikot.kikoto_id
WHERE leiras LIKE '%mobil daruk%'
GROUP BY to_char(megrendeles_datuma,'yyyy.mm.')
ORDER BY COUNT(*) DESC;

/*List�zza ki n�vekv? sorrendben az 'Asterix' nev? haj� �ltal az 'It_Cat' azonos�t�j� kik�t?be sz�ll�tott megrendel�sek azonos�t�it mindegyiket csak
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

/*�rja ki
az utolj�ra leadott megrendel�seknek az azonos�t�j�t, d�tum�t �s idej�t, az indul�si �s �rkez�si kik�t?k azonos�t�j�t, �s �gyf�l teljes nev�t*/
SELECT megrendeles_id,to_char(megrendeles_datuma,'yyyy.mm.dd.hh24:mi:ss'),indulasi_kikoto,erkezesi_kikoto,
CONCAT(vezeteknev,CONCAT(' ',keresztnev)) AS "Teljes n�v"
FROM HAJO.S_MEGRENDELES rend
LEFT OUTER JOIN 
HAJO.S_UGYFEL ugyf
ON rend.ugyfel=ugyf.ugyfel_id
WHERE megrendeles_datuma IN(SELECT megrendeles_datuma
                            FROM HAJO.S_MEGRENDELES
                            ORDER BY megrendeles_datuma ASC
                            FETCH FIRST ROW WITH TIES);