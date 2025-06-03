package fnas.backend.util;

import haxe.Json;
import openfl.utils.Assets;

/**
 * Utility class for obtaining and manipulating data in files or variables.
 */
final class AssetUtil
{
	function new() {}

	/**
	 * Removes the file extension from the passed down file name.
	 * 
	 * @param fileName The file name.
	 * @return         The file name (but with the extension removed).
	 */
	public static function removeFileExtension(fileName:String):String
	{
		var dotIndex:Int = fileName.lastIndexOf(".");
		return (dotIndex > 0) ? fileName.substr(0, dotIndex) : fileName;
	}

	/**
	 * Generate a random string for a new file (this is mainly used for
	 * new log files).
	 * 
	 * @return A new random file name.
	 */
	public static function generateRandomFileName():String
	{
		var chars:String = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
		var result:StringBuf = new StringBuf();

		for (i in 0...chars.length)
		{
			var index = Std.int(Math.random() * chars.length);
			result.add(chars.charAt(index));
		}

		return result.toString();
	}

	/**
	 * Gets regular JSON data from the specified file pathway.
	 * 
	 * @param path        The pathway to obtain the JSON data.
	 * @param defaultData The data that is returned if the `.json` file does not exist.
	 * @return            The data that was obtained from the said file. If it was not found, then `null` is returned instead.
	 */
	public static inline function getJsonData(path:String, ?defaultData:Dynamic):Dynamic
	{
		return (Assets.exists(path)) ? Json.parse(Assets.getText(path)) : defaultData;
	}

	/**
	 * Get a dynamic value from a `Dynamic` object. Note that this is meant 
	 * for JSON specific objects.
	 * 
	 * @param object       The JSON `Dynamic` object to obtain the field from.
	 * @param field        The field to get.
	 * @param defaultValue The value that is returned if the field does not exist.
	 * @return             The value found from the said field. If it isn't found, then the
	 *                     `defaultValue` parameter is returned instead.
	 */
	public static inline function getDynamicField(object:Dynamic, field:String, defaultValue:Dynamic):Any
	{
		return (Reflect.hasField(object, field)) ? Reflect.field(object, field) : defaultValue;
	}

	/**
	 * Caches a list of sounds from an `Array`.
	 * 
	 * @param soundArray The list of the file pathways for each sound file to precache.
	 */
	public static function precacheSoundArray(soundArray:Array<String>):Void
	{
		for (snd in soundArray)
		{
			Assets.loadSound(snd);
		}
	}
}
