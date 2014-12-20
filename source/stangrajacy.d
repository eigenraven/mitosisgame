module stangrajacy;

import imps;

class StanGrajacy : StanGry
{
	Button[string] btns;
	
	public this()
	{
		// hacks{
		BASS_Free();
		if(!BASS_Init(-1,48000,0,null,null))throw new Error(text(BASS_ErrorGetCode()));
		// }hacks

	}
	
	public void free()
	{
	}
	
	public StanGry update(double dt, sfRenderWindow* rwin)
	{
		return this;
	}
	
	public void render(sfRenderWindow* rwin)
	{
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

