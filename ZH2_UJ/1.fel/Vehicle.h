#pragma once

#include <iostream>
#include <string>
#include <fstream>


class Audi;

class Vehicle
{   public:
    Vehicle()=default;
    Vehicle(unsigned int loero, unsigned int uzemanyag, unsigned int fogyasztas):loero(loero),uzemanyag(uzemanyag),fogyasztas(fogyasztas){}
    ~Vehicle()=default;
    unsigned int getLoero()const{
        return loero;
    }
    unsigned int getUzemanyag()const{
        return uzemanyag;
    }
    unsigned int getFogyasztas()const{
        return fogyasztas;
    }
    void setLoero(unsigned int loero){
        this->loero=loero;
    }
    void setUzemanyag(unsigned int uzemanyag){
        this->uzemanyag=uzemanyag;
    }
    void setFogyasztas(unsigned int fogyasztas){
        this->fogyasztas=fogyasztas;
    }
    double fogyaszt(unsigned int fogyasztas, unsigned int uzemanyag)
    {
        return (double)uzemanyag/fogyasztas;
    }
    //ez itt mindenképpen kell a fileba iratáshoz, ne felejts majd el a V-t és a Vehicle-t átírni!
   
    friend std::ostream& operator << (std::ostream& s, const Vehicle& V) {
        return s << V.getLoero() << "," << V.getUzemanyag() << "," << V.getFogyasztas() << std::endl;
    }

    



    private:
    unsigned int loero;
    unsigned int uzemanyag;
    unsigned int fogyasztas;

};