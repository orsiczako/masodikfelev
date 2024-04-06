#include <iostream>
#include <cstdlib>

int main(int argc, char* argv[])
{

	int* p = 0; //NULL, nullptr

	int n = 5;
	p = &n;

	int* p2 = p;
	int** p3 = nullptr;

	int N[100];
	p2 = N; //p2 = &N[0]; //p2 = &N[5];
	p2[0] = 5; //N[0] = 5;

	/*
	Pointer feladat:
	1. Hozzanak létre tetszőleges típusú változót, és deklaráljanak egy pointert, amely
	   erre a változóra rá fog mutatni. Irassák ki mutatón keresztül a változó értékét,
	   majd a mutató értékét is (memóriacím)!
	   A mutatón keresztül változtassák meg ennek a változónak az értékét a felhasználó
	   által megadott érték alapján.
	2. Hozzanak létre tetszőleges típusú tömböt nulla kezdőértékekkel!
	   Mutató segítségével az első tíz darab páratlan indexű elemnek módosítsák az értékét!

	*/

	//1. Hozzana k létre tetszőleges típusú változót, és deklaráljanak egy pointert, amely
	//erre a változóra rá fog mutatni.Irassák ki mutatón keresztül a változó értékét,
	//majd a mutató értékét is(memóriacím)!
	//A mutatón keresztül változtassák meg ennek a változónak az értékét a felhasználó
	//által megadott érték alapján.

	int n = 0; //valtozo deklaralasa nulla kezdoertekkel
	int* p = &n; //ramutatunk n-re, p fogja n memoriacimet tarolni.

	std::cout << *p << " " << p << std::endl; //kiiratas: csillaggal a ramutatott valtozo erteke lesz lathato, siman hasznalva a mutatot a ramutatott valtozo memoriacimet fogjuk megkapni.
	*p = 2; // itt valtoztatjuk meg a ramutatott valtozo erteket.

	//2. Hozzanak létre tetszőleges típusú tömböt nulla kezdőértékekkel!
	//   Mutató segítségével az első tíz darab páratlan indexű elemnek módosítsák
	//   az értékét!

	int N[100] = { 0 };
	int* p2 = N;

	//egyik megoldas
	for (int i = 1; i < 20; i = i + 2)
	{
		p2[i] = 3;
	}

	//masik megoldas alvariaciokkal
	int elemszam = 0;
	int j = 0; // =1;
	int ujelem = 0;
	while (elemszam < 10) {
		std::cin >> ujelem;
		p2[j + 1] = ujelem;  //p[j] = ujelem;
		j += 2;
		elemszam += 1;
	}

	///Dinamikus memoriafoglalas

	int* p4 = nullptr;
	float* fp = nullptr;

	p4 = (int*)malloc(sizeof(int) * 100); //tipus merete * elemszam
	fp = (float*)calloc(sizeof(float), 100); //tipus merete, elemszam

	p4[3] = 6;
	fp[0] = 5.4;

	free(p4);
	free(fp);


	//- Kerjenek be a felhasznalotol 10 es 1000 kozotti erteket.Ezen ertek alapjan
	//	foglaljanak le dinamikusan egy egesz tipusu tombot.
	
	int n,meret;
	std::cin >> n;
	meret = n;

	int* P = (int*)calloc(sizeof(int), n);

	// Töltsék fel a tömböt úgy, hogy újabb számokat bekérve a felhasználótól egészen - 1 - ig
	//	és a számmal megegyező indexű tömbelem értéke - 50 és 250 közötti véletlen érték!
	while (n != -1)
	{
		std::cin >> n;
		if (n >= 0) {
			P[n] = rand() % (250 + 1 - (-50)) - 50;
		}
	}
	//  Hozzanak létre harmadakkora méretű tömböt az előzőhöz képest, és töltsék fel a tömb
	//  elemeit az alábbiak szerint :
	//		+ tagolják hármas csoportokba az első tömb elemeit
	//  	+ számítsák ki mindne hármas csoport átlagértékét
	//  	+ a tömb adott elemének értéke legyen véletlenszerű érték az átlagérték és ennek
	//  	  kétszerese között.
	//  	  pl : az átlag 3 értékre 15, akkor kérnek 15 és 30 között véletlenszámot!

	int* P2 = (int*)calloc(sizeof(int), meret / 3);

	for (int i = 0; i < meret - 2; i += 3) {
		int atlag = (P[i] + P[i + 1] + P[i + 2]) / 3; //vesszuk az aktualis indexhez kepest a kovetkezo ket elemet! Igy kapunk harmas csoportot, erre kell az atlag!
		P2[i] = rand() % (atlag * 2 + 1 - atlag) + atlag;
	}
	free(P2);
	free(P);
	return 0;
}

/*
   - Kerjenek be a felhasznalotol 10 es 1000 kozotti erteket. Ezen ertek alapjan
     foglaljanak le dinamikusan egy egesz tipusu tombot.
   - Töltsék fel a tömböt úgy, hogy újabb számokat bekérve a felhasználótól egészen -1-ig
	 és a számmal megegyező indexű tömbelem értéke -50 és 250 közötti véletlen érték!
   - Hozzanak létre harmadakkora méretű tömböt az előzőhöz képest, és töltsék fel a tömb
     elemeit az alábbiak szerint:
	 + tagolják hármas csoportokba az első tömb elemeit
	 + számítsák ki mindne hármas csoport átlagértékét
	 + a tömb adott elemének értéke legyen véletlenszerű érték az átlagérték és ennek 
	   skétszerese között. 
	   pl: az átlag 3 értékre 15, akkor kérnek 15 és 30 között véletlenszámot!
*/

/*
   - Kerjenek be a felhasznalotol 10 es 150 kozotti erteket. Ezen �rt�k alapj�n
   foglaljanak le dinamikusan egy eg�sz t�pus� t�mb�t.
   - Ezt a t�mb�t t�lts�k fel -30 �s 120 k�z�tti v�letlensz�mokkal.
   - Hozzanak l�tre az els� t�mh�z k�pest
	 egy harmadakkora t�rt t�pus� dinamikus t�mb�t. A t�mb adott elemeit t�lts�k fel
	 az els� t�mb �rt�kei alapj�n �gy, hogy a m�sodik t�mbbel megegyez� indexhez k�pest a szomsz�dos
	 elemeket ki�tlagolj�k az els� t�mbben.
   */