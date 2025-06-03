package fnas.backend;

import fnas.backend.data.ClientPrefs;
import flixel.FlxG;

/**
 * Core class for handling when the user presses a certain control.
 * 
 * There are two ways you can get if a bind is held down or just pressed/released:
 * 
 * ```haxe
 * Controls.binds.YOUR_BIND_PRESSED; // Held down
 * Controls.binds.YOUR_BIND_JUST_PRESSED; // Just pressed
 * Controls.binds.YOUR_BIND_JUST_RELEASED; // Just released
 * ```
 * 
 * ***OR***
 * 
 * ```haxe
 * Controls.pressed('your_bind_id'); // Held down
 * Controls.justPressed('your_bind_id'); // Just pressed
 * Controls.justReleased('your_bind_id'); // Just released
 * ```
 * 
 * It doesn't really matter how you do it, but if you would like to make your
 * bind(s) its own variable, you can do so with the following format:
 * 
 * ```haxe
 * // Notice how the variables are public with no value, while
 * // the functions are private and inline. Technically inline isn't
 * // required, but it's very good for performance since it's just
 * // a simple return statement
 * public var YOUR_BIND_PRESSED(get, never):Bool;
 * public var YOUR_BIND_JUST_PRESSED(get, never):Bool;
 * public var YOUR_BIND_JUST_RELEASED(get, never):Bool;
 * inline function get_YOUR_BIND_PRESSED():Bool return pressed('your_bind_id');
 * inline function get_YOUR_BIND_JUST_PRESSED():Bool return justPressed('your_bind_id');
 * inline function get_YOUR_BIND_JUST_RELEASED():Bool return justReleased('your_bind_id');
 * ```
 */
final class Controls
{
	// Movement (pressed)
	public var MV_UP_PRESSED(get, never):Bool;
	public var MV_LEFT_PRESSED(get, never):Bool;
	public var MV_DOWN_PRESSED(get, never):Bool;
	public var MV_RIGHT_PRESSED(get, never):Bool;

	inline function get_MV_UP_PRESSED():Bool
		return pressed('mv_up');

	inline function get_MV_LEFT_PRESSED():Bool
		return pressed('mv_left');

	inline function get_MV_DOWN_PRESSED():Bool
		return pressed('mv_down');

	inline function get_MV_RIGHT_PRESSED():Bool
		return pressed('mv_right');

	// UI (just pressed)
	public var UI_LEFT_JUST_PRESSED(get, never):Bool;
	public var UI_DOWN_JUST_PRESSED(get, never):Bool;
	public var UI_UP_JUST_PRESSED(get, never):Bool;
	public var UI_RIGHT_JUST_PRESSED(get, never):Bool;
	public var UI_SELECT_JUST_PRESSED(get, never):Bool;
	public var UI_BACK_JUST_PRESSED(get, never):Bool;

	inline function get_UI_LEFT_JUST_PRESSED():Bool
		return justPressed('ui_left');

	inline function get_UI_DOWN_JUST_PRESSED():Bool
		return justPressed('ui_down');

	inline function get_UI_UP_JUST_PRESSED():Bool
		return justPressed('ui_up');

	inline function get_UI_RIGHT_JUST_PRESSED():Bool
		return justPressed('ui_right');

	inline function get_UI_SELECT_JUST_PRESSED():Bool
		return justPressed('ui_select');

	inline function get_UI_BACK_JUST_PRESSED():Bool
		return justPressed('ui_back');

	// Volume (just pressed)
	public var VL_UP_JUST_PRESSED(get, never):Bool;
	public var VL_DOWN_JUST_PRESSED(get, never):Bool;
	public var VL_MUTE_JUST_PRESSED(get, never):Bool;

	inline function get_VL_UP_JUST_PRESSED():Bool
		return justPressed('vl_up');

	inline function get_VL_DOWN_JUST_PRESSED():Bool
		return justPressed('vl_down');

	inline function get_VL_MUTE_JUST_PRESSED():Bool
		return justPressed('vl_mute');

	// Misc. (just pressed)
	public var MS_FULLSCREEN_JUST_PRESSED(get, never):Bool;
	public var MS_OPENEDITORS_JUST_PRESSED(get, never):Bool;

	inline function get_MS_FULLSCREEN_JUST_PRESSED():Bool
		return justPressed('ms_fullscreen');

	inline function get_MS_OPENEDITORS_JUST_PRESSED():Bool
		return justPressed('ms_openeditors');

	function new() {}

	/**
	 * Object used to get the pressed, just pressed and just released controls.
	 */
	static var binds:Controls;

	/**
	 * Gets all pressed, just pressed and just released binds.
	 * 
	 * @return All of the binds the user is interacting with.
	 */
	public static inline function getBinds():Controls
	{
		return binds;
	}

	/**
	 * Check if the user is holding down a certain control.
	 * 
	 * @param bind The bind to check.
	 * @return     If the said bind is being held down.
	 */
	public static inline function pressed(bind:String):Bool
	{
		return FlxG.keys.anyPressed([ClientPrefs.getBinds().get(bind)]);
	}

	/**
	 * Check if the user just pressed a certain control.
	 * 
	 * @param bind The bind to check.
	 * @return     If the said bind was just pressed.
	 */
	public static inline function justPressed(bind:String):Bool
	{
		return FlxG.keys.anyJustPressed([ClientPrefs.getBinds().get(bind)]);
	}

	/**
	 * Check if the user just released a certain control.
	 * 
	 * @param bind The bind to check.
	 * @return     If the said bind just released.
	 */
	public static inline function justReleased(bind:String):Bool
	{
		return FlxG.keys.anyJustReleased([ClientPrefs.getBinds().get(bind)]);
	}

	/**
	 * Check if the user just pressed ***ANY*** volume keys.
	 *  
	 * @return If the user just pressed any volume keys.
	 */
	public static inline function justPressedAnyVolumeKeys():Bool
	{
		return justPressed('vl_up') || justPressed('vl_down') || justPressed('vl_mute');
	}
}
