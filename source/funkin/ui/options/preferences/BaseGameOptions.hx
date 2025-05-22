package funkin.ui.options.preferences;

import funkin.Preferences;
import funkin.ui.options.UserPreference;
import lime.ui.WindowVSyncMode;

/**
 * These are options used by base game.
 */
class BaseGameOptions extends UserPreference
{
  public function new()
  {
    super("BaseGameOptions");
  }

  public override function getPreferences():Array<UserPreferenceData>
  {
    var preferences:Array<UserPreferenceData> = [];

    preferences.push(
      {
        name: "Naughtyness",
        description: "If enabled, raunchy content (such as swearing, etc.) will be displayed.",
        type: "checkbox",
        callback: function(value:Bool) {
          Preferences.naughtyness = value;
        },
        defaultValue: Preferences.naughtyness
      });

    preferences.push(
      {
        name: "Downscroll",
        description: "If enabled, this will make the notes move downwards.",
        type: "checkbox",
        callback: function(value:Bool) {
          Preferences.downscroll = value;
        },
        defaultValue: Preferences.downscroll
      });

    preferences.push(
      {
        name: "Strumline Background",
        description: "Give the strumline a semi-transparent background",
        type: "percentage",
        callback: function(value:Int) {
          Preferences.strumlineBackgroundOpacity = value;
        },
        defaultValue: Preferences.strumlineBackgroundOpacity
      });

    preferences.push(
      {
        name: "Flashing Lights",
        description: "If disabled, it will dampen flashing effects. Useful for people with photosensitive epilepsy.",
        type: "checkbox",
        callback: function(value:Bool) {
          Preferences.flashingLights = value;
        },
        defaultValue: Preferences.flashingLights
      });

    preferences.push(
      {
        name: "Camera Zooms",
        description: "If disabled, camera stops bouncing to the song.",
        type: "checkbox",
        callback: function(value:Bool) {
          Preferences.zoomCamera = value;
        },
        defaultValue: Preferences.zoomCamera
      });

    preferences.push(
      {
        name: "Debug Display",
        description: "If enabled, FPS and other debug stats will be displayed.",
        type: "checkbox",
        callback: function(value:Bool) {
          Preferences.debugDisplay = value;
        },
        defaultValue: Preferences.debugDisplay
      });

    preferences.push(
      {
        name: "Pause on Unfocus",
        description: "If enabled, game automatically pauses when it loses focus.",
        type: "checkbox",
        callback: function(value:Bool) {
          Preferences.autoPause = value;
        },
        defaultValue: Preferences.autoPause
      });

    preferences.push(
      {
        name: "Launch in Fullscreen",
        description: "Automatically launch the game in fullscreen on startup",
        type: "checkbox",
        callback: function(value:Bool) {
          Preferences.autoFullscreen = value;
        },
      });

    // disabled on macos due to "error: Late swap tearing currently unsupported"
    #if !mac
    preferences.push(
      {
        name: "VSync",
        description: "If enabled, game will attempt to match framerate with your monitor.",
        type: "enum",
        callback: function(key:String, value:WindowVSyncMode) {
          trace("Setting vsync mode to " + key);
          Preferences.vsyncMode = value;
        },
        defaultValue: switch (Preferences.vsyncMode)
        {
          case WindowVSyncMode.OFF: "Off";
          case WindowVSyncMode.ON: "On";
          case WindowVSyncMode.ADAPTIVE: "Adaptive";
        },
        data:
          {
            keys: [
              "Off" => WindowVSyncMode.OFF,
              "On" => WindowVSyncMode.ON,
              "Adaptive" => WindowVSyncMode.ADAPTIVE,
            ]
          },
      });
    #end

    #if web
    preferences.push(
      {
        name: "Unlocked Framerate",
        description: "If enabled, the framerate will be unlocked.",
        type: "checkbox",
        callback: function(value:Bool) {
          Preferences.unlockedFramerate = value;
        },
        defaultValue: Preferences.unlockedFramerate
      });
    #else
    preferences.push(
      {
        name: "FPS",
        description: "The maximum framerate that the game targets.",
        type: "number",
        callback: function(value:Float) {
          Preferences.framerate = Std.int(value);
        },
        defaultValue: Preferences.framerate,
        data:
          {
            min: 30,
            max: 300,
            step: 5,
            precision: 0
          }
      });
    #end

    preferences.push(
      {
        name: "Hide Mouse",
        description: "If enabled, the mouse will be hidden when taking a screenshot.",
        type: "checkbox",
        callback: function(value:Bool) {
          Preferences.shouldHideMouse = value;
        },
        defaultValue: Preferences.shouldHideMouse
      });

    preferences.push(
      {
        name: "Fancy Preview",
        description: "If enabled, a preview will be shown after taking a screenshot.",
        type: "checkbox",
        callback: function(value:Bool) {
          Preferences.fancyPreview = value;
        },
        defaultValue: Preferences.fancyPreview
      });

    preferences.push(
      {
        name: "Preview on save",
        description: "If enabled, the preview will be shown only after a screenshot is saved.",
        type: "checkbox",
        callback: function(value:Bool) {
          Preferences.previewOnSave = value;
        },
        defaultValue: Preferences.previewOnSave
      });

    preferences.push(
      {
        name: "Save Format",
        description: "Save screenshots to this format.",
        type: "enum",
        callback: function(value:String, oValue:String) {
          Preferences.saveFormat = value;
        },
        data:
          {
            keys: ["PNG" => "PNG", "JPEG" => "JPEG"]
          },
        defaultValue: Preferences.saveFormat
      });

    preferences.push(
      {
        name: "JPEG Quality",
        description: "The quality of JPEG screenshots.",
        type: "number",
        callback: function(value:Float) {
          Preferences.jpegQuality = Std.int(value);
        },
        defaultValue: Preferences.jpegQuality,
        data:
          {
            min: 0,
            max: 100,
            step: 5,
            precision: 0
          }
      });

    return preferences;
  }
}
