# Warp

Warp is a customized fork of Raspbian lite. It exists to easily flash new swarm robots without manual setup. This repository pulls the official Raspbian lite image and injects custom code, libraries, and dependencies. 

## 0. Directory Structure

```
warp
├── core        : Core code and libraries
│   ├── jobs    : Greengrass job handlers
│   └── startup : Pi initialization services
├── deploy      : Warp images (if building from source)
├── modules     : Pimod software injections
└── pimod       : Image injection tool
```

## 1. Installation and Building

**NOTE:** WPA configs are currently hardcoded into all images, so you must build from source to support your network. This will change in the future. See <a href="1.2">Building From Source</a> for more.

### 1.1 Downloading

1. Head over to the [releases](https://github.com/SwarmDHS/warp/releases) to get the latest image
2. Unzip the artifact
Use something like the [Raspberry Pi Image Flasher](https://www.raspberrypi.org/software/) to flash the `.img` file to your Raspberry Pi

Go to <a href="#2">Step 2</a> to start playing around with Warp

<a id="1.2"></a>

### 1.2 Building From Source

The warped image file can be built inside of a docker container, and in fact it's recommended to do so. This allows images to be built in a clean environment every time, making it easier to reproduce any errors that may show up later. This also means that your builds are machine agnostic, allowing you to tweak whether you're on Linux, MacOS, or Windows.

To build:

1. Make sure [Docker](https://www.docker.com/get-started) is installed
2. In the root directory, create a file called `credentials`. Insert the following into it:
    ```
    BOOTSTRAP_WPA_SSID=your_wifi_name
    BOOTSTRAP_WPA_PASSPHRASE=your_wifi_password
    ```
    - Note that even though the credentials file is ignored by git, you don't *have* to use it
        - Simply creating those environment variables will work fine, but the file is recommended
        for your convenience
    - The wifi credentials are currently hardcoded into Warp
    - No setup tools have been created yet, but will be soon
3. Run `./build.sh` to create an image and to run the build in a container
    - Note that the container will be automatically deleted, but previous images will be preserved

**Note:** If building without docker, create environment variables instead of that credentials file.

If you would like to inspect the container in case it fails or if you want to poke around, you may build with:

```
PRESERVE_CONTAINER=1 ./build.sh
```
and then examine the container with
```
sudo docker run -it --privileged --volumes-from=warp_build pimod_warp /bin/bash
```

To clean all previous images **and start with a clean container**, you can use:
```
CLEAN=1 ./build.sh
```

You can also set both `PRESERVE_CONTAINER` and `CLEAN`. You'll get a file ending in `.img` in `deploy/` that can be flashed to an RPi.

<a id="2"></a>

## 2. Getting Started

Currently, the only service is `bootstrap`. It's started by systemd when the RPi starts up and is meant to handle initialization. It'll take care of setting up an access point, and configuring a WiFi network and running simple shell commands from a connected LAN device (to set up IoT Greengrass, for example).

It runs a simple python script outputting "Hello, world!". The script can be found in `core/startup/bootstrap.py`, and you can view its output with `journalctl -u bootstrap`.
