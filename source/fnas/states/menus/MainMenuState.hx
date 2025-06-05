package fnas.states.menus;

import fnas.backend.util.AssetUtil;
import flixel.util.FlxTimer;
import fnas.objects.ui.ClickableText;
import flixel.FlxSprite;
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
	var scratchy:FlxSprite;
	var mainMenuGroup:FlxSpriteGroup;

	var newNightText:FlxText;

	var cameraBlip:FlxSprite;

	var buttonIds:Array<String> = ['Play', 'Quit'];
	var buttonFunctions:Map<String, Void->Void>;

	var scratchyChangeTimer:FlxTimer;

	override function create():Void
	{
		super.create();

		warningTextGroup = new FlxSpriteGroup();
		warningTextGroup.alpha = 0;
		add(warningTextGroup);

		warningText = new FlxText();
		warningText.text = 'This game contains flashing lights and many jumpscares!\n'
			+ 'If you cannot handle that, then it\'s best if you turn back now, as\n'
			+ 'this game isn\'t for you...';
		warningText.color = FlxColor.WHITE;
		warningText.alignment = CENTER;
		warningText.size = 22;
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

		scratchy = new FlxSprite();
		scratchy.loadGraphic(PathUtil.ofImage('main-menu/mm-scratchy-1'));
		scratchy.scale.set(2.3, 2.3);
		scratchy.updateHitbox();
		scratchy.x = (FlxG.width - scratchy.width) + 5;
		scratchy.y = (FlxG.height - scratchy.height) + 60;
		mainMenuGroup.add(scratchy);

		titleText = new FlxText();
		titleText.text = 'Five\nNights\nat\nScratchy\'s';
		titleText.size = 64;
		titleText.updateHitbox();
		titleText.setPosition(40);
		titleText.screenCenter(Y);
		titleText.y -= 60;
		mainMenuGroup.add(titleText);

		newNightText = new FlxText();
		newNightText.text = 'Night 1\n12:00 AM';
		newNightText.size = 80;
		newNightText.alignment = CENTER;
		newNightText.updateHitbox();
		newNightText.screenCenter(XY);
		newNightText.visible = false;
		add(newNightText);

		cameraBlip = AssetUtil.generateCameraBlipSprite();
		add(cameraBlip);

		buttonFunctions = [
			'Play' => () ->
			{
				mainMenuGroup.visible = false;
				newNightText.visible = true;
				cameraBlip.animation.play('blip');
				FlxG.sound.music.stop();
				FlixelUtil.playSoundWithReverb(PathUtil.ofSound('camera-blip'), 1, 7);
			},
			'Quit' => () ->
			{
				FlixelUtil.closeGame();
			}
		];

		// Create the buttons you see on the menu
		var newY:Float = titleText.y + titleText.height + 50;
		for (btn in buttonIds)
		{
			var b:ClickableText = new ClickableText();
			b.text = btn;
			b.size = 50;
			b.updateHitbox();
			b.x = titleText.x;
			b.y = newY;
			b.updateHoverBounds();
			b.onClick = buttonFunctions.get(btn);
			b.onHover = () ->
			{
				b.text = '> $btn';
				FlxG.sound.play(PathUtil.ofSound('camera-blip'));
			};
			b.onHoverLost = () ->
			{
				b.text = btn;
			};
			mainMenuGroup.add(b);
			newY += b.height + 5;
		}

		// Set the timers for Scratchy
		scratchyChangeTimer = new FlxTimer();

		// Play menu music
		FlxG.sound.playMusic(PathUtil.ofMusic('menu-music'), 0);

		// Slowly bring up the volume of the menu music
		FlxTween.num(FlxG.sound.music.volume, 0.45, 15, (n:Float) ->
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

		if (!CacheUtil.alreadySawWarning)
		{
			// If the user presses ENTER, then
			// skip the warning
			if (FlxG.keys.justPressed.ENTER)
			{
				// Ensure that we don't see the warning again
				CacheUtil.alreadySawWarning = true;
				// Cancel the already ongoing tween and
				// go straight to the main menu
				FlxTween.cancelTweensOf(warningTextGroup);
				FlxTween.tween(warningTextGroup, {alpha: 0}, 2, {
					onComplete: (_) ->
					{
						displayMainMenu();
					}
				});
			}
		}
	}

	function displayMainMenu():Void
	{
		// Ensure that we don't see the warning again
		CacheUtil.alreadySawWarning = true;
		// Slowly make the main menu appear
		FlxTween.tween(mainMenuGroup, {alpha: 1}, 3.5);

		// Start an infinitely looped timer that makes Scratchy
		// change for a split second
		scratchyChangeTimer.start(1.45, (_) ->
		{
			scratchy.loadGraphic(PathUtil.ofImage('main-menu/mm-scratchy-${FlxG.random.int(2, 4)}'));
			resetScratchy();
			new FlxTimer().start(FlxG.random.float(0.1, 0.2), (_) ->
			{
				scratchy.loadGraphic(PathUtil.ofImage('main-menu/mm-scratchy-1'));
				resetScratchy();
			});
		}, 0);
	}

	function displayWarning():Void
	{
		// Bring up the visibility for the warning text
		FlxTween.tween(warningTextGroup, {alpha: 1}, 5, {
			onComplete: (_) ->
			{
				// When the warning text is done losing its transparency, then
				// start another tween to hide it again but with a delay
				FlxTween.tween(warningTextGroup, {alpha: 0}, 5, {
					startDelay: 6,
					onComplete: (_) ->
					{
						displayMainMenu();
					}
				});
			}
		});
	}

	function resetScratchy():Void
	{
		scratchy.updateHitbox();
		scratchy.x = (FlxG.width - scratchy.width) + 5;
		scratchy.y = (FlxG.height - scratchy.height) + 60;
	}
}
