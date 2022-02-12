# rpi-gpio-brightness-control
This is how to setup brightness control of RPI Official Touchscreen 7" display or Waveshare 7" DSI IPS touchscreen display via sunrise and sunset times

1. create new systemd service that will starting on boot of RPI   
`sudo nano /etc/systemd/system/brightness_control.service`
1. paste this    
   ```
   [Unit]
   Description=Control display brightness automatically
   After=multi-user.target
   
   [Service]
   Type=idle
   User=root
   ExecStart=/usr/bin/python3 /opt/brightness-monitor/brightness-automation.py
   Restart=always
   RestartSec=300
      
   [Install]
   WantedBy=multi-user.target
   ```     
     
1. install pip modules   
` sudo pip3 install astral`   
` sudo pip3 install rpi-backlight`   
1. Note: Create this udev rule to update permissions, otherwise you'll have to run Python code, the GUI and CLI as root when changing the power or brightness:   
`$ echo 'SUBSYSTEM=="backlight",RUN+="/bin/chmod 666 /sys/class/backlight/%k/brightness /sys/class/backlight/%k/bl_power"' | sudo tee -a /etc/udev/rules.d/backlight-permissions.rules`
1. create folder in opt
`sudo mkdir /opt/brightness-monitor`
1. create script
`sudo nano /opt/brightness-monitor/brightness-automation.py`
1. paste this
   ```
   #!/usr/bin/python3
   import logging
   import time
   import traceback
   from rpi_backlight import Backlight
   from datetime import datetime
   from astral import LocationInfo
   from astral.sun import sun
   from pytz import timezone

   logging.basicConfig(filename="log.txt",format="%(asctime)s-%(levelname)s-%(message)s",level=logging.DEBUG)

   completed=False

   backlight = Backlight()

   city = LocationInfo(name="Prague", region="Czech Republic", timezone="Europe/Prague", latitude=50.08019531831508, longitude=14.448768052010621) #enter your location info here
   c_data = sun(city.observer, tzinfo=city.timezone)

   dawn=str(c_data["dawn"])
   sunrise=str(c_data["sunrise"])
   sunset=str(c_data["sunset"])
   dusk=str(c_data["dusk"])
   current_local_time=datetime.now(tz=timezone(city.timezone))

   print("Current Time: ",current_local_time)
   print("Dawn: " + dawn)
   print("Sunrise: " + sunrise)
   print("Sunset: " + sunset)
   print("Dusk: " + dusk)

   dawn=datetime.fromisoformat(dawn)
   sunrise=datetime.fromisoformat(sunrise)
   sunset=datetime.fromisoformat(sunset)
   dusk=datetime.fromisoformat(dusk)

   backlight.brightness = 100 #initial brightness is 100%

   if current_local_time>=dawn and current_local_time<sunrise: #this is where you adjust your brightness settings depending on sunrise and sunset
    with backlight.fade(duration=2):backlight.brightness = 40 #brightness between sunrise and dusk is set to 40 % with 2 second fade duration from previous brightness
   elif current_local_time>=sunrise and current_local_time<sunset:
     with backlight.fade(duration=2):backlight.brightness = 100
   elif current_local_time>=sunset and current_local_time<dusk:
     with backlight.fade(duration=2):backlight.brightness = 30
   else:
     with backlight.fade(duration=2):backlight.brightness = 15

   print("Brightness: ",backlight.brightness)

   completed=True
   fi
   
   exit 0
   ```
1. Make sure the permissions on the script and the service file are correct. They should be owned by root and the script should be executable.   
   1. `sudo chmod 744 /opt/brightness-monitor/brightness-automation.py`   
   1. `sudo chmod 644 /etc/systemd/system/brightness_control.service`   
   2. `sudo systemctl daemon-reload`    
   3. `sudo systemctl enable brightness_control.service`   
