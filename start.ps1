# This script will uninstall any IoT Edge device and setup a new one with a deployment
# to showcase the use of the OPC-UA Client and Server modules
# Don't run this script if you need to reuse a registered device

function Write-Log {
    Param(
      [Parameter(Mandatory=$true, Position=0)]
      [ValidateNotNullOrEmpty()]
      [string]$Message
    )
    Write-Host $Message -ForegroundColor DarkYellow -BackgroundColor DarkGray
  }
  function Write-Success {
    Param(
      [Parameter(Mandatory=$true, Position=0)]
      [ValidateNotNullOrEmpty()]
      [string]$Message
    )
    Write-Host $Message -ForegroundColor White -BackgroundColor DarkGreen
  }
  function Write-Failure {
    Param(
      [Parameter(Mandatory=$true, Position=0)]
      [ValidateNotNullOrEmpty()]
      [string]$Message
    )
    Write-Host $Message -ForegroundColor White -BackgroundColor DarkRed
  }


$IOTHUB_NAME = ""
$IOTHUB_KEY = ""
$IOTHUB_DEVICEID = ""
$IOTHUB_DEVICE_CONNECTIONSTRING = ""

if ($IOTHUB_NAME -eq "") {
    Write-Failure "Please provide an IoT Hub name!"
    return
}

if ($IOTHUB_KEY -eq "") {
  Write-Failure "Please provide an IoT Hub key!"
  return
}

if ($IOTHUB_DEVICEID -eq "") {
    Write-Failure "Please provide an IoT device id!"
    return
}

if ($IOTHUB_DEVICEID -eq "") {
    Write-Failure "Please provide an IoT device connection string!"
    return
}

Write-Log "Uninstalling any IoT Edge device on this machine..."
iotedgectl uninstall

Write-Log "Install new IoT Edge device"
iotedgectl setup --connection-string $IOTHUB_DEVICE_CONNECTIONSTRING --auto-cert-gen-force-no-passwords

Write-Log "Deploy configuration to device via IoT Hub"
python .\scripts\device-conf.py --name $IOTHUB_NAME `
                                --key $IOTHUB_KEY `
                                --device-id $IOTHUB_DEVICEID `
                                --config-file .\edge-deployment-opc.json


Write-Log "Starting Azure IoT Edge runtime"
iotedgectl start

docker logs -f edgeAgent