#define  SearchCategoryAndString   //SearchString
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using TodoApp.Models;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TodoApp.Pages.Todos
{
    #region snippet_newProps
    public class IndexModel : PageModel
    {
        private readonly TodoApp.Data.TodoAppContext _context;

        public IndexModel(TodoApp.Data.TodoAppContext context)
        {
            _context = context;
        }

        public IList<Todo> Todos { get; set; }
        [BindProperty(SupportsGet = true)]
        public string SearchString { get; set; }
        // Requires using Microsoft.AspNetCore.Mvc.Rendering;
        public SelectList Categories { get; set; }
        [BindProperty(SupportsGet = true)]
        public string TodoCategory { get; set; }

        #endregion

#if SearchString
        #region snippet_1stSearch
        public async Task OnGetAsync()
        {
            var todos = from m in _context.Todo
                         select m;
        #region snippet_SearchNull
            if (!string.IsNullOrEmpty(SearchString))
            {
                todos = todos.Where(s => s.Title.Contains(SearchString));
            }
        #endregion

            Todo = await todos.ToListAsync();
        }
        #endregion
#endif

#if Original
        public async Task OnGetAsync()
        {
            Todo = await _context.Todo.ToListAsync();
        }
#endif
#if SearchCategoryAndString
        public async Task OnGetAsync()
        {
            #region snippet_LINQ
            // Use LINQ to get list of categories.
            IQueryable<string> categoryQuery = from m in _context.Todo
                                            orderby m.Category
                                            select m.Category;
            #endregion

            var todos = from m in _context.Todo
                         select m;

            if (!string.IsNullOrEmpty(SearchString))
            {
                todos = todos.Where(s => s.Title.Contains(SearchString));
            }

            if (!string.IsNullOrEmpty(TodoCategory))
            {
                todos = todos.Where(x => x.Category == TodoCategory);
            }
            #region snippet_SelectList
            Categories = new SelectList(await categoryQuery.Distinct().ToListAsync());
            #endregion
            Todos = await todos.ToListAsync();
        }
#endif
    }
}