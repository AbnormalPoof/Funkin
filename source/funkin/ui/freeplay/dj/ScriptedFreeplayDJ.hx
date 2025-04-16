package funkin.play.ui.freeplay.dj;

/**
 * A script that can be tied to a BaseFreeplayDJ.
 * Create a scripted class that extends BaseFreeplayDJ to use this.
 * Note: Making a scripted class extending BaseFreeplayDJ is not recommended.
 * Do so ONLY if are handling all the Freeplay DJ rendering yourself,
 * and can't use one of the built-in render modes.
 */
@:hscriptClass
class ScriptedBaseFreeplayDJ extends BaseFreeplayDJ implements polymod.hscript.HScriptedClass {}

/**
 * A script that can be tied to a SparrowFreeplayDJ.
 * Create a scripted class that extends SparrowFreeplayDJ,
 * then call `super('charId')` in the constructor to use this.
 */
@:hscriptClass
class ScriptedSparrowFreeplayDJ extends SparrowFreeplayDJ implements polymod.hscript.HScriptedClass {}

/**
 * A script that can be tied to an AnimateAtlasFreeplayDJ.
 * Create a scripted class that extends AnimateAtlasFreeplayDJ,
 * then call `super('charId')` in the constructor to use this.
 */
@:hscriptClass
class ScriptedAnimateAtlasFreeplayDJ extends AnimateAtlasFreeplayDJ implements polymod.hscript.HScriptedClass {}
