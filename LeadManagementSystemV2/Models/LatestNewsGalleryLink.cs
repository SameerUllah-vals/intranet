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
    
    public partial class LatestNewsGalleryLink
    {
        public int Id { get; set; }
        public int LatestNewsId { get; set; }
        public int GalleryId { get; set; }
    
        public virtual Gallery Gallery { get; set; }
        public virtual LatestNew LatestNew { get; set; }
    }
}