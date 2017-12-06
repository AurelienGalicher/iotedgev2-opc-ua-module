FROM microsoft/dotnet:2.0.0-runtime-nanoserver-1709
ARG EXE_DIR=.
WORKDIR /app
COPY $EXE_DIR/ ./
EXPOSE 51210
EXPOSE 4840
CMD ["dotnet", "NetCoreConsoleServer.dll"]