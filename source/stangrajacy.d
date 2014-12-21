module stangrajacy;

import imps;

class StanGrajacy : StanGry
{
	Button[string] btns;
	ParametryGry stan;
	Random rand;
	sfSprite* BG;
	sfTexture* BG_tex, AnsTex;

	/// Random [a..b]
	public double RD(double a, double b)
	{
		return uniform(a,b,rand);
	}

	public this()
	{
		stan = new ParametryGry();
		BG_tex = sfTexture_createFromFile("res/gamebg.png",null);
		AnsTex = sfTexture_createFromFile("res/answerbtn.png",null);
		BG = sfSprite_create();
		sfSprite_setTexture(BG,BG_tex,sfTrue);

		btns["ans1"] = new Button("Ans1",8,500,380,36,AnsTex,null);
		sfRectangleShape_setTextureRect(btns["ans1"].shape,sfIntRect(0,0,380,36));
		btns["ans2"] = new Button("Ans1",400,500,380,36,AnsTex,null);
		sfRectangleShape_setTextureRect(btns["ans2"].shape,sfIntRect(0,36,380,36));
		btns["ans3"] = new Button("Ans1",8,540,380,36,AnsTex,null);
		sfRectangleShape_setTextureRect(btns["ans3"].shape,sfIntRect(0,72,380,36));
		btns["ans4"] = new Button("Ans1",400,540,380,36,AnsTex,null);
		sfRectangleShape_setTextureRect(btns["ans4"].shape,sfIntRect(0,0,380,36));
	}
	
	public void free()
	{
	}
	
	public StanGry update(double dt, sfRenderWindow* rwin)
	{
		return this;
	}

	public void NextQuestion()
	{

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

