module stanmenu;

import imps;

private shared bool didPlay = false;

class StanMenu : StanGry
{
	sfTexture* texBg;

	sfTexture* texPlay;
	sfTexture* texQuit;

	sfSprite* background;
	Button[string] btns;
	Audio music;

	public this()
	{
		texBg = sfTexture_createFromFile("res/bgimg.png",null);
		texPlay = sfTexture_createFromFile("res/play.png",null);
		texQuit = sfTexture_createFromFile("res/quit.png",null);
		background = sfSprite_create();
		sfSprite_setTexture(background, texBg, sfFalse);

		music = new Audio("res/menumusic.ogg");
		music.Loop = true;
		music.Play();

		// GUI
		btns["play"] = new Button("Play",250,250,300,64,texPlay,&this.SwitchPlay);
		btns["quit"] = new Button("Quit",250,350,300,64,texQuit,&this.Quit);
	}

	public void free()
	{
		sfSprite_destroy(background);
		sfTexture_destroy(texBg);
		sfTexture_destroy(texQuit);
		sfTexture_destroy(texPlay);
		music.Stop();
	}

	void Quit(float x, float y)
	{
		sfRenderWindow_close(rwin);
	}

	void SwitchPlay(float x, float y)
	{
		didPlay = true;
	}

	public StanGry update(double dt, sfRenderWindow* rwin)
	{
		if(didPlay)
		{
			return new StanGrajacy();
		}
		return this;
	}

	public void render(sfRenderWindow* rwin)
	{
		sfRenderWindow_drawSprite(rwin,background,rendMode);
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

