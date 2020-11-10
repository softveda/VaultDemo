using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using TodoApp.Data;
using System;
using System.Linq;

namespace TodoApp.Models
{
    public static class SeedData
    {
        public static void Initialize(IServiceProvider serviceProvider)
        {
            using (var context = new TodoAppContext(
                serviceProvider.GetRequiredService<
                    DbContextOptions<TodoAppContext>>()))
            {
                // Look for any Todos.
                if (context.Todo.Any())
                {
                    return;   // DB has been seeded
                }

                context.Todo.AddRange(
                    new Todo
                    {
                        Title = "Learn Terraform",
                        DueDate = DateTime.Now.AddMonths(1),
                        Category = "Technical",
                        Effort = 10
                    },

                    new Todo
                    {
                        Title = "Write blog post ",
                        DueDate = DateTime.Now.AddDays(6),
                        Category = "Professional",
                        Effort = 3
                    },

                    new Todo
                    {
                        Title = "Buy new XBox",
                        DueDate = DateTime.Now.AddMonths(3),
                        Category = "Personal",
                        Effort = 1
                    },

                    new Todo
                    {
                        Title = "PoC Azure Consul",
                        DueDate = DateTime.Now.AddMonths(2),
                        Category = "Technical",
                        Effort = 12
                    }
                );
                context.SaveChanges();
            }
        }
    }
}