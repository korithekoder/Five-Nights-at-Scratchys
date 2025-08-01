package fnas.backend.util;

import flixel.FlxG;
import flixel.util.FlxSave;
import fnas.backend.data.ClientPrefs;
import fnas.backend.data.Constants;

/**
 * Utility class for handling and saving user save data.
 */
final class SaveUtil
{
	function new() {}

	/**
	 * Save ***ALL*** of the user's preferences and progress.
	 */
	public static function saveAll():Void
	{
		saveUserOptions();
		saveUserProgress();
	}

	/**
	 * Saves all of the user's options.
	 */
	public static function saveUserOptions():Void
	{
		// Log info
		LoggerUtil.log('Saving user options');

		// Create and bind the saves
		var optionsSave:FlxSave = new FlxSave();
		optionsSave.bind(Constants.OPTIONS_SAVE_BIND_ID, PathUtil.getSavePath());

		// Assign the data
		optionsSave.data.options = ClientPrefs.getOptions();

		// For checking if the data saved
		var didOptionsSave:Bool = optionsSave.flush();

		// Close the bind
		optionsSave.close();

		// Warn if all settings weren't saved
		if (!didOptionsSave)
			LoggerUtil.log('All options failed to save.', WARNING, false);
	}

	/**
	 * Saves all of the user's progress.
	 */
	public static function saveUserProgress():Void
	{
		// Log info
		LoggerUtil.log('Saving user progress');
		// Create and bind the save
		var progressSave:FlxSave = new FlxSave();
		progressSave.bind(Constants.PROGRESS_SAVE_BIND_ID, PathUtil.getSavePath());

		// Assign the data
		// TODO: Add later lol

		// For checking if the data saved
		var didProgressSave:Bool = progressSave.flush();

		// Close the bind
		progressSave.close();

		// Warn if all progress wasn't saved
		if (!didProgressSave)
			LoggerUtil.log('All progress failed to save.', WARNING, false);
	}

	/**
	 * Loads all of the user's progress.
	 */
	public static function loadUserProgress():Void
	{
		// Log info
		LoggerUtil.log('Loading user progress');
		// Create and bind the save
		var progressSave:FlxSave = new FlxSave();
		progressSave.bind(Constants.PROGRESS_SAVE_BIND_ID, PathUtil.getSavePath());

		// Assign the data
		// TODO: Do later :p

		// Close the bind
		progressSave.close();
	}

	/**
	 * Deletes ***ALL*** of the user save data.
	 */
	public static function deleteAll():Void
	{
		LoggerUtil.log('Deleting all user data', WARNING);
		// Create and bind the saves
		var optionsSave:FlxSave = new FlxSave();

		// Connect to the saves
		optionsSave.bind(Constants.OPTIONS_SAVE_BIND_ID, PathUtil.getSavePath());

		// Delete the data
		optionsSave.erase();

		// Ensure the data is deleted
		var didOptionsDelete:Bool = optionsSave.flush();

		// Close the binds
		optionsSave.close();

		// Warn if all settings weren't deleted
		if (!didOptionsDelete)
			LoggerUtil.log('Saved options failed to delete.', WARNING, false);

		// TODO: Make sure the progress gets deleted and logged when the time comes!
	}
}
