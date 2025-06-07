package fnas.ui;

import flixel.text.FlxText;

/**
 * Object that can be created for making text clickable.
 */
class ClickableText extends FlxText
{
	/**
	 * The behavior for this clickable sprite.
	 */
	public var behavior:ClickableBehavior;

	/**
	 * Constructor.
	 * 
	 * @param x The X position of `this` clickable sprite.
	 * @param y The Y position of `this` clickable sprite.
	 */
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		behavior = new ClickableBehavior();
	}

	// =============================
	//            METHODS
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