using System;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace TodoExporter
{
    public class Todo
    {
        public int ID { get; set; }
        public string Title { get; set; }
        public DateTime DueDate { get; set; }
        public string Category { get; set; }
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