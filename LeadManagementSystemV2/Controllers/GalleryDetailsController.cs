using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;
using LeadManagementSystemV2.Models;

namespace LeadManagementSystemV2.Controllers
{
    public class GalleryDetailsController : Controller
    {
        private readonly DbLeadManagementSystemV2Entities Database;
        public GalleryDetailsController()
        {
            Database = new DbLeadManagementSystemV2Entities();
        }
        public ActionResult Index(int id)
        {
            if (id > 0)
            {
                var records = Database.GalleryDetails.Where(x => x.GalleryId == id).ToList();
                return View(records);
            }
            else
            {
                return RedirectToAction("", "home");
            }
           
        }

      
    }
}