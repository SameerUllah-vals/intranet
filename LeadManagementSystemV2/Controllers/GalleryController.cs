using LeadManagementSystemV2.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;
namespace LeadManagementSystemV2.Controllers
{
    public class GalleryController : BaseController
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
            IQueryable<Gallery> dataSource;
            dataSource = Database.Galleries.Where(o => o.IsDeleted == false).AsQueryable();
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
                             select new { x.ID, x.Title, x.Image, x.Status, CreatedDateTime = x.CreatedDateTime.ToString(Website_Date_Time_Format), UpdatedDateTime = (x.UpdatedDateTime.HasValue ? x.UpdatedDateTime.Value.ToString(Website_Date_Time_Format) : "") };
            var result = new
            {
                draw = param.Draw,
                data = resultData,
                recordsFiltered = FilteredDataCount,
                recordsTotal = TotalDataCount
            };
            return Json(result);
        }
        public GalleryModel GetRecord(int? id)
        {
            User CurrentUserRecord = GetUserData();
            GalleryModel Model = new GalleryModel();
            var Record = Database.Galleries.FirstOrDefault(o => o.ID == id && o.IsDeleted == false);
            var details = Database.GalleryDetails.Where(x => x.GalleryId == id).ToList();

            if (Record != null)
            {
                Model.ID = Record.ID;
                Model.Title = Record.Title;
                Model.Status = Record.Status;
                Model.Image = Record.Image;
                if (details.Count > 0)
                    Model.galleryDetails = details;
                else
                    Model.galleryDetails = new List<GalleryDetail>();
            }
            else
                Model.galleryDetails = new List<GalleryDetail>();

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
                return Redirect(ViewBag.WebsiteURL + "gallery");
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
                return Redirect(ViewBag.WebsiteURL + "gallery");
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
                    var RecordToDelete = Database.Galleries.FirstOrDefault(o => o.ID == RecordID && o.IsDeleted == false);
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
        [ValidateInput(false)]
        public JsonResult DeleteDetails(string _value)
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
                    var RecordToDelete = Database.GalleryDetails.FirstOrDefault(o => o.ID == RecordID);
                    if (RecordToDelete != null)
                    {
                        if (RecordToDelete.ID == 0)
                        {
                            AjaxResponse.Message = "Unable to delete this record";
                        }
                        else
                        {
                            Database.GalleryDetails.Remove(RecordToDelete);
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
        public JsonResult Save(GalleryModel modelRecord, string[] titles)
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
                        Gallery Record = Database.Galleries.FirstOrDefault(x => x.ID == modelRecord.ID && x.IsDeleted == false);
                        if (Record == null)
                        {
                            Record = Database.Galleries.Create();
                            isRecordWillAdded = true;
                        }
                        Record.Title = modelRecord.Title;
                        Record.Status = modelRecord.Status;
                        Record.IsDeleted = false;
                       
                        if (isRecordWillAdded)
                        {
                           
                            Record.CreatedDateTime = GetDateTime();
                            Record.CreatedBy = CurrentUserRecord.ID;
                            Database.Galleries.Add(Record);                         
                        }
                        else
                        {
                            Record.UpdatedDateTime = GetDateTime();
                            Record.UpdatedBy = CurrentUserRecord.ID;
                        }
                        for (int i = 0; i < Request.Files.Count; i++)
                        {
                            var _file = Request.Files[i];
                            string formattedFileName = UploadFiles(_file, Server, Gallery_Image_Path);
                            GalleryDetail details = new GalleryDetail();
                            if (i == 0)
                            {
                                
                                Record.Image = formattedFileName;
                                details.Title = Record.Title;

                            }
                            else
                            {
                               
                               
                               details.Title = titles[i - 1];
                                
                            }

                            details.GalleryId = Record.ID;
                            details.Image = formattedFileName;
                            details.CreatedDateTime = GetDateTime();
                            Database.GalleryDetails.Add(details);

                        }
                        Database.SaveChanges();
                        AjaxResponse.Type = EnumJQueryResponseType.MessageAndRedirectWithDelay;
                        AjaxResponse.TargetURL = ViewBag.WebsiteURL + "gallery";
                        AjaxResponse.Message = "Please wait images are uploading..";
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

        public ActionResult upload(FormCollection form)
        {
            AjaxResponse AjaxResponse = new AjaxResponse();
            AjaxResponse.Success = false;
            AjaxResponse.Type = EnumJQueryResponseType.MessageOnly;
            AjaxResponse.Message = "Post Data Not Found";
            if (Request.Files.Count > 0)
            {
                try
                {
                    var titlesArray = form.Get("titles");
                    string[] titles = titlesArray.Split(',');
                    var _GalleryId = form.Get("GalleryId");
                    int GalleryId = _GalleryId != null ? Convert.ToInt32(_GalleryId) : 0;
                    int count = 0;
                    foreach (string file in Request.Files)
                    {
                        var _file = Request.Files[file];
                        GalleryDetail details = new GalleryDetail();
                        details.Image = UploadFiles(_file, Server, Gallery_Image_Path);                        
                        details.GalleryId = GalleryId;
                        details.Title = titles[count];
                        details.CreatedDateTime = GetDateTime();
                        Database.GalleryDetails.Add(details);
                        count++;
                    }
                    Database.SaveChanges();
                }
                catch (Exception ex)
                {
                    AjaxResponse.Message = "Ann error occured due to: " + ex.Message;
                }             
                AjaxResponse.Type = EnumJQueryResponseType.MessageAndRedirectWithDelay;
                AjaxResponse.TargetURL = ViewBag.WebsiteURL + "gallery";
                AjaxResponse.Message = "Images Uploaded";
            }
            return Json(AjaxResponse);
        }
    }
}