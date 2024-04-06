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

#include <iostream>
#include <cstdlib>

// 1. �rjanak egy f�ggv�nyt, amely k�t stringet kap meg
// a param�terk�nt m�retekkel egy�tt, �s visszat�r
// igaz �rt�kkel, hogy ha a m�sodik string megtal�lhat�
// az els�ben.

int getStrHossz(char* str)
{
	int i = 0;
	while (str[i] != '\0')
	{
		i += 1;
	}

	return i;
}

int megtalalhato(char* C, char* C2)
{
	int hossz_1 = getStrHossz(C);
	int hossz_2 = getStrHossz(C2);
	
	if (hossz_2 > hossz_1) return -1;
	
	int pozicio = 0;
	for (int i = 0; i <= hossz_1 - hossz_2; i++)
	{
		pozicio = 0;
		for (int j = 0; j < hossz_2; j++)
		{
			if (C[i + j] == C2[j])
			{
				if (!j) pozicio = i;
				if (j == hossz_2 - 1) return pozicio;
			}

			else break;
		}
	}

	return -1;
}

// 2. �rjanak egy elj�r�s, amely k�t stringet kap meg
// param�terk�nt a m�retekkel egy�tt, �s kit�rli
// a m�sodik string karaktereit az els� stringb�l.
// (karaktert�mb�kkel val�s�ts�k meg)
// A be�p�tett C st�lus� elj�r�sok �s
// fv - ek n�lk�l oldj�k meg!

void torles(char* C1, int meret, char* C2, int meret2)
{
	while (megtalalhato(C1, C2) != -1)
	{	
		int i = 0;
		for (i = megtalalhato(C1, C2) + getStrHossz(C2); i < getStrHossz(C1); i++)
		{
			C1[i - getStrHossz(C2)] = C1[i];
		}

		C1[i - getStrHossz(C2)] = '\0';
	}
}

int main(int argc, char* argv[])
{
	return 0;
}