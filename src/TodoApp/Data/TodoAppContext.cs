using Microsoft.EntityFrameworkCore;

namespace TodoApp.Data
{
    public class TodoAppContext : DbContext
    {
        public TodoAppContext (
            DbContextOptions<TodoAppContext> options)
            : base(options)
        {
        }

        public DbSet<TodoApp.Models.Todo> Todo { get; set; }
    }
}