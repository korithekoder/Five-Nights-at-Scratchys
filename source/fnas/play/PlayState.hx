package fnas.play;

import openfl.geom.Point;
import openfl.display.BitmapData;
import openfl.filters.ShaderFilter;
import openfl.filters.BlurFilter;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.sound.filters.FlxSoundFilter;
import fnas.backend.util.FlixelUtil;
import flixel.sound.filters.effects.FlxSoundReverbEffect;
import flixel.sound.filters.FlxFilteredSound;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.FlxCamera;
import fnas.ui.UIClickableSprite;
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
	var monitorGroup:FlxSpriteGroup;

	//
	// DATA
	// ========================
	var currentNight:Int = 1;
	var monitorUp:Bool = false;
	var lastOfficeBitmapData:Map<FlxSprite, BitmapData>;

	//
	// OFFICE SPRITES
	// ========================
	var base:FlxSprite;
	var poster:UIClickableSprite;
	var lamp:FlxSprite;
	var laptop:UIClickableSprite;

	//
	// MONITOR SPRITES
	// ========================
	var greenFlag:UIClickableSprite;

	//
	// UI TEXT AND SPRITES
	// ========================
	var timeText:FlxText;
	var nightText:FlxText;
	var monitor:FlxSprite; // Meant for only display!
	var faggot:UIClickableSprite;

	//
	// SOUNDS
	// ========================
	var fanAmb:FlxSound;
	var phoneCallSfx:FlxSound;
	var phoneCallRingtoneSfx:FlxFilteredSound;

	//
	// TIMERS
	// ========================
	var lampFlickerTimer:FlxTimer;
	var laptopOpenTimer:FlxTimer;

	override function create():Void
	{
		super.create();
		LoggerUtil.log('LOADING BASE GAME', false);
		setupCameras();
		setupGroups();
		setupOffice();
		setupMonitorDisplay();
		setupUI();
		setupSounds();
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Check if the user is trying to look around
		scrollOffice(elapsed);

		if (FlxG.keys.justPressed.SPACE && phoneCallRingtoneSfx.playing)
		{
			phoneCallRingtoneSfx.stop();
			FlixelUtil.playSoundWithReverb(PathUtil.ofSound('phone-pick-up'), 0.75, 4, () ->
			{
				phoneCallSfx = FlixelUtil.playSoundWithReverb(PathUtil.ofPhoneCall(Std.string(currentNight)), 1, 3.2, () ->
				{
					FlixelUtil.playSoundWithReverb(PathUtil.ofSound('phone-hang-up'), 0.75, 4);
				});
			});
		}

		if (FlxG.keys.justPressed.Y)
		{
			toggleMonitor();
		}
	}

	//
	// SETUP FUNCTIONS
	// ===============================

	function setupCameras():Void
	{
		LoggerUtil.log('Setting up flixel cameras');
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

		// Create monitor group
		monitorGroup = new FlxSpriteGroup();
		monitorGroup.cameras = [uiCamera];
		monitorGroup.visible = false;
		add(monitorGroup);
	}

	function setupOffice():Void
	{
		LoggerUtil.log('Setting up office');

		lastOfficeBitmapData = new Map<FlxSprite, BitmapData>();

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
		poster = new UIClickableSprite();
		poster.loadGraphic(PathUtil.ofImage('office/poster'));
		poster.setPosition(base.x + 70, base.y + 60);
		poster.setGraphicSize(0, 160);
		poster.updateHitbox();
		poster.behavior.resetCursorOnClick = false;
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

		// Create the laptop which displays the amount of power left
		laptop = new UIClickableSprite();
		laptop.loadGraphic(PathUtil.ofImage('office/laptop'));
		laptop.scale.set(0.8, 0.8);
		laptop.updateHitbox();
		laptop.setPosition(base.x + 100, base.y + 200);
		laptop.behavior.onClick = toggleMonitor;
		officeGroup.add(laptop);
	}

	function setupMonitorDisplay():Void
	{
		greenFlag = new UIClickableSprite();
		greenFlag.loadGraphic(PathUtil.ofImage('monitor/green-flag'));
		greenFlag.scale.set(2, 2);
		greenFlag.updateHitbox();
		greenFlag.setPosition(20, 20);
		monitorGroup.add(greenFlag);
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
		nightText.text = 'Night $currentNight';
		nightText.size = 32;
		nightText.updateHitbox();
		nightText.setPosition(FlxG.width - nightText.width - 30, timeText.y + timeText.height + 3);
		nightText.cameras = [uiCamera];
		add(nightText);

		// Add the monitor
		var paths:Array<String> = PathUtil.ofSpritesheet('camera/monitor');
		monitor = new FlxSprite();
		monitor.loadGraphic(paths[0], true);
		monitor.setGraphicSize(FlxG.width);
		monitor.updateHitbox();
		monitor.screenCenter(X);
		monitor.y = FlxG.height - monitor.height;
		monitor.frames = FlxAtlasFrames.fromSparrow(paths[0], paths[1]);
		monitor.animation.addByIndices('open', 'monitor_', [0, 1, 2, 3], '', 15, false);
		monitor.animation.addByIndices('close', 'monitor_', [3, 2, 1, 0], '', 15, false);
		monitor.animation.onFrameChange.add((animName:String, fn:Int, fi:Int) ->
		{
			monitor.setGraphicSize(FlxG.width);
			monitor.updateHitbox();
			monitor.screenCenter(X);
			monitor.y = FlxG.height - monitor.height;
		});
		monitor.animation.onFinish.add((animName:String) ->
		{
			if (animName == 'close')
			{
				monitor.visible = false;
				laptop.behavior.canClick = true;
			}
		});
		monitor.cameras = [uiCamera];
		add(monitor);
	}

	function setupSounds():Void
	{
		LoggerUtil.log('Setting up sounds');
		// Fan ambience
		fanAmb = new FlxSound();
		fanAmb.loadEmbedded(PathUtil.ofAmbience('office-fan'), true);
		FlxG.sound.list.add(fanAmb);
		fanAmb.play();

		// Phone call sound effects
		var effect:FlxSoundReverbEffect = new FlxSoundReverbEffect();
		effect.decayTime = 3.6;
		phoneCallRingtoneSfx = new FlxFilteredSound();
		phoneCallRingtoneSfx.loadEmbedded(PathUtil.ofSound('ringtone'), true);
		phoneCallRingtoneSfx.volume = 0.35;
		phoneCallRingtoneSfx.filter = new FlxSoundFilter();
		phoneCallRingtoneSfx.filter.addEffect(effect);
		FlxG.sound.list.add(phoneCallRingtoneSfx);
		new FlxTimer().start(4, (_) ->
		{
			phoneCallRingtoneSfx.play();
		});
	}

	//
	// CORE FUNCTIONS
	// ===============================

	function scrollOffice(elapsed:Float):Void
	{
		if (monitorUp)
		{
			return;
		}

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
		poster.behavior.setHoverBounds((poster.x + poster.width / 2)
			- 16, (poster.x + poster.width / 2)
			- 6, (poster.y + poster.height / 2)
			- 2,
			(poster.y + poster.height / 2)
			+ 5);

		// Update hover bounds for the laptop
		laptop.behavior.updateHoverBounds(
			laptop.x,
			laptop.y,
			laptop.width,
			laptop.height
		);
	}

	function toggleMonitor():Void
	{
		if (!monitorUp)
		{
			FlxG.sound.play(PathUtil.ofSound('monitor-up'));
			monitor.animation.play('open');
			monitor.visible = true;
			laptop.behavior.canClick = false;
			for (member in officeGroup.members)
			{
				if (member == lamp)
				{
					continue;
				}
				// Store the original bitmapData if not already stored
				if (member.graphic != null && member.graphic.bitmap != null)
				{
					lastOfficeBitmapData.set(member, member.graphic.bitmap.clone());
					// Apply blur filter
					var bitmapData:BitmapData = member.graphic.bitmap.clone();
					var blurFilter:BlurFilter = new BlurFilter(20, 20);
					bitmapData.applyFilter(bitmapData, bitmapData.rect, new Point(0, 0), blurFilter);

					member.graphic.bitmap = bitmapData;
					member.dirty = true;
				}
			}
		}
		else
		{
			FlxG.sound.play(PathUtil.ofSound('monitor-down'));
			monitor.animation.play('close');
			FlxG.camera.filters = [];

			for (member in officeGroup.members)
			{
				if (member == lamp)
				{
					continue;
				}
				if (lastOfficeBitmapData.exists(member))
				{
					member.graphic.bitmap = lastOfficeBitmapData.get(member);
					member.dirty = true;
					Reflect.deleteField(member, "originalBitmapData");
				}
			}
		}
		monitorUp = !monitorUp;
		poster.behavior.canClick = !monitorUp;
	}
}
