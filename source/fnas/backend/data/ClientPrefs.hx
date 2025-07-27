package fnas.backend.data;

import fnas.backend.util.FlixelUtil;
import fnas.backend.util.LoggerUtil;
import fnas.backend.util.PathUtil;
import fnas.backend.util.SaveUtil;
import flixel.FlxG;
import flixel.util.FlxSave;
import haxe.Exception;

/**
 * Class that handles, modifies and stores the user's
 * options and settings.
 * 
 * When you are updating a setting, use `setOption()` to update a user's option(s)
 * or `setBind()` to change a bind.
 * 
 * Controls are saved in their own variable, *NOT* in `options`.
 * 
 * The way controls are created is with this structure: `'keybind_id' => FlxKey.YOUR_KEY`.
 * To create a control, go to `backend.data.Constants`, search for `DEFAULT_CONTROLS_KEYBOARD`
 * and then add your controls accordingly.
 * 
 * To access controls, use `backend.Controls`. (**TIP**: Read `backend.Controls`'s
 * documentation for accessing if binds are pressed!)
 */
final class ClientPrefs
{
	static var options:Map<String, Any> = Constants.DEFAULT_OPTIONS;

	function new() {}

	// ==============================
	//      GETTERS AND SETTERS
	// ==============================

	/**
	 * Get and return a client option by its ID.
	 * 
	 * @param option       The option to get as a `String`.
	 * @param defaultValue The value that is returned instead if the said option isn't found.
	 * @return             The value of the option. If it does not exist, then the
	 *                     default value is returned instead.
	 */
	public static inline function getOption(option:String):Dynamic
	{
		if (options.exists(option))
		{
			return options.get(option);
		}
		else
		{
			LoggerUtil.log('Client option "$option" doesn\'t exist!', ERROR, false);
			FlixelUtil.closeGame(false);
			throw new Exception('Client option "$option" doesn\'t exist!');
		}
	}

	/**
	 * Get and return all client options.
	 * 
	 * @return A `Map` of all client options.
	 */
	public static inline function getOptions():Map<String, Any>
	{
		return options.copy();
	}

	/**
	 * Sets a client's option.
	 * 
	 * @param option      The setting to be set.
	 * @param value       The value to set the option to.
	 * @throws Exception  If the option does not exist.
	 */
	public static function setOption(option:String, value:Any):Void
	{
		if (options.exists(option))
		{
			options.set(option, value);
			SaveUtil.saveUserOptions();
		}
		else
		{
			LoggerUtil.log('Client option "$option" doesn\'t exist!', ERROR, false);
			FlixelUtil.closeGame(false);
			throw new Exception('Client option "$option" doesn\'t exist!');
		}
	}

	// =============================
	//            METHODS
	// =============================

	/**
	 * Load and obtain all of the user's options and controls.
	 */
	public static function loadAll():Void
	{
		// Log info
		LoggerUtil.log('Loading all client preferences');

		// Create the binds
		var optionsData:FlxSave = new FlxSave();

		// Connect to the saves
		optionsData.bind(Constants.OPTIONS_SAVE_BIND_ID, PathUtil.getSavePath());

		// Load options
		if (optionsData.data.options != null)
			options = optionsData.data.options;

		// Check if the user has any new options
		// (this is for when new options are added in an update!)
		for (key in Constants.DEFAULT_OPTIONS.keys())
		{
			if (!options.exists(key))
			{
				options.set(key, Constants.DEFAULT_OPTIONS.get(key));
			}
		}

		// Filter out any options that are not present in the current
		// standard set of options (which is determined by the default options)
		for (key in options.keys())
		{
			if (!Constants.DEFAULT_OPTIONS.exists(key))
			{
				options.remove(key);
			}
		}

		FlxG.sound.volume = 1.0;

		// Respectfully close the saves to prevent data leaks
		optionsData.close();
	}
}
