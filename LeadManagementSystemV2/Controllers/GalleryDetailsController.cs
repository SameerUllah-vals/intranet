using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;
using LeadManagementSystemV2.Models;
using LeadManagementSystemV2.Helpers;

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
            ViewBag.BApp = Database.BusinessApplications.Where(x => x.IsDeleted == false).ToList();
            ViewBag.Policies = Database.Policies.Where(x => x.Type == ApplicationHelper.EnumPolicyType.DTI).ToList();

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