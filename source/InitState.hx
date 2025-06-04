package;

import fnas.backend.util.AssetUtil;
import openfl.events.KeyboardEvent;
import fnas.states.menus.MainMenuState;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import fnas.backend.util.FlixelUtil;
import fnas.backend.util.LoggerUtil;
import openfl.display.StageQuality;
import fnas.backend.util.CacheUtil;
import fnas.backend.data.ClientPrefs;
import fnas.backend.util.PathUtil;
import flixel.system.FlxAssets;
import openfl.filters.ShaderFilter;
import flixel.FlxG;
import flixel.FlxState;
#if DISCORD_ALLOWED
import fnas.backend.api.DiscordClient;
#end
import lime.app.Application;
import openfl.Lib;
import openfl.display.StageScaleMode;
#if FILTERS_ALLOWED
import fnas.filters.*;
#end
#if html5
import js.Browser;
#end

/**
 * The initial state of the game. This is where
 * you can load assets and set up the game.
 */
class InitState extends FlxState
{
	override public function create():Void
	{
		// Setup the logger for fnas
		LoggerUtil.initialize();

		// Log that we are setting up fnas
		LoggerUtil.log('INITIALIZING FNAS SETUP', INFO, false);

		trace(AssetUtil.getJsonData(PathUtil.ofJson('tight-spot')));

		// Assign and configure Flixel settings
		configureFlixelSettings();

		// Add the processes that always run in the background
		addBackgroundProcesses();

		// Add the event listeners
		addEventListeners();

		// Load all of the player's settings and options
		// Note that if this line is not present, it will
		// cause null errors and crash the game!
		ClientPrefs.loadAll();

		// Start up Discord rich presence
		#if DISCORD_ALLOWED
		DiscordClient.initialize();
		#end

		// Switch to the main menu state after everything has loaded
		FlxG.switchState(() -> new MainMenuState());
	}

	function configureFlixelSettings():Void
	{
		// Log info
		LoggerUtil.log('Configuring Flixel settings');

		// Set the cursor to be the system default
		FlxG.mouse.useSystemCursor = true;

		// Set auto pause to false
		FlxG.autoPause = false;

		// Set the stage and scaling modes
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

		// Disable the binds for increasing/decreasing/muting
		// the flixel master volume
		FlxG.sound.volumeUpKeys = [];
		FlxG.sound.volumeDownKeys = [];
		FlxG.sound.muteKeys = [];

		// Set the default font
		FlxAssets.FONT_DEFAULT = PathUtil.ofFont('vcr');

		// Set the stage quality
		FlxG.stage.quality = StageQuality.MEDIUM;

		// Disable the right-click context menu for HTML5
		#if html5
		Browser.document.addEventListener("contextmenu", (e) ->
		{
			e.preventDefault();
		});
		#end

		// Apply cool but creepy filters
		#if FILTERS_ALLOWED
		// Assign the filters AFTER all assets have been loaded!
		CacheUtil.angelFilter = new AngelFilter();
		CacheUtil.vcrBorderFilter = new VCRBorderFilter();
		CacheUtil.vcrMario85Filter = new VCRMario85Filter();
		CacheUtil.ycbuEndingFilter = new YCBUEndingFilter();
		CacheUtil.grayscaleFilter = new GrayscaleFilter();
		// Set the main filters
		FlxG.game.setFilters([
			new ShaderFilter(CacheUtil.angelFilter),
			new ShaderFilter(CacheUtil.vcrBorderFilter),
			new ShaderFilter(CacheUtil.vcrMario85Filter),
			new ShaderFilter(CacheUtil.ycbuEndingFilter)
		]);
		#end
	}

	function addBackgroundProcesses():Void
	{
		// Log info
		LoggerUtil.log('Adding background processes');
		// Update the filters that need to
		// constantly be reset
		#if FILTERS_ALLOWED
		FlxG.signals.postUpdate.add(() ->
		{
			CacheUtil.angelFilter.update(FlxG.elapsed);
			CacheUtil.vcrMario85Filter.update(FlxG.elapsed);
			CacheUtil.ycbuEndingFilter.update(0, FlxG.elapsed);
		});
		#end
	}

	function addEventListeners():Void
	{
		// Log info
		LoggerUtil.log('Adding event listeners');

		#if desktop
		// Minimize volume when the window is out of focus
		Application.current.window.onFocusIn.add(() ->
		{
			// Bring the volume back up when the window is focused again
			var minimizeVolume:Bool = ClientPrefs.getOption('minimizeVolume');
			if (minimizeVolume && !CacheUtil.isWindowFocused)
			{
				// Set back to one decimal place (0.1) when the screen gains focus again
				// (note that if the user had the volume all the way down, it will be set to zero)
				FlxG.sound.volume = (!(Math.abs(FlxG.sound.volume) < FlxMath.EPSILON)) ? 0.1 : 0;
				CacheUtil.isWindowFocused = true;
				// Set the volume back to the last volume used
				FlxTween.num(FlxG.sound.volume, CacheUtil.lastVolumeUsed, 0.3, {type: FlxTweenType.ONESHOT}, (v) ->
				{
					FlxG.sound.volume = v;
				});
			}
		});
		Application.current.window.onFocusOut.add(() ->
		{
			// Minimize the volume when the window loses focus
			var minimizeVolume:Bool = ClientPrefs.getOption('minimizeVolume');
			if (minimizeVolume && CacheUtil.isWindowFocused)
			{
				// Set the last volume used to the current volume
				CacheUtil.lastVolumeUsed = FlxG.sound.volume;
				CacheUtil.isWindowFocused = false;
				// Tween the volume to 0.03
				FlxTween.num(FlxG.sound.volume, (!(Math.abs(FlxG.sound.volume) < FlxMath.EPSILON)) ? 0.05 : 0, 0.3, {type: FlxTweenType.ONESHOT}, (v) ->
				{
					FlxG.sound.volume = v;
				});
			}
		});
		#end

		// Close the game when the user presses ESCAPE
		// (like literally every FNaF remake lol)
		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, (_) ->
		{
			if (FlxG.keys.justPressed.ESCAPE)
			{
				FlixelUtil.closeGame();
			}
		});

		// Do shit like saving the user's data when the game closes
		Application.current.window.onClose.add(() ->
		{
			// Despite it saying "closeGame", it's not actually closing
			// the game since the parameter "sysShutdown" is false. What's
			// actually happening is all of the data is still saving and other utilities
			// (i.e. Discord RPC and logging) are still being shutdown. This is just for keeping the
			// code D.R.Y and still doing everything that is needed when the game closes!
			// - Kori ;3
			FlixelUtil.closeGame(false);
		});
	}
}
