using LeadManagementSystemV2.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;

namespace LeadManagementSystemV2.Controllers
{
    public class BaseController : Controller
    {
        protected DbLeadManagementSystemV2Entities Database { get; set; }
        public BaseController()
        {
            Database = new DbLeadManagementSystemV2Entities();
        }
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            User CurrentUserRecord = GetUserData();
            var TodayDate = GetDateTime();
            //if(CurrentUserRecord !=null)
            //{
            //    ViewBag.Notification = Database.Leads.Where(x => x.IsDeleted.Equals(false) && x.UserID.Equals(CurrentUserRecord.ID) && System.Data.Entity.DbFunctions.TruncateTime(x.ReminderDate) == System.Data.Entity.DbFunctions.TruncateTime(TodayDate)).ToList();
            //}
            ViewBag.WebsiteURL = GetSettingContentByName("Website URL");
            
            ViewBag.jQuery_Date_Time_Format = jQuery_Date_Time_Format;
            ViewBag.jQuery_Date_Format = jQuery_Date_Format;
            ViewBag.Website_Date_Time_Format = Website_Date_Time_Format;
            ViewBag.Website_Date_Format = Website_Date_Format;
            int index = 2;
            var domainType = GetSettingContentByName("DomainType");
            if (domainType == EnumDomainType.SubDomain)
                index = 3;
            if (!filterContext.HttpContext.Request.IsAjaxRequest())
            {
                string[] requestURL = filterContext.HttpContext.Request.Path.ToString().Split('/');
                string controllerURL = requestURL[index - 1].ToLower(); //
                if (!IsUserLogin())
                {                   
                    filterContext.Result = new RedirectResult("/");
                }
                else
                {
                    ViewBag.ControllerName = UpperCaseWords(controllerURL);
                    ViewBag.ControllerURL = controllerURL;
                    string menuURL = controllerURL;
                    string actionURL = string.Empty;
                   
                    if (requestURL.Length > index) //
                    {
                        actionURL = requestURL[index].ToLower(); //
                        if (actionURL != "importexcel" && actionURL != "exportempty" && actionURL != "export" && actionURL != "add" && actionURL != "edit" && actionURL != "views" && actionURL != "sorting")
                        {
                            menuURL += "/" + actionURL;
                        }
                    }
                    User UserRecord = GetUserData();
                    User userCurrentRecord = Database.Users.FirstOrDefault(x => x.ID == UserRecord.ID);
                    ViewBag.ProfileImage = userCurrentRecord.ProfileImage == null ? "1.png" : userCurrentRecord.ProfileImage;
                    var UserRolePermissionRecords = Database.RolePermissions.Where(o => o.RoleID == UserRecord.RoleID).OrderBy(o => o.SequenceOrder).ToList();

                    if (!AllowedUrlList().Contains(menuURL))
                    {
                        filterContext.Result = new RedirectResult("/dashboard/accessunauthorized");
                        if (UserRolePermissionRecords.Count > 0)
                        {
                            var UserRolePermissionRecord = UserRolePermissionRecords.FirstOrDefault(o => o.Menu.AccessURL.ToLower().Equals(menuURL));
                            if (UserRolePermissionRecord != null)
                            {
                                if (UserRolePermissionRecord.Permissions.ToLower().Equals("all"))
                                {
                                    filterContext.Result = null;
                                    if (UserRolePermissionRecord.Menu.MenuPermissions.Any(o => o.Name.ToLower().Equals("add")))
                                    {
                                        ViewBag.AllowAdding = true;
                                    }
                                    if (UserRolePermissionRecord.Menu.MenuPermissions.Any(o => o.Name.ToLower().Equals("edit")))
                                    {
                                        ViewBag.AllowEditing = true;
                                    }
                                    if (UserRolePermissionRecord.Menu.MenuPermissions.Any(o => o.Name.ToLower().Equals("delete")))
                                    {
                                        ViewBag.AllowDeleting = true;
                                    }
                                    if (UserRolePermissionRecord.Menu.MenuPermissions.Any(o => o.Name.ToLower().Equals("view")))
                                    {
                                        ViewBag.AllowViewing = true;
                                    }
                                    if (UserRolePermissionRecord.Menu.MenuPermissions.Any(o => o.Name.ToLower().Equals("sorting")))
                                    {
                                        ViewBag.AllowSorting = true;
                                    }
                                }
                                else
                                {
                                    string[] UserPermissionArray = UserRolePermissionRecord.Permissions.ToLower().Split('|');
                                    if (string.IsNullOrWhiteSpace(actionURL) || UserPermissionArray.Contains(actionURL))
                                    {
                                        filterContext.Result = null;
                                    }
                                    if (filterContext.Result == null)
                                    {
                                        if (UserPermissionArray.Contains("add"))
                                        {
                                            ViewBag.AllowAdding = true;
                                        }
                                        if (UserPermissionArray.Contains("edit"))
                                        {
                                            ViewBag.AllowEditing = true;
                                        }
                                        if (UserPermissionArray.Contains("delete"))
                                        {
                                            ViewBag.AllowDeleting = true;
                                        }
                                        if (UserPermissionArray.Contains("view"))
                                        {
                                            ViewBag.AllowViewing = true;
                                        }
                                        if (UserPermissionArray.Contains("sorting"))
                                        {
                                            ViewBag.AllowSorting = true;
                                        }
                                    }
                                }
                                if (filterContext.Result == null)
                                {
                                    ViewBag.ControllerName = UserRolePermissionRecord.Menu.Name;
                                }
                            }
                        }
                    }

                    if (filterContext.Result == null)
                    {
                        ViewBag.UserRecord = UserRecord;
                        if (UserRolePermissionRecords.Count > 0)
                        {
                            ViewBag.UserRolePermissionRecords = UserRolePermissionRecords;
                            ViewBag.UserRoleParentPermissionRecords = UserRolePermissionRecords.Where(o => o.Menu.Menu1 != null).Select(o => o.Menu.Menu1).Distinct().ToList();
                        }
                        List<BreadCrumbMenu> breadCrumbList = new List<BreadCrumbMenu>();
                        if (!string.IsNullOrWhiteSpace(actionURL))
                        {
                            ViewBag.ActionName = UpperCaseFirstLetter(actionURL);
                            ViewBag.ActionURL = controllerURL;
                            if (!controllerURL.Equals("dashboard"))
                            {
                                breadCrumbList.Add(new BreadCrumbMenu { Name = ViewBag.ControllerName, AccessURL = ConvertToWebURL(controllerURL), ClassName = "" });
                            }
                            breadCrumbList.Add(new BreadCrumbMenu { Name = ViewBag.ActionName, AccessURL = "#", ClassName = "active" });
                        }
                        else
                        {
                            breadCrumbList.Add(new BreadCrumbMenu { Name = ViewBag.ControllerName, AccessURL = "#", ClassName = "active" });
                        }
                        ViewBag.BreadCrumbMenus = breadCrumbList;
                        ViewBag.PageURL = ViewBag.WebsiteURL + controllerURL;
                        ViewBag.PageName = controllerURL;
                    }
                }
            }
            base.OnActionExecuting(filterContext);
        }
        protected override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            base.OnActionExecuted(filterContext);
        }
        protected override void Dispose(bool disposing)
        {
            Database.Dispose();
            base.Dispose(disposing);
        }
    }
}