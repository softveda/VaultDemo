using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Dapper;
using Microsoft.Extensions.Configuration;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.Runtime.CredentialManagement;
using Amazon;
using Amazon.Runtime;
using Amazon.Extensions.NETCore.Setup;

namespace TodoExporter
{
  class Program
  {
    static IConfiguration Configuration;
    static async Task<int> Main(string[] args)
    {
      BuildConfiguration(args);
      ConfigureAWSCredentials();

      try
      {
        var todoItems = await GetTodoItemsAsync();
        foreach (var item in todoItems)
        {
          //PrintTodoItems(item);
          await ExportToS3(item);
        }
      }
      catch (System.Exception ex)
      {
        System.Console.WriteLine(ex);
        return 1;
      }
      // Console.ReadKey();
      return 0;
    }

    static async Task<IEnumerable<Todo>> GetTodoItemsAsync()
    {
      var connectionString = Configuration.GetConnectionString("TodoExporterContext");
      var builder = new SqlConnectionStringBuilder(connectionString);
      builder.DataSource = Configuration["DB:server"];
      builder.UserID = Configuration["DB:user"];
      builder.Password = Configuration["DB:password"];

      using (var connection = new SqlConnection(builder.ConnectionString))
      {
        var sql = "select * from todo";
        var todoItems = await connection.QueryAsync<Todo>(sql);
        return todoItems;
      }
    }

    static void PrintTodoItems(Todo todo)
    {
      Console.WriteLine($"{todo.ID} {todo.Title}");
    }

    static async Task ExportToS3(Todo todo)
    {
      var path = "./.aws/credentials";
      var options = new AWSOptions
      {
        Profile = Configuration["AWS:profile"],
        ProfilesLocation = path,
        Region = RegionEndpoint.USWest2
      };
      var chain = new CredentialProfileStoreChain(options.ProfilesLocation);
      AWSCredentials awsCredentials;
      if (chain.TryGetAWSCredentials(options.Profile, out awsCredentials))
      {
        // Console.WriteLine($"Exporting to S3: {todo.ID}");
        try
        {
          using (var client = new AmazonS3Client(awsCredentials, RegionEndpoint.USWest2))
          {
            var createdOn = DateTime.UtcNow;
            var s3Key = $"{createdOn:yyyy}/{createdOn:MM}/{createdOn:dd}/todo-{todo.ID}.json";

            var putRequest = new PutObjectRequest
            {
              BucketName = Configuration["AWS:s3_bucket"],
              Key = s3Key,
              ContentBody = todo.ToJsonString()
            };

            Console.WriteLine($"Uploading to S3: {s3Key}");
            PutObjectResponse response = await client.PutObjectAsync(putRequest);
            System.Console.WriteLine(response.HttpStatusCode);
          }
        }
        catch (System.Exception ex)
        {
          Console.WriteLine(ex);
        }
      }
      else
      {
        Console.WriteLine($"Skipped: {todo.ID}");
      }
    }

    static void BuildConfiguration(string[] args)
    {
      Configuration = new ConfigurationBuilder()
         .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
         .AddEnvironmentVariables()
         .AddCommandLine(args)
         .Build();
    }

    static void ConfigureAWSCredentials()
    {
      var options = new CredentialProfileOptions
      {
        AccessKey = Configuration["AWS:access_key"],
        SecretKey = Configuration["AWS:secret_key"]
      };
      var profile = new CredentialProfile(Configuration["AWS:profile"], options);
      profile.Region = RegionEndpoint.USWest2;
      var path = "./.aws/credentials";
      var sharedFile = new SharedCredentialsFile(path);
      sharedFile.RegisterProfile(profile);
    }
  }
}
