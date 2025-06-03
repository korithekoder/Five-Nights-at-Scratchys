package fnas.filters;

import flixel.addons.display.FlxRuntimeShader;
import fnas.backend.util.PathUtil;

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
		this.setFloat("_amount", amount);
	}
}
