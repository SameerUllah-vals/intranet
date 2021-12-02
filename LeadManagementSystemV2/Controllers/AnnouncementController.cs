using LeadManagementSystemV2.Models;
using System;
using System.IO;
using System.Linq;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;
namespace LeadManagementSystemV2.Controllers
{
    public class AnnouncementController : BaseController
    {
        public ActionResult Index(string RequestType)
        {
            ViewBag.RequestType = RequestType;
            return View();
        }
        [HttpPost]
        [ValidateInput(false)]
        public JsonResult Listener(DTParameters param)
        {
            User CurrentUserRecord = GetUserData();
            IQueryable<OrgAnnouncement> dataSource;
            if(string.IsNullOrEmpty(param.status))
                dataSource = Database.OrgAnnouncements.Where(o => o.IsDeleted == false).AsQueryable();
            else
                dataSource = Database.OrgAnnouncements.Where(o => o.IsDeleted == false && o.Status== EnumStatus.Enable).AsQueryable();
            int TotalDataCount = dataSource.Count();
            if (!string.IsNullOrWhiteSpace(param.Search.Value))
            {
                string searchValue = param.Search.Value.ToLower().Trim();
                DateTime searchDate = ParseExactDateTime(searchValue);
                dataSource = dataSource.Where(p => (
                    p.Title.ToLower().Contains(searchValue) ||
                    p.Announcement.ToLower().Contains(searchValue) ||
                    p.Files.ToLower().Contains(searchValue) ||
                    p.CreatedDateTime != null && System.Data.Entity.DbFunctions.TruncateTime(p.CreatedDateTime) == System.Data.Entity.DbFunctions.TruncateTime(searchDate) ||
                    p.UpdatedDateTime != null && System.Data.Entity.DbFunctions.TruncateTime(p.UpdatedDateTime) == System.Data.Entity.DbFunctions.TruncateTime(searchDate))
                );
            }
            int FilteredDataCount = dataSource.Count();
            dataSource = dataSource.SortBy(param.SortOrder).Skip(param.Start).Take(param.Length);
            var resultList = dataSource.ToList();
            var resultData = from x in resultList
                             select new { x.ID, x.Title, Files = x.OrgAnnouncementDetails.Select(m => new {m.Files }).ToList(), x.Announcement, Status = x.Status , CreatedBy = x.User.Name, UpdatedBy = (x.User1 != null ? x.User1.Name : "") ,CreatedDateTime = x.CreatedDateTime.ToString(Website_Date_Time_Format), UpdatedDateTime = (x.UpdatedDateTime.HasValue ? x.UpdatedDateTime.Value.ToString(Website_Date_Time_Format) : "") };
            var result = new
            {
                draw = param.Draw,
                data = resultData,
                recordsFiltered = FilteredDataCount,
                recordsTotal = TotalDataCount
            };
            return Json(result);
        }
        public OrgAnnouncementModel GetRecord(int? id)
        {
            User CurrentUserRecord = GetUserData();
            OrgAnnouncementModel Model = new OrgAnnouncementModel();
            var Record = Database.OrgAnnouncements.FirstOrDefault(o => o.ID == id && o.IsDeleted == false);
            if (Record != null)
            {
                Model.ID = Record.ID;
                Model.Title = Record.Title;
                Model.Announcement = Record.Announcement;
                Model.Status = Record.Status;
                Model.Files = Record.OrgAnnouncementDetails.ToList();
                Model.isNoticeBoard = (bool)Record.isNoticeBoard;
            }
            return Model;
        }

        public ActionResult RemoveFile(int? id)
        {
            User CurrentUserRecord = GetUserData();
            OrgAnnouncementModel Model = new OrgAnnouncementModel();
            var Record = Database.OrgAnnouncements.FirstOrDefault(o => o.ID == id && o.IsDeleted == false);
            if (Record != null)
            {
               
                Record.Files = null;
                
            }
            return RedirectToAction("Edit",new {id = id });
        }
        public ActionResult Add()
        {
            ViewBag.PageType = "Add";
            return View("Form", GetRecord(0));
        }
        public ActionResult Edit(int? id,int? fileRemove)
        {
            if (fileRemove != null)
            {
                var data = Database.OrgAnnouncementDetails.Find(fileRemove);
                if (data != null)
                {
                    Database.OrgAnnouncementDetails.Remove(data);
                    Database.SaveChanges();
                }
            }
            var Record = GetRecord(id);
            if (Record != null)
            {
                ViewBag.PageType = "Edit";
                return View("Form", Record);
            }
            else
            {
                return Redirect(ViewBag.WebsiteURL + "announcement");
            }
        }
        public ActionResult Views(int? id)
        {
            var Record = GetRecord(id);
            if (Record != null)
            {
                ViewBag.PageType = EnumPageType.View;
                return View("Form", Record);
            }
            else
            {
                return Redirect(ViewBag.WebsiteURL + "announcement");
            }
        }
        [HttpPost]
        [ValidateInput(false)]
        public JsonResult Delete(string _value)
        {
            AjaxResponse AjaxResponse = new AjaxResponse();
            AjaxResponse.Success = false;
            AjaxResponse.Type = EnumJQueryResponseType.MessageOnly;
            AjaxResponse.Message = "Data not found in our records";
            int RecordID = ParseInt(_value);
            if (IsUserLogin())
            {
                User CurrentUserRecord = GetUserData();
                if (RecordID == 0)
                {
                    AjaxResponse.Message = "ID is not in numeric format";
                }
                else
                {
                    var RecordToDelete = Database.OrgAnnouncements.FirstOrDefault(o => o.ID == RecordID && o.IsDeleted == false);
                    if (RecordToDelete != null)
                    {
                        if (RecordToDelete.ID == 0)
                        {
                            AjaxResponse.Message = "Unable to delete this record";
                        }
                        else
                        {
                            RecordToDelete.IsDeleted = true;
                            RecordToDelete.DeletedDateTime = GetDateTime();
                            Database.SaveChanges();
                            AjaxResponse.Success = true;
                            AjaxResponse.Message = "Record Deleted Successfully";
                        }
                    }
                }
            }
            else
            {
                AjaxResponse.Type = EnumJQueryResponseType.MessageAndRedirectWithDelay;
                AjaxResponse.Message = "Session Expired";
                AjaxResponse.TargetURL = ViewBag.WebsiteURL;
            }
            return Json(AjaxResponse, "json");
        }
        
        [HttpPost]
        [ValidateAntiForgeryToken]
        [ValidateInput(false)]
        public JsonResult Save(OrgAnnouncementModel modelRecord)
        {
            AjaxResponse AjaxResponse = new AjaxResponse();
            AjaxResponse.Success = false;
            AjaxResponse.Type = EnumJQueryResponseType.MessageOnly;
            AjaxResponse.Message = "Post Data Not Found";
            try
            {
                if (IsUserLogin())
                {
                    User CurrentUserRecord = GetUserData();
                    bool isAbleToUpdate = true;
                    if (isAbleToUpdate)
                    {
                        bool isRecordWillAdded = false;
                        OrgAnnouncement Record = Database.OrgAnnouncements.FirstOrDefault(x => x.ID == modelRecord.ID && x.IsDeleted == false);
                        if (Record == null)
                        {
                            Record = Database.OrgAnnouncements.Create();
                            isRecordWillAdded = true;
                        }
                        Record.Title = modelRecord.Title;
                        Record.Announcement = modelRecord.Announcement;
                        Record.isNoticeBoard = modelRecord.isNoticeBoard;
                        Record.Status = modelRecord.Status;
                        Record.IsDeleted = false;
                   
                        if (isRecordWillAdded)
                        {
                            Record.CreatedDateTime = GetDateTime();
                            Record.CreatedBy = CurrentUserRecord.ID;
                            Database.OrgAnnouncements.Add(Record);
                        }
                        else
                        {
                            Record.UpdatedDateTime = GetDateTime();
                            Record.UpdatedBy = CurrentUserRecord.ID;
                        }
                        if (modelRecord.File != null)
                        {
                            try
                            {
                                for (int i = 0; i < modelRecord.File.Length; i++)
                                {
                                    OrgAnnouncementDetail orgDetails = new OrgAnnouncementDetail();
                                    orgDetails.Files = UploadFiles(modelRecord.File[i], Server, Document_Path, "any");                                    
                                    orgDetails.OrgAnnoucmentID = modelRecord.ID;
                                    Database.OrgAnnouncementDetails.Add(orgDetails);
                                }

                            }
                            catch (FileFormatException ex)
                            {
                                string _catchMessage = ex.Message;
                                AjaxResponse.Message = _catchMessage;
                                AjaxResponse.Type = EnumJQueryResponseType.FieldOnly;
                                AjaxResponse.FieldName = "file";
                                return Json(AjaxResponse);
                            }
                        }
                        Database.SaveChanges();
                        AjaxResponse.Type = EnumJQueryResponseType.MessageAndRedirectWithDelay;
                        AjaxResponse.Message = "Successfully Added.";
                        AjaxResponse.TargetURL = ViewBag.WebsiteURL + "announcement";
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
                string _catchMessage = ex.Message;
                if (ex.InnerException != null)
                {
                    _catchMessage += "<br/>" + ex.InnerException.Message;
                }
                AjaxResponse.Message = _catchMessage;

            }

            return Json(AjaxResponse);
        }
    }
}