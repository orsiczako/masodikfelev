#include<iostream>

using namespace std;

int main(int argc, char* argv[])
{
    /*
	K�sz�tsenek egy f�ggv�nyt, amely k�t stringet kap meg
	param�terk�nt, �s �sszehasonl�tja azokat!
	A fv t�rjen vissza igaz �rt�kkel, hogy ha a tartalmuk
	megegyezik!
    */
   char egyik;
   char masik;
   const char e1[]='valami';
   const char e2[]='nem tom';
   hossz1=szohossz(egyik);
   hossz2=szohossz(masik);


}

//először állapítsuk meg a hosszát a szónak
int szohossz(char szo)
{
    int ossz;
    
    while (szo[ossz] != '\0')
	{
		ossz+= 1;
	} 
    return ossz;
}
 /*1. �rjanak egy f�ggv�nyt, amely k�t stringet kap meg
	a param�terk�nt m�retekkel egy�tt, �s visszat�r
	igaz �rt�kkel, hogy ha a m�sodik string megtal�lhat�
	az els�ben.*/
bool hasonlit(char egyik, char masik)
{
    bool igaz=true;
    if(szohossz(egyik)!=szohossz(masik))
    {
        igaz=false;
    }
    else
    {
        for(int i=0; i<szohossz(egyik); i++)
        {
            if(egyik[i]!=masik[i])
            {
                igaz=false;
            }
            igaz=true;
        }
    }
    return igaz;
}

/*2. �rjanak egy elj�r�s, amely k�t stringet kap meg
	param�terk�nt a m�retekkel egy�tt, �s kit�rli
	a m�sodik string karaktereit az els� stringb�l.
	(karaktert�mb�kkel val�s�ts�k meg)
	A be�p�tett C st�lus� elj�r�sok �s
	fv-ek n�lk�l oldj�k meg!*/

void eljaras(const char[] egyik, const char[] masik, int hossz1,int hossz2)
{
    
    for (int i = 0; i < hossz2; i++) {
        for (int j = 0; j < hossz1; j++) {
            if (egyik[j] == masik[i]) {
            // Ha az adott karakter megtalálható az első karaktertömbben

                // Balra toljuk a karaktertömböt, hogy az adott karakter eltűnjön
                for (int k = j; k < hossz1 - 1; k++) 
                {
                    egyik[k] = egyik[k + 1];
                }
                // Lezárjuk a karaktertömböt a nullával
                egyik[hossz1 - 1] = '\0'; 
                // Csökkentjük az első karaktertömb hosszát
                hossz1--; 
                // Visszalépünk egyet a j indexben, hogy az aktuális karaktert még egyszer megvizsgáljuk
                j--; 
            }
        }
    }

}

