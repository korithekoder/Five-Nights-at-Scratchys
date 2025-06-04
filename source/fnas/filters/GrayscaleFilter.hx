package fnas.filters;

import openfl.utils.Assets;
import flixel.addons.display.FlxRuntimeShader;
import fnas.backend.util.PathUtil;

/**
 * What do you think?
 */
class GrayscaleFilter extends FlxRuntimeShader
{
	public var amount:Float = 1;

	public function new(amount:Float = 1)
	{
		super(Assets.getText(PathUtil.ofFrag('grayscale')));
		setAmount(amount);
	}

	public function setAmount(value:Float):Void
	{
		amount = value;
		setFloat("_amount", amount);
	}
}
