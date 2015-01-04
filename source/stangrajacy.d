module stangrajacy;

import imps;

enum int FONT_SIZE = 18;

class StanGrajacy : StanGry
{
	Button[string] btns;
	Timer qTimer;
	ParametryGry stan;
	Random rand;
	sfSprite* BG;
	sfTexture* BG_tex, AnsTex;
	sfFont* Fnt;
	sfText* Qtext;
	Audio music;
	bool LockQ=false;

	/// Random [a..b]
	public double RD(double a, double b)
	{
		return uniform(a,b,rand);
	}

	public this()
	{
		stan = new ParametryGry();
		ParseQs();
		BG_tex = sfTexture_createFromFile("res/gamebg.png".toStringz(),null);
		AnsTex = sfTexture_createFromFile("res/answerbtn.png".toStringz(),null);
		BG = sfSprite_create();
		sfSprite_setTexture(BG,BG_tex,sfTrue);
		Fnt = sfFont_createFromFile("res/font.ttf".toStringz());
		
		music = new Audio("res/gamemusic.ogg");
		music.Loop = true;
		music.Play();
		
		btns["ans1"] = new Button("Ans1",8,500,380,36,AnsTex,&OnClickAns!(0));
		btns["ans1"].text = sfText_create();
		btns["ans1"].text.sfText_setFont(Fnt);
		btns["ans1"].text.sfText_setColor(sfWhite);
		btns["ans1"].text.sfText_setString(toStringz("???"));
		btns["ans1"].text.sfText_setCharacterSize(FONT_SIZE);
		btns["ans1"].text.sfText_setPosition(sfVector2f(16,502));
		btns["ans2"] = new Button("Ans1",400,500,380,36,AnsTex,&OnClickAns!(1));
		btns["ans2"].text = sfText_create();
		btns["ans2"].text.sfText_setFont(Fnt);
		btns["ans2"].text.sfText_setColor(sfWhite);
		btns["ans2"].text.sfText_setString(toStringz("???"));
		btns["ans2"].text.sfText_setCharacterSize(FONT_SIZE);
		btns["ans2"].text.sfText_setPosition(sfVector2f(408,502));
		btns["ans3"] = new Button("Ans1",8,540,380,36,AnsTex,&OnClickAns!(2));
		btns["ans3"].text = sfText_create();
		btns["ans3"].text.sfText_setFont(Fnt);
		btns["ans3"].text.sfText_setColor(sfWhite);
		btns["ans3"].text.sfText_setString(toStringz("???"));
		btns["ans3"].text.sfText_setCharacterSize(FONT_SIZE);
		btns["ans3"].text.sfText_setPosition(sfVector2f(16,542));
		btns["ans4"] = new Button("Ans1",400,540,380,36,AnsTex,&OnClickAns!(3));
		btns["ans4"].text = sfText_create();
		btns["ans4"].text.sfText_setFont(Fnt);
		btns["ans4"].text.sfText_setColor(sfWhite);
		btns["ans4"].text.sfText_setString(toStringz("???"));
		btns["ans4"].text.sfText_setCharacterSize(FONT_SIZE);
		btns["ans4"].text.sfText_setPosition(sfVector2f(408,542));
		Qtext = sfText_create();
		Qtext.sfText_setFont(Fnt);
		Qtext.sfText_setColor(sfWhite);
		Qtext.sfText_setString(toStringz("QQQ???QQQ"));
		Qtext.sfText_setCharacterSize(FONT_SIZE);
		Qtext.sfText_setPosition(sfVector2f(16,470));
		
		qTimer = new Timer(3,null);
		qTimer.Active=false;

		NextQuestion();
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
	
	public void free()
	{
		music.Stop();
	}
	
	public StanGry update(double dt, sfRenderWindow* rwin)
	{
		qTimer.Update(dt);
		return this;
	}

	public void OnClickAns(int i)(float x, float y)
	{
		if(LockQ)return;
		LockQ=true;
		auto D = stan.curQuest.dobra;
		stan.IleByloPyt++;
		if(i == D)
		{
			// Dobra odp. - dodaj ATP
			sfRectangleShape_setTextureRect(btns["ans1"].shape,sfIntRect(0,(i==0)?(36):(72),380,36));
			sfRectangleShape_setTextureRect(btns["ans2"].shape,sfIntRect(0,(i==1)?(36):(72),380,36));
			sfRectangleShape_setTextureRect(btns["ans3"].shape,sfIntRect(0,(i==2)?(36):(72),380,36));
			sfRectangleShape_setTextureRect(btns["ans4"].shape,sfIntRect(0,(i==3)?(36):(72),380,36));
			btns["ans"~text(i+1)].text.sfText_setColor(sfCyan);
			stan.IleDobrzePyt++;
			stan.AddQuestionATP();
		}
		else
		{
			// Zla odp. - nic nie rob
			sfRectangleShape_setTextureRect(btns["ans1"].shape,sfIntRect(0,(D==0)?(36):(72),380,36));
			sfRectangleShape_setTextureRect(btns["ans2"].shape,sfIntRect(0,(D==1)?(36):(72),380,36));
			sfRectangleShape_setTextureRect(btns["ans3"].shape,sfIntRect(0,(D==2)?(36):(72),380,36));
			sfRectangleShape_setTextureRect(btns["ans4"].shape,sfIntRect(0,(D==3)?(36):(72),380,36));
			btns["ans"~text(i+1)].text.sfText_setColor(sfMagenta);
		}
		qTimer.Reset(3.0,&this.NextQuestion);
	}

	public void NextQuestion()
	{
		if(stan.remQuests.length==0)
		{
			stan.remQuests = stan.origQuests.dup;
		}
		int ei;
		ei = cast(int)(floor(RD(0.0,stan.remQuests.length-0.9)));
		Pytanie P = stan.remQuests[ei];
		stan.remQuests[ei] = stan.remQuests[$-1];
		stan.remQuests.length--;
		string db = P.odp[P.dobra];
		P.odp.randomShuffle!(string[],Random)(rand);
		if(P.odp[0]==db)
			P.dobra=0;
		if(P.odp[1]==db)
			P.dobra=1;
		if(P.odp[2]==db)
			P.dobra=2;
		if(P.odp[3]==db)
			P.dobra=3;
		stan.curQuest=P;
		sfRectangleShape_setTextureRect(btns["ans1"].shape,sfIntRect(0,0,380,36));
		sfRectangleShape_setTextureRect(btns["ans2"].shape,sfIntRect(0,0,380,36));
		sfRectangleShape_setTextureRect(btns["ans3"].shape,sfIntRect(0,0,380,36));
		sfRectangleShape_setTextureRect(btns["ans4"].shape,sfIntRect(0,0,380,36));
		btns["ans1"].text.sfText_setColor(sfWhite);
		btns["ans2"].text.sfText_setColor(sfWhite);
		btns["ans3"].text.sfText_setColor(sfWhite);
		btns["ans4"].text.sfText_setColor(sfWhite);
		btns["ans1"].text.sfText_setString(toStringz(P.odp[0]));
		btns["ans2"].text.sfText_setString(toStringz(P.odp[1]));
		btns["ans3"].text.sfText_setString(toStringz(P.odp[2]));
		btns["ans4"].text.sfText_setString(toStringz(P.odp[3]));
		Qtext.sfText_setString(toStringz(P.pytanie));
		LockQ = false;
		qTimer.Active = false;
	}

	public void render(sfRenderWindow* rwin)
	{
		sfRenderWindow_drawSprite(rwin,BG,null);
		sfRenderWindow_drawText(rwin,Qtext,null);
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

