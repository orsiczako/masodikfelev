// Labor7.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "Product.h"

#include <iostream>

enum Categories {
	ELELMISZER,
	OLTOZKODES,
	HAZTARTAS
};

struct Product {
	unsigned int   category;
	unsigned int   quantity;
	unsigned int   price;
	unsigned char  id[13];
};

void initProduct(Product* P) {
	P->category = rand() % 3;
	P->quantity = rand() % (20 + 1 - 1) + 1; /// 1 es 20 kozott valtozik a mennyisege
	P->price = rand() % (100000 + 1 - 1000) + 1000; ///az ar 1000 es 100000 kozott lesz

	P->id[0] = rand() % (90 + 1 - 65) + 65;
	P->id[1] = rand() % (90 + 1 - 65) + 65;
	P->id[2] = '-';

	for (int i = 3; i < 3 + 6; i++)
		P->id[i] = rand() % (57 + 1 - 48) + 48;

	unsigned int interval_numbers = 57 + 1 - 48;
	unsigned int interval_characters =  90 + 1 - 65;
	
	for (int i = 9; i < 11; i++) {
		unsigned int value = rand() % (interval_numbers + interval_characters);
		
		if (value <= interval_numbers) P->id[i] = value + 48;
		else                           P->id[i] = value + 65;
	}

	P->id[12] = '\0';
}

void computeCategoryInfo(Product* P,unsigned int size)
{
	std::string names[3] = { "Élelmiszer","Öltözködés","Háztartás" };

	float prices[3] = { 0 };
	unsigned int quantities[3]{ 0 };

	for (int i = 0; i < size; i++) {

		// rovidebb megoldas, siman hasznaljuk indexkent a kategoriat.
		prices[P[i].category] += P[i].price;
		quantities[P[i].category] += P[i].quantity;

		//hosszabb megoldas, switch case-zel minden esetet lekezeleunk sorban
		switch (P[i].category) {
			case Categories::ELELMISZER: {
				prices[Categories::ELELMISZER]     += P[i].price;
				quantities[Categories::ELELMISZER] += P[i].quantity;
				break;
			}
			case Categories::HAZTARTAS: {
				prices[Categories::HAZTARTAS] += P[i].price;
				quantities[Categories::HAZTARTAS] += P[i].quantity;
				break;
			}
			case Categories::OLTOZKODES: {
				prices[Categories::OLTOZKODES] += P[i].price;
				quantities[Categories::OLTOZKODES] += P[i].quantity;
				break;
			}
			default: break;
		}
		
	}
	for (int i=0;i<3;i++)
		prices[P[i].category] /= 3;

	for (int i = 0; i < 3; i++) {
		std::cout << names[i] << " mennyiség: " << quantities[i] << ", ár: " << prices[i] << std::endl;
	}

}

void saleProducts(Product* P, unsigned int size)
{
	for (int i = 0; i < size; i++) {
		float isSale = (float)rand() / RAND_MAX;

		if (isSale <= 0.6) {
			float sale = (float)(rand() % (20 + 1 - 5) + 5) / 100;
			P[i].price *= (1 - sale);
		}
	}
}

int main()
{
	// 1. Deklaraljanak egy Termek nevu strukturat az alabbi jellemzokkel:
	//    - kategoria
	//    - mennyiseg
	//    - ar
	//    - termekkod (XX-XXXXX-XX) // AD-125478-A0
	// 2. Hozzanak letre 12 db példányt, és töltsék fel véletlenszerû értékekkel!
	// 3. A szoftver számolja ki az egyes kategóriákhoz tartozó termékek mennyiségét,
	//    és átlagos árát!
	// 4. A szoftver 60%-os eséllyel leakciózza az adott kategórián belüli termék árát
	//    5 és 20% közötti értékkel véletlenszerûen!

	Product P2;
	Product* P = new Product[12];
	for (int i = 0; i < 12; i++)
		initProduct(&P[i]);

	computeCategoryInfo(P,12);
	saleProducts(P, 12);
	

	//Product P(); //ez az osztaly peldanyositasa, kov oran folytatjuk az atalakítast
    std::cout << "Hello World!\n";
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
