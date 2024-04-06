/*1.List�zza ki a 15 tonn�t meghalad� rakom�nnyal rendelkez? kont�nerek
teljes azonos�t�j�t, valamint a rakom�nys�lyt is 2 tizedesjegyre kerek�tve! Rendezze az eredm�nyt a pontos rakom�nys�ly szerint n�vekv? sorrendbe!*/
SELECT megrendeles,kontener,round(rakomanysuly,2)
FROM HAJO.S_HOZZARENDEL
WHERE rakomanysuly>=15
ORDER BY rakomanysuly ASC;

/*2.List�zza ki a kis m�ret? mobil darukkal rendelkez? kik�t?k adatait! Ezeknek a kik�t?knek a le�r�s�ban megtal�lhat� a 'kik�t?m�ret: kicsi', illetve
a 'mobil daruk' sztring (nem felt�tlen�l ebben a sorrendben)*/
SELECT *
FROM HAJO.S_KIKOTO
WHERE leiras LIKE ('%kik�t?m�ret: kicsi%')AND leiras LIKE '%mobil daruk%';

/*3.List�zza ki azoknak az utaknak az adatait, d�tummal egy�tt, amelyek nem eg�sz percben indultak! 
Rendezze az eredm�nyt az indul�si id? szerint n�vekv? sorrendbe!*/
SELECT to_char(indulasi_ido,'yyyy.mm.dd.hh24:mi:ss'),to_char(erkezesi_ido,'yyyy.mm.dd.hh24:mi:ss'),ut_id,indulasi_kikoto,erkezesi_kikoto,hajo
FROM HAJO.S_UT 
WHERE to_char(indulasi_ido,'yyyy.mm.dd.hh24:mi:ss') NOT LIKE ('____.__.__.__:00:__');

/*4.H�ny 500 tonn�n�l nagyobb maxim�lis s�lyterhel�s? haj� tartozik az egyes haj�t�pusokhoz?
A haj�t�pusokat az azonos�t�jukkal adja meg!*/

SELECT tip.nev,COUNT(hajo_id)
FROM HAJO.S_HAJO haj
INNER JOIN 
HAJO.S_HAJO_TIPUS tip
ON haj.hajo_tipus=tip.hajo_tipus_id
WHERE max_sulyterheles>500
GROUP BY tip.nev;

/*5.Mely h�napokban (�v,h�nap) adtak le legal�bb 6 megrendel�st? A lista legyen id?rendben!*/
SELECT to_char(megrendeles_datuma,'yyyy.mm'),COUNT(megrendeles_datuma)
FROM HAJO.S_MEGRENDELES 
GROUP BY to_char(megrendeles_datuma,'yyyy.mm')
HAVING COUNT(megrendeles_datuma)>=6;

/*6.List�zza ki a sz�riai �gyfelek teljes nev�t �s telefonsz�m�t!*/
SELECT CONCAT(vezeteknev,CONCAT(' ',keresztnev)) AS "Teljes n�v", telefon
FROM HAJO.S_UGYFEL ugyf
INNER JOIN
HAJO.S_HELYSEG helys
ON ugyf.helyseg=helys.helyseg_id
WHERE orszag='Sz�ria';

/*7.Mennyi az egyes haj�t�pusokhoz tartoz� haj�k legkisebb nett� s�lya?
A haj�t�pusokat nev�kkel adja meg! Csak azokat a haj�t�pusokat list�zza, amelyekhez van haj�nk!*/
SELECT tip.nev,netto_suly
FROM HAJO.S_HAJO_TIPUS tip
INNER JOIN
HAJO.S_HAJO haj
ON tip.hajo_tipus_id=haj.hajo_tipus
GROUP BY tip.nev,netto_suly
HAVING netto_suly IN (SELECT MIN(netto_suly)
                        FROM HAJO.S_HAJO
                        GROUP BY hajo_tipus);
                        
/*8.Melyik �zsiai telep�l�seken tal�lhat� kik�t?? Az eredm�nyben az orsz�g �s helys�gneveket adja meg,orsz�gn�v azon bel�l helys�gn�v szerint rendezve*/
SELECT helys.orszag,helys.helysegnev
FROM HAJO.S_ORSZAG orsz
LEFT OUTER JOIN 
HAJO.S_HELYSEG helys
ON orsz.orszag=helys.orszag
WHERE foldresz='�zsia'
AND helyseg_id IN(SELECT helyseg
                    FROM HAJO.S_KIKOTO)
ORDER BY helys.orszag,helys.helysegnev;

/*9.Melyik haj� indult �tra utolj�ra? List�zza ki ezekneka haj�knak a nev�t, azonos�t�j�t, az indul�si �s �rkez�si kik�t?k azonos�t�j�t, valamint indul�s 
d�tum�t �s idej�t!*/
SELECT to_char(indulasi_ido,'yyyy.mm.dd.hh24:mi:ss'),nev,hajo_id,indulasi_kikoto,erkezesi_kikoto
FROM HAJO.S_UT ut
INNER JOIN
HAJO.S_HAJO haj
ON ut.hajo=haj.hajo_id
WHERE indulasi_ido IN (SELECT MAX(indulasi_ido)
                        FROM HAJO.S_HAJO);
                        
                        
/*10.Az 'It_Cat' azonos�t�j� kik�t?b?l indul� legkor�bbi �t melyik kik�t?be tartottak? Adja meg az �rkez�si kik�t? azonos�t�j�t valamint a helys�g�nel �s orsz�g�nal
a nev�t*/
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





                        












