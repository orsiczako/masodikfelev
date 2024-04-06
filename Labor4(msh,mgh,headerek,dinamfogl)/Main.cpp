#include "Labor4.h"
#include <cstdlib>
#include <iostream>

int main(int argc, char* argv[])
{
    int meret = 0;
    meret = beker();

    int* tomb = nullptr;
    lefoglal(tomb, meret);
    feltolt(tomb, meret);

    if (tomb) delete[] tomb;

    char* masik = nullptr;
    fel1(masik);
    int mmeret = 128;
    fel2(masik, mmeret);
    fel3(masik, mmeret);
    char szo = 'b';
    std::cout << fel4(szo) << std::endl;
    char* tomb2=fel2(masik,mmeret);
    fel5(tomb2,mmeret);

    return 0;
}

/*
Bevezet� feladat.
1. K�sz�tsenek egy f�ggv�nyt, amely bek�r a felhaszn�l�t�l 
   egy 100 �s 500 k�z�tti �rt�ket!
2. K�sz�tsenek egy elj�r�st, amely lefoglal egy eg�sz t�pus� 
   t�mb�t a fent beolvasott m�retet felhaszn�lva!
3. K�sz�tsenek egy elj�r�st, amely felt�lti 10 �s 100 
   k�z�tti v�letlen �rt�kekkel a kor�bban lefoglalt t�mbot!
*/

/*
1. K�sz�tsenek egy elj�r�st, amely egy 128 m�ret� karakter 
   t�pus� t�mb�t fog lefoglalni dinamikusan!
2. K�sz�tsenek egy elj�r�st, amely a t�mb els� 20 p�ratlan elem�t
   mag�nhangz�kkal, �s minden els� 20 p�ros elem�t pedig 
   m�ssalhangz�kkal fogja felt�lteni!
3. K�sz�tsenek egy elj�r�st, amely a t�mb m�sodik fel�t
   v�letlenszer� karakterekkel t�lti fel!
4. K�sz�tsenek egy f�ggv�nyt, amely megsz�molja 
   a m�ssalhangz�k sz�m�t!
5. K�sz�tsenek egy elj�r�st, amely minden mag�nhangz�t
   a m�sodik 128 m�ret� dinamikusan lefoglalt t�mbbe fog �tm�solni!
6. K�sz�tsenek egy elj�r�st, amely rendezi n�vekv� sorrendbe
   a kor�bban �tm�solt m�ssalhangz�kat!

*/
