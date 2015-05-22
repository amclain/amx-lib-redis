# AMX LOG LIBRARY

amx-lib-log
This library contains the code to perform logging and report various notifications
to a control system developer or technician.

*THIS IS A THIRD-PARTY LIBRARY AND IS NOT AFFILIATED WITH THE AMX ORGANIZATION*


## Overview

[TOC]


## Download

**Git Users:**

https://github.com/amclain/amx-lib-log


**Mercurial Users:**

https://bitbucket.org/amclain/amx-lib-log


**Zip File:**

Both sites above offer a feature to download the source code as a zip file.
Any stable release, as well as the current development snapshot can be downloaded.


## Issues, Bugs, Feature Requests

Any bugs and feature requests should be reported on the GitHub issue tracker:

https://github.com/amclain/amx-lib-log/issues


**Pull requests are preferred via GitHub.**

Mercurial users can use [Hg-Git](http://hg-git.github.io/) to interact with
GitHub repositories.


## Usage

### Including The Library

The easiest way to include the log library is in the project's master `axs` file.
If the log library is placed at the top of the list of includes, it will propagate
to the include files for the project and won't have to be included again.

In the `DEFINE_START` section, the log level should be set to the least important
message type you wish to see logged. For example, in development this may be
`LOG_LEVEL_DEBUG`, and in production it may be `LOG_LEVEL_INFO`. Messages of
this importance or greater will be visible, and less important messages will
be filtered.

``` c
(***********************************************************)
(*                    INCLUDES GO BELOW                    *)
(***********************************************************)

#include 'amx-lib-log';

// Project includes.
#include '...'

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

logSetLevel(LOG_LEVEL_INFO);
```


### Logging Data

Data can be output to the log by using the `print()` function and
specifying the message's importance with a `LOG_LEVEL` constant.

``` c
define_function videoPatch(integer input, integer output)
{
    // Source code ...
    
    print(LOG_LEVEL_INFO, "'Video Patch: ', itoa(input), ' -> ', itoa(output)");
}
```


### Viewing The Log

Log items can be viewed in the NetLinx Diagnostics via the `Diagnostics` tab.

``` text
Line     15 (10:07:41):: INFO: Video Patch: 21 -> 14
```

Disk-based persistent logging is not implemented yet. However, the log output
can be redirected to your own disk logging utility. See: `Redirecting The Log`.


### Redirecting The Log

The log output is sent to a NetLinx device, and therefore is not limited to being
displayed in the NetLinx console. By defining the device `dvLogConsole` before
including the logging library, the log can be directed to a user-defined device
like an RS232 port, a network connection, or a module.

``` c
(***********************************************************)
(*           DEVICE NUMBER DEFINITIONS GO BELOW            *)
(***********************************************************)
DEFINE_DEVICE

dvLogConsole = 33000:1:0;  // Override the console output device.

#include 'amx-lib-log'
```
