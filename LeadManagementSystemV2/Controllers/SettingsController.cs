using LeadManagementSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;

namespace LeadManagementSystemV2.Controllers
{
    public class SettingsController : BaseController
    {
        // GET: Settings
        public ActionResult Index()
        {
            return View("Form",GetRecord());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        [ValidateInput(false)]
        public ActionResult save(settings model)
        {
            AjaxResponse AjaxResponse = new AjaxResponse();
            AjaxResponse.Success = false;
            AjaxResponse.Type = EnumJQueryResponseType.FieldOnly;
            AjaxResponse.FieldName = "btnSave";
            if (model != null)
            {
                try
                {
                    var keys = Database.Settings.ToList();
                    keys.Where(x => x.Name == EnumDisplaySetting.Announce).FirstOrDefault().Content = model.announcementDisplay.ToString();
                    keys.Where(x => x.Name == EnumDisplaySetting.News).FirstOrDefault().Content = model.newsDisplay.ToString();
                    keys.Where(x => x.Name == EnumDisplaySetting.Notice).FirstOrDefault().Content = model.noticeDisplay.ToString();
                    Database.SaveChanges();
                    AjaxResponse.Message = "Changes Saved";
                    AjaxResponse.Success = true;
                }
                catch (Exception ex)
                {

                    AjaxResponse.Message = ex.Message;
                }
        
            }
            return Json(AjaxResponse);
        }
        public settings GetRecord()
        {

            settings _setting = new settings();
            _setting.announcementDisplay = string.IsNullOrEmpty(GetSettingContentByName(EnumDisplaySetting.Announce)) ? 1
                : Convert.ToInt32(GetSettingContentByName(EnumDisplaySetting.Announce));
            _setting.newsDisplay = string.IsNullOrEmpty(GetSettingContentByName(EnumDisplaySetting.News)) ? 1
                : Convert.ToInt32(GetSettingContentByName(EnumDisplaySetting.News));
            _setting.noticeDisplay = string.IsNullOrEmpty(GetSettingContentByName(EnumDisplaySetting.Notice)) ? 1
                : Convert.ToInt32(GetSettingContentByName(EnumDisplaySetting.Notice));
            return _setting;
        }
    }
}