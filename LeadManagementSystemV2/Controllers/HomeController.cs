using System;
using System.Collections.Generic;
using System.Data.Entity;
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
            .Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false && x.isDefault == true &&  DbFunctions.TruncateTime(DateTime.Now) <= DbFunctions.TruncateTime(x.SubmissionDate))
            .OrderByDescending(x => x.CreatedDateTime).FirstOrDefault();
            if (model.Servey == null)
                model.Servey = new Question();

            model.Jobs = Database.Jobs
            .Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false)
            .OrderByDescending(x => x.CreatedDateTime).ToList();
            if (model.Jobs == null)
                model.Jobs = new List<Job>();

            model.Policies = Database.Policies
           .Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false)
           .OrderByDescending(x => x.CreatedDateTime).ToList();
            if (model.Policies == null)
                model.Policies = new List<Policy>();


            model.ServeyResponse = Database.QuestionDetails.Where(x=>x.QuestionsId == model.Servey.ID)
         .OrderByDescending(x => x.CreatedDateTime).ToList();
            if (model.ServeyResponse == null)
                model.ServeyResponse = new List<QuestionDetail>();

            return View(model);
        }

        [AllowAnonymous]
        public JsonResult vote(QuestionDetailsModel modelRecord)
        {
            AjaxResponse AjaxResponse = new AjaxResponse();
            AjaxResponse.Success = false;
            AjaxResponse.Type = EnumJQueryResponseType.MessageOnly;
            AjaxResponse.Message = "Post Data Not Found";
            try
            {
                bool isAbleToUpdate = true;
                if (isAbleToUpdate)
                {
                    QuestionDetail Record = Database.QuestionDetails.FirstOrDefault(x => x.ID == modelRecord.ID);
                    if (Record == null)
                    {
                        Record = Database.QuestionDetails.Create();
                    }
                    Record.QuestionsId = modelRecord.QuestionsId;
                    Record.IpAddress = Request.UserHostAddress;
                    Record.Answer = modelRecord.opt;
                    Record.CreatedDateTime = GetDateTime();
                    Database.QuestionDetails.Add(Record);
                    Database.SaveChanges();
                    AjaxResponse.Type = EnumJQueryResponseType.MessageAndReloadWithDelay;
                    AjaxResponse.Message = "vote Added.";
                    AjaxResponse.Success = true;
                }

            }
            catch (Exception ex)
            {
                string _catchMessage = ex.Message;
                if (ex.InnerException != null)
                {
                    _catchMessage += "<br/>" + ex.InnerException.Message;
                }
                AjaxResponse.Message = _catchMessage;

            }

            return Json(AjaxResponse);
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("Events")]
        public JsonResult Events()
        {
            var records = Database.Events.Where(x=>x.Status == EnumStatus.Enable && x.IsDeleted == false)
                .ToList();
            var data = from x in records select new { CreatedDateTime = x.CreatedDateTime.ToString(Simple_Date_Format), EventDateTime = x.EventDateTime.ToString(Simple_Date_Format), Title =x.Title };
            return Json(data,JsonRequestBehavior.AllowGet);
        }
    }
}