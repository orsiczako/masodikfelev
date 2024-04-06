/*
	Készítsenek egy függvényt, amely két stringet kap meg
	paraméterként, és összehasonlítja azokat!
	A fv térjen vissza igaz értékkel, hogy ha a tartalmuk
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
 1. Írjanak egy függvényt, amely két stringet kap meg 
    a paraméterként méretekkel együtt, és visszatér 
	igaz értékkel, hogy ha a második string megtalálható
	az elsõben.
 2. Írjanak egy eljárás, amely két stringet kap meg 
    paraméterként a méretekkel együtt, és kitörli 
	a második string karaktereit az elsõ stringbõl. 
	(karaktertömbökkel valósítsák meg)
	A beépített C stílusú eljárások és 
	fv-ek nélkül oldják meg!

*/