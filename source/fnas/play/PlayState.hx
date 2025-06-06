package fnas.play;

import flixel.text.FlxText;
import flixel.FlxCamera;
import openfl.ui.MouseCursor;
import openfl.ui.Mouse;
import fnas.ui.ClickableSprite;
import fnas.backend.util.LoggerUtil;
import flixel.group.FlxSpriteGroup;
import fnas.backend.data.Constants;
import flixel.FlxSprite;
import fnas.backend.util.PathUtil;
import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxState;

/**
 * The state where all of the funky gameplay happens.
 */
class PlayState extends FlxState
{
	//
	// CAMERAS
	// ========================
	var uiCamera:FlxCamera;

	//
	// GROUPS
	// ========================
	var officeGroup:FlxSpriteGroup;

	//
	// OFFICE SPRITES
	// ========================
	var base:FlxSprite;
	var poster:ClickableSprite;

	//
	// UI TEXT AND SPRITES
	// ========================
	var timeText:FlxText;
	var nightText:FlxText;

	//
	// SOUNDS
	// ========================
	var fanAmb:FlxSound;

	override function create():Void
	{
		super.create();
		LoggerUtil.log('LOADING BASE GAME', false);
		setupCameras();
		setupGroups();
		setupOffice();
		setupUI();
		setupSounds();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Check if the user is trying to look around
		scrollOffice(elapsed);
	}

	//
	// SETUP FUNCTIONS
	// ===============================

	function setupCameras():Void
	{
		// UI camera
		uiCamera = new FlxCamera();
		uiCamera.bgColor.alpha = 0;
		FlxG.cameras.add(uiCamera, false);
	}

	function setupGroups():Void
	{
		LoggerUtil.log('Setting up groups');
		// Create office group
		officeGroup = new FlxSpriteGroup();
		officeGroup.screenCenter(X);
		officeGroup.y = -15;
		add(officeGroup);
	}

	function setupOffice():Void
	{
		LoggerUtil.log('Setting up office');
		// Create the base office background
		base = new FlxSprite();
		base.loadGraphic(PathUtil.ofImage('office/base'));
		base.setGraphicSize(1500, 720);
		base.updateHitbox();
		base.screenCenter(X);
		officeGroup.add(base);
		FlxG.camera.focusOn(base.getMidpoint());
		FlxG.camera.y -= 5;

		// Create the poster
		poster = new ClickableSprite();
		poster.loadGraphic(PathUtil.ofImage('office/poster'));
		poster.setPosition(base.x + 70, base.y + 60);
		poster.setGraphicSize(0, 160);
		poster.updateHitbox();
		poster.onClick = () ->
		{
			FlxG.sound.play(PathUtil.ofSound('poster-honk'), 0.5);
		};
		poster.onHover = () ->
		{
			Mouse.cursor = MouseCursor.BUTTON;
		};
		poster.onHoverLost = () ->
		{
			Mouse.cursor = MouseCursor.ARROW;
		};
		officeGroup.add(poster);
	}

	function setupUI():Void
	{
		// Time text
		timeText = new FlxText();
		timeText.text = '12:00 AM';
		timeText.size = 50;
		timeText.updateHitbox();
		timeText.setPosition(FlxG.width - timeText.width - 30, 30);
		timeText.cameras = [uiCamera];
		add(timeText);

		// Night text
		nightText = new FlxText();
		nightText.text = 'Night 1';
		nightText.size = 32;
		nightText.updateHitbox();
		nightText.setPosition(FlxG.width - nightText.width - 30, timeText.y + timeText.height + 3);
		nightText.cameras = [uiCamera];
		add(nightText);
	}

	function setupSounds():Void
	{
		LoggerUtil.log('Setting up sounds');
		// Fan ambience
		fanAmb = new FlxSound();
		fanAmb.loadEmbedded(PathUtil.ofAmbience('office-fan'), true);
		FlxG.sound.list.add(fanAmb);
		fanAmb.play();
	}

	//
	// CORE FUNCTIONS
	// ===============================

	function scrollOffice(elapsed:Float):Void
	{
		var isInRange:Bool = (FlxG.mouse.viewX < Constants.OFFICE_SCROLL_RANGE)
			|| (FlxG.mouse.viewX > (FlxG.width - Constants.OFFICE_SCROLL_RANGE));
		if (isInRange)
		{
			var scrollDirection:Float = (FlxG.mouse.viewX < Constants.OFFICE_SCROLL_RANGE) ? 1 : -1; // 1 = left, -1 = Right
			var dist = (scrollDirection == 1) ? (Constants.OFFICE_SCROLL_RANGE - FlxG.mouse.viewX) : (FlxG.mouse.viewX
				- (FlxG.width - Constants.OFFICE_SCROLL_RANGE));
			var scrollSpeed = Constants.OFFICE_SCROLL_SPEED * (0.45 + dist / Constants.OFFICE_SCROLL_RANGE);
			officeGroup.x += scrollSpeed * scrollDirection * elapsed;

			// Reset the position if the office is out of bounds
			if (officeGroup.x > 670)
			{
				officeGroup.x = 670;
			}
			else if (officeGroup.x < 245)
			{
				officeGroup.x = 245;
			}
		}
		// Center the click bounds to be on Scratchy's nose
		poster.setHoverBounds(
			(poster.x + poster.width / 2) - 16,
			(poster.x + poster.width / 2) - 6,
			(poster.y + poster.height / 2) - 2,
			(poster.y + poster.height / 2) + 5
		);
	}
}
