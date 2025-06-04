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

	function new() {}
}
