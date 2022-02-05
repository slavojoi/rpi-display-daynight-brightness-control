# rpi-gpio-brightness-control
This is how to setup brightness control of RPI Official Touchscreen 7" display via GPIO Trigger (GPIO PIN 3 = Ignition and GPIO 15 = Car Headlights)

1. create new systemd service that will starting on boot of RPI   
`sudo nano /etc/systemd/system/illumination.service`
2. paste content of https://github.com/slavojoi/rpi-gpio-brightness-control/blob/main/illumination.service   
3. create illumination folder in opt
`sudo mkdir /opt/illumination`
4. create variable file   
`sudo nano /opt/illumination/illumination_env.sh`
5. paste content of https://github.com/slavojoi/rpi-gpio-brightness-control/blob/main/illumination_env.sh
6. create script
`sudo nano /opt/illumination/service_illumination.sh`
7. paste content of https://github.com/slavojoi/rpi-gpio-brightness-control/blob/main/service_illumination.sh
8. Make sure the permissions on the script and the service file are correct. They should be owned by root and the script should be executable.   
9. `sudo chmod 744 /opt/illumination/service_illumination.sh`
10. `sudo chmod 744 /opt/illumination/illumination_env.sh`
11. `sudo chmod 644 /etc/systemd/system/illumination.service`
12. `sudo systemctl enable illumination.service`
