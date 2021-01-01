using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using LeadManagementSystemV2.Models;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;

namespace LeadManagementSystemV2.Controllers
{
    public class HomeController : Controller
    {
        private readonly DbLeadManagementSystemV2Entities Database;
        public HomeController()
        {
            Database = new DbLeadManagementSystemV2Entities();
        }           
        public ActionResult Index()
        {
            viewModel model = new viewModel();
            model.banner = Database.Banners.Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false)
                .OrderByDescending(x=>x.CreatedDateTime).FirstOrDefault();
            if (model.banner == null)
                model.banner = new Banner();

            model.OrgAnoouncement = Database.OrgAnnouncements
                .Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false)
                .OrderByDescending(x=>x.CreatedDateTime).ToList();
            if (model.OrgAnoouncement == null)
                model.OrgAnoouncement = new List<OrgAnnouncement>();

            model.Galleries = Database.Galleries
                .Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false)
                .OrderByDescending(x=>x.CreatedDateTime).ToList();
            if (model.Galleries == null)
                model.Galleries = new List<Gallery>();

            model.LatestNews = Database.LatestNews
                .Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false)
                .OrderByDescending(x => x.CreatedDateTime).ToList();
            if (model.LatestNews == null)
                model.LatestNews = new List<LatestNew>();

            model.NewsLetter = Database.NewsLetters
                .Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false)
                .OrderByDescending(x => x.CreatedDateTime).ToList();
            if (model.NewsLetter == null)
                model.NewsLetter = new List<NewsLetter>();

            model.Servey = Database.Questions
            .Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false && x.isDefault == true)
            .OrderByDescending(x => x.CreatedDateTime).FirstOrDefault();
            if (model.Servey == null)
                model.Servey = new Question();

            return View(model);
        }
    }
}