package fnas.backend.data;

import flixel.input.keyboard.FlxKey;

/**
 * Class that holds all of the general values that do not change.
 */
final class Constants
{
	/**
	 * DEFAULTS
	 * ======================
	 */
	/**
	 * The default controls for the player. This is typically used when
	 * the player wishes to reset all of their binds.
	 */
	public static final DEFAULT_CONTROLS_KEYBOARD:Map<String, FlxKey> = [
		// UI
		'ui_left' => LEFT,
		'ui_down' => DOWN,
		'ui_up' => UP,
		'ui_right' => RIGHT,
		'ui_select' => ENTER,
		'ui_back' => ESCAPE,
		// Volume
		'vl_up' => PLUS,
		'vl_down' => MINUS,
		'vl_mute' => F12,
		// Misc.
		'ms_fullscreen' => F11
	];

	/**
	 * The default options for the game. These are only really used when
	 * the player either updated the game ***OR*** is missing anything important.
	 */
	public static final DEFAULT_OPTIONS:Map<String, Any> = [
		// Misc.
		'discordRPC' => true,
		'minimizeVolume' => true,
	];

	/**
	 * SAVE BIND ID'S
	 * ==========================
	 */
	/**
	 * The name of the save file for the player's options.
	 */
	public static final OPTIONS_SAVE_BIND_ID:String = 'options';

	/**
	 * The name of the save file for the player's controls.
	 */
	public static final CONTROLS_SAVE_BIND_ID:String = 'controls';

	/**
	 * The name of the save file for the player's progress.
	 */
	public static final PROGRESS_SAVE_BIND_ID:String = 'progress';

	/**
	 * MUSIC
	 * ========================
	 */
	/**
	 * Name of the music that plays when in the main menus.
	 */
	public static final MENU_MUSIC_NAME:String = '';

	/**
	 * The maximum amount of reverb sound effects that can be played at once.
	 */
	public static final REVERB_SOUND_EFFECT_LIMIT:Int = 15;

	function new() {}
}
