#Dockerfile
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/runtime:3.1-buster-slim
WORKDIR /app
COPY --from=build /src/out .

ENTRYPOINT ["dotnet", "TodoExporter.dll", "--DB:server=$db_server", "--DB:user=$db_user", "--DB:password=$db_password", "--AWS:access_key=$aws_access_key", "--AWS:secret_key=$aws_secret_key"]
