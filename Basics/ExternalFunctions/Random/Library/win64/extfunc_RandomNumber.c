/*******************************************
* Funktion für Modelica, die Zufallszahlen zurückliefert.
* Weitere mögliche Funktionen sind WELL Algorithmus: http://de.wikipedia.org/wiki/Well_Equidistributed_Long-period_Linear
* Mersenne-Twister / TT800: http://de.wikipedia.org/wiki/Mersenne-Twister
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
long random2 (long init)
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

// KISS implementierung
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
int extfunc_RandomNumberOld(int UseSeed, int SeedNumber, int MaxNumber, int MinNumber)
{
	int Zufallszahl = 0; // Speichert die generierte Zufallszahl 
	int ObereGrenze = MaxNumber; // Speichert die obere Grenze des geforderten Zahlenraums
	int UntereGrenze = MinNumber; // Speichert die untere Grenze des geforderten Zahlenraum
	int count = MaxNumber - MinNumber + 1;
	static int ErsterLauf = 0;	

	// Defaultbedingungen setzen
	if (ObereGrenze == 0)
	{
		ObereGrenze = 10;
	}
	if (UntereGrenze == 0)
	{
		UntereGrenze = 0;
	}



	// Zufallsgenerator initialisieren, wenn gefordert
	if (UseSeed == 1 && ErsterLauf == 0)
	{
		srand((int)time(NULL));
		ErsterLauf = 1;
	}
	else if (UseSeed == 2 && ErsterLauf == 0)
	{
		srand(SeedNumber);
		ErsterLauf = 1;
	}

	if (count == 2 || count == 4 || count == 8 ||
          count == 16 || count == 32 || count == 64 ||
          count == 128 || count == 256 || count == 512 ||
          count == 1024 || count == 2048 || count == 4096 ||
          count == 8192 || count == 16384)
	{
		Zufallszahl = UntereGrenze + rand() % (ObereGrenze - UntereGrenze + 1);
	}
	else
	{
		int Berechnungsgrenze = (RAND_MAX / count) * count;
		do
		{
			Zufallszahl = rand();
		} while (Zufallszahl > Berechnungsgrenze);
		Zufallszahl = UntereGrenze + Zufallszahl % (ObereGrenze - UntereGrenze + 1);
	}
	
	return Zufallszahl;
}


int main123(void)
{
	uint32_t zahl = 0;
	int i = 0;
	int a = 0;
	for (i = 0; i < 20; i++)
	{
		//zahl = extfunc_randomnumber(1,-110,1000,0);
		zahl = extfunc_RandomNumber(1,0,1000,0);
		//zahl = random(0);
		printf(" Zahl: %d", zahl);
		printf("\n");
	}
	//printf("\n Test: %u \n", sizeof(long long));
	//printf(" Random %i", RAND_MAX);
	system("Pause");

	return 0;
}