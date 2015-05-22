# AMX VOLUME CONTROL LIBRARY

amx-lib-volume

This library contains the code to set up and manipulate volume controls from within an AMX Netlinx project.

*THIS IS A THIRD-PARTY LIBRARY AND IS NOT AFFILIATED WITH THE AMX ORGANIZATION*

## Overview

[TOC]


## Download

**Git Users:**

https://github.com/amclain/amx-lib-volume


**Mercurial Users:**

https://bitbucket.org/amclain/amx-lib-volume


**Zip File:**

Both sites above offer a feature to download the source code as a zip file.
Any stable release, as well as the current development snapshot can be downloaded.


## Issues, Bugs, Feature Requests

Any bugs and feature requests should be reported on the GitHub issue tracker:

https://github.com/amclain/amx-lib-volume/issues


**Pull requests are preferred via GitHub.**

Mercurial users can use [Hg-Git](http://hg-git.github.io/) to interact with
GitHub repositories.


## Snake Case Wrapper

A wrapper that converts the library functions to snake case is available
as `amx-lib-volume-sc.axi`. When using this file, be sure to add the base
library `amx-lib-volume.axi` to the workspace.


## Usage

### Conventions

`VOL_` prefixes all library constants, and `vol` prefixes all library functions. `volArray` prefixes any functions that operate on an array of structure `volume`.

Constants are snake case (underscores separate words) with all uppercase letters.

Function names are camel case with the first letter being lowercase. If using the
snake case wrapper file, then all function names are snake case with all lowercase
characters.

Volume levels have a native resolution of 16 bits (integer). The `...AsByte` functions can be applied to convert these levels to 8 bit (char) values.


### Volume Control Structure

All of the data for a volume control is stored in the `volume` structure. These variables
are considered private and therefore it is ***not*** recommended to access them directly.
Instead, helper functions are provided to perform operations on the structure.

``` c
struct volume
{
    integer lvl;    // Volume level.
    char mute;      // Mute status (VOL_MUTED | VOL_UNMUTED).
    integer max;    // Max volume level limit.  Assumed full-on ($FFFF) if not set.
    integer min;    // Min volume level limit.  Assumed full-off ($0000) if not set.
    integer step;   // Amount to raise/lower the volume level when incremented or
                    // decremented.
    char dim;             // Level dim status (VOL_DIM_ON | VOL_DIM_OFF).
    integer dimAmount;    // Amount to reduce the level when dim is on.
}
```

### Constants

In order to make it easier to distinguish a control's mute state when reading code, the constants `VOL_MUTED` and `VOL_UNMUTED` are defined.

``` c
// Volume control mute states.
VOL_UNMUTED	= 0;
VOL_MUTED	= 1;
```

Likewise, the same applies to the level dim state.

``` c
// Volume control dim states.
VOL_DIM_OFF	= 0;
VOL_DIM_ON	= 1;
```

Some of the functions in the volume control library return a status message of type `sinteger`.  These codes are mapped to the following constants, with failures being negative numbers.

``` c
// Function return messages.
VOL_SUCCESS		=  0;	// Operation succeded.
VOL_FAILED		= -1;	// Generic operation failure.
VOL_LIMITED		= -2;	// Input value was limited and may not have reached its
                        // specified value.
VOL_PARAM_NOT_SET	= -3;	// Parameter was not set.
VOL_OUT_OF_BOUNDS	= -4;	// Index boundry exceeded.
```


### Functions

#### Including The Library

To include the volume control library, place the include statement just before the `DEFINE_DEVICE` section.

``` c
// Include the volume control library.
#include 'amx-lib-volume'

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE
```


#### Initializing A Control

First, define a variable of type `volume` to act as a volume control.

``` c
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volume mic1; // Define a volume control.
```

Call the helper function `volInit()` to initialize the control with a level, mute state, min limit, max limit, and number of steps between the min and max limits.  The min, max, and step parameters can be set to `0` if they're not needed.

``` c
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

volInit(mic1, 0, VOL_UNMUTED, 10000, 20000, 5); // Initialize the volume control.
```

Note that although the volume level `0` is passed, the min limit will be applied, resulting in an actual initialization level of `10,000`.


#### Initializing An Array Of Controls

Initializing an array of volume controls is just as easy as initializing a single control, as the library contains functions to operate on arrays.  Volume control arrays can be used to group devices, link channels, create zones, etc.

First, define an array of type `volume`.

``` c
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

// Define a volume control array for the input devices.
volume inputs[8];
```

Call the helper function `volArrayInit()` to initialize all controls in the array with a level, mute state, min limit, max limit, and number of steps.  The min, max, and step parameters can be set to `0` if they're not needed.

``` c
(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

// Initialize the array of volume controls.
volArrayInit(inputs, 0, VOL_UNMUTED, 10000, 20000, 5);
```

All eight volume controls in the array are now ready for use!


#### Getting Volume Levels

To read the level of a volume control, use `volGetLevel()` or `volGetLevelAsByte()`.  The function takes min/max limits into account.

``` c
level = volGetLevel(mic1); // Saves the volume level of mic 1 to "level".
```

If you want to get the level while taking the mute state into account, use the funtion `volGetLevelPostMute()`. This can be used for updating an audio DSP without having to manage its mute control.

``` c
level = volGetLevelPostMute(mic1); // Returns the volume level if unmuted,
                                   // or 0 if muted.
```

The `...AsByte` functions provide an easy way to scale values down to a range of 0-255, which is convenient for updating bar graphs on touch panels.

``` c
send_level dvTouchPanel, LEVEL_MIC_1, volGetLevelAsByte(mic1);
```


#### Setting Volume Levels

Setting a volume level is performed by calling `volSetLevel()` or `volSetLevelAsByte()`.  This function takes into account min/max limits, but *does not* affect mute status.  This means volume levels can be adjusted while a channel is muted, and the change will be heard once the channel is unmuted.

``` c
volSetLevel(mic1, 15000); // Set the volume of mic 1 to 15,000.
```

Volume levels for all of the controls in an array can also be set by calling `volArraySetLevel()` or `volArraySetLevelAsByte()`.  This is helpful if you have an array representing linked channels.

``` c
volArraySetLevel(inputs, 15000); // Set all levels in the input array to 15,000
```

#### Incrementing Levels

"Hey Bob, my mic needs to be louder!  Set the volume to fifteen thousand!"
"That's still not loud enough!  Try twenty thousand!"
"It's too loud now!  Set it to nineteen thousand!"
"Almost there!  How about nineteen thousand and one?  That's it!  Keep it at nineteen thousand and one!"

Ok, so end-users aren't going to be setting volume levels by entering 16-bit integer values.  That's where the `volIncrement()` and `volDecrement()` functions come into play.  These functions can be called when a UI control is pressed.

Let's back up for a second.  Remember the last parameter when initializing a volume control array?

``` c
volInit(mic1, 0, VOL_UNMUTED, 10000, 20000, 5);
```

The `5` specifies that there are five steps between the min and max limits, which in this example is a step value of `2000`.  The step value is the amount that `volIncrement()` and `volDecrement()` increase or decrease a control's volume based on its current level.  Here's an example.

``` text
Mic 1 starting level: 10,000

Remember, the min value 10,000 overrides the level 0 passed during
initialization.

STEP    VOL LEVEL
 5 ---- 20,000    MAX
   |  |
 4 ---- 18,000
   |  |
 3 ---- 16,000
   |  |
 2 ---- 14,000
   |  |
 1 ---- 12,000
   |  |
 0 ---- 10,000    MIN    <-- CURRENT LEVEL


/********************************************************/

volIncrement(mic1); // Increment mic 1's volume by 1 step.

/********************************************************/

Mic 1 level: 12,000

STEP    VOL LEVEL
 5 ---- 20,000    MAX
   |  |
 4 ---- 18,000
   |  |
 3 ---- 16,000
   |  |
 2 ---- 14,000
   |  |
 1 ---- 12,000    <-- CURRENT LEVEL
   |XX|
 0 ---- 10,000    MIN
```

After initialization, a control's step value can be set two ways:
1. `volSetStep()` sets the volume level amount to increase or decrease when incremented, or
2. `volSetNumberOfSteps()` sets the number of steps between the min and max limits.

``` c
volSetStep(mic1, 2000);     // Level will increase by 2,000 each time
                            // volIncrement() is called.

/*  OR  */

volSetNumberOfSteps(mic1, 5);   // volIncrement() can be called 5 times before
                                // the max limit is reached.
```


#### Ramping

Volume ramping can be achieved by calling `volIncrement()` and `volDecrement()` from `PUSH` and `HOLD` events. The higher the number of steps, the smoother the level will appear to ramp.

``` c
(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)

DEFINE_VARIABLE    
volume mic1;

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)

DEFINE_START
volInit(mic1, 0, VOL_UNMUTED, 0, 100, 50);

(***********************************************************)
(*                   THE EVENTS GO BELOW                   *)
(***********************************************************)

DEFINE_EVENT
BUTTON_EVENT[dvTouchPanel, BTN_VOLUME_UP]
{
    PUSH:
    {
        volIncrement(mic1);
    }
    
    HOLD[.5, REPEAT]:
    {
        volIncrement(mic1);
    }
}
```


#### Examples

Example projects are packaged with the source code.
