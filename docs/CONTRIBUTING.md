# Contributing
Welcome to the Contributing Guide!
You can contribute to the Funkin' repository by opening issues or pull requests. This guide will cover best practices for each type of contribution.

# Part 1: Issues
Issues serve many purposes, from reporting bugs to suggesting new features.
This section provides guidelines to follow when [opening an issue](https://github.com/FunkinCrew/Funkin/issues). 

## Requirements
Make sure you're playing:
- the latest version of the game (currently v0.5.3)
- without any mods
- on [Newgrounds](https://www.newgrounds.com/portal/view/770371) or downloaded from [itch.io](https://ninja-muffin24.itch.io/funkin)

## Rejected Features
If you want to **suggest a feature**, make sure it hasn't already been rejected by the devs!
Here's a list of commonly suggested features that probably won't be added:

| Feature | Reason |
| ------- | ------- |
| Combo Break + Accuracy Displays | https://github.com/FunkinCrew/Funkin/pull/2681#issuecomment-2156308982 |
| Toggleable Ghost Tapping | https://github.com/FunkinCrew/Funkin/pull/2564#issuecomment-2119701802 |
| Perfectly Centered Strumlines | _same as above^_ |
| Losing Icons for DD and Parents | https://github.com/FunkinCrew/Funkin/issues/3048#issuecomment-2243491536 |
| Playable GF / Speaker BF / Speaker Pico | https://github.com/FunkinCrew/Funkin/issues/2953#issuecomment-2216985230 |
| Adjusted Difficulty Ratings | https://github.com/FunkinCrew/Funkin/issues/2781#issuecomment-2172053144 |
| Countdown after Unpausing | https://github.com/FunkinCrew/Funkin/issues/2721#issuecomment-2159330106 |
| Importing Charts from Psych Engine (and other mod content) | https://github.com/FunkinCrew/Funkin/issues/2586#issuecomment-2125733327 |
| Backwards Compatibility for Modding | https://github.com/FunkinCrew/Funkin/issues/3949#issuecomment-2608391329 |
| Lua Support | https://github.com/FunkinCrew/Funkin/issues/2643#issuecomment-2143718093 |

## Issue Types
Choose the issue template that best suits your needs!
Here's what each template is designed for:

### Bug Report ([view list](https://github.com/FunkinCrew/Funkin/issues?q=is%3Aissue%20state%3Aopen%20label%3A%22type%3A%20minor%20bug%22))
For minor bugs and general issues with the game. Choose this one if none of the others fit your needs.

### Crash Report ([view list](https://github.com/FunkinCrew/Funkin/issues?q=is%3Aissue%20state%3Aopen%20label%3A%22type%3A%20major%20bug%22))
For crashes and freezes like the [Null Object Reference](https://github.com/FunkinCrew/Funkin/issues/2209) problem from v0.3.0.

### Charting Issue ([view list](https://github.com/FunkinCrew/Funkin/issues?q=is%3Aissue%20state%3Aopen%20label%3A%22type%3A%20charting%20issue%22))
For misplaced notes, wonky camera movements, broken song events, and everything related to the game's charts.

### Enhancement ([view list](https://github.com/FunkinCrew/Funkin/issues?q=is%3Aissue%20state%3Aopen%20label%3A%22type%3A%20enhancement%22))
For suggestions to add new features or improve existing ones. We'd love to hear your ideas!

### Compiling Help (only after reading the [Troubleshooting Guide](https://github.com/FunkinCrew/Funkin/blob/main/docs/TROUBLESHOOTING.md))
For issues with compiling the game. Legacy versions (before v0.3.0) are not supported.

## Before You Submit...
Use the search bar on the Issues page to check that your issue hasn't already been reported by someone else! 
Duplicate issues make it harder for the devs to keep track of important issues with the game.

Also only report one issue or enhancement at a time! That way they're easier to track.

Once you're sure your issue is unique and specific, feel free to submit it.

**Thank you for opening issues!**

# Part 2: Pull requests
Community members are welcome to contribute their code by [opening pull requests](https://github.com/FunkinCrew/Funkin/pulls).
This section covers guidelines for opening and managing pull requests (PRs).

## Choosing a base branch
When creating a branch in your fork, base your branch on either the `main` or `develop` branch depending on the types of changes you want to make.

Choose the `main` branch if you modify:
- Documentation (`.md` files)
- GitHub files (`.yml` files or anything in the `.github` folder)

Choose the `develop` branch if you modify:
- Game code (`.hx` files)
- Any other type of file

> [!TIP]
> When in doubt, base your branch on the `develop` branch. 

Choosing the right base branch helps keep your commit history clean and avoid merge conflicts.
Once you’re satisfied with the changes you’ve made, open a PR and base it on the same branch you previously chose.

## Merge conflicts and rebasing
Some game updates introduce significant breaking changes that may create merge conflicts in your PR. To resolve them, you will need to update or rebase your PR.

Most merge conflicts are small and will only require you to modify a few files to resolve them. 
However, some changes are so big that your commit history will look like a mess! 
In this case, you will have to perform a [**rebase**](https://docs.github.com/en/get-started/using-git/about-git-rebase). 
This process reapplies your changes on top of the updated branch and cleanly resolves the merge conflicts.

## Code PRs

> [!IMPORTANT]
> This guide does not cover compiling. If you have trouble compiling the game, refer to the [Compilation Guide](https://github.com/FunkinCrew/Funkin/blob/main/docs/COMPILING.md).

Code-based PRs make changes such as **fixing bugs** or **implementing new features** in the game. 
This involves modifying one or several of the repository’s `.hx` files, found within the `source/` folder. 

### Codestyle
Before submitting your PR, check that your code follows the [Style Guide](https://github.com/FunkinCrew/Funkin/blob/main/docs/style-guide.md).

Here are some guidelines for writing comments in your code:
- Leave comments only when you believe a piece of code warrants explanation.
- Ensure that your comments provide meaningful insight into the function or purpose of the code.
- Write your comments in a clear and concise manner.
- Only sign your comments with your name when your changes are complex and may require further explanation.

### DON'T:
```haxe
  /**
    * jumps around the song
    * works with bpm changes but skipped notes still hurt
    * @param sections how many sections to jump, negative = backwards
    */
  function changeSection(sections:Int):Void
  {
    // Pause the music, as you probably guessed
    // FlxG.sound.music.pause();

    // Set the target time in steps, I don’t really get how this works though lol - [GitHub username]
    var targetTimeSteps:Float = Conductor.instance.currentStepTime + (Conductor.instance.stepsPerMeasure * sections);
    var targetTimeMs:Float = Conductor.instance.getStepTimeInMs(targetTimeSteps);

    // Don't go back in time to before the song started, that would probably break a lot of things and cause a whole bunch of problems!
    targetTimeMs = Math.max(0, targetTimeMs);

    if (FlxG.sound.music != null) // If the music is not null, set the time to the target time
    {
      FlxG.sound.music.time = targetTimeMs;
    }

    // Handle skipped notes and events and all that jazz
    handleSkippedNotes();
    SongEventRegistry.handleSkippedEvents(songEvents, Conductor.instance.songPosition);
    // regenNoteData(FlxG.sound.music.time);

    Conductor.instance.update(FlxG.sound?.music?.time ?? 0.0);

    // I hate this function - [GitHub username]
    resyncVocals();
  }
```

### DO:
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

## Documentation PRs
Documentation-based PRs make changes such as **fixing typos** or **adding new information** in documentation files. 
This involves modifying one or several of the repository’s `.md` files, found throughout the repository.
Make sure your changes are easy to understand and formatted consistently to maximize clarity and readability.

> [!IMPORTANT]
> DO NOT TOUCH THE `LICENSE.md` FILE, EVEN TO MAKE SMALL CHANGES!

## GitHub PRs
GitHub-related PRs make changes such as **tweaking Issue Templates** or **updating the repository’s workflows**. 
This involves modifying one or several of the repository’s `.yml` files, or any other file in the `.github` folder.
Please test these changes on your fork’s main branch to avoid breaking anything in this repository (e.g. GitHub Actions, issue templates, etc.)!

## funkin.assets PRs
The `assets` submodule has its own repository called [funkin.assets](https://github.com/FunkinCrew/funkin.assets). 
If you only modify files in the `assets` folder, open a PR in the funkin.assets repository instead of the main repository.
If you simultaneously modify files from both repositories, then open two separate PRs and explain the connection in your PR descriptions.

# Closing
Thank you for reading the Contributing Guide.
We look forward to seeing your contributions to the game!
