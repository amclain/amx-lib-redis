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

Note: NetLinx `send_string` is limited to a maximum of 16,000 bytes. Due to
this, data sent to a Redis connection must be lower than this limit, *including
the Redis protocol overhead*. It is advised to keep data passed to library
functions well below this limit.

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


### Getting And Setting Values

Setting the value for a Redis key is pretty straightforward:

```netlinx
redis_set(dvREDIS, 'test_key', 'hello world');
```

Getting a value is more complicated due to the asynchronous nature of the
connection and how NetLinx handles socket events. This library provides a
minimalistic approach for this implementation; your specific project may require
adding a buffer, queue, or state machine.

Helper functions like `redis_parse_bulk_string()` are provided to assist in
parsing responses from the Redis server, and return the constant `REDIS_SUCCESS`
if they were able to process the response. Since these helper functions are
capable of performing their own checks on the data, it is possible to set up a
chain of `redis_parse` functions and test for which one succeeds.

```netlinx
redis_get(dvREDIS, 'test_key');
```

```netlinx
(***********************************************************)
(*                   THE EVENTS GO BELOW                   *)
(***********************************************************)
DEFINE_EVENT

data_event[dvREDIS]
{
    string:
    {
        char value[65535];
        
        if (redis_parse_bulk_string(data.text, value) == REDIS_SUCCESS)
        {
            // Process the string stored in `value`.
        }
    }
}
```
