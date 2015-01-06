module paramgry;

import std.math, std.algorithm, std.stdio;

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
		long CellFrame = 0;
		long CellFrames = 16;
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
	
	public void NextFrame()
	{
		//writeln(FrameCost);
		if(ATP>=FrameCost)
		{
			ATP-=FrameCost;
		}
		CellFrame++;
		if(CellFrame == CellFrames){Ecells++;CellFrame=0;}
	}
	
	public @property long FrameCost()
	{
		if((CellFrame%8)!=0)return 0;
		return cast(long)max(1.0,3.0 - lvlAtpPerDiv.pow(0.7) + lvlDivSpeed.pow(1.1) + lvlDivSpeedPlus.pow(1.4) + Ecells.pow(0.5));
	}

	public @property long FrameCost2()
	{
		return cast(long)max(1.0,3.0 - lvlAtpPerDiv.pow(0.7) + lvlDivSpeed.pow(1.1) + lvlDivSpeedPlus.pow(1.4) + Ecells.pow(0.5));
	}

	public @property double FrameDur()
	{
		return max(0.1, 4.0 - (lvlDivSpeed/12.0) - (lvlDivSpeedPlus/4.0));
	}
	
	public void AddQuestionATP()
	{
		ATP += lvlAtpPerAns;
	}

	public void ATPmagnet(float x, float y)
	{
		if(ATP>=costATPmagnet)
		{
			ATP -= costATPmagnet;
			lvlAtpPerDiv++;
		}
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
		if(ATP>=costMito)
		{
			ATP -= costMito;
			lvlDivSpeed++;
		}
	}

	public void MitochondriaPlus(float x, float y)
	{
		if(ATP>=costMitoPlus)
		{
			ATP -= costMitoPlus;
			lvlDivSpeedPlus++;
		}
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

