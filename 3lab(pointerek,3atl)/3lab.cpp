#include<iostream>
#include<cstdlib>

/*
    Deklar�ljanak n�gyfajta typus� v�ltoz�kat,
    �s akkor deklar�ljanak hozz�val� mutat� t�pusokat is.
    Adjanak minden v�ltoz�nak kezd��rt�ket a pointerek alkalmaz�s�val,
    �s irass�k is ki ezeket az �rt�kekekt a konzolba.
*/


using namespace std;

int main(int argc, char* argv[])
{
  /*int a;
  char b;
  bool c;
  float f;

  int* p1;
  char* p2;
  bool* p3;
  float* p4;

  *p1 = 5;
  *p2 = 'A';
  *p3 = true;
  *p4 = 3.14;*/

   /*
    deklar�ljanak egy statikus t�mb�t. Egy pointer seg�ts�g�vel t�lts�k
    fel �rt�kekkel, melyet a felhaszn�l�t�l olvas be a program.
    */
  int* tomb=(int*)calloc(sizeof(int),10);
  int* p=tomb;
  for(int i=0; i<10;i++)
  {
    p[i]=rand()%(10+1-1)+1;
  }

  for(int i=0; i<10; i++)
  {
    std::cout<<tomb[i]<<std::endl;
  }

  /*Deklar�ljanak egy 15 elem� karaktert�mb�t.
    T�lts�k fel a karaktert�mb�t a felhaszn�l� �ltal megadott �rt�kekkel
    mutat� alkalmaz�s�val.*/
  char elemek[15];
  char* po=elemek;
  for(int i=0; i<15; i++)
  {
    std::cout<<"Adjon meg egy értéket!"<<std::endl;
    
    std::cin>>po[i];
  }

  for(int i=0; i<15;i++)
  {
    std::cout<<elemek[i]<<std::endl;
  }
    /*
    - K�rjenek be a felhaszn�l�t�l 10 �s 150 k�z�tti �rt�ket. Ezen �rt�k alapj�n
    foglaljanak le dinamikusan egy eg�sz t�pus� t�mb�t.
    - Ezt a t�mb�t t�lts�k fel -30 �s 120 k�z�tti v�letlensz�mokkal.
    - Hozzanak l�tre az els� t�mh�z k�pest 
    egy harmadakkora t�rt t�pus� dinamikus t�mb�t. A t�mb adott elemeit t�lts�k fel
    az els� t�mb �rt�kei alapj�n �gy, hogy a m�sodik t�mbbel megegyez� indexhez k�pest a szomsz�dos
    elemeket ki�tlagolj�k az els� t�mbben.
    */
  std::cout<<"Adjon meg egy értéket 10 és 150 között!"<<std::endl;
  int ertek;
  std::cin>>ertek;
  int* valami =(int*)calloc(sizeof(int),ertek);
  for(int i=0;i<ertek;i++)
  {
    //(max+1-min)+min
    valami[i]+=rand()%(120+1+30)-30;
  }
  for(int i=0;i<ertek;i++)
  {
    std::cout<<i<<". "<<valami[i]<<std::endl;
  }
  int* harmad =(int*)calloc(ertek/3,sizeof(int));
  for(int i=0;i<ertek/3;i++)
  {
    /*
		Itt kiszamitjuk az elso tomb indexet az alabbiak alapjan:
		- mindig harmas csoportokra osztjuk fel az elso tombot.
		- az i*3-mal leptetjuk a csoportokat, tehat a legelso iteracioban a 0,1,2 indexu elemeket tartalmazo csoport lesz
		  utana pedig a 3,4,5 egeszen a tomb vegeig.
		- vesszuk a kozepso elemet, ezt jelenti a plusz hozzadas a vegen.
		*/
    firstIndex = (i*3)+1;
    harmad[i]=((float)valami[firstIndex-1]+(float)valami[firstIndex]+(float)valami[firstIndex+1])/3;
    //a hetfo csutortok fileban lévő kód az szebb szerintem
  }
  free(valami);
  free(harmad);
  /*2. Hozzanak létre tetszőleges típusú tömböt nulla kezdőértékekkel!
	   Mutató segítségével az első tíz darab páratlan indexű elemnek módosítsák az értékét!

	*/
    int kutya[100]={0};
    int* point=kutya;
    int elem;
    for(int i=0;i<20;i+=2)
    {
        std::cout<<"új"<<std::endl;
        std::cin>>elem;
        point[i]+=elem;

    }
    for (int i=0;i<100;i++)
    {
        std::cout<<kutya[i];
    }


    
}