module util;
import imps;

alias void delegate(float,float) BtnCallback;

public sfRenderStates *rendMode;
public sfVector2f mouseCoord;

class Button
{
	public string name;
	public sfFloatRect* location;
	public sfRectangleShape* shape;
	public sfTexture* texture;
	public BtnCallback onClick;

	public this(string name="przycisk", float x=0, float y=0, float w=32, float h=32, sfTexture* tex=null, BtnCallback click=null)
	{
		this.name=name;
		this.location = new sfFloatRect();
		this.location.left=x;
		this.location.top=y;
		this.location.width=w;
		this.location.height=h;
		this.shape = sfRectangleShape_create();
		this.texture = tex;
		this.onClick = click;
		this.UpdateShape();
	}

	~this()
	{
		sfRectangleShape_destroy(shape);
	}

	public bool Clicked(float x, float y)
	{
		return (sfFloatRect_contains(location,x,y)==sfTrue);
	}

	public void UpdateShape()
	{
		this.shape.sfRectangleShape_setPosition(sfVector2f(this.location.left,this.location.top));
		this.shape.sfRectangleShape_setSize(sfVector2f(this.location.width,this.location.height));
		if(texture is null)
		{
			//this.shape.sfRectangleShape_setTexture(null,false);
			this.shape.sfRectangleShape_setFillColor(sfWhite);
			this.shape.sfRectangleShape_setOutlineColor(sfTransparent);
			this.shape.sfRectangleShape_setOutlineThickness(1f);
		}
		else
		{
			this.shape.sfRectangleShape_setTexture(texture,true);
			this.shape.sfRectangleShape_setFillColor(sfWhite);
			this.shape.sfRectangleShape_setOutlineColor(sfTransparent);
			this.shape.sfRectangleShape_setOutlineThickness(1f);
		}
	}

	public void Draw(sfRenderWindow* win)
	{
		if(Clicked(mouseCoord.x,mouseCoord.y))this.shape.sfRectangleShape_setOutlineColor(sfRed);
		else this.shape.sfRectangleShape_setOutlineColor(sfBlack);
		sfRenderWindow_drawRectangleShape(win,shape,rendMode);
	}

	public void RunCallback()
	{
		if(onClick != null)onClick(mouseCoord.x,mouseCoord.y);
	}
}

interface StanGry
{
	StanGry update(double dt, sfRenderWindow* rwin);
	void render(sfRenderWindow* rwin);
	void free();
	void onevent(sfRenderWindow* rwin, sfEvent* ev);
}

class FreeObj(T,alias freefun)
{
	public T o;
	~this()
	{
		freefun(o);
	}
}
