package funkin.data.preferences;

import funkin.ui.options.UserPreference;
import funkin.ui.options.ScriptedUserPreference;
import funkin.util.macro.ClassMacro;

/**
 * This class statically handles the parsing of internal and scripted preference handlers.
 */
class PreferenceRegistry
{
  /**
   * Every built-in preference class must be added to this list.
   */
  static final BUILTIN_PREFERENCES:List<Class<UserPreference>> = ClassMacro.listSubclassesOf(UserPreference);

  /**
   * Map of internal handlers for user preferences.
   * These may be either `ScriptedUserPreferences` or built-in classes extending `UserPreference`.
   */
  static final preferenceCache:Map<String, UserPreference> = new Map<String, UserPreference>();

  public static function loadPreferenceCache():Void
  {
    clearPreferenceCache();

    //
    // BASE GAME OPTIONS
    //
    registerBasePreferences();
    registerScriptedPreferences();
  }

  static function registerBasePreferences()
  {
    trace('Instantiating ${BUILTIN_PREFERENCES.length} built-in user preferences...');
    for (preferenceCls in BUILTIN_PREFERENCES)
    {
      var preferenceClsName:String = Type.getClassName(preferenceCls);
      if (preferenceClsName == 'funkin.ui.options.UserPreference'
        || preferenceClsName == 'funkin.ui.options.ScriptedUserPreference') continue;

      var preference:UserPreference = Type.createInstance(preferenceCls, ["UNKNOWN"]);

      if (preference != null)
      {
        trace('  Loaded built-in user preference: ${preference.id}');
        preferenceCache.set(preference.id, preference);
      }
      else
      {
        trace('  Failed to load built-in user preference: ${Type.getClassName(preferenceCls)}');
      }
    }
  }

  static function registerScriptedPreferences()
  {
    var scriptedPreferenceClassNames:Array<String> = ScriptedUserPreference.listScriptClasses();
    trace('Instantiating ${scriptedPreferenceClassNames.length} scripted user preferences...');
    if (scriptedPreferenceClassNames == null || scriptedPreferenceClassNames.length == 0) return;

    for (preferenceCls in scriptedPreferenceClassNames)
    {
      var preference:UserPreference = ScriptedUserPreference.init(preferenceCls, "UKNOWN");

      if (preference != null)
      {
        trace('  Loaded scripted user preference: ${preference.id}');
        preferenceCache.set(preference.id, preference);
      }
      else
      {
        trace('  Failed to instantiate scripted user preference class: ${preferenceCls}');
      }
    }
  }

  public static function listPreferenceIds():Array<String>
  {
    return preferenceCache.keys().array();
  }

  public static function listPreferences():Array<UserPreference>
  {
    return preferenceCache.values();
  }

  public static function getPreference(id:String):UserPreference
  {
    return preferenceCache.get(id);
  }

  static function clearPreferenceCache()
  {
    preferenceCache.clear();
  }
}
