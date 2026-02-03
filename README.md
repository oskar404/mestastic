
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
