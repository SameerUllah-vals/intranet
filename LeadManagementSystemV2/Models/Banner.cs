//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace LeadManagementSystemV2.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Banner
    {
        public int ID { get; set; }
        public string Title { get; set; }
        public string Image { get; set; }
        public string Ticker { get; set; }
        public string Status { get; set; }
        public bool IsDeleted { get; set; }
        public System.DateTime CreatedDateTime { get; set; }
        public Nullable<System.DateTime> UpdatedDateTime { get; set; }
        public Nullable<System.DateTime> DeletedDateTime { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<int> UpdatedBy { get; set; }
        public Nullable<int> DeletedBy { get; set; }
        public Nullable<bool> isDefault { get; set; }
    }
}
