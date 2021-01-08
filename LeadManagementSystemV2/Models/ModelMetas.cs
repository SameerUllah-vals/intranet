using DocumentFormat.OpenXml.Drawing.Charts;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web;

namespace LeadManagementSystemV2.Models
{
    public class CustomerModel
    {
        public string Text { get; set; }
        public int Value { get; set; }
    }
    public class UsersLeadListModel
    {
        public string Text { get; set; }
        public int Value { get; set; }
    }
    public class StatusModel
    {
        public string Text { get; set; }
        public string Value { get; set; }
    }
  
    public class SourceModel
    {
        public string Text { get; set; }
        public string Value { get; set; }
    }
    public class ServicesModel
    {
        public string Text { get; set; }
        public string Value { get; set; }
    }
    public class BreadCrumbMenu
    {
        public string Name { get; set; }
        public string ClassName { get; set; }
        public string AccessURL { get; set; }
    }
    public class LoginModel
    {
        [Required(ErrorMessage = "Required")]
        [DataType(DataType.EmailAddress)]
        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        public string EmailAddress { get; set; }
        [Required(ErrorMessage = "Required")]
        public string Password { get; set; }
    }
    public class ProfileModel
    {
        public int ID { get; set; }
        [Required(ErrorMessage = "Required")]
        public string Name { get; set; }
        [Required(ErrorMessage = "Required")]
        [DataType(DataType.EmailAddress)]
        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        public string EmailAddress { get; set; }
        public string Password { get; set; }
    }
    public class RoleModel
    {
        public int? ID { get; set; }
        [Required(ErrorMessage = "Required")]
        public int BranchID { get; set; }
        [Required(ErrorMessage = "Required")]
        public string Name { get; set; }
        public string Status { get; set; }
    }
    public class UserModel
    {
        public int? ID { get; set; }
        public int? BranchID { get; set; }
        [Required(ErrorMessage = "Required")]
        public int RoleID { get; set; }
        [Required(ErrorMessage = "Required")]
        public int DepartmentID { get; set; }

        [Required(ErrorMessage = "Required")]


        public string Name { get; set; }
        [Required(ErrorMessage = "Required")]
        public string EmailAddress { get; set; }
        [Required(ErrorMessage = "Required")]
        public string Password { get; set; }
        public string ProfileImage { get; set; }
        [Required(ErrorMessage = "Required")]
        public string Status { get; set; }
        [Required(ErrorMessage = "Required")]
        public bool IsDeleted { get; set; }
        [Required(ErrorMessage = "Required")]
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public DateTime DeletedDateTime { get; set; }
        [Required(ErrorMessage = "Required")]
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        public int DeletedBy { get; set; }
    }

    public class BannerModel
    {
        public int ID { get; set; }

        [Required(ErrorMessage ="Required")]
        public string Title { get; set; }
        public string Ticker { get; set; }

        [Required(ErrorMessage = "Required")]
        public HttpPostedFileBase ImageFile { get; set; }
        public string Base64 { get; set; }
        public string Status { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public DateTime DeletedDateTime { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        public int DeletedBy { get; set; }


    }
    public class LatestNewsModel
    {
        public int ID { get; set; }

        [Required(ErrorMessage = "Required")]
        public string Title { get; set; }

        [Required(ErrorMessage = "Required")]
        public string ShortDescription { get; set; }

        [Required(ErrorMessage = "Required")]
        public string Description { get; set; }
        public string Status { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public DateTime DeletedDateTime { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        public int DeletedBy { get; set; }


    }

    public class LatestNewsGalleryLinkModel
    {
        public int ID { get; set; }
        [Required(ErrorMessage = "Required")]
        public int GalleryId { get; set; }
        [Required(ErrorMessage = "Required")]
        public int LatestnewsId { get; set; }
    }
    public class GalleryModel
    {
        public int ID { get; set; }

        [Required(ErrorMessage = "Required")]
        public string Title { get; set; }

        [Required(ErrorMessage = "Required")]
        public HttpPostedFileBase Thumbnail { get; set; }
        [Required(ErrorMessage = "Required")]
        public HttpPostedFileBase[] ImageFiles { get; set; }
        public string Description{ get; set; }
        public string Status { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public DateTime DeletedDateTime { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        public int DeletedBy { get; set; }


    }


    public class QuestionModel
    {
        public int ID { get; set; }

        [Required(ErrorMessage = "Required")]
        public string Title { get; set; }

        [Required(ErrorMessage = "Required")]
        public string Option1 { get; set; }
        [Required(ErrorMessage = "Required")]

        public string Option2 { get; set; }
        [Required(ErrorMessage = "Required")]

        public string Option3 { get; set; }
        [Required(ErrorMessage = "Required")]

        public string Option4 { get; set; }
        [Required(ErrorMessage = "Required")]

        public DateTime SubmissionDate { get; set; }
        public string Status { get; set; }
        public bool IsDeleted { get; set; }
        public bool isDefault { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public DateTime DeletedDateTime { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        public int DeletedBy { get; set; }


    }

    public class QuestionDetailsModel
    {
        public int ID { get; set; }
        public int QuestionsId { get; set; }
        public string opt { get; set; }
        public string IpAddress { get; set; }
        public DateTime CreatedDateTime { get; set; }

    }

    public class NewsLetterModel
    {
        public int ID { get; set; }

        [Required(ErrorMessage = "Required")]
        public string Title { get; set; }
        [Required(ErrorMessage = "Required")]
        public HttpPostedFileBase file { get; set; }
        public string PDF { get; set; }

        [Required(ErrorMessage = "Required")]
        public HttpPostedFileBase ImageFile { get; set; }
        public bool isDefault { get; set; }
        public string Status { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public DateTime DeletedDateTime { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        public int DeletedBy { get; set; }


    }

    public class OrgAnnouncementModel
    {
        public int ID { get; set; }

        [Required(ErrorMessage = "Required")]
        public string Title { get; set; }

        [Required(ErrorMessage = "Required")]        
        public string Announcement { get; set; }
        public bool isNoticeBoard { get; set; }
        public string Status { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public DateTime DeletedDateTime { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        public int DeletedBy { get; set; }
    }

    public class JobModel
    {
        public int ID { get; set; }
        [Required(ErrorMessage = "Required")]
        public string JobCode { get; set; }
        [Required(ErrorMessage = "Required")]
        public string Title { get; set; }
        public string Department { get; set; }
        public string Location { get; set; }
        public string BusinessSelector { get; set; }
        public string JobType { get; set; }
        public int Positions { get; set; }
        public string CareerLevel { get; set; }
        public string EducationLevel { get; set; }
        public string MinExp { get; set; }
        [Required(ErrorMessage = "Required")]
        public System.DateTime SubmissionDate { get; set; }
        public string Description { get; set; }
        public string Status { get; set; }
    }

    public class PolicyModel
    {
        public int ID { get; set; }
        [Required(ErrorMessage = "Required")]
        public string Title { get; set; }
        [Required(ErrorMessage = "Required")]
        public string Type { get; set; }
        [Required(ErrorMessage = "Required")]
        public string Category { get; set; }
        [Required(ErrorMessage = "Required")]
        public string PDF { get; set; }
        public HttpPostedFileBase file { get; set; }
        public string Status { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public DateTime DeletedDateTime { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        public int DeletedBy { get; set; }
        public bool isDefault { get; set; }
    }

    public class EventModel
    {
        public int ID { get; set; }
        [Required(ErrorMessage = "Required")]
        public string Title { get; set; }
        public string EventOrganizer { get; set; }
        public string EventLocation { get; set; }
        [Required(ErrorMessage = "Required")]
        public DateTime EventDateTime { get; set; }
        public string Description { get; set; }
        public string Status { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public DateTime DeletedDateTime { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        public int DeletedBy { get; set; }
    }
    public class viewModel
    {
        public Banner banner { get; set; }
        public IEnumerable<OrgAnnouncement> OrgAnoouncement { get; set; }
        public IEnumerable<Gallery> Galleries { get; set; }
        public IEnumerable<LatestNew> LatestNews { get; set; }
        public IEnumerable<NewsLetter> NewsLetter { get; set; }
        public Question Servey { get; set; }
        public IEnumerable<QuestionDetail> ServeyResponse { get; set; }
        public IEnumerable<Job> Jobs { get; set; }
        public IEnumerable<Policy> Policies { get; set; }

    }

}