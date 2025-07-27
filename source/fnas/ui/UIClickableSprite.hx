package fnas.ui;

import fnas.ui.behavior.ClickableBehavior;
import flixel.FlxSprite;

/**
 * Object that can be created for making a sprite clickable.
 */
class UIClickableSprite extends FlxSprite
{
	/**
	 * The behavior for this clickable sprite.
	 */
	public var behavior:ClickableBehavior;

	/**
	 * @param x The X position of `this` clickable sprite.
	 * @param y The Y position of `this` clickable sprite.
	 */
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		behavior = new ClickableBehavior();
	}

	//
	// METHODS
	// =============================

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		behavior.update(x, y, width, height);
	}

	override function updateHitbox():Void
	{
		super.updateHitbox();
		behavior.updateHoverBounds(x, y, width, height);
	}

	override function setPosition(x:Float = 0.0, y:Float = 0.0):Void
	{
		super.setPosition(x, y);
		behavior.updateHoverBounds(x, y, width, height);
	}
}
