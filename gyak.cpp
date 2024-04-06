/*
    - Hozzanak letre egy 1000 meretu tombot, kerjenek be a felhasznalotol szamokat -1 ertekig, es a bekert szamok alapjan
    inkrementaljak a tomb elemeit!
    - Irassanak ki minden otodik elemet!
    - Hozzanak letre egy masik 1000 elemu tobot es minden paros indexu elemet masoljanak at az eredeti
      tombbol!
    - A masodik tomb minden harmadik elemet toltsuk fel -3 es 10 kozotti veletlenszeru ertekekkel!
    - A masodik tombben minden paratlan elemet toltsenek fel tortszamokkal 10 �s 105 k�z�tt!
    */

# include <iostream>

using namespace std;

int main(int argc, char* agrv[])
{
    int tomb[1000]={0};
    int ertek;
    int i=0;
    while(true)
    {
        std::cout<<"Adjon meg értékeket"<<std::endl;
        std::cin>>ertek;
        if (ertek==-1)
        {
            break;
        }
        else
        {
            tomb[i]+=ertek;
            i++;
        }
        

    }
    for (int i=4;i<1000;i+=5)
    {
        std::cout<<tomb[i];
    }
    int masik[1000]={0};
    for (int i=0;i<1000;i+=2)
    {
        masik[i/2]+=tomb[i];
    }
    for(int i=0;i<1000;i++)
    {
        std::cout<<masik[i];
    }
    /*Deklar�ljanak n�gyfajta typus� v�ltoz�kat,
    �s akkor deklar�ljanak hozz�val� mutat� t�pusokat is.
    Adjanak minden v�ltoz�nak kezd��rt�ket a pointerek alkalmaz�s�val,
    �s irass�k is ki ezeket az �rt�kekekt a konzolba.*/
    int egyik=5;

    char valami;
    double ez;
    bool amaz;

    int* p1=&egyik;

    std::cout<<*p1<<std::endl;
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