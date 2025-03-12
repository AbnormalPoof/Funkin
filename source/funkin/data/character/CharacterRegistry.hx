package funkin.data.character;

import flixel.graphics.frames.FlxFrame;
import funkin.data.character.CharacterData;
import funkin.play.character.AnimateAtlasCharacter;
import funkin.play.character.BaseCharacter;
import funkin.play.character.BaseCharacter;
import funkin.play.character.MultiSparrowCharacter;
import funkin.modding.events.ScriptEventDispatcher;
import funkin.modding.events.ScriptEvent;
import funkin.play.character.PackerCharacter;
import funkin.play.character.ScriptedCharacter.ScriptedAnimateAtlasCharacter;
import funkin.play.character.ScriptedCharacter.ScriptedBaseCharacter;
import funkin.play.character.ScriptedCharacter.ScriptedMultiSparrowCharacter;
import funkin.play.character.ScriptedCharacter.ScriptedPackerCharacter;
import funkin.play.character.ScriptedCharacter.ScriptedSparrowCharacter;
import funkin.play.character.SparrowCharacter;
import funkin.util.assets.DataAssets;
import funkin.util.VersionUtil;

/**
 * NOTE: This doesn't act the same as the other registries.
 * It doesn't implement `BaseRegistry` and fetching produces a new instance rather than reusing them.
 */
class CharacterRegistry extends BaseRegistry<BaseCharacter, CharacterData>
{
  /**
   * The current version string for the character data format.
   * Handle breaking changes by incrementing this value
   * and adding migration to the `migrateCharacterData()` function.
   */
  public static final CHARACTER_DATA_VERSION:String = '1.1.0';

  /**
   * The current version rule check for the character data format.
   */
  public static final CHARACTER_DATA_VERSION_RULE:String = '1.0.x';

  /**
   * The default danceEvery value for characters.
   */
  public static final DEFAULT_DANCEEVERY:Float = 1.0;

  static final characterCache:Map<String, CharacterData> = new Map<String, CharacterData>();
  static final characterScriptedClass:Map<String, String> = new Map<String, String>();

  static final DEFAULT_CHAR_ID:String = 'unknown';

  public static var instance(get, never):CharacterRegistry;
  static var _instance:Null<CharacterRegistry> = null;

  static function get_instance():CharacterRegistry
  {
    if (_instance == null) _instance = new CharacterRegistry();
    return _instance;
  }

  public function new()
  {
    super('CHARACTER', 'characters', CHARACTER_DATA_VERSION_RULE);
  }

  /**
   * Parses and preloads the game's stage data and scripts when the game starts.
   *
   * If you want to force stages to be reloaded, you can just call this function again.
   */
  public static function loadCharacterCache():Void
  {
    // Clear any stages that are cached if there were any.
    clearCharacterCache();
    trace('[CHARACTER] Parsing all entries...');

    //
    // UNSCRIPTED CHARACTERS
    //
    var charIdList:Array<String> = CharacterRegistry.instance.listEntryIds();
    var unscriptedCharIds:Array<String> = charIdList.filter(function(charId:String):Bool {
      return !characterCache.exists(charId);
    });
    trace('  Fetching data for ${unscriptedCharIds.length} characters...');
    for (charId in unscriptedCharIds)
    {
      try
      {
        var charData:CharacterData = parseCharacterData(charId);
        if (charData != null)
        {
          trace('    Loaded character data: ${charId}');
          characterCache.set(charId, charData);
        }
      }
      catch (e)
      {
        // Assume error was already logged.
        continue;
      }
    }

    //
    // SCRIPTED CHARACTERS
    //

    // Fuck I wish scripted classes supported static functions.

    var scriptedCharClassNames1:Array<String> = ScriptedSparrowCharacter.listScriptClasses();
    if (scriptedCharClassNames1.length > 0)
    {
      trace('  Instantiating ${scriptedCharClassNames1.length} (Sparrow) scripted characters...');
      for (charCls in scriptedCharClassNames1)
      {
        try
        {
          var character:SparrowCharacter = ScriptedSparrowCharacter.init(charCls, DEFAULT_CHAR_ID);
          trace('  Initialized character ${character.characterName}');
          characterScriptedClass.set(character.characterId, charCls);
        }
        catch (e)
        {
          trace('    FAILED to instantiate scripted Sparrow character: ${charCls}');
          trace(e);
        }
      }
    }

    var scriptedCharClassNames2:Array<String> = ScriptedPackerCharacter.listScriptClasses();
    if (scriptedCharClassNames2.length > 0)
    {
      trace('  Instantiating ${scriptedCharClassNames2.length} (Packer) scripted characters...');
      for (charCls in scriptedCharClassNames2)
      {
        try
        {
          var character:PackerCharacter = ScriptedPackerCharacter.init(charCls, DEFAULT_CHAR_ID);
          characterScriptedClass.set(character.characterId, charCls);
        }
        catch (e)
        {
          trace('    FAILED to instantiate scripted Packer character: ${charCls}');
          trace(e);
        }
      }
    }

    var scriptedCharClassNames3:Array<String> = ScriptedMultiSparrowCharacter.listScriptClasses();
    if (scriptedCharClassNames3.length > 0)
    {
      trace('  Instantiating ${scriptedCharClassNames3.length} (Multi-Sparrow) scripted characters...');
      for (charCls in scriptedCharClassNames3)
      {
        try
        {
          var character:MultiSparrowCharacter = ScriptedMultiSparrowCharacter.init(charCls, DEFAULT_CHAR_ID);
          characterScriptedClass.set(character.characterId, charCls);
        }
        catch (e)
        {
          trace('    FAILED to instantiate scripted Multi-Sparrow character: ${charCls}');
          trace(e);
        }
      }
    }

    var scriptedCharClassNames4:Array<String> = ScriptedAnimateAtlasCharacter.listScriptClasses();
    if (scriptedCharClassNames4.length > 0)
    {
      trace('  Instantiating ${scriptedCharClassNames4.length} (Animate Atlas) scripted characters...');
      for (charCls in scriptedCharClassNames4)
      {
        try
        {
          var character:AnimateAtlasCharacter = ScriptedAnimateAtlasCharacter.init(charCls, DEFAULT_CHAR_ID);
          characterScriptedClass.set(character.characterId, charCls);
        }
        catch (e)
        {
          trace('    FAILED to instantiate scripted Animate Atlas character: ${charCls}');
          trace(e);
        }
      }
    }

    // NOTE: Only instantiate the ones not populated above.
    // ScriptedBaseCharacter.listScriptClasses() will pick up scripts extending the other classes.
    var scriptedCharClassNames:Array<String> = ScriptedBaseCharacter.listScriptClasses();
    scriptedCharClassNames = scriptedCharClassNames.filter(function(charCls:String):Bool {
      return !(scriptedCharClassNames1.contains(charCls)
        || scriptedCharClassNames2.contains(charCls)
        || scriptedCharClassNames3.contains(charCls)
        || scriptedCharClassNames4.contains(charCls));
    });

    if (scriptedCharClassNames.length > 0)
    {
      trace('  Instantiating ${scriptedCharClassNames.length} (Base) scripted characters...');
      for (charCls in scriptedCharClassNames)
      {
        var character:BaseCharacter = ScriptedBaseCharacter.init(charCls, DEFAULT_CHAR_ID, Custom);
        if (character == null)
        {
          trace('    Failed to instantiate scripted character: ${charCls}');
          continue;
        }
        else
        {
          trace('    Successfully instantiated scripted character: ${charCls}');
          characterScriptedClass.set(character.characterId, charCls);
        }
      }
    }

    trace('  Successfully loaded ${Lambda.count(characterCache)} stages.');
  }

  /**
   * Fetches data for a character and returns a BaseCharacter instance,
   * ready to be added to the scene.
   * @param charId The character ID to fetch.
   * @return The character instance, or null if the character was not found.
   */
  public static function fetchCharacter(charId:String, debug:Bool = false):Null<BaseCharacter>
  {
    if (charId == null || charId == '' || !characterCache.exists(charId))
    {
      // Gracefully handle songs that don't use this character,
      // or throw an error if the character is missing.

      if (charId != null && charId != '') trace('Failed to build character, not found in cache: ${charId}');
      return null;
    }

    var charData:CharacterData = CharacterRegistry.instance.parseEntryData(charId);
    var charScriptClass:String = characterScriptedClass.get(charId);

    var char:BaseCharacter;

    if (charScriptClass != null)
    {
      switch (charData.renderType)
      {
        case CharacterRenderType.AnimateAtlas:
          char = ScriptedAnimateAtlasCharacter.init(charScriptClass, charId);
        case CharacterRenderType.MultiSparrow:
          char = ScriptedMultiSparrowCharacter.init(charScriptClass, charId);
        case CharacterRenderType.Sparrow:
          char = ScriptedSparrowCharacter.init(charScriptClass, charId);
        case CharacterRenderType.Packer:
          char = ScriptedPackerCharacter.init(charScriptClass, charId);
        default:
          // We're going to assume that the script class does the rendering.
          char = ScriptedBaseCharacter.init(charScriptClass, charId, CharacterRenderType.Custom);
      }
    }
    else
    {
      switch (charData.renderType)
      {
        case CharacterRenderType.AnimateAtlas:
          char = new AnimateAtlasCharacter(charId);
        case CharacterRenderType.MultiSparrow:
          char = new MultiSparrowCharacter(charId);
        case CharacterRenderType.Sparrow:
          char = new SparrowCharacter(charId);
        case CharacterRenderType.Packer:
          char = new PackerCharacter(charId);
        default:
          trace('[WARN] Creating character with undefined renderType ${charData.renderType}');
          char = new BaseCharacter(charId, CharacterRenderType.Custom);
      }
    }

    if (char == null)
    {
      trace('Failed to instantiate character: ${charId}');
      return null;
    }

    trace('Successfully instantiated character (${debug ? 'debug' : 'stable'}): ${charId}');

    char.debug = debug;

    // Call onCreate only in the fetchCharacter() function, not at application initialization.
    ScriptEventDispatcher.callEvent(char, new ScriptEvent(CREATE));

    return char;
  }

  /**
   * Returns the idle frame of a character.
   */
  public static function getCharPixelIconAsset(char:String):FlxFrame
  {
    var charPath:String = "freeplay/icons/";

    // FunkinCrew please dont skin me alive for copying pixelated icon and changing it a tiny bit
    switch (char)
    {
      case "bf-christmas" | "bf-car" | "bf-pixel" | "bf-holding-gf" | "bf-dark":
        charPath += "bfpixel";
      case "monster-christmas":
        charPath += "monsterpixel";
      case "mom" | "mom-car":
        charPath += "mommypixel";
      case "pico-blazin" | "pico-playable" | "pico-speaker":
        charPath += "picopixel";
      case "gf-christmas" | "gf-car" | "gf-pixel" | "gf-tankmen" | "gf-dark":
        charPath += "gfpixel";
      case "dad":
        charPath += "dadpixel";
      case "darnell-blazin":
        charPath += "darnellpixel";
      case "senpai-angry":
        charPath += "senpaipixel";
      case "spooky-dark":
        charPath += "spookypixel";
      case "tankman-atlas":
        charPath += "tankmanpixel";
      case "pico-christmas" | "pico-dark":
        charPath += "picopixel";
      default:
        charPath += '${char}pixel';
    }

    if (!Assets.exists(Paths.image(charPath)))
    {
      trace('[WARN] Character ${char} has no freeplay icon.');
      return null;
    }

    var isAnimated = Assets.exists(Paths.file('images/$charPath.xml'));
    var frame:FlxFrame = null;

    if (isAnimated)
    {
      var frames = Paths.getSparrowAtlas(charPath);

      var idleFrame:FlxFrame = frames.frames.find(function(frame:FlxFrame):Bool {
        return frame.name.startsWith('idle');
      });

      if (idleFrame == null)
      {
        trace('[WARN] Character ${char} has no idle in their freeplay icon.');
        return null;
      }

      // so, haxe.ui.backend.AssetsImpl uses the parent width and height, which makes the image go crazy when rendered
      // so this is a work around so that it uses the actual width and height
      var imageGraphic = flixel.graphics.FlxGraphic.fromFrame(idleFrame);

      var imageFrame = flixel.graphics.frames.FlxImageFrame.fromImage(imageGraphic);
      frame = imageFrame.frame;
    }
    else
    {
      var imageFrame = flixel.graphics.frames.FlxImageFrame.fromImage(Paths.image(charPath));
      frame = imageFrame.frame;
    }

    return frame;
  }

  /**
   * Clears the character data cache.
   */
  static function clearCharacterCache():Void
  {
    if (characterCache != null)
    {
      characterCache.clear();
    }
    if (characterScriptedClass != null)
    {
      characterScriptedClass.clear();
    }
  }

  /**
   * Read, parse, and validate the JSON data and produce the corresponding data object.
   */
  public function parseEntryData(id:String):Null<CharacterData>
  {
    // JsonParser does not take type parameters,
    // otherwise this function would be in BaseRegistry.
    var parser = new json2object.JsonParser<CharacterData>();
    parser.ignoreUnknownVariables = false;

    switch (loadEntryFile(id))
    {
      case {fileName: fileName, contents: contents}:
        parser.fromJson(contents, fileName);
      default:
        return null;
    }

    if (parser.errors.length > 0)
    {
      printErrors(parser.errors, id);
      return null;
    }
    return parser.value;
  }

  /**
   * Parse and validate the JSON data and produce the corresponding data object.
   *
   * NOTE: Must be implemented on the implementation class.
   * @param contents The JSON as a string.
   * @param fileName An optional file name for error reporting.
   */
  public function parseEntryDataRaw(contents:String, ?fileName:String):Null<CharacterData>
  {
    var parser = new json2object.JsonParser<CharacterData>();
    parser.ignoreUnknownVariables = false;
    parser.fromJson(contents, fileName);

    if (parser.errors.length > 0)
    {
      printErrors(parser.errors, fileName);
      return null;
    }
    return parser.value;
  }

  /**
   * Load a character's JSON file and parse its data.
   *
   * @param charId The character to load.
   * @return The character data, or null if validation failed.
   */
  public static function parseCharacterData(charId:String):Null<CharacterData>
  {
    var charData:CharacterData = parseEntryData(charId);

    if (CHARACTER_DATA_VERSION_RULE == null || VersionUtil.validateVersionStr(charData.version, CHARACTER_DATA_VERSION_RULE))
    {
      return migrateCharacterData(charData, charId);
    }
    else if (VersionUtil.validateVersion(charData.version, "1.0.x"))
    {
      return migrateCharacterData_v1_0_0(charData, charId);
    }
    else
    {
      trace('[CHARACTER] Could not load character data for "$charId": bad version (got ${charData.version}, expected ${CHARACTER_DATA_VERSION_RULE})');
      return null;
    }
  }

  /**
   * Apply operations to prevent regressions when updating character data.
   */
  static function migrateCharacterData_v1_0_0(result:Null<CharacterData>, charId:String):Null<CharacterData>
  {
    if (result == null) return null;

    // These values are new, and default to enabled on newer metadata versions,
    // but should be forced to false for older character data to prevent breaking existing characters.
    result.flipXOffsets = false;
    result.flipSingAnimations = false;

    // NOTE: Migration should be STACKED!
    // So migrate 1.0.0->1.1.0->1.2.0, etc.
    return migrateCharacterData(result, charId);
  }

  /**
   * Apply migration operations which are relevant for all character data.
   * This is mostly applying non-primitive default values.
   */
  static function migrateCharacterData(result:Null<CharacterData>, charId:String):Null<CharacterData>
  {
    if (result.healthIcon == null)
    {
      result.healthIcon = {};
    }

    if (result.healthIcon.id == null)
    {
      result.healthIcon.id = charId;
    }

    // If `flipXOffsets` is enabled, we need to account for the default value of `flipX`.
    if (result.flipX && result.flipXOffsets)
    {
      for (anim in result.animations)
      {
        anim.offsets[0] *= -1;
      }
    }

    return result;
  }
}
