using LeadManagementSystemV2.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;

namespace LeadManagementSystemV2.Controllers
{
    public class ManagementsController : BaseController
    {
        // GET: Management
        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        [ValidateInput(false)]
        public JsonResult Listener(DTParameters param)
        {
            User CurrentUserRecord = GetUserData();
            IQueryable<User> dataSource;
            if (CurrentUserRecord.RoleID == EnumRole.SuperAdministrator)
            {
                dataSource = Database.Users.Where(o => o.IsDeleted == false).AsQueryable();
            }
            else
            {
                dataSource = Database.Users.Where(o => o.IsDeleted == false && o.CreatedBy == CurrentUserRecord.ID).AsQueryable();
            }
            int TotalDataCount = dataSource.Count();
            if (!string.IsNullOrWhiteSpace(param.Search.Value))
            {
                string searchValue = param.Search.Value.ToLower().Trim();
                DateTime searchDate = ParseExactDateTime(searchValue);
                dataSource = dataSource.Where(p => (
                    p.Name.ToLower().Contains(searchValue) ||
                    p.EmailAddress.ToLower().Contains(searchValue) ||
                    p.Status.ToLower().Contains(searchValue) ||
                    p.Role.Name.ToLower().Contains(searchValue) ||
                    p.CreatedDateTime != null && System.Data.Entity.DbFunctions.TruncateTime(p.CreatedDateTime) == System.Data.Entity.DbFunctions.TruncateTime(searchDate) ||
                    p.UpdatedDateTime != null && System.Data.Entity.DbFunctions.TruncateTime(p.UpdatedDateTime) == System.Data.Entity.DbFunctions.TruncateTime(searchDate))
                );
            }
            int FilteredDataCount = dataSource.Count();
            dataSource = dataSource.SortBy(param.SortOrder).Skip(param.Start).Take(param.Length);
            var resultList = dataSource.ToList();
            var resultData = from x in resultList
                             select new { x.ID, x.Name, RoleName = x.Role.Name,  x.EmailAddress, x.Status, CreatedDateTime = x.CreatedDateTime.ToString(Website_Date_Time_Format), UpdatedDateTime = (x.UpdatedDateTime.HasValue ? x.UpdatedDateTime.Value.ToString(Website_Date_Time_Format) : "") };

            var result = new
            {
                draw = param.Draw,
                data = resultData,
                recordsFiltered = FilteredDataCount,
                recordsTotal = TotalDataCount
            };
            return Json(result);
        }
        public void StatusRecords()
        {
            var StatusItems = new List<StatusModel>();
            StatusItems.Add(new StatusModel() { Value = "Enable", Text = "Enable" });
            StatusItems.Add(new StatusModel() { Value = "Disable", Text = "Disable" });
            ViewBag.StatusRecords = StatusItems;
        }
        public void RolesRecords()
        {
            ViewBag.RolesRecords = Database.Roles.Where(x => x.Status == EnumStatus.Enable && x.IsDeleted==false).ToList().Select(x => new { Value = x.ID, Text = x.Name });
        }
      
        public UserModel GetRecord(int? id)
        {
            RolesRecords();
            StatusRecords();
            User CurrentUserRecord = GetUserData();
            UserModel userModel = new UserModel();
            var Record = Database.Users.FirstOrDefault(o => o.ID == id && o.IsDeleted == false);
            if (Record != null)
            {
                userModel.ID = Record.ID;
                userModel.EmailAddress = Record.EmailAddress;
                userModel.Name = Record.Name;
                userModel.Status = Record.Status;
                userModel.RoleID = Record.RoleID;
                userModel.Password = Decrypt(Record.Password);
            }
            return userModel;
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
                return Redirect(ViewBag.WebsiteURL + "managements");
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
                return Redirect(ViewBag.WebsiteURL + "managements");
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
                    var RecordToDelete = Database.Users.FirstOrDefault(o => o.ID == RecordID && o.IsDeleted == false);
                    if (RecordToDelete != null)
                    {
                        if (RecordToDelete.ID == 1)
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
        public JsonResult Save(UserModel modelRecord)
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
                        if (!string.IsNullOrWhiteSpace(modelRecord.EmailAddress))
                        {
                            var Record = Database.Users.FirstOrDefault(o => o.EmailAddress.ToLower().Equals(modelRecord.EmailAddress.ToLower()) && o.ID != modelRecord.ID && o.IsDeleted == false);
                            if (Record != null)
                            {
                                AjaxResponse.Type = EnumJQueryResponseType.FieldOnly;
                                AjaxResponse.FieldName = "Email";
                                AjaxResponse.Message = "Email already exist in our records";
                                isAbleToUpdate = false;
                            }
                        }
                    }
                    if (isAbleToUpdate)
                    {
                        bool isRecordWillAdded = false;
                        User UserRecord = Database.Users.FirstOrDefault(x => x.ID == modelRecord.ID && x.IsDeleted == false);
                        if (UserRecord == null)
                        {
                            UserRecord = Database.Users.Create();
                            isRecordWillAdded = true;
                        }
                        string LoginEncryptPasswordValue = Encrypt(modelRecord.Password);
                        UserRecord.RoleID = modelRecord.RoleID;
                        UserRecord.Name = modelRecord.Name;
                        UserRecord.EmailAddress = modelRecord.EmailAddress;
                        UserRecord.Password = LoginEncryptPasswordValue;

                        if (string.IsNullOrWhiteSpace(modelRecord.Status))
                        {
                            UserRecord.Status = EnumStatus.Enable;
                        }
                        else
                        {
                            UserRecord.Status = modelRecord.Status;
                        }

                        if (isRecordWillAdded)
                        {
                            UserRecord.CreatedDateTime = GetDateTime();
                            UserRecord.CreatedBy = CurrentUserRecord.ID;
                            Database.Users.Add(UserRecord);
                            var currentDateTime = GetDateTime();                           
                        }
                        else
                        {
                            UserRecord.UpdatedDateTime = GetDateTime();
                            UserRecord.UpdatedBy = CurrentUserRecord.ID;
                        }
                        Database.SaveChanges();
                        AjaxResponse.Type = EnumJQueryResponseType.MessageAndRedirectWithDelay;
                        AjaxResponse.Message = "Successfully Added.";
                        AjaxResponse.TargetURL = ViewBag.WebsiteURL + "managements";
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