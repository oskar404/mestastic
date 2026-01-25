
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

The mobile phone app found the device. Now the next step is to figure out how to
change the name of the node to a name which I can remember.
