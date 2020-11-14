using System;

namespace TodoExporter
{
    public class Todo
    {
        public int ID { get; set; }
        public string Title { get; set; }
        public DateTime DueDate { get; set; }
        public string Category { get; set; }
        public decimal Effort { get; set; }
    }
}