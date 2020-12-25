USE [dbProject]
GO
/****** Object:  Table [dbo].[Banners]    Script Date: 12/25/2020 12:53:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Banners](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NULL,
	[Image] [nvarchar](200) NULL,
	[Status] [nvarchar](20) NULL,
	[isDeleted] [bit] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedDateTime] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedBy] [int] NULL,
	[DeletedBy] [int] NULL,
	[isDefault] [bit] NULL,
 CONSTRAINT [PK_Banner] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Gallery]    Script Date: 12/25/2020 12:53:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gallery](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NULL,
	[Image] [nvarchar](200) NULL,
	[Description] [nvarchar](max) NULL,
	[Status] [nvarchar](20) NULL,
	[isDeleted] [bit] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedDateTime] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedBy] [int] NULL,
	[DeletedBy] [int] NULL,
	[isDefault] [bit] NULL,
 CONSTRAINT [PK_Gallery] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuPermissions]    Script Date: 12/25/2020 12:53:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuPermissions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MenuID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Type] [nvarchar](5) NOT NULL,
 CONSTRAINT [PK_MenuPermissions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Menus]    Script Date: 12/25/2020 12:53:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menus](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](25) NOT NULL,
	[ParentID] [int] NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Icon] [nvarchar](255) NULL,
	[AccessURL] [nvarchar](255) NOT NULL,
	[Status] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_Menus] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsLetters]    Script Date: 12/25/2020 12:53:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsLetters](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NULL,
	[Image] [nvarchar](200) NULL,
	[Link] [nvarchar](200) NULL,
	[Status] [nvarchar](20) NULL,
	[isDeleted] [bit] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedDateTime] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedBy] [int] NULL,
	[DeletedBy] [int] NULL,
	[isDefault] [bit] NULL,
 CONSTRAINT [PK_NewsLetter] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrgAnnouncement]    Script Date: 12/25/2020 12:53:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrgAnnouncement](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NULL,
	[Announcement] [nvarchar](200) NULL,
	[Status] [nvarchar](20) NULL,
	[isDeleted] [bit] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedDateTime] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedBy] [int] NULL,
	[DeletedBy] [int] NULL,
 CONSTRAINT [PK_OrgAnnouncement] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuestionDetail]    Script Date: 12/25/2020 12:53:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuestionDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionsId] [int] NULL,
	[IpAddress] [nvarchar](50) NULL,
	[CreatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_QuestionDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Questions]    Script Date: 12/25/2020 12:53:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NULL,
	[option1] [nvarchar](200) NULL,
	[option2] [nvarchar](200) NULL,
	[option3] [nvarchar](200) NULL,
	[option4] [nvarchar](200) NULL,
	[Status] [nvarchar](20) NULL,
	[isDeleted] [bit] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedDateTime] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[UpdatedBy] [int] NULL,
	[DeletedBy] [int] NULL,
	[isDefault] [bit] NULL,
 CONSTRAINT [PK_Question] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RolePermissions]    Script Date: 12/25/2020 12:53:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RolePermissions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[MenuID] [int] NOT NULL,
	[Permissions] [nvarchar](500) NOT NULL,
	[SequenceOrder] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedBy] [int] NULL,
 CONSTRAINT [PK_RolePermissions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 12/25/2020 12:53:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedDateTime] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedBy] [int] NULL,
	[DeletedBy] [int] NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Settings]    Script Date: 12/25/2020 12:53:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Settings](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[Content] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 12/25/2020 12:53:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[EmailAddress] [nvarchar](255) NOT NULL,
	[Password] [nvarchar](500) NOT NULL,
	[ProfileImage] [nvarchar](255) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[DeletedDateTime] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[UpdatedBy] [int] NULL,
	[DeletedBy] [int] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[MenuPermissions] ON 

INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (1, 2, 1, N'None', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (2, 2, 1, N'All', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (4, 2, 1, N'Add', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (5, 2, 1, N'Edit', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (6, 2, 1, N'Delete', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (7, 2, 1, N'View', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (8, 3, 1, N'None', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (9, 3, 1, N'All', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (10, 3, 1, N'Add', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (11, 3, 1, N'Edit', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (12, 3, 1, N'Delete', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (13, 3, 1, N'View', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (16, 5, 1, N'None', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (17, 5, 1, N'All', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (18, 5, 1, N'Add', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (19, 5, 1, N'Edit', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (20, 5, 1, N'Delete', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (21, 5, 1, N'View', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (22, 7, 1, N'None', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (23, 7, 1, N'All', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (24, 7, 1, N'Add', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (25, 7, 1, N'Edit', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (26, 7, 1, N'Delete', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (27, 7, 1, N'View', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (28, 8, 1, N'None', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (29, 8, 1, N'All', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (30, 8, 1, N'Add', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (31, 8, 1, N'Edit', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (32, 8, 1, N'Delete', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (33, 8, 1, N'View', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (34, 12, 1, N'All', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (35, 12, 1, N'Add', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (36, 12, 1, N'Edit', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (37, 12, 1, N'Delete', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (38, 12, 1, N'View', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (39, 12, 1, N'None', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (40, 14, 1, N'All', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (41, 14, 1, N'Add', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (42, 14, 1, N'Edit', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (43, 14, 1, N'Delete', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (44, 14, 1, N'View', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (45, 14, 1, N'None', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (46, 15, 1, N'All', N'R')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (47, 15, 1, N'Add', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (48, 15, 1, N'Edit', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (49, 15, 1, N'Delete', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (50, 15, 1, N'View', N'C')
INSERT [dbo].[MenuPermissions] ([ID], [MenuID], [RoleID], [Name], [Type]) VALUES (51, 15, 1, N'None', N'R')
SET IDENTITY_INSERT [dbo].[MenuPermissions] OFF
GO
SET IDENTITY_INSERT [dbo].[Menus] ON 

INSERT [dbo].[Menus] ([ID], [Type], [ParentID], [Name], [Icon], [AccessURL], [Status]) VALUES (1, N'Both', NULL, N'Home Page', N'fa fa-wrench', N'#', N'Enable')
INSERT [dbo].[Menus] ([ID], [Type], [ParentID], [Name], [Icon], [AccessURL], [Status]) VALUES (2, N'Both', 1, N'Banner', N'fa fa-image', N'banner', N'Enable')
INSERT [dbo].[Menus] ([ID], [Type], [ParentID], [Name], [Icon], [AccessURL], [Status]) VALUES (3, N'Both', 1, N'Announcement', N'fa fa-speaker', N'announcement', N'Enable')
INSERT [dbo].[Menus] ([ID], [Type], [ParentID], [Name], [Icon], [AccessURL], [Status]) VALUES (4, N'Both', NULL, N'Gallery', N'fa fa-image', N'#', N'Enable')
INSERT [dbo].[Menus] ([ID], [Type], [ParentID], [Name], [Icon], [AccessURL], [Status]) VALUES (5, N'Both', 4, N'List', N'fa fa-align-justify', N'gallery', N'Enable')
INSERT [dbo].[Menus] ([ID], [Type], [ParentID], [Name], [Icon], [AccessURL], [Status]) VALUES (6, N'Both', NULL, N'Servey', N'fa fa-users', N'#', N'Enable')
INSERT [dbo].[Menus] ([ID], [Type], [ParentID], [Name], [Icon], [AccessURL], [Status]) VALUES (7, N'Both', 6, N'List', N'fa fa-align-justify', N'questions', N'Enable')
INSERT [dbo].[Menus] ([ID], [Type], [ParentID], [Name], [Icon], [AccessURL], [Status]) VALUES (8, N'Both', 4, N'Inbox', N'fa fa-envelope-open', N'Inbox', N'Disable')
INSERT [dbo].[Menus] ([ID], [Type], [ParentID], [Name], [Icon], [AccessURL], [Status]) VALUES (11, N'Both', NULL, N'Admin', N'fa fa-user', N'#', N'Disable')
INSERT [dbo].[Menus] ([ID], [Type], [ParentID], [Name], [Icon], [AccessURL], [Status]) VALUES (12, N'Both', 1, N'News Letter', N'fa fa-news', N'newsletter', N'Enable')
INSERT [dbo].[Menus] ([ID], [Type], [ParentID], [Name], [Icon], [AccessURL], [Status]) VALUES (14, N'Both', 1, N'Issues', N'fa fa-align-justify', N'resource', N'Disable')
INSERT [dbo].[Menus] ([ID], [Type], [ParentID], [Name], [Icon], [AccessURL], [Status]) VALUES (15, N'Both', 1, N'Persons', N'fa fa-users', N'departmentperson', N'Disable')
SET IDENTITY_INSERT [dbo].[Menus] OFF
GO
SET IDENTITY_INSERT [dbo].[RolePermissions] ON 

INSERT [dbo].[RolePermissions] ([ID], [RoleID], [MenuID], [Permissions], [SequenceOrder], [CreatedDateTime], [UpdatedDateTime], [CreatedBy], [UpdatedBy]) VALUES (1, 1, 2, N'All', 0, CAST(N'2020-05-23T00:00:00.000' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[RolePermissions] ([ID], [RoleID], [MenuID], [Permissions], [SequenceOrder], [CreatedDateTime], [UpdatedDateTime], [CreatedBy], [UpdatedBy]) VALUES (2, 1, 3, N'All', 1, CAST(N'2020-05-23T00:00:00.000' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[RolePermissions] ([ID], [RoleID], [MenuID], [Permissions], [SequenceOrder], [CreatedDateTime], [UpdatedDateTime], [CreatedBy], [UpdatedBy]) VALUES (3, 1, 5, N'All', 0, CAST(N'2020-05-23T00:00:00.000' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[RolePermissions] ([ID], [RoleID], [MenuID], [Permissions], [SequenceOrder], [CreatedDateTime], [UpdatedDateTime], [CreatedBy], [UpdatedBy]) VALUES (4, 1, 7, N'All', 0, CAST(N'2020-05-30T00:00:00.000' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[RolePermissions] ([ID], [RoleID], [MenuID], [Permissions], [SequenceOrder], [CreatedDateTime], [UpdatedDateTime], [CreatedBy], [UpdatedBy]) VALUES (5, 3, 5, N'All', 0, CAST(N'2020-05-30T16:13:18.393' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[RolePermissions] ([ID], [RoleID], [MenuID], [Permissions], [SequenceOrder], [CreatedDateTime], [UpdatedDateTime], [CreatedBy], [UpdatedBy]) VALUES (7, 4, 5, N'All', 0, CAST(N'2020-05-30T16:13:28.033' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[RolePermissions] ([ID], [RoleID], [MenuID], [Permissions], [SequenceOrder], [CreatedDateTime], [UpdatedDateTime], [CreatedBy], [UpdatedBy]) VALUES (9, 1, 8, N'All', 2, CAST(N'2020-04-06T00:00:00.000' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[RolePermissions] ([ID], [RoleID], [MenuID], [Permissions], [SequenceOrder], [CreatedDateTime], [UpdatedDateTime], [CreatedBy], [UpdatedBy]) VALUES (10, 3, 8, N'All', 1, CAST(N'2020-06-04T17:57:18.857' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[RolePermissions] ([ID], [RoleID], [MenuID], [Permissions], [SequenceOrder], [CreatedDateTime], [UpdatedDateTime], [CreatedBy], [UpdatedBy]) VALUES (11, 4, 8, N'All', 1, CAST(N'2020-06-04T18:06:15.713' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[RolePermissions] ([ID], [RoleID], [MenuID], [Permissions], [SequenceOrder], [CreatedDateTime], [UpdatedDateTime], [CreatedBy], [UpdatedBy]) VALUES (15, 1, 12, N'All', 1, CAST(N'2020-10-07T00:00:00.000' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[RolePermissions] ([ID], [RoleID], [MenuID], [Permissions], [SequenceOrder], [CreatedDateTime], [UpdatedDateTime], [CreatedBy], [UpdatedBy]) VALUES (16, 1, 14, N'All', 1, CAST(N'2020-10-07T00:00:00.000' AS DateTime), NULL, 1, NULL)
INSERT [dbo].[RolePermissions] ([ID], [RoleID], [MenuID], [Permissions], [SequenceOrder], [CreatedDateTime], [UpdatedDateTime], [CreatedBy], [UpdatedBy]) VALUES (17, 1, 15, N'All', 2, CAST(N'2020-10-08T00:00:00.000' AS DateTime), NULL, 1, NULL)
SET IDENTITY_INSERT [dbo].[RolePermissions] OFF
GO
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([ID], [Name], [Status], [IsDeleted], [CreatedDateTime], [UpdatedDateTime], [DeletedDateTime], [CreatedBy], [UpdatedBy], [DeletedBy]) VALUES (1, N'Super Admin', N'Enable', 0, CAST(N'2020-05-23T00:00:00.000' AS DateTime), NULL, NULL, 1, NULL, NULL)
INSERT [dbo].[Roles] ([ID], [Name], [Status], [IsDeleted], [CreatedDateTime], [UpdatedDateTime], [DeletedDateTime], [CreatedBy], [UpdatedBy], [DeletedBy]) VALUES (3, N'Administrator', N'Enable', 0, CAST(N'2020-05-23T00:00:00.000' AS DateTime), CAST(N'2020-06-10T11:28:47.397' AS DateTime), NULL, 1, 1, NULL)
INSERT [dbo].[Roles] ([ID], [Name], [Status], [IsDeleted], [CreatedDateTime], [UpdatedDateTime], [DeletedDateTime], [CreatedBy], [UpdatedBy], [DeletedBy]) VALUES (4, N'Employee', N'Enable', 0, CAST(N'2020-05-23T00:00:00.000' AS DateTime), CAST(N'2020-06-10T11:28:39.253' AS DateTime), NULL, 1, 1, NULL)
SET IDENTITY_INSERT [dbo].[Roles] OFF
GO
SET IDENTITY_INSERT [dbo].[Settings] ON 

INSERT [dbo].[Settings] ([ID], [Name], [Content]) VALUES (1, N'Website Name', N'Lead Management System')
INSERT [dbo].[Settings] ([ID], [Name], [Content]) VALUES (2, N'Website URL', N'http://localhost:63458/')
INSERT [dbo].[Settings] ([ID], [Name], [Content]) VALUES (3, N'Website Status', N'Online')
SET IDENTITY_INSERT [dbo].[Settings] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([ID], [RoleID], [Name], [EmailAddress], [Password], [ProfileImage], [Status], [IsDeleted], [CreatedDateTime], [UpdatedDateTime], [DeletedDateTime], [CreatedBy], [UpdatedBy], [DeletedBy]) VALUES (1, 1, N'Super Admin', N'Admin@fulcrumpk.com', N'vRn+sr55cuJc/Diu94UHPg==', NULL, N'Enable', 0, CAST(N'2020-05-23T00:00:00.000' AS DateTime), NULL, NULL, 1, NULL, NULL)
INSERT [dbo].[Users] ([ID], [RoleID], [Name], [EmailAddress], [Password], [ProfileImage], [Status], [IsDeleted], [CreatedDateTime], [UpdatedDateTime], [DeletedDateTime], [CreatedBy], [UpdatedBy], [DeletedBy]) VALUES (2, 4, N'Kiran', N'Kiran@fulcrumpk.com', N'M0Zg6KNhZSQ=', NULL, N'Enable', 1, CAST(N'2020-05-28T15:51:15.940' AS DateTime), NULL, CAST(N'2020-10-09T15:35:22.923' AS DateTime), 1, NULL, NULL)
INSERT [dbo].[Users] ([ID], [RoleID], [Name], [EmailAddress], [Password], [ProfileImage], [Status], [IsDeleted], [CreatedDateTime], [UpdatedDateTime], [DeletedDateTime], [CreatedBy], [UpdatedBy], [DeletedBy]) VALUES (3, 4, N'muhammad Waqas', N'mwaqas@fulcrum-pk.com', N'vRn+sr55cuJc/Diu94UHPg==', NULL, N'Enable', 1, CAST(N'2020-06-02T18:48:45.283' AS DateTime), NULL, CAST(N'2020-10-09T15:35:10.033' AS DateTime), 1, NULL, NULL)
INSERT [dbo].[Users] ([ID], [RoleID], [Name], [EmailAddress], [Password], [ProfileImage], [Status], [IsDeleted], [CreatedDateTime], [UpdatedDateTime], [DeletedDateTime], [CreatedBy], [UpdatedBy], [DeletedBy]) VALUES (4, 4, N'shikha Chawla ', N'shikha@fulcrum-pk.com', N'vRn+sr55cuJc/Diu94UHPg==', NULL, N'Enable', 1, CAST(N'2020-06-02T18:49:39.117' AS DateTime), NULL, CAST(N'2020-10-09T15:35:04.153' AS DateTime), 1, NULL, NULL)
INSERT [dbo].[Users] ([ID], [RoleID], [Name], [EmailAddress], [Password], [ProfileImage], [Status], [IsDeleted], [CreatedDateTime], [UpdatedDateTime], [DeletedDateTime], [CreatedBy], [UpdatedBy], [DeletedBy]) VALUES (5, 1, N'Shanee Hanif', N'Shanee.hanif@gmail.com', N'vRn+sr55cuJc/Diu94UHPg==', NULL, N'Enable', 1, CAST(N'2020-07-09T00:00:00.000' AS DateTime), NULL, CAST(N'2020-10-09T15:34:58.907' AS DateTime), 1, NULL, NULL)
INSERT [dbo].[Users] ([ID], [RoleID], [Name], [EmailAddress], [Password], [ProfileImage], [Status], [IsDeleted], [CreatedDateTime], [UpdatedDateTime], [DeletedDateTime], [CreatedBy], [UpdatedBy], [DeletedBy]) VALUES (6, 4, N'sameer', N'sameer@gmail.com', N'cVNABq3+R48=', NULL, N'Enable', 1, CAST(N'2020-10-07T17:19:39.367' AS DateTime), NULL, CAST(N'2020-10-07T17:19:48.557' AS DateTime), 1, NULL, NULL)
INSERT [dbo].[Users] ([ID], [RoleID], [Name], [EmailAddress], [Password], [ProfileImage], [Status], [IsDeleted], [CreatedDateTime], [UpdatedDateTime], [DeletedDateTime], [CreatedBy], [UpdatedBy], [DeletedBy]) VALUES (7, 4, N'Sameer Ullah', N'vals.sameer@gmail.com', N'vRn+sr55cuJc/Diu94UHPg==', NULL, N'Enable', 1, CAST(N'2020-10-08T15:34:37.373' AS DateTime), NULL, CAST(N'2020-10-09T15:35:14.197' AS DateTime), 1, NULL, NULL)
INSERT [dbo].[Users] ([ID], [RoleID], [Name], [EmailAddress], [Password], [ProfileImage], [Status], [IsDeleted], [CreatedDateTime], [UpdatedDateTime], [DeletedDateTime], [CreatedBy], [UpdatedBy], [DeletedBy]) VALUES (8, 3, N'Amir', N'anonymous76760@gmail.com', N'vRn+sr55cuJc/Diu94UHPg==', NULL, N'Enable', 0, CAST(N'2020-10-09T12:29:10.687' AS DateTime), CAST(N'2020-10-09T18:39:59.170' AS DateTime), NULL, 1, 1, NULL)
INSERT [dbo].[Users] ([ID], [RoleID], [Name], [EmailAddress], [Password], [ProfileImage], [Status], [IsDeleted], [CreatedDateTime], [UpdatedDateTime], [DeletedDateTime], [CreatedBy], [UpdatedBy], [DeletedBy]) VALUES (9, 4, N'Sameer Ullah', N'vals.sameer@gmail.com', N'vRn+sr55cuJc/Diu94UHPg==', NULL, N'Enable', 0, CAST(N'2020-10-09T15:50:14.060' AS DateTime), NULL, NULL, 1, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[MenuPermissions]  WITH CHECK ADD  CONSTRAINT [FK_MenuPermissions_Menus] FOREIGN KEY([MenuID])
REFERENCES [dbo].[Menus] ([ID])
GO
ALTER TABLE [dbo].[MenuPermissions] CHECK CONSTRAINT [FK_MenuPermissions_Menus]
GO
ALTER TABLE [dbo].[MenuPermissions]  WITH CHECK ADD  CONSTRAINT [FK_MenuPermissions_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([ID])
GO
ALTER TABLE [dbo].[MenuPermissions] CHECK CONSTRAINT [FK_MenuPermissions_Roles]
GO
ALTER TABLE [dbo].[Menus]  WITH CHECK ADD  CONSTRAINT [FK_Menus_Menus] FOREIGN KEY([ParentID])
REFERENCES [dbo].[Menus] ([ID])
GO
ALTER TABLE [dbo].[Menus] CHECK CONSTRAINT [FK_Menus_Menus]
GO
ALTER TABLE [dbo].[QuestionDetail]  WITH CHECK ADD  CONSTRAINT [FK_QuestionDetail_Question] FOREIGN KEY([QuestionsId])
REFERENCES [dbo].[Questions] ([ID])
GO
ALTER TABLE [dbo].[QuestionDetail] CHECK CONSTRAINT [FK_QuestionDetail_Question]
GO
ALTER TABLE [dbo].[RolePermissions]  WITH CHECK ADD  CONSTRAINT [FK_RolePermissions_Menus] FOREIGN KEY([MenuID])
REFERENCES [dbo].[Menus] ([ID])
GO
ALTER TABLE [dbo].[RolePermissions] CHECK CONSTRAINT [FK_RolePermissions_Menus]
GO
ALTER TABLE [dbo].[RolePermissions]  WITH CHECK ADD  CONSTRAINT [FK_RolePermissions_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([ID])
GO
ALTER TABLE [dbo].[RolePermissions] CHECK CONSTRAINT [FK_RolePermissions_Roles]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([ID])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Roles]
GO
