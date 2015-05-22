PROGRAM_NAME='amx-lib-netlinx-integration'
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(*           DEVICE NUMBER DEFINITIONS GO BELOW            *)
(***********************************************************)
DEFINE_DEVICE

dvREDIS = 0:2:0;
dvDEBUG = 34500:1:0;

(***********************************************************)
(*                    INCLUDES GO BELOW                    *)
(***********************************************************)

#include 'amx-lib-log'
#include 'amx-lib-volume-sc'
#include 'amx-lib-redis'

(***********************************************************)
(*              CONSTANT DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_CONSTANT

REDIS_IP = '10.0.11.63';
REDIS_PORT = REDIS_DEFAULT_PORT;

(***********************************************************)
(*              VARIABLE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_VARIABLE

volatile char key[255];

(***********************************************************)
(*         SUBROUTINE/FUNCTION DEFINITIONS GO BELOW        *)
(***********************************************************)

(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)
DEFINE_START

key = 'netlinx';

logSetLevel(LOG_LEVEL_DEBUG);

(***********************************************************)
(*                   THE EVENTS GO BELOW                   *)
(***********************************************************)
DEFINE_EVENT

button_event[dvDEBUG, 1]
{
    push:
    {
        redis_connect(dvREDIS, REDIS_IP, REDIS_PORT);
        print(LOG_LEVEL_INFO, 'opened socket');
    }
    
    release: {}
}

button_event[dvDEBUG, 2]
{
    push:
    {
        volume inputs[8];
        
        char str[65535];
        
        vol_array_init(inputs, 0, VOL_UNMUTED, 0, 100, 10);
        // variable_to_xml(inputs, str, 1, XML_ENCODE_TYPES);
        variable_to_xml(inputs, str, 1, 0);
        
        // print(LOG_LEVEL_INFO, str);
        
        redis_set(dvREDIS, key, str);
        print(LOG_LEVEL_INFO, 'set netlinx');
    }
    
    release: {}
}

button_event[dvDEBUG, 3]
{
    push:
    {
        redis_get(dvREDIS, key);
        print(LOG_LEVEL_INFO, 'get netlinx');
    }
    
    release: {}
}

button_event[dvDEBUG, 4]
{
    push:
    {
        redis_get(dvREDIS, 'netlinx2');
        print(LOG_LEVEL_INFO, 'get netlinx2');
    }
    
    release: {}
}

data_event[dvREDIS]
{
    string:
    {
        char value[65535];
        
        print(LOG_LEVEL_DEBUG, "'REDIS: ', data.text");
        
        if (redis_is_bulk_string(data.text))
        {
            redis_parse_bulk_string(data.text, value);
            print(LOG_LEVEL_INFO, "'Value: ', value");
        }
    }
    
    command: {}
    online:  {}
    offline: {}
}

(***********************************************************)
(*                     END OF PROGRAM                      *)
(*          DO NOT PUT ANY CODE BELOW THIS COMMENT         *)
(***********************************************************)
