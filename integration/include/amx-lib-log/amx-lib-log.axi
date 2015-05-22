(***********************************************************
    AMX LOG LIBRARY
    v1.0.0
    
    Website: https://github.com/amclain/amx-lib-log
    
    
 -- THIS IS A THIRD-PARTY LIBRARY AND IS NOT AFFILIATED WITH --
 --                   THE AMX ORGANIZATION                   --
    
    
    This library contains the code to perform logging and report
    various notifications to the system developer.  Source code
    and documentation can be obtained from the website listed above.
    
    It is recommended to use LOG_LEVEL_WARNING or LOG_LEVEL_INFO
    in a production environment.
*************************************************************
    Copyright 2012, 2014 Alex McLain
    
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
************************************************************)

#if_not_defined AMX_LIB_LOG
#define AMX_LIB_LOG 1
(***********************************************************)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    History: See changelog.txt or version control repository.
*)
(***********************************************************)
(*                    INCLUDES GO BELOW                    *)
(***********************************************************)

(***********************************************************)
(*           DEVICE NUMBER DEFINITIONS GO BELOW            *)
(***********************************************************)
DEFINE_DEVICE

#if_not_defined dvLogConsole
dvLogConsole = 0:0:0;
#end_if

(***********************************************************)
(*              CONSTANT DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_CONSTANT

// Log message levels.
LOG_LEVEL_NONE          = 0;
LOG_LEVEL_CRITICAL      = 1;
LOG_LEVEL_ERROR         = 2;
LOG_LEVEL_WARNING       = 3;
LOG_LEVEL_INFO          = 4;
LOG_LEVEL_DEBUG         = 5;
LOG_LEVEL_DETAIL        = 6;

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_VARIABLE

volatile integer logLevel;
volatile integer logDisablePrependSeverity;

(***********************************************************)
(*         SUBROUTINE/FUNCTION DEFINITIONS GO BELOW        *)
(***********************************************************)

/*
 *  Print a message to the log device.
 *  The severity parameter accepts a log message level (e.g. LOG_LEVEL_INFO).
 */
define_function print(integer severity, char str[])
{
    char prefix[20];

    if (severity == LOG_LEVEL_NONE || severity > logLevel) return;
    
    if (logDisablePrependSeverity == false)
    {
        switch (severity)
        {
            case LOG_LEVEL_CRITICAL:    prefix = "'CRITICAL: '";
            case LOG_LEVEL_ERROR:       prefix = "'ERROR: '";
            case LOG_LEVEL_WARNING:     prefix = "'WARNING: '";
            case LOG_LEVEL_INFO:        prefix = "'INFO: '";
            case LOG_LEVEL_DEBUG:       prefix = "'DEBUG: '";
            case LOG_LEVEL_DETAIL:      prefix = "'DETAIL: '";
            default:                    prefix = "'LOG: '";
        }
        
        send_string dvLogConsole, "prefix, str";
    }
    else
    {
        send_string dvLogConsole, str;
    }
}

/*
 *  Set the log level.
 *
 *  Parameter accepts a log level constant.
 */
define_function logSetLevel(integer lvl)
{
    logLevel = lvl;
}

/*
 *  Option to disable prepending the message severity
 *  to the log string.
 *
 *  Parameter accepts a boolean value.
 */
define_function logSetDisablePrependSeverity(integer prepend)
{
    if (prepend == false)
    {
        logDisablePrependSeverity = false;
    }
    else
    {
        logDisablePrependSeverity = true;
    }
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
