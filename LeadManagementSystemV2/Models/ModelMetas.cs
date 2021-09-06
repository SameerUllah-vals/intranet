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
        public List<LatestNewsGalleryLink> GalleryLink { get; set; }

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
        public string Image { get; set; }
        public string Description{ get; set; }
        public string Status { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public DateTime UpdatedDateTime { get; set; }
        public DateTime DeletedDateTime { get; set; }
        public int CreatedBy { get; set; }
        public int UpdatedBy { get; set; }
        public int DeletedBy { get; set; }

        public List<GalleryDetail> galleryDetails { get; set; }
    }


    public class ServeyMasterModel 
    {
        public int Id { get; set; }
        [Required (ErrorMessage = "this field is required")]
        public string Title { get; set; }
        public string Status { get; set; }

        [Required(ErrorMessage = "this field is required")]

        public string LastDate { get; set; }

        public List<ServeyQuestion> ServeyQuestion { get; set; } = new List<ServeyQuestion>();
        public List<ServeyResponseMaster> serveyResponseMasters { get; set; } = new List<ServeyResponseMaster>(); 
        public List<ServeyResponseShowModel> serveyResponseAnswers { get; set; } = new List<ServeyResponseShowModel>();
    }
    public class ServeyResponseShowModel 
    {
        public List<ServeyResponseAnswer> serveyReponseAnswer { get; set; } = new List<ServeyResponseAnswer>();
        public string Name{ get; set; }
        public string Email{ get; set; }
        public DateTime CreatedDate{ get; set; }
    }

    public class ResponseMasterModel
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public List<ServeyQuestion> Questions { get; set; } = new List<ServeyQuestion>();
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

        public string SubmissionDate { get; set; }
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
        public string Image { get; set; }
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
        public OrgAnnouncementModel()
        {
            Files = new List<OrgAnnouncementDetail>();
        }
        public int ID { get; set; }

        [Required(ErrorMessage = "Required")]
        public string Title { get; set; }

        [Required(ErrorMessage = "Required")]        
        public string Announcement { get; set; }
        public bool isNoticeBoard { get; set; }
        public string Status { get; set; }
        public List<OrgAnnouncementDetail> Files { get; set; }
        public HttpPostedFileBase[] File { get; set; }
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
        public string SubmissionDate { get; set; }
        public string Description { get; set; }
        public string Status { get; set; }
    }

    public class BusinessAppModel
    {
        public int ID { get; set; }
        [Required]

        public string Name { get; set; }
        [Required]
        public string Category { get; set; }
        [Required]

        public string IsFooterLink { get; set; }
        public string Url { get; set; }
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
        public string Files { get; set; }
        public HttpPostedFileBase File { get; set; }
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
        public IEnumerable<Job> Jobs { get; set; }
        public IEnumerable<Policy> Policies { get; set; }
        public settings setting { get; set; } = new settings();
        public ResponseMasterModel Servey { get; set; } = new ResponseMasterModel();
    }

    public class DirModel
    {
        public string DirName { get; set; }
        public DateTime DirAccessed { get; set; }
    }

    public class FileModel
    {
        public string FileName { get; set; }
        public string FileSizeText { get; set; }
        public DateTime FileAccessed { get; set; }
    }

    public class ExplorerModel
    {
        public List<DirModel> dirModelList;
        public List<FileModel> fileModelList;

        public ExplorerModel(List<DirModel> _dirModelList, List<FileModel> _fileModelList)
        {
            dirModelList = _dirModelList;
            fileModelList = _fileModelList;
        }
    }

    public class settings
    {
        public int  noticeDisplay{ get; set; }
        public int  newsDisplay{ get; set; }
        public int  announcementDisplay{ get; set; }
    }

}