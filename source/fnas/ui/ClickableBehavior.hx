package fnas.ui;

import openfl.ui.MouseCursor;
import openfl.ui.Mouse;
import flixel.FlxG;

/**
 * Abstract class for creating clickable-like behavior
 * for any `FlxObject` that uses it.
 */
class ClickableBehavior
{
	/**
	 * Called when `this` clickable sprite is clicked on.
	 */
	public var onClick:Void->Void = () -> {};

	/**
	 * Called when `this` clickable sprite is hovered on.
	 */
	public var onHover:Void->Void = () -> {};

	/**
	 * Called when `this` clickable sprite's hover boundaries are no longer overlapping
	 * the mouse.
	 */
	public var onHoverLost:Void->Void = () -> {};

	/**
	 * X bounds for the *left* side of `this` clickable sprite.
	 */
	public var bxl:Float;

	/**
	 * X bounds for the *right* side of `this` clickable sprite.
	 */
	public var bxr:Float;

	/**
	 * Y bounds for the *top* side of `this` clickable sprite.
	 */
	public var byt:Float;

	/**
	 * Y bounds for the *bottom* side of `this` clickable sprite.
	 */
	public var byb:Float;

	/**
	 * Is `this` current clickable sprite being hovered on?
	 */
	public var isHovered:Bool = false;

	/**
	 * Is it allowed to click `this` sprite?
	 */
	public var canClick:Bool = true;

	/**
	 * Should `this` clickable sprite change to the pointer
	 * icon when hovered over?
	 */
	public var hoverMouseIcon:Bool = true;

	public function new() {}

	/**
	 * ...I don't think I have to explain this.
	 * 
	 * @param x      The X position of the object.
	 * @param y      The Y position of the object.
	 * @param width  The width of the object.
	 * @param height The height of the object.
	 */
	public function update(x:Float, y:Float, width:Float, height:Float):Void
	{
		if (isHoveringOverMouse() && canClick)
		{
			if (!isHovered)
			{
				onHover();
				if (hoverMouseIcon)
				{
					Mouse.cursor = MouseCursor.BUTTON;
				}
				isHovered = true;
			}
			if (FlxG.mouse.justPressed)
			{
				onClick();
			}
		}

		if (!isHoveringOverMouse() && isHovered)
		{
			isHovered = false;
			if (hoverMouseIcon)
			{
				Mouse.cursor = MouseCursor.ARROW;
			}
			onHoverLost();
		}
	}

	/**
	 * Gets `this` clickable sprite's hover bounds as an array.
	 * @return The hover bounds as an array.
	 */
	public inline function getHoverBoundsArray():Array<Float>
	{
		return [bxl, bxr, byt, byb];
	}

	/**
	 * Sets the ***X*** hover bounds.
	 * 
	 * @param bxl Left X hover bound.
	 * @param bxr Right X hover bound.
	 */
	public function setHoverBoundsX(bxl:Float, bxr:Float):Void
	{
		this.bxl = bxl;
		this.bxr = bxr;
	}

	/**
	 * Sets the ***Y*** hover bounds.
	 * 
	 * @param byt Top Y hover bound.
	 * @param byb Bottom Y hover bound.
	 */
	public function setHoverBoundsY(byt:Float, byb:Float):Void
	{
		this.byt = byt;
		this.byb = byb;
	}

	/**
	 * Sets the hover bounds for all four sides of `this`
	 * clickable sprite. 
	 * 
	 * @param bxl Left X hover bound.
	 * @param bxr Right X hover bound.
	 * @param byt Top Y hover bound.
	 * @param byb Bottom Y hover bound.
	 */
	public function setHoverBounds(bxl:Float, bxr:Float, byt:Float, byb:Float):Void
	{
		this.bxl = bxl;
		this.bxr = bxr;
		this.byt = byt;
		this.byb = byb;
	}

	/**
	 * Reset the hover bounds to match `this` clickable sprite's hitbox.
	 * 
	 * @param x      The X position of the object.
	 * @param y      The Y position of the object.
	 * @param width  The width of the object.
	 * @param height The height of the object.
	 */
	public function updateHoverBounds(x:Float, y:Float, width:Float, height:Float):Void
	{
		bxl = x;
		bxr = x + width;
		byt = y;
		byb = y + height;
	}

	/**
	 * Is `this` clickable sprite's hover bounds overlapping the mouse?
	 * 
	 * @return If the mouse is inside `this` clickable sprite's hover bounds.
	 */
	public inline function isHoveringOverMouse():Bool
	{
		return (FlxG.mouse.x >= bxl) && (FlxG.mouse.y >= byt) && (FlxG.mouse.y <= byb) && (FlxG.mouse.x <= bxr);
	}
}
