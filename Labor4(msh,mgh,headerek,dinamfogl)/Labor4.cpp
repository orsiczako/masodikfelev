// Labor4.cpp

#include "Labor4.h"
#include <cstdlib>

int beker() {
    int ertek;
    do {
        std::cin >> ertek;
    } while (ertek < 100 || ertek > 500);
    return ertek;
}

void lefoglal(int*& N, int meret) {
    N = new int[meret];
}

void feltolt(int*& N, int meret) {
    for (int i = 0; i < meret; i++)
        N[i] = rand() % (100 + 1 - 10) + 10;
}

void fel1(char*& tomb) {
    tomb = new char[128];
}

char fel2(char* masik, int mmeret) {
    char maganh[] = { 'a','e','i','o','u' };
    char massalh[] = { 'q','w','r','t','z','p','s','d','f','g','h','j','k','l','y','x','c','v','b','n','m' };
    for (int i = 0; i < 40; i += 2) {
        int index = rand() % (sizeof(maganh) / sizeof(maganh[0]));
        masik[i] = maganh[index];
    }
    for (int i = 1; i < 40; i += 2) {
        int index = rand() % (sizeof(massalh) / sizeof(massalh[0]));
        masik[i] = massalh[index];
    }
	return masik;
}

void fel3(char* masik, int meret) {
    for (int i = meret / 2; i < meret; i++) {
        masik[i] = static_cast<char>(rand() % (122 + 1 - 97) + 97);
    }
}

int fel4(char szo) {
    int szam = 0;
    int meret = strlen(szo);
    char massalh[] = { 'q','w','r','t','z','p','s','d','f','g','h','j','k','l','y','x','c','v','b','n','m' };
    for (int i = 0; i < meret; i++) {
        for (int j = 0; j < sizeof(massalh); j++) {
            if (massalh[j] == szo[i]) {
                szam++;
                break;
            }
        }
    }
    return szam;
}

void fel5(char* tomb,int meret)
{
	

}
