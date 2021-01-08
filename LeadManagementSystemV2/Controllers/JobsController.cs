using LeadManagementSystemV2.Models;
using System;
using System.IO;
using System.Linq;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;
namespace LeadManagementSystemV2.Controllers
{
    public class JobsController : BaseController
    {
        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        [ValidateInput(false)]
        public JsonResult Listener(DTParameters param)
        {
            User CurrentUserRecord = GetUserData();
            IQueryable<Job> dataSource;
            dataSource = Database.Jobs.Where(o => o.IsDeleted == false).AsQueryable();
            int TotalDataCount = dataSource.Count();
            if (!string.IsNullOrWhiteSpace(param.Search.Value))
            {
                string searchValue = param.Search.Value.ToLower().Trim();
                DateTime searchDate = ParseExactDateTime(searchValue);
                dataSource = dataSource.Where(p => (
                    p.Title.ToLower().Contains(searchValue) ||
                    p.JobCode.ToLower().Contains(searchValue) ||
                    p.BusinessSelector.ToLower().Contains(searchValue) ||
                    p.CareerLevel.ToLower().Contains(searchValue) ||
                    p.Department.ToLower().Contains(searchValue) ||
                    p.Description.ToLower().Contains(searchValue) ||
                    p.EducationLevel.ToLower().Contains(searchValue) ||
                    p.JobType.ToLower().Contains(searchValue) ||
                    p.Location.ToLower().Contains(searchValue) ||
                    p.MinExp.ToLower().Contains(searchValue) ||
                    p.Positions.ToString().ToLower().Contains(searchValue) ||
                    p.Title.ToLower().Contains(searchValue) ||
                    p.SubmissionDate != null && System.Data.Entity.DbFunctions.TruncateTime(p.SubmissionDate) == System.Data.Entity.DbFunctions.TruncateTime(searchDate) ||
                    p.CreatedDateTime != null && System.Data.Entity.DbFunctions.TruncateTime(p.CreatedDateTime) == System.Data.Entity.DbFunctions.TruncateTime(searchDate) ||
                    p.UpdatedDateTime != null && System.Data.Entity.DbFunctions.TruncateTime(p.UpdatedDateTime) == System.Data.Entity.DbFunctions.TruncateTime(searchDate))
                );
            }
            int FilteredDataCount = dataSource.Count();
            dataSource = dataSource.SortBy(param.SortOrder).Skip(param.Start).Take(param.Length);
            var resultList = dataSource.ToList();
            var resultData = from x in resultList
                             select new { x.ID, x.Title, x.JobCode, x.BusinessSelector,x.Positions, x.Status, SubmissionDate = x.SubmissionDate.ToString(Website_Date_Format), CreatedDateTime = x.CreatedDateTime.ToString(Website_Date_Time_Format), UpdatedDateTime = (x.UpdatedDateTime.HasValue ? x.UpdatedDateTime.Value.ToString(Website_Date_Time_Format) : "") };
            var result = new
            {
                draw = param.Draw,
                data = resultData,
                recordsFiltered = FilteredDataCount,
                recordsTotal = TotalDataCount
            };
            return Json(result);
        }
        public JobModel GetRecord(int? id)
        {
            User CurrentUserRecord = GetUserData();
            JobModel Model = new JobModel();
            var Record = Database.Jobs.FirstOrDefault(o => o.ID == id && o.IsDeleted == false);
            if (Record != null)
            {
                Model.ID = Record.ID;
                Model.JobCode = Record.JobCode;
                Model.Title = Record.Title;
                Model.BusinessSelector = Record.BusinessSelector;
                Model.CareerLevel = Record.CareerLevel;
                Model.Department = Record.Department;
                Model.Description = Record.Description;
                Model.EducationLevel = Record.EducationLevel;
                Model.JobType = Record.JobType;
                Model.Location = Record.Location;
                Model.MinExp = Record.MinExp;
                Model.Positions = (int)Record.Positions;
                Model.SubmissionDate = Record.SubmissionDate;  
                Model.Status = Record.Status;  
            }
            return Model;
        }
        public ActionResult Add()
        {
            ViewBag.PageType = "Add";
            return View("Form", GetRecord(0));
        }
        public ActionResult Edit(int? id)
        {
            var Record = GetRecord(id);
            if (Record != null)
            {
                ViewBag.PageType = "Edit";
                return View("Form", Record);
            }
            else
            {
                return Redirect(ViewBag.WebsiteURL + "jobs");
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
                return Redirect(ViewBag.WebsiteURL + "jobs");
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
                    var RecordToDelete = Database.Jobs.FirstOrDefault(o => o.ID == RecordID && o.IsDeleted == false);
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
        public JsonResult Save(JobModel modelRecord)
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
                        Job Record = Database.Jobs.FirstOrDefault(x => x.ID == modelRecord.ID && x.IsDeleted == false);
                        if (Record == null)
                        {
                            Record = Database.Jobs.Create();
                            isRecordWillAdded = true;
                        }
                        Record.Title = modelRecord.Title;
                        Record.BusinessSelector = modelRecord.BusinessSelector;
                        Record.CareerLevel = modelRecord.CareerLevel;
                        Record.Department = modelRecord.Department;
                        Record.Description = modelRecord.Description;
                        Record.EducationLevel = modelRecord.EducationLevel;
                        Record.JobCode = modelRecord.JobCode;
                        Record.JobType = modelRecord.JobType;
                        Record.Location = modelRecord.Location;
                        Record.MinExp = modelRecord.MinExp;
                        Record.Positions = modelRecord.Positions;
                        Record.SubmissionDate = modelRecord.SubmissionDate;
                        Record.Status = modelRecord.Status;
                        Record.IsDeleted = false;
                        if (isRecordWillAdded)
                        {
                            Record.CreatedDateTime = GetDateTime();
                            Record.CreatedBy = CurrentUserRecord.ID;
                            Database.Jobs.Add(Record);
                        }
                        else
                        {
                            Record.UpdatedDateTime = GetDateTime();
                            Record.UpdatedBy = CurrentUserRecord.ID;
                        }
                        Database.SaveChanges();
                        AjaxResponse.Type = EnumJQueryResponseType.MessageAndRedirectWithDelay;
                        AjaxResponse.Message = "Successfully Added.";
                        AjaxResponse.TargetURL = ViewBag.WebsiteURL + "jobs";
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