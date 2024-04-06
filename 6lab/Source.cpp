#include <iostream>
#include <string>

/*#define RED 0
#define GREEN 1
#define BLUE 2
#define BLACK 3*/

enum Colors {
	RED,
	GREEN,
	BLUE,
	BLACK
};

enum Marka {
	BMW,
	Mercedes,
	Audi
};

//1. Deklaraljanak egy Car nevu strukt�r�t
struct Car {
	int szin;
	int loero;
	int tipus;
	bool kolcsonozve;
	unsigned int ar;

	Car() {
		this->szin = rand() % 4;
		this->loero = rand() % (260 + 1 - 80) + 80;
		this->tipus = rand() % 3;
		this->kolcsonozve = rand() % 2;
		this->ar = rand() % (10) + 1;
	}
	~Car() = default;
	void kiir() {
		this->szin;
		this->loero;
	}
};

void computeValues(Car* C,int size)
{
	int numberofBorred = 0;
	int carValues = 0;

	for (int i = 0; i < size; i++) {
		numberofBorred += (int)C[i].kolcsonozve;
		carValues += C[i].ar;
	}

	std::cout << "Kolcsonozve: " << numberofBorred << std::endl
		<< "Osszertek: " << carValues << std::endl;
}

void kiir(Car& C)
{
	std::cout << "Szintipus: " << C.szin << std::endl;
}

int main()
{

	//2. Hozzanak l�tre 5 db p�ld�nyt ebb�l a strukt�r�b�l, �s t�lts�k fel v�letlenszer� 
	//    �rt�kekkel!

	Car* C = new Car[5];

	for (int i = 0; i < 5; i++) {
		C[i].szin = rand() % 4;
		C[i].loero = rand() % (260 + 1 - 80) + 80;
		C[i].tipus = rand() % 3;
		C[i].kolcsonozve = rand() % 2;
		C[i].ar = rand() % (10) + 1;
	}


	/*Car C;
	Car C2;
	Car *C3 = new Car();

	C.s = "ASD-569";
	C.kerek = 23;

	C2.s = "DFS-478";

	C3->s = "ERT-213"; //*C3.s
	*/

	// 1. Deklaraljanak egy Car nevu strukt�r�t az al�bbi jellemz�kkel
	//    - szin
	//    - loero
	//    - tipusa
	//    - kikolcsonoztek-e
	//    - ar
	//
	// 2. Hozzanak l�tre 5 db p�ld�nyt ebb�l a strukt�r�b�l, �s t�lts�k fel v�letlenszer� 
	//    �rt�kekkel!
	// 3. �rja ki a szoftver, hogy h�ny aut� nincs kik�lcs�n�zve, 
	//    illetve mennyi az aut�k �ssz�rt�ke!
	//    A feladatot elj�r�ssal, vagy f�ggv�nnyel oldj�k meg!
	// 4. �rjanak egy elj�r�st, ami ki�rja az adott Car p�ld�ny jellemz�it!

	//1.




	return 0;
}