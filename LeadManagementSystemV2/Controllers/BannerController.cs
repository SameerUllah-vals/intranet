﻿using LeadManagementSystemV2.Models;
using System;
using System.IO;
using System.Linq;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;
namespace LeadManagementSystemV2.Controllers
{
    public class BannerController : BaseController
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
            IQueryable<Banner> dataSource;           
            dataSource = Database.Banners.Where(o => o.IsDeleted == false).AsQueryable();
            int TotalDataCount = dataSource.Count();
            if (!string.IsNullOrWhiteSpace(param.Search.Value))
            {
                string searchValue = param.Search.Value.ToLower().Trim();
                DateTime searchDate = ParseExactDateTime(searchValue);
                dataSource = dataSource.Where(p => (
                    p.Title.ToLower().Contains(searchValue) ||
                    p.CreatedDateTime != null && System.Data.Entity.DbFunctions.TruncateTime(p.CreatedDateTime) == System.Data.Entity.DbFunctions.TruncateTime(searchDate) ||
                    p.UpdatedDateTime != null && System.Data.Entity.DbFunctions.TruncateTime(p.UpdatedDateTime) == System.Data.Entity.DbFunctions.TruncateTime(searchDate))
                );
            }
            int FilteredDataCount = dataSource.Count();
            dataSource = dataSource.SortBy(param.SortOrder).Skip(param.Start).Take(param.Length);
            var resultList = dataSource.ToList();
            var resultData = from x in resultList
                             select new { x.ID, x.Title,x.Image , x.Status, CreatedDateTime = x.CreatedDateTime.ToString(Website_Date_Time_Format), UpdatedDateTime = (x.UpdatedDateTime.HasValue ? x.UpdatedDateTime.Value.ToString(Website_Date_Time_Format) : "") };
            var result = new
            {
                draw = param.Draw,
                data = resultData,
                recordsFiltered = FilteredDataCount,
                recordsTotal = TotalDataCount
            };
            return Json(result);
        }
        public BannerModel GetRecord(int? id)
        {
            User CurrentUserRecord = GetUserData();
            BannerModel Model = new BannerModel();
            var Record = Database.Banners.FirstOrDefault(o => o.ID == id && o.IsDeleted == false);
            if (Record != null)
            {
                Model.ID = Record.ID;
                Model.Title = Record.Title;
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
                return Redirect(ViewBag.WebsiteURL + "banner");
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
                return Redirect(ViewBag.WebsiteURL + "banner");
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
                    var RecordToDelete = Database.Banners.FirstOrDefault(o => o.ID == RecordID && o.IsDeleted == false);
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
        public JsonResult Save(BannerModel modelRecord)
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
                        Banner Record = Database.Banners.FirstOrDefault(x => x.ID == modelRecord.ID && x.IsDeleted == false);
                        if (Record == null)
                        {
                            Record = Database.Banners.Create();
                            isRecordWillAdded = true;
                        }
                        Record.Title = modelRecord.Title;
                        Record.Status = modelRecord.Status;
                        Record.IsDeleted = false;
                        if(modelRecord.ImageFile != null)
                        {
                            UploadFiles(modelRecord.ImageFile, Server, Banner_Image_Path);
                            Record.Image = modelRecord.ImageFile.FileName;
                        }
                        if (isRecordWillAdded)
                        {
                            Record.CreatedDateTime = GetDateTime();
                            Record.CreatedBy = CurrentUserRecord.ID;
                            Database.Banners.Add(Record);
                        }
                        else
                        {
                            Record.UpdatedDateTime = GetDateTime();
                            Record.UpdatedBy = CurrentUserRecord.ID;
                        }
                        Database.SaveChanges();
                        AjaxResponse.Type = EnumJQueryResponseType.MessageAndRedirectWithDelay;
                        AjaxResponse.Message = "Successfully Added.";
                        AjaxResponse.TargetURL = ViewBag.WebsiteURL + "banner";
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
            catch (FileFormatException ex)
            {
                string _catchMessage = ex.Message;                
                AjaxResponse.Message = _catchMessage;
                AjaxResponse.Type = EnumJQueryResponseType.FieldOnly;
                AjaxResponse.FieldName = "ImageFile";
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