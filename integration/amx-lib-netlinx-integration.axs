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
redis_connect(dvREDIS, REDIS_IP, REDIS_PORT);

(***********************************************************)
(*                   THE EVENTS GO BELOW                   *)
(***********************************************************)
DEFINE_EVENT

button_event[dvDEBUG, 100]
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

button_event[dvDEBUG, 5]
{
    push:
    {
        redis_publish(dvREDIS, 'chan1', 'published by netlinx');
        print(LOG_LEVEL_INFO, 'pub');
    }
    
    release: {}
}

button_event[dvDEBUG, 6]
{
    push:
    {
        redis_subscribe(dvREDIS, 'chan2');
        print(LOG_LEVEL_INFO, 'subscribed');
    }
    
    release: {}
}

button_event[dvDEBUG, 7]
{
    push:
    {
        redis_psubscribe(dvREDIS, 'chan*');
        print(LOG_LEVEL_INFO, 'subscribed to chan*');
    }
    
    release: {}
}

button_event[dvDEBUG, 8]
{
    push:
    {
        redis_punsubscribe_all(dvREDIS);
        print(LOG_LEVEL_INFO, 'unsubscribed from all channels');
    }
    
    release: {}
}

data_event[dvREDIS]
{
    string:
    {
        char channel[65535];
        char value[65535];
        
        print(LOG_LEVEL_DEBUG, "'REDIS: ', data.text");
        
        if (redis_parse_bulk_string(data.text, value) == REDIS_SUCCESS)
        {
            print(LOG_LEVEL_INFO, 'bulk string received');
            print(LOG_LEVEL_INFO, "'Value: ', value");
        }
        else if (redis_parse_message(data.text, channel, value) == REDIS_SUCCESS)
        {
            print(LOG_LEVEL_INFO, 'pub/sub message received');
            print(LOG_LEVEL_INFO, "'Channel: ', channel");
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
