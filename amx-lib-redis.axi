(***********************************************************
    amx-lib-redis
    
    A Redis database client for AMX's NetLinx programming language.
    
    Redis Comamnds:
    http://redis.io/commands
    
    Redis Protocol Specification:
    http://redis.io/topics/protocol
************************************************************
The MIT License (MIT)

Copyright (c) 2015 Alex McLain

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
************************************************************)

#if_not_defined AMX_LIB_REDIS
#define AMX_LIB_REDIS 1
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(*           DEVICE NUMBER DEFINITIONS GO BELOW            *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*              CONSTANT DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_CONSTANT

REDIS_DEFAULT_PORT = 6379;

// Error codes.
REDIS_SUCCESS = 0;
REDIS_ERR_INCORRECT_TYPE = 0;

(***********************************************************)
(*                    INCLUDES GO BELOW                    *)
(***********************************************************)

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_VARIABLE

(***********************************************************)
(*         SUBROUTINE/FUNCTION DEFINITIONS GO BELOW        *)
(***********************************************************)

define_function redis_connect()
{
    // TODO: Implement
}

/*
 *  Get the value of a key.
 *  http://redis.io/commands/get
 */
define_function redis_get(dev socket, char key[])
{
    send_string socket, "
        '*2', $0D, $0A,
        '$3', $0D, $0A,
        'get', $0D, $0A,
        '$', itoa(length_string(key)), $0D, $0A,
        key, $0D, $0A
    ";
}

/*
 *  Set the string value of a key.
 *  http://redis.io/commands/set
 */
define_function redis_set(dev socket, char key[], char value[])
{
    send_string socket, "
        '*3', $0D, $0A,
        '$3', $0D, $0A,
        'set', $0D, $0A,
        '$', itoa(length_string(key)), $0D, $0A,
        key, $0D, $0A,
        '$', itoa(length_string(value)), $0D, $0A,
        value, $0D, $0A
    ";
}

/*
 *  Returns true if packet is a bulk string.
 */
define_function integer redis_is_bulk_string(char packet[])
{
    if (packet[1] == '$') { return true; }
    return false;
}

/*
 *  Parses a bulk string from a response packet.
 *  packet is the response from the server.
 *  bulk_string is the buffer to store the value.
 */
define_function integer redis_parse_bulk_string(char packet[], char bulk_string[])
{
    integer pos;
    
    if (redis_is_bulk_string(packet) == 0)
    {
        return REDIS_ERR_INCORRECT_TYPE; // Not bulk string.
    }
    
    bulk_string = '';
    pos = find_string(packet, "$0A", 1);
    // TODO: Test return value for error.
    // TODO: Test for nil.
    
    bulk_string = mid_string(packet, pos + 1, length_string(packet) - pos - 2);
    return REDIS_SUCCESS;
}

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                   THE EVENTS GO BELOW                   *)
(***********************************************************)
DEFINE_EVENT

(***********************************************************)
(*                 THE MAINLINE GOES BELOW                 *)
(***********************************************************)
DEFINE_PROGRAM

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*          DO NOT PUT ANY CODE BELOW THIS COMMENT         *)
(***********************************************************)
#end_if
