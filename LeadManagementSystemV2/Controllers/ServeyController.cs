using LeadManagementSystemV2.Models;
using System;
using System.IO;
using System.Linq;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using static LeadManagementSystemV2.Helpers.ApplicationHelper;
namespace LeadManagementSystemV2.Controllers
{
    public class ServeyController : BaseController
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
            IQueryable<ServeyMaster> dataSource;
            dataSource = Database.ServeyMasters.Where(o => o.IsDeleted == false).AsQueryable();
            int TotalDataCount = dataSource.Count();
            if (!string.IsNullOrWhiteSpace(param.Search.Value))
            {
                string searchValue = param.Search.Value.ToLower().Trim();
                DateTime searchDate = ParseExactDateTime(searchValue);
                dataSource = dataSource.Where(p => (
                    p.Title.ToLower().Contains(searchValue) ||
                    p.LastDate != null && System.Data.Entity.DbFunctions.TruncateTime(p.LastDate) == System.Data.Entity.DbFunctions.TruncateTime(searchDate) ||
                    p.CreatedDateTime != null && System.Data.Entity.DbFunctions.TruncateTime(p.CreatedDateTime) == System.Data.Entity.DbFunctions.TruncateTime(searchDate) ||
                    p.UpdatedDateTime != null && System.Data.Entity.DbFunctions.TruncateTime(p.UpdatedDateTime) == System.Data.Entity.DbFunctions.TruncateTime(searchDate))
                );
            }
            int FilteredDataCount = dataSource.Count();
            dataSource = dataSource.SortBy(param.SortOrder).Skip(param.Start).Take(param.Length);
            var resultList = dataSource.ToList();
            var resultData = from x in resultList
                             select new { x.ID, x.Title, x.Status, SubmissionDate = x.LastDate.ToString(Website_Date_Time_Format), CreatedDateTime = x.CreatedDateTime.ToString(Website_Date_Time_Format), UpdatedDateTime = (x.UpdatedDateTime.HasValue ? x.UpdatedDateTime.Value.ToString(Website_Date_Time_Format) : "") };
            var result = new
            {
                draw = param.Draw,
                data = resultData,
                recordsFiltered = FilteredDataCount,
                recordsTotal = TotalDataCount
            };
            return Json(result);
        }
        public ServeyMasterModel GetRecord(int? id)
        {
            User CurrentUserRecord = GetUserData();
            ServeyMasterModel Model = new ServeyMasterModel();
            var Record = Database.ServeyMasters.FirstOrDefault(o => o.ID == id && o.IsDeleted == false);
            if (Record != null)
            {
                Model.Id = Record.ID;
                Model.Title = Record.Title;
                Model.LastDate = Record.LastDate.ToString();
                Model.Status = Record.Status;
                Model.ServeyQuestion = Database.ServeyQuestions.Where(x => x.ServeyMasterId.Equals(Record.ID) && x.IsDeleted.Equals(false)).ToList();
                Model.serveyResponseMasters = Database.ServeyResponseMasters.Where(x => x.ServeyMasterId.Equals(Record.ID)).ToList();
                foreach (var record in Model.serveyResponseMasters)
                {
                    ServeyResponseShowModel serveyReponseShowModel = new ServeyResponseShowModel();
                    serveyReponseShowModel.serveyReponseAnswer = Database.ServeyResponseAnswers.Where(x => x.ServeyResponseMasterId.Equals(record.ID)).ToList();
                    serveyReponseShowModel.Name = record.Name;
                    serveyReponseShowModel.Email = record.EmailAddress;
                    serveyReponseShowModel.CreatedDate = record.CreatedDateTime;
                    Model.serveyResponseAnswers.Add(serveyReponseShowModel);
                }

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
                return Redirect(ViewBag.WebsiteURL + "servey");
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
                return Redirect(ViewBag.WebsiteURL + "servey");
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
                    var RecordToDelete = Database.ServeyMasters.FirstOrDefault(o => o.ID == RecordID && o.IsDeleted == false);
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
        public JsonResult Save(ServeyMasterModel modelRecord)
        {
            AjaxResponse AjaxResponse = new AjaxResponse();
            AjaxResponse.Success = false;
            AjaxResponse.Type = EnumJQueryResponseType.MessageOnly;
            AjaxResponse.Message = "Post Data Not Found";
            using (var transaction = Database.Database.BeginTransaction())
            {
                try
                {
                    if (IsUserLogin())
                    {

                        User CurrentUserRecord = GetUserData();
                        bool isAbleToUpdate = true;
                        if (isAbleToUpdate)
                        {
                            bool isRecordWillAdded = false;
                            ServeyMaster Record = Database.ServeyMasters.FirstOrDefault(x => x.ID == modelRecord.Id && x.IsDeleted == false);
                            if (Record == null)
                            {
                                Record = Database.ServeyMasters.Create();
                                isRecordWillAdded = true;
                            }
                            Record.Title = modelRecord.Title;
                            if (string.IsNullOrEmpty(modelRecord.LastDate))
                                Record.LastDate = DateTime.Now;
                            else
                                Record.LastDate = DateTime.Parse(modelRecord.LastDate);
                            //if (modelRecord.isDefault)
                            //{
                            //    var defaultrecord = Database.Questions.Where(x => x.isDefault == true).FirstOrDefault();
                            //    if (defaultrecord != null)
                            //    {
                            //        defaultrecord.isDefault = false;
                            //    }
                            //}
                            //Record.isDefault = modelRecord.isDefault;
                            Record.Status = modelRecord.Status;
                            Record.IsDeleted = false;
                            if (isRecordWillAdded)
                            {
                                Record.CreatedDateTime = GetDateTime();
                                Record.CreatedBy = CurrentUserRecord.ID;
                                Database.ServeyMasters.Add(Record);
                            }
                            else
                            {
                                Record.UpdatedDateTime = GetDateTime();
                                Record.UpdatedBy = CurrentUserRecord.ID;
                            }
                            Database.SaveChanges();
                            if (modelRecord.ServeyQuestion.Count > 0)
                            {
                                var AllQuestionRecords = Database.ServeyQuestions.Where(x => x.ServeyMasterId.Equals(Record.ID) && x.IsDeleted.Equals(false)).ToList();
                                var recordToDelete = AllQuestionRecords.Where(x => !modelRecord.ServeyQuestion.Any(s => s.ID == x.ID)).ToList();
                                recordToDelete.ForEach(x => x.IsDeleted = true);
                                Database.SaveChanges();
                                foreach (var serveyQuestion in modelRecord.ServeyQuestion)
                                {

                                    if (serveyQuestion.ID > 0)
                                    {
                                        var serveryQuestionRecord = AllQuestionRecords.FirstOrDefault(x => x.ID.Equals(serveyQuestion.ID));
                                        serveryQuestionRecord.Question = serveyQuestion.Question;
                                        serveryQuestionRecord.opt1 = serveyQuestion.opt1;
                                        serveryQuestionRecord.opt2 = serveyQuestion.opt2;
                                        serveryQuestionRecord.opt3 = serveyQuestion.opt3;
                                        serveryQuestionRecord.opt4 = serveyQuestion.opt4;
                                        serveryQuestionRecord.ServeyMasterId = Record.ID;
                                        serveryQuestionRecord.UpdatedBy = CurrentUserRecord.ID;
                                        serveryQuestionRecord.UpdatedDateTime = GetDateTime();
                                        Database.SaveChanges();
                                    }
                                    else
                                    {
                                        serveyQuestion.ServeyMasterId = Record.ID;
                                        serveyQuestion.CreatedBy = CurrentUserRecord.ID;
                                        serveyQuestion.CreatedDateTime = GetDateTime();
                                        serveyQuestion.IsDeleted = false;
                                        serveyQuestion.Status = EnumStatus.Enable;
                                        Database.ServeyQuestions.Add(serveyQuestion);
                                    }

                                }
                                Database.SaveChanges();
                            }
                            AjaxResponse.Type = EnumJQueryResponseType.MessageAndRedirectWithDelay;
                            AjaxResponse.Message = "Successfully Added.";
                            AjaxResponse.TargetURL = ViewBag.WebsiteURL + "servey";
                            AjaxResponse.Success = true;
                            transaction.Commit();
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
                    transaction.Rollback();

                }
            }
            return Json(AjaxResponse);
        }


    }
}