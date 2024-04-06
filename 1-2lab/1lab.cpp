/*
    - Hozzanak letre egy 1000 meretu tombot, kerjenek be a felhasznalotol szamokat -1 ertekig, es a bekert szamok alapjan
    inkrementaljak a tomb elemeit!
    - Irassanak ki minden otodik elemet!
    - Hozzanak letre egy masik 1000 elemu tobot es minden paros indexu elemet masoljanak at az eredeti
      tombbol!
    - A masodik tomb minden harmadik elemet toltsuk fel -3 es 10 kozotti veletlenszeru ertekekkel!
    - A masodik tombben minden paratlan elemet toltsenek fel tortszamokkal 10 �s 105 k�z�tt!
    */

#include<iostream>
#include<cstdlib>

using namespace std;

int main(int agrc, char *argv[])
{

    /*- Hozzanak letre egy 1000 meretu tombot, kerjenek be a felhasznalotol szamokat -1 ertekig, es a bekert szamok alapjan
    inkrementaljak a tomb elemeit!*/
    int tomb[1000]={0};
    int i=0;
    while(true)
    {
        std::cout<<"Adjon meg értékeket -1-ig!"<<std::endl;
        int ertek;
        std::cin>>ertek;
        if(ertek==-1)
        {
            std::cout<<"-1-et adtál meg!"<<std::endl;
            break;
        }
        else
        {
            
            tomb[i]+=ertek;
            i++;
        }
    }
    int tombnagys=sizeof(tomb)/sizeof(tomb[0]);
    for(int i=0;i<tombnagys;i++)
    {
        std::cout<<tomb[i]<<std::endl;
    }
    /*VAGY:
    for(int i=0;i<1000;i++)
    {
        std::cout<<tomb[i]<<std::endl;
    }
    */
   //- Irassanak ki minden otodik elemet!
    
    for(int i=4;i<tombnagys;i+=5)
    {
        std::cout<<tomb[i]<<std::endl;
    }
    //- Hozzanak letre egy masik 1000 elemu tombot es minden paros indexu elemet masoljanak at az eredeti
    //tombbol!
    int masik[1000]={0};
    for (int i=0;i<1000;i+=2)
    {
        masik[i]+=tomb[i];
    }
    //irassuk ki:
    for (int i=0;i<tombnagys;i++)
    {
        std::cout<<masik[i]<<" ez a masik"<<std::endl;
    }
    // - A masodik tomb minden harmadik elemet toltsuk fel -3 es 10 kozotti veletlenszeru ertekekkel!
    int harmadik[1000]={0};
    for(int i=2;i<1000;i+=3)
    {
        harmadik[i]=rand()%(10+1+3)+3;
    }
    for(int i=0;i<1000;i++)
    {
        std::cout<<harmadik[i]<<" harmadik"<<std::endl;

    }
    // - A masodik tombben minden paratlan elemet toltsenek fel tortszamokkal 10 �s 105 k�z�tt!
    for(int i=1;i<1000;i+=2)
    {
        masik[i]+=(float)rand()/RAND_MAX*(105-10)+10;
    }
    //Hozzanak l�tre egy 10 elem� karaktert�mb�t, majd t�lts�k fel kism�ret� bet�kkel! 
    char betuk[10];
    for(int i=0;i<10;i++)
    {
        //a=97,z=122
        betuk[i]=(char)(rand()%(122+1-97)+97);
    }
    for(int i=0;i<10;i++)
    {
        std::cout<<betuk[i]<<" betu"<<std::endl;
    }











    
    
    
    return 0;

}