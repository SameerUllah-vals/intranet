using LeadManagementSystemV2.Helpers;
using LeadManagementSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.SqlServer;
using System.Linq;
using System.Web.Mvc;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;

namespace LeadManagementSystemV2.Controllers
{
    public class DashboardController : BaseController
    {
        // GET: Dashboard
        public ActionResult Index()
        {
            ViewBag.Announcement = Database.OrgAnnouncements.Where(x => x.IsDeleted == false).ToList();
            ViewBag.NewsLetter = Database.NewsLetters.Where(x => x.IsDeleted == false).ToList();
            ViewBag.Banner = Database.Banners.Where(x => x.IsDeleted == false).ToList();
            ViewBag.Question = Database.Questions.Where(x => x.IsDeleted == false).ToList();
            ViewBag.Gallery = Database.Galleries.Where(x => x.IsDeleted == false).ToList();
            return View();
        }
        public ActionResult Profiles()
        {
            User UserRecord = GetUserData();
            ProfileModel profileModel = new ProfileModel();
            profileModel.ID = UserRecord.ID;
            profileModel.Name = UserRecord.Name;
            profileModel.EmailAddress = UserRecord.EmailAddress;
            return View("Profile", profileModel);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult Profiles(ProfileModel modelRecord, string DateOfBirth)
        {
            AjaxResponse AjaxResponse = new AjaxResponse();
            AjaxResponse.Success = false;
            AjaxResponse.Type = EnumJQueryResponseType.MessageOnly;
            AjaxResponse.Message = "Post Data Not Found";
            try
            {
                if (IsUserLogin())
                {
                    bool isAbleToUpdate = true;
                    var Record1 = Database.Users.FirstOrDefault(o => o.EmailAddress.ToLower().Equals(modelRecord.EmailAddress.ToLower()) && o.ID != modelRecord.ID && o.IsDeleted == false);
                    if (Record1 != null)
                    {
                        AjaxResponse.Type = EnumJQueryResponseType.FieldOnly;
                        AjaxResponse.FieldName = "EmailAddress";
                        AjaxResponse.Message = "Email Address already exist in our records";
                        isAbleToUpdate = false;
                    }
                    if (isAbleToUpdate)
                    {
                        var UserRecord = Database.Users.FirstOrDefault(o => o.ID == modelRecord.ID);
                        UserRecord.Name = modelRecord.Name;
                        if (UserRecord.RoleID == EnumRole.SuperAdministrator)
                        {
                            UserRecord.EmailAddress = modelRecord.EmailAddress;
                        }
                        if (!string.IsNullOrWhiteSpace(modelRecord.Password))
                        {
                            UserRecord.Password = Encrypt(modelRecord.Password);
                        }
                        AddSession(Session_User_Login, UserRecord);
                        Database.SaveChanges();
                        AjaxResponse.Type = EnumJQueryResponseType.MessageAndReloadWithDelay;
                        AjaxResponse.Message = "Profile Updated Successfully";
                        AjaxResponse.Success = true;
                    }
                }
                else
                {
                    AjaxResponse.Type = EnumJQueryResponseType.MessageAndRedirectWithDelay;
                    AjaxResponse.Message = "Session Expired";
                    AjaxResponse.TargetURL = ViewBag.WebsiteURL;
                }
            }
            catch (Exception ex)
            {
                AjaxResponse.Message = ex.Message;
            }
            return Json(AjaxResponse, "json");
        }
        public ActionResult Logout()
        {
            RemoveSession(Session_User_Login);
            return RedirectToAction("index", "account");
        }
        public ActionResult AccessUnauthorized()
        {
            return View("Unauthorized");
        }
    }
}