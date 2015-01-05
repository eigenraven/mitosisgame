module paramgry;

import std.math;

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
		long ATP = 10;
		long IleByloPyt = 1; // Zeby nie bylo / przez 0
		long IleDobrzePyt = 1;
		// Pytania
		Pytanie[] remQuests;
		Pytanie[] origQuests;
		Pytanie curQuest;
		// Upgradey
		long lvlDivSpeed = 1;
		long lvlDivSpeedPlus = 1;
		long lvlAtpPerAns = 1;
		long lvlAtpPerDiv = 1;
	}

	this()
	{
	}

	~this()
	{
	}

	public void AddQuestionATP()
	{
		ATP += cast(long)(pow(lvlAtpPerAns,0.7)+0.6);
	}

	public void ATPmagnet(float x, float y)
	{
	}

	public void ATPboost(float x, float y)
	{
		if(ATP>=costATPboost)
		{
			ATP -= costATPboost;
			lvlAtpPerAns++;
		}
	}

	public void Mitochondria(float x, float y)
	{
	}

	public void MitochondriaPlus(float x, float y)
	{
	}
	
	public @property long costATPmagnet()
	{
		return 10+2*cast(long)(lvlAtpPerDiv.pow(1.4));
	}
	
	public @property long costATPboost()
	{
		return 10+cast(long)(lvlAtpPerAns.pow(1.5));
	}
	
	public @property long costMito()
	{
		return 10+cast(long)(lvlDivSpeed.pow(1.6));
	}
	
	public @property long costMitoPlus()
	{
		return 10+cast(long)((lvlDivSpeedPlus*4).pow(1.75));
	}
}

