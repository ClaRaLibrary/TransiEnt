/*******************************************
* Funktion in C für Modelica, die gleichverteilte 
* Zufallszahlen zurückliefert.
* Patrick Göttsch, 01.06.2014
*
*******************************************/

#include "extfunc_RandomNumber.h"

/********************************************
*	Pseudozufallszahlengenerator
*	Marsaglia KISS 2003 Implementierung nach 
*	http://de.wikipedia.org/wiki/KISS_Zufallszahlengenerator
*
*	uint32_t init:		Startwert für die Initialisierung des Zufallzahlengenerators
*	uint32_t return:	Rückgabewert: Generierte Zufallszahlen im Bereich 0 bis 4.294.967.295
********************************************/
uint32_t random(uint32_t init)
{
	static uint32_t x = 123456789;
	static uint32_t y = 362436000;
	static uint32_t z = 521288629;
	static uint32_t c = 7654321;

	uint64_t t;

	if (init > 0)
	{
		x = init;
	}

	x = 69069  * x + 12345;

	y ^= y << 13;
	y ^= y >> 17;
	y ^= y << 5;

	t = 698769069ULL * z + c;
	c = t >> 32;
	z = (uint32_t) t;

	return x + y + z;
}

/****************************************
*	extfunc_RandomNumber
*	Aufrufprogramm für Zufallszahlengenerator.
*	Setzt die obere und untere Grenze der gelieferten Zufallszahlen
*	Setzt den Initialisierungswert
*
* int UseSeed:			0: Kein Seed,
*						1: Benutze Systemzeit
*						2: Benutze feste Zahl SeedNumber
* uint32_t SeedNumber:	Zahl mit dem der Zufallsgenerator initialisiert wird. Für
*						reproduzierbare Ergebnisse
* uint32_t MaxNumber:	Maximale Zahl, die zurückgegeben wird.
*						Für Null wird die Systemeinstellung verwendet
* uint32_t MinNumber:	Maximale Zahl, die zurückgegeben wird.
*						Für Null wird die Systemeinstellung verwendet
* int32_t return:		Gibt die formatierte Zufallszahl im Bereich -2.147.483.648 bis 2.147.483.647 zurück
****************************************/
int32_t extfunc_RandomNumber(int UseSeed, uint32_t SeedNumber, int32_t MaxNumber, int32_t MinNumber)
{
	int32_t Zufallszahl = 0; // Speichert die generierte Zufallszahl 
	int32_t ObereGrenze = MaxNumber; // Speichert die obere Grenze des geforderten Zahlenraums
	int32_t UntereGrenze = MinNumber; // Speichert die untere Grenze des geforderten Zahlenraum
	static int ErsterLauf = 0;	

	// Defaultbedingungen setzen
	if (ObereGrenze == 0)
	{
		ObereGrenze = 1;
	}
	if (UntereGrenze == 0)
	{
		UntereGrenze = 0;
	}

	// Zufallsgenerator initialisieren, wenn gefordert
	if (UseSeed == 1 && ErsterLauf == 0)
	{
		random((uint32_t)time(NULL));
		ErsterLauf = 1;
	}
	else if (UseSeed == 2 && ErsterLauf == 0)
	{
		random(SeedNumber);
		ErsterLauf = 1;
	}
	
	Zufallszahl = UntereGrenze + random(0) % (ObereGrenze - UntereGrenze + 1);
	
	return Zufallszahl;
}