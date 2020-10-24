# Simply Macro
Simply Macro is a fork of Simply Love for SM5 with MochitheDog's DDR game mode edits and additional edits to compensate for different simfile offset standards.

## Why?
Step artists/simfile creators sync songs differently. Many sync to a null offset, whereas others sync to account for play on an ITG dedicab (+9 ms). Our primary objective here is to allow for play of both kinds of simfiles and songs without worrying about conforming every song to a single offset standard or using multiple StepMania setups. To accomplish this, Simply Macro sets StepMania's global offset each session based on whether you select DDR or ITG as your game mode.

## Quick setup guide
1. Make sure your GlobalOffsetSeconds is accurate for null offset-synced songs (i.e., songs not synced to account for ITG's +9 ms)
2. Install Simply Macro by dropping the folder in [your SM folder]/Themes/
3. Switch the game's active theme to Simply Macro
4. ???
5. Profit!

## Implemented features/changes
- [x] [MochitheDog's DDR game mode](https://github.com/MochitheDog/Simply-Love-SM5) for Simply Love
- [x] Different global offsets for DDR and ITG modes
- [x] Decents and WayOffs are disabled by default in ITG modes
- [x] TimingWindowAdd set to zero for DDR

## Potential features/changes
- [ ] ITG/FA+ game modes show only the song groups defined by the user (i.e., ITG songs and others synced for +9 ms) in a way similar to how song groups are defined for Casual mode, whereas DDR game mode shows everything else
- [ ] DDR-specific judgment graphics that match Wendy and/or are similar to Love

## What do you get with DDR game mode?
- Selectable DDR mode at game start enables DDR-approximate timing windows as follows (in seconds):
  - Marvelous: 0.016667,
  - Perfect: 0.033333,
  - Great: 0.091667,
  - Good: 0.141667,
  - Boo (disabled by default): 0.225000
- Judgments are renamed from ITG names to DDR names as seen above.
- "Goods" count towards combo.
- Scores earned in DDR mode are saved to a separate .xml file.

Note: Life mechanics in DDR mode have *not* been changed from Simply Love's ITG settings. Scoring is also percentage-based as it is in vanilla Simply Love/ITG.

<details>
  <summary>Click to see screenshots of DDR game mode.</summary>

![DDR mode select](https://i.imgur.com/u32ZOLV.png)

![DDR mode eval](https://i.imgur.com/ZXs5qSB.png)
</details>

## How are the different offsets implemented?
This fork uses a new theme preference called DDROffset. The value of DDROffset should be the same as what GlobalOffsetSeconds should be if you've properly synced your pads to play songs with a null offset. The first time you use Simply Macro, the game will set your DDROffset as whatever GlobalOffsetSeconds is.

When you select your game mode, if you've selected DDR, the game sets GlobalOffsetSeconds as the value of DDROffset. If instead you've selected ITG or FA+, the game sets GlobalOffsetSeconds as the value of DDROffset minus 0.009.

## How do I set DDROffset manually?
After you run the game with Simply Macro for the first time, you'll be able to find DDROffset as a preference in ThemePrefs.ini. As mentioned above, if the game does not detect a value for DDROffset, it will use the current value of GlobalOffsetSeconds to set DDROffset. (There's currently a weird rounding issue here, but the difference is so minor that, practically speaking, I don't think it'll matter to anyone; we're talking less than a microsecond. Still, it might be nice to clean this up sometime.) You may modify the value manually just as you'd otherwise modify GlobalOffsetSeconds in Preferences.ini if you were using vanilla Simply Love or a different theme.

**CAUTION: Any adjustments you make to GlobalOffsetSeconds by editing Preferences.ini will be overridden whenever you select a game mode in this theme.** Likewise, if you use AutoSync or otherwise adjust GlobalOffsetSeconds in the game, the changed GlobalOffsetSeconds value will get overridden based on DDROffset the next time you select a game mode.

You may thus want to make note of any AutoSync-suggested change to manually edit DDROffset after you exit the game. Alternatively, switch to vanilla Simply Love, use AutoSync with a song you know is synced to a null offset, exit the game, and delete DDROffset from ThemePrefs.ini before starting the game (and switching back to Simply Macro) again.

All of this can be a bit tricky, so I highly recommend figuring out what your DDROffset (i.e., GlobalOffsetSeconds for a null offset-synced song) should be before using this theme for the first time. And if you want to switch back to using vanilla Simply Love or another theme as your "daily driver," make sure that your GlobalOffsetSeconds is properly set when you do so.

## Why did you disable Decents and WayOffs by default?
In the past several years of playing DDR A, I've gotten used to ghost-stepping in a way that often triggers Decents and WayOffs on ITG, so I now almost always turn off "The Boys." I find the game much more enjoyable without them. Vanilla Simply Love resets the relevant setting every time you start a new game session, and I would prefer not having to do that. Thus, I've disabled them by default.

## Other limitations
Unfortunately, you have to use this in English for now.

## Acknowledgements
- Special thanks to quietly-turning for creating, maintaining, and adding new features to [Simply Love for SM5](https://github.com/quietly-turning/Simply-Love-SM5), as well as to MochitheDog for implementing the DDR game mode and sharing it with the world. Honestly, this fork is basically the same as [MochitheDog's](https://github.com/MochitheDog/Simply-Love-SM5) when I cloned it, plus a few edits for my personal setup.
- Additional judgment graphics by zenius-i-vanisher user bLOOdSAW/HURG: https://zenius-i-vanisher.com/v5.2/thread?threadid=8936&page=1

## Finally...
This fork is primarily meant to be useful for myself. Still, as I continue working on this, I'm open to ideas, suggestions, bug reports, or anything, really. And please forgive any issues. This is the first time I've used git or GitHub, the first time I've made any edit to a StepMania theme, and the first time I've done anything in Lua. In any case, I hope this is useful for some of you. Thanks for checking this out, and stay cool!
—13wonders (*last updated 10/23/2020*)
