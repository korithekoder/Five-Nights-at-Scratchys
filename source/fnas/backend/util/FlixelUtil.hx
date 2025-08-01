package fnas.backend.util;

import openfl.net.URLRequest;
import openfl.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.sound.FlxSound;
import flixel.sound.filters.FlxFilteredSound;
import flixel.sound.filters.FlxSoundFilter;
import flixel.sound.filters.effects.FlxSoundReverbEffect;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import fnas.backend.data.Constants;
#if DISCORD_ALLOWED
import fnas.backend.api.DiscordClient;
#end
#if html5
import js.Browser;
#end

/**
 * Utility class for handling objects and components specific to Flixel.
 */
final class FlixelUtil
{
	function new() {}

	/**
	 * Fades into a state with a cool transition effect.
	 * 
	 * @param state             The states to switch to.
	 * @param duration          How long it takes to switch from one state to the next state.
	 * @param playTransitionSfx Should the game play a sound when it switches states?
	 */
	public static function fadeIntoState(state:FlxState, duration:Float, playTransitionSfx:Bool = true):Void
	{
		if (playTransitionSfx)
		{
			FlxG.sound.play(PathUtil.ofSound(''), 1, false, false);
		}

		FlxG.camera.fade(FlxColor.BLACK, duration, false, () ->
		{
			FlxG.switchState(() -> state);
		});
	}

	/**
	 * Play a sound with an echo, cave-like sound effect.
	 * 
	 * @param path      The path to the sound to play.
	 * @param volume    The volume of the sound.
	 * @param decayTime How long it echoes for.
	 * @param onComplete Function to call when the sound finishes playing.
	 * @return The sound that was played, or `null` if the sound limit has been reached.
	 */
	public static function playSoundWithReverb(path:String, volume:Float = 1, decayTime:Float = 4, ?onComplete:Void->Void):FlxSound
	{
		#if REVERB_ALLOWED
		if (!(CacheUtil.currentReverbSoundsAmount > Constants.REVERB_SOUND_EFFECT_LIMIT))
		{
			// Make the sound and filter
			var sound:FlxFilteredSound = new FlxFilteredSound();
			var effect = new FlxSoundReverbEffect();
			// Settings for the echoF
			effect.decayTime = decayTime;
			// Load the sound
			sound.loadEmbedded(path);
			sound.volume = volume;
			sound.filter = new FlxSoundFilter();
			sound.filter.addEffect(effect);
			// Add the sound to the game so that way it
			// gets lowered when the game loses focus and
			// the user has "minimizeVolume" enabled
			FlxG.sound.list.add(sound);
			// Play the sound
			sound.play();
			CacheUtil.currentReverbSoundsAmount++;
			// Recycle the sound after it finishes playing
			new FlxTimer().start((sound.length / 1000) + decayTime, (_) ->
			{
				sound.filter.clearEffects();
				sound.filter = null;
				FlxG.sound.list.remove(sound, true);
				FlxG.sound.list.recycle(FlxSound);
				sound.destroy();
				CacheUtil.currentReverbSoundsAmount--;
				if (onComplete != null)
				{
					onComplete();
				}
			});
			return sound;
		}
		else
		{
			return null;
		}
		#else
		var sound:FlxSound = new FlxSound();
		sound.loadEmbedded(path);
		sound.onComplete = onComplete;
		sound.volume = volume;
		FlxG.sound.list.add(sound);
		return sound.play();
		#end
	}

	/**
	 * Tweens an `FlxTypedGroup<FlxSprite>`'s members with ease.
	 * 
	 * @param group    The group to tween.
	 * @param options  Dynamic object with the attributes to tween.
	 * @param duration How long the tween should last for.
	 * @param types    The types and eases for the group to tween with.
	 */
	public static function tweenSpriteGroup(group:FlxTypedGroup<FlxSprite>, options:Dynamic, duration:Float, types:Dynamic):Void
	{
		for (obj in group.members)
		{
			if (obj != null)
			{
				FlxTween.tween(obj, options, duration, types);
			}
		}
	}

	/**
	 * Open a new URL in the user's browser.
	 * 
	 * @param url The link to the website to open.
	 */
	public static function openURL(url:String):Void
	{
		Lib.getURL(new URLRequest(url));
	}

	/**
	 * Close the entire game.
	 * 
	 * @param sysShutdown Whether to close the game using the dedicated platform
	 * 					  shutdown method or not. Only place this is set to `false`
	 * 					  is in `InitState` when the event listener for the game closing
	 * 					  is added.
	 */
	public static function closeGame(sysShutdown:Bool = true):Void
	{
		// Log info
		LoggerUtil.log('SHUTTING DOWN FNAS', INFO, false);
		// Save all of the user's data
		SaveUtil.saveAll();
		// Shutdown Discord rich presence
		#if DISCORD_ALLOWED
		DiscordClient.shutdown();
		#end
		// Shutdown the logging system
		LoggerUtil.shutdown();
		// Close the game respectfully
		if (sysShutdown)
		{
			#if web
			Browser.window.close();
			#elseif desktop
			Sys.exit(0);
			#end
		}
	}
}
