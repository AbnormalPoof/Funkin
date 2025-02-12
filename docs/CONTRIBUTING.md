# Contributing
Contributing to the Funkin' repository can be done in 2 ways, issues and pull requests. This guide will cover both ways to contribute.

# Part 1: Issues (TODO: Adapt this to fit the contributors guide)
This part will cover opening issues on the repository.
## Requirements

Make sure you're playing:

    * the latest version of the game (currently v0.5.3)

    * without any mods

    * on [Newgrounds](https://www.newgrounds.com/portal/view/770371) or downloaded from [itch.io](https://ninja-muffin24.itch.io/funkin)


## Rejected Features

If you want to **suggest a feature**, make sure it hasn't already been rejected by the devs! Here's a list of commonly suggested features that probably won't be added:
Feature 	Reason
Combo Break + Accuracy Displays 	[#2681 (comment)](https://github.com/FunkinCrew/Funkin/pull/2681#issuecomment-2156308982)
Toggleable Ghost Tapping 	[#2564 (comment)](https://github.com/FunkinCrew/Funkin/pull/2564#issuecomment-2119701802)
Perfectly Centered Strumlines 	_same as above^_
Losing Icons for DD and Parents 	[#3048 (comment)](https://github.com/FunkinCrew/Funkin/issues/3048#issuecomment-2243491536)
Playable GF / Speaker BF / Speaker Pico 	[#2953 (comment)](https://github.com/FunkinCrew/Funkin/issues/2953#issuecomment-2216985230)
Adjusted Difficulty Ratings 	[#2781 (comment)](https://github.com/FunkinCrew/Funkin/issues/2781#issuecomment-2172053144)
Countdown after Unpausing 	[#2721 (comment)](https://github.com/FunkinCrew/Funkin/issues/2721#issuecomment-2159330106)
Importing Charts from Psych Engine (and other mod content) 	[#2586 (comment)](https://github.com/FunkinCrew/Funkin/issues/2586#issuecomment-2125733327)
Backwards Compatibility for Modding 	[#3949 (comment)](https://github.com/FunkinCrew/Funkin/issues/3949#issuecomment-2608391329)
Lua Support 	[#2643 (comment)](https://github.com/FunkinCrew/Funkin/issues/2643#issuecomment-2143718093)
## Issue Types

Choose the issue template that best suits your needs! Here's what each template is designed for:
#### Bug Report ([view list](https://github.com/FunkinCrew/Funkin/issues?q=sort%3Aupdated-desc+is%3Aissue+state%3Aopen+label%3A%22type%3A+minor+bug%22))

For minor bugs and general issues with the game. Choose this one if none of the others fit your needs.
#### Crash Report ([view list](https://github.com/FunkinCrew/Funkin/issues?q=sort%3Aupdated-desc+is%3Aissue+state%3Aopen+label%3A%22type%3A+major+bug%22))

For crashes and freezes like the [Null Object Reference](https://github.com/FunkinCrew/Funkin/issues/2209) problem from v0.3.0.
#### Charting Issue ([view list](https://github.com/FunkinCrew/Funkin/issues?q=sort%3Aupdated-desc+is%3Aissue+state%3Aopen+label%3A%22type%3A+charting+issue%22))

For misplaced notes, wonky camera movements, broken song events, and everything related to the game's charts.
#### Enhancement ([view list](https://github.com/FunkinCrew/Funkin/issues?q=sort%3Aupdated-desc+is%3Aissue+state%3Aopen+label%3A%22type%3A+enhancement%22))

For suggestions to add new features or improve existing ones. We'd love to hear your ideas!
#### Compiling Help (only after reading the [Troubleshooting Guide](https://github.com/FunkinCrew/Funkin/blob/main/docs/TROUBLESHOOTING.md))

For issues with compiling the game. Legacy versions (before v0.3.0) are not supported.
## Before You Submit...

Use the search bar on the Issues page to check that your issue hasn't already been reported by someone else! Duplicate issues make it harder for the devs to keep track of important issues with the game.

Also only report one issue or enhancement at a time! That way they're easier to track.

Once you're sure your issue is unique and specific, feel free to submit it.

# Part 2: Pull requests (TODO: This section fucking sucks lol)
This part will cover opening and managing pull requests on the repository.

## General
### Picking the correct base branch
It's important to pick the correct base branch when making your repository. A base branch, in short, is the branch that you want to merge your pull requests into. There are 2 branches in particular that you want to keep in mind: `main` and `develop`.

These 2 serve different purposes. **For documentation (editing `.md` files) and GitHub-related (editing `.yml` files or anything in the `.github` folder) changes, the base branch should be `main`**. **For code-related changes (editing `.hx` files), the base branch should be `develop`**.
It's also important to base your pull request branch on the base branch you select, since it could cause significant merge conflicts due to the difference in commit history between `main` and `develop`.

### Merge conflicts and rebasing
The game updates from time to time. When that happens, changes from that version will be pushed to its branches. For minor versions, it's generally not an issue. However, some versions contain significant breaking changes which require you to update your pull request to adapt.

For the most part, the merge conflicts are small, only requiring you to modify 1 or 2 files to update your branch. However, sometimes, a change is so big that your commit history will look like a mess! In this case, you will have to do what's called a [**rebase**](https://docs.github.com/en/get-started/using-git/about-git-rebase). In short, a rebase reapplies your changes on top of another branch, as if they were already there before!

## Code
Creating a code-based pull request involves modifying one or several of the game's `.hx` files, found within the `source/` folder. This will not cover compiling the game since it's assumed that you are able to do so.
### Codestyle
Making sure your code follows the [style guide](https://github.com/FunkinCrew/Funkin/blob/main/docs/style-guide.md) is important.
**You should avoid writing comments that explain already self-explanatory code, or provide little to no explanation on functionality.** Furthermore, signing your name on a comment is discouraged and should only be done sparingly.

DO:
```haxe
  /**
    * Jumps forward or backward a number of sections in the song.
    * Accounts for BPM changes, does not prevent death from skipped notes.
    * @param sections The number of sections to jump, negative to go backwards.
    */
  function changeSection(sections:Int):Void
  {
    // FlxG.sound.music.pause();

    var targetTimeSteps:Float = Conductor.instance.currentStepTime + (Conductor.instance.stepsPerMeasure * sections);
    var targetTimeMs:Float = Conductor.instance.getStepTimeInMs(targetTimeSteps);

    // Don't go back in time to before the song started.
    targetTimeMs = Math.max(0, targetTimeMs);

    if (FlxG.sound.music != null)
    {
      FlxG.sound.music.time = targetTimeMs;
    }

    handleSkippedNotes();
    SongEventRegistry.handleSkippedEvents(songEvents, Conductor.instance.songPosition);
    // regenNoteData(FlxG.sound.music.time);

    Conductor.instance.update(FlxG.sound?.music?.time ?? 0.0);

    resyncVocals();
  }
```

DON'T:
```haxe
  /**
    * Jumps forward or backward a number of sections in the song.
    * Accounts for BPM changes, does not prevent death from skipped notes.
    * @param sections The number of sections to jump, negative to go backwards.
    */
  function changeSection(sections:Int):Void
  {
    // Pause the music
    // FlxG.sound.music.pause();

    // Set the target time in steps
    var targetTimeSteps:Float = Conductor.instance.currentStepTime + (Conductor.instance.stepsPerMeasure * sections);
    var targetTimeMs:Float = Conductor.instance.getStepTimeInMs(targetTimeSteps);

    // Don't go back in time to before the song started.
    targetTimeMs = Math.max(0, targetTimeMs);

    if (FlxG.sound.music != null) // If the music is not null, set the time to the target time
    {
      FlxG.sound.music.time = targetTimeMs;
    }

    // Handle skipped notes and events
    handleSkippedNotes();
    SongEventRegistry.handleSkippedEvents(songEvents, Conductor.instance.songPosition);
    // regenNoteData(FlxG.sound.music.time);


    Conductor.instance.update(FlxG.sound?.music?.time ?? 0.0);

    // I hate this function - [GitHub username]
    resyncVocals();
  }
```

## Documentation
Creating a documentation-based pull request involves modifying one or several of the game's `.md` files, found throughout the repository.
Make sure your documentation is consistent and easy to understand. Furthermore, **DO NOT TOUCH THE `LICENSE` FILE, EVEN TO MAKE SMALL CHANGES!**

## GitHub
Creating a documentation-based pull request involves modifying one or several of the game's `.yml` files, found in the `.github` folder.
Please test these changes on a fork, as this could break one of the repositories functions (i.e GitHub actions, issue templates, etc.)!
