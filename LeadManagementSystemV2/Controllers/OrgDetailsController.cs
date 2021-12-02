using LeadManagementSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;

namespace LeadManagementSystemV2.Controllers
{
    public class OrgDetailsController : Controller
    {
        private readonly DbLeadManagementSystemV2Entities Database;
        public OrgDetailsController()
        {
            Database = new DbLeadManagementSystemV2Entities();
        }
        public ActionResult Index(int id)
        {
            ViewBag.WebsiteURL = GetSettingContentByName("Website URL");
            ViewBag.BApp = Database.BusinessApplications.Where(x => x.IsDeleted == false).ToList();
            ViewBag.Policies = Database.Policies.Where(x => x.Type == EnumPolicyType.DTI).ToList();

            if (id > 0)
            {
                var records = Database.OrgAnnouncements.Where(x => x.ID == id).FirstOrDefault();
                return View(records);
            }
            else
            {
                return RedirectToAction("", "home");
            }
        }
    }
}