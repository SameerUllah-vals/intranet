using LeadManagementSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace LeadManagementSystemV2.Controllers
{
    public class NewsDetailsController : Controller
    {
        private readonly DbLeadManagementSystemV2Entities Database;
        public NewsDetailsController()
        {
            Database = new DbLeadManagementSystemV2Entities();
        }
        public ActionResult Index(int id)
        {

            if (id > 0)
            {
                var records = Database.LatestNews.Where(x => x.ID == id).FirstOrDefault();
                return View(records);
            }
            else
            {
                return RedirectToAction("", "home");
            }
        }
    }
}