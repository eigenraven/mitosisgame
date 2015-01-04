module stangrajacy;

import imps;

class StanGrajacy : StanGry
{
	Button[string] btns;
	ParametryGry stan;
	Random rand;
	sfSprite* BG;
	sfTexture* BG_tex, AnsTex;
	Audio music;

	/// Random [a..b]
	public double RD(double a, double b)
	{
		return uniform(a,b,rand);
	}

	protected void ParseQs()
	{
		import f=std.file;
		string Qfile = f.readText("pytania.txt").strip;
		enforce(Qfile.length>9,"Za krotki plik 'pytania.txt'!");
		auto LLA = splitLines(Qfile);
		for(int i=0;i<LLA.length;i+=5)
		{
			string Q = LLA[i];
			string As[4]= LLA[i+1..i+5];
			enforce(Q[0]=='%');
			int numm, numc,CA;
			for(int j=0;j<4;j++)
			{
				if(As[j][0]=='-')numm++;
				else if(As[j][0]=='='){numc++;CA=j;}
				else enforce(0,"Zly 1. znak pytania (musi byc =/-)");
				As[j] = As[j][2..$].strip;
			}
			enforce( (numm==3)&&(numc==1) ,"Zly zestaw odpowiedzi do pytania w linii %d".format(i+1));
			stan.origQuests.length++;
			stan.origQuests[$-1] = new Pytanie(Q,As,CA);
		}
		stan.remQuests = stan.origQuests.dup;
	}

	public this()
	{
		stan = new ParametryGry();
		ParseQs();
		BG_tex = sfTexture_createFromFile("res/gamebg.png",null);
		AnsTex = sfTexture_createFromFile("res/answerbtn.png",null);
		BG = sfSprite_create();
		sfSprite_setTexture(BG,BG_tex,sfTrue);

		music = new Audio("res/gamemusic.ogg");
		music.Loop = true;
		music.Play();

		btns["ans1"] = new Button("Ans1",8,500,380,36,AnsTex,&OnClickAns!(0));
		sfRectangleShape_setTextureRect(btns["ans1"].shape,sfIntRect(0,0,380,36));
		btns["ans2"] = new Button("Ans1",400,500,380,36,AnsTex,&OnClickAns!(1));
		sfRectangleShape_setTextureRect(btns["ans2"].shape,sfIntRect(0,0,380,36));
		btns["ans3"] = new Button("Ans1",8,540,380,36,AnsTex,&OnClickAns!(2));
		sfRectangleShape_setTextureRect(btns["ans3"].shape,sfIntRect(0,0,380,36));
		btns["ans4"] = new Button("Ans1",400,540,380,36,AnsTex,&OnClickAns!(3));
		sfRectangleShape_setTextureRect(btns["ans4"].shape,sfIntRect(0,0,380,36));
	}
	
	public void free()
	{
		music.Stop();
	}
	
	public StanGry update(double dt, sfRenderWindow* rwin)
	{
		return this;
	}

	public void OnClickAns(int i)(float x, float y)
	{

	}

	public void NextQuestion()
	{
		int ei;
		ei = cast(int)(floor(RD(0.0,stan.remQuests.length+0.8)));
		Pytanie P = stan.remQuests[ei];
		stan.remQuests[ei] = stan.remQuests[$-1];
		stan.remQuests.length--;
		P.odp.randomShuffle!(string[],Random)(rand);
		stan.curQuest=P;
		//TODO: Aktual. sf::RectangleShape
		//...
	}

	public void render(sfRenderWindow* rwin)
	{
		sfRenderWindow_drawSprite(rwin,BG,null);
		foreach(Button B; btns)
		{
			B.Draw(rwin);
		}
	}
	
	public void onevent(sfRenderWindow* rwin, sfEvent* ev)
	{
		if(ev.type == sfEvtMouseButtonPressed)
		{
			foreach(Button B; btns)
			{
				if(B.Clicked(mouseCoord.x,mouseCoord.y))
				{
					B.RunCallback();
				}
			}
		}
	}
}

