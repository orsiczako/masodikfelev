/*
	K�sz�tsenek egy f�ggv�nyt, amely k�t stringet kap meg
	param�terk�nt, �s �sszehasonl�tja azokat!
	A fv t�rjen vissza igaz �rt�kkel, hogy ha a tartalmuk
	megegyezik!
*/
#include <iostream>
#include <string>


bool compare(char*& a, char*& b, int meret, int meret2)
{
	bool egyezik = false;

	if (meret == meret2) {
		egyezik = true;
		for (int i = 0; i < meret; i++)
		{
			if (a[i] != b[i]) {
				egyezik = false;
			}
		}
	}

	return egyezik;
}

/*
Feladat:
 1. �rjanak egy f�ggv�nyt, amely k�t stringet kap meg 
    a param�terk�nt m�retekkel egy�tt, �s visszat�r 
	igaz �rt�kkel, hogy ha a m�sodik string megtal�lhat�
	az els�ben.
 2. �rjanak egy elj�r�s, amely k�t stringet kap meg 
    param�terk�nt a m�retekkel egy�tt, �s kit�rli 
	a m�sodik string karaktereit az els� stringb�l. 
	(karaktert�mb�kkel val�s�ts�k meg)
	A be�p�tett C st�lus� elj�r�sok �s 
	fv-ek n�lk�l oldj�k meg!

*/