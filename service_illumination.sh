#!/bin/bash

source /opt/illumination/illumination_env.sh

# check gpio pin if activated
if [ $DAYNIGHT_PIN -ne 0 ]; then
    while true; do
		# turn backlight down/up based on car ignition signal (I turn my backlight off)
        if [ $IGNITION_PIN -ne 0 ]; then
#            IGNITION_GPIO=`gpio -g read $IGNITION_PIN`
			IGNITION_GPIO=$(raspi-gpio get $IGNITION_PIN)
			IGNITION_GPIO=${IGNITION_GPIO##* level=}
			IGNITION_GPIO=${IGNITION_GPIO%% *}
			if [ $IGNITION_GPIO -eq 0 ]; then
				if [ ! -f /tmp/ignition_dim_enabled ]; then
					touch /tmp/ignition_dim_enabled
					echo $BR_IGNITION > $BRIGHTNESS_FILE
				fi
			else
				if [ -f /tmp/ignition_dim_enabled ]; then
					rm /tmp/ignition_dim_enabled >/dev/null 2>&1
					if [ -f /tmp/night_mode_enabled ]; then
						echo $BR_NIGHT > $BRIGHTNESS_FILE
					else
						echo $BR_DAY > $BRIGHTNESS_FILE
					fi
				fi
			fi
		fi
		# cycle day/night based on $DAYNIGHT_GPIO
        if [ ! -f /tmp/ignition_dim_enabled ]; then # skip day/night cycle if ignition_dim_enabled
            if [ ! -f /tmp/illumination_brightness_active ]; then
                touch /tmp/illumination_brightness_active
            fi
#            DAYNIGHT_GPIO=`gpio -g read $DAYNIGHT_PIN`
			DAYNIGHT_GPIO=$(raspi-gpio get $DAYNIGHT_PIN)
			DAYNIGHT_GPIO=${DAYNIGHT_GPIO##* level=}
			DAYNIGHT_GPIO=${DAYNIGHT_GPIO%% *}
            if [ $DAYNIGHT_GPIO -eq 1 ]; then
#                if [ ! -f /tmp/night_mode_enabled ]; then
#                    touch /tmp/night_mode_enabled
                    echo $BR_NIGHT > $BRIGHTNESS_FILE
#                fi
            else
#                if [ -f /tmp/night_mode_enabled ]; then
#                    rm /tmp/night_mode_enabled >/dev/null 2>&1
                    echo $BR_DAY > $BRIGHTNESS_FILE
#                fi
            fi
        else
            if [ -f /tmp/illumination_brightness_active ]; then
                rm /tmp/illumination_brightness_active >/dev/null 2>&1
            fi
        fi		
        sleep 1
    done
fi

exit 0
