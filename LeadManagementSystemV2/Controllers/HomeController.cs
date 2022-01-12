using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Web.Mvc;
using LeadManagementSystemV2.Helpers;
using LeadManagementSystemV2.Models;
using Newtonsoft.Json;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;

namespace LeadManagementSystemV2.Controllers
{
    public class HomeController : Controller
    {
        private readonly DbLeadManagementSystemV2Entities Database;
        private readonly List<BusinessApplication> businessAppRecords;
        public HomeController()
        {
            Database = new DbLeadManagementSystemV2Entities();
            ViewBag.Policies = Database.Policies.Where(x => x.Type == EnumPolicyType.DTI).ToList();
            businessAppRecords = Database.BusinessApplications.Where(x => x.IsDeleted == false).ToList();
            
            ViewBag.BApp = businessAppRecords;
           

        }

        
        public ActionResult Index()
        {
            viewModel model = new viewModel();
            ViewBag.WebsiteURL = GetSettingContentByName("Website URL");
            settings _setting = new settings();
            _setting.announcementDisplay = string.IsNullOrEmpty(GetSettingContentByName(EnumDisplaySetting.Announce)) ? 1
                : Convert.ToInt32(GetSettingContentByName(EnumDisplaySetting.Announce));
            _setting.newsDisplay = string.IsNullOrEmpty(GetSettingContentByName(EnumDisplaySetting.News)) ? 1
                : Convert.ToInt32(GetSettingContentByName(EnumDisplaySetting.News));
            _setting.noticeDisplay = string.IsNullOrEmpty(GetSettingContentByName(EnumDisplaySetting.Notice)) ? 1
                : Convert.ToInt32(GetSettingContentByName(EnumDisplaySetting.Notice));
            model.setting = _setting;

            model.LatestNews = Database.LatestNews
             .Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false)
             .OrderByDescending(x => x.CreatedDateTime).ToList();
            if (model.LatestNews == null)
                model.LatestNews = new List<LatestNew>();

            model.banner = Database.Banners.Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false)
                .OrderByDescending(x => x.CreatedDateTime).FirstOrDefault();
            if (model.banner == null)
                model.banner = new Banner();
            foreach (var item in model.LatestNews.Take(model.setting.newsDisplay))
            {
                model.banner.Ticker += item.Title + $". ({item.CreatedDateTime}) ";
            }

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

         

           
            model.NewsLetter = Database.NewsLetters
                .Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false)
                .OrderByDescending(x => x.CreatedDateTime).ToList();
            if (model.NewsLetter == null)
                model.NewsLetter = new List<NewsLetter>();

            //model.Servey = Database.Questions
            //.Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false && x.isDefault == true &&  DbFunctions.TruncateTime(DateTime.Now) <= DbFunctions.TruncateTime(x.SubmissionDate))
            //.OrderByDescending(x => x.CreatedDateTime).FirstOrDefault();
            //if (model.Servey == null)
            //    model.Servey = new Question();

            var serveyMasterRecord = Database.ServeyMasters.Where(x=> x.IsDeleted.Equals(false) && x.Status.Equals(EnumStatus.Enable))
                .OrderByDescending(x => x.CreatedDateTime).FirstOrDefault();
            if(serveyMasterRecord != null)
            {
                model.Servey.ID = serveyMasterRecord.ID;
                model.Servey.Questions = Database.ServeyQuestions.Where(x => x.ServeyMasterId.Equals(serveyMasterRecord.ID) && x.IsDeleted.Equals(false)).ToList();
            }

            model.Jobs = Database.Jobs
            .Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false)
            .OrderByDescending(x => x.CreatedDateTime).ToList();
            if (model.Jobs == null)
                model.Jobs = new List<Job>();

           // model.Policies = Database.Policies
           //.Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false)
           //.OrderByDescending(x => x.CreatedDateTime).ToList();
           // if (model.Policies == null)
           //     model.Policies = new List<Policy>();
           // else
           //     ViewBag.Policies = model.Policies.Where(x => x.Type == ApplicationHelper.EnumPolicyType.DTI).ToList();


         //   model.ServeyResponse = Database.QuestionDetails.Where(x=>x.QuestionsId == model.Servey.ID)
         //.OrderByDescending(x => x.CreatedDateTime).ToList();
         //   if (model.ServeyResponse == null)
         //       model.ServeyResponse = new List<QuestionDetail>();

     
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
            var data = from x in records select new { x.ID,CreatedDateTime = x.CreatedDateTime.ToString(Simple_Date_Format), EventDateTime = x.EventDateTime.ToString(Simple_Date_Time_Format), Title =x.Title, EventLocation = x.EventLocation , EventOrganizer = x.EventOrganizer, Description = x.Description, isDefault = x.isDefault};
            return Json(data,JsonRequestBehavior.AllowGet);
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("Event")]
        public JsonResult Event(int id)
        {
            var records = Database.Events.Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false &&x.ID == id).ToList();
            var data = from x in records select new { x.ID, CreatedDateTime = x.CreatedDateTime.ToString(Website_Date_Format),
                EventDateTime = x.EventDateTime.ToString(Website_Date_Time_Format), Title = x.Title, EventLocation = x.EventLocation, EventOrganizer = x.EventOrganizer, Description = x.Description, isDefault = x.isDefault,x.Files };
            return Json(data, JsonRequestBehavior.AllowGet);
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("Jobs")]
        public JsonResult Jobs(int id)
        {
            var records = Database.Jobs.Where(x => x.Status == EnumStatus.Enable && x.IsDeleted == false && x.ID == id).ToList();
            var data = from x in records
            select new
            {
                x.ID,
                CreatedDateTime = x.CreatedDateTime.ToString(Website_Date_Format),
                SubmissionDate = x.SubmissionDate.ToString(Website_Date_Format),
                Title = x.Title,
                x.BusinessSelector,
                x.CareerLevel,
                x.Department,
                x.Description,
                x.EducationLevel,
                x.JobCode,
                x.JobType,
                x.Location,
                x.MinExp,
                x.Positions,
                x.Status,
            };
            return Json(data, JsonRequestBehavior.AllowGet);
        }



        public ActionResult ArchivedOrg()
        {
            var data = Database.OrgAnnouncements.Where(x => x.isNoticeBoard == false && x.IsDeleted == false &&x.Status==EnumStatus.Enable).ToList();
            return View(data);
        }
        public ActionResult ArchivedNlt()
        {
            var data = Database.NewsLetters.Where(x => x.IsDeleted == false && x.Status == EnumStatus.Enable).ToList();
            return View(data);
        }
        public ActionResult ArchivedNews()
        {
            var data = Database.LatestNews.Where(x => x.IsDeleted == false && x.Status == EnumStatus.Enable).ToList();
            return View(data);
        }

        public ActionResult ArchivedNotice()
        {
            var data = Database.OrgAnnouncements.Where(x => x.isNoticeBoard == true && x.IsDeleted == false && x.Status == EnumStatus.Enable).ToList();
            return View(data);
        }

        public ActionResult Explorer(string type,string keyword)
        {
            AddCookie("policy", type);
            AddCookie("keyword", keyword);
            ViewBag.WebsiteURL = GetSettingContentByName("Website URL");
            return View();
        }

        public ActionResult ServeyResponse(FormCollection form)
        {
            AjaxResponse ajaxResponse = new AjaxResponse();
            ajaxResponse.Success = false;
            ajaxResponse.Type = EnumJQueryResponseType.MessageOnly;
            ajaxResponse.Message = "Response is not in authentic format";
            TempData["error"] = ajaxResponse.Message;
            TempData["success"] = null;

            try
            {
                var QuestionIdsArray = string.IsNullOrEmpty(form.Get("ServeyQuestionId")) ? null : form.Get("ServeyQuestionId").Split(',');
                if (QuestionIdsArray != null)
                {
                    ServeyResponseMaster serveyResponseMasterRecord = new ServeyResponseMaster();
                    serveyResponseMasterRecord.ServeyMasterId = Convert.ToInt32(form.Get("ServeyMasterId"));
                    serveyResponseMasterRecord.Name = string.IsNullOrEmpty(form.Get("Name")) ? "(Unknown)" : form.Get("Name");
                    serveyResponseMasterRecord.EmailAddress = string.IsNullOrEmpty(form.Get("Email")) ? "(Unknown)" : form.Get("Email");
                    serveyResponseMasterRecord.CreatedDateTime = GetDateTime();
                    Database.ServeyResponseMasters.Add(serveyResponseMasterRecord);
                    Database.SaveChanges();
                    foreach (var QuestionId in QuestionIdsArray)
                    {
                        var Answer = form.Get("[" + QuestionId + "].Answer");
                        ServeyResponseAnswer serveyResponseAnswerRecord = new ServeyResponseAnswer();
                        serveyResponseAnswerRecord.ServeyResponseMasterId = serveyResponseMasterRecord.ID;
                        serveyResponseAnswerRecord.QuestionId = Convert.ToInt32(QuestionId);
                        serveyResponseAnswerRecord.Response = Answer;
                        Database.ServeyResponseAnswers.Add(serveyResponseAnswerRecord);
                        Database.SaveChanges();
                    }
                    ajaxResponse.Message = "Thanks! Your response is submitted";
                    TempData["success"] = ajaxResponse.Message;
                    TempData["error"] = null;
                }
                

            }
            catch (Exception ex)
            {

                ajaxResponse.Message = ex.Message;
                TempData["error"] = ajaxResponse.Message;
                TempData["success"] = null;
            }


            return RedirectToAction("index");
        }

        //public ActionResult Exp2()
        //{
        //    ViewBag.WebsiteURL = GetSettingContentByName("Website URL");
        //    return View();
        //}

        //public ActionResult Exp3()
        //{
        //    ViewBag.WebsiteURL = GetSettingContentByName("Website URL");
        //    return View();
        //}

        //public ActionResult Exp4()
        //{
        //    ViewBag.WebsiteURL = GetSettingContentByName("Website URL");
        //    return View();
        //}

        //public ActionResult Exp5()
        //{
        //    ViewBag.WebsiteURL = GetSettingContentByName("Website URL");
        //    return View();
        //}
    }
}