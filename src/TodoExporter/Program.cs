using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Data.SqlClient;
using Dapper;
using Microsoft.Extensions.Configuration;

namespace TodoExporter
{
    class Program
    {
        static IConfiguration Configuration;
        static async Task<int> Main(string[] args)
        {
            BuildConfiguration(args);           

            try
            {
                var todoItems = await GetTodoItemsAsync();
                PrintTodoItems(todoItems);
            }
            catch (System.Exception ex)
            {             
                System.Console.WriteLine(ex);   
                return 1;
            }         

            return 0;
        }

        static async Task<IEnumerable<Todo>> GetTodoItemsAsync()
        {
            var connectionString = "Initial Catalog=TodoDB;Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";
            var builder = new SqlConnectionStringBuilder(connectionString);
            builder.DataSource = Configuration["DB_SERVER"]??"tcp:hashidemo-dev-sqlserver.database.windows.net";
            builder.UserID = Configuration["DB_USER"]??"SqlUser";
            builder.Password = Configuration["DB_PASSWORD"];

            using (var connection  = new SqlConnection(builder.ConnectionString))
            {
                var sql = "select * from todo";
                var todoItems = await connection.QueryAsync<Todo>(sql);                
                return todoItems;
            }
        }

        static void PrintTodoItems(IEnumerable<Todo> todoItems)
        {
            foreach(var item in todoItems)
            {
                Console.WriteLine($"{item.ID} {item.Title}");
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
    }
}
