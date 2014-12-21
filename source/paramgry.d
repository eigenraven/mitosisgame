module paramgry;

class Pytanie
{
	string pytanie;
	string[4] odp;
	int dobra;
}

class ParametryGry
{
	public
	{
		// Podstawowe
		long Ecells = 0;
		long ATP = 5;
		long IleByloPyt = 1; // Zeby nie bylo / przez 0
		long IleDobrzePyt = 1;
		// Pytania
		Pytanie[] remQuests;
		Pytanie[] origQuests;
		// Upgradey
		long lvlDivSpeed = 1;
		long lvlAtpPerAns = 1;
	}

	this()
	{
	}

	~this()
	{
	}

}

