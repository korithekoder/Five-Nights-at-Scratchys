package fnas.filters;

import fnas.backend.util.PathUtil;
import openfl.Assets;
import flixel.addons.display.FlxRuntimeShader;

/**
 * Allows an object or sprite to shift its colors
 * to another set.
 */
class HueShiftShader extends FlxRuntimeShader
{
	public function new(hue:Float = 0)
	{
		super(Assets.getText(PathUtil.ofFrag('hueshift')));
		setHue(hue);
	}

	public function setHue(amount:Float):Void
	{
		setFloat('hue', amount);
	}
}
