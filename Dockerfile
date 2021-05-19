FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /DockerSource

# Copy csproj and restore as distinct layers
COPY *.sln .
COPY seedapp/*.csproj ./seedapp/
RUN dotnet restore

# Copy everything else and build website
COPY seedapp/. ./seedapp/
WORKDIR /DockerSource/seedapp
RUN dotnet publish -c release -o /DockerOutput/Website --no-restore

# Final stage / image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /DockerOutput/Website
COPY --from=build /DockerOutput/Website ./
ENTRYPOINT ["dotnet", "seedapp.dll"]