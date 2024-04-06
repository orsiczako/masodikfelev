#include<iostream>

using namespace std;
/*Implementáljanak egy eljárást amely egy termék struktúrát megkapja paraméterként, feltölti aze egyes adatelemeit
A termék struktúrának deifináljanak tetszőlegesen 3 jellemzőt*/

/*Hozzanak létre egy 10 elemű Termék típusú struktúrát dinamikus
 lefoglalva.Készítsenek egy függvényt, amely visszatár a termékek átlagárával
*/


struct Termek{
    double suly;
    int ar;
    char marka[20];
};

void init_Termek(Termek* T)
{
    std::cout<<"Súly:";
    std::cin>>T->suly;

    std::cout<<"Ar:";
    std::cin>>T->ar;


    strncpy(T->marka,"Milfina",20);

    
}
int atlag(Termek* peldany){
    int atlag=0;
    for(int i=0;i<10;i++)
    {
        atlag+=peldany[i].ar;
    }
    return atlag/10;
}

int main(int argc, char* argv[]){

    Termek T;
    init_Termek(&T);
    //Ha pointerként hivatkozok egy struktúrára akkor nyíllal adok meg neki értéket, ellenben ha változóként  pl:
    /*
    Auto A A.loero=150
    akkor csak simán ponttal, meg akkor is simán ponttal, amikor példányosítunk és a példányon keresztül hivatkozunk rá
    
    
    pointer féle:
    Auto* A = new Auto();
    (Auto*)calloc(insert(Auto),1);
    A loero->150*/
    //Így adjuk át paraméterként 
    //mivel dinamikusan van lefoglalva így így példányosítunk
    Termek* peldany=new Termek[10];
    for (int=0;i<10;i++)
    {
        peldany[i].suly=rand()%9000+1000;
        peldany[i].ar=rand();
        peldany[i].marka[0]=rand()%26+65;
        peldany[i].marka[1]='\0'; // Null terminátor hozzáadása a string végéhez

    }
    atlag(&peldany);

   


    return 0;
}
