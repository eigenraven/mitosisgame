module app;
import std.stdio, std.string;
import derelict.sfml2.system;
import derelict.sfml2.window;
import derelict.sfml2.audio;
import derelict.sfml2.graphics;
import derelict.opengl3.gl3; // Opengl

public enum WindowWidth = 800;
public enum WindowHeight = 600;
public enum WindowTitle = "Mitosis - Cellionaires";
public sfRenderWindow* rwin;

void main()
{
	DerelictGL3.load();
	DerelictSFML2System.load();
	DerelictSFML2Window.load();
	DerelictSFML2Audio.load();
	DerelictSFML2Graphics.load();
	sfVideoMode vm = sfVideoMode_getDesktopMode();
	vm.width=WindowWidth;
	vm.height=WindowHeight;
	rwin = sfRenderWindow_create(vm,toStringz(WindowTitle),sfTitlebar|sfClose,null);
	sfRenderWindow_setFramerateLimit(rwin,120);
	sfRenderWindow_setVerticalSyncEnabled(rwin,sfTrue);
	while(sfRenderWindow_isOpen(rwin))
	{
		sfRenderWindow_clear(rwin,sfColor(0,0,0,255));
		sfEvent* ev = new sfEvent();
		while(sfRenderWindow_pollEvent(rwin,ev))
		{
			switch(ev.type)
			{
				case sfEvtClosed:
					sfRenderWindow_close(rwin);break;
				default:break;
			}
		}
		sfRenderWindow_display(rwin);
	}
	sfRenderWindow_destroy(rwin);
	return;
}
