using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LeadManagementSystemV2
{
    public partial class exp4 : System.Web.UI.Page
    {
		protected void Page_Load(object sender, EventArgs e)
		{
			ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
			scriptManager.RegisterPostBackControl(this.TreeView1);
			if (!IsPostBack)
			{
				string path = ConfigurationManager.AppSettings["InspectPoliciesPath"].ToString();
				System.IO.DirectoryInfo RootDir = new System.IO.DirectoryInfo(path);

				// output the directory into a node
				TreeNode RootNode = OutputDirectory(RootDir, null);

				// add the output to the tree
				TreeView1.Nodes.Add(RootNode);
			}
		}

		protected void TreeView1_SelectedNodeChanged(object sender, EventArgs e)
		{
			string filename = ConfigurationManager.AppSettings["InspectPoliciesPath"].ToString() + TreeView1.SelectedNode.ValuePath.Substring(TreeView1.SelectedNode.ValuePath.IndexOf("/") + 1);
			//string filename = Path.GetFullPath(TreeView1.SelectedValue);

			System.IO.FileInfo file = new System.IO.FileInfo(filename);

			if (file.Exists)
			{
				//System.Diagnostics.Process.Start(file.FullName);
				System.Web.HttpResponse response = System.Web.HttpContext.Current.Response;
				response.ClearContent();
				response.Clear();
				response.ContentType = "text/plain";
				response.AddHeader("Content-Disposition",
								   "attachment; filename=" + TreeView1.SelectedValue + ";");
				response.TransmitFile(filename);
				response.Flush();
				response.End();
			}
		}
		TreeNode OutputDirectory(System.IO.DirectoryInfo directory, TreeNode parentNode)
		{
			// validate param
			if (directory == null) return null;

			// create a node for this directory
			TreeNode DirNode = new TreeNode(directory.Name);

			// get subdirectories of the current directory
			System.IO.DirectoryInfo[] SubDirectories = directory.GetDirectories();

			// output each subdirectory
			for (int DirectoryCount = 0; DirectoryCount < SubDirectories.Length; DirectoryCount++)
			{
				OutputDirectory(SubDirectories[DirectoryCount], DirNode);
			}

			// output the current directories files
			System.IO.FileInfo[] Files = directory.GetFiles();

			for (int FileCount = 0; FileCount < Files.Length; FileCount++)
			{
				DirNode.ChildNodes.Add(new TreeNode(Files[FileCount].Name));
			}

			// if the parent node is null, return this node
			// otherwise add this node to the parent and return the parent
			if (parentNode == null)
			{
				return DirNode;
			}
			else
			{
				parentNode.ChildNodes.Add(DirNode);
				return parentNode;
			}
		}
	}
}