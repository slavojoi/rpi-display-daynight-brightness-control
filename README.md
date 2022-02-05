# rpi-gpio-brightness-control
This is how to setup brightness control of RPI Official Touchscreen 7" display or Waveshare 7" DSI IPS touchscreen display via sunrise and sunset times

1. create new systemd service that will starting on boot of RPI   
`sudo nano /etc/systemd/system/daynight_brightness.service`
2. paste this
```
[Unit]
   Description=RPI/Waveshare Tuchscreen Display Day & Nighr Brightness Trigger Service
   ConditionPathExists=/opt/daynight_brightness/daynight_brightness_script.sh

    [Service]
   Type=simple
   ExecStart=/opt/daynight_brightness/daynight_brightness_script.sh
   RemainAfterExit=yes

    [Install]
   WantedBy=multi-user.target
```   
4. create daynight_brightness folder in opt
`sudo mkdir /opt/daynight_brightness`
6. create script
`sudo nano /opt/daynight_brightness/daynight_brightness_script.sh`
7. paste this
```
#!/bin/bash

NOW=$(TZ=Europe/London date '+%T %d/%m')

if [ "$1" == "reboot" ]; then
  if [ ! -f /var/run/lightordark ];
  then
    echo $1' @ '$NOW > /var/run/lightordark
  fi
  else
  echo $1' @ '$NOW > /var/run/lightordark
fi

if [ "$1" == "light" ]; then
  /usr/local/bin/gpio -g pwm 18 0
else
  /usr/local/bin/gpio -g pwm 18 1023
fi
```
9. Make sure the permissions on the script and the service file are correct. They should be owned by root and the script should be executable.   
10. `sudo chmod 744 /opt/illumination/service_illumination.sh`
11. `sudo chmod 744 /opt/illumination/illumination_env.sh`
12. `sudo chmod 644 /etc/systemd/system/illumination.service`
13. `sudo systemctl enable illumination.service`
