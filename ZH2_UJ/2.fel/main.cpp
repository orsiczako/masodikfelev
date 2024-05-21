#include <fstream>
#include <string>
#include "Vehicle.h"
#include "json.hpp"

int main()
{
    std::ifstream input("file.txt", std::ios::in); // Fájl beolvasása olvasásra
    std::string fajlnev[256]; // Fájlnevek tömbje
    Vehicle* products = new Vehicle[256]; // Vehicle objektumok tömbje
    double k; // Üzemanyagszint
    unsigned int l = 0; // Üzemanyagtartály
    unsigned int a = 0.0; // Lóerő
    double c; // Segédváltozó

    int iterator = 1; // Iterátor inicializálása 1-gyel, hogy az első sort kihagyja
    while (input >> fajlnev[iterator] >> c >> k >> c >> l >> c >> a) {
        products[iterator].setUzemanyagszint(k); // Üzemanyagszint beállítása
        products[iterator].setUzemanyagtartaly(l); // Üzemanyagtartály beállítása
        products[iterator].setLoero(a); // Lóerő beállítása
        ++iterator; // Iterátor növelése
    }
    std::ofstream output("output.txt", std::ios::out); // Fájl kimenet nyitása írásra

    // Kiírás JSON formátumban:
    std::ofstream jsonOutput("output.json", std::ios::out); // JSON fájl kimenet nyitása írásra
    nlohmann::json jsonData; // JSON adatok

    for (int i = 1; i < iterator; i++) {
        nlohmann::json vehicleData; // Jármű adatok
        vehicleData["uzemanyagszint"] = products[i].getUzemanyagszint(); // Üzemanyagszint hozzáadása a jármű adatokhoz
        vehicleData["uzemanyagtartaly"] = products[i].getUzemanyagtartaly(); // Üzemanyagtartály hozzáadása a jármű adatokhoz
        vehicleData["loero"] = products[i].getLoero(); // Lóerő hozzáadása a jármű adatokhoz
        jsonData[fajlnev[i]] = vehicleData; // Jármű adatok hozzáadása a JSON adatokhoz

        if (products[i].getUzemanyagszint() > 2 * 0.3 * average) { // Ha az üzemanyagszint nagyobb, mint a számított érték
            if (output.is_open())
                output << fajlnev[i] << " " << products[i].getUzemanyagszint() << " " << products[i].getUzemanyagtartaly() << " " << products[i].getLoero() << std::endl; // Adatok kiírása a fájlba
        }
    }

    jsonOutput << jsonData.dump(4); // JSON adatok kiírása a fájlba
    jsonOutput.close(); // JSON fájl kimenet bezárása
    output.close(); // Fájl kimenet bezárása

    std::ofstream out_txt("output.txt", std::ios::out); // Szöveges fájl kimenet nyitása írásra
    std::ofstream out_bin("output.bin", std::ios::binary | std::ios::out); // Bináris fájl kimenet nyitása írásra

    for (int i = 1; i < iterator; i++) {
        if (products[i].getUzemanyagszint() > 2 * 0.3 * average) { // Ha az üzemanyagszint nagyobb, mint a számított érték
            if (out_txt.is_open())
                out_txt << products[i].getUzemanyagszint() << " " << products[i].getUzemanyagtartaly() << " " << products[i].getLoero() << std::endl; // Adatok kiírása a szöveges fájlba

            if (out_bin.is_open())
                out_bin.write(reinterpret_cast<char*>(&products[i]), sizeof(Vehicle)); // Adatok kiírása a bináris fájlba
        }
    }

    out_txt.close(); // Szöveges fájl kimenet bezárása
    out_bin.close(); // Bináris fájl kimenet bezárása

    delete[] products; // Dinamikusan foglalt memória felszabadítása

    return 0;
}
