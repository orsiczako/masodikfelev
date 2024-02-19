#include <iostream>
//itt így importálunk modulokat ha sajátot akarunk akkor<> helyett""
//v #define

int main(int agrs, char *argv[])
{/*argumentumok száma, (int args) és args[] ez a mainben*/
    /*int valt=5;
    //ez itt egy int valtozo(nyilvan)
    int tomb[30]; //int tipusu tomb
    int masiktomb[5];
    //cserébe itt egy ciklus is
    for(int i=0;i<30;i++)
    {
        tomb[i]=i;
        //fel van tölltve
    }
   
    for(int i=0;i<30;i++)
    {
        std::cout<<tomb[i]<<" ";
        //itt meg lazán faszán ki vannak írva szóközzel elválasztva
    }
   
    std::cout<<std::endl;
    //ifek meg elsek meg ilyenek:
    if(valt==5)
    {
        std::cout<<"ez 5"<<std::endl;
    }
    else if(valt==10)
    {
        std::cout<<"ez 10"<<std::endl;
    }
    else
    {
        std::cout<<"ez nem 5"<<std::endl;
    }

    for(int i=0;i<5;i++)
    {
        std::cin>>tomb[i]>>tomb[i];
    }*/







    //Gyakorlás:

    //1.fel: Kérj a felhasználótól négy darab értéket ami különbözik!
    int megadott;
    bool masikk;
    float ize;
    char vmi;
    std::cout<<"Adj meg egy intet"<<std::endl;
    std::cin>>megadott;
    std::cout<<"Adj meg egy floatet"<<std::endl;
    std::cin>>ize;
    std::cout<<"Egy chart"<<std::endl;
    std::cin>>vmi;
    std::cout<<"Adj meg egy bool"<<std::endl;
    std::cin>>masikk;

    std::cout<<megadott<<std::endl;
    std::cout<<ize<<std::endl;
    std::cout<<masikk<<std::endl;
    std::cout<<vmi<<std::endl;
    //nézd meg hogy osztható-e

    
    std::cout<<"Adj meg még egy értéket"<<std::endl;
    int adott;
    std::cin>>adott;
    if(megadott%adott==0){
        std::cout<<"Osztható"<<std::endl;
    }
    else
    {
        std::cout<<"Nem osztható"<<std::endl;
    }

    //olvass be számokat -1-ig vagy amíg 25-el nem osztható
    
   
    std::cout << "Adj meg számokat" << std::endl;
    int i = 0; 
    while (true) {
        std::cin >> i;
        if (i == -1 || i % 25 == 0) {
            break; 
        }
        std::cout << i << std::endl;

    }
    

   

   

    
    
    



    return 0;
}

//nyilván pythonban a main:

/* if __name__="__main__"*/

