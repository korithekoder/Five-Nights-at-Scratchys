package fnas.backend.data;

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
	 * The name of the save file for the player's progress.
	 */
	public static final PROGRESS_SAVE_BIND_ID:String = 'progress';

	/**
	 * The maximum amount of reverb sound effects that can be played at once.
	 */
	public static final REVERB_SOUND_EFFECT_LIMIT:Int = 10;

	/**
	 * How far the user has to move the mouse on the X plane on both sides
	 * before the office can scroll side to side.
	 */
	public static final OFFICE_SCROLL_RANGE:Float = 200;

	/**
	 * How fast the office scrolls side to side.
	 */
	public static final OFFICE_SCROLL_SPEED:Float = 600;

	function new() {}
}
