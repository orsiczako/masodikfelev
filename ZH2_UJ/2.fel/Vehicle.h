#pragma once

#include <iostream>
#include <string>
#include <fstream>
#include "json.hpp"

class Vehicle
{
public:
    Vehicle() = default;
    Vehicle(double uzemanyagszint, unsigned int uzemanyagtartaly, unsigned int loero, double fogyasztas)
        : uzemanyagszint(uzemanyagszint), uzemanyagtartaly(uzemanyagtartaly), loero(loero), fogyasztas(fogyasztas) {}
    ~Vehicle() = default;

    double getUzemanyagszint() const
    {
        return uzemanyagszint;
    }
    unsigned int getUzemanyagtartaly() const
    {
        return uzemanyagtartaly;
    }
    unsigned int getLoero() const
    {
        return loero;
    }
    double getFogyasztas() const
    {
        return fogyasztas;
    }

    void setUzemanyagszint(double uzemanyagszint)
    {
        this->uzemanyagszint = uzemanyagszint;
    }
    void setUzemanyagtartaly(unsigned int uzemanyagtartaly)
    {
        this->uzemanyagtartaly = uzemanyagtartaly;
    }
    void setLoero(unsigned int loero)
    {
        this->loero = loero;
    }
    void setFogyasztas(double fogyasztas)
    {
        this->fogyasztas = fogyasztas;
    }

    double fogyaszt() const
    {
        return uzemanyagtartaly / fogyasztas;
    }

    friend std::ostream& operator<<(std::ostream& s, const Vehicle& V)
    {
        return s << V.getUzemanyagszint() << ";" << V.getUzemanyagtartaly() << ";" << V.getLoero() << ";" << V.getFogyasztas() << std::endl;
    }

private:
    double uzemanyagszint;
    unsigned int uzemanyagtartaly;
    unsigned int loero;
    double fogyasztas;
};