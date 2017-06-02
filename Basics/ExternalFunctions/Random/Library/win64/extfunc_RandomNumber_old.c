/*******************************************
* Funktion für Modelica, die Zufallszahlen zurückliefert.
*
*
*******************************************/

#include "extfunc_RandomNumber.h"


// Lewis, Goldman und Miller, 1969
// n = (a * n + c) % m
// a = 7^5 = 16807
// c = 0
// m = 2^31-1 = 2147483647
// http://computer.wer-weiss-was.de/c-cplusplus/zufalls-zahl-c
long random (long init)
{
    static long n = 1;
	int a = 16807;

    if (init>0)
	{
		n = init;
	}
    n = a * (n % 127773) - 2836 * (n / 127773);
    if (n<0)
	{
		n += 2147483647;
	}

    return n;
}

/****************************************
*
*
* 
* int UseSeed:				0: Kein Seed,
*							1: Benutze Systemzeit
*							2: Benutze feste Zahl SeedNumber
* int SeedNumber:			Zahl mit dem der Zufallsgenerator initialisiert wird. Für
*							reproduzierbare Ergebnisse
* int MaxNumber:			Maximale Zahl, die zurückgegeben wird.
*							Für Null wird die Systemeinstellung verwendet
* int MinNumber:			Maximale Zahl, die zurückgegeben wird.
*							Für Null wird die Systemeinstellung verwendet
****************************************/
long extfunc_RandomNumber(int UseSeed, long SeedNumber, long MaxNumber, long MinNumber)
{
	long Zufallszahl = 0; // Speichert die generierte Zufallszahl 
	long ObereGrenze = MaxNumber; // Speichert die obere Grenze des geforderten Zahlenraums
	long UntereGrenze = MinNumber; // Speichert die untere Grenze des geforderten Zahlenraum
	long count = MaxNumber - MinNumber + 1;
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
		random((long)time(NULL));
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