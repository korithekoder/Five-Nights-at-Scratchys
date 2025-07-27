package fnas.ui;

import fnas.ui.behavior.ClickableBehavior;
import flixel.text.FlxText;

/**
 * Object that can be created for making text clickable.
 */
class UIClickableText extends FlxText
{
	/**
	 * The behavior for this clickable text.
	 */
	public var behavior:ClickableBehavior;

	/**
	 * @param x The X position of `this` clickable text.
	 * @param y The Y position of `this` clickable text.
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