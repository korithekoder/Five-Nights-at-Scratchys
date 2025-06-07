package fnas.play;

import flixel.sound.filters.FlxSoundFilter;
import fnas.backend.util.FlixelUtil;
import flixel.sound.filters.effects.FlxSoundReverbEffect;
import flixel.sound.filters.FlxFilteredSound;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.FlxCamera;
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
	var lamp:FlxSprite;

	//
	// UI TEXT AND SPRITES
	// ========================
	var timeText:FlxText;
	var nightText:FlxText;

	//
	// SOUNDS
	// ========================
	var fanAmb:FlxSound;
	var phoneCallSfx:FlxFilteredSound;

	//
	// TIMERS
	// ========================
	var lampFlickerTimer:FlxTimer;

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

		if (FlxG.keys.justPressed.SPACE && phoneCallSfx.playing)
		{
			phoneCallSfx.stop();
			FlixelUtil.playSoundWithReverb(PathUtil.ofSound('phone-pick-up'), 0.75, 4);
		}
	}

	//
	// SETUP FUNCTIONS
	// ===============================

	function setupCameras():Void
	{
		LoggerUtil.log('Setting up cameras');
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
		poster.behavior.onClick = () ->
		{
			FlixelUtil.playSoundWithReverb(PathUtil.ofSound('poster-honk'), 0.35, 3);
		};
		officeGroup.add(poster);

		// Create the flickering lamp
		lamp = new FlxSprite();
		lamp.loadGraphic(PathUtil.ofImage('office/lamp-1'));
		lamp.setGraphicSize(400);
		lamp.updateHitbox();
		lamp.screenCenter(X);
		lamp.y = -5;
		officeGroup.add(lamp);
		lampFlickerTimer = new FlxTimer();
		lampFlickerTimer.start(2.4, (_) ->
		{
			lamp.loadGraphic(PathUtil.ofImage('office/lamp-2'));
			lamp.x += 7;
			lamp.y += 2.75;
			new FlxTimer().start(FlxG.random.float(0.05, 0.1), (_) ->
			{
				lamp.loadGraphic(PathUtil.ofImage('office/lamp-1'));
				lamp.x -= 7;
				lamp.y -= 2.75;
			});
		}, 0);
	}

	function setupUI():Void
	{
		LoggerUtil.log('Setting up UI');
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

		// Phone call sfx
		var effect:FlxSoundReverbEffect = new FlxSoundReverbEffect();
		effect.decayTime = 3.6;
		phoneCallSfx = new FlxFilteredSound();
		phoneCallSfx.loadEmbedded(PathUtil.ofSound('ringtone'), true);
		phoneCallSfx.volume = 0.35;
		phoneCallSfx.filter = new FlxSoundFilter();
		phoneCallSfx.filter.addEffect(effect);
		FlxG.sound.list.add(phoneCallSfx);
		new FlxTimer().start(4, (_) ->
		{
			phoneCallSfx.play();
		});
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
		poster.behavior.setHoverBounds(
			(poster.x + poster.width / 2) - 16,
			(poster.x + poster.width / 2) - 6,
			(poster.y + poster.height / 2) - 2,
			(poster.y + poster.height / 2) + 5
		);
	}
}
