using LeadManagementSystemV2.Models;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;

namespace LeadManagementSystemV2.Controllers
{
    public class RolesController : BaseController
    {
        // GET: Roles
        public ActionResult Index()
        {
            return View();
        }
        [HttpPost]
        [ValidateInput(false)]
        public JsonResult Listener(DTParameters param)
        {
            User CurrentUserRecord = GetUserData();
            IQueryable<Role> dataSource;
            if (CurrentUserRecord.RoleID == EnumRole.SuperAdministrator)
            {
                dataSource = Database.Roles.Where(x => x.ID != 1 && x.IsDeleted == false).OrderByDescending(x=>x.ID).AsQueryable();
            }
            else
            {
                dataSource = Database.Roles.Where(o => o.ID != 1 && o.IsDeleted == false && o.CreatedBy == CurrentUserRecord.ID).AsQueryable();
            }
            int TotalDataCount = dataSource.Count();
            if (!string.IsNullOrWhiteSpace(param.Search.Value))
            {
                string searchValue = param.Search.Value.ToLower().Trim();
                DateTime searchDate = ParseExactDateTime(searchValue);
                dataSource = dataSource.Where(p => (
                    p.Name.ToLower().Contains(searchValue) ||
                    p.Status.ToLower().Contains(searchValue) ||
                    p.CreatedDateTime != null && System.Data.Entity.DbFunctions.TruncateTime(p.CreatedDateTime) == System.Data.Entity.DbFunctions.TruncateTime(searchDate) ||
                    p.UpdatedDateTime != null && System.Data.Entity.DbFunctions.TruncateTime(p.UpdatedDateTime) == System.Data.Entity.DbFunctions.TruncateTime(searchDate))
                );
            }
            int FilteredDataCount = dataSource.Count();
            dataSource = dataSource.SortBy(param.SortOrder).Skip(param.Start).Take(param.Length);
            var resultList = dataSource.ToList();

            var resultData = from x in resultList
                             select new { x.ID, x.Name, x.Status, CreatedDateTime = x.CreatedDateTime.ToString(Website_Date_Time_Format), UpdatedDateTime = (x.UpdatedDateTime.HasValue ? x.UpdatedDateTime.Value.ToString(Website_Date_Time_Format) : "") };

            var result = new
            {
                draw = param.Draw,
                data = resultData,
                recordsFiltered = FilteredDataCount,
                recordsTotal = TotalDataCount
            };
            return Json(result);
        }
        public JsonResult GetMenus(int id)
        {
            AjaxResponse ajaxResponse = new AjaxResponse();
            ajaxResponse.Success = false;
            ajaxResponse.Type = EnumJQueryResponseType.DataOnly;
            ajaxResponse.Message = "No Record Found";
            IQueryable<Models.Menu> menusRecord = Database.Menus.Where(x => x.ParentID == null).AsQueryable();
            if (menusRecord.Count() > 0)
            {
                List<Dictionary<string, object>> menus = new List<Dictionary<string, object>>();
                foreach (var menu in menusRecord)
                {
                    Dictionary<string, object> menuDictionary = new Dictionary<string, object>();
                    menuDictionary.Add("ID", menu.ID);
                    menuDictionary.Add("Name", menu.Name);
                    var childMenus = menu.Menus1.AsQueryable();
                    List<object> childMenuList = new List<object>();
                    foreach (var chld in childMenus)
                    {
                        Dictionary<string, object> childMenuDictionary = new Dictionary<string, object>();
                        childMenuDictionary.Add("ID", chld.ID);
                        childMenuDictionary.Add("Name", chld.Name);
                        var permissions = chld.MenuPermissions.OrderByDescending(x => x.Type).ToList();
                        List<object> childMenuPermissionList = new List<object>();
                        foreach (var perm in permissions)
                        {
                            Dictionary<string, object> childMenuPermissionDictionary = new Dictionary<string, object>();
                            childMenuPermissionDictionary.Add("ID", perm.ID);
                            childMenuPermissionDictionary.Add("Name", perm.Name);
                            childMenuPermissionDictionary.Add("Type", perm.Type);
                            bool isSelected = false;
                            var existingPermission = Database.RolePermissions.FirstOrDefault(x => x.RoleID == id && x.MenuID == chld.ID);
                            if (existingPermission != null)
                            {
                                if (existingPermission.Permissions.Split('|').Contains(perm.Name))
                                {
                                    isSelected = true;
                                }
                                else
                                {
                                    isSelected = false;
                                }
                            }
                            else { }
                            childMenuPermissionDictionary.Add("Selected", isSelected);
                            childMenuPermissionList.Add(childMenuPermissionDictionary);
                        }
                        childMenuDictionary.Add("Permissions", childMenuPermissionList);
                        childMenuList.Add(childMenuDictionary);
                    }
                    menuDictionary.Add("Menus", childMenuList);
                    menus.Add(menuDictionary);
                }
                ajaxResponse.Success = true;
                ajaxResponse.Message = string.Empty;
                ajaxResponse.Type = EnumJQueryResponseType.DataOnly;
                ajaxResponse.Data = JsonConvert.SerializeObject(menus);
            }
            return Json(ajaxResponse);
        }
        public RoleModel GetRecord(int? id)
        {
            User CurrentUserRecord = GetUserData();
            RoleModel modelRecord = new RoleModel();
            var Record = Database.Roles.FirstOrDefault(o => o.ID == id && o.ID != 1 && o.IsDeleted == false);
            if (Record != null)
            {
                modelRecord.ID = Record.ID;
                modelRecord.Name = Record.Name;
                modelRecord.Status = Record.Status;
            }
            var StatusItems = new List<StatusModel>();
            StatusItems.Add(new StatusModel() { Value = EnumStatus.Enable, Text = EnumStatus.Enable });
            StatusItems.Add(new StatusModel() { Value = EnumStatus.Disable, Text = EnumStatus.Disable });
            ViewBag.StatusRecords = StatusItems;
            return modelRecord;
        }
        public ActionResult Add()
        {
            ViewBag.PageType = EnumPageType.Add;
            return View("Form", GetRecord(0));
        }
        public ActionResult Edit(int? id)
        {
            var Record = GetRecord(id);
            if (Record != null)
            {
                ViewBag.PageType = EnumPageType.Edit;
                return View("Form", Record);
            }
            else
            {
                return Redirect(ViewBag.WebsiteURL + "roles");
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
                return Redirect(ViewBag.WebsiteURL + "roles");
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
                if (RecordID == 0)
                {
                    AjaxResponse.Message = "ID is not in numeric format";
                }
                else
                {
                    var RecordToDelete = Database.Roles.FirstOrDefault(o => o.ID == RecordID && o.IsDeleted == false);
                    if (RecordToDelete != null)
                    {
                        if (RecordToDelete.ID <= 3)
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
        public JsonResult Save(RoleModel modelRecord, string RolePermission)
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
                    var Record = Database.Roles.FirstOrDefault(o => o.Name.ToLower().Equals(modelRecord.Name.ToLower()) && o.ID != modelRecord.ID && o.IsDeleted == false);
                    if (Record != null)
                    {
                        AjaxResponse.Type = EnumJQueryResponseType.FieldOnly;
                        AjaxResponse.FieldName = "Name";
                        AjaxResponse.Message = "Name already exist in our records";
                        isAbleToUpdate = false;
                    }
                    if (isAbleToUpdate)
                    {
                        bool isRecordWillAdded = false;
                        var DataRecord = Database.Roles.FirstOrDefault(x => x.ID == modelRecord.ID && x.IsDeleted == false);
                        if (DataRecord == null)
                        {
                            DataRecord = Database.Roles.Create();
                            isRecordWillAdded = true;
                        }
                        DataRecord.Name = modelRecord.Name;
                        DataRecord.Status = modelRecord.Status;
                        if (isRecordWillAdded)
                        {
                            if (RolePermission.Trim() != string.Empty)
                            {
                                DataRecord.CreatedDateTime = GetDateTime();
                                DataRecord.CreatedBy = CurrentUserRecord.ID;
                                Database.Roles.Add(DataRecord);
                            }
                            else
                            {
                                AjaxResponse.Type = EnumJQueryResponseType.MessageOnly;
                                AjaxResponse.Message = "Please select atleast one permission";
                                return Json(AjaxResponse);
                            }
                        }
                        else
                        {
                            DataRecord.UpdatedDateTime = GetDateTime();
                            DataRecord.UpdatedBy = CurrentUserRecord.ID;
                        }
                        Database.SaveChanges();
                        if (!string.IsNullOrWhiteSpace(RolePermission))
                        {
                            string[] RecordRolePermissionArray = RolePermission.Split(new string[] { "||" }, StringSplitOptions.None);
                            if (RecordRolePermissionArray.Length > 0)
                            {
                                int SequenceOrder = 0;
                                foreach (string RolePermission1 in RecordRolePermissionArray)
                                {
                                    string[] RolePermissionArray = RolePermission1.Split(',');
                                    if (RolePermissionArray.Length == 2)
                                    {
                                        int MenuID = ParseInt(RolePermissionArray[0]);
                                        string MenuPermission = ParseString(RolePermissionArray[1]);
                                        if (MenuID != 0 && !string.IsNullOrWhiteSpace(MenuPermission))
                                        {
                                            if (MenuPermission.Equals("None"))
                                            {
                                                var RecordToDelete = Database.RolePermissions.FirstOrDefault(o => o.MenuID == MenuID && o.RoleID == DataRecord.ID);
                                                if (RecordToDelete != null)
                                                {
                                                    Database.RolePermissions.Remove(RecordToDelete);
                                                    Database.SaveChanges();
                                                }
                                            }
                                            else
                                            {
                                                bool isPermissionAdd = false;
                                                var RolePermissionRecord = Database.RolePermissions.FirstOrDefault(o => o.MenuID == MenuID && o.RoleID == DataRecord.ID);
                                                if (RolePermissionRecord == null)
                                                {
                                                    isPermissionAdd = true;
                                                    RolePermissionRecord = new RolePermission();
                                                }
                                                RolePermissionRecord.RoleID = DataRecord.ID;
                                                RolePermissionRecord.MenuID = MenuID;
                                                RolePermissionRecord.Permissions = MenuPermission;
                                                RolePermissionRecord.SequenceOrder = SequenceOrder;
                                                if (isPermissionAdd)
                                                {
                                                    RolePermissionRecord.CreatedBy = CurrentUserRecord.ID;
                                                    RolePermissionRecord.CreatedDateTime = GetDateTime();
                                                    Database.RolePermissions.Add(RolePermissionRecord);
                                                }
                                                Database.SaveChanges();
                                                SequenceOrder += 1;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if (isRecordWillAdded)
                        {
                            AjaxResponse.Message = "Record Added Successfully";
                        }
                        else
                        {
                            AjaxResponse.Message = "Record Updated Successfully";
                        }
                        AjaxResponse.Type = EnumJQueryResponseType.MessageAndRedirectWithDelay;
                        AjaxResponse.TargetURL = ViewBag.WebsiteURL + "roles";
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