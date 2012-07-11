mplayer2.app 
============

mplayer2.app is a modern mplayer2 GUI for Mac OS X. It's main goal is
to be minimal, fast and preserve as much as possible of the slick keyboard
driven experience that you get with mplayer2 running standalone as well
as the great configurability.

Work in progress
----------------

Please notice that this software is still Work in progress. At this point
nothing is working.

Design goals
------------

*  Clear, modular, tested code. Even if the end user can't see it, good code
   will impact the overall quality of the application. It will also be more
   easily maintainable.
*  Avoid bloat as much as possible, both in term of features and perfomance.
*  Preserve mplayer2's customizability. Traditionally, Mac OS X have tried
   to hide the customization part of mplayer2 in favor of ease of use. Even if
   sane defaults are good, mplayer2 shines for it's customizability.
*  Preserve mplayer2's keyboard mapping. As much as Cocoa conventions
   are good, mplayer2 has a very nice keyboard mapping that GUIs tend
   to hide.


Coding and contribution guidelines
----------------------------------

*  Use soft tabs with 4 spaces indent and don't exceed 80 columns per row.
*  Add the XCode project file to the commit only if you actually changed
   something in the project (i.e.: added some libraries, changed
   something to the build targets etc). Also please describe the nature
   of your changes to the project file in the commit text. Since the
   project file is pretty much a binary format it would be hard to tell
   what changed otherwise.
*  Write commit messages in imperative form. The text should summarize
   briefly what you changed and why you changed it.
*  Write unit tests!