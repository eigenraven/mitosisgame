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
	HSTREAM music;

	public this()
	{
		texBg = sfTexture_createFromFile("res/bgimg.png",null);
		texPlay = sfTexture_createFromFile("res/play.png",null);
		texQuit = sfTexture_createFromFile("res/quit.png",null);
		background = sfSprite_create();
		sfSprite_setTexture(background, texBg, sfFalse);
		music = BASS_StreamCreateFile(0,cast(void*)("res/menumusic.ogg\0".dup),0,0,BASS_SAMPLE_LOOP);
		BASS_ChannelPlay(music,1);
		BASS_ChannelSetAttribute(music,BASS_ATTRIB_VOL,0.7f);

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
		BASS_StreamFree(music);
	}

	void Quit(float x, float y)
	{
		sfRenderWindow_close(rwin);
	}

	void SwitchPlay(float x, float y)
	{
		BASS_ChannelStop(music);
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

