using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace TodoApp.Models
{
    public class Todo
    {
        public int ID { get; set; }
        public string Title { get; set; }

        [Display(Name = "Due Date")]
        [DataType(DataType.Date)]
        public DateTime DueDate { get; set; }
        public string Category { get; set; }

        [Column(TypeName = "decimal(18, 2)")]
        public decimal Effort { get; set; }

        public string ToJsonString(bool formatted=true)
        {
          var options = new JsonSerializerOptions
          {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
            WriteIndented = formatted,
          };
          var jsonString = JsonSerializer.Serialize(this, options);
          return jsonString;
        }
    }
}