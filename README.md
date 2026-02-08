
# Mestastic Hacking

Device: Heltec WiFi LoRa 32(V4), ESP32S3 + SX1262 LoRa Node

https://heltec.org/project/wifi-lora-32-v4/

The target is to setup mestastic software running into the device.

This mainly documentation for myself.

## Learnings

"LoRa Error" before uploading mestastic SW just means that the device did not
find any other device in factory mode.

In Ubuntu 24.04 the Chromium is installed via snap and the access to serial port
is not working in default installation. The drivers in Linux are in-built. The
`lsusb` returns:

    Bus 008 Device 009: ID 303a:1001 Espressif USB JTAG/serial debug unit

There are some Chromium configuration information sugesting to use `hotplug`
here:

    https://forum.snapcraft.io/t/chromium-cant-open-serial-port-on-ubuntu-22-04/31139

but it was simpler to change to a computer with MS Edge installation.

In MS Edge the [Mestastic Web Flasher](https://flasher.meshtastic.org/) page
works. The page has Heltec V4 support and nicely provides the latest SW which
was at the time of the installation 2.7.15.

The Flasher page had some hicups - it reserved the serial port and the complained
that the port was in use. Page reload and just follow the steps without too much
manual configuration fixed the issue.

Confusing Flasher page console message:

    "Hard resetting via RTS pin..."

just meant that the reset button should be pressed.

The mobile phone app found the device. Now the next step is to figure out how to
change the name of the node to a name which I can remember.

## Configuration

Region: European Union 868MHz
Presets: Long Range - Fast

## Mesh Monitor Docker Setup

Information source: https://meshmonitor.org/configurator.html

Install Docker:

    sudo apt install docker.io docker-compose-v2

Configure user to be able to run docker without `sudo`:

    sudo usermod -aG docker ${USER}

And logout and login again or start a new shell with comand: `su - ${USER}`

Check that `docker` group is part of active groups with command: `groups`

Deployment Instructions:

1. Run `docker compose up -d` to start MeshMonitor
2. Access MeshMonitor at http://localhost:8080

When logging first time in change the default password:

    Username: admin
    Password: changeme

=> was not able to connect .. the `ping` responded:

    > ping 192.168.100.2
    PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
    64 bytes from 192.168.100.2: icmp_seq=1 ttl=64 time=11.1 ms

and `nmap` did not find any open ports:

    > nmap 192.168.100.2
    Starting Nmap 7.94SVN ( https://nmap.org ) at 2026-02-03 21:11 EET
    Nmap scan report for 192.168.100.2
    Host is up (0.024s latency).
    All 1000 scanned ports on 192.168.100.2 are in ignored states.
    Not shown: 1000 closed tcp ports (conn-refused)

    Nmap done: 1 IP address (1 host up) scanned in 2.87 seconds

=> The heltec firmware does not seem support the HTTP connection

## Serial Bridge Connection

Information source: https://meshmonitor.org/configuration/serial-bridge.html

    "Serial Bridge is a Docker-based application"

The device seems to connect to: `/dev/ttyACM0`

=> complex stuff let's try something else

## Next try python3 esptool

https://meshtastic.org/docs/getting-started/flashing-firmware/esp32/cli-script/

    sudo install pipenv
    pipenv shell
    python3 -m pip install esptool
    esptool --port /dev/ttyACM0 chip-id

=> no response

    > esptool --port /dev/ttyACM0 chip-id
    esptool v5.1.0
    Serial port /dev/ttyACM0:
    Connecting......................................

    A fatal error occurred: Failed to connect to Espressif device: No serial data received.
    For troubleshooting steps visit: https://docs.espressif.com/projects/esptool/en/latest/troubleshooting.html

## Python3 meshtastic package

Information source: https://meshtastic.org/docs/software/python/cli/installation/

Prepare virtual environment:

    sudo install pipenv
    pipenv shell

Install packages:

    pip3 install --upgrade pytap2
    pip3 install --upgrade meshtastic

Test USB connection:

    meshtastic --serial /dev/ttyACM0

and got response from the command: `Connected to radio`

Usage information: https://meshtastic.org/docs/software/python/cli/usage/

Next step is how to configure the radio device ..

## More Hacking

To get info:

    meshtastic --info

To set configuration from Yaml

    meshtastic --configure blt-config.yaml

For some reason I can't find this new device in the iPhone app when in bluetooth.
In the computer the device was visible. And turning back to Wifi and normal UI
is not possible. The device is in somekind of weird config now.

Maybe full erase / flash to remove all the data is the solution

Settng the bluetooth mode to FIXED_PIN solved the iPhone application connection
problem:

    meshtastic --set bluetooth.mode 2
