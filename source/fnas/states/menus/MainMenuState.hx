package fnas.states.menus;

import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import fnas.backend.util.CacheUtil;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import fnas.backend.util.FlixelUtil;
import fnas.backend.util.PathUtil;

/**
 * The main menu of the game.
 */
class MainMenuState extends FlxState
{
	var warningTitle:FlxText;
	var warningText:FlxText;
	var warningTextGroup:FlxSpriteGroup;

	var titleText:FlxText;
	var mainMenuGroup:FlxSpriteGroup;

	override function create():Void
	{
		super.create();

		warningTextGroup = new FlxSpriteGroup();
		warningTextGroup.alpha = 0;
		add(warningTextGroup);

		warningText = new FlxText();
		warningText.text = 'This game contains flashing lights and many jumpscares!\n'
			+ 'If you do not like that, it\'s best if you turn back now, as\n'
			+ 'this game isn\'t for you...';
		warningText.color = FlxColor.RED;
		warningText.alignment = CENTER;
		warningText.size = 25;
		warningText.updateHitbox();
		warningText.screenCenter(X);
		warningText.y = (FlxG.height / 2) + 10;
		warningTextGroup.add(warningText);

		warningTitle = new FlxText();
		warningTitle.text = 'WARNING';
		warningTitle.color = FlxColor.RED;
		warningTitle.alignment = CENTER;
		warningTitle.size = 64;
		warningTitle.updateHitbox();
		warningTitle.screenCenter(X);
		warningTitle.y = (warningText.y - warningTitle.height) - 5;
		warningTextGroup.add(warningTitle);

		mainMenuGroup = new FlxSpriteGroup();
		mainMenuGroup.alpha = 0;
		add(mainMenuGroup);

		titleText = new FlxText();
		titleText.text = 'Five\nNights\nat\nScratchy\'s';
		titleText.size = 64;
		titleText.updateHitbox();
		titleText.setPosition(40, 115);
		mainMenuGroup.add(titleText);

		// Play menu music
		FlxG.sound.playMusic(PathUtil.ofMusic('menu-music'), 0);

		// Slowly bring up the volume of the menu music
		FlxTween.num(FlxG.sound.music.volume, 0.75, 15, (n:Float) ->
		{
			FlxG.sound.music.volume = n;
		});

		// When everything is done, show the warning
		// (if the user hasn't seen it yet)
		if (!CacheUtil.alreadySawWarning)
		{
			displayWarning();
		}
		else
		{
			displayMainMenu();
		}
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
		{
			FlixelUtil.playSoundWithReverb(PathUtil.ofSound('ringtone'), 1, 5.5);
		}
	}

	function displayMainMenu():Void
	{
		FlxTween.tween(mainMenuGroup, {alpha: 1}, 3.5);
	}

	function displayWarning():Void
	{
		// Ensure that we don't see this warning again
		CacheUtil.alreadySawWarning = true;
		// Bring up the visibility for the warning text
		FlxTween.tween(warningTextGroup, {alpha: 1}, 5, {onComplete: (_) ->
		{
			// When the warning text is done losing its transparency, then
			// start another tween to hide it again but with a delay
			FlxTween.tween(warningTextGroup, {alpha: 0}, 5, {startDelay: 6, onComplete: (_) ->
			{
				displayMainMenu();
			}});
		}});
	}
}
