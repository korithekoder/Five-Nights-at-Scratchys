package fnas.menus;

import fnas.backend.util.FlixelUtil;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxState;

/**
 * Warning that gets shown if the user is playing on the web 
 * build and instead recommends the desktop version.
 */
class WebWarningState extends FlxState
{
	var warningGroup:FlxSpriteGroup;
	var warningHeading:FlxText;
	var warningText:FlxText;

	override function create():Void
	{
		super.create();

		warningGroup = new FlxSpriteGroup();
		warningGroup.alpha = 0;
		add(warningGroup);

		warningHeading = new FlxText();
		warningHeading.text = 'Looks like you\'re playing on the web...';
		warningHeading.color = FlxColor.YELLOW;
		warningHeading.size = 40;
		warningHeading.updateHitbox();
		warningHeading.screenCenter(X);
		warningHeading.y = 220;
		warningGroup.add(warningHeading);

		warningText = new FlxText();
		warningText.text = 'Even though it TECHNICALLY functions just fine, it is\n'
			+ 'STRONGLY recommended that you play the desktop version, as it\n'
			+ 'has sounds that echo, spooky filters and overall just a better\n'
			+ 'horror experience!\n\n'
			+ 'SPACE: Continue Playing on the Web\n'
			+ 'ENTER: Redirect to Official Desktop Downloads on itch.io';
		warningText.size = 25;
		warningText.alignment = CENTER;
		warningText.updateHitbox();
		warningText.screenCenter(X);
		warningText.y = warningHeading.y + warningHeading.height + 12;
		warningGroup.add(warningText);

		FlxTween.tween(warningGroup, {alpha: 1}, 1);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
		{
			FlxTween.cancelTweensOf(warningGroup);
			FlxTween.tween(warningGroup, {alpha: 0}, 1, {
				onComplete: (_) ->
				{
					FlxG.switchState(() -> new MainMenuState());
				}
			});
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			// TODO: MAKE SURE TO REPLACE THIS WITH ACTUAL DOWNLOAD LINK!!!!!1!!!1!!!
			FlixelUtil.openURL('https://github.com/korithekoder');
			FlixelUtil.closeGame();
		}
	}
}
