module app;
import imps;

public enum WindowWidth = 800;
public enum WindowHeight = 600;
public enum WindowTitle = "Mitosis - Cellionaires";
public sfRenderWindow* rwin;
public StanGry gstate,nstate;

void main()
{
	DerelictGL3.load();
	DerelictSFML2System.load();
	DerelictSFML2Window.load();
	DerelictSFML2Graphics.load();
	DerelictBASS.load();
	if(!BASS_Init(-1,48000,0,null,null))throw new Error(text(BASS_ErrorGetCode()));
	scope(exit)BASS_Free();
	BASS_SetVolume(1.0f);
	BASS_Start();
	sfVideoMode vm = sfVideoMode_getDesktopMode();
	vm.width=WindowWidth;
	vm.height=WindowHeight;
	vm.bitsPerPixel = 32;
	sfContextSettings *cs = new sfContextSettings();
	cs.depthBits=8;
	cs.majorVersion=1;
	cs.minorVersion=2;
	rendMode = new sfRenderStates();
	rendMode.blendMode = sfBlendAlpha;
	rwin = sfRenderWindow_create(vm,toStringz(WindowTitle),sfTitlebar|sfClose,cs);
	sfRenderWindow_setFramerateLimit(rwin,120);
	sfRenderWindow_setVerticalSyncEnabled(rwin,sfTrue);
	gstate = new StanMenu();
	sfClock *fclock;
	fclock = sfClock_create();
	double dt;
	nstate = gstate;
	while((gstate !is null) && (sfRenderWindow_isOpen(rwin)))
	{
		dt = sfTime_asSeconds(sfClock_restart(fclock));
		gstate.update(dt,rwin);
		if(nstate != gstate)
		{
			gstate = nstate;
			GC.collect();
			continue;
		}
		sfEvent* ev = new sfEvent();
		while(sfRenderWindow_pollEvent(rwin,ev))
		{
			switch(ev.type)
			{
				case sfEvtClosed:
					sfRenderWindow_close(rwin);break;
				default:break;
			}
			gstate.onevent(rwin,ev);
		}
		auto mpos = sfMouse_getPositionRenderWindow(rwin);
		mouseCoord.x = mpos.x;
		mouseCoord.y = mpos.y;
		sfRenderWindow_clear(rwin,sfMagenta);
		gstate.render(rwin);
		sfRenderWindow_display(rwin);
	}
	sfRenderWindow_destroy(rwin);
	return;
}
