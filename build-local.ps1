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
  Write-Host $Message -ForegroundColor DarkGreen -BackgroundColor DarkGray
}

# Build assemblies
Write-Log "Cleaning up"
dotnet clean
Write-Log "Restoring assemblies"
dotnet restore
Write-Log "Build and publish projects to release directory"
dotnet publish -f netcoreapp2.0 -c Release -o release

# Build docker images
Write-Log "Cleaning up existing local registries"
docker rm -f registry
Write-Log "Build docker image OPC-UA client module"
Push-Location -Path .\opc-ua-client-module
Write-Log "Building linux-x64"
docker build -f ./Docker/linux-x64/Dockerfile `
             --build-arg EXE_DIR=./release `
             -t localhost:5000/opc-ua-client-module:latest .
Pop-Location

Write-Log "Build docker image OPC-UA server module"
Push-Location -Path .\opc-ua-server-module
# Need to copy the xml file for server opc ua properties into build directory
Copy-Item .\Opc.Ua.SampleServer.Config.xml release
Write-Log "Building linux-x64"
docker build -f ./Docker/linux-x64/Dockerfile `
             --build-arg EXE_DIR=./release `
             -t localhost:5000/opc-ua-server-module:latest .
Pop-Location

Write-Log "Start local container registry"
docker run -d -p 5000:5000 --name "registry" registry:2

Write-Log "Push OPC UA client into local registry"
docker push localhost:5000/opc-ua-client-module

Write-Log "Push OPC UA server into local registry"
docker push localhost:5000/opc-ua-server-module

Write-Success "To start the demo execute start.ps1"