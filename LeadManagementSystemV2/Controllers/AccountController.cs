using System;
using System.Linq;
using System.Web.Mvc;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;
using LeadManagementSystemV2.Models;

namespace LeadManagementSystemV2.Controllers
{
    public class AccountController : Controller
    {
        DbLeadManagementSystemV2Entities Database;
        public AccountController()
        {
            Database = new DbLeadManagementSystemV2Entities();
        }
        // GET: Account
        public ActionResult Index()
        {
            if (IsUserLogin())
            {
                return RedirectToAction("index", "dashboard");
            }
            else
            {
                LoginModel loginModel = new LoginModel();
                string cookieEmailAddress = ParseString(GetCookie(Cookie_User_Email_Address));
                string cookiePassword = ParseString(GetCookie(Cookie_User_Password));
                if (!string.IsNullOrWhiteSpace(cookieEmailAddress) && !string.IsNullOrWhiteSpace(cookiePassword))
                {
                    loginModel.EmailAddress = cookieEmailAddress;
                    loginModel.Password = cookiePassword;
                }
                return View("Login", loginModel);
            }
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public JsonResult Login(LoginModel loginModel, string RememberMe)
        {
            AjaxResponse AjaxResponse = new AjaxResponse();
            AjaxResponse.Success = false;
            AjaxResponse.Type = EnumJQueryResponseType.MessageOnly;
            AjaxResponse.Message = "Invalid login attempt.";
            try
            {
                if (!string.IsNullOrWhiteSpace(loginModel.EmailAddress) && !string.IsNullOrWhiteSpace(loginModel.Password))
                {
                    string LoginEncryptPasswordValue = Encrypt(loginModel.Password);
                    var UserRecord = Database.Users.FirstOrDefault(o => o.EmailAddress.Equals(loginModel.EmailAddress) && o.Password.Equals(LoginEncryptPasswordValue) && o.IsDeleted == false && o.Status == EnumStatus.Enable);
                    if (UserRecord != null)
                    {
                        if (UserRecord.Status.Equals(EnumStatus.Enable))
                        {
                            AddSession(Session_User_Login, UserRecord);
                            if (!string.IsNullOrWhiteSpace(RememberMe))
                            {
                                AddCookie(Cookie_User_Email_Address, loginModel.EmailAddress);
                                AddCookie(Cookie_User_Password, loginModel.Password);
                            }
                            else
                            {
                                RemoveCookie(Cookie_User_Email_Address);
                                RemoveCookie(Cookie_User_Password);
                            }
                            AjaxResponse.Success = true;
                            AjaxResponse.Type = EnumJQueryResponseType.RedirectOnly;
                            AjaxResponse.Message = "";
                            if (GetCookie("ReturnURL") != string.Empty)
                            {
                                AjaxResponse.TargetURL = GetCookie("ReturnURL");
                                RemoveCookie("ReturnURL");
                            }
                            else
                            {
                                AjaxResponse.TargetURL = ConvertToWebURL("dashboard");
                            }
                        }
                        else
                        {
                            AjaxResponse.Message = "Your Account has been deactivated by administrator";
                        }
                    }
                    else
                    {
                        AjaxResponse.Message = "Invalid login attempt";
                    }
                }
            }
            catch (Exception ex)
            {
                AjaxResponse.Message = ex.Message;
            }
            return Json(AjaxResponse, "json");
        }
    }
}