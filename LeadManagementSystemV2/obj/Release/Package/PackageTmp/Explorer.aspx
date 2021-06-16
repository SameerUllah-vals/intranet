<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Explorer.aspx.cs" Inherits="LeadManagementSystemV2.Views.Home.Explorer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form runat="server">
            <asp:UpdatePanel runat="server">                
                <ContentTemplate>
                    <asp:ScriptManager runat="server" ></asp:ScriptManager>
                      
                      <asp:TreeView ID="TreeView1" OnSelectedNodeChanged="TreeView1_SelectedNodeChanged" Height="400" EnableClientScript="false" ExpandDepth="0" runat="server" ImageSet="XPFileExplorer" NodeIndent="15">
                <HoverNodeStyle Font-Underline="True" ForeColor="#6666AA" />
                <NodeStyle Font-Names="Tahoma" Font-Size="14pt" ForeColor="Black" HorizontalPadding="2px"
                    NodeSpacing="0px" VerticalPadding="2px"></NodeStyle>
                <ParentNodeStyle Font-Bold="False" />
                <SelectedNodeStyle BackColor="#B5B5B5" Font-Underline="False" HorizontalPadding="0px"
                    VerticalPadding="0px" />
            </asp:TreeView>
    
                </ContentTemplate>
         
     </asp:UpdatePanel>
 </form>


</body>
</html>
