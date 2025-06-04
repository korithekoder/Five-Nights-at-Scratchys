package fnas.filters;

import fnas.backend.util.PathUtil;
import openfl.Assets;
import flixel.addons.display.FlxRuntimeShader;
import flixel.system.FlxAssets.FlxShader;

// https://www.shadertoy.com/view/ldjGzV and https://www.shadertoy.com/view/Ms23DR and https://www.shadertoy.com/view/MsXGD4 and https://www.shadertoy.com/view/Xtccz4
class VCRMario85Filter extends FlxRuntimeShader
{
	public function new()
	{
		super(Assets.getText(PathUtil.ofFrag('vcrmario85')));
		setFloat('time', 0);
	}

	public function update(elapsed:Float):Void
	{
		setFloat('time', getFloat('time') + elapsed);
	}
}
