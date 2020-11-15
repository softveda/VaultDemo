# TodoApp
dotnet tool install --global dotnet-ef --version 3.1.9
dotnet tool install --global dotnet-aspnet-codegenerator --version 3.1.4
dotnet add package Microsoft.AspNetCore.Diagnostics.EntityFrameworkCore --version 3.1.9
dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design --version 3.1.4
dotnet add package Microsoft.EntityFrameworkCore.Design --version 3.1.9
dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version 3.1.9
dotnet add package Microsoft.Extensions.Logging.Debug --version 3.1.9

dotnet build
dotnet ef migrations add InitialCreate
dotnet ef database update

# TodoExporter
dotnet new console -o TodoExporter
dotnet add package System.Data.SqlClient
dotnet add package Dapper
dotnet add package System.Threading.Tasks
dotnet add package Microsoft.Extensions.Configuration
dotnet add package Microsoft.Extensions.Configuration.Json
dotnet add package Microsoft.Extensions.Configuration.CommandLine
dotnet add package Microsoft.Extensions.Configuration.EnvironmentVariables
dotnet add package AWSSDK.S3
dotnet add package AWSSDK.Extensions.NETCore.Setup

dotnet restore
dotnet build

dotnet todoexporterv1/app/TodoExporter.dll \
--DB:server=${db_server} \
--DB:user=${db_user} \
--DB:password=${db_password} \
--AWS:access_key=${aws_access_key} \
--AWS:secret_key=${aws_secret_key}

dotnet publish \
--framework netcoreapp3.1 \
--runtime linux-x64 \
-p:PublishTrimmed=true \
-o app



blob_url=""
sas=""
azcopy copy "./app" "$blob_url/todoexporterv1/$sas" --recursive=true

