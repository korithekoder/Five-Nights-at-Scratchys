package fnas.filters;

import fnas.backend.util.PathUtil;
import openfl.Assets;
import flixel.addons.display.FlxRuntimeShader;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxShader;
import haxe.Timer;

class YCBUEndingFilter extends FlxRuntimeShader
{
	public function new()
	{
		super(Assets.getText(PathUtil.ofFrag('ycbuending')));
		setFloat('seed', Timer.stamp());
		setFloat('intensity', 0.0);
	}

	public function update(amount:Float, elapsed:Float):Void
	{
		setFloat('seed', getFloat('seed') + elapsed);
		setFloat('intensity', FlxMath.bound(getFloat('intensity') + amount, 0, 1));
	}
}
