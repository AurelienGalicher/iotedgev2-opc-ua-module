# OPC-UA Module for IoT Edge v2

This module enables devs to include OPC-UA communication into the IoT Edge device.

## Prerequisites

A running version of Azure IoT Edge v2 Public Preview with all its prerequisites

## Usage

### Building

This step is just required if you want to build and host the opc modules yourself.

To build the project and the docker images you have first to update the destination tags of the docker containers. To do so edit `build.ps1` and change `$DOCKER_TAG_OPC_CLIENT` and `$DOCKER_TAG_OPC_SERVER` to your repository image destination. Further you have to edit `edge-deployment-opc.json` to use your docker containers.

```
.\build.ps1
```

### Testing

Provide the required parameter for the start script and execute it

> Be aware that this will uninstall any existing IoT Edge device and setup a new one. If you don't want this behaviour modify the script or deploy `edge-deployment-opc.json` manually.

```
.\start1.ps1
```

After that you can `docker logs -f opc-client` and `docker logs -f opc-server` to see communication between both
