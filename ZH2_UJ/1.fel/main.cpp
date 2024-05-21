#include "Vehicle.h"


int main()
{
    //példányosítás:
    Vehicle V;
    Vehicle* V2= new Vehicle(100, 50, 10);

    V.setLoero(100);
    V.setUzemanyag(50); 
    V.setFogyasztas(100); 
    delete V2;
    std::cout<<"Adja meg a fogyasztást"<<std::endl;
    unsigned int fogyasztas;
    std::cin>>fogyasztas;
    std::cout<<"Adja meg az üzemanyagot"<<std::endl;
    unsigned int uzemanyag;
    std::cin>>uzemanyag;
    double fogyasztott=V.fogyaszt(fogyasztas,uzemanyag);
    std::cout<<"Fogyasztás: "<<fogyasztott<<"%"<<std::endl;

    std::ofstream out("kocsi.txt", std::ios::out);
	if (out.is_open())
		out << V;
	out.close();

   

    return 0;
}