package funkin.play.ui.freeplay.dj;

/**
 * A script that can be tied to a ScriptedBaseFreeplayDJ.
 * Create a scripted class that extends BaseFreeplayDJ to use this.
 * Note: Making a scripted class extending BaseFreeplayDJ is not recommended.
 * Do so ONLY if are handling all the rendering yourself,
 * and can't use one of the built-in render modes.
 */
@:hscriptClass
class ScriptedBaseFreeplayDJ extends BaseFreeplayDJ implements polymod.hscript.HScriptedClass {}

/**
 * A script that can be tied to a AnimateAtlasFreeplayDJ.
 * Create a scripted class that extends FreeplayDJ to use this.
 */
@:hscriptClass
class ScriptedAnimateAtlasFreeplayDJ extends AnimateAtlasFreeplayDJ implements polymod.hscript.HScriptedClass {}

/**
 * A script that can be tied to a SparrowFreeplayDJ.
 * Create a scripted class that extends FreeplayDJ to use this.
 */
@:hscriptClass
class ScriptedSparrowFreeplayDJ extends SparrowFreeplayDJ implements polymod.hscript.HScriptedClass {}
