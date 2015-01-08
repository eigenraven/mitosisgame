module stangrajacy;

import imps;

enum int FONT_SIZE = 20;
enum int FONTB_SIZE = 24;
enum int FONTU_SIZE = 16;

sfColor darkGreen = sfColor(0,90,0,255);
sfColor darkRed = sfColor(90,0,0,255);

string LogName;

class StanGrajacy : StanGry
{
	Button[string] btns;
	Timer qTimer;
	ParametryGry stan;
	Random rand;
	sfSprite* BG;
	sfSprite*[8] Cells;
	sfTexture* BG_tex, AnsTex, CellTex;
	sfFont* Fnt,FntB;
	sfText* Qtext, CellNtext, ATPtext, CellStats;
	sfRectangleShape* Rok,Rbad;
	Audio music, sndGood, sndBad, sndSplit;
	StopWatch Cwatch;
	bool LockQ=false;
	long pcells=-100;

	/// Random [a..b]
	public double RD(double a, double b)
	{
		return uniform(a,b);
	}

	public sfText* mkText(sfFont* font, sfColor color, string str, int charSize, sfVector2f pos)
	{
		sfText* tmp = sfText_create();
		sfText_setFont(tmp,font);
		sfText_setColor(tmp,color);
		sfText_setString(tmp,str.toStringz);
		sfText_setCharacterSize(tmp,charSize);
		sfText_setPosition(tmp,pos);
		return tmp;
	}

	public this()
	{
		LogName = "loggry-"~Clock.currTime().toISOString()~".log";
		F.write(LogName, "--- Cellionaires Log ---");
		stan = new ParametryGry();
		ParseQs();
		BG_tex = sfTexture_createFromFile("res/gamebg.png".toStringz(),null);
		AnsTex = sfTexture_createFromFile("res/answerbtn.png".toStringz(),null);
		CellTex= sfTexture_createFromFile("res/cell.png".toStringz(),null);
		BG = sfSprite_create();
		sfSprite_setTexture(BG,BG_tex,sfTrue);
		Fnt = sfFont_createFromFile("res/font.ttf".toStringz());
		FntB = sfFont_createFromFile("res/bigfont.ttf".toStringz());
		
		for(int i=0;i<8;i++)
		{
			Cells[i] = sfSprite_create();
			sfSprite_setTexture(Cells[i],CellTex,sfTrue);
			sfSprite_setTextureRect(Cells[i],sfIntRect(0,0,128,128));
			sfSprite_setOrigin(Cells[i],sfVector2f(64,64));
			sfSprite_setPosition(Cells[i],sfVector2f(100+ (i%3)*160,90+ (i/3)*120));
			sfSprite_setScale(Cells[i],sfVector2f(1.0f,1.0f));
		}
		
		music = new Audio("res/gamemusic.ogg");
		music.Loop = true;
		music.Play();
		sndGood = new Audio("res/dob_odp.ogg");
		sndBad = new Audio("res/zla_odp.ogg");
		sndSplit = new Audio("res/podzial.ogg");
		
		btns["ans1"] = new Button("Ans1",8,500,380,36,AnsTex,&OnClickAns!(0));
		btns["ans1"].text = mkText(Fnt,sfWhite,"???",FONT_SIZE,sfVector2f(16,502));
		btns["ans2"] = new Button("Ans2",400,500,380,36,AnsTex,&OnClickAns!(1));
		btns["ans2"].text = mkText(Fnt,sfWhite,"???",FONT_SIZE,sfVector2f(408,502));
		btns["ans3"] = new Button("Ans3",8,540,380,36,AnsTex,&OnClickAns!(2));
		btns["ans3"].text = mkText(Fnt,sfWhite,"???",FONT_SIZE,sfVector2f(16,542));
		btns["ans4"] = new Button("Ans4",400,540,380,36,AnsTex,&OnClickAns!(3));
		btns["ans4"].text = mkText(Fnt,sfWhite,"???",FONT_SIZE,sfVector2f(408,542));
		Qtext = mkText(Fnt,sfWhite,"QQQ???QQQ",FONT_SIZE,sfVector2f(16,465));

		btns["upg1"] = new Button("ATPmag",535,15,240,103,null,&stan.ATPmagnet);
		btns["upg1"].text = mkText(FntB,sfWhite,"Lv99",FONTU_SIZE,sfVector2f(715,18));
		btns["upg1"].text2= mkText(FntB,sfWhite,"123 ATP",FONTU_SIZE,sfVector2f(554,18));
		btns["upg2"] = new Button("ATPboost",535,126,240,103,null,&stan.ATPboost);
		btns["upg2"].text = mkText(FntB,sfWhite,"Lv99",FONTU_SIZE,sfVector2f(715,127));
		btns["upg2"].text2= mkText(FntB,sfWhite,"123 ATP",FONTU_SIZE,sfVector2f(552,127));
		btns["upg3"] = new Button("Mitochondria",535,237,240,103,null,&stan.Mitochondria);
		btns["upg3"].text = mkText(FntB,sfWhite,"Lv99",FONTU_SIZE,sfVector2f(715,238));
		btns["upg3"].text2= mkText(FntB,sfWhite,"123 ATP",FONTU_SIZE,sfVector2f(582,238));
		btns["upg4"] = new Button("MitoPlus",535,348,240,103,null,&stan.MitochondriaPlus);
		btns["upg4"].text = mkText(FntB,sfWhite,"Lv99",FONTU_SIZE,sfVector2f(715,348));
		btns["upg4"].text2= mkText(FntB,sfWhite,"123 ATP",FONTU_SIZE,sfVector2f(582,348));

		CellNtext = mkText(FntB,sfWhite,"? CELLS",FONTB_SIZE,sfVector2f(210,410));
		ATPtext = mkText(FntB,sfWhite,"? ATP",FONTB_SIZE,sfVector2f(16,400));
		CellStats = mkText(Fnt,sfWhite,"-",14,sfVector2f(0,0));

		Rok = sfRectangleShape_create();
		Rbad= sfRectangleShape_create();
		sfRectangleShape_setPosition(Rok , sfVector2f(8,493));
		sfRectangleShape_setPosition(Rbad, sfVector2f(8,493));
		sfRectangleShape_setFillColor(Rok , darkGreen);
		sfRectangleShape_setFillColor(Rbad, darkRed);
		sfRectangleShape_setSize(Rok ,sfVector2f(800-24,6));
		sfRectangleShape_setSize(Rbad,sfVector2f(800-24,6));

		qTimer = new Timer(3,null);
		qTimer.Active=false;

		NextQuestion();
		Cwatch.start();
		Cwatch.reset();
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
			stan.origQuests[$-1] = new Pytanie(Q[2..$],As,CA);
		}
		stan.remQuests = stan.origQuests.dup;
	}
	
	public void free()
	{
		music.Stop();
	}
	
	public StanGry update(double dt, sfRenderWindow* rwin)
	{
		if(pcells!=stan.Ecells)
		{
			pcells = stan.Ecells;
			string K = "cells-stage%d".format(min(pcells,3));
			enum float XOFF = 258;
			enum float YOFF = 210;
			for(char I='0';I<'8';I++)
			{
				float XV = cfg.intValue(K,"Cell%c-X".format(I));
				float YV = cfg.intValue(K,"Cell%c-Y".format(I));
				float AV = cfg.intValue(K,"Cell%c-A".format(I));
				sfSprite_setPosition(Cells[I-'0'], sfVector2f(XOFF+XV,YOFF+YV));
				sfSprite_setRotation(Cells[I-'0'], AV);
			}
		}
		qTimer.Update();
		sfText_setString(CellNtext, "%d CELLS".format(stan.Ecells).toStringz());
		sfText_setString(ATPtext, "%3d ATP".format(stan.ATP).toStringz());
		if(stan.ATP<stan.FrameCost)
		{
			sfText_setColor(ATPtext,sfRed);
		}
		else
		{
			sfText_setColor(ATPtext,sfWhite);
		}
		sfText_setString(btns["upg1"].text, "Lv%2d".format(stan.lvlAtpPerDiv).toStringz());
		sfText_setString(btns["upg2"].text, "Lv%2d".format(stan.lvlAtpPerAns).toStringz());
		sfText_setString(btns["upg3"].text, "Lv%2d".format(stan.lvlDivSpeed).toStringz());
		sfText_setString(btns["upg4"].text, "Lv%2d".format(stan.lvlDivSpeedPlus).toStringz());
		sfText_setString(btns["upg1"].text2,"%3d ATP".format(stan.costATPmagnet).toStringz());
		sfText_setString(btns["upg2"].text2,"%3d ATP".format(stan.costATPboost).toStringz());
		sfText_setString(btns["upg3"].text2,"%3d ATP".format(stan.costMito).toStringz());
		sfText_setString(btns["upg4"].text2,"%3d ATP".format(stan.costMitoPlus).toStringz());
		sfText_setString(CellStats, "M.Cost: %3d ATP ; M.Length: %f".format(stan.FrameCost2,stan.FrameDur*16).toStringz());
		sfRectangleShape_setScale(Rok, sfVector2f(cast(float)(stan.IleDobrzePyt)/stan.IleByloPyt,1.0f));
		if((Cwatch.peek.msecs/1000.0)>=stan.FrameDur)
		{
			if(stan.ATP>=stan.FrameCost)
			{
				stan.NextFrame();
				auto R = sfIntRect(cast(int)((stan.CellFrame/8)*128),cast(int)((stan.CellFrame%8)*128),128,128);
				for(int i=0;i<8;i++)
				{
					sfSprite_setTextureRect(Cells[i],R);
				}
				if(stan.CellFrame==0)sndSplit.Play();
			}
			Cwatch.reset();
		}
		
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
			btns["ans"~text(i+1)].text.sfText_setColor(darkGreen);
			stan.IleDobrzePyt++;
			stan.AddQuestionATP();
			sndGood.Play();
		}
		else
		{
			// Zla odp. - nic nie rob
			sfRectangleShape_setTextureRect(btns["ans1"].shape,sfIntRect(0,(D==0)?(36):(72),380,36));
			sfRectangleShape_setTextureRect(btns["ans2"].shape,sfIntRect(0,(D==1)?(36):(72),380,36));
			sfRectangleShape_setTextureRect(btns["ans3"].shape,sfIntRect(0,(D==2)?(36):(72),380,36));
			sfRectangleShape_setTextureRect(btns["ans4"].shape,sfIntRect(0,(D==3)?(36):(72),380,36));
			btns["ans"~text(i+1)].text.sfText_setColor(darkRed);
			sndBad.Play();
		}
		F.append(LogName, "\n>> Nowa odpowiedz - %s\n> %s\n> %s\n".format((i==D)?("OK"):("zla"),stan.curQuest.pytanie,stan.curQuest.odp[i]));
		qTimer.Reset(1.0,&this.NextQuestion);
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
		btns["ans1"].text.sfText_setString(toStringz("------"));
		btns["ans2"].text.sfText_setString(toStringz("------"));
		btns["ans3"].text.sfText_setString(toStringz("------"));
		btns["ans4"].text.sfText_setString(toStringz("------"));
		Qtext.sfText_setString(toStringz(P.pytanie));
		qTimer.Reset(1,&this.DispAnswers);
	}

	public void DispAnswers()
	{
		auto P = stan.curQuest;
		btns["ans1"].text.sfText_setString(toStringz(P.odp[0]));
		btns["ans2"].text.sfText_setString(toStringz(P.odp[1]));
		btns["ans3"].text.sfText_setString(toStringz(P.odp[2]));
		btns["ans4"].text.sfText_setString(toStringz(P.odp[3]));
		LockQ = false;
		qTimer.Active = false;
	}

	public void render(sfRenderWindow* rwin)
	{
		sfRenderWindow_drawSprite(rwin,BG,null);
		sfRenderWindow_drawText(rwin,Qtext,null);
		sfRenderWindow_drawText(rwin,ATPtext,null);
		sfRenderWindow_drawText(rwin,CellNtext,null);
		sfRenderWindow_drawText(rwin,CellStats,null);
		
		sfRenderWindow_drawSprite(rwin,Cells[0],null);
		if(stan.Ecells>=1)
		{
			sfRenderWindow_drawSprite(rwin,Cells[1],null);
		}
		if(stan.Ecells>=2)
		{
			sfRenderWindow_drawSprite(rwin,Cells[2],null);
			sfRenderWindow_drawSprite(rwin,Cells[3],null);
		}
		if(stan.Ecells>=3)
		{
			sfRenderWindow_drawSprite(rwin,Cells[4],null);
			sfRenderWindow_drawSprite(rwin,Cells[5],null);
			sfRenderWindow_drawSprite(rwin,Cells[6],null);
			sfRenderWindow_drawSprite(rwin,Cells[7],null);
		}

		sfRenderWindow_drawRectangleShape(rwin,Rbad,null);
		sfRenderWindow_drawRectangleShape(rwin,Rok ,null);
		
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
		else if(ev.type == sfEvtKeyPressed)
		{
			if(ev.key.code==sfKeyAdd)
			{
				stan.ATP += 10;
			}
			else if(ev.key.code==sfKeySubtract)
			{
				stan.ATP -= 9;
			}
			else if(ev.key.code==sfKeyO)
			{
				stan.Ecells++;
			}
			else if(ev.key.code==sfKeyL)
			{
				stan.Ecells--;
			}
		}
	}
}

