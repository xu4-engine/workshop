XU4 Module System
=================

Individual adventures are packaged into module files.

* A module is distributed as single file with a .mod extension.
* A module can have variants included in the package.
* A module can extend and/or modify one other module.  Extended modules work
  as an overlay where any resources with the same name in both are taken from
  the extension.
* Each module uses one set of game rules.  The rules are defined in the
  executable program.  Module extensions must use the rules of the base module.
* The module name displayed in the game comes directly from the package
  filename.  The filename may contain spaces.  For display purposes dash and
  underbar characters will be replaced with spaces.
* Each module is developed in separate Git repository (or repository branch).
* Saved games are specific to a module.

It is hoped that the xu4-engine project will develop at least five modules.

Module Name             | Rules      | Notes
------------------------|------------|-----------------------
Ultima-IV               | Ultima-IV  | No graphics, EGA & VGA variants
Quest-of-the-Avatar     | Ultima-IV  | Ultima-IV recreation. VGA & Utne images.
Ultima-V                | Ultima-V   | No graphics.
Warriors-of-Destiny     | Ultima-V   | Ultima-V recreation.
a-custom-adventure      | Dark-Magic | Demonstrates extended capabilities.

NOTE: The Ultima-IV & Ultima-V modules could be embedded in the game
executable to run with only the originial game data and no other external
requirements.


Game Rules
----------

The xu4 program can be compiled so support a number of game rule systems.
Each rule system is enabled with a RULES_ macro.

    RULES_U4
    RULES_U5
    RULES_DARK_MAGIC


Module Header
-------------

```
module [
    author: "John Smith & friends"
    about: {{
        The Avatar must seek the holy grail in order to bring peace
        to the land.
    }}
    version: "1.0-beta"
    rules: Ultima-IV

    ;rules: "Quest-of-the-Avatar/1.0"  ; Example extension.
]
```


Module Versions
---------------

Versions are declared using strings.
