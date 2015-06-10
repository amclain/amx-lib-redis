# amx-lib-redis

A [Redis](http://redis.io/) database client for AMX's NetLinx programming
language.


## Download

**Git Users:**

https://github.com/amclain/amx-lib-redis


**Mercurial Users:**

https://bitbucket.org/amclain/amx-lib-redis


**Zip File:**

Both sites above offer a feature to download the source code as a zip file.
Any stable release, as well as the current development snapshot can be downloaded.


## Issues, Bugs, Feature Requests

Any bugs and feature requests should be reported on the GitHub issue tracker:

https://github.com/amclain/amx-lib-redis/issues


**Pull requests are preferred via GitHub.**

Mercurial users can use [Hg-Git](http://hg-git.github.io/) to interact with
GitHub repositories.


## Usage

### Setting Up A Connection

This library supports multiple connections to Redis databases, and therefore
lets the control system developer decide what connections are needed in a
system. In this example `dvREDIS` is used for sending commands to a single
database. Additional devices could be added to connect to other databases,
or used for [pub/sub messaging](http://redis.io/topics/pubsub). Due to the
support for multiple connections, library functions typically take a Redis
device as the first argument.

```netlinx
(***********************************************************)
(*           DEVICE NUMBER DEFINITIONS GO BELOW            *)
(***********************************************************)
DEFINE_DEVICE

dvREDIS = 0:2:0;

(***********************************************************)
(*                    INCLUDES GO BELOW                    *)
(***********************************************************)

#include 'amx-lib-redis'

(***********************************************************)
(*              CONSTANT DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_CONSTANT

REDIS_IP   = '192.168.1.2';
REDIS_PORT = REDIS_DEFAULT_PORT;

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

redis_connect(dvREDIS, REDIS_IP, REDIS_PORT);
```
