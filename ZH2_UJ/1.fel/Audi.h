#pragma once

#include<iostream>
#include <string>
#include <fstream>


class Audi: public Vehicle
{
    public:
    Audi(unsigned int loero, unsigned int uzemanyag, unsigned int fogyasztas, std::string tipus):Vehicle(loero,uzemanyag,fogyasztas)
    {
        this->tipus = tipus;
    }
    void setTipus(std::string tipus){
        this->tipus=tipus;
    }
    std::string getTipus(){
        return this->tipus;
    }
    
    private:
    std::string tipus;
};

/*Készítsenek származtatott termékosztályokat, amely ráépül a meglévő Vehicle
osztályra! (1p/osztály, maximum +2p)!*/
//itt erre majd rákérdezek, hogy egy fileon belül vagy külön csináljam