# Get Base Image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app

# Copy csproj and restore all packages

COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build 
COPY . ./
RUN dotnet publish -c release -o out

# Build Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app/out ./
# Set the EntryPoint for dll
ENTRYPOINT ["dotnet", "seedapp.dll"]
