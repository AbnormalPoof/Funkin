package funkin.ui.options;

/**
 * This class represents a handler for a set of user preferences.
 * It is used by the ScriptedUserPreference class to handle user-defined options.
 */
class UserPreference
{
  /**
   * The internal  ID that this handler is responsible for.
   */
  public var id:String;

  public function new(id:String)
  {
    this.id = id;
  }

  /**
   * Returns an array of preferences.
   * Override this in your script to add custom options!
   */
  public function getPreferences():Array<UserPreferenceData>
  {
    throw 'UserPreference.getPreferences() must be overridden!';
  }

  public function toString():String
  {
    return 'UserPreference(${this.id})';
  }
}

typedef UserPreferenceData =
{
  /**
   * The name to display for this preference.
   */
  var name:String;

  /**
   * The description to display for this preference.
   */
  var description:String;

  /**
   * The type of preference to use.
   */
  var type:String;

  /**
   * A custom function to run when the preference is changed.
   */
  var callback:Dynamic->Void;

  /**
   * The data for this preference.
   * This differs based on the preference type.
   */
  var data:PreferenceTypeData;

  /**
   * The default value for this preference.
   */
  var defaultValue:Dynamic;
}

typedef PreferenceTypeData =
{
  /**
   * NUMBER PREFERENCE ITEMS
   *
   * NOTE: Percentage preference types share min and max!
   */
  /**
   * The minimum value for the number preference.
   */
  @optional
  var min:Float;

  /**
   * The maximum value for the number preference.
   */
  @optional
  var max:Float;

  /**
   * The value to increment/decrement by.
   */
  @optional
  var step:Float;

  /**
   * Rounds decimals up to a certain amount.
   * (ex: 4 -> 0.1234, 2 -> 0.12)
   */
  @optional
  var precision:Int;

  /**
   * If you need to display the value differently, you can set this.
   */
  @optional
  var valueFormatter:Float->String;

  /**
   * ENUM PREFERENCE ITEMS
   */
  /**
   * The keys for the enum preference.
   * This is a map, the first key is the text to display, the second key is the internal value to use for save data.
   *
   * Example:
   * ```
   * ["Display Name" => "someValue"]
   * ```
   */
  @optional
  var keys:Map<String, String>;
}
