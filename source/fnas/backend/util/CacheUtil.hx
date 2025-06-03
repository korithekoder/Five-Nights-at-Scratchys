package fnas.backend.util;

import fnas.filters.*;

/**
 * Class that holds general, temporary data for pretty much anything.
 * Examples of general temporary data can be things such as the last volume used.
 */
final class CacheUtil
{
	/**
	 * The last volume that the player had set before the game loses focus.
	 */
	public static var lastVolumeUsed:Float;

	/**
	 * Did the user already see the warnings?
	 * (This is for loading from and to the main menu when the game hasn't closed yet.)
	 */
	public static var alreadySawWarning:Bool = false;

	/**
	 * Is the game's window focused?
	 */
	public static var isWindowFocused:Bool = true;

	/**
	 * Can the game play menu music when the user leaves gameplay?
	 */
	public static var canPlayMenuMusic:Bool = true;

	/**
	 * The amount of reverb sounds that are currently playing.
	 */
	public static var currentReverbSoundsAmount:Int = 0;

	/**
	 * Angel filter for Starcore.
	 */
	public static var angelFilter:AngelFilter = new AngelFilter();

	/**
	 * VCR border filter for Starcore.
	 */
	public static var vcrBorderFilter:VCRBorderFilter = new VCRBorderFilter();

	/**
	 * VCR Mario 85 filter for Starcore.
	 */
	public static var vcrMario85Filter:VCRMario85Filter = new VCRMario85Filter();

	/**
	 * YCBU ending filter for Starcore.
	 */
	public static var ycbuEndingFilter:YCBUEndingFilter = new YCBUEndingFilter();

	function new() {}
}
