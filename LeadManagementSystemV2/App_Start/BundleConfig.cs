using System.Web;
using System.Web.Optimization;

namespace LeadManagementSystemV2
{
    public class BundleConfig
    {
        // For more information on bundling, visit https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new StyleBundle("~/assets/cache/site").Include(
                   "~/assets/css/bootstrap.css",
                   "~/assets/css/nifty.css",
                   "~/assets/css/nifty-demo-icons.css",
                   "~/assets/plugins/pace/pace.min.css",
                   "~/assets/css/nifty-demo.css",
                   "~/assets/plugins/font-awesome/css/font-awesome.min.css",
                   "~/assets/css/jquery-confirm.min.css",
                   "~/assets/css/summernote.min.css",
                   "~/assets/css/dropzone.min.css"
            ));
            bundles.Add(new StyleBundle("~/assets/cache/datatablestyle").Include(
                  "~/assets/plugins/datatables/media/css/dataTables.bootstrap.css",
                  "~/assets/plugins/datatables/extensions/Responsive/css/responsive.dataTables.min.css"
            ));
            bundles.Add(new StyleBundle("~/assets/cache/datepickerstyle").Include(
                 "~/assets/plugins/bootstrap-datepicker/bootstrap-datepicker.min.css"
             ));
            bundles.Add(new StyleBundle("~/assets/cache/timepickerstyle").Include(
                "~/assets/plugins/bootstrap-timepicker/bootstrap-timepicker.min.css"
            ));
            bundles.Add(new StyleBundle("~/assets/cache/chosen").Include(
                "~/assets/plugins/chosen/chosen.min.css"
            ));
            bundles.Add(new StyleBundle("~/assets/cache/bootstrapselect").Include(
                "~/assets/plugins/bootstrap-select/bootstrap-select.min.css"
            ));
            bundles.Add(new StyleBundle("~/assets/cache/select2style").Include(
                "~/assets/plugins/select2/css/select2.min.css"
            ));
            bundles.Add(new ScriptBundle("~/assets/cache/jquery").Include(
                 "~/assets/js/jquery-3.3.1.js"
            ));
            bundles.Add(new ScriptBundle("~/assets/cache/core").Include(
                "~/assets/js/bootstrap.js",
                "~/assets/plugins/pace/pace.min.js",
                "~/assets/js/nifty.js",
                "~/assets/js/nifty-demo.js",
                "~/assets/js/notify.js",
                "~/assets/js/jquery-confirm.min.js",
                "~/assets/js/autoNumeric.js",
                "~/assets/js/jquery.validate.js",
                "~/assets/js/jquery.unobtrusive-ajax.js",
                "~/assets/js/jquery.validate.unobtrusive.js"           
            ));
            bundles.Add(new ScriptBundle("~/assets/cache/datatablescript").Include(
                "~/assets/plugins/datatables/media/js/jquery.dataTables.js",
                "~/assets/plugins/datatables/media/js/dataTables.bootstrap.js",
                "~/assets/plugins/datatables/extensions/Responsive/js/dataTables.responsive.min.js"
            ));
            bundles.Add(new ScriptBundle("~/assets/cache/datepickerscript").Include(
                "~/assets/plugins/bootstrap-datepicker/bootstrap-datepicker.min.js"
            ));
            bundles.Add(new ScriptBundle("~/assets/cache/timepickerscript").Include(
               "~/assets/plugins/bootstrap-timepicker/bootstrap-timepicker.min.js"
           ));
            bundles.Add(new ScriptBundle("~/assets/cache/chosen.min.js").Include(
               "~/assets/plugins/chosen/chosen.jquery.min.js"
           ));
            bundles.Add(new ScriptBundle("~/assets/cache/select2script").Include(
                "~/assets/plugins/select2/js/select2.min.js"
            ));
            bundles.Add(new ScriptBundle("~/assets/cache/summernote").Include(
               "~/assets/plugins/summernote/summernote.min.js"
           ));
            bundles.Add(new ScriptBundle("~/assets/cache/dropzone").Include(
              "~/assets/plugins/dropzone/dropzone.min.js"
          ));
            bundles.Add(new ScriptBundle("~/assets/cache/function").Include(
                 "~/assets/js/functions.js"
            ));
            bundles.Add(new ScriptBundle("~/assets/cache/component").Include(
                "~/assets/js/form-component.js"
           ));
            bundles.Add(new ScriptBundle("~/assets/cache/fileupload").Include(
               "~/assets/js/form-file-upload.js"
          ));
        }
    }
}