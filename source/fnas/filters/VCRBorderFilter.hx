package fnas.filters;

import fnas.backend.util.PathUtil;
import openfl.Assets;
import flixel.addons.display.FlxRuntimeShader;
import flixel.system.FlxAssets.FlxShader;

class VCRBorderFilter extends FlxRuntimeShader // https://www.shadertoy.com/view/Ms23DR and https://www.shadertoy.com/view/MsXGD4
{
	public function new()
	{
		super(Assets.getText(PathUtil.ofFrag('vcrborder')));
	}
}
