package fnas.filters;

import flixel.addons.display.FlxRuntimeShader;
import fnas.backend.util.PathUtil;
import openfl.Assets;
import flixel.system.FlxAssets.FlxShader;

/**
 * Filter for adding a red-blue effect on the sides of
 * objects, similar to an old TV.
 */
class AngelFilter extends FlxRuntimeShader
{
	public function new()
	{
		super(Assets.getText(PathUtil.ofFrag('angel')));
		setFloat('iTime', 0.0);
		setFloat('stronk', 0);
		setFloatArray('pixel', [1, 1]);
	}

	public function update(elapsed:Float):Void
	{
		setFloat('iTime', getFloat('iTime') + elapsed);
	}
}
