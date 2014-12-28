module paramgry;

class Pytanie
{
	public this(string Q, string[4] A, int ok)
	{
		pytanie = Q;
		odp = A.dup;
		dobra = ok;
	}
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
		Pytanie curQuest;
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

