USE [BiltySystemTesting]
GO
/****** Object:  User [NBG]    Script Date: 5/10/2021 1:50:43 PM ******/
CREATE USER [NBG] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [NBG]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [NBG]
GO
/****** Object:  UserDefinedFunction [dbo].[BillNo]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[BillNo](
@CustomerCode varchar(max),
@CompanyId bigint
) 
returns char(16) 
as 
begin 
	declare @lastval bigint 
	set @lastval = (select count(*) from Invoices 
	where CompanyId=@CompanyId ) 
	if @lastval =0 set @lastval = 0
	declare @i bigint 
	IF @lastval=0
	BEGIN 
	--SET @lastval='000000'
	set @i = CAST(@lastval AS bigint)+1 
	END
	ELSE 
	BEGIN
	set @i =CAST(@lastval AS bigint)+1 
	END
	
	return @CustomerCode+'-'+ CAST(@i AS nvarchar)
end





GO
/****** Object:  UserDefinedFunction [dbo].[ChallanGenerator]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE function [dbo].[ChallanGenerator](
@CustomerCode varchar(max)
) 
returns char(16) 
as 
begin 
	declare @lastval bigint 
	set @lastval = (select count(*) from DriverChallan) 
	--where CustomerCode=@CustomerCode and   ParentId=0 and biltyno is not null ) 
	if @lastval =0 set @lastval = 0
	declare @i bigint 
	IF @lastval=0
	BEGIN 
	set @i = CAST(@lastval AS bigint)+1 
	END
	ELSE 
	BEGIN
	set @i =CAST(@lastval AS bigint)+1  
	END	
	return  @i 
end






GO
/****** Object:  UserDefinedFunction [dbo].[GetNextProductCode]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[GetNextProductCode](
) 
returns char(16) 
as 
begin 
	declare @lastval bigint 
	set @lastval = (select top 1 Code from Product where code is not null  order by 1 desc ) 
	if @lastval =0  OR @lastval is null set @lastval = 0
	declare @i int 
	IF @lastval=0 
	BEGIN 
	--SET @lastval='000000'
	set @i = right('000000'+convert(varchar(6),@lastval),6) + 1
	END
	ELSE 
	BEGIN
	set @i =right(@lastval,6) + 1 
	END
	
	return  right('000000' + convert(varchar(6),@i),6) 
end
GO
/****** Object:  UserDefinedFunction [dbo].[GetNextVehicleTypeCode]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create function [dbo].[GetNextVehicleTypeCode](
) 
returns char(16) 
as 
begin 
	declare @lastval bigint 
	set @lastval = (select top 1 VehicleTypeCode from VehicleType where VehicleTypeCode is not null  order by 1 desc ) 
	if @lastval =0  OR @lastval is null set @lastval = 0
	declare @i int 
	IF @lastval=0 
	BEGIN 
	--SET @lastval='000000'
	set @i = right('00'+convert(varchar(6),@lastval),6) + 1
	END
	ELSE 
	BEGIN
	set @i =right(@lastval,6) + 1 
	END
	
	return  right('00' + convert(varchar(6),@i),6) 
end

GO
/****** Object:  UserDefinedFunction [dbo].[ManualBiltyGenerator]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[ManualBiltyGenerator](
@CustomerCode varchar(max)
) 
returns char(16) 
as 
begin 
	declare @lastval bigint 
	set @lastval = (select count(*) from OrderDetail 
	where CustomerCode=@CustomerCode and   ParentId in (0,1) and biltyno is not null ) 
	if @lastval =0 set @lastval = 0
	declare @i bigint 
	IF @lastval=0
	BEGIN 
	--SET @lastval='000000'
	set @i = CAST(@lastval AS bigint)+1 
	END
	ELSE 
	BEGIN
	set @i =CAST(@lastval AS bigint)+1 
	END
	
	return @CustomerCode+'-'+ CAST(@i AS nvarchar)
end




GO
/****** Object:  UserDefinedFunction [dbo].[NextBiltyNumberByCompany]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[NextBiltyNumberByCompany](
@CompanyCode varchar(max)
) 
returns char(16) 
as 
begin 
	declare @lastval bigint 
	set @lastval = (select count(*) from InquiryAndOrders where CustomerCompanyCode=@CompanyCode and IsInquiryToOrder=1 and biltyno is not null ) 
	if @lastval =0 set @lastval = 0
	declare @i varchar 
	IF @lastval=0
	BEGIN 
	--SET @lastval='000000'
	set @i = @lastval + 1
	END
	ELSE 
	BEGIN
	set @i =@lastval + 1 
	END
	
	return @CompanyCode+'-' + @i+'' 
end



GO
/****** Object:  UserDefinedFunction [dbo].[PartManualBiltyGenerator]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[PartManualBiltyGenerator](
@CustomerCode varchar(max),
@ParentId	bigint,
@BiltyNo varchar(11)
) 
returns char(16) 
as 
begin 
	declare @lastval bigint 
	set @lastval = (select count(*) from OrderDetail 
	where CustomerCode=@CustomerCode and  ParentId not in (0,1) and BiltyNo like '%'+@BiltyNo+'%'  ) 
	if @lastval =0 set @lastval = 0
	declare @i varchar 
	IF @lastval=0
	BEGIN 
	--SET @lastval='000000'
	set @i = CHAR(65)
	END
	ELSE 
	BEGIN
	set @i =CHAR(@lastval+65)
	END
	
	return @BiltyNo+'_' + @i 
end




GO
/****** Object:  UserDefinedFunction [dbo].[rpad]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[rpad](@text nvarchar(MAX), @length int, @padChar char)
returns nvarchar(MAX) as 
BEGIN
  return @text + REPLICATE(@padChar, CASE WHEN @length - LEN(@text) > 0 THEN @length - LEN(@text) ELSE 0 END)
end






GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitString]
(    
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Output TABLE (
      Item NVARCHAR(1000)
)
AS
BEGIN
      DECLARE @StartIndex INT, @EndIndex INT
 
      SET @StartIndex = 1
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
      BEGIN
            SET @Input = @Input + @Character
      END
 
      WHILE CHARINDEX(@Character, @Input) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Input)
           
            INSERT INTO @Output(Item)
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
           
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END
 
      RETURN
END



GO
/****** Object:  UserDefinedFunction [dbo].[TRIM]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Function [dbo].[TRIM](@val NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
BEGIN
    RETURN LTRIM(RTRIM(@val))
END



GO
/****** Object:  UserDefinedFunction [dbo].[udf_GetNumeric]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_GetNumeric]
(@strAlphaNumeric VARCHAR(256))
RETURNS VARCHAR(256)
AS
BEGIN
DECLARE @intAlpha INT
SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric)
BEGIN
WHILE @intAlpha > 0
BEGIN
SET @strAlphaNumeric = STUFF(@strAlphaNumeric, @intAlpha, 1, '' )
SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric )
END
END
RETURN ISNULL(@strAlphaNumeric,0)
END



GO
/****** Object:  Table [dbo].[AccessPages]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccessPages](
	[AccessPagesID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [bigint] NULL,
	[NavMenuID] [bigint] NULL,
	[Roles] [nvarchar](50) NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[Modifieddate] [datetime] NULL,
 CONSTRAINT [PK_AccessPages] PRIMARY KEY CLUSTERED 
(
	[AccessPagesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AdvancePlaces]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AdvancePlaces](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[ContactNo] [bigint] NULL,
	[Address] [nvarchar](max) NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_AdvancePlaces] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Area]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Area](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[AreaCode] [varchar](50) NULL,
	[CityID] [bigint] NULL,
	[AreaName] [varchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUserID] [bigint] NULL,
	[Description] [varchar](50) NULL,
	[Status] [bit] NULL,
	[Province] [nvarchar](50) NULL,
	[Region] [bigint] NULL,
 CONSTRAINT [PK_Area] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Banks]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Banks](
	[BankID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[AccountNo] [nvarchar](50) NULL,
	[AccountTitle] [nvarchar](50) NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[isActive] [bit] NULL,
	[isDelete] [bit] NULL,
 CONSTRAINT [PK_Banks] PRIMARY KEY CLUSTERED 
(
	[BankID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bill]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bill](
	[BillID] [bigint] IDENTITY(1,1) NOT NULL,
	[BillNo] [nvarchar](50) NULL,
	[CustomerBillNo] [nvarchar](50) NULL,
	[CustomerCompany] [nvarchar](50) NULL,
	[OrderConsignmentID] [bigint] NULL,
	[Total] [float] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[isPayed] [bit] NULL,
	[DocumentNo] [nvarchar](50) NULL,
	[TransferedTo] [nvarchar](50) NULL,
	[PaymentDate] [nvarchar](50) NULL,
	[PaymentMode] [nvarchar](50) NULL,
	[TotalBalance] [float] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Bill] PRIMARY KEY CLUSTERED 
(
	[BillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BillingType]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillingType](
	[BillingTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[BillingTypeName] [nvarchar](50) NULL,
 CONSTRAINT [PK_BillingType] PRIMARY KEY CLUSTERED 
(
	[BillingTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Brokers]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Brokers](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Phone] [bigint] NULL,
	[Phone2] [bigint] NULL,
	[HomeNo] [bigint] NULL,
	[Address] [nvarchar](100) NULL,
	[NIC] [bigint] NULL,
	[Description] [nvarchar](250) NULL,
	[isActive] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Brokers] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Description] [nvarchar](200) NULL,
	[Status] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[City]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[City](
	[CityID] [bigint] IDENTITY(1,1) NOT NULL,
	[CityCode] [varchar](50) NULL,
	[CityName] [varchar](50) NULL,
	[ProvinceID] [bigint] NULL,
	[Description] [varchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUserID] [bigint] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED 
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClearingAgent]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClearingAgent](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[ContactPersonName] [nvarchar](50) NULL,
	[ContactPersonNo] [bigint] NULL,
	[ContactPersonSecNo] [bigint] NULL,
	[ContactNo] [bigint] NULL,
	[SecContactNo] [bigint] NULL,
	[Address] [nvarchar](200) NULL,
	[Email] [nvarchar](50) NULL,
	[Website] [nvarchar](50) NULL,
	[isActive] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_ClearingAgent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Company]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[CompanyID] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyCode] [nvarchar](15) NULL,
	[CompanyName] [nvarchar](100) NULL,
	[CompanyEmail] [nvarchar](50) NULL,
	[CompanyWebSite] [nvarchar](50) NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[Active] [bit] NULL,
	[CreatedDate] [date] NULL,
	[ModifiedDate] [date] NULL,
	[Contact] [varchar](50) NULL,
	[OtherContact] [nvarchar](50) NULL,
	[Description] [nvarchar](255) NULL,
	[GroupID] [bigint] NOT NULL,
	[Address] [nvarchar](200) NULL,
	[NTN] [nvarchar](50) NULL,
	[STN] [nvarchar](50) NULL,
	[Tax] [float] NULL,
	[CustomerType] [nvarchar](50) NULL,
 CONSTRAINT [PK_Company_1] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyAccounts]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyAccounts](
	[AccountID] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyID] [bigint] NULL,
	[Debit] [float] NULL,
	[Credit] [float] NULL,
	[Balance] [float] NULL,
	[CreatedByID] [bigint] NULL,
	[DateCreated] [datetime] NULL,
	[ModifiedById] [bigint] NULL,
	[DateModified] [datetime] NULL,
 CONSTRAINT [PK_CompanyAccounts] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyProfile]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyProfile](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[GroupID] [bigint] NULL,
	[CompanyID] [bigint] NULL,
	[PersonID] [bigint] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK_CompanyProfile_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyProfileAuthorizedPersons]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyProfileAuthorizedPersons](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyProfileID] [bigint] NULL,
	[Name] [nvarchar](50) NULL,
	[Father] [nvarchar](50) NULL,
	[Designation] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[ContactNo] [bigint] NULL,
	[DepartmentID] [bigint] NULL,
 CONSTRAINT [PK_CompanyProfileAuthorizedPersons] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyProfileDetail]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyProfileDetail](
	[ProfileDetailID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProfileId] [nvarchar](50) NULL,
	[ProductCode] [nvarchar](50) NULL,
	[ProductId] [bigint] NULL,
	[LocationFrom] [bigint] NULL,
	[LocationTo] [bigint] NULL,
	[RateType] [nvarchar](50) NULL,
	[DoorStepRate] [bigint] NULL,
	[Total] [float] NULL,
	[Active] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
 CONSTRAINT [PK_CompanyProfileDetail] PRIMARY KEY CLUSTERED 
(
	[ProfileDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyProfileFreight]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyProfileFreight](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyProfileID] [bigint] NULL,
	[PickLocationID] [bigint] NULL,
	[DropLocationID] [bigint] NULL,
	[VehicleTypeID] [bigint] NULL,
	[CalculationMethod] [nvarchar](50) NULL,
	[TotalFreight] [bigint] NULL,
	[Distance] [bigint] NULL,
 CONSTRAINT [PK_CompanyProfileFreight] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyProfileLocations]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyProfileLocations](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyProfileID] [bigint] NULL,
	[LocationID] [bigint] NULL,
	[Type] [nvarchar](50) NULL,
 CONSTRAINT [PK_CompanyProfileLocations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Container]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Container](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ContainerNo] [nvarchar](50) NULL,
	[Code] [nvarchar](50) NULL,
	[Type] [bigint] NULL,
	[ShippingCompany] [nvarchar](50) NULL,
	[Owner] [nvarchar](50) NULL,
	[OwnerContact] [bigint] NULL,
	[Description] [text] NULL,
	[isActive] [bit] NULL,
	[OwnershipType] [nvarchar](50) NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Container] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContainerDropOption]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContainerDropOption](
	[ContainerDropId] [int] IDENTITY(1,1) NOT NULL,
	[DropOption] [nvarchar](50) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_ContainerDropOption] PRIMARY KEY CLUSTERED 
(
	[ContainerDropId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContainerExpenses]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContainerExpenses](
	[ContainerExpenseID] [bigint] IDENTITY(1,1) NOT NULL,
	[ContainerID] [bigint] NULL,
	[ExpenseTypeID] [bigint] NULL,
	[Amount] [float] NULL,
	[CreatedByID] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedByID] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[PaidByDriver] [bit] NULL,
 CONSTRAINT [PK__Containe__4E41F8894482513B] PRIMARY KEY CLUSTERED 
(
	[ContainerExpenseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Containerized]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Containerized](
	[ContainerizedId] [bigint] IDENTITY(1,1) NOT NULL,
	[ShipmentTypeID] [bigint] NULL,
	[ShipmentType] [nvarchar](50) NULL,
	[Order_ID] [bigint] NULL,
	[PackageTypeID] [int] NULL,
	[Quantity] [int] NULL,
	[TotalWeight] [float] NULL,
	[Length] [float] NULL,
	[Width] [float] NULL,
	[Height] [float] NULL,
	[LoadQuantityWise] [float] NULL,
	[LoadWeightWise] [float] NULL,
	[PickLocationId] [bigint] NULL,
	[PickAddress] [nvarchar](50) NULL,
	[DropLoctionId] [bigint] NULL,
	[DropAddress] [nvarchar](50) NULL,
	[Dispatch_date] [datetime] NULL,
	[BillType] [nvarchar](50) NULL,
	[VehicleId] [bigint] NULL,
	[VehicleTypeId] [bigint] NULL,
	[VehicleTypeQuantity] [int] NULL,
	[ContainerTypeId] [bigint] NULL,
	[ContainerName] [nvarchar](50) NULL,
	[ContainerTypeQuantity] [int] NULL,
	[Loading] [nvarchar](50) NULL,
	[LoadingType] [nvarchar](50) NULL,
	[LoadingQuantity] [int] NULL,
	[LoadingCapacity] [nvarchar](50) NULL,
	[OtherEquipmentType] [nvarchar](50) NULL,
	[OtherEquipmentQuantity] [int] NULL,
	[OtherEquipmentCapacity] [nvarchar](50) NULL,
	[DriverID] [bigint] NULL,
	[BrokerID] [bigint] NULL,
	[VehicleDispatchDate] [datetime] NULL,
	[VehicleOutFormLoading] [datetime] NULL,
	[Status] [nvarchar](50) NULL,
 CONSTRAINT [PK_Containerized] PRIMARY KEY CLUSTERED 
(
	[ContainerizedId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContainerToVehicle]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContainerToVehicle](
	[ContainerToVehicleid] [int] IDENTITY(1,1) NOT NULL,
	[ContainerToVehicle] [nvarchar](50) NULL,
 CONSTRAINT [PK_ContainerToVehicle] PRIMARY KEY CLUSTERED 
(
	[ContainerToVehicleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContainerType]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContainerType](
	[ContainerTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[ContainerType] [varchar](50) NULL,
	[Code] [nvarchar](50) NULL,
	[DimensionUnitType] [varchar](10) NULL,
	[LowerDeckInnerLength] [float] NULL,
	[LowerDeckInnerWidth] [float] NULL,
	[LowerDeckInnerHeight] [float] NULL,
	[UpperDeckInnerLength] [float] NULL,
	[UpperDeckInnerWidth] [float] NULL,
	[UpperDeckInnerHeight] [float] NULL,
	[LowerDeckOuterLength] [float] NULL,
	[LowerDeckOuterWidth] [float] NULL,
	[LowerDeckOuterHeight] [float] NULL,
	[UpperDeckOuterLength] [float] NULL,
	[UpperDeckOuterWidth] [float] NULL,
	[UpperDeckOuterHeight] [float] NULL,
	[UpperPortionInnerLength] [float] NULL,
	[UpperPortionInnerwidth] [float] NULL,
	[UpperPortionInnerHeight] [float] NULL,
	[LowerPortionInnerLength] [float] NULL,
	[LowerPortionInnerWidth] [float] NULL,
	[LowerPortionInnerHeight] [float] NULL,
	[Description] [varchar](max) NULL,
	[TareWeight] [float] NULL,
	[TareWeightUnit] [float] NULL,
	[CubicCapacity] [float] NULL,
	[CubicCapacityUnit] [varchar](20) NULL,
	[PayLoadWeight] [float] NULL,
	[PayLoadWeightUnit] [varchar](20) NULL,
	[IsActive] [bit] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUserID] [bigint] NULL,
 CONSTRAINT [PK_ContainerType] PRIMARY KEY CLUSTERED 
(
	[ContainerTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContractorVehicle]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractorVehicle](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ContractorID] [bigint] NULL,
	[VehicleType] [nvarchar](50) NULL,
	[LabourCharges] [float] NULL,
	[Comission] [float] NULL,
 CONSTRAINT [PK_ContractorVehicle] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Country]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryName] [varchar](50) NULL,
	[CountryDialCode] [varchar](50) NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerName] [varchar](50) NULL,
	[CustomerCode] [varchar](50) NULL,
	[CustomerAdd] [varchar](50) NULL,
	[Description] [varchar](50) NULL,
	[CustomerContact1] [varchar](50) NULL,
	[CustomerContact2] [varchar](50) NULL,
	[CustomerEmail] [varchar](50) NULL,
	[WebAdd] [varchar](50) NULL,
	[Customerlogo] [image] NULL,
	[GroupID] [bigint] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [varchar](50) NULL,
	[ModifiedByUserID] [varchar](50) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Customer_1] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerProfile]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerProfile](
	[ProfileId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerName] [nvarchar](50) NULL,
	[CustomerCode] [nvarchar](50) NULL,
	[CustomerId] [bigint] NULL,
	[OwnCompanyId] [bigint] NULL,
	[PaymentTerm] [nvarchar](50) NULL,
	[CreditTerm] [nvarchar](50) NULL,
	[InvoiceFormat] [nvarchar](250) NULL,
	[CreatedDate] [date] NULL,
	[ModifiedDate] [date] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[isHide] [bit] NULL,
	[IsAdditionalCharges] [bit] NULL,
	[IsLaborCharges] [bit] NULL,
 CONSTRAINT [PK_CustomerProfile_1] PRIMARY KEY CLUSTERED 
(
	[ProfileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerProfileDetail]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerProfileDetail](
	[ProfileDetail] [bigint] IDENTITY(1,1) NOT NULL,
	[ProfileId] [bigint] NULL,
	[ProductCode] [nvarchar](50) NULL,
	[ProductId] [bigint] NULL,
	[LocationFrom] [bigint] NULL,
	[LocationTo] [bigint] NULL,
	[RateType] [nvarchar](50) NULL,
	[DoorStepRate] [bigint] NULL,
	[Total] [float] NULL,
	[Active] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[Rate] [float] NULL,
	[WeightPerUnit] [float] NULL,
	[AdditionCharges] [float] NULL,
	[LabourCharges] [float] NULL,
 CONSTRAINT [PK_CustomerProfileDetail_1] PRIMARY KEY CLUSTERED 
(
	[ProfileDetail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerProfileDetail_Audit]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerProfileDetail_Audit](
	[ProfileDetail_AuditID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProfileDetail] [bigint] NULL,
	[ProfileId] [bigint] NULL,
	[ProductCode] [nvarchar](50) NULL,
	[ProductId] [bigint] NULL,
	[LocationFrom] [bigint] NULL,
	[LocationTo] [bigint] NULL,
	[RateType] [nvarchar](50) NULL,
	[DoorStepRate] [bigint] NULL,
	[Total] [float] NULL,
	[Active] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[Rate] [float] NULL,
	[WeightPerUnit] [float] NULL,
	[AdditionCharges] [float] NULL,
	[LabourCharges] [float] NULL,
	[AuditDataState] [varchar](10) NULL,
	[AuditDMLAction] [varchar](10) NULL,
	[AuditUser] [sysname] NULL,
	[AuditDateTime] [datetime] NULL,
	[UpdateColumns] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DamageType]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DamageType](
	[DamageTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Description] [nvarchar](100) NULL,
	[isActive] [bit] NULL,
	[CreatedByID] [bigint] NULL,
	[ModifiedByID] [bigint] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
 CONSTRAINT [PK_DamageType] PRIMARY KEY CLUSTERED 
(
	[DamageTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepartID] [bigint] IDENTITY(1,1) NOT NULL,
	[DepartCode] [varchar](50) NULL,
	[DepartName] [varchar](50) NULL,
	[Contact] [varchar](50) NULL,
	[ContactOther] [varchar](50) NULL,
	[EmailAdd] [varchar](50) NULL,
	[WebAdd] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[CustomerID] [bigint] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUser] [bigint] NULL,
	[Description] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[GROUPID] [bigint] NOT NULL,
	[COMPANYID] [bigint] NOT NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[DepartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DepartmentPerson]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DepartmentPerson](
	[PersonalID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[BusinessEmail] [nvarchar](50) NULL,
	[GroupID] [bigint] NULL,
	[CompanyID] [bigint] NULL,
	[DepartmentID] [bigint] NULL,
	[Designation] [nvarchar](50) NULL,
	[Cell] [nvarchar](50) NULL,
	[PhoneNo] [nvarchar](50) NULL,
	[OtherContact] [nvarchar](50) NULL,
	[AddressOffice] [nvarchar](255) NULL,
	[AddressOther] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[IsIndividual] [bit] NULL,
	[Active] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_DepartmentPerson] PRIMARY KEY CLUSTERED 
(
	[PersonalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Designation]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Designation](
	[DesignationId] [int] IDENTITY(1,1) NOT NULL,
	[DesignationName] [nvarchar](150) NOT NULL,
	[Active] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
 CONSTRAINT [PK_Designation] PRIMARY KEY CLUSTERED 
(
	[DesignationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentType]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentType](
	[DocumentTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Description] [nvarchar](100) NULL,
	[isActive] [bit] NULL,
	[CreatedByID] [bigint] NULL,
	[ModifiedByID] [bigint] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
 CONSTRAINT [PK_DocumentType] PRIMARY KEY CLUSTERED 
(
	[DocumentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Driver]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Driver](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[FatherName] [nvarchar](50) NULL,
	[Type] [nvarchar](50) NULL,
	[DateOfBirth] [datetime] NULL,
	[Gender] [nvarchar](50) NULL,
	[BloodGroup] [nvarchar](50) NULL,
	[CellNo] [bigint] NULL,
	[OtherContact] [bigint] NULL,
	[HomeNo] [bigint] NULL,
	[Address] [nvarchar](200) NULL,
	[NIC] [bigint] NULL,
	[IdentityMark] [nvarchar](50) NULL,
	[NICIssueDate] [datetime] NULL,
	[NICExpiryDate] [datetime] NULL,
	[LicenseNo] [nvarchar](50) NULL,
	[LicenseCategory] [nvarchar](50) NULL,
	[LicenseIssueDate] [datetime] NULL,
	[LicenseExpiryDate] [datetime] NULL,
	[LicenseIssuingAuthority] [nvarchar](50) NULL,
	[LicenseStatus] [nvarchar](50) NULL,
	[EmergencyContactName] [nvarchar](50) NULL,
	[EmergencyContactNo] [bigint] NULL,
	[ContactRelation] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[Active] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Driver] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DriverChallan]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DriverChallan](
	[ChallanId] [bigint] IDENTITY(1,1) NOT NULL,
	[BiltyNos] [nvarchar](1000) NULL,
	[ChallanNo] [nvarchar](10) NULL,
	[ChallanDate] [datetime] NULL,
	[VehicleId] [bigint] NULL,
	[DriverId] [bigint] NULL,
	[Mobile] [nvarchar](50) NULL,
	[BrokerId] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[CreadtedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[ContractorId] [bigint] NULL,
	[DriverName] [nvarchar](50) NULL,
	[VehicleNo] [nvarchar](50) NULL,
 CONSTRAINT [PK_DriverChallan_1] PRIMARY KEY CLUSTERED 
(
	[ChallanId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DriverChallan_Audit]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DriverChallan_Audit](
	[ChallanId] [bigint] NULL,
	[BiltyNos] [nvarchar](1000) NULL,
	[ChallanNo] [nvarchar](10) NULL,
	[ChallanDate] [datetime] NULL,
	[VehicleId] [bigint] NULL,
	[DriverId] [bigint] NULL,
	[Mobile] [nvarchar](50) NULL,
	[BrokerId] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[CreadtedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[ContractorId] [bigint] NULL,
	[DriverName] [nvarchar](50) NULL,
	[VehicleNo] [nvarchar](50) NULL,
	[AuditDataState] [varchar](10) NULL,
	[AuditDMLAction] [varchar](10) NULL,
	[AuditUser] [sysname] NULL,
	[AuditDateTime] [datetime] NULL,
	[UpdateColumns] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DriverImage]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DriverImage](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[DriverID] [bigint] NULL,
	[Name] [nvarchar](50) NULL,
	[ContentType] [nvarchar](200) NULL,
	[Data] [varbinary](max) NULL,
 CONSTRAINT [PK_DriverImage] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExpensesType]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExpensesType](
	[ExpensesTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[ExpensesTypeName] [varchar](50) NULL,
	[ExpensesTypeCode] [varchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUserID] [bigint] NULL,
	[Remarks] [varchar](500) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_ExpensesType] PRIMARY KEY CLUSTERED 
(
	[ExpensesTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FreightType]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FreightType](
	[FreightTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[FreightTypeCode] [varchar](50) NULL,
	[FreightTypeName] [varchar](50) NULL,
	[Description] [varchar](500) NULL,
 CONSTRAINT [PK_FreightType] PRIMARY KEY CLUSTERED 
(
	[FreightTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Gener]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gener](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[Status] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Gener] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Groups]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Groups](
	[GroupID] [bigint] IDENTITY(1,1) NOT NULL,
	[GroupCode] [varchar](50) NULL,
	[GroupName] [varchar](50) NULL,
	[Contact] [varchar](50) NULL,
	[ContactOther] [varchar](50) NULL,
	[EmailAdd] [varchar](50) NULL,
	[WebAdd] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[Logo] [image] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUserID] [bigint] NULL,
	[Description] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[CompanyAccess] [varchar](50) NULL,
 CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InquiryAndOrders]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InquiryAndOrders](
	[Order_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[CompanyId] [int] NULL,
	[GroupID] [int] NULL,
	[DepartmentID] [int] NULL,
	[ExistingCustomer] [bit] NULL,
	[CustomerGroupId] [nchar](10) NULL,
	[CustomerGroupCode] [nvarchar](50) NULL,
	[CustomerGroup] [nvarchar](150) NULL,
	[CustomerCompanyId] [bigint] NULL,
	[CustomerCompany] [nvarchar](150) NULL,
	[CustomerCompanyCode] [nvarchar](50) NULL,
	[CustomerDepartmentId] [bigint] NULL,
	[CustomerDepartment] [nvarchar](150) NULL,
	[CustomerDepartmentCode] [nvarchar](50) NULL,
	[CustomerPersonId] [bigint] NULL,
	[CustomerPerson] [nvarchar](150) NULL,
	[CustomerPersonCode] [nvarchar](50) NULL,
	[CustomerContact] [nvarchar](50) NULL,
	[ExistingRefference] [bigint] NULL,
	[RefferenceGroupId] [bigint] NULL,
	[RefferenceGroupCode] [nvarchar](50) NULL,
	[RefferenceGroup] [nvarchar](50) NULL,
	[RefferenceCompanyId] [bigint] NULL,
	[RefferenceCompany] [nvarchar](50) NULL,
	[RefferenceCompanyCode] [nvarchar](50) NULL,
	[RefferenceDepartmentId] [bigint] NULL,
	[RefferenceDepartment] [nvarchar](50) NULL,
	[RefferenceDepartmentCode] [nvarchar](50) NULL,
	[RefferencePersonId] [bigint] NULL,
	[RefferencePerson] [nvarchar](50) NULL,
	[RefferencePersonCode] [nvarchar](50) NULL,
	[RefferenceContact] [nvarchar](50) NULL,
	[ExistingReceiver] [bigint] NULL,
	[ReceiverGroupId] [bigint] NULL,
	[ReceiverGroupCode] [nvarchar](50) NULL,
	[ReceiverGroup] [nvarchar](50) NULL,
	[ReceiverCompanyId] [bigint] NULL,
	[ReceiverCompany] [nvarchar](50) NULL,
	[ReceiverCompanyCode] [nvarchar](50) NULL,
	[ReceiverDepartmentId] [bigint] NULL,
	[ReceiverDepartment] [nvarchar](50) NULL,
	[ReceiverDepartmentCode] [nvarchar](50) NULL,
	[ReceiverPersonId] [bigint] NULL,
	[ReceiverPerson] [nvarchar](50) NULL,
	[ReceiverPersonCode] [nvarchar](50) NULL,
	[ReceiverContact] [nvarchar](50) NULL,
	[ExistingBillTo] [bigint] NULL,
	[BillToGroupId] [bigint] NULL,
	[BillToGroupCode] [nvarchar](50) NULL,
	[BillToGroup] [nvarchar](50) NULL,
	[BillToCompanyId] [bigint] NULL,
	[BillToCompany] [nvarchar](50) NULL,
	[BillToCompanyCode] [nvarchar](50) NULL,
	[BillToDepartmentId] [bigint] NULL,
	[BillToDepartment] [nvarchar](50) NULL,
	[BillToDepartmentCode] [nvarchar](50) NULL,
	[BillToPersonId] [bigint] NULL,
	[BillToPerson] [nvarchar](50) NULL,
	[BillToPersonCode] [nvarchar](50) NULL,
	[BillToContact] [nvarchar](50) NULL,
	[IsCommunicatewithCustomer] [bit] NULL,
	[Status] [nvarchar](50) NULL,
	[OrderCompleted] [bit] NULL,
	[Active] [bit] NULL,
	[AssessmentReponse] [bit] NULL,
	[OrderPlacment] [bit] NOT NULL,
	[CustomerID] [bigint] NOT NULL,
	[IsForward] [bit] NOT NULL,
	[Department] [int] NULL,
	[IsResponseBackToCustomer] [bit] NULL,
	[IsInquiryToOrder] [bit] NOT NULL,
	[IsComplete] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[BiltyNo] [nvarchar](15) NULL,
	[ManualBiltyNo] [nvarchar](50) NULL,
	[ManualBiltyDate] [datetime] NULL,
 CONSTRAINT [PK_Inquiry_Or_Orders] PRIMARY KEY CLUSTERED 
(
	[Order_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InquiryAndOrdersDetail]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InquiryAndOrdersDetail](
	[ImportExportID] [bigint] IDENTITY(1,1) NOT NULL,
	[ShipmentTypeId] [int] NOT NULL,
	[OrderDetail_ID] [bigint] NOT NULL,
	[ContainerTypeID] [bigint] NOT NULL,
	[ContainerTypeQuantity] [bigint] NULL,
	[TotalWeight] [float] NULL,
	[ContainerPickupLocationID] [bigint] NOT NULL,
	[ContainerPickupAddress] [nvarchar](150) NULL,
	[ExportCargoPickLocationID] [bigint] NULL,
	[ExportCargoPickAddress] [nvarchar](150) NULL,
	[ContainerDropOfLocationID] [bigint] NULL,
	[ContainerDropOfAddress] [nvarchar](150) NULL,
	[ImportContainerDropOption] [nvarchar](50) NULL,
	[Dispatch_Date] [datetime] NULL,
	[ShippingLine] [nvarchar](50) NULL,
	[ContainerTerminalOrYeard] [nvarchar](50) NULL,
	[BillingType] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[VehicleTypeQuantity] [int] NULL,
	[ContainerToVehicle] [nvarchar](50) NULL,
	[LoadingUnloadingLocationType] [nvarchar](50) NULL,
	[LoadingUnloadingExpenseTypeId] [int] NULL,
	[LoadingUnloadingExpenseTypeQty] [int] NULL,
	[LoadingUnloadingExpenseTypeCapacity] [nvarchar](50) NULL,
	[OtherExpenseTypeId] [int] NULL,
	[OtherExpenseTypeQty] [int] NULL,
	[OtherExpenseTypeCapacity] [nvarchar](50) NULL,
	[PackageTypeID] [int] NULL,
	[Length] [float] NULL,
	[Width] [float] NULL,
	[Height] [float] NULL,
	[LoadQuantityWise] [float] NULL,
	[LoadWeightWise] [float] NULL,
	[Expenses_on_Consignment] [float] NULL,
	[Profit] [float] NULL,
	[Other_Charges] [float] NULL,
	[Tax] [float] NULL,
	[Total] [float] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[VehicleTypeId] [int] NULL,
	[VehicleID] [bigint] NULL,
	[VehicleRegNo] [nvarchar](50) NULL,
	[VehicleAssignTypeID] [bigint] NULL,
	[VehicleAssignDateTime] [datetime] NULL,
	[DriverID] [bigint] NULL,
	[DriverCode] [nvarchar](50) NULL,
	[DriverName] [nvarchar](50) NULL,
	[DriverCell] [nvarchar](50) NULL,
	[DriverCNIC] [nvarchar](50) NULL,
	[DriverLicenseNo] [nvarchar](50) NULL,
	[DriverLicenseExp] [datetime] NULL,
	[LicenseStatus] [nvarchar](50) NULL,
	[BrokerID] [bigint] NULL,
	[BrokerName] [nvarchar](50) NULL,
	[BrokerCell] [nvarchar](50) NULL,
	[BrokerCNIC] [nvarchar](50) NULL,
	[ContainerSealedNo] [nvarchar](50) NULL,
 CONSTRAINT [PK_Assessment_ContainerExportOrImport] PRIMARY KEY CLUSTERED 
(
	[ImportExportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InvoiceExpenses]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvoiceExpenses](
	[InvoiceExpenseId] [bigint] IDENTITY(1,1) NOT NULL,
	[ExpenseId] [nvarchar](50) NULL,
	[AmountExpenses] [bigint] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[InvoiceId] [bigint] NOT NULL,
 CONSTRAINT [PK_InvoiceExpenses] PRIMARY KEY CLUSTERED 
(
	[InvoiceExpenseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InvoiceExpenseType]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvoiceExpenseType](
	[InvoiceExpenseTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_InvoiceExpenseType] PRIMARY KEY CLUSTERED 
(
	[InvoiceExpenseTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoices]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoices](
	[InvoiceNo] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NULL,
	[CompanyId] [bigint] NULL,
	[DateFrom] [date] NULL,
	[DateTo] [date] NULL,
	[InvoiceDate] [date] NULL,
	[DateCreated] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[BiltyNo] [nvarchar](max) NULL,
	[BillCode] [nvarchar](12) NULL,
	[ExpensesAmount] [bigint] NULL,
	[SaleTax] [float] NULL,
	[Expenses] [nvarchar](50) NULL,
	[InvoiceTotalAmount] [bigint] NULL,
 CONSTRAINT [PK_Invoices_1] PRIMARY KEY CLUSTERED 
(
	[InvoiceNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Item]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Item](
	[ItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[ItemCode] [varchar](50) NULL,
	[ItemName] [varchar](50) NULL,
	[weight] [decimal](6, 2) NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUserID] [bigint] NULL,
	[IsActive] [bit] NULL,
	[Description] [varchar](500) NULL,
	[IsGeneralItem] [bit] NULL,
	[OwnerID] [bigint] NULL,
 CONSTRAINT [PK_Item] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LabourReport]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LabourReport](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportNo] [bigint] NULL,
	[Vehicle] [nvarchar](50) NULL,
	[VehicleType] [nvarchar](50) NULL,
	[ChallanNo] [nvarchar](50) NULL,
	[LabourCharges] [bigint] NULL,
	[Comission] [bigint] NULL,
	[LifterExpense] [bigint] NULL,
	[TotalCharges] [bigint] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModfiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_LabourReport] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LabourReportDetail]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LabourReportDetail](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[LRCNo] [float] NULL,
	[ReportNo] [bigint] NULL,
	[ContractorCharges] [bigint] NULL,
	[AmountPayable] [bigint] NULL,
	[TotalComission] [bigint] NULL,
	[TotalLabourCharges] [bigint] NULL,
	[TotalLifter] [bigint] NULL,
 CONSTRAINT [PK_LabourReportChild] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LocationType]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocationType](
	[LocationTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[LocationTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_LocationType] PRIMARY KEY CLUSTERED 
(
	[LocationTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MCBBranches]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MCBBranches](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[BR_CODE] [varchar](10) NULL,
	[BranchName] [nvarchar](250) NULL,
	[ContactNo] [varchar](50) NULL,
	[EmailId] [varchar](50) NULL,
	[Active] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_MCBBranches] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Menu]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Menu](
	[MenuID] [bigint] IDENTITY(1,1) NOT NULL,
	[MenuName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED 
(
	[MenuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuRights]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuRights](
	[FormAccessID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NULL,
	[Menu] [nvarchar](50) NULL,
	[FormID] [nvarchar](200) NULL,
 CONSTRAINT [PK_MenuRights] PRIMARY KEY CLUSTERED 
(
	[FormAccessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Nature]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Nature](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Description] [nvarchar](50) NULL,
	[Status] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Nature] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NavMenu]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NavMenu](
	[FormID] [bigint] IDENTITY(1,1) NOT NULL,
	[FormName] [nvarchar](50) NOT NULL,
	[Url] [nvarchar](200) NOT NULL,
	[Active] [bit] NOT NULL,
	[icon] [nvarchar](150) NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[MenuID] [bigint] NOT NULL,
	[formTarget] [nvarchar](50) NULL,
 CONSTRAINT [PK_NavMenu] PRIMARY KEY CLUSTERED 
(
	[FormID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[OrderID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[CompanyId] [int] NULL,
	[GroupID] [int] NULL,
	[DepartmentID] [int] NULL,
	[ExistingCustomer] [bit] NULL,
	[CustomerGroupId] [nchar](10) NULL,
	[CustomerGroupCode] [nvarchar](50) NULL,
	[CustomerGroup] [nvarchar](150) NULL,
	[CustomerCompanyId] [bigint] NULL,
	[CustomerCompany] [nvarchar](150) NULL,
	[CustomerCompanyCode] [nvarchar](50) NULL,
	[CustomerDepartmentId] [bigint] NULL,
	[CustomerDepartment] [nvarchar](150) NULL,
	[CustomerDepartmentCode] [nvarchar](50) NULL,
	[CustomerPersonId] [bigint] NULL,
	[CustomerPerson] [nvarchar](150) NULL,
	[CustomerPersonCode] [nvarchar](50) NULL,
	[CustomerContact] [nvarchar](50) NULL,
	[ExistingRefference] [bigint] NULL,
	[RefferenceGroupId] [bigint] NULL,
	[RefferenceGroupCode] [nvarchar](50) NULL,
	[RefferenceGroup] [nvarchar](50) NULL,
	[RefferenceCompanyId] [bigint] NULL,
	[RefferenceCompany] [nvarchar](50) NULL,
	[RefferenceCompanyCode] [nvarchar](50) NULL,
	[RefferenceDepartmentId] [bigint] NULL,
	[RefferenceDepartment] [nvarchar](50) NULL,
	[RefferenceDepartmentCode] [nvarchar](50) NULL,
	[RefferencePersonId] [bigint] NULL,
	[RefferencePerson] [nvarchar](50) NULL,
	[RefferencePersonCode] [nvarchar](50) NULL,
	[RefferenceContact] [nvarchar](50) NULL,
	[ExistingReceiver] [bigint] NULL,
	[ReceiverGroupId] [bigint] NULL,
	[ReceiverGroupCode] [nvarchar](50) NULL,
	[ReceiverGroup] [nvarchar](50) NULL,
	[ReceiverCompanyId] [bigint] NULL,
	[ReceiverCompany] [nvarchar](50) NULL,
	[ReceiverCompanyCode] [nvarchar](50) NULL,
	[ReceiverDepartmentId] [bigint] NULL,
	[ReceiverDepartment] [nvarchar](50) NULL,
	[ReceiverDepartmentCode] [nvarchar](50) NULL,
	[ReceiverPersonId] [bigint] NULL,
	[ReceiverPerson] [nvarchar](50) NULL,
	[ReceiverPersonCode] [nvarchar](50) NULL,
	[ReceiverContact] [nvarchar](50) NULL,
	[ExistingBillTo] [bigint] NULL,
	[BillToGroupId] [bigint] NULL,
	[BillToGroupCode] [nvarchar](50) NULL,
	[BillToGroup] [nvarchar](50) NULL,
	[BillToCompanyId] [bigint] NULL,
	[BillToCompany] [nvarchar](50) NULL,
	[BillToCompanyCode] [nvarchar](50) NULL,
	[BillToDepartmentId] [bigint] NULL,
	[BillToDepartment] [nvarchar](50) NULL,
	[BillToDepartmentCode] [nvarchar](50) NULL,
	[BillToPersonId] [bigint] NULL,
	[BillToPerson] [nvarchar](50) NULL,
	[BillToPersonCode] [nvarchar](50) NULL,
	[BillToContact] [nvarchar](50) NULL,
	[ChallanNo] [nvarchar](50) NULL,
	[ChallanDate] [datetime] NULL,
	[Status] [nvarchar](50) NULL,
	[OrderCompleted] [bit] NULL,
	[Active] [bit] NULL,
	[OrderPlacment] [bit] NOT NULL,
	[CustomerID] [bigint] NOT NULL,
	[IsForward] [bit] NOT NULL,
	[Department] [int] NULL,
	[IsResponseBackToCustomer] [bit] NULL,
	[IsInquiryToOrder] [bit] NOT NULL,
	[IsComplete] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[BiltyNo] [nvarchar](15) NULL,
	[ManualBiltyNo] [nvarchar](50) NULL,
	[ManualBiltyDate] [datetime] NULL,
	[PartBilty] [bit] NULL,
 CONSTRAINT [PK_Order_1] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order_OLD]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order_OLD](
	[OrderID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[CompanyId] [int] NULL,
	[GroupID] [int] NULL,
	[DepartmentID] [int] NULL,
	[ExistingCustomer] [bit] NULL,
	[CustomerGroupId] [nchar](10) NULL,
	[CustomerGroupCode] [nvarchar](50) NULL,
	[CustomerGroup] [nvarchar](150) NULL,
	[CustomerCompanyId] [bigint] NULL,
	[CustomerCompany] [nvarchar](150) NULL,
	[CustomerCompanyCode] [nvarchar](50) NULL,
	[CustomerDepartmentId] [bigint] NULL,
	[CustomerDepartment] [nvarchar](150) NULL,
	[CustomerDepartmentCode] [nvarchar](50) NULL,
	[CustomerPersonId] [bigint] NULL,
	[CustomerPerson] [nvarchar](150) NULL,
	[CustomerPersonCode] [nvarchar](50) NULL,
	[CustomerContact] [nvarchar](50) NULL,
	[ExistingRefference] [bigint] NULL,
	[RefferenceGroupId] [bigint] NULL,
	[RefferenceGroupCode] [nvarchar](50) NULL,
	[RefferenceGroup] [nvarchar](50) NULL,
	[RefferenceCompanyId] [bigint] NULL,
	[RefferenceCompany] [nvarchar](50) NULL,
	[RefferenceCompanyCode] [nvarchar](50) NULL,
	[RefferenceDepartmentId] [bigint] NULL,
	[RefferenceDepartment] [nvarchar](50) NULL,
	[RefferenceDepartmentCode] [nvarchar](50) NULL,
	[RefferencePersonId] [bigint] NULL,
	[RefferencePerson] [nvarchar](50) NULL,
	[RefferencePersonCode] [nvarchar](50) NULL,
	[RefferenceContact] [nvarchar](50) NULL,
	[ExistingReceiver] [bigint] NULL,
	[ReceiverGroupId] [bigint] NULL,
	[ReceiverGroupCode] [nvarchar](50) NULL,
	[ReceiverGroup] [nvarchar](50) NULL,
	[ReceiverCompanyId] [bigint] NULL,
	[ReceiverCompany] [nvarchar](50) NULL,
	[ReceiverCompanyCode] [nvarchar](50) NULL,
	[ReceiverDepartmentId] [bigint] NULL,
	[ReceiverDepartment] [nvarchar](50) NULL,
	[ReceiverDepartmentCode] [nvarchar](50) NULL,
	[ReceiverPersonId] [bigint] NULL,
	[ReceiverPerson] [nvarchar](50) NULL,
	[ReceiverPersonCode] [nvarchar](50) NULL,
	[ReceiverContact] [nvarchar](50) NULL,
	[ExistingBillTo] [bigint] NULL,
	[BillToGroupId] [bigint] NULL,
	[BillToGroupCode] [nvarchar](50) NULL,
	[BillToGroup] [nvarchar](50) NULL,
	[BillToCompanyId] [bigint] NULL,
	[BillToCompany] [nvarchar](50) NULL,
	[BillToCompanyCode] [nvarchar](50) NULL,
	[BillToDepartmentId] [bigint] NULL,
	[BillToDepartment] [nvarchar](50) NULL,
	[BillToDepartmentCode] [nvarchar](50) NULL,
	[BillToPersonId] [bigint] NULL,
	[BillToPerson] [nvarchar](50) NULL,
	[BillToPersonCode] [nvarchar](50) NULL,
	[BillToContact] [nvarchar](50) NULL,
	[IsCommunicatewithCustomer] [bit] NULL,
	[Status] [nvarchar](50) NULL,
	[OrderCompleted] [bit] NULL,
	[Active] [bit] NULL,
	[AssessmentReponse] [bit] NULL,
	[OrderPlacment] [bit] NOT NULL,
	[CustomerID] [bigint] NOT NULL,
	[IsForward] [bit] NOT NULL,
	[Department] [int] NULL,
	[IsResponseBackToCustomer] [bit] NULL,
	[IsInquiryToOrder] [bit] NOT NULL,
	[IsComplete] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[BiltyNo] [nvarchar](15) NULL,
	[ManualBiltyNo] [nvarchar](50) NULL,
	[ManualBiltyDate] [datetime] NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderAdvances]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderAdvances](
	[AdvanceID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderID] [bigint] NULL,
	[AdvancePlace] [nvarchar](50) NULL,
	[AdvanceAgainst] [nvarchar](100) NULL,
	[AdvanceAmount] [float] NULL,
	[PatrolPumpID] [bigint] NULL,
	[PatrolRate] [float] NULL,
	[PatrolLitres] [float] NULL,
	[RecordedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ReceivedFrom] [nvarchar](50) NULL,
 CONSTRAINT [PK_OrderAdvances] PRIMARY KEY CLUSTERED 
(
	[AdvanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderConsignment]    Script Date: 5/10/2021 1:50:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderConsignment](
	[OrderConsignmentID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderID] [bigint] NULL,
	[ContainerType] [bigint] NULL,
	[ContainerNo] [nvarchar](50) NULL,
	[ContainerWeight] [float] NULL,
	[PickupLocationID] [bigint] NULL,
	[EmptyContainerPickLocation] [nvarchar](200) NULL,
	[DropoffLocationID] [bigint] NULL,
	[EmptyContainerDropLocation] [nvarchar](200) NULL,
	[VesselName] [nvarchar](50) NULL,
	[Remarks] [nvarchar](200) NULL,
	[AssignedVehicle] [nvarchar](50) NULL,
	[Rate] [float] NULL,
	[PaymentStatus] [bit] NULL,
	[Status] [bit] NULL,
	[IsBilled] [bit] NULL,
	[ReceivedBy] [nvarchar](50) NULL,
	[ReceivedDateTime] [datetime] NULL,
	[WeighmentCharges] [float] NULL,
 CONSTRAINT [PK_OrderConsignment] PRIMARY KEY CLUSTERED 
(
	[OrderConsignmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderConsignmentReceiving]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderConsignmentReceiving](
	[ConsignmentReceiverID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderID] [bigint] NULL,
	[ReceivedBy] [nvarchar](50) NULL,
	[ReceivedDateTime] [datetime] NULL,
 CONSTRAINT [PK_ConsignmentReceiver] PRIMARY KEY CLUSTERED 
(
	[ConsignmentReceiverID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDamage]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDamage](
	[OrderDamageID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderID] [bigint] NULL,
	[ItemName] [nvarchar](50) NULL,
	[DamageType] [nvarchar](50) NULL,
	[DamageCost] [bigint] NULL,
	[DamageCause] [nvarchar](50) NULL,
	[DamageDocumentName] [nvarchar](50) NULL,
	[DamageDocumentPath] [nvarchar](200) NULL,
 CONSTRAINT [PK_OrderDamage] PRIMARY KEY CLUSTERED 
(
	[OrderDamageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[OrderDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderID] [bigint] NOT NULL,
	[BiltyNo] [nvarchar](50) NULL,
	[BiltyNoDate] [datetime] NULL,
	[ManualBiltyNo] [nvarchar](50) NULL,
	[ManualBiltyDate] [datetime] NULL,
	[CustomerCode] [nvarchar](50) NULL,
	[PaymentType] [nvarchar](50) NULL,
	[ShipmentTypeId] [int] NOT NULL,
	[VehicleTypeId] [int] NULL,
	[BrokerId] [int] NULL,
	[BrokerName] [nvarchar](100) NULL,
	[BrokerContactNo] [nvarchar](50) NULL,
	[AdditionalWeight] [float] NULL,
	[NetWeight] [float] NULL,
	[TotalExpenses] [float] NULL,
	[FreightTypeId] [int] NULL,
	[FreightTypeQty] [int] NULL,
	[Freight] [float] NULL,
	[ParentId] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[LocalFreight] [bigint] NULL,
	[DA_No] [nvarchar](50) NULL,
	[Remarks] [nvarchar](250) NULL,
	[ChallanNo] [nvarchar](50) NULL,
	[ChallanDate] [datetime] NULL,
	[AdditionalFreight] [float] NULL,
	[InvoiceNo] [bigint] NULL,
	[StatusID] [bigint] NULL,
 CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED 
(
	[OrderDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetailItem]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetailItem](
	[OrderDetailItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderDetailID] [bigint] NOT NULL,
	[ItemId] [bigint] NOT NULL,
	[ItemQty] [int] NULL,
	[Weight] [float] NULL,
	[Unit] [nvarchar](50) NULL,
	[CreatedBy] [bigint] NULL,
	[CreadtedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_OrderDetailItem] PRIMARY KEY CLUSTERED 
(
	[OrderDetailItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDispatchDocument]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDispatchDocument](
	[OrderDispatchDocumentID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderID] [bigint] NULL,
	[DocumentType] [nvarchar](50) NULL,
	[DocumentNo] [nvarchar](50) NULL,
	[DocumentName] [nvarchar](50) NULL,
	[DocumentPath] [nvarchar](50) NULL,
 CONSTRAINT [PK_OrderDispatchDocument] PRIMARY KEY CLUSTERED 
(
	[OrderDispatchDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDocument]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDocument](
	[OrderDocumentId] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderDetailId] [bigint] NOT NULL,
	[DocumentTypeId] [bigint] NULL,
	[DocumentNo] [nvarchar](150) NULL,
	[Attachment] [nvarchar](250) NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
 CONSTRAINT [PK_OrderDocument_1] PRIMARY KEY CLUSTERED 
(
	[OrderDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDocument_OLD]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDocument_OLD](
	[OrderDocumentId] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderDetailId] [bigint] NOT NULL,
	[DocumentTypeId] [bigint] NULL,
	[DocumentNo] [nvarchar](150) NULL,
	[Attachment] [nvarchar](250) NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
 CONSTRAINT [PK_OrderDocument] PRIMARY KEY CLUSTERED 
(
	[OrderDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDocumentReceiving]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDocumentReceiving](
	[OrderReceivedDocumentID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderID] [bigint] NULL,
	[DocumentType] [nvarchar](50) NULL,
	[DocumentNo] [nvarchar](50) NULL,
	[DocumentName] [nvarchar](50) NULL,
	[DocumentPath] [nvarchar](100) NULL,
 CONSTRAINT [PK_OrderDocumentReceiving] PRIMARY KEY CLUSTERED 
(
	[OrderReceivedDocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderExpenses]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderExpenses](
	[OrderExpenseId] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderDetailId] [bigint] NOT NULL,
	[ExpenseTypeId] [bigint] NOT NULL,
	[Amount] [float] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
 CONSTRAINT [PK_OrderExpenses] PRIMARY KEY CLUSTERED 
(
	[OrderExpenseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderInvoices]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderInvoices](
	[InvoiceID] [bigint] IDENTITY(1,1) NOT NULL,
	[InvoiceNo] [nvarchar](50) NULL,
	[CustomerInvoice] [nvarchar](50) NULL,
	[CustomerCompany] [nvarchar](50) NULL,
	[OrderID] [bigint] NULL,
	[Total] [float] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[isPaid] [bit] NULL,
	[DocumentNo] [nvarchar](50) NULL,
	[TransferedTo] [nvarchar](50) NULL,
	[PaymentDate] [datetime] NULL,
	[PaymentMode] [nvarchar](50) NULL,
	[TotalBalance] [float] NULL,
 CONSTRAINT [PK_OrderInvoices] PRIMARY KEY CLUSTERED 
(
	[InvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderLocations]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderLocations](
	[LocationId] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderDetailId] [bigint] NOT NULL,
	[PickupLocationId] [bigint] NOT NULL,
	[PickupLocationAddress] [nvarchar](250) NULL,
	[DropLocationId] [bigint] NOT NULL,
	[DropLocationAddress] [nvarchar](250) NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[StationFrom] [bigint] NULL,
	[StationTo] [bigint] NULL,
	[DeliveryType] [nvarchar](50) NULL,
	[ReceiverName] [nvarchar](150) NULL,
	[ReceiverAddress] [nvarchar](250) NULL,
	[ReceiverContact] [varchar](50) NULL,
 CONSTRAINT [PK_OrderLocations] PRIMARY KEY CLUSTERED 
(
	[LocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderPackageTypes]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderPackageTypes](
	[OrderPackageId] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderDetailId] [bigint] NOT NULL,
	[PackageTypeId] [bigint] NOT NULL,
	[ItemId] [bigint] NOT NULL,
	[Quantity] [bigint] NULL,
	[Weight] [float] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[UnitFreight] [float] NULL,
	[UnitWeight] [float] NULL,
	[RateType] [nvarchar](20) NULL,
	[ProfileDetailId] [bigint] NULL,
	[AdditionalCharges] [float] NULL,
	[LabourCharges] [float] NULL,
	[DC_NO] [nvarchar](50) NULL,
 CONSTRAINT [PK_OrderPackageTypes] PRIMARY KEY CLUSTERED 
(
	[OrderPackageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderProduct]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderProduct](
	[OrderProductID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderID] [bigint] NULL,
	[PackageType] [nvarchar](50) NULL,
	[Item] [nvarchar](50) NULL,
	[Qty] [bigint] NULL,
	[TotalWeight] [float] NULL,
 CONSTRAINT [PK_OrderProduct] PRIMARY KEY CLUSTERED 
(
	[OrderProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderVehicle]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderVehicle](
	[OrderVehicleID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderID] [bigint] NULL,
	[VehicleType] [nvarchar](50) NULL,
	[VehicleRegNo] [nvarchar](50) NULL,
	[VehicleContactNo] [bigint] NULL,
	[BrokerID] [bigint] NULL,
	[DriverName] [nvarchar](50) NULL,
	[FatherName] [nvarchar](50) NULL,
	[DriverNIC] [bigint] NULL,
	[DriverLicence] [nvarchar](50) NULL,
	[DriverCellNo] [bigint] NULL,
	[ReportingTime] [datetime] NULL,
	[InTime] [datetime] NULL,
	[OutTime] [datetime] NULL,
	[Rate] [float] NULL,
	[Status] [nvarchar](50) NULL,
 CONSTRAINT [PK_OrderVehicle] PRIMARY KEY CLUSTERED 
(
	[OrderVehicleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Organization]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organization](
	[OrganizationID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NULL,
	[password] [nvarchar](50) NULL,
	[Code] [nvarchar](50) NULL,
	[Address] [nvarchar](250) NULL,
	[Active] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[Modifiedby] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_Organization] PRIMARY KEY CLUSTERED 
(
	[OrganizationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OwnCompany]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OwnCompany](
	[CompanyID] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyCode] [nvarchar](15) NULL,
	[CompanyName] [nvarchar](100) NULL,
	[CompanyEmail] [nvarchar](50) NULL,
	[CompanyWebSite] [nvarchar](50) NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[Active] [bit] NULL,
	[CreatedDate] [date] NULL,
	[ModifiedDate] [date] NULL,
	[Contact] [varchar](50) NULL,
	[OtherContact] [nvarchar](50) NULL,
	[Description] [nvarchar](255) NULL,
	[GroupID] [bigint] NOT NULL,
	[Address1] [nvarchar](250) NULL,
	[Address2] [nvarchar](250) NULL,
	[NTN] [varchar](10) NULL,
 CONSTRAINT [PK_OwnCompany_1] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OwnDepartment]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OwnDepartment](
	[DepartID] [bigint] IDENTITY(1,1) NOT NULL,
	[DepartCode] [varchar](50) NULL,
	[DepartName] [varchar](50) NULL,
	[Contact] [varchar](50) NULL,
	[ContactOther] [varchar](50) NULL,
	[EmailAdd] [varchar](50) NULL,
	[WebAdd] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[CustomerID] [bigint] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUser] [bigint] NULL,
	[Description] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[GROUPID] [bigint] NOT NULL,
	[COMPANYID] [bigint] NOT NULL,
 CONSTRAINT [PK_OwnDepartment_1] PRIMARY KEY CLUSTERED 
(
	[DepartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Owner]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Owner](
	[OwnerID] [bigint] IDENTITY(1,1) NOT NULL,
	[OwnerCode] [varchar](50) NULL,
	[OwnerName] [varchar](50) NULL,
	[UserName] [varchar](50) NULL,
	[OwnerPassword] [varchar](50) NULL,
	[OwnerAdd] [varchar](50) NULL,
	[OwnerContact#] [varchar](50) NULL,
	[OwnerCell#] [varchar](50) NULL,
	[OwnerEmail] [varchar](50) NULL,
	[Description] [varchar](500) NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUserID] [bigint] NULL,
	[IsActive] [bit] NULL,
	[imageUrl] [image] NULL,
 CONSTRAINT [PK_Owner_1] PRIMARY KEY CLUSTERED 
(
	[OwnerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OwnGroups]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OwnGroups](
	[GroupID] [bigint] IDENTITY(1,1) NOT NULL,
	[GroupCode] [varchar](50) NULL,
	[GroupName] [varchar](50) NULL,
	[Contact] [varchar](50) NULL,
	[ContactOther] [varchar](50) NULL,
	[EmailAdd] [varchar](50) NULL,
	[WebAdd] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[Logo] [image] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUserID] [bigint] NULL,
	[Description] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[CompanyAccess] [varchar](50) NULL,
 CONSTRAINT [PK_OwnGroups] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PackageType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackageType](
	[PackageTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[PackageTypeCode] [varchar](50) NULL,
	[PackageTypeName] [varchar](50) NULL,
	[Length] [float] NULL,
	[Width] [float] NULL,
	[Height] [float] NULL,
	[DimensionUnit] [varchar](10) NULL,
	[Weight] [float] NULL,
	[WeightUnit] [varchar](10) NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUserID] [bigint] NULL,
	[IsActive] [bit] NULL,
	[IsMaster] [bit] NULL,
	[Description] [varchar](500) NULL,
 CONSTRAINT [PK_PackageType_1] PRIMARY KEY CLUSTERED 
(
	[PackageTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PartRegistration]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PartRegistration](
	[PartRegID] [bigint] IDENTITY(1,1) NOT NULL,
	[VehiclePartId] [bigint] NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[EstimationCost] [float] NULL,
	[EstimationLifeInDay] [numeric](18, 0) NULL,
	[EstimationRunning] [numeric](18, 0) NULL,
	[Description] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
 CONSTRAINT [PK_PartRegistration] PRIMARY KEY CLUSTERED 
(
	[PartRegID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PatrolPumps]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatrolPumps](
	[PatrolPumpID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[PerLiterRate] [float] NULL,
	[CreatedBy] [bigint] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[isActive] [bit] NULL,
	[isDelete] [bit] NULL,
 CONSTRAINT [PK_PatrolPumps] PRIMARY KEY CLUSTERED 
(
	[PatrolPumpID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PickDropLocation]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PickDropLocation](
	[PickDropID] [bigint] IDENTITY(1,1) NOT NULL,
	[PickDropCode] [varchar](50) NULL,
	[AreaID] [bigint] NULL,
	[Address] [varchar](50) NULL,
	[ProvinceID] [bigint] NULL,
	[LocationTypeID] [bigint] NULL,
	[OwnerID] [bigint] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUserID] [bigint] NULL,
	[IsActive] [bit] NULL,
	[Description] [varchar](500) NULL,
	[PickDropLocationName] [varchar](100) NULL,
	[IsPort] [bit] NULL,
	[LAT] [varchar](50) NULL,
	[LON] [varchar](50) NULL,
	[CityID] [bigint] NULL,
	[RegionID] [bigint] NULL,
 CONSTRAINT [PK_PickDropLocation_1] PRIMARY KEY CLUSTERED 
(
	[PickDropID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[PackageTypeID] [bigint] NULL,
	[Code] [nvarchar](50) NULL,
	[Category] [nvarchar](50) NULL,
	[Gener] [nvarchar](50) NULL,
	[Nature] [nvarchar](50) NULL,
	[DimensionUnit] [nvarchar](50) NULL,
	[Weight] [float] NULL,
	[Description] [nvarchar](200) NULL,
	[Status] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[Width] [float] NULL,
	[Height] [float] NULL,
	[Unit] [nvarchar](50) NULL,
	[Volume] [float] NULL,
	[Length] [float] NULL,
 CONSTRAINT [PK_Product_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_WASTE]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_WASTE](
	[ProductId] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](10) NULL,
	[ProductName] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_ProductName] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Province]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Province](
	[ProvinceID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProvinceName] [varchar](50) NULL,
	[CountryID] [bigint] NULL,
 CONSTRAINT [PK_Province] PRIMARY KEY CLUSTERED 
(
	[ProvinceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Region]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Region](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[ProvinceID] [bigint] NULL,
	[CityID] [bigint] NULL,
	[Description] [text] NULL,
	[Active] [bit] NULL,
	[CreatedByID] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedByID] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Region] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportsType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportsType](
	[ReportId] [int] IDENTITY(1,1) NOT NULL,
	[ReportName] [nvarchar](50) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_ReportsType_1] PRIMARY KEY CLUSTERED 
(
	[ReportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RevenueType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RevenueType](
	[RevenueTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Description] [nvarchar](100) NULL,
	[isActive] [bit] NULL,
	[CreatedById] [bigint] NULL,
	[ModifiedByID] [bigint] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
 CONSTRAINT [PK_RevenueType] PRIMARY KEY CLUSTERED 
(
	[RevenueTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleBaseFormRight]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleBaseFormRight](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FormId] [bigint] NOT NULL,
	[RoleId] [bigint] NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_RoleBaseFormRight] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SalesTaxInvoice]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalesTaxInvoice](
	[SalesTaxInvoiceID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrderID] [bigint] NULL,
	[SupplierID] [bigint] NULL,
	[BuyerID] [bigint] NULL,
	[ActualAmount] [float] NULL,
	[AppliedTaxPercentage] [float] NULL,
	[AppliedTaxAmount] [float] NULL,
	[ValueInclusiveTax] [float] NULL,
	[InvoiceDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_SalesTaxInvoice] PRIMARY KEY CLUSTERED 
(
	[SalesTaxInvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Section]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Section](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[SectionName] [nvarchar](50) NULL,
	[Group] [nvarchar](50) NULL,
	[Dept] [nvarchar](50) NULL,
	[ListofPerson] [nvarchar](50) NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Section_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShipmentType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShipmentType](
	[ShipmentType_ID] [int] IDENTITY(1,1) NOT NULL,
	[ShipmentTypeDetail] [nvarchar](150) NULL,
	[ShipmentType] [nvarchar](50) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_ShipmentType] PRIMARY KEY CLUSTERED 
(
	[ShipmentType_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingLine]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingLine](
	[ShippingLineID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[ContactPerson] [nvarchar](50) NULL,
	[PrimaryContact] [bigint] NULL,
	[SecondaryContact] [bigint] NULL,
	[LandLine] [bigint] NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[WebSite] [nvarchar](50) NULL,
	[Address] [nvarchar](50) NULL,
	[Description] [nvarchar](100) NULL,
	[isActive] [bit] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedById] [bigint] NULL,
	[ModifiedByID] [bigint] NULL,
 CONSTRAINT [PK_ShippingLine] PRIMARY KEY CLUSTERED 
(
	[ShippingLineID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SQLError]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SQLError](
	[ErrorId] [bigint] IDENTITY(1,1) NOT NULL,
	[ErrorDateTime] [datetime] NULL,
	[SQLString] [varchar](max) NULL,
	[SQLError] [varchar](max) NULL,
	[ErrorOrigin] [varchar](15) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stations]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stations](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[CityID] [bigint] NULL,
	[ContactPerson] [nvarchar](50) NULL,
	[SecondaryContactPerson] [nvarchar](50) NULL,
	[ContactNo] [bigint] NULL,
	[SecondaryContactNo] [bigint] NULL,
	[Address] [nvarchar](100) NULL,
	[Description] [nvarchar](100) NULL,
	[isActive] [bit] NULL,
	[CreatedByID] [bigint] NULL,
	[ModifiedByID] [bigint] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
 CONSTRAINT [PK_Stations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Status]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Status](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[StatusCode] [nvarchar](10) NOT NULL,
	[StatusName] [nvarchar](50) NOT NULL,
	[Color] [nvarchar](20) NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TaxTypes]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxTypes](
	[TaxID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Percentage] [float] NULL,
	[isActive] [bit] NULL,
	[isDelete] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_TaxTypes] PRIMARY KEY CLUSTERED 
(
	[TaxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TripExpenses]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TripExpenses](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[TripID] [bigint] NULL,
	[ExpenseTypeID] [bigint] NULL,
	[Amount] [float] NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TripExpenses] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Trips]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Trips](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyID] [bigint] NULL,
	[TripStart] [datetime] NULL,
	[TripEnd] [datetime] NULL,
	[Pickup] [nvarchar](max) NULL,
	[Dropoff] [nvarchar](max) NULL,
	[VehicleRegNo] [bigint] NULL,
	[Freight] [float] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Trips] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TripVehicleExpenses]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TripVehicleExpenses](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[VehicleID] [bigint] NULL,
	[ExpenseTypeID] [bigint] NULL,
	[Vendor] [nvarchar](50) NULL,
	[Date] [datetime] NULL,
	[Amount] [float] NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_TripVehicleExpenses] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAccounts]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccounts](
	[UserID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[UserPassword] [nvarchar](50) NOT NULL,
	[GroupID] [bigint] NOT NULL,
	[CompanyID] [bigint] NULL,
	[DepartmentID] [bigint] NULL,
	[Active] [bit] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[DesignationID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
 CONSTRAINT [PK_UserAccounts] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vehicle]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle](
	[VehicleID] [bigint] IDENTITY(1,1) NOT NULL,
	[VehicleCode] [varchar](50) NULL,
	[RegNo] [varchar](50) NULL,
	[ChasisNo] [varchar](50) NULL,
	[EngineNo] [varchar](50) NULL,
	[Length] [float] NULL,
	[Width] [float] NULL,
	[Height] [float] NULL,
	[DimensionUnitType] [varchar](50) NULL,
	[VehicleTypeID] [bigint] NOT NULL,
	[Type] [varchar](50) NULL,
	[VehicleModel] [varchar](50) NULL,
	[VehicleColor] [varchar](50) NULL,
	[BodyType] [varchar](50) NULL,
	[ManufacturingYear] [varchar](50) NULL,
	[ManufacturerName] [varchar](50) NULL,
	[Picture] [image] NULL,
	[PurchasingDate] [datetime] NULL,
	[PurchasingAmount] [bigint] NULL,
	[PurchaseFromName] [varchar](50) NULL,
	[PurchaseFromDetail] [varchar](200) NULL,
	[OwnerName] [varchar](50) NULL,
	[OwnerContact] [varchar](50) NULL,
	[OwnerNIC] [varchar](50) NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUserID] [bigint] NULL,
	[IsActive] [bit] NULL,
	[Description] [varchar](500) NULL,
	[IsOwnVehicle] [bit] NULL,
	[VehicleCharges] [float] NULL,
	[Comssion] [float] NULL,
 CONSTRAINT [PK_Vehicle] PRIMARY KEY CLUSTERED 
(
	[VehicleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Unique_RegNo] UNIQUE NONCLUSTERED 
(
	[RegNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Unique_VehicleCode] UNIQUE NONCLUSTERED 
(
	[VehicleCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VehicleParts]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleParts](
	[PartID] [bigint] IDENTITY(1,1) NOT NULL,
	[PartCode] [nvarchar](20) NULL,
	[PartName] [nvarchar](50) NULL,
	[PartDescription] [nvarchar](250) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedBy] [bigint] NULL,
	[Status] [bit] NULL,
 CONSTRAINT [PK_VehicleParts] PRIMARY KEY CLUSTERED 
(
	[PartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VehicleType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VehicleType](
	[VehicleTypeID] [bigint] IDENTITY(1,1) NOT NULL,
	[VehicleTypeCode] [varchar](50) NULL,
	[VehicleTypeName] [varchar](50) NULL,
	[DimensionUnitType] [varchar](50) NULL,
	[LowerDeckInnerLength] [float] NULL,
	[LowerDeckInnerWidth] [float] NULL,
	[LowerDeckInnerHeight] [float] NULL,
	[UpperDeckInnerLength] [float] NULL,
	[UpperDeckInnerWidth] [float] NULL,
	[UpperDeckInnerHeight] [float] NULL,
	[LowerDeckOuterLength] [float] NULL,
	[LowerDeckOuterWidth] [float] NULL,
	[LowerDeckOuterHeight] [float] NULL,
	[UpperDeckOuterLength] [float] NULL,
	[UpperDeckOuterWidth] [float] NULL,
	[UpperDeckOuterHeight] [float] NULL,
	[UpperPortionInnerLength] [float] NULL,
	[UpperPortionInnerwidth] [float] NULL,
	[UpperPortionInnerHeight] [float] NULL,
	[LowerPortionInnerLength] [float] NULL,
	[LowerPortionInnerWidth] [float] NULL,
	[LowerPortionInnerHeight] [float] NULL,
	[PermisibleHeight] [float] NULL,
	[PermisibleLength] [float] NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[CreatedByUserID] [bigint] NULL,
	[ModifiedByUserID] [bigint] NULL,
	[IsActive] [bit] NULL,
	[Description] [varchar](500) NULL,
 CONSTRAINT [PK_VehicleType] PRIMARY KEY CLUSTERED 
(
	[VehicleTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vendor]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vendor](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Contact] [bigint] NULL,
	[OtherContact] [bigint] NULL,
	[Email] [nvarchar](50) NULL,
	[ContractorCharges] [float] NULL,
	[Address] [nvarchar](200) NULL,
	[Description] [nvarchar](200) NULL,
	[isActive] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[ModifiedBy] [bigint] NULL,
 CONSTRAINT [PK_Vendor] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vouchers]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vouchers](
	[VoucherID] [bigint] IDENTITY(1,1) NOT NULL,
	[VoucherNo] [nvarchar](50) NULL,
	[BrokerID] [bigint] NULL,
	[PatrolPumpID] [bigint] NULL,
	[OrderID] [bigint] NULL,
	[VehicleRegNo] [nvarchar](50) NULL,
	[BankID] [bigint] NULL,
	[ChequeNo] [nvarchar](50) NULL,
	[Amount] [float] NULL,
	[ReceivedBy] [nvarchar](100) NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [date] NULL,
	[ModifiedBy] [bigint] NULL,
	[ModifiedDate] [datetime] NULL,
	[isPayed] [bit] NULL,
 CONSTRAINT [PK_Vouchers] PRIMARY KEY CLUSTERED 
(
	[VoucherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[AllContainerType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AllContainerType] AS SELECT ContainerTypeID,ContainerType FROM ContainerType



GO
/****** Object:  View [dbo].[AllDamageType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AllDamageType] AS SELECT DamageTypeID,Name FROM DamageType



GO
/****** Object:  View [dbo].[AllDocument]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AllDocument] AS SELECT DocumentTypeID,Name FROM DocumentType



GO
/****** Object:  View [dbo].[AllExpense]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AllExpense] AS SELECT ExpensesTypeID,ExpensesTypeName FROM ExpensesType



GO
/****** Object:  View [dbo].[AllVehicles]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AllVehicles] AS SELECT VehicleTypeID,VehicleTypeName FROM VehicleType



GO
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_GroupID]  DEFAULT ((0)) FOR [GroupID]
GO
ALTER TABLE [dbo].[ContainerDropOption] ADD  CONSTRAINT [DF_ContainerDropOption_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_LowerDeckInnerLenght]  DEFAULT ((0.0)) FOR [LowerDeckInnerLength]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_LowerDeckInnerWidth]  DEFAULT ((0.0)) FOR [LowerDeckInnerWidth]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_LowerDeckInnerHeight]  DEFAULT ((0.0)) FOR [LowerDeckInnerHeight]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_UperDeckInnerLength]  DEFAULT ((0.0)) FOR [UpperDeckInnerLength]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_UpperDeckInnerWidth]  DEFAULT ((0.0)) FOR [UpperDeckInnerWidth]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_UpperDeckInnerHeight]  DEFAULT ((0.0)) FOR [UpperDeckInnerHeight]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_LowerDeckOuterLength]  DEFAULT ((0.0)) FOR [LowerDeckOuterLength]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_LowerDeckOuterWidth]  DEFAULT ((0.0)) FOR [LowerDeckOuterWidth]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_LowerDeckOuterHeight]  DEFAULT ((0.0)) FOR [LowerDeckOuterHeight]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_UpperDeckOuterLength]  DEFAULT ((0.0)) FOR [UpperDeckOuterLength]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_UpperDeckOuterWidth]  DEFAULT ((0.0)) FOR [UpperDeckOuterWidth]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_UpperDeckOuterHeight]  DEFAULT ((0.0)) FOR [UpperDeckOuterHeight]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_UpperPortionInnerLength]  DEFAULT ((0.0)) FOR [UpperPortionInnerLength]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_UpperPortionInnerwidth]  DEFAULT ((0.0)) FOR [UpperPortionInnerwidth]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_UpperPortionInnerHeight]  DEFAULT ((0.0)) FOR [UpperPortionInnerHeight]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_LowePortionInnerLength]  DEFAULT ((0.0)) FOR [LowerPortionInnerLength]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_LowerPortionInnerWidth]  DEFAULT ((0.0)) FOR [LowerPortionInnerWidth]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_LowerPortionInnerHeight]  DEFAULT ((0.0)) FOR [LowerPortionInnerHeight]
GO
ALTER TABLE [dbo].[ContainerType] ADD  CONSTRAINT [DF_ContainerType_TareWeightUnit]  DEFAULT ((0.0)) FOR [TareWeightUnit]
GO
ALTER TABLE [dbo].[CustomerProfileDetail] ADD  CONSTRAINT [DF_CustomerProfileDetail_Active]  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[DepartmentPerson] ADD  CONSTRAINT [DF_Person_GroupID]  DEFAULT ((0)) FOR [GroupID]
GO
ALTER TABLE [dbo].[DepartmentPerson] ADD  CONSTRAINT [DF_Person_CompanyID]  DEFAULT ((0)) FOR [CompanyID]
GO
ALTER TABLE [dbo].[DepartmentPerson] ADD  CONSTRAINT [DF_Table_1_Department]  DEFAULT ((0)) FOR [DepartmentID]
GO
ALTER TABLE [dbo].[DepartmentPerson] ADD  CONSTRAINT [DF_Person_IsIndividual]  DEFAULT ((0)) FOR [IsIndividual]
GO
ALTER TABLE [dbo].[DepartmentPerson] ADD  CONSTRAINT [DF_Person_Active]  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[InquiryAndOrders] ADD  CONSTRAINT [DF_InquiryAndOrders_AssessmentReponse]  DEFAULT ((0)) FOR [AssessmentReponse]
GO
ALTER TABLE [dbo].[InquiryAndOrders] ADD  CONSTRAINT [DF_InquiryAndOrders_OrderPlacment]  DEFAULT ((0)) FOR [OrderPlacment]
GO
ALTER TABLE [dbo].[InquiryAndOrders] ADD  CONSTRAINT [DF_Inquiry_Or_Orders_Is_Forward]  DEFAULT ((0)) FOR [IsForward]
GO
ALTER TABLE [dbo].[InquiryAndOrders] ADD  CONSTRAINT [DF_Inquiry_Or_Orders_Is_ResponseBackToCustomer]  DEFAULT ((0)) FOR [IsResponseBackToCustomer]
GO
ALTER TABLE [dbo].[InquiryAndOrders] ADD  CONSTRAINT [DF_Inquiry_Or_Orders_Is_InquiryToOrder]  DEFAULT ((0)) FOR [IsInquiryToOrder]
GO
ALTER TABLE [dbo].[InquiryAndOrders] ADD  CONSTRAINT [DF_Inquiry_Or_Orders_Is_Complete]  DEFAULT ((0)) FOR [IsComplete]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_Assessment_ContainerExportOrImport_ShipmentTypeId]  DEFAULT ((0)) FOR [ShipmentTypeId]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_Assessment_ContainerExportOrImport_ContainerTypeQuantity]  DEFAULT ((0)) FOR [ContainerTypeQuantity]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_Assessment_ContainerExportOrImport_TotalWeight]  DEFAULT ((0.0)) FOR [TotalWeight]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_Assessment_ContainerExportOrImport_ExportCargoPickLocationID]  DEFAULT ((0)) FOR [ExportCargoPickLocationID]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_InquiryAndOrdersDetail_Status]  DEFAULT (N'OPN') FOR [Status]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_InquiryAndOrdersDetail_Length]  DEFAULT ((0)) FOR [Length]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_InquiryAndOrdersDetail_Width]  DEFAULT ((0)) FOR [Width]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_InquiryAndOrdersDetail_Height]  DEFAULT ((0)) FOR [Height]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_InquiryAndOrdersDetail_LoadQuantityWise]  DEFAULT ((0)) FOR [LoadQuantityWise]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_InquiryAndOrdersDetail_LoadWeightWise]  DEFAULT ((0)) FOR [LoadWeightWise]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_InquiryAndOrdersDetail_Expenses_on_Consignment]  DEFAULT ((0.00)) FOR [Expenses_on_Consignment]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_InquiryAndOrdersDetail_Profit]  DEFAULT ((0.00)) FOR [Profit]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_InquiryAndOrdersDetail_Other_Charges]  DEFAULT ((0.00)) FOR [Other_Charges]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_InquiryAndOrdersDetail_Tax]  DEFAULT ((0.00)) FOR [Tax]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_InquiryAndOrdersDetail_Total]  DEFAULT ((0.00)) FOR [Total]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_ContainerExportOrImport_VehicleTypeId]  DEFAULT ((0)) FOR [VehicleTypeId]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_Assessment_ContainerExportOrImport_VehicleID]  DEFAULT ((0)) FOR [VehicleID]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_Assessment_ContainerExportOrImport_DriverID]  DEFAULT ((0)) FOR [DriverID]
GO
ALTER TABLE [dbo].[InquiryAndOrdersDetail] ADD  CONSTRAINT [DF_Assessment_ContainerExportOrImport_BrokerID]  DEFAULT ((0)) FOR [BrokerID]
GO
ALTER TABLE [dbo].[InvoiceExpenseType] ADD  CONSTRAINT [DF_InvoiceExpenseType_Active]  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[NavMenu] ADD  CONSTRAINT [DF_NavMenu_Active]  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[NavMenu] ADD  CONSTRAINT [DF_NavMenu_ParentID]  DEFAULT ((0)) FOR [MenuID]
GO
ALTER TABLE [dbo].[NavMenu] ADD  CONSTRAINT [DF_NavMenu_Target]  DEFAULT (N'Self') FOR [formTarget]
GO
ALTER TABLE [dbo].[OrderDetail] ADD  CONSTRAINT [DF_OrderDetail_BiltyNo]  DEFAULT ((0)) FOR [BiltyNo]
GO
ALTER TABLE [dbo].[OrderDetail] ADD  CONSTRAINT [DF_OrderDetail_ManualBiltyNo]  DEFAULT ((0)) FOR [ManualBiltyNo]
GO
ALTER TABLE [dbo].[OrderDetail] ADD  CONSTRAINT [DF_OrderDetail_ShipmentType]  DEFAULT ((0)) FOR [ShipmentTypeId]
GO
ALTER TABLE [dbo].[OrderDetail] ADD  CONSTRAINT [DF_OrderDetail_BrokerId]  DEFAULT ((0)) FOR [BrokerId]
GO
ALTER TABLE [dbo].[OrderDetail] ADD  CONSTRAINT [DF_OrderDetail_ParentId]  DEFAULT ((0)) FOR [ParentId]
GO
ALTER TABLE [dbo].[OrderDetail] ADD  CONSTRAINT [DF_OrderDetail_LocalFreight]  DEFAULT ((0)) FOR [LocalFreight]
GO
ALTER TABLE [dbo].[OrderDocument] ADD  CONSTRAINT [DF_OrderDocument_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[OrderDocument] ADD  CONSTRAINT [DF_OrderDocument_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[OrderExpenses] ADD  CONSTRAINT [DF_OrderExpenses_Amount]  DEFAULT ((0.0)) FOR [Amount]
GO
ALTER TABLE [dbo].[OrderExpenses] ADD  CONSTRAINT [DF_OrderExpenses_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[OrderExpenses] ADD  CONSTRAINT [DF_OrderExpenses_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[OrderPackageTypes] ADD  CONSTRAINT [DF_OrderPackageTypes_CreatedBy]  DEFAULT ((0)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[OrderPackageTypes] ADD  CONSTRAINT [DF_OrderPackageTypes_ModifiedBy]  DEFAULT ((0)) FOR [ModifiedBy]
GO
ALTER TABLE [dbo].[Product_WASTE] ADD  CONSTRAINT [DF_ProductName_Active]  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[ReportsType] ADD  CONSTRAINT [DF_ReportsType_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[ShipmentType] ADD  CONSTRAINT [DF_ShipmentType_Active]  DEFAULT ((0)) FOR [Active]
GO
ALTER TABLE [dbo].[UserAccounts] ADD  CONSTRAINT [DF_UserAccounts_GroupID]  DEFAULT ((0)) FOR [GroupID]
GO
ALTER TABLE [dbo].[UserAccounts] ADD  CONSTRAINT [DF_UserAccounts_CompanyID]  DEFAULT ((0)) FOR [CompanyID]
GO
ALTER TABLE [dbo].[UserAccounts] ADD  CONSTRAINT [DF_UserAccounts_DepartmentID]  DEFAULT ((0)) FOR [DepartmentID]
GO
ALTER TABLE [dbo].[VehicleParts] ADD  CONSTRAINT [DF_VehicleParts_Status]  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_LowerDeckInnerLength]  DEFAULT ((0.0)) FOR [LowerDeckInnerLength]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_LowerDeckInnerWidth]  DEFAULT ((0.0)) FOR [LowerDeckInnerWidth]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_LowerDeckInnerHeight]  DEFAULT ((0.0)) FOR [LowerDeckInnerHeight]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_UperDeckInnerLength]  DEFAULT ((0.0)) FOR [UpperDeckInnerLength]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_UpperDeckInnerWidth]  DEFAULT ((0.0)) FOR [UpperDeckInnerWidth]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_UpperDeckInnerHeight]  DEFAULT ((0.0)) FOR [UpperDeckInnerHeight]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_LowerDeckOuterLength]  DEFAULT ((0.0)) FOR [LowerDeckOuterLength]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_LowerDeckOuterWidth]  DEFAULT ((0.0)) FOR [LowerDeckOuterWidth]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_LowerDeckOuterHeight]  DEFAULT ((0.0)) FOR [LowerDeckOuterHeight]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_UpperDeckOuterLength]  DEFAULT ((0.0)) FOR [UpperDeckOuterLength]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_UpperDeckOuterWidth]  DEFAULT ((0.0)) FOR [UpperDeckOuterWidth]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_UpperDeckOuterHeight]  DEFAULT ((0.0)) FOR [UpperDeckOuterHeight]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_UpperPortionInnerLength]  DEFAULT ((0.0)) FOR [UpperPortionInnerLength]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_UpperPortionInnerwidth]  DEFAULT ((0.0)) FOR [UpperPortionInnerwidth]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_UpperPortionInnerHeight]  DEFAULT ((0.0)) FOR [UpperPortionInnerHeight]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_LowePortionInnerLength]  DEFAULT ((0.0)) FOR [LowerPortionInnerLength]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_LowerPortionInnerWidth]  DEFAULT ((0.0)) FOR [LowerPortionInnerWidth]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_LowerPortionInnerHeight]  DEFAULT ((0.0)) FOR [LowerPortionInnerHeight]
GO
ALTER TABLE [dbo].[VehicleType] ADD  CONSTRAINT [DF_VehicleType_PermisibleHeight]  DEFAULT ((0.0)) FOR [PermisibleHeight]
GO
/****** Object:  StoredProcedure [dbo].[City_DeleteCityByCityID]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<fayyaz Ali>
-- Create date: <29062012>
-- Modify Date: <()>
-- Description:	< Delete record from City by CityID>
-- =============================================
CREATE PROCEDURE [dbo].[City_DeleteCityByCityID]
(
@CityID  bigint
)
AS

BEGIN
	DELETE 
	
	FROM	City
	
	WHERE	 CityID	=		@CityID 
	
	SELECT @@ROWCOUNT 'AS ROWCNT'
	
END




GO
/****** Object:  StoredProcedure [dbo].[City_GetAllCitiesIDAndName]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[City_GetAllCitiesIDAndName]
	
AS

BEGIN

SELECT CityID,CityName FROM City


END




GO
/****** Object:  StoredProcedure [dbo].[City_GetAllCitiesIDAndNameByProviceID]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[City_GetAllCitiesIDAndNameByProviceID]
(
@ProvinceID bigint
)	
AS

BEGIN

SELECT 

	C.CityID,C.CityName 
	FROM City C

	JOIN Province P ON
	P.ProvinceID=C.ProvinceID
	
	WHERE C.ProvinceID = @ProvinceID

END




GO
/****** Object:  StoredProcedure [dbo].[City_GetAllCity]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Naveed>
-- Create date: <29062012>
-- Modified date: <()>
-- Description:	<This stored procedure gets all records from City table>
-- =============================================
CREATE PROCEDURE		[dbo].[City_GetAllCity]
	
AS
BEGIN
	
	SELECT		
	
	c.[CityID]			,c.[CityCode]			,c.[CityName]			,c.[ProvinceID]	,	p.[ProvinceName], 
	cn.CountryID		,cn.CountryName			,c.[Description]		,c.[DateCreated],
    c.[DateModified]    ,c.[CreatedByUserID]	,c.[ModifiedByUserID]   ,c.[IsActive]
	
	FROM		City c
	
	JOIN Province p ON 
	p.ProvinceID=c.ProvinceID
	
	JOIN Country cn on
	cn.CountryID = p.CountryID

	ORDER BY	p.ProvinceName ASC
	
	
END




GO
/****** Object:  StoredProcedure [dbo].[City_GetAllProvinceAndCity]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[City_GetAllProvinceAndCity]

AS
BEGIN

	SELECT   
	
	p.ProvinceName,c.CityName,c.CityID
	
	FROM City c
	
	JOIN Province p on
	c.ProvinceID=p.ProvinceID
	
	

END




GO
/****** Object:  StoredProcedure [dbo].[City_GetCitiesByKeyword]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Fayyaz Ali>
-- Create date: <30062012>
-- Description:	<Through this Procedure we get all Areas By AreaID>
-- =============================================
CREATE PROCEDURE	[dbo].[City_GetCitiesByKeyword]
(
	@Keyword		nvarchar(50)
)

AS

BEGIN

	SELECT		
	
	c.[CityID]			,c.[CityCode]			,c.[CityName]			,c.[ProvinceID]	,	p.[ProvinceName], 
	cn.CountryID		,cn.CountryName			,c.[Description]		,c.[DateCreated],
    c.[DateModified]    ,c.[CreatedByUserID]	,c.[ModifiedByUserID]   ,c.[IsActive]
	
	FROM		City c
	
	JOIN Province p ON 
	p.ProvinceID=c.ProvinceID
	
	JOIN Country cn on
	cn.CountryID = p.CountryID
	
	WHERE	
	c.[CityCode]	LIKE '%' +	@Keyword + '%' OR
	c.[CityName]	LIKE '%' +	@Keyword + '%' OR
	p.[ProvinceName]		LIKE '%' +	@Keyword + '%' OR
	cn.CountryName		LIKE '%' +	@Keyword + '%' OR
	c.[Description] LIKE '%' +  @Keyword + '%'
END




GO
/****** Object:  StoredProcedure [dbo].[City_GetCityByCityID]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Fayyaz Ali>
-- Create date: <30062012>
-- Description:	<Through this Procedure we get all Areas By AreaID>
-- =============================================
CREATE PROCEDURE	[dbo].[City_GetCityByCityID]
(
	@CityID		bigint
)

AS

BEGIN

	SELECT		
	
	c.[CityID]			,c.[CityCode]			,c.[CityName]			,c.[ProvinceID]	,	p.[ProvinceName], 
	cn.CountryID		,cn.CountryName			,c.[Description]		,c.[DateCreated],
    c.[DateModified]    ,c.[CreatedByUserID]	,c.[ModifiedByUserID]   ,c.[IsActive]
	
	FROM		City c
	
	JOIN Province p ON 
	p.ProvinceID=c.ProvinceID
	
	JOIN Country cn on
	cn.CountryID = p.CountryID
	
	WHERE	c.CityID	=	@CityID
	
END




GO
/****** Object:  StoredProcedure [dbo].[City_GetDuplicateCity]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Naveed>
-- Create date: <29062012>
-- Modified date: <()>
-- Description:	<This stored procedure gets all records from City table>
-- =============================================
CREATE PROCEDURE		[dbo].[City_GetDuplicateCity]
	(@Code nvarchar(15), @Name nvarchar(15))
AS
BEGIN
	
	SELECT		
	
	c.[CityID]			,c.[CityCode]			,c.[CityName]			,c.[ProvinceID]	,	p.[ProvinceName], 
	cn.CountryID		,cn.CountryName			,c.[Description]		,c.[DateCreated],
    c.[DateModified]    ,c.[CreatedByUserID]	,c.[ModifiedByUserID]   ,c.[IsActive]
	
	FROM		City c
	
	JOIN Province p ON 
	p.ProvinceID=c.ProvinceID
	
	JOIN Country cn on
	cn.CountryID = p.CountryID

	WHERE c.CityCode = @Code OR c.CityName = @Name

	ORDER BY	p.ProvinceName ASC
	
	
END




GO
/****** Object:  StoredProcedure [dbo].[City_InsertCity]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Naveed>
-- Create date: <29062012>
-- Modified date: <()>
-- Description:	<Insert CityCode, CityName, Description, DateCreated, CreatedByUserID, and IsActive in City>
-- =============================================
CREATE PROCEDURE [dbo].[City_InsertCity]
(
	@CityCode			varchar(50),
	@CityName			varchar(50),
	@ProvinceID			bigint,
	@Description		varchar(50),
	@CreatedByUserID	bigint,
	@IsActive			bit
)	
AS
BEGIN
	
	INSERT INTO			City
	(
		CityCode,
		CityName,
		ProvinceID,
		[Description],
		DateCreated,
		CreatedByUserID,
		IsActive
	)
	
	VALUES
	(
		@CityCode,
		@CityName,
		@ProvinceID,
		@Description,
		GETDATE(),
		@CreatedByUserID,
		@IsActive
	)
	
	SELECT		@@IDENTITY		AS		'ID'
	
END




GO
/****** Object:  StoredProcedure [dbo].[City_UpdateCity]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Naveed>
-- Create date: <02072012>
-- Modify date: <()>
-- Description:	<Update CityCode, CityName, Description, DateModified, ModifiedByUserID and IsActive in City table>
-- =============================================
CREATE PROCEDURE [dbo].[City_UpdateCity]
(
	@CityID		bigint,
	@CityCode	varchar(50),
	@CityName	varchar(50),
	@Description	varchar(50),
	@ModifiedByUserID	bigint,
	@IsActive		bit
)

AS
BEGIN

	UPDATE		City
	
	SET		CityCode			=	@CityCode,
			CityName			=	@CityName,
			[Description]		=	@Description,
			DateModified		=	GETDATE(),
			ModifiedByUserID	=	@ModifiedByUserID,
			IsActive			=	@IsActive
	
	WHERE	CityID	=	@CityID
	
	SELECT		@@ROWCOUNT		AS		'ROWCNT'
	
END




GO
/****** Object:  StoredProcedure [dbo].[GenerateTriggers]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  

CREATE PROC [dbo].[GenerateTriggers]  

 @Schemaname Sysname = 'dbo'  

,@Tablename  Sysname  

,@GenerateScriptOnly    bit = 1 

,@ForceDropAuditTable   bit = 0 

,@IgnoreExistingColumnMismatch   bit = 0 

,@DontAuditforUsers NVARCHAR(4000) =  ''

,@DontAuditforColumns NVARCHAR(4000) =  ''

AS  

   

SET NOCOUNT ON  

   

/*  

Parameters   

@Schemaname            - SchemaName to which the table belongs to. Default value 'dbo'.  

@Tablename            - TableName for which the procs needs to be generated.  

@GenerateScriptOnly - When passed 1 , this will generate the scripts alone..  

                      When passed 0 , this will create the audit tables and triggers in the current database.  

                      Default value is 1  

@ForceDropAuditTable - When passed 1 , will drop the audit table and recreate

                       When passed 0 , will generate the alter scripts

                       Default value is 0

@IgnoreExistingColumnMismatch - When passed 1 , will not stop with the error on the mismatch of existing column and will create the trigger.

                                When passed 0 , will stop with the error on the mismatch of existing column.

                                Default value is 0

@DontAuditforUsers - Pass the UserName as comma seperated for whom the audit is not required.

                              Default value is '' which will do audit for all the users.

 

@DontAuditforColumns - Pass the ColumnNames as comma seperated for which the audit is not required.

      Default value is '' which will do audit for all the users.

*/  

   

DECLARE @SQL VARCHAR(MAX)  

DECLARE @SQLTrigger VARCHAR(MAX)  

DECLARE @ErrMsg VARCHAR(MAX)

  

 

DECLARE @AuditTableName SYSNAME  

DECLARE @QuotedSchemaName SYSNAME

DECLARE @QuotedTableName SYSNAME

DECLARE @QuotedAuditTableName SYSNAME

DECLARE @InsertTriggerName SYSNAME

DECLARE @UpdateTriggerName SYSNAME

DECLARE @DeleteTriggerName SYSNAME

DECLARE @QuotedInsertTriggerName SYSNAME

DECLARE @QuotedUpdateTriggerName SYSNAME

DECLARE @QuotedDeleteTriggerName SYSNAME

DECLARE @DontAuditforUsersTmp NVARCHAR(4000)

 

SELECT @AuditTableName =  @Tablename + '_Audit'  

SELECT @QuotedSchemaName = QUOTENAME(@Schemaname)

SELECT @QuotedTableName = QUOTENAME(@Tablename)

SELECT @QuotedAuditTableName = QUOTENAME(@AuditTableName)

SELECT @InsertTriggerName = @Tablename + '_Insert' 

SELECT @UpdateTriggerName = @Tablename + '_Update' 

SELECT @DeleteTriggerName = @Tablename + '_Delete' 

SELECT @QuotedInsertTriggerName = QUOTENAME(@InsertTriggerName)

SELECT @QuotedUpdateTriggerName = QUOTENAME(@UpdateTriggerName)

SELECT @QuotedDeleteTriggerName = QUOTENAME(@DeleteTriggerName)

 

IF LTRIM(RTRIM(@DontAuditforUsers)) <> ''

BEGIN

 

      IF RIGHT(@DontAuditforUsers,1) = ','

      BEGIN

            SELECT @DontAuditforUsersTmp = LEFT(@DontAuditforUsers,LEN(@DontAuditforUsers) -1)

      END

      ELSE

      BEGIN

            SELECT @DontAuditforUsersTmp = @DontAuditforUsers

      END

     

      SELECT @DontAuditforUsersTmp = REPLACE(@DontAuditforUsersTmp,',',''',''')

 

END

 

 

SELECT @DontAuditforColumns =',' + UPPER(@DontAuditforColumns) + ','

 

IF NOT EXISTS (SELECT 1   

             FROM sys.objects   

            WHERE Name= @TableName  

              AND Schema_id=Schema_id(@Schemaname)  

              AND Type = 'U')

BEGIN

      SELECT @ErrMsg = @QuotedSchemaName + '.' + @QuotedTableName + ' Table Not Found '

      RAISERROR(@ErrMsg ,16,1)

      RETURN

END

 

  

----------------------------------------------------------------------------------------------------------------------  

-- Audit Create OR Alter table   

----------------------------------------------------------------------------------------------------------------------  

  

DECLARE @ColList VARCHAR(MAX) 

DECLARE @InsertColList VARCHAR(MAX) 

DECLARE @UpdateCheck VARCHAR(MAX) 

 

DECLARE @NewAddedCols TABLE

(

 ColumnName SYSNAME

,DataType   SYSNAME

,CharLength INT

,Collation  SYSNAME NULL

,ChangeType VARCHAR(20) NULL

,MainTableColumnName SYSNAME  NULL

,MainTableDataType   SYSNAME  NULL

,MainTableCharLength INT  NULL

,MainTableCollation SYSNAME  NULL

,AuditTableColumnName SYSNAME  NULL

,AuditTableDataType   SYSNAME  NULL

,AuditTableCharLength INT  NULL

,AuditTableCollation SYSNAME  NULL

)

 

  

SELECT @ColList = '' 

SELECT @UpdateCheck = ' ' 

SELECT @SQL = ''

SELECT @InsertColList = ''

 

 

SELECT @ColList = @ColList +   CASE SC.is_identity 

                                           WHEN 1 THEN 'CONVERT(' + ST.name + ',' + QUOTENAME(SC.name) + ') as ' + QUOTENAME(SC.name) 

                                           ELSE QUOTENAME(SC.name) 

                                           END + ',' 

                        , @InsertColList = @InsertColList + QUOTENAME(SC.name) + ','

                ,  @UpdateCheck = @UpdateCheck +

                                                  CASE

                                                  WHEN CHARINDEX(',' + UPPER(SC.NAME) + ',',@DontAuditforColumns) = 0 THEN 'CASE WHEN UPDATE(' + QUOTENAME(SC.name) + ') THEN ''' + QUOTENAME(SC.name) + '-'' ELSE '''' END + ' +  CHAR(10) 

                                                  ELSE ''

                                                  END

              FROM SYS.COLUMNS SC 

              JOIN SYS.OBJECTS SO 

                ON SC.object_id = SO.object_id    

              JOIN SYS.schemas SCH 

                ON SCH.schema_id = SO.schema_id 

              JOIN SYS.types ST 

                ON ST.user_type_id = SC.user_type_id 

               AND ST.system_type_id = SC.system_type_id  

             WHERE SCH.Name = @Schemaname  

               AND SO.name  = @Tablename  

               AND UPPER(ST.name)  <> UPPER('timestamp') 

  

            SELECT @ColList = SUBSTRING(@ColList,1,LEN(@ColList)-1) 

                  SELECT @UpdateCheck = SUBSTRING(@UpdateCheck,1,LEN(@UpdateCheck)-3) 

                  SELECT @InsertColList = SUBSTRING(@InsertColList,1,LEN(@InsertColList)-1) 

 

            SELECT @InsertColList = @InsertColList + ',AuditDataState,AuditDMLAction,AuditUser,AuditDateTime,UpdateColumns'

 

IF EXISTS (SELECT 1   

             FROM sys.objects   

            WHERE Name= @AuditTableName  

              AND Schema_id=Schema_id(@Schemaname)  

              AND Type = 'U')  AND @ForceDropAuditTable = 0

 BEGIN

 

            ----------------------------------------------------------------------------------------------------------------------  

            -- Get the comparision metadata for Main and Audit Tables

            ----------------------------------------------------------------------------------------------------------------------  

 

            INSERT INTO @NewAddedCols

            (ColumnName,DataType,CharLength,Collation,ChangeType,MainTableColumnName

            ,MainTableDataType,MainTableCharLength,MainTableCollation,AuditTableColumnName,AuditTableDataType,AuditTableCharLength,AuditTableCollation)

            SELECT ISNULL(MainTable.ColumnName,AuditTable.ColumnName)

                  ,ISNULL(MainTable.DataType,AuditTable.DataType)

                  ,ISNULL(MainTable.CharLength,AuditTable.CharLength)

                  ,ISNULL(MainTable.Collation,AuditTable.Collation)

                  ,CASE 

                   WHEN MainTable.ColumnName IS NULL THEN 'Deleted'

                   WHEN AuditTable.ColumnName IS NULL THEN 'Added'

                   ELSE NULL

                   END 

                  ,MainTable.ColumnName

                  ,MainTable.DataType

                  ,MainTable.CharLength

                  ,MainTable.Collation

                  ,AuditTable.ColumnName

                  ,AuditTable.DataType

                  ,AuditTable.CharLength

                  ,AuditTable.Collation

              FROM

     

            (

            SELECT SC.Name As ColumnName,ST.Name as DataType,SC.is_identity as isIdentity,SC.Max_length as CharLength,SC.Collation_Name as Collation

              FROM SYS.COLUMNS SC 

              JOIN SYS.OBJECTS SO 

                ON SC.object_id = SO.object_id    

              JOIN SYS.schemas SCH 

                ON SCH.schema_id = SO.schema_id 

              JOIN SYS.types ST 

                ON ST.user_type_id = SC.user_type_id 

               AND ST.system_type_id = SC.system_type_id  

             WHERE SCH.Name = @Schemaname  

               AND SO.name  = @Tablename  

               AND UPPER(ST.name)  <> UPPER('timestamp') 

            ) MainTable

            FULL OUTER JOIN

            (

            SELECT SC.Name As ColumnName,ST.Name as DataType,SC.is_identity as isIdentity,SC.Max_length as CharLength,SC.Collation_Name as Collation

              FROM SYS.COLUMNS SC 

              JOIN SYS.OBJECTS SO 

                ON SC.object_id = SO.object_id    

              JOIN SYS.schemas SCH 

                ON SCH.schema_id = SO.schema_id 

              JOIN SYS.types ST 

                ON ST.user_type_id = SC.user_type_id 

               AND ST.system_type_id = SC.system_type_id  

             WHERE SCH.Name = @Schemaname  

               AND SO.name  = @AuditTableName  

               AND UPPER(ST.name)  <> UPPER('timestamp') 

               AND SC.Name NOT IN ('AuditDataState','AuditDMLAction','AuditUser','AuditDateTime','UpdateColumns')

            ) AuditTable

            ON MainTable.ColumnName = AuditTable.ColumnName

          

         ----------------------------------------------------------------------------------------------------------------------  

        -- Find data type changes between table

        ----------------------------------------------------------------------------------------------------------------------  

 

            IF EXISTS ( SELECT * FROM @NewAddedCols NC

                         WHERE NC.MainTableColumnName = NC.AuditTableColumnName

                           AND (

                               NC.MainTableDataType   <> NC.AuditTableDataType

                               OR

                               NC.MainTableCharLength  > NC.AuditTableCharLength

                               OR

                               NC.MainTableCollation  <> NC.AuditTableCollation

                               )

                )

            BEGIN

                SELECT CONVERT(VARCHAR(50),

                           CASE

                           WHEN NC.MainTableDataType   <> NC.AuditTableDataType   THEN 'DataType Mismatch'

                           WHEN NC.MainTableCharLength  > NC.AuditTableCharLength THEN 'Length in maintable is greater than Audit Table'

                           WHEN NC.MainTableCollation  <> NC.AuditTableCollation  THEN 'Collation Difference'

                           END) AS Mismatch

                      ,NC.MainTableColumnName

                      ,NC.MainTableDataType

                      ,NC.MainTableCharLength

                      ,NC.MainTableCollation

                      ,NC.AuditTableColumnName

                      ,NC.AuditTableDataType

                      ,NC.AuditTableCharLength

                      ,NC.AuditTableCollation

                  FROM @NewAddedCols NC

                 WHERE NC.MainTableColumnName = NC.AuditTableColumnName

                   AND (

                       NC.MainTableDataType   <> NC.AuditTableDataType

                       OR

                       NC.MainTableCharLength  > NC.AuditTableCharLength

                       OR

                       NC.MainTableCollation  <> NC.AuditTableCollation

                       )

 

                RAISERROR('There are differences in Datatype or Lesser Length or Collation difference between the Main table and Audit Table. Please refer the output',16,1)

                IF @IgnoreExistingColumnMismatch = 0

                BEGIN

                    RETURN

                END

            END

 

        ----------------------------------------------------------------------------------------------------------------------  

        -- Find the new and deleted columns 

        ----------------------------------------------------------------------------------------------------------------------  

 

          IF EXISTS(SELECT * FROM @NewAddedCols WHERE ChangeType IS NOT NULL)

          BEGIN

 

                SELECT @SQL = @SQL +   'ALTER TABLE ' + @QuotedSchemaName + '.' + @QuotedAuditTableName 

                                   + CASE

                                     WHEN NC.ChangeType ='Added' THEN ' ADD '  + QUOTENAME(NC.ColumnName) + ' ' + NC.DataType + ' ' 

                                     +  CASE 

                                        WHEN NC.DataType IN ('char','varchar','nchar','nvarchar') AND NC.CharLength = -1 THEN '(max) COLLATE ' + NC.Collation + ' NULL '

                                        WHEN NC.DataType IN ('char','varchar') THEN '(' + CONVERT(VARCHAR(5),NC.CharLength) + ') COLLATE ' + NC.Collation + ' NULL '

                                        WHEN NC.DataType IN ('nchar','nvarchar') THEN '(' + CONVERT(VARCHAR(5),NC.CharLength/2) + ') COLLATE ' + NC.Collation + ' NULL '

                                        ELSE ''

                                        END

                                     WHEN NC.ChangeType ='Deleted' THEN ' DROP COLUMN '  + QUOTENAME(NC.ColumnName) 

                                     END + CHAR(10)

                                      

                  FROM @NewAddedCols NC

                  WHERE NC.ChangeType IS NOT NULL

          END

 

 

 END

 ELSE

 BEGIN

  

            SELECT @SQL = '  IF EXISTS (SELECT 1   

                                                              FROM sys.objects   

                                                           WHERE Name=''' + @AuditTableName + '''  

                                                               AND Schema_id=Schema_id(''' + @Schemaname + ''')  

                                                               AND Type = ''U'')   

                                          DROP TABLE ' + @QuotedSchemaName + '.' + @QuotedAuditTableName + '

 

                    SELECT ' + @ColList + '  

                        ,AuditDataState=CONVERT(VARCHAR(10),'''')   

                        ,AuditDMLAction=CONVERT(VARCHAR(10),'''')    

                        ,AuditUser =CONVERT(SYSNAME,'''')  

                        ,AuditDateTime=CONVERT(DATETIME,''01-JAN-1900'')  

                        ,UpdateColumns = CONVERT(VARCHAR(MAX),'''') 

                        Into ' + @QuotedSchemaName + '.' + @QuotedAuditTableName + '  

                    FROM ' + @QuotedSchemaName + '.' + @QuotedTableName +'  

                    WHERE 1=2 '  

END

 

 

 

IF @GenerateScriptOnly = 1  

BEGIN  

    PRINT REPLICATE ('-',200)  

    PRINT '--Create \ Alter Script Audit table for ' + @QuotedSchemaName + '.' + @QuotedTableName  

    PRINT REPLICATE ('-',200)  

    PRINT @SQL  

    IF LTRIM(RTRIM(@SQL)) <> ''

    BEGIN

        PRINT 'GO' 

    END

    ELSE

    BEGIN

        PRINT '-- No changes in table structure'

    END 

END  

ELSE  

BEGIN  

    IF RTRIM(LTRIM(@SQL)) = ''

    BEGIN

        PRINT 'No Table Changes Found' 

    END

    ELSE

    BEGIN

        PRINT 'Creating \ Altered Audit table for ' + @QuotedSchemaName + '.' + @QuotedTableName  

        EXEC(@SQL)  

        PRINT 'Audit table ' + @QuotedSchemaName + '.' + @QuotedAuditTableName + ' Created \ Altered succesfully'  

    END

END  

   

   

----------------------------------------------------------------------------------------------------------------------  

-- Create Insert Trigger  

----------------------------------------------------------------------------------------------------------------------  

   

   

SELECT @SQL = '  

IF EXISTS (SELECT 1   

             FROM sys.objects   

            WHERE Name=''' + @Tablename + '_Insert' + '''  

              AND Schema_id=Schema_id(''' + @Schemaname + ''')  

              AND Type = ''TR'')  

DROP TRIGGER ' + @QuotedSchemaName + '.' + @QuotedInsertTriggerName   

SELECT @SQLTrigger = '  

CREATE TRIGGER '  + @QuotedSchemaName + '.' + @QuotedInsertTriggerName + '

ON '  + @QuotedSchemaName + '.' + @QuotedTableName + '  

FOR INSERT  

AS  

'

 

 

IF LTRIM(RTRIM(@DontAuditforUsersTmp)) <> ''

BEGIN

 

SELECT @SQLTrigger = @SQLTrigger + CHAR(10) + ' IF SUSER_NAME() NOT IN (''' + @DontAuditforUsersTmp + ''')'

SELECT @SQLTrigger = @SQLTrigger + CHAR(10) + ' BEGIN'

 

END

 

 

 

 

SELECT @SQLTrigger =  @SQLTrigger  + CHAR(10) + ' INSERT INTO ' + @QuotedSchemaName + '.' + @QuotedAuditTableName + CHAR(10) + 

 '(' + @InsertColList + ')' + CHAR(10) + 

 'SELECT ' + @ColList + ',''New'',''Insert'',SUSER_SNAME(),getdate(),''''  FROM INSERTED '  

 

IF LTRIM(RTRIM(@DontAuditforUsersTmp)) <> ''

BEGIN

 

      SELECT @SQLTrigger = @SQLTrigger + CHAR(10) + ' END'

 

END

 

  

IF @GenerateScriptOnly = 1  

BEGIN  

    PRINT REPLICATE ('-',200)  

    PRINT '--Create Script Insert Trigger for ' +  @QuotedSchemaName + '.' + @QuotedTablename  

    PRINT REPLICATE ('-',200)  

    PRINT @SQL  

    PRINT 'GO'  

    PRINT @SQLTrigger  

    PRINT 'GO'  

END  

ELSE  

BEGIN  

    PRINT 'Creating Insert Trigger ' + @QuotedInsertTriggerName + '  for ' + @QuotedSchemaName + '.' + @QuotedTablename  

    EXEC(@SQL)  

    EXEC(@SQLTrigger)  

    PRINT 'Trigger ' + @QuotedSchemaName + '.' + @QuotedInsertTriggerName  + ' Created succesfully'  

END  

   

   

----------------------------------------------------------------------------------------------------------------------  

-- Create Delete Trigger  

----------------------------------------------------------------------------------------------------------------------  

   

   

SELECT @SQL = '  

   

IF EXISTS (SELECT 1   

             FROM sys.objects   

            WHERE Name=''' + @Tablename + '_Delete' + '''  

              AND Schema_id=Schema_id(''' + @Schemaname + ''')  

              AND Type = ''TR'')  

DROP TRIGGER ' + @QuotedSchemaName + '.' + + @QuotedDeleteTriggerName + '  

'  

   

SELECT @SQLTrigger =   

'  

CREATE TRIGGER '  + @QuotedSchemaName + '.'  + @QuotedDeleteTriggerName + '  

ON '+ @QuotedSchemaName + '.' + @QuotedTableName + '  

FOR DELETE  

AS   '

 

IF LTRIM(RTRIM(@DontAuditforUsersTmp)) <> ''

BEGIN

 

SELECT @SQLTrigger = @SQLTrigger + CHAR(10) + ' IF SUSER_NAME() NOT IN (''' + @DontAuditforUsersTmp + ''')'

SELECT @SQLTrigger = @SQLTrigger + CHAR(10) + ' BEGIN'

 

END

 

 

 

SELECT @SQLTrigger = @SQLTrigger + CHAR(10) + '  INSERT INTO ' + @QuotedSchemaName + '.' + @QuotedAuditTableName + CHAR(10) + 

 '(' + @InsertColList + ')' + CHAR(10) + 

 'SELECT ' + @ColList + ',''Old'',''Delete'',SUSER_SNAME(),getdate(),''''  FROM DELETED'  

 

IF LTRIM(RTRIM(@DontAuditforUsersTmp)) <> ''

BEGIN

 

      SELECT @SQLTrigger = @SQLTrigger + CHAR(10) + ' END'

 

END

 

  

IF @GenerateScriptOnly = 1  

BEGIN  

    PRINT REPLICATE ('-',200)  

    PRINT '--Create Script Delete Trigger for ' + @QuotedSchemaName + '.' + @QuotedTableName  

    PRINT REPLICATE ('-',200)  

    PRINT @SQL  

    PRINT 'GO'  

    PRINT @SQLTrigger   

    PRINT 'GO'  

END  

ELSE  

BEGIN  

    PRINT 'Creating Delete Trigger ' + @QuotedDeleteTriggerName + '  for ' + @QuotedSchemaName + '.' + @QuotedTableName  

    EXEC(@SQL)  

    EXEC(@SQLTrigger)  

    PRINT 'Trigger ' + @QuotedSchemaName + '.' + @QuotedDeleteTriggerName + ' Created succesfully'  

END  

   

----------------------------------------------------------------------------------------------------------------------  

-- Create Update Trigger  

----------------------------------------------------------------------------------------------------------------------  

   

   

SELECT @SQL = '  

   

IF EXISTS (SELECT 1   

             FROM sys.objects   

            WHERE Name=''' + @Tablename + '_Update' + '''  

              AND Schema_id=Schema_id(''' + @Schemaname + ''')  

              AND Type = ''TR'')  

DROP TRIGGER ' + @QuotedSchemaName + '.' + @QuotedUpdateTriggerName + '  

'  

   

SELECT @SQLTrigger =  

'  

CREATE TRIGGER ' + @QuotedSchemaName + '.'  + @QuotedUpdateTriggerName + '    

ON '+ @QuotedSchemaName + '.' + @QuotedTableName + '  

FOR UPDATE  

AS '

 

IF LTRIM(RTRIM(@DontAuditforUsersTmp)) <> ''

BEGIN

 

SELECT @SQLTrigger = @SQLTrigger + CHAR(10) + ' IF SUSER_NAME() NOT IN (''' + @DontAuditforUsersTmp + ''')'

SELECT @SQLTrigger = @SQLTrigger + CHAR(10) + ' BEGIN'

 

END

 

 

 

SELECT @SQLTrigger = @SQLTrigger + CHAR(10) + ' 

 

      DECLARE @UpdatedCols varchar(max)

 

   SELECT @UpdatedCols = ' + @UpdateCheck + '

  

   IF LTRIM(RTRIM(@UpdatedCols)) <> ''''

   BEGIN

              INSERT INTO ' + @QuotedSchemaName + '.' + @QuotedAuditTableName + CHAR(10) + 

             '(' + @InsertColList + ')' + CHAR(10) + 

             'SELECT ' + @ColList +',''New'',''Update'',SUSER_SNAME(),getdate(),@UpdatedCols  FROM INSERTED   

   

              INSERT INTO ' + @QuotedSchemaName + '.' + @QuotedAuditTableName + CHAR(10) + 

             '(' + @InsertColList + ')' + CHAR(10) + 

             'SELECT ' + @ColList +',''Old'',''Update'',SUSER_SNAME(),getdate(),@UpdatedCols  FROM DELETED

   END'  

 

IF LTRIM(RTRIM(@DontAuditforUsersTmp)) <> ''

BEGIN

 

      SELECT @SQLTrigger = @SQLTrigger + CHAR(10) + ' END'

 

END

 

 

  

IF @GenerateScriptOnly = 1  

BEGIN  

    PRINT REPLICATE ('-',200)  

    PRINT '--Create Script Update Trigger for ' + @QuotedSchemaName + '.' + @QuotedTableName  

    PRINT REPLICATE ('-',200)  

    PRINT @SQL  

    PRINT 'GO'  

    PRINT @SQLTrigger  

    PRINT 'GO'  

END  

ELSE  

BEGIN  

    PRINT 'Creating Delete Trigger ' + @QuotedUpdateTriggerName + '  for ' + @QuotedSchemaName + '.' + @QuotedTableName  

    EXEC(@SQL)  

    EXEC(@SQLTrigger)  

    PRINT 'Trigger ' + @QuotedSchemaName + '.' + @QuotedUpdateTriggerName + '  Created succesfully'  

END  

   

SET NOCOUNT OFF  


GO
/****** Object:  StoredProcedure [dbo].[GET_DEPARTMENTBY_GROUPANDCOMPANYID]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[GET_DEPARTMENTBY_GROUPANDCOMPANYID] 
	@GROUPID	bigint,
	@COMPANYID	bigint
AS
BEGIN
	
	SELECT DepartID,DepartCode,DepartName FROM Department WHERE GROUPID=@GROUPID AND COMPANYID=@COMPANYID AND  ISACTIVE=1
END



GO
/****** Object:  StoredProcedure [dbo].[GETACTIVEGROUPS]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GETACTIVEGROUPS]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT * FROM GROUPS WHERE IsActive=1
END



GO
/****** Object:  StoredProcedure [dbo].[GETALLPERSON]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETALLPERSON] 
	
AS
BEGIN
	
	SELECT P.*,G.GroupName,C.CompanyName,D.DepartName  FROM DepartmentPerson P
	LEFT JOIN GROUPS G ON P.GroupID=G.GroupID
	LEFT JOIN COMPANY C ON P.CompanyID=C.CompanyID
	LEFT JOIN Department D ON P.DepartmentID=D.DepartID
	--WHERE P.Active=1
END



GO
/****** Object:  StoredProcedure [dbo].[GETCOMPANYBYGROUPID]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETCOMPANYBYGROUPID] 
	
	@GROUPID	bigint
AS
BEGIN
	
	SELECT c.CompanyName,c.CompanyID AS 'COMPANYID' FROM GROUPS G
	--CROSS APPLY dbo.splitstring(G.CompanyAccess, ',') AS htvf
	INNER JOIN Company C on G.GroupID=C.GroupID
	where  G.GroupID = @GROUPID
	ORDER BY C.COMPANYNAME 
END



GO
/****** Object:  StoredProcedure [dbo].[GetCompanyList]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCompanyList] 
	
AS
BEGIN
	SELECT C.*,G.GroupName,G.GroupCode FROM Company C
	LEFT JOIN GROUPS G on C.GroupID=G.GroupID
END



GO
/****** Object:  StoredProcedure [dbo].[GetCompanyUser]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[GetCompanyUser]
(
	@CompanyID	bigint
	
)
AS
BEGIN
	
	SELECT		CompanyUser.*,Company.CompanyName
	
	FROM		CompanyUser 
	
	INNER JOIN Company ON CompanyUser.COMPANYID = COMPANY.CompanyID

	WHERE  COMPANY.CompanyID = @CompanyID	
	
END



GO
/****** Object:  StoredProcedure [dbo].[GetCustomer]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomer] 
	
AS
BEGIN
	
	SELECT * from CUSTOMER
END



GO
/****** Object:  StoredProcedure [dbo].[GETDEPARTMENT]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETDEPARTMENT]
	
AS
BEGIN
 SELECT D.*,G.GroupName,C.CompanyName FROM DEPARTMENT D
 INNER JOIN GROUPS G  on D.GROUPID =G.GroupID
 INNER JOIN  COMPANY C on D.companyid=C.CompanyID

END



GO
/****** Object:  StoredProcedure [dbo].[GETGROUP]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GETGROUP] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT * FROM GROUPS
END



GO
/****** Object:  StoredProcedure [dbo].[LocationType_GetAllLocationType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LocationType_GetAllLocationType]
		
	
AS
BEGIN
	
	SELECT * FROM LocationType
	
END




GO
/****** Object:  StoredProcedure [dbo].[Owner_GetAllOwner]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Naveed>
-- Create date: <29062012>
-- Modified date: <()>
-- Description:	<This stored procedure gets all records from Owner table>
-- =============================================
CREATE PROCEDURE		[dbo].[Owner_GetAllOwner]
	
AS
BEGIN
	
	SELECT		*
	
	FROM		[Owner]
	
END



GO
/****** Object:  StoredProcedure [dbo].[PickDropLocation_GetRecordByCodeOrName]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Saqib Muneer>
-- Create date: <13th August 2013 10:23 AM>
-- Description:	<Get record by Code or Location Name to check duplication>
-- =============================================
CREATE PROCEDURE [dbo].[PickDropLocation_GetRecordByCodeOrName]
(
	@PickDropCode			varchar(50),
	@PickDropLocationName	varchar(100)
)
AS
BEGIN
	
	SELECT		PickDropCode,		PickDropLocationName
	
	FROM		PickDropLocation 
	
	
	WHERE		PickDropCode			=	@PickDropCode
				OR
				PickDropLocationName	=	@PickDropLocationName	
END




GO
/****** Object:  StoredProcedure [dbo].[PickDropLocation_InsertPickDropLocation]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Naveed>
-- Create date: <30062012>
-- Modify date: <()>
-- Description:	<Insert PickDropCode, CityID, AreaID, Address, LocationType, OwnerID, DateCreated,
--				CreatedByUserID, IsActive and Description in PickDropLocation>
-- =============================================
CREATE PROCEDURE [dbo].[PickDropLocation_InsertPickDropLocation]
(
	@PickDropCode			varchar(50),
	@AreaID					bigint,
	@Address				varchar(500),
	@OwnerID				bigint,
	@LocationTypeID			bigint,
	@CreatedByUserID		bigint,
	@IsActive				bit,
	@Description			varchar(500),
	@PickDropLocationName	varchar(100),
	@IsPort					bit
)

AS
BEGIN

	INSERT INTO		PickDropLocation
	(
		PickDropCode,
		AreaID,
		[Address],
		LocationTypeID,
		OwnerID,
		DateCreated,
		CreatedByUserID,
		IsActive,
		[Description],
		PickDropLocationName,
		IsPort
	)
	
	VALUES
	(
		@PickDropCode,
		@AreaID,
		@Address,
		@LocationTypeID,
		@OwnerID,
		GETDATE(),
		@CreatedByUserID,
		@IsActive,
		@Description,
		@PickDropLocationName,
		@IsPort
	)
	
	SELECT		@@IDENTITY		AS		'ID'
END




GO
/****** Object:  StoredProcedure [dbo].[PickDropLocation_UpdatePickDropLocation]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Naveed>
-- Create date: <03072012>
-- Modify date: <()>
-- Description:	<Update PickDropCode, CityID, AreaID, Address, LocationType, OwnerID,
--				DateModified, ModifiedByUserID, IsActive and Description in PickDropLocation table>
-- =============================================
CREATE PROCEDURE [dbo].[PickDropLocation_UpdatePickDropLocation]
(
	@PickDropID				bigint,
	@PickDropCode			varchar(50),
	@AreaID					bigint,
	@Address				varchar(500),
	@LocationTypeID			bigint,
	@OwnerID				bigint,
	@ModifiedByUserID		bigint,
	@IsActive				bit,
	@Description			varchar(500),
	@PickDropLocationName	varchar(100),
	@IsPort					bit
)

AS
BEGIN

	UPDATE		PickDropLocation
	
	SET		PickDropCode			=		@PickDropCode,
			AreaID					=		@AreaID,
			[Address]				=		@Address,
			LocationTypeID			=		@LocationTypeID,
			OwnerID					=		@OwnerID,
			DateModified			=		GETDATE(),
			ModifiedByUserID		=		@ModifiedByUserID,
			IsActive				=		@IsActive,
			[Description]			=		@Description,
			PickDropLocationName	=		@PickDropLocationName,
			IsPort					=		@IsPort
	
	WHERE	PickDropID	=	@PickDropID
	
	SELECT		@@ROWCOUNT		AS		'ROWCNT'
	
END




GO
/****** Object:  StoredProcedure [dbo].[Provinces_GetAllProvincesIDsAndName]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Naveed>
-- Create date: <29062012>
-- Modified date: <()>
-- Description:	<This stored procedure gets all records from City table>
-- =============================================
CREATE PROCEDURE		[dbo].[Provinces_GetAllProvincesIDsAndName]
	
AS
BEGIN
	
	SELECT		
	
	p.ProvinceID ,c.CountryName, p.ProvinceName
	
	FROM		Province p
	
	join Country c on
	c.CountryID = p.CountryID
	
	
	
END




GO
/****** Object:  StoredProcedure [dbo].[Provinces_GetAllProvincesIDsAndNameByCountryID]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Naveed>
-- Create date: <29062012>
-- Modified date: <()>
-- Description:	<This stored procedure gets all records from City table>
-- =============================================
CREATE PROCEDURE		[dbo].[Provinces_GetAllProvincesIDsAndNameByCountryID]
(
@CountryID bigint
)	
AS
BEGIN
	
	SELECT		
	
	Province.ProvinceID , Province.ProvinceName
	
	FROM		Province
	
	WHERE Province.CountryID = @CountryID
	
END




GO
/****** Object:  StoredProcedure [dbo].[Report1]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report1](
@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
							 @Customer_Id					bigint,
							 @DateFrom						date,
							 @DateTo						date,
							 @BiltyNo						nvarchar(max)
)

AS 
BEGIN

DECLARE @query nvarchar(max)

SET @query='SELECT ShipmentTypeDetail, DATE,BiltyNo,DA_No,Station,CustomerName,Name,SUM(Quantity) Quantity,'''' Name ,SUM(Amount) Amount,Rate,WeightPerUnit FROM (SELECT ShpType.ShipmentTypeDetail,convert(varchar, BiltyNoDate, 6)  Date  ,OD.BiltyNo,Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) SI ,OD.DA_No ,C.CityName Station,ISNULL(Company.CompanyName,CP.CustomerName) CustomerName,'''' name,OPT.Quantity,
CASE 
WHEN  UPPER(ShpType.ShipmentTypeDetail)=''Full Truck Load'' then  OD.Freight 
WHEN  UPPER(CPD.RateType)=''Lumsum'' then  OPT.UnitFreight*OPT.Quantity 
WHEN UPPER(CPD.RateType)=''Carton'' then OPT.UnitFreight*OPT.Quantity
WHEN UPPER(CPD.RateType)=''Kg'' then OPT.UnitFreight*OPT.Quantity*OPT.UnitWeight
WHEN UPPER(CPD.RateType)=''Unit'' then OPT.UnitFreight*OPT.Quantity
end ''Amount'',
CPD.Rate,''0'' WeightPerUnit
  FROM [Order] O
inner join orderdetail OD on O.orderid=OD.orderid
left join shipmenttype ShpType on OD.ShipmentTypeId=ShpType.ShipmentType_Id
inner join OrderLocations OL on OL.OrderDetailId=OD.OrderDetailId
inner join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
inner join CITY C on C.CityID=OL.DropLocationId
inner join CustomerProfile CP on o.CustomerCompanyId=CP.CustomerId
inner join CustomerProfileDetail CPD on CP.ProfileId=CPD.ProfileId and OL.PickupLocationId= CPD.LocationFrom and OL.DropLocationId = CPD.LocationTo
inner join Company  on o.CustomerCompanyId=Company.CompanyID
and  OL.PickupLocationId=CPD.LocationFrom and OL.DropLocationId=CPD.LocationTo and  CPD.ProductId=OPT.ItemId
	inner join Product P on CPD.ProductId = P.ID
	WHERE 

 
 
  OD.BiltyNo in ('+@BiltyNo+')) tabl
  GROUP BY tabl.ShipmentTypeDetail,tabl.BiltyNo,tabl.CustomerName,tabl.Rate,tabl.DA_No,tabl.Date,tabl.Station,tabl.WeightPerUnit,tabl.si,Name  order  by SI,Date ASC';
 --CP.CustomerId=CAST('+@Customer_Id+' AS bigint)
 --and BiltyNoDate between CAST('+@DateFrom +'as date) and  CAST('+ @DateTo +'as date)
 print @query
 exec (@query)

 --group BY BiltyNoDate  ,BiltyNo ,DA_No ,CityName ,CustomerName,Rate,WeightPerUnit
	END
	 





GO
/****** Object:  StoredProcedure [dbo].[Report10]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[Report10](
@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
							 @Customer_Id					bigint,
							 @DateFrom						date,
							 @DateTo						date,
							 @BiltyNo						nvarchar(max)
)

AS 
BEGIN

DECLARE @query nvarchar(max)

SET @query='SELECT distinct PivotTable.station,  PivotTable.BiltyNo,PivotTable.Date,PivotTable.DC_NO,PivotTable.RegNo,PivotTable.CustomerName,ISNULL(PivotTable.[COIL WIRE],''0'') Coil,SUM(ISNULL(PivotTable.[Drum Wire],''0'')+ISNULL(PivotTable.[WIRE(DRUM)],''0'')) Drum,OD.Freight,''0'' AS Weight,PivotTable.RegNo AS Vehicle , OD.Freight Amount,PivotTable.ReceiverName,PivotTable.UnitFreight Rate,PivotTable.Charges  FROM 
(SELECT   OD.BiltyNo,convert(varchar, OD.BiltyNoDate, 6) Date,C.CityName Station,isnull(OPT.DC_NO,''0'') DC_NO,p.Name,OPT.Quantity,ISNULL(V.VehicleCode,DC.VehicleNo) ''RegNo'',CP.CustomerName
,Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) SI ,OL.ReceiverName,OPT.UnitFreight, OD.AdditionalFreight as Charges

 FROM  [order] o
INNER JOIN  OrderDetail OD on O.OrderID=OD.OrderID
inner join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
inner join shipmenttype ShpType on OD.ShipmentTypeId=ShpType.ShipmentType_Id
inner join OrderLocations OL on OL.OrderDetailId=OD.OrderDetailId
inner join CITY C on C.CityID=OL.DropLocationId
inner join CustomerProfile CP on o.CustomerCompanyId=CP.CustomerId
inner join CustomerProfileDetail CPD on CP.ProfileId=CPD.ProfileId and OL.PickupLocationId= CPD.LocationFrom and OL.DropLocationId = CPD.LocationTo
inner join Company  on o.CustomerCompanyId=Company.CompanyID
and  OL.PickupLocationId=CPD.LocationFrom and OL.DropLocationId=CPD.LocationTo and  CPD.ProductId=OPT.ItemId
inner join Product P on CPD.ProductId = P.ID
LEFT JOIN DriverChallan DC on OD.ChallanNo = DC.ChallanNo
	LEFT JOIN  Vehicle V on DC.VehicleId = v.VehicleID
) AS SourceTable
PIVOT(
SUM(Quantity)
FOR Name IN ([COIL WIRE],[WIRE(DRUM)],[Drum Wire])
) AS PivotTable
INNER JOIN OrderDetail OD on PivotTable.BiltyNo=OD.BiltyNo
inner join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId AND 

ISNULL(OPT.DC_NO,0)= ISNULL(PivotTable.DC_NO,0)
	WHERE 

 
 
  PivotTable.BiltyNo in ('+@BiltyNo+')    
  GROUP BY PivotTable.station,  PivotTable.BiltyNo,PivotTable.Date,PivotTable.DC_NO,PivotTable.RegNo,PivotTable.CustomerName,  OD.Freight,Weight,PivotTable.RegNo,OD.Freight,PivotTable.[COIL WIRE],PivotTable.ReceiverName,PivotTable.UnitFreight,PivotTable.Charges
 order by PivotTable.BiltyNo';
 --CP.CustomerId=CAST('+@Customer_Id+' AS bigint)
 --and BiltyNoDate between CAST('+@DateFrom +'as date) and  CAST('+ @DateTo +'as date)
 --print @query
 exec (@query)

 --group BY BiltyNoDate  ,BiltyNo ,DA_No ,CityName ,CustomerName,Rate,WeightPerUnit
	END
	 







GO
/****** Object:  StoredProcedure [dbo].[Report2]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Report2](
@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
							 @Customer_Id					bigint,
							 @DateFrom						date,
							 @DateTo						date,
							 @BiltyNo						nvarchar(max)
)

AS 
BEGIN

DECLARE @query nvarchar(max)

SET @query='SELECT  ShipmentTypeDetail, DATE,BiltyNo,DA_No,Station,CustomerName,Amount,Rate, Weight FROM (SELECT distinct ShpType.ShipmentTypeDetail,convert(varchar, BiltyNoDate, 6)  Date  ,OD.BiltyNo,Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) SI ,OD.DA_No ,C.CityName Station,
ISNULL(Company.CompanyName,CP.CustomerName) CustomerName,

ISNULL(CAST(ROUND(OD.NetWeight,0) as varchar),''0'') WEIGHT,OPT.UnitFreight ''RATE'',ISNULL( ROUND(OD.NetWeight,0) ,''0'') * OPT.UnitFreight ''Amount''
  FROM [Order] O
inner join orderdetail OD on O.orderid=OD.orderid
left join shipmenttype ShpType on OD.ShipmentTypeId=ShpType.ShipmentType_Id
inner join OrderLocations OL on OL.OrderDetailId=OD.OrderDetailId
inner join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
inner join CITY C on C.CityID=OL.DropLocationId
inner join CustomerProfile CP on o.CustomerCompanyId=CP.CustomerId
inner join CustomerProfileDetail CPD on CP.ProfileId=CPD.ProfileId and OL.PickupLocationId= CPD.LocationFrom and OL.DropLocationId = CPD.LocationTo
inner join Company  on o.CustomerCompanyId=Company.CompanyID
and  OL.PickupLocationId=CPD.LocationFrom and OL.DropLocationId=CPD.LocationTo and  CPD.ProductId=OPT.ItemId
inner join Product P on CPD.ProductId = P.ID
	WHERE 

 
 
  OD.BiltyNo in ('+@BiltyNo+')) tabl  order  by SI,Date ASC';
 --CP.CustomerId=CAST('+@Customer_Id+' AS bigint)
 --and BiltyNoDate between CAST('+@DateFrom +'as date) and  CAST('+ @DateTo +'as date)
 exec (@query)

 --group BY BiltyNoDate  ,BiltyNo ,DA_No ,CityName ,CustomerName,Rate,WeightPerUnit
	END
	 






GO
/****** Object:  StoredProcedure [dbo].[Report3]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Report3](
@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
							 @Customer_Id					bigint,
							 @DateFrom						date,
							 @DateTo						date,
							 @BiltyNo						nvarchar(max)
)

AS 
BEGIN

DECLARE @query nvarchar(max)

SET @query='SELECT   ShipmentTypeDetail, DATE,BiltyNo,DA_No,Station,CustomerName,Amount,Rate,Weight,SUM(Quantity) Quantity FROM (SELECT  ShpType.ShipmentTypeDetail,convert(varchar, BiltyNoDate, 6)  Date  ,OD.BiltyNo,Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) SI ,OD.DA_No ,C.CityName Station,
ISNULL(Company.CompanyName,CP.CustomerName) CustomerName,OPT.Quantity,
CASE 

WHEN UPPER(CPD.RateType)=''Unit'' then OPT.UnitFreight*OPT.Quantity
WHEN UPPER(CPD.RateType)=''Carton'' then OPT.UnitFreight*OPT.Quantity
WHEN UPPER(CPD.RateType)=''Kg'' then ISNULL(OD.NetWeight ,''0'') * OPT.UnitFreight
else 0


end ''Amount'',

ISNULL(CAST(OD.NetWeight as varchar),''0'') WEIGHT,OPT.UnitFreight ''RATE''
  FROM [Order] O
inner join orderdetail OD on O.orderid=OD.orderid
left join shipmenttype ShpType on OD.ShipmentTypeId=ShpType.ShipmentType_Id
inner join OrderLocations OL on OL.OrderDetailId=OD.OrderDetailId
inner join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
inner join CITY C on C.CityID=OL.DropLocationId
inner join CustomerProfile CP on o.CustomerCompanyId=CP.CustomerId
inner join CustomerProfileDetail CPD on CP.ProfileId=CPD.ProfileId and OL.PickupLocationId= CPD.LocationFrom and OL.DropLocationId = CPD.LocationTo
inner join Company  on o.CustomerCompanyId=Company.CompanyID
and  OL.PickupLocationId=CPD.LocationFrom and OL.DropLocationId=CPD.LocationTo and  CPD.ProductId=OPT.ItemId
inner join Product P on CPD.ProductId = P.ID
	WHERE 

 
 
  OD.BiltyNo in ('+@BiltyNo+')) tabl
  
   GROUP BY tabl.ShipmentTypeDetail,tabl.BiltyNo,tabl.CustomerName,tabl.Rate,tabl.DA_No,tabl.Date,tabl.Station,tabl.amount,tabl.weight,tabl.si  order  by SI,Date ASC';
 --CP.CustomerId=CAST('+@Customer_Id+' AS bigint)
 --and BiltyNoDate between CAST('+@DateFrom +'as date) and  CAST('+ @DateTo +'as date)
 exec (@query)

 --group BY BiltyNoDate  ,BiltyNo ,DA_No ,CityName ,CustomerName,Rate,WeightPerUnit
	END
	 






GO
/****** Object:  StoredProcedure [dbo].[Report4]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report4](
@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
							 @Customer_Id					bigint,
							 @DateFrom						date,
							 @DateTo						date,
							 @BiltyNo						nvarchar(max)
)

AS 
BEGIN

DECLARE @query nvarchar(max)

SET @query='SELECT  ShipmentTypeDetail, DATE,BiltyNo,DA_No,Station,CustomerName,Name,Quantity,Amount,Rate,WeightPerUnit FROM (SELECT ShpType.ShipmentTypeDetail,convert(varchar, BiltyNoDate, 6)  Date  ,OD.BiltyNo,Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) SI ,OD.DA_No ,C.CityName Station,ISNULL(Company.CompanyName,CP.CustomerName) CustomerName,P.Name,OPT.Quantity,
CASE 
WHEN  UPPER(ShpType.ShipmentTypeDetail)=''Full Truck Load'' then  OD.Freight 
WHEN  UPPER(CPD.RateType)=''Lumsum'' then  OPT.UnitFreight*OPT.Quantity 
WHEN UPPER(CPD.RateType)=''Carton'' then OPT.UnitFreight*OPT.Quantity
WHEN UPPER(CPD.RateType)=''Kg'' then OPT.UnitFreight*OPT.Quantity*OPT.UnitWeight
WHEN UPPER(CPD.RateType)=''Unit'' then OPT.UnitFreight*OPT.Quantity
end ''Amount'',
CPD.Rate,ISNULL(CAST(CPD.WeightPerUnit as varchar),'''') WeightPerUnit
  FROM [Order] O
inner join orderdetail OD on O.orderid=OD.orderid
left join shipmenttype ShpType on OD.ShipmentTypeId=ShpType.ShipmentType_Id
inner join OrderLocations OL on OL.OrderDetailId=OD.OrderDetailId
inner join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
inner join CITY C on C.CityID=OL.DropLocationId
inner join CustomerProfile CP on o.CustomerCompanyId=CP.CustomerId
inner join CustomerProfileDetail CPD on CP.ProfileId=CPD.ProfileId and OL.PickupLocationId= CPD.LocationFrom and OL.DropLocationId = CPD.LocationTo
inner join Company  on o.CustomerCompanyId=Company.CompanyID
and  OL.PickupLocationId=CPD.LocationFrom and OL.DropLocationId=CPD.LocationTo and  CPD.ProductId=OPT.ItemId
	inner join Product P on CPD.ProductId = P.ID
	WHERE 

 
 
  OD.BiltyNo in ('+@BiltyNo+')) tabl  order  by SI,Date ASC';
 --CP.CustomerId=CAST('+@Customer_Id+' AS bigint)
 --and BiltyNoDate between CAST('+@DateFrom +'as date) and  CAST('+ @DateTo +'as date)
 print @query
 exec (@query)

 --group BY BiltyNoDate  ,BiltyNo ,DA_No ,CityName ,CustomerName,Rate,WeightPerUnit
	END
	 





GO
/****** Object:  StoredProcedure [dbo].[Report4_backup]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[Report4_backup](
@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
							 @Customer_Id					bigint,
							 @DateFrom						date,
							 @DateTo						date,
							 @BiltyNo						nvarchar(max)
)

AS 
BEGIN

DECLARE @query nvarchar(max)

SET @query='SELECT DATE,BiltyNo,DA_No,Station,CustomerName,Name,Quantity,Amount,Rate,WeightPerUnit FROM (SELECT convert(varchar, BiltyNoDate, 6)  Date  ,OD.BiltyNo,Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) SI ,OD.DA_No ,C.CityName Station,ISNULL(Company.CompanyName,CP.CustomerName) CustomerName,P.Name,OPT.Quantity,
CASE WHEN  UPPER(CPD.RateType)=''Lumsum'' then  OPT.UnitFreight*OPT.Quantity 
WHEN UPPER(CPD.RateType)=''Carton'' then OPT.UnitFreight*OPT.Quantity
WHEN UPPER(CPD.RateType)=''Kg'' then OPT.UnitFreight*OPT.Quantity*OPT.UnitWeight
WHEN UPPER(CPD.RateType)=''Unit'' then OPT.UnitFreight*OPT.Quantity
end ''Amount'',
CPD.Rate,ISNULL(CAST(CPD.WeightPerUnit as varchar),'''') WeightPerUnit
  FROM [Order] O
inner join orderdetail OD on O.orderid=OD.orderid
inner join OrderLocations OL on OL.OrderDetailId=OD.OrderDetailId
inner join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
inner join CITY C on C.CityID=OL.DropLocationId
inner join CustomerProfile CP on o.CustomerCompanyId=CP.CustomerId
inner join CustomerProfileDetail CPD on CP.ProfileId=CPD.ProfileId 
inner join Company  on o.CustomerCompanyId=Company.CompanyID
and  OL.PickupLocationId=CPD.LocationFrom and OL.DropLocationId=CPD.LocationTo and  CPD.ProductId=OPT.ItemId
	inner join Product P on CPD.ProductId = P.ID
	WHERE 

 
 
  OD.BiltyNo in ('+@BiltyNo+')) tabl  order  by SI,Date ASC';
 --CP.CustomerId=CAST('+@Customer_Id+' AS bigint)
 --and BiltyNoDate between CAST('+@DateFrom +'as date) and  CAST('+ @DateTo +'as date)
 print @query
 exec (@query)

 --group BY BiltyNoDate  ,BiltyNo ,DA_No ,CityName ,CustomerName,Rate,WeightPerUnit
	END
	 




GO
/****** Object:  StoredProcedure [dbo].[Report5]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report5](
@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
							 @Customer_Id					bigint,
							 @DateFrom						date,
							 @DateTo						date,
							 @BiltyNo						nvarchar(max)
)

AS 
BEGIN

DECLARE @query nvarchar(max)

SET @query='SELECT ShipmentTypeDetail, DATE,BiltyNo,DA_No,Station,CustomerName,Name,Quantity,Amount,Rate,WeightPerUnit,ReceiverName FROM (SELECT distinct ShpType.ShipmentTypeDetail,convert(varchar, BiltyNoDate, 6)  Date  ,OD.BiltyNo,Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) SI ,OD.DA_No ,C.CityName Station,ISNULL(Company.CompanyName,CP.CustomerName) CustomerName,P.Name,OPT.Quantity,
CASE 
WHEN  UPPER(ShpType.ShipmentTypeDetail)=''Full Truck Load'' then  OD.Freight 
WHEN  UPPER(CPD.RateType)=''Lumsum'' then  OPT.UnitFreight*OPT.Quantity 
WHEN UPPER(CPD.RateType)=''Carton'' then OPT.UnitFreight*OPT.Quantity
WHEN UPPER(CPD.RateType)=''Kg'' then OPT.UnitFreight*OPT.Quantity*OPT.UnitWeight
WHEN UPPER(CPD.RateType)=''Unit'' then OPT.UnitFreight*OPT.Quantity
end ''Amount'',OL.ReceiverName,
CPD.Rate,ISNULL(CAST(OD.NetWeight as varchar),'''') WeightPerUnit
  FROM [Order] O
inner join orderdetail OD on O.orderid=OD.orderid
left join shipmenttype ShpType on OD.ShipmentTypeId=ShpType.ShipmentType_Id
inner join OrderLocations OL on OL.OrderDetailId=OD.OrderDetailId
inner join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
inner join CITY C on C.CityID=OL.DropLocationId
inner join CustomerProfile CP on o.CustomerCompanyId=CP.CustomerId
inner join CustomerProfileDetail CPD on CP.ProfileId=CPD.ProfileId and OL.PickupLocationId= CPD.LocationFrom and OL.DropLocationId = CPD.LocationTo
inner join Company  on o.CustomerCompanyId=Company.CompanyID
and  OL.PickupLocationId=CPD.LocationFrom and OL.DropLocationId=CPD.LocationTo and  CPD.ProductId=OPT.ItemId
	inner join Product P on CPD.ProductId = P.ID
	WHERE 

 
 
  OD.BiltyNo in ('+@BiltyNo+')) tabl  order  by SI,Date ASC';
 --CP.CustomerId=CAST('+@Customer_Id+' AS bigint)
 --and BiltyNoDate between CAST('+@DateFrom +'as date) and  CAST('+ @DateTo +'as date)
 print @query
 exec (@query)

 --group BY BiltyNoDate  ,BiltyNo ,DA_No ,CityName ,CustomerName,Rate,WeightPerUnit
	END
	 





GO
/****** Object:  StoredProcedure [dbo].[Report6]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Report6](
@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
							 @Customer_Id					bigint,
							 @DateFrom						date,
							 @DateTo						date,
							 @BiltyNo						nvarchar(max)
)

AS 
BEGIN

DECLARE @query nvarchar(max)

SET @query='SELECT ShipmentTypeDetail, DATE,BiltyNo,DA_No,Station,CustomerName,Name,Quantity,Amount,Rate,WeightPerUnit,VehicleNo,ReceiverName,ContainerType FROM (SELECT distinct ShpType.ShipmentTypeDetail,convert(varchar, BiltyNoDate, 6)  Date  ,OD.BiltyNo,Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) SI ,OD.DA_No ,C.CityName Station,ISNULL(Company.CompanyName,CP.CustomerName) CustomerName,P.Name,OPT.Quantity,
CASE 
WHEN  UPPER(ShpType.ShipmentTypeDetail)=''Full Truck Load'' then  OD.Freight 
WHEN  UPPER(CPD.RateType)=''Lumsum'' then  OPT.UnitFreight*OPT.Quantity 
WHEN UPPER(CPD.RateType)=''Carton'' then OPT.UnitFreight*OPT.Quantity
WHEN UPPER(CPD.RateType)=''Kg'' then OPT.UnitFreight*OPT.Quantity*OPT.UnitWeight
WHEN UPPER(CPD.RateType)=''Unit'' then OPT.UnitFreight*OPT.Quantity
end ''Amount'',OL.ReceiverName,containerType.ContainerType,DriverChallan.VehicleNo,
CPD.Rate,ISNULL(CAST(CPD.WeightPerUnit as varchar),'''') WeightPerUnit
  FROM [Order] O
inner join orderdetail OD on O.orderid=OD.orderid
left join shipmenttype ShpType on OD.ShipmentTypeId=ShpType.ShipmentType_Id
INNER JOIN containerType on OD.VehicleTypeId=ContainerType.ContainerTypeID
LEFT JOIN DriverChallan on OD.ChallanNo=DriverChallan.ChallanNo
inner join OrderLocations OL on OL.OrderDetailId=OD.OrderDetailId
inner join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
inner join CITY C on C.CityID=OL.DropLocationId
inner join CustomerProfile CP on o.CustomerCompanyId=CP.CustomerId
inner join CustomerProfileDetail CPD on CP.ProfileId=CPD.ProfileId and OL.PickupLocationId= CPD.LocationFrom and OL.DropLocationId = CPD.LocationTo
inner join Company  on o.CustomerCompanyId=Company.CompanyID
and  OL.PickupLocationId=CPD.LocationFrom and OL.DropLocationId=CPD.LocationTo and  CPD.ProductId=OPT.ItemId
	inner join Product P on CPD.ProductId = P.ID
	WHERE 

 
 
  OD.BiltyNo in ('+@BiltyNo+')) tabl  order  by SI,Date ASC';
 --CP.CustomerId=CAST('+@Customer_Id+' AS bigint)
 --and BiltyNoDate between CAST('+@DateFrom +'as date) and  CAST('+ @DateTo +'as date)
 print @query
 exec (@query)

 --group BY BiltyNoDate  ,BiltyNo ,DA_No ,CityName ,CustomerName,Rate,WeightPerUnit
	END
	 






GO
/****** Object:  StoredProcedure [dbo].[Report7]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Report7](
@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
							 @Customer_Id					bigint,
							 @DateFrom						date,
							 @DateTo						date,
							 @BiltyNo						nvarchar(max)
)

AS 
BEGIN

DECLARE @query nvarchar(max)

SET @query='SELECT  ShipmentTypeDetail, DATE,BiltyNo,DA_No,Station,CustomerName,Amount,Rate, Weight,ContainerType,VehicleNo,SUM(Quantity) Quantity FROM (SELECT distinct ShpType.ShipmentTypeDetail,convert(varchar, BiltyNoDate, 6)  Date  ,
OD.BiltyNo,Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) SI ,OD.DA_No ,C.CityName Station,
ISNULL(Company.CompanyName,CP.CustomerName) CustomerName,

ISNULL(CAST(ROUND(OD.NetWeight,0) as varchar),''0'') WEIGHT,OPT.UnitFreight ''RATE'',


CASE 

WHEN UPPER(ShpType.ShipmentTypeDetail)=''FULL TRUCK LOAD'' then OD.Freight
else ISNULL( ROUND(OD.NetWeight,0) ,''0'') * OPT.UnitFreight

end ''Amount'' 
,OPT.Quantity,
VT.VehicleTypeName ''containertype'',DriverChallan.VehicleNo
  FROM [Order] O
inner join orderdetail OD on O.orderid=OD.orderid

left join shipmenttype ShpType on OD.ShipmentTypeId=ShpType.ShipmentType_Id
INNER JOIN containerType on OD.VehicleTypeId=ContainerType.ContainerTypeID
LEFT JOIN DriverChallan on OD.ChallanNo=DriverChallan.ChallanNo
left join VehicleType  VT on OD.VehicleTypeId=VT.VehicleTypeID
inner join OrderLocations OL on OL.OrderDetailId=OD.OrderDetailId
inner join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
inner join CITY C on C.CityID=OL.DropLocationId
inner join CustomerProfile CP on o.CustomerCompanyId=CP.CustomerId
inner join CustomerProfileDetail CPD on CP.ProfileId=CPD.ProfileId and OL.PickupLocationId= CPD.LocationFrom and OL.DropLocationId = CPD.LocationTo
left join Company  on o.CustomerCompanyId=Company.CompanyID
and  OL.PickupLocationId=CPD.LocationFrom and OL.DropLocationId=CPD.LocationTo and  CPD.ProductId=OPT.ItemId
inner join Product P on CPD.ProductId = P.ID AND OPT.ItemID = P.ID
	WHERE 

 
 
  OD.BiltyNo in ('+@BiltyNo+')) tabl  
  GROUP BY tabl.ShipmentTypeDetail,tabl.BiltyNo,tabl.CustomerName,tabl.Rate,tabl.DA_No,tabl.Date,tabl.Station,tabl.amount,tabl.weight,tabl.si,tabl.ContainerType,tabl.VehicleNo  order  by SI,Date ASC';
 --CP.CustomerId=CAST('+@Customer_Id+' AS bigint)
 --and BiltyNoDate between CAST('+@DateFrom +'as date) and  CAST('+ @DateTo +'as date)
 --print @query
 exec (@query)

 --group BY BiltyNoDate  ,BiltyNo ,DA_No ,CityName ,CustomerName,Rate,WeightPerUnit
	END
	 








GO
/****** Object:  StoredProcedure [dbo].[Report8]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Report8](
@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
							 @Customer_Id					bigint,
							 @DateFrom						date,
							 @DateTo						date,
							 @BiltyNo						nvarchar(max)
)

AS 
BEGIN

DECLARE @query nvarchar(max)

SET @query='SELECT ShipmentTypeDetail, DATE,BiltyNo,DA_No,Station,CustomerName,SUM(Quantity) Quantity,SUM(Amount) Amount,Rate,name,WeightPerUnit FROM (SELECT ShpType.ShipmentTypeDetail,convert(varchar, BiltyNoDate, 6)  Date  ,OD.BiltyNo,Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) SI ,OD.DA_No ,C.CityName Station,ISNULL(Company.CompanyName,CP.CustomerName) CustomerName,'''' Name,OPT.Quantity,
CASE 
WHEN  UPPER(ShpType.ShipmentTypeDetail)=''Full Truck Load'' then  OD.Freight 
WHEN  UPPER(CPD.RateType)=''Lumsum'' then  OPT.UnitFreight*OPT.Quantity 
WHEN UPPER(CPD.RateType)=''Carton'' then OPT.UnitFreight*OPT.Quantity
WHEN UPPER(CPD.RateType)=''Kg'' then OPT.UnitFreight*OPT.Quantity*OPT.UnitWeight
WHEN UPPER(CPD.RateType)=''Unit'' then OPT.UnitFreight*OPT.Quantity
end ''Amount'',
OPT.UnitFreight Rate,ISNULL(CAST(ROUND(OD.NetWeight,0) as varchar),'''') WeightPerUnit
  FROM [Order] O
inner join orderdetail OD on O.orderid=OD.orderid
left join shipmenttype ShpType on OD.ShipmentTypeId=ShpType.ShipmentType_Id
inner join OrderLocations OL on OL.OrderDetailId=OD.OrderDetailId
inner join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
inner join CITY C on C.CityID=OL.DropLocationId
inner join CustomerProfile CP on o.CustomerCompanyId=CP.CustomerId
inner join CustomerProfileDetail CPD on CP.ProfileId=CPD.ProfileId and OL.PickupLocationId= CPD.LocationFrom and OL.DropLocationId = CPD.LocationTo
left join Company  on o.CustomerCompanyId=Company.CompanyID
and  OL.PickupLocationId=CPD.LocationFrom and OL.DropLocationId=CPD.LocationTo and  CPD.ProductId=OPT.ItemId
	inner join Product P on CPD.ProductId = P.ID
	WHERE 

 
 
  OD.BiltyNo in ('+@BiltyNo+')) tabl    
  GROUP BY tabl.ShipmentTypeDetail,tabl.BiltyNo,tabl.CustomerName,tabl.Rate,tabl.DA_No,tabl.Date,tabl.Station,tabl.name,tabl.WeightPerUnit,tabl.si  order  by SI,Date ASC';
 --CP.CustomerId=CAST('+@Customer_Id+' AS bigint)
 --and BiltyNoDate between CAST('+@DateFrom +'as date) and  CAST('+ @DateTo +'as date)
 print @query
 exec (@query)

 --group BY BiltyNoDate  ,BiltyNo ,DA_No ,CityName ,CustomerName,Rate,WeightPerUnit
	END
	 







GO
/****** Object:  StoredProcedure [dbo].[Report9]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Report9](
@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
							 @Customer_Id					bigint,
							 @DateFrom						date,
							 @DateTo						date,
							 @BiltyNo						nvarchar(max)
)

AS 
BEGIN

DECLARE @query nvarchar(max)

SET @query='SELECT distinct PivotTable.station,  PivotTable.BiltyNo,PivotTable.Date,PivotTable.DC_NO,PivotTable.RegNo,PivotTable.CustomerName,ISNULL(PivotTable.[COIL WIRE],''0'') Coil,SUM(ISNULL(PivotTable.[Drum Wire],''0'')+ISNULL(PivotTable.[WIRE(DRUM)],''0'')) Drum,OD.Freight,''0'' AS Weight,PivotTable.RegNo AS Vehicle , OD.Freight Amount FROM 
(SELECT   OD.BiltyNo,convert(varchar, OD.BiltyNoDate, 6) Date,C.CityName Station,isnull(OPT.DC_NO,''0'') DC_NO,p.Name,OPT.Quantity,ISNULL(V.VehicleCode,DC.VehicleNo) ''RegNo'',CP.CustomerName
,Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) SI 

 FROM  [order] o
INNER JOIN  OrderDetail OD on O.OrderID=OD.OrderID
inner join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
inner join shipmenttype ShpType on OD.ShipmentTypeId=ShpType.ShipmentType_Id
inner join OrderLocations OL on OL.OrderDetailId=OD.OrderDetailId
inner join CITY C on C.CityID=OL.DropLocationId
inner join CustomerProfile CP on o.CustomerCompanyId=CP.CustomerId
inner join CustomerProfileDetail CPD on CP.ProfileId=CPD.ProfileId and OL.PickupLocationId= CPD.LocationFrom and OL.DropLocationId = CPD.LocationTo
inner join Company  on o.CustomerCompanyId=Company.CompanyID
and  OL.PickupLocationId=CPD.LocationFrom and OL.DropLocationId=CPD.LocationTo and  CPD.ProductId=OPT.ItemId
inner join Product P on CPD.ProductId = P.ID
LEFT JOIN DriverChallan DC on OD.ChallanNo = DC.ChallanNo
	LEFT JOIN  Vehicle V on DC.VehicleId = v.VehicleID
) AS SourceTable
PIVOT(
SUM(Quantity)
FOR Name IN ([COIL WIRE],[WIRE(DRUM)],[Drum Wire])
) AS PivotTable
INNER JOIN OrderDetail OD on PivotTable.BiltyNo=OD.BiltyNo
inner join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId AND 

ISNULL(OPT.DC_NO,0)= ISNULL(PivotTable.DC_NO,0)
	WHERE 

 
 
  PivotTable.BiltyNo in ('+@BiltyNo+')    
  GROUP BY PivotTable.station,  PivotTable.BiltyNo,PivotTable.Date,PivotTable.DC_NO,PivotTable.RegNo,PivotTable.CustomerName,  OD.Freight,Weight,PivotTable.RegNo,OD.Freight,PivotTable.[COIL WIRE]
 order by PivotTable.BiltyNo';
 --CP.CustomerId=CAST('+@Customer_Id+' AS bigint)
 --and BiltyNoDate between CAST('+@DateFrom +'as date) and  CAST('+ @DateTo +'as date)
 print @query
 exec (@query)

 --group BY BiltyNoDate  ,BiltyNo ,DA_No ,CityName ,CustomerName,Rate,WeightPerUnit
	END
	 







GO
/****** Object:  StoredProcedure [dbo].[tools_CS_SPROC_Builder]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE       PROCEDURE [dbo].[tools_CS_SPROC_Builder] 
(
@objName nvarchar(100)
)
AS
/*
___________________________________________________________________
Name:  		CS SPROC Builder
Version: 	1
Date:    	10/09/2004
Author:  	Paul McKenzie
Description: 	Call this stored procedue passing the name of your 
  database object that you wish to insert/update
  from .NET (C#) and the code returns code to copy
  and paste into your application.  This version is
  for use with "Microsoft Data Application Block".
  
Version: 	1.1
Date:	 	17/02/2006
Author:	 	Paul McKenzie
Description:	a) Updated to include 'UniqueIdentifier' Data Type
		b) Support for 'ParameterDirection.Output'

*/
SET NOCOUNT ON
DECLARE @parameterCount int
DECLARE @errMsg varchar(100)
DECLARE @parameterAt varchar(1)
DECLARE @connName varchar(100)
DECLARE @outputValues varchar(100)
--Change the following variable to the name of your connection instance
SET @connName='conn.Connection'
SET @parameterAt=''
SET @outputValues=''
SELECT 
 	dbo.sysobjects.name AS ObjName, 
 	dbo.sysobjects.xtype AS ObjType,
 	dbo.syscolumns.name AS ColName, 
 	dbo.syscolumns.colorder AS ColOrder, 
 	dbo.syscolumns.length AS ColLen, 
 	dbo.syscolumns.colstat AS ColKey, 
 	dbo.syscolumns.isoutparam AS ColIsOut,
 	dbo.systypes.xtype
INTO #t_obj
FROM         
 	dbo.syscolumns INNER JOIN
 	dbo.sysobjects ON dbo.syscolumns.id = dbo.sysobjects.id INNER JOIN
 	dbo.systypes ON dbo.syscolumns.xtype = dbo.systypes.xtype
WHERE     
 	(dbo.sysobjects.name = @objName) 
 	AND 
 	(dbo.systypes.status <> 1) 
ORDER BY 
 	dbo.sysobjects.name, 
 	dbo.syscolumns.colorder

SET @parameterCount=(SELECT count(*) FROM #t_obj)
IF(@parameterCount<1) SET @errMsg='No Parameters/Fields found for ' + @objName
IF(@errMsg is null)
	BEGIN
  		PRINT 'try'
  		PRINT '   {'
  		PRINT '   SqlParameter[] paramsToStore = new SqlParameter[' + cast(@parameterCount as varchar) + '];'
  		PRINT ''
  
  		DECLARE @source_name nvarchar,@source_type varchar,
    			@col_name nvarchar(100),@col_order int,@col_type varchar(20),
    			@col_len int,@col_key int,@col_xtype int,@col_redef varchar(20), @col_isout tinyint
 
  		DECLARE cur CURSOR FOR
  		SELECT * FROM #t_obj
  		OPEN cur
  		-- Perform the first fetch.
  		FETCH NEXT FROM cur INTO @source_name,@source_type,@col_name,@col_order,@col_len,@col_key,@col_isout,@col_xtype
 
  			if(@source_type=N'U') SET @parameterAt='@'
  			-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
  			WHILE @@FETCH_STATUS = 0
  				BEGIN
   				SET @col_redef=(SELECT CASE @col_xtype
					WHEN 34 THEN 'Image'
					WHEN 35 THEN 'Text'
					WHEN 36 THEN 'UniqueIdentifier'
					WHEN 48 THEN 'TinyInt'
					WHEN 52 THEN 'SmallInt'
					WHEN 56 THEN 'Int'
					WHEN 58 THEN 'SmallDateTime'
					WHEN 59 THEN 'Real'
					WHEN 60 THEN 'Money'
					WHEN 61 THEN 'DateTime'
					WHEN 62 THEN 'Float'
					WHEN 99 THEN 'NText'
					WHEN 104 THEN 'Bit'
					WHEN 106 THEN 'Decimal'
					WHEN 122 THEN 'SmallMoney'
					WHEN 127 THEN 'BigInt'
					WHEN 165 THEN 'VarBinary'
					WHEN 167 THEN 'VarChar'
					WHEN 173 THEN 'Binary'
					WHEN 175 THEN 'Char'
					WHEN 231 THEN 'NVarChar'
					WHEN 239 THEN 'NChar'
					ELSE '!MISSING'
					END AS C) 

				--Write out the parameter
				PRINT '   paramsToStore[' + cast(@col_order-1 as varchar) 
				    + '] = new SqlParameter("' + @parameterAt + @col_name
				    + '", SqlDbType.' + @col_redef
				    + ');'

				--Write out the parameter direction it is output
				IF(@col_isout=1)
					BEGIN
						PRINT '   paramsToStore['+ cast(@col_order-1 as varchar) +'].Direction=ParameterDirection.Output;'
						SET @outputValues=@outputValues+'   ?=paramsToStore['+ cast(@col_order-1 as varchar) +'].Value;'
					END
					ELSE
					BEGIN
						--Write out the parameter value line
   						PRINT '   paramsToStore['+ cast(@col_order-1 as varchar) + '].Value = ?;'
					END
				--If the type is a string then output the size declaration
				IF(@col_xtype=231)OR(@col_xtype=167)OR(@col_xtype=175)OR(@col_xtype=99)OR(@col_xtype=35)
					BEGIN
						PRINT '   paramsToStore[' + cast(@col_order-1 as varchar) + '].Size=' + cast(@col_len as varchar) + ';'
					END

				 -- This is executed as long as the previous fetch succeeds.
      			FETCH NEXT FROM cur INTO @source_name,@source_type,@col_name,@col_order, @col_len,@col_key,@col_isout,@col_xtype 
  	END
  PRINT ''
  PRINT '   SqlHelper.ExecuteNonQuery(' + @connName + ', CommandType.StoredProcedure,"' + @objName + '", paramsToStore);'
  PRINT @outputValues
  PRINT '   }'
  PRINT 'catch(Exception excp)'
  PRINT '   {'
  PRINT '   }'
  PRINT 'finally'
  PRINT '   {'
  PRINT '   ' + @connName + '.Dispose();'
  PRINT '   ' + @connName + '.Close();'
  PRINT '   }'  
  CLOSE cur
  DEALLOCATE cur
 END
if(LEN(@errMsg)>0) PRINT @errMsg
DROP TABLE #t_obj
SET NOCOUNT ON




GO
/****** Object:  StoredProcedure [dbo].[usp_BillingType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_BillingType                                                                                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Friday, 23 Nov 2018 17:41:04:180                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_BillingType](@Action_Type                    numeric(10),
                                 @p_Success                      bit             = 1    OUTPUT,
                                 @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                 @BillingTypeId                  bigint          = NULL OUTPUT, 
                                 @BillingTypeName                nvarchar(50)    = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO BillingType(BillingTypeName)
      VALUES                    (@BillingTypeName)

      SET       @BillingTypeId                 = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    BillingType
      SET       BillingTypeName                = COALESCE(@BillingTypeName,BillingTypeName)
                
      WHERE     BillingTypeId                  = @BillingTypeId
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    BillingType
      WHERE     BillingTypeId                  = @BillingTypeId
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, BillingTypeId, BillingTypeName
      FROM      BillingType
      WHERE     BillingTypeId                                     = COALESCE(@BillingTypeId,BillingTypeId)
      AND       COALESCE(BillingTypeName,'X')                     = COALESCE(@BillingTypeName,COALESCE(BillingTypeName,'X'))

	  order by BillingTypeName
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_BillingType--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_BiltyPDF]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_BiltyPDF]
(
@Action_Type                    numeric(10),
                                   @p_Success                      bit             = 1    OUTPUT,
                                   @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
								   @CustomerId	bigint	=null,
								   @BiltyFrom nvarchar(20)=0,
								   @BiltyTo nvarchar(20)=0,
								   @DateFrom date =null,
								   @DateTo   date =null)
AS
 BEGIN
DECLARE @QUERY NVARCHAR(MAX)
DECLARE @CUSTOMER NVARCHAR(MAX)
DECLARE @WHERECLAUSE NVARCHAR(2000)=''
IF @CustomerId is not null AND @CustomerId <> 0
BEGIN
 SET @WHERECLAUSE = ' COALESCE(O.CustomerCompanyId,0) = COALESCE('+CAST(@CustomerId as nvarchar)+',COALESCE(O.CustomerCompanyId,0))'
 END
ELSE
BEGIN
SET @WHERECLAUSE = ' COALESCE(O.CustomerCompanyId,0) = COALESCE(null,COALESCE(O.CustomerCompanyId,0))'
END
IF @BiltyFrom is not null AND @BiltyFrom <> '0'
	--SET @WHERECLAUSE =  ' AND  dbo.udf_GetNumeric(OD.BiltyNo) >= ' + CAST(@BiltyFrom as varchar)+'';
	SET @WHERECLAUSE = @WHERECLAUSE+ ' AND  dbo.udf_GetNumeric(REPLACE(SUBSTRING(OD.BiltyNo, CHARINDEX(''-'', OD.BiltyNo) + 1, LEN(OD.BiltyNo)), '' '','''') ) >= ' + CAST(@BiltyFrom as varchar)+'';
IF @BiltyTo is not null AND @BiltyTo <> '0'
	--SET @WHERECLAUSE = @WHERECLAUSE + ' AND  dbo.udf_GetNumeric(OD.BiltyNo) <= ' + CAST( @BiltyTo as varchar)+'';
	SET @WHERECLAUSE = @WHERECLAUSE +  ' AND  dbo.udf_GetNumeric(REPLACE(SUBSTRING(OD.BiltyNo, CHARINDEX(''-'', OD.BiltyNo) + 1, LEN(OD.BiltyNo)), '' '','''') ) <= ' + CAST(@BiltyTo as varchar)+'';
IF  @DateFrom is not null AND @DateTo is not null
	SET @WHERECLAUSE = @WHERECLAUSE + ' AND  OD.BiltyNoDate between '''+ CONVERT(varchar, @DateFrom, 23) + ''' and '''+ CONVERT(varchar, @DateTo, 23) +''''

SET @QUERY= ' select ISNULL(OD.Remarks,'''') Remarks,ISNULL(OD.AdditionalWeight,0) AdditionalWeight,
 
  CASE  When CP.isHide  = 1 Then ''''		
		ELSE   O.CustomerCompany	END	AS   CustomerCompany 
  ,OD.OrderDetailId, OC.CompanyName ''OwnCompany'',OC.Address1,OC.Address2,  ISNULL(CP.PaymentTerm,OD.PaymentType) PaymentType, C.CompanyName,OD.BiltyNo,OD.BiltyNoDate,
 PC.CityName ''PickupCity'',DC.CityName ''DropCity'',od.DA_No,OL.ReceiverName,OL.ReceiverAddress,OL.ReceiverContact,S2.Name,
S2.SecondaryContactNo,S2.ContactNo,OrderPackageId, Product.Name ''ProductName'', 
OPT.PackageTypeId,PackageType.PackageTypeName,
 OPT.ItemId, Quantity, OPT.UnitWeight,
 OPT.UnitFreight,ISNULL(CPD.RateType,'''') RateType,ISNULL(CPD.WeightPerUnit,''1'') WeightPerUnit, OD.Freight
 from [Order] O
inner join [OrderDetail] OD on O.orderid=OD.orderid
inner join [Company] C on O.CompanyId=C.CompanyID
 INNER JOIN CustomerProfile CP on O.CustomerCompanyId=CP.CustomerId
INNER JOIN OwnCompany OC on CP.OwnCompanyId=OC.CompanyID
INNER JOIN OrderLocations OL ON OD.OrderDetailId=OL.OrderDetailId
INNER JOIN City AS PC on OL.PickupLocationId=PC.CityID
INNER JOIN City AS DC on OL.DropLocationId=DC.CityID
left join Stations S1 on OL.StationFrom=S1.ID
left join Stations S2 on OL.StationTo=S2.ID
left join OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
left JOIN PackageType on OPT.PackageTypeId=PackageType.PackageTypeID
INNER JOIN Product on OPT.ItemId=Product.ID
INNER JOIN CustomerProfileDetail CPD on OPT.ItemId=CPD.ProductId AND  (OPT.ProfileDetailId=cpd.ProfileDetail AND OPT.ProfileDetailId is not null)

WHERE    '+ @WHERECLAUSE + ' order by  OD.BiltyNoDate'
	 END
	 --print @QUERY
	 Execute(@QUERY)

GO
/****** Object:  StoredProcedure [dbo].[usp_Brokers]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Brokers                                                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Wednesday, 27 Mar 2019 13:05:53:267                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Brokers](@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                             @ID                             bigint          = NULL OUTPUT, 
                             @Code                           nvarchar(50)    = NULL,
                             @Name                           nvarchar(50)    = NULL,
                             @Phone                          bigint          = NULL,
                             @Phone2                         bigint          = NULL,
                             @HomeNo                         bigint          = NULL,
                             @Address                        nvarchar(100)   = NULL,
                             @NIC                            bigint          = NULL,
                             @Description                    nvarchar(250)   = NULL,
                             @isActive                       bit             = NULL,
                             @CreatedBy                      bigint          = NULL,
                             @CreatedDate                    datetime        = NULL,
                             @ModifiedBy                     bigint          = NULL,
                             @ModifiedDate                   datetime        = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Brokers(Code,  Name,  Phone,  Phone2,  HomeNo,  Address,  NIC,  Description,  isActive,  CreatedBy,  CreatedDate,  ModifiedBy,  ModifiedDate)
      VALUES                (@Code, @Name, @Phone, @Phone2, @HomeNo, @Address, @NIC, @Description, @isActive, @CreatedBy, @CreatedDate, @ModifiedBy, @ModifiedDate)

      SET       @ID                            = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Brokers
      SET       Code                           = COALESCE(@Code,Code),
                Name                           = COALESCE(@Name,Name),
                Phone                          = COALESCE(@Phone,Phone),
                Phone2                         = COALESCE(@Phone2,Phone2),
                HomeNo                         = COALESCE(@HomeNo,HomeNo),
                Address                        = COALESCE(@Address,Address),
                NIC                            = COALESCE(@NIC,NIC),
                Description                    = COALESCE(@Description,Description),
                isActive                       = COALESCE(@isActive,isActive),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate)
                
      WHERE     ID                             = @ID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Brokers
      WHERE     ID                             = @ID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, ID, Code, Name, Phone, Phone2, HomeNo, Address, NIC, Description, isActive, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
      FROM      Brokers
      --WHERE     ID                                                = COALESCE(@ID,ID)
      --AND       COALESCE(Code,'X')                                = COALESCE(@Code,COALESCE(Code,'X'))
      --AND       COALESCE(Name,'X')                                = COALESCE(@Name,COALESCE(Name,'X'))
      --AND       COALESCE(Phone,0)                                 = COALESCE(@Phone,COALESCE(Phone,0))
      --AND       COALESCE(Phone2,0)                                = COALESCE(@Phone2,COALESCE(Phone2,0))
      --AND       COALESCE(HomeNo,0)                                = COALESCE(@HomeNo,COALESCE(HomeNo,0))
      --AND       COALESCE(Address,'X')                             = COALESCE(@Address,COALESCE(Address,'X'))
      --AND       COALESCE(NIC,0)                                   = COALESCE(@NIC,COALESCE(NIC,0))
      --AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
      --AND       COALESCE(isActive,0)                              = COALESCE(@isActive,COALESCE(isActive,0))
      --AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Brokers------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_Challan]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_Challan] (
@DateFrom datetime,
@DateTo datetime,
@BiltyNo nvarchar(11) = null,
@CityFrom bigint =null,
@CityTo bigint =null,
@CustomerName nvarchar(250) =null)
AS
BEGIN 

SELECT CITYPICK.CityName PICKLOACTION,CITYDROP.CityName DROPLOCATION,CITYDROP.CityName 'DropCity',ISNULL(ST.Name,OrderLocations.DropLocationAddress) 'Station' ,TABLEA.* FROM (SELECT OD.OrderDetailId, O.CustomerCompany CustomerPerson,od.BiltyNoDate 'BiltyDate',
od.BiltyNo,ST.ShipmentType,OD.da_no AS DA,PT.name 'ItemName',
OP.Quantity,OP.UnitWeight 'Weight',E.ExpensesTypeName
,CAST (ISNULL(OD.LocalFreight,0) as bigint) AS LocalFreight
,OD.Freight
 AS Freight
 FROM [dbo].[Order] O
INNER JOIN OrderDetail OD on O.OrderID=OD.OrderID  and OD.ParentId <>1
inner join ShipmentType ST on od.ShipmentTypeId=ST.ShipmentType_ID
left join OrderExpenses OE on OD.OrderDetailId=OE.OrderDetailId 
left join ExpensesType E on OE.ExpenseTypeId=E.ExpensesTypeID --and UPPER(E.ExpensesTypeName)='LOCAL FREIGHT'
inner join OrderPackageTypes OP on OD.OrderDetailId=OP.OrderDetailId
inner join Product PT on OP.ItemID=PT.ID
left join   OrderDocument ODoc on OD.OrderDetailId=ODoc.OrderDetailId
WHERE
OD.ChallanNo is null and
 OD.BiltyNo=COALESCE(@BiltyNo,OD.BiltyNo) 
-- and O.CustomerCompany like '%'+COALESCE(@CustomerName,O.CustomerCompany)+'%'
 and 
 OD.BiltyNoDate between @DateFrom and @DateTo
) AS TABLEA
INNER JOIN OrderLocations  On  TABLEA.OrderDetailId=OrderLocations.OrderDetailId
inner join City AS CITYPICK on OrderLocations.PickupLocationId=CITYPICK.CityID 
inner join City AS CITYDROP on OrderLocations.DropLocationId=CITYDROP.CityID
left join Stations AS ST on OrderLocations.StationTo=ST.ID

WHERE
 --OrderLocations.PickupLocationId=COALESCE(@CityTo,OrderLocations.PickupLocationId) 
 --OR 
 OrderLocations.DropLocationId=COALESCE(@CityTo,OrderLocations.DropLocationId)


END




GO
/****** Object:  StoredProcedure [dbo].[usp_City]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_City                                                                                                                         ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Saturday, 17 Nov 2018 09:52:09:750                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_City](@Action_Type                    numeric(10),
                          @p_Success                      bit             = 1    OUTPUT,
                          @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                          @CityID                         bigint          = NULL OUTPUT, 
                          @CityCode                       varchar(50)     = NULL,
                          @CityName                       varchar(50)     = NULL,
                          @ProvinceID                     bigint          = NULL,
                          @Description                    varchar(50)     = NULL,
                          @DateCreated                    datetime        = NULL,
                          @DateModified                   datetime        = NULL,
                          @CreatedByUserID                bigint          = NULL,
                          @ModifiedByUserID               bigint          = NULL,
                          @IsActive                       bit             = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO City(CityCode,  CityName,  ProvinceID,  Description,  DateCreated,  DateModified,  CreatedByUserID,  ModifiedByUserID,  IsActive)
      VALUES             (@CityCode, @CityName, @ProvinceID, @Description, @DateCreated, @DateModified, @CreatedByUserID, @ModifiedByUserID, @IsActive)

      SET       @CityID                        = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    City
      SET       CityCode                       = COALESCE(@CityCode,CityCode),
                CityName                       = COALESCE(@CityName,CityName),
                ProvinceID                     = COALESCE(@ProvinceID,ProvinceID),
                Description                    = COALESCE(@Description,Description),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified),
                CreatedByUserID                = COALESCE(@CreatedByUserID,CreatedByUserID),
                ModifiedByUserID               = COALESCE(@ModifiedByUserID,ModifiedByUserID),
                IsActive                       = COALESCE(@IsActive,IsActive)
                
      WHERE     CityID                         = @CityID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    City
      WHERE     CityID                         = @CityID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, C.*,P.ProvinceName
      FROM      City C
	  INNER JOIN Province P on C.ProvinceID=P.ProvinceID
      WHERE     CityID                                            = COALESCE(@CityID,CityID)
      AND       COALESCE(CityCode,'X')                            = COALESCE(@CityCode,COALESCE(CityCode,'X'))
      AND       COALESCE(CityName,'X')                            = COALESCE(@CityName,COALESCE(CityName,'X'))
      AND       COALESCE(C.ProvinceID,0)                            = COALESCE(@ProvinceID,COALESCE(C.ProvinceID,0))
      AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
      AND       COALESCE(DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(DateCreated,GETDATE()))
      AND       COALESCE(DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(DateModified,GETDATE()))
      AND       COALESCE(CreatedByUserID,0)                       = COALESCE(@CreatedByUserID,COALESCE(CreatedByUserID,0))
      AND       COALESCE(ModifiedByUserID,0)                      = COALESCE(@ModifiedByUserID,COALESCE(ModifiedByUserID,0))
      AND       COALESCE(IsActive,0)                              = COALESCE(@IsActive,COALESCE(IsActive,0))
	  order by CityName 
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_City---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_Company]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Company                                                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Saturday, 16 Feb 2019 23:32:08:447                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Company](@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                             @CompanyID                      bigint          = NULL OUTPUT, 
                             @CompanyCode                    nvarchar(15)    = NULL,
                             @CompanyName                    nvarchar(100)   = NULL,
                             @CompanyEmail                   nvarchar(50)    = NULL,
                             @CompanyWebSite                 nvarchar(50)    = NULL,
                             @CreatedBy                      bigint          = NULL,
                             @ModifiedBy                     bigint          = NULL,
                             @Active                         bit             = NULL,
                             @CreatedDate                    date            = NULL,
                             @ModifiedDate                   date            = NULL,
                             @Contact                        varchar(50)     = NULL,
                             @OtherContact                   nvarchar(50)    = NULL,
                             @Description                    nvarchar(255)   = NULL,
                             @GroupID                        bigint          = NULL,
                             @Address                        nvarchar(200)   = NULL,
							  @NTN                        nvarchar(50)   = NULL,
							   @STN                        nvarchar(50)   = NULL,
							   @Tax   float=0.0,
							   @CustomerType nvarchar(50)=null)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Company(CompanyCode,  CompanyName,  CompanyEmail,  CompanyWebSite,  CreatedBy,  ModifiedBy,  Active,  CreatedDate,  ModifiedDate,  Contact,  OtherContact,  Description,  GroupID,  Address,NTN,STN,Tax,CustomerType)
      VALUES                (@CompanyCode, @CompanyName, @CompanyEmail, @CompanyWebSite, @CreatedBy, @ModifiedBy, @Active, @CreatedDate, @ModifiedDate, @Contact, @OtherContact, @Description, @GroupID, @Address,@NTN,@STN,@Tax,@CustomerType)

      SET       @CompanyID                     = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Company
      SET       CompanyCode                    = COALESCE(@CompanyCode,CompanyCode),
                CompanyName                    = COALESCE(@CompanyName,''),
                CompanyEmail                   = COALESCE(@CompanyEmail,''),
                CompanyWebSite                 = COALESCE(@CompanyWebSite,''),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                Active                         = COALESCE(@Active,Active),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                Contact                        = COALESCE(@Contact,''),
                OtherContact                   = COALESCE(@OtherContact,''),
                Description                    = COALESCE(@Description,''),
                GroupID                        = COALESCE(@GroupID,GroupID),
                Address                        = COALESCE(@Address,''),
				NTN                        = COALESCE(@NTN,''),
				STN                        = COALESCE(@STN,''),
				Tax                        = COALESCE(@Tax,''),
				CustomerType                        = COALESCE(@CustomerType,'')
                
      WHERE     CompanyID                      = @CompanyID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Company
      WHERE     CompanyID                      = @CompanyID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
       SELECT    @Action_Type  AS ActionType,CP.PaymentTerm, C.*,G.GroupName,G.GroupCode
      FROM      Company C
	  LEFT JOIN GROUPS G on C.GroupID=G.GroupID
	  LEFT join CustomerProfile CP on C.CompanyID=cp.CustomerId
      WHERE     CompanyID                                         = COALESCE(@CompanyID,CompanyID)
        AND       COALESCE(CompanyCode,'X')                         = COALESCE(@CompanyCode,COALESCE(CompanyCode,'X'))
      AND       COALESCE(CompanyName,'X')                         = COALESCE(@CompanyName,COALESCE(CompanyName,'X'))
      AND       COALESCE(CompanyEmail,'X')                        = COALESCE(@CompanyEmail,COALESCE(CompanyEmail,'X'))
      AND       COALESCE(CompanyWebSite,'X')                      = COALESCE(@CompanyWebSite,COALESCE(CompanyWebSite,'X'))
      --AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
      --AND       COALESCE(Active,0)                                = COALESCE(@Active,COALESCE(Active,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
      AND       COALESCE(C.Contact,'X')                             = COALESCE(@Contact,COALESCE(C.Contact,'X'))
      AND       COALESCE(OtherContact,'X')                        = COALESCE(@OtherContact,COALESCE(OtherContact,'X'))
      AND       COALESCE(C.Description,'X')                         = COALESCE(@Description,COALESCE(C.Description,'X'))
      AND       C.GroupID                                           = COALESCE(@GroupID,C.GroupID)
	  AND C.Active=1
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Company------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------



GO
/****** Object:  StoredProcedure [dbo].[usp_ContainerExportOrImport]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_ContainerExportOrImport                                                         ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦ ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Tuesday, 27 Nov 2018 10:12:42:890                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_ContainerExportOrImport](@Action_Type                    numeric(10),
                                             @p_Success                      bit             = 1    OUTPUT,
                                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                             @ImportExportID                 bigint          = NULL OUTPUT, 
                                             @ShipmentTypeId                 int             = NULL,
                                             @OrderDetail_ID                 bigint          = NULL,
                                             @ContainerTypeID                nchar(10)       = NULL,
                                             @ContainerTypeQuantity          bigint          = NULL,
                                             @TotalWeight                    float(53)       = NULL,
                                             @ContainerPickupLocationID      bigint          = NULL,
                                             @ContainerPickupAddress         nvarchar(150)   = NULL,
                                             @ExportCargoPickLocationID      bigint          = NULL,
                                             @ExportCargoPickAddress         nvarchar(150)   = NULL,
                                             @ContainerDropOfLocationID      bigint          = NULL,
                                             @ContainerDropOfAddress         nvarchar(150)   = NULL,
                                             @ImportContainerDropOption      nvarchar(50)    = NULL,
                                             @Dispatch_Date                  datetime        = NULL,
                                             @ShippingLine                   nvarchar(50)    = NULL,
                                             @ContainerTerminalOrYeard       nvarchar(50)    = NULL,
                                             @BillingType                    nvarchar(50)    = NULL,
                                             @Status                         nvarchar(50)    = NULL,
                                             @VehicleID                      bigint          = NULL,
                                             @DriverID                       bigint          = NULL,
                                             @BrokerID                       bigint          = NULL,
                                             @CreatedDate                    datetime        = NULL,
                                             @ModifiedDate                   datetime        = NULL,
                                             @CreatedBy                      bigint          = NULL,
                                             @ModifiedBy                     bigint          = NULL,
                                             @VehicleTypeId                  int             = NULL,
                                             @VehicleTypeQuantity            int             = NULL,
                                             @ContainerToVehicle             nvarchar(50)    = NULL,
                                             @LoadingUnloadingLocationType   nvarchar(50)    = NULL,
                                             @LoadingUnloadingExpenseTypeId  int             = NULL,
                                             @LoadingUnloadingExpenseTypeQty int             = NULL,
                                             @LoadingUnloadingExpenseTypeCapacity nvarchar(50)    = NULL,
                                             @OtherExpenseTypeId             int             = NULL,
                                             @OtherExpenseTypeQty            int             = NULL,
                                             @OtherExpenseTypeCapacity       nvarchar(50)    = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO ContainerExportOrImport(ShipmentTypeId,  OrderDetail_ID,  ContainerTypeID,  ContainerTypeQuantity,  TotalWeight,  ContainerPickupLocationID,  ContainerPickupAddress,  ExportCargoPickLocationID,  ExportCargoPickAddress,  ContainerDropOfLocationID,  ContainerDropOfAddress,  ImportContainerDropOption,  Dispatch_Date,  ShippingLine,  ContainerTerminalOrYeard,  BillingType,  Status,  VehicleID,  DriverID,  BrokerID,  CreatedDate,  ModifiedDate,  CreatedBy,  ModifiedBy,  VehicleTypeId,  VehicleTypeQuantity,  ContainerToVehicle,  LoadingUnloadingLocationType,  LoadingUnloadingExpenseTypeId,  LoadingUnloadingExpenseTypeQty,  LoadingUnloadingExpenseTypeCapacity,  OtherExpenseTypeId,  OtherExpenseTypeQty,  OtherExpenseTypeCapacity)
      VALUES                                (@ShipmentTypeId, @OrderDetail_ID, @ContainerTypeID, @ContainerTypeQuantity, @TotalWeight, @ContainerPickupLocationID, @ContainerPickupAddress, @ExportCargoPickLocationID, @ExportCargoPickAddress, @ContainerDropOfLocationID, @ContainerDropOfAddress, @ImportContainerDropOption, @Dispatch_Date, @ShippingLine, @ContainerTerminalOrYeard, @BillingType, @Status, @VehicleID, @DriverID, @BrokerID, @CreatedDate, @ModifiedDate, @CreatedBy, @ModifiedBy, @VehicleTypeId, @VehicleTypeQuantity, @ContainerToVehicle, @LoadingUnloadingLocationType, @LoadingUnloadingExpenseTypeId, @LoadingUnloadingExpenseTypeQty, @LoadingUnloadingExpenseTypeCapacity, @OtherExpenseTypeId, @OtherExpenseTypeQty, @OtherExpenseTypeCapacity)

      SET       @ImportExportID                = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    ContainerExportOrImport
      SET       ShipmentTypeId                 = COALESCE(@ShipmentTypeId,ShipmentTypeId),
                OrderDetail_ID                 = COALESCE(@OrderDetail_ID,OrderDetail_ID),
                ContainerTypeID                = COALESCE(@ContainerTypeID,ContainerTypeID),
                ContainerTypeQuantity          = COALESCE(@ContainerTypeQuantity,ContainerTypeQuantity),
                TotalWeight                    = COALESCE(@TotalWeight,TotalWeight),
                ContainerPickupLocationID      = COALESCE(@ContainerPickupLocationID,ContainerPickupLocationID),
                ContainerPickupAddress         = COALESCE(@ContainerPickupAddress,ContainerPickupAddress),
                ExportCargoPickLocationID      = COALESCE(@ExportCargoPickLocationID,ExportCargoPickLocationID),
                ExportCargoPickAddress         = COALESCE(@ExportCargoPickAddress,ExportCargoPickAddress),
                ContainerDropOfLocationID      = COALESCE(@ContainerDropOfLocationID,ContainerDropOfLocationID),
                ContainerDropOfAddress         = COALESCE(@ContainerDropOfAddress,ContainerDropOfAddress),
                ImportContainerDropOption      = COALESCE(@ImportContainerDropOption,ImportContainerDropOption),
                Dispatch_Date                  = COALESCE(@Dispatch_Date,Dispatch_Date),
                ShippingLine                   = COALESCE(@ShippingLine,ShippingLine),
                ContainerTerminalOrYeard       = COALESCE(@ContainerTerminalOrYeard,ContainerTerminalOrYeard),
                BillingType                    = COALESCE(@BillingType,BillingType),
                Status                         = COALESCE(@Status,Status),
                VehicleID                      = COALESCE(@VehicleID,VehicleID),
                DriverID                       = COALESCE(@DriverID,DriverID),
                BrokerID                       = COALESCE(@BrokerID,BrokerID),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                VehicleTypeId                  = COALESCE(@VehicleTypeId,VehicleTypeId),
                VehicleTypeQuantity            = COALESCE(@VehicleTypeQuantity,VehicleTypeQuantity),
                ContainerToVehicle             = COALESCE(@ContainerToVehicle,ContainerToVehicle),
                LoadingUnloadingLocationType   = COALESCE(@LoadingUnloadingLocationType,LoadingUnloadingLocationType),
                LoadingUnloadingExpenseTypeId  = COALESCE(@LoadingUnloadingExpenseTypeId,LoadingUnloadingExpenseTypeId),
                LoadingUnloadingExpenseTypeQty = COALESCE(@LoadingUnloadingExpenseTypeQty,LoadingUnloadingExpenseTypeQty),
                LoadingUnloadingExpenseTypeCapacity= COALESCE(@LoadingUnloadingExpenseTypeCapacity,LoadingUnloadingExpenseTypeCapacity),
                OtherExpenseTypeId             = COALESCE(@OtherExpenseTypeId,OtherExpenseTypeId),
                OtherExpenseTypeQty            = COALESCE(@OtherExpenseTypeQty,OtherExpenseTypeQty),
                OtherExpenseTypeCapacity       = COALESCE(@OtherExpenseTypeCapacity,OtherExpenseTypeCapacity)
                
      WHERE     ImportExportID                 = @ImportExportID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    ContainerExportOrImport
      WHERE     ImportExportID                 = @ImportExportID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
        SELECT   @Action_Type  AS ActionType, ST.ShipmentType,
		   CPICK.PickDropLocationName AS 'CONTAINER_PICKLOCATION',   CDROP.PickDropLocationName  AS 'CONTAINER_DROPLOCATION',	
		   	   ECARGO.PickDropLocationName AS 'EXPORT_CARGOPICKLOCATION',CT.ContainerType, VT.VehicleTypeCode,VT.VehicleTypeName,
			   LoadUnloadET1.ExpensesTypeName,LoadUnloadET1.ExpensesTypeCode,
			   OtherET1.ExpensesTypeName AS 'OtherExpensesTypeName',OtherET1.ExpensesTypeCode AS 'OtherExpensesTypeCode',

		   ACEI.*	
      FROM      InquiryAndOrdersDetail  ACEI
	  LEFT JOIN PickDropLocation CPICK ON ACEI.ContainerPickupLocationID=CPICK.PickDropID
	  LEFT JOIN PickDropLocation CDROP ON ACEI.ContainerDropOfLocationID=CDROP.PickDropID
	  LEFT JOIN PickDropLocation ECARGO ON ACEI.ExportCargoPickLocationID=ECARGO.PickDropID
	  LEFT JOIN ShipmentType ST ON ACEI.ShipmentTypeId=ST.SHIPMENTTYPE_ID
	  LEFT JOIN ContainerType CT on ACEI.ContainerTypeID=CT.ContainerTypeID
	  Left join VehicleType VT on ACEI.VehicleTypeID=VT.VehicleTypeID
	  LEFT JOIN ExpensesType LoadUnloadET1 on ACEI.LoadingUnloadingExpenseTypeId=LoadUnloadET1.ExpensesTypeID
	  LEFT JOIN ExpensesType OtherET1 on ACEI.LoadingUnloadingExpenseTypeId=OtherET1.ExpensesTypeID
	 -- where ACEI.ORDERDETAIL_id=1  
      WHERE     ACEI.ImportExportID                                    = COALESCE(@ImportExportID,ACEI.ImportExportID)
      AND       ACEI.ShipmentTypeId                                    = COALESCE(@ShipmentTypeId,ACEI.ShipmentTypeId)
      AND       ACEI.OrderDetail_ID                                    = COALESCE(@OrderDetail_ID,ACEI.OrderDetail_ID)
      AND       ACEI.ContainerTypeID                                   = COALESCE(@ContainerTypeID,ACEI.ContainerTypeID)
      --WHERE     ImportExportID                                    = COALESCE(@ImportExportID,ImportExportID)
      --AND       ShipmentTypeId                                    = COALESCE(@ShipmentTypeId,ShipmentTypeId)
      --AND       OrderDetail_ID                                    = COALESCE(@OrderDetail_ID,OrderDetail_ID)
      --AND       ContainerTypeID                                   = COALESCE(@ContainerTypeID,ContainerTypeID)
      --AND       COALESCE(ContainerTypeQuantity,0)                 = COALESCE(@ContainerTypeQuantity,COALESCE(ContainerTypeQuantity,0))
      --AND       TotalWeight                                       = COALESCE(@TotalWeight,TotalWeight)
      --AND       ContainerPickupLocationID                         = COALESCE(@ContainerPickupLocationID,ContainerPickupLocationID)
      --AND       COALESCE(ContainerPickupAddress,'X')              = COALESCE(@ContainerPickupAddress,COALESCE(ContainerPickupAddress,'X'))
      --AND       COALESCE(ExportCargoPickLocationID,0)             = COALESCE(@ExportCargoPickLocationID,COALESCE(ExportCargoPickLocationID,0))
      --AND       COALESCE(ExportCargoPickAddress,'X')              = COALESCE(@ExportCargoPickAddress,COALESCE(ExportCargoPickAddress,'X'))
      --AND       COALESCE(ContainerDropOfLocationID,0)             = COALESCE(@ContainerDropOfLocationID,COALESCE(ContainerDropOfLocationID,0))
      --AND       COALESCE(ContainerDropOfAddress,'X')              = COALESCE(@ContainerDropOfAddress,COALESCE(ContainerDropOfAddress,'X'))
      --AND       COALESCE(ImportContainerDropOption,'X')           = COALESCE(@ImportContainerDropOption,COALESCE(ImportContainerDropOption,'X'))
      --AND       COALESCE(Dispatch_Date,GETDATE())                 = COALESCE(@Dispatch_Date,COALESCE(Dispatch_Date,GETDATE()))
      --AND       COALESCE(ShippingLine,'X')                        = COALESCE(@ShippingLine,COALESCE(ShippingLine,'X'))
      --AND       COALESCE(ContainerTerminalOrYeard,'X')            = COALESCE(@ContainerTerminalOrYeard,COALESCE(ContainerTerminalOrYeard,'X'))
      --AND       COALESCE(BillingType,'X')                         = COALESCE(@BillingType,COALESCE(BillingType,'X'))
      --AND       COALESCE(Status,'X')                              = COALESCE(@Status,COALESCE(Status,'X'))
      --AND       COALESCE(VehicleID,0)                             = COALESCE(@VehicleID,COALESCE(VehicleID,0))
      --AND       COALESCE(DriverID,0)                              = COALESCE(@DriverID,COALESCE(DriverID,0))
      --AND       COALESCE(BrokerID,0)                              = COALESCE(@BrokerID,COALESCE(BrokerID,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
      --AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
      --AND       COALESCE(VehicleTypeId,0)                         = COALESCE(@VehicleTypeId,COALESCE(VehicleTypeId,0))
      --AND       COALESCE(VehicleTypeQuantity,0)                   = COALESCE(@VehicleTypeQuantity,COALESCE(VehicleTypeQuantity,0))
      --AND       COALESCE(ContainerToVehicle,'X')                  = COALESCE(@ContainerToVehicle,COALESCE(ContainerToVehicle,'X'))
      --AND       COALESCE(LoadingUnloadingLocationType,'X')        = COALESCE(@LoadingUnloadingLocationType,COALESCE(LoadingUnloadingLocationType,'X'))
      --AND       COALESCE(LoadingUnloadingExpenseTypeId,0)         = COALESCE(@LoadingUnloadingExpenseTypeId,COALESCE(LoadingUnloadingExpenseTypeId,0))
      --AND       COALESCE(LoadingUnloadingExpenseTypeQty,0)        = COALESCE(@LoadingUnloadingExpenseTypeQty,COALESCE(LoadingUnloadingExpenseTypeQty,0))
      --AND       COALESCE(LoadingUnloadingExpenseTypeCapacity,'X') = COALESCE(@LoadingUnloadingExpenseTypeCapacity,COALESCE(LoadingUnloadingExpenseTypeCapacity,'X'))
      --AND       COALESCE(OtherExpenseTypeId,0)                    = COALESCE(@OtherExpenseTypeId,COALESCE(OtherExpenseTypeId,0))
      --AND       COALESCE(OtherExpenseTypeQty,0)                   = COALESCE(@OtherExpenseTypeQty,COALESCE(OtherExpenseTypeQty,0))
      --AND       COALESCE(OtherExpenseTypeCapacity,'X')            = COALESCE(@OtherExpenseTypeCapacity,COALESCE(OtherExpenseTypeCapacity,'X'))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_ContainerExportOrImport--------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_Containerized]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Containerized                                                                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Saturday, 24 Nov 2018 16:25:16:513                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Containerized](@Action_Type                    numeric(10),
                                   @p_Success                      bit             = 1    OUTPUT,
                                   @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                   @ContainerizedId                bigint          = NULL OUTPUT, 
                                   @ShipmentTypeID                 bigint          = NULL,
                                   @ShipmentType                   nvarchar(50)    = NULL,
                                   @Order_ID                       bigint          = NULL,
                                   @PackageTypeID                  int             = NULL,
                                   @Quantity                       int             = NULL,
                                   @TotalWeight                    float(53)       = NULL,
                                   @Length                         float(53)       = NULL,
                                   @Width                          float(53)       = NULL,
                                   @Height                         float(53)       = NULL,
                                   @LoadQuantityWise               float(53)       = NULL,
                                   @LoadWeightWise                 float(53)       = NULL,
                                   @PickLocationId                 bigint          = NULL,
                                   @PickAddress                    nvarchar(50)    = NULL,
                                   @DropLoctionId                  bigint          = NULL,
                                   @DropAddress                    nvarchar(50)    = NULL,
                                   @Dispatch_date                  datetime        = NULL,
                                   @BillType                       nvarchar(50)    = NULL,
                                   @VehicleId                      bigint          = NULL,
                                   @VehicleTypeId                  bigint          = NULL,
                                   @VehicleTypeQuantity            int             = NULL,
                                   @ContainerTypeId                bigint          = NULL,
                                   @ContainerName                  nvarchar(50)    = NULL,
                                   @ContainerTypeQuantity          int             = NULL,
                                   @Loading                        nvarchar(50)    = NULL,
                                   @LoadingType                    nvarchar(50)    = NULL,
                                   @LoadingQuantity                int             = NULL,
                                   @LoadingCapacity                nvarchar(50)    = NULL,
                                   @OtherEquipmentType             nvarchar(50)    = NULL,
                                   @OtherEquipmentQuantity         int             = NULL,
                                   @OtherEquipmentCapacity         nvarchar(50)    = NULL,
                                   @DriverID                       bigint          = NULL,
                                   @BrokerID                       bigint          = NULL,
                                   @VehicleDispatchDate            datetime        = NULL,
                                   @VehicleOutFormLoading          datetime        = NULL,
                                   @Status                         nvarchar(50)    = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Containerized(ShipmentTypeID,  ShipmentType,  Order_ID,  PackageTypeID,  Quantity,  TotalWeight,  Length,  Width,  Height,  LoadQuantityWise,  LoadWeightWise,  PickLocationId,  PickAddress,  DropLoctionId,  DropAddress,  Dispatch_date,  BillType,  VehicleId,  VehicleTypeId,  VehicleTypeQuantity,  ContainerTypeId,  ContainerName,  ContainerTypeQuantity,  Loading,  LoadingType,  LoadingQuantity,  LoadingCapacity,  OtherEquipmentType,  OtherEquipmentQuantity,  OtherEquipmentCapacity,  DriverID,  BrokerID,  VehicleDispatchDate,  VehicleOutFormLoading,  Status)
      VALUES                      (@ShipmentTypeID, @ShipmentType, @Order_ID, @PackageTypeID, @Quantity, @TotalWeight, @Length, @Width, @Height, @LoadQuantityWise, @LoadWeightWise, @PickLocationId, @PickAddress, @DropLoctionId, @DropAddress, @Dispatch_date, @BillType, @VehicleId, @VehicleTypeId, @VehicleTypeQuantity, @ContainerTypeId, @ContainerName, @ContainerTypeQuantity, @Loading, @LoadingType, @LoadingQuantity, @LoadingCapacity, @OtherEquipmentType, @OtherEquipmentQuantity, @OtherEquipmentCapacity, @DriverID, @BrokerID, @VehicleDispatchDate, @VehicleOutFormLoading, @Status)

      SET       @ContainerizedId               = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Containerized
      SET       ShipmentTypeID                 = COALESCE(@ShipmentTypeID,ShipmentTypeID),
                ShipmentType                   = COALESCE(@ShipmentType,ShipmentType),
                Order_ID                       = COALESCE(@Order_ID,Order_ID),
                PackageTypeID                  = COALESCE(@PackageTypeID,PackageTypeID),
                Quantity                       = COALESCE(@Quantity,Quantity),
                TotalWeight                    = COALESCE(@TotalWeight,TotalWeight),
                Length                         = COALESCE(@Length,Length),
                Width                          = COALESCE(@Width,Width),
                Height                         = COALESCE(@Height,Height),
                LoadQuantityWise               = COALESCE(@LoadQuantityWise,LoadQuantityWise),
                LoadWeightWise                 = COALESCE(@LoadWeightWise,LoadWeightWise),
                PickLocationId                 = COALESCE(@PickLocationId,PickLocationId),
                PickAddress                    = COALESCE(@PickAddress,PickAddress),
                DropLoctionId                  = COALESCE(@DropLoctionId,DropLoctionId),
                DropAddress                    = COALESCE(@DropAddress,DropAddress),
                Dispatch_date                  = COALESCE(@Dispatch_date,Dispatch_date),
                BillType                       = COALESCE(@BillType,BillType),
                VehicleId                      = COALESCE(@VehicleId,VehicleId),
                VehicleTypeId                  = COALESCE(@VehicleTypeId,VehicleTypeId),
                VehicleTypeQuantity            = COALESCE(@VehicleTypeQuantity,VehicleTypeQuantity),
                ContainerTypeId                = COALESCE(@ContainerTypeId,ContainerTypeId),
                ContainerName                  = COALESCE(@ContainerName,ContainerName),
                ContainerTypeQuantity          = COALESCE(@ContainerTypeQuantity,ContainerTypeQuantity),
                Loading                        = COALESCE(@Loading,Loading),
                LoadingType                    = COALESCE(@LoadingType,LoadingType),
                LoadingQuantity                = COALESCE(@LoadingQuantity,LoadingQuantity),
                LoadingCapacity                = COALESCE(@LoadingCapacity,LoadingCapacity),
                OtherEquipmentType             = COALESCE(@OtherEquipmentType,OtherEquipmentType),
                OtherEquipmentQuantity         = COALESCE(@OtherEquipmentQuantity,OtherEquipmentQuantity),
                OtherEquipmentCapacity         = COALESCE(@OtherEquipmentCapacity,OtherEquipmentCapacity),
                DriverID                       = COALESCE(@DriverID,DriverID),
                BrokerID                       = COALESCE(@BrokerID,BrokerID),
                VehicleDispatchDate            = COALESCE(@VehicleDispatchDate,VehicleDispatchDate),
                VehicleOutFormLoading          = COALESCE(@VehicleOutFormLoading,VehicleOutFormLoading),
                Status                         = COALESCE(@Status,Status)
                
      WHERE     ContainerizedId                = @ContainerizedId
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Containerized
      WHERE     ContainerizedId                = @ContainerizedId
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, ContainerizedId, ShipmentTypeID, ShipmentType, Order_ID, PackageTypeID, Quantity, TotalWeight, Length, Width, Height, LoadQuantityWise, LoadWeightWise, PickLocationId, PickAddress, DropLoctionId, DropAddress, Dispatch_date, BillType, VehicleId, VehicleTypeId, VehicleTypeQuantity, ContainerTypeId, ContainerName, ContainerTypeQuantity, Loading, LoadingType, LoadingQuantity, LoadingCapacity, OtherEquipmentType, OtherEquipmentQuantity, OtherEquipmentCapacity, DriverID, BrokerID, VehicleDispatchDate, VehicleOutFormLoading, Status
      FROM      Containerized
      WHERE     ContainerizedId                                   = COALESCE(@ContainerizedId,ContainerizedId)
      AND       COALESCE(ShipmentTypeID,0)                        = COALESCE(@ShipmentTypeID,COALESCE(ShipmentTypeID,0))
      AND       COALESCE(ShipmentType,'X')                        = COALESCE(@ShipmentType,COALESCE(ShipmentType,'X'))
      AND       COALESCE(Order_ID,0)                              = COALESCE(@Order_ID,COALESCE(Order_ID,0))
      AND       COALESCE(PackageTypeID,0)                         = COALESCE(@PackageTypeID,COALESCE(PackageTypeID,0))
      AND       COALESCE(Quantity,0)                              = COALESCE(@Quantity,COALESCE(Quantity,0))
      AND       TotalWeight                                       = COALESCE(@TotalWeight,TotalWeight)
      AND       Length                                            = COALESCE(@Length,Length)
      AND       Width                                             = COALESCE(@Width,Width)
      AND       Height                                            = COALESCE(@Height,Height)
      AND       LoadQuantityWise                                  = COALESCE(@LoadQuantityWise,LoadQuantityWise)
      AND       LoadWeightWise                                    = COALESCE(@LoadWeightWise,LoadWeightWise)
      AND       COALESCE(PickLocationId,0)                        = COALESCE(@PickLocationId,COALESCE(PickLocationId,0))
      AND       COALESCE(PickAddress,'X')                         = COALESCE(@PickAddress,COALESCE(PickAddress,'X'))
      AND       COALESCE(DropLoctionId,0)                         = COALESCE(@DropLoctionId,COALESCE(DropLoctionId,0))
      AND       COALESCE(DropAddress,'X')                         = COALESCE(@DropAddress,COALESCE(DropAddress,'X'))
      AND       COALESCE(Dispatch_date,GETDATE())                 = COALESCE(@Dispatch_date,COALESCE(Dispatch_date,GETDATE()))
      AND       COALESCE(BillType,'X')                            = COALESCE(@BillType,COALESCE(BillType,'X'))
      AND       COALESCE(VehicleId,0)                             = COALESCE(@VehicleId,COALESCE(VehicleId,0))
      AND       COALESCE(VehicleTypeId,0)                         = COALESCE(@VehicleTypeId,COALESCE(VehicleTypeId,0))
      AND       COALESCE(VehicleTypeQuantity,0)                   = COALESCE(@VehicleTypeQuantity,COALESCE(VehicleTypeQuantity,0))
      AND       COALESCE(ContainerTypeId,0)                       = COALESCE(@ContainerTypeId,COALESCE(ContainerTypeId,0))
      AND       COALESCE(ContainerName,'X')                       = COALESCE(@ContainerName,COALESCE(ContainerName,'X'))
      AND       COALESCE(ContainerTypeQuantity,0)                 = COALESCE(@ContainerTypeQuantity,COALESCE(ContainerTypeQuantity,0))
      AND       COALESCE(Loading,'X')                             = COALESCE(@Loading,COALESCE(Loading,'X'))
      AND       COALESCE(LoadingType,'X')                         = COALESCE(@LoadingType,COALESCE(LoadingType,'X'))
      AND       COALESCE(LoadingQuantity,0)                       = COALESCE(@LoadingQuantity,COALESCE(LoadingQuantity,0))
      AND       COALESCE(LoadingCapacity,'X')                     = COALESCE(@LoadingCapacity,COALESCE(LoadingCapacity,'X'))
      AND       COALESCE(OtherEquipmentType,'X')                  = COALESCE(@OtherEquipmentType,COALESCE(OtherEquipmentType,'X'))
      AND       COALESCE(OtherEquipmentQuantity,0)                = COALESCE(@OtherEquipmentQuantity,COALESCE(OtherEquipmentQuantity,0))
      AND       COALESCE(OtherEquipmentCapacity,'X')              = COALESCE(@OtherEquipmentCapacity,COALESCE(OtherEquipmentCapacity,'X'))
      AND       COALESCE(DriverID,0)                              = COALESCE(@DriverID,COALESCE(DriverID,0))
      AND       COALESCE(BrokerID,0)                              = COALESCE(@BrokerID,COALESCE(BrokerID,0))
      AND       COALESCE(VehicleDispatchDate,GETDATE())           = COALESCE(@VehicleDispatchDate,COALESCE(VehicleDispatchDate,GETDATE()))
      AND       COALESCE(VehicleOutFormLoading,GETDATE())         = COALESCE(@VehicleOutFormLoading,COALESCE(VehicleOutFormLoading,GETDATE()))
      AND       COALESCE(Status,'X')                              = COALESCE(@Status,COALESCE(Status,'X'))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Containerized------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_ContainerToVehicle]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_ContainerToVehicle                                                              ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦ ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Tuesday, 27 Nov 2018 23:50:15:627                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_ContainerToVehicle](@Action_Type                    numeric(10),
                                        @p_Success                      bit             = 1    OUTPUT,
                                        @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                        @ContainerToVehicleid           int             = NULL OUTPUT, 
                                        @ContainerToVehicle             nvarchar(50)    = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO ContainerToVehicle(ContainerToVehicle)
      VALUES                           (@ContainerToVehicle)

      SET       @ContainerToVehicleid          = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    ContainerToVehicle
      SET       ContainerToVehicle             = COALESCE(@ContainerToVehicle,ContainerToVehicle)
                
      WHERE     ContainerToVehicleid           = @ContainerToVehicleid
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    ContainerToVehicle
      WHERE     ContainerToVehicleid           = @ContainerToVehicleid
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, ContainerToVehicleid, ContainerToVehicle
      FROM      ContainerToVehicle
      WHERE     ContainerToVehicleid                              = COALESCE(@ContainerToVehicleid,ContainerToVehicleid)
      AND       COALESCE(ContainerToVehicle,'X')                  = COALESCE(@ContainerToVehicle,COALESCE(ContainerToVehicle,'X'))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_ContainerToVehicle-------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_ContainerType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_ContainerType                                                                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Sunday, 03 Mar 2019 00:03:28:397                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_ContainerType](@Action_Type                    numeric(10),
                                   @p_Success                      bit             = 1    OUTPUT,
                                   @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                   @ContainerTypeID                bigint          = NULL OUTPUT, 
                                   @ContainerType                  varchar(50)     = NULL,
                                   @Code                           nvarchar(50)    = NULL,
                                   @DimensionUnitType              varchar(10)     = NULL,
                                   @LowerDeckInnerLength           float(53)       = NULL,
                                   @LowerDeckInnerWidth            float(53)       = NULL,
                                   @LowerDeckInnerHeight           float(53)       = NULL,
                                   @UpperDeckInnerLength           float(53)       = NULL,
                                   @UpperDeckInnerWidth            float(53)       = NULL,
                                   @UpperDeckInnerHeight           float(53)       = NULL,
                                   @LowerDeckOuterLength           float(53)       = NULL,
                                   @LowerDeckOuterWidth            float(53)       = NULL,
                                   @LowerDeckOuterHeight           float(53)       = NULL,
                                   @UpperDeckOuterLength           float(53)       = NULL,
                                   @UpperDeckOuterWidth            float(53)       = NULL,
                                   @UpperDeckOuterHeight           float(53)       = NULL,
                                   @UpperPortionInnerLength        float(53)       = NULL,
                                   @UpperPortionInnerwidth         float(53)       = NULL,
                                   @UpperPortionInnerHeight        float(53)       = NULL,
                                   @LowerPortionInnerLength        float(53)       = NULL,
                                   @LowerPortionInnerWidth         float(53)       = NULL,
                                   @LowerPortionInnerHeight        float(53)       = NULL,
                                   @Description                    varchar(MAX)    = NULL,
                                   @TareWeight                     float(53)       = NULL,
                                   @TareWeightUnit                 float(53)       = NULL,
                                   @CubicCapacity                  float(53)       = NULL,
                                   @CubicCapacityUnit              varchar(20)     = NULL,
                                   @PayLoadWeight                  float(53)       = NULL,
                                   @PayLoadWeightUnit              varchar(20)     = NULL,
                                   @IsActive                       bit             = NULL,
                                   @DateCreated                    datetime        = NULL,
                                   @DateModified                   datetime        = NULL,
                                   @CreatedByUserID                bigint          = NULL,
                                   @ModifiedByUserID               bigint          = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO ContainerType(ContainerType,  Code,  DimensionUnitType,  LowerDeckInnerLength,  LowerDeckInnerWidth,  LowerDeckInnerHeight,  UpperDeckInnerLength,  UpperDeckInnerWidth,  UpperDeckInnerHeight,  LowerDeckOuterLength,  LowerDeckOuterWidth,  LowerDeckOuterHeight,  UpperDeckOuterLength,  UpperDeckOuterWidth,  UpperDeckOuterHeight,  UpperPortionInnerLength,  UpperPortionInnerwidth,  UpperPortionInnerHeight,  LowerPortionInnerLength,  LowerPortionInnerWidth,  LowerPortionInnerHeight,  Description,  TareWeight,  TareWeightUnit,  CubicCapacity,  CubicCapacityUnit,  PayLoadWeight,  PayLoadWeightUnit,  IsActive,  DateCreated,  DateModified,  CreatedByUserID,  ModifiedByUserID)
      VALUES                      (@ContainerType, @Code, @DimensionUnitType, @LowerDeckInnerLength, @LowerDeckInnerWidth, @LowerDeckInnerHeight, @UpperDeckInnerLength, @UpperDeckInnerWidth, @UpperDeckInnerHeight, @LowerDeckOuterLength, @LowerDeckOuterWidth, @LowerDeckOuterHeight, @UpperDeckOuterLength, @UpperDeckOuterWidth, @UpperDeckOuterHeight, @UpperPortionInnerLength, @UpperPortionInnerwidth, @UpperPortionInnerHeight, @LowerPortionInnerLength, @LowerPortionInnerWidth, @LowerPortionInnerHeight, @Description, @TareWeight, @TareWeightUnit, @CubicCapacity, @CubicCapacityUnit, @PayLoadWeight, @PayLoadWeightUnit, @IsActive, @DateCreated, @DateModified, @CreatedByUserID, @ModifiedByUserID)

      SET       @ContainerTypeID               = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    ContainerType
      SET       ContainerType                  = COALESCE(@ContainerType,ContainerType),
                Code                           = COALESCE(@Code,Code),
                DimensionUnitType              = COALESCE(@DimensionUnitType,DimensionUnitType),
                LowerDeckInnerLength           = COALESCE(@LowerDeckInnerLength,LowerDeckInnerLength),
                LowerDeckInnerWidth            = COALESCE(@LowerDeckInnerWidth,LowerDeckInnerWidth),
                LowerDeckInnerHeight           = COALESCE(@LowerDeckInnerHeight,LowerDeckInnerHeight),
                UpperDeckInnerLength           = COALESCE(@UpperDeckInnerLength,UpperDeckInnerLength),
                UpperDeckInnerWidth            = COALESCE(@UpperDeckInnerWidth,UpperDeckInnerWidth),
                UpperDeckInnerHeight           = COALESCE(@UpperDeckInnerHeight,UpperDeckInnerHeight),
                LowerDeckOuterLength           = COALESCE(@LowerDeckOuterLength,LowerDeckOuterLength),
                LowerDeckOuterWidth            = COALESCE(@LowerDeckOuterWidth,LowerDeckOuterWidth),
                LowerDeckOuterHeight           = COALESCE(@LowerDeckOuterHeight,LowerDeckOuterHeight),
                UpperDeckOuterLength           = COALESCE(@UpperDeckOuterLength,UpperDeckOuterLength),
                UpperDeckOuterWidth            = COALESCE(@UpperDeckOuterWidth,UpperDeckOuterWidth),
                UpperDeckOuterHeight           = COALESCE(@UpperDeckOuterHeight,UpperDeckOuterHeight),
                UpperPortionInnerLength        = COALESCE(@UpperPortionInnerLength,UpperPortionInnerLength),
                UpperPortionInnerwidth         = COALESCE(@UpperPortionInnerwidth,UpperPortionInnerwidth),
                UpperPortionInnerHeight        = COALESCE(@UpperPortionInnerHeight,UpperPortionInnerHeight),
                LowerPortionInnerLength        = COALESCE(@LowerPortionInnerLength,LowerPortionInnerLength),
                LowerPortionInnerWidth         = COALESCE(@LowerPortionInnerWidth,LowerPortionInnerWidth),
                LowerPortionInnerHeight        = COALESCE(@LowerPortionInnerHeight,LowerPortionInnerHeight),
                Description                    = COALESCE(@Description,Description),
                TareWeight                     = COALESCE(@TareWeight,TareWeight),
                TareWeightUnit                 = COALESCE(@TareWeightUnit,TareWeightUnit),
                CubicCapacity                  = COALESCE(@CubicCapacity,CubicCapacity),
                CubicCapacityUnit              = COALESCE(@CubicCapacityUnit,CubicCapacityUnit),
                PayLoadWeight                  = COALESCE(@PayLoadWeight,PayLoadWeight),
                PayLoadWeightUnit              = COALESCE(@PayLoadWeightUnit,PayLoadWeightUnit),
                IsActive                       = COALESCE(@IsActive,IsActive),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified),
                CreatedByUserID                = COALESCE(@CreatedByUserID,CreatedByUserID),
                ModifiedByUserID               = COALESCE(@ModifiedByUserID,ModifiedByUserID)
                
      WHERE     ContainerTypeID                = @ContainerTypeID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    ContainerType
      WHERE     ContainerTypeID                = @ContainerTypeID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, ContainerTypeID, ContainerType, Code, DimensionUnitType, LowerDeckInnerLength, LowerDeckInnerWidth, LowerDeckInnerHeight, UpperDeckInnerLength, UpperDeckInnerWidth, UpperDeckInnerHeight, LowerDeckOuterLength, LowerDeckOuterWidth, LowerDeckOuterHeight, UpperDeckOuterLength, UpperDeckOuterWidth, UpperDeckOuterHeight, UpperPortionInnerLength, UpperPortionInnerwidth, UpperPortionInnerHeight, LowerPortionInnerLength, LowerPortionInnerWidth, LowerPortionInnerHeight, Description, TareWeight, TareWeightUnit, CubicCapacity, CubicCapacityUnit, PayLoadWeight, PayLoadWeightUnit, IsActive, DateCreated, DateModified, CreatedByUserID, ModifiedByUserID
      FROM      ContainerType
      WHERE     ContainerTypeID                                   = COALESCE(@ContainerTypeID,ContainerTypeID)
      --AND       COALESCE(ContainerType,'X')                       = COALESCE(@ContainerType,COALESCE(ContainerType,'X'))
      --AND       COALESCE(Code,'X')                                = COALESCE(@Code,COALESCE(Code,'X'))
      --AND       COALESCE(DimensionUnitType,'X')                   = COALESCE(@DimensionUnitType,COALESCE(DimensionUnitType,'X'))
      --AND       LowerDeckInnerLength                              = COALESCE(@LowerDeckInnerLength,LowerDeckInnerLength)
      --AND       LowerDeckInnerWidth                               = COALESCE(@LowerDeckInnerWidth,LowerDeckInnerWidth)
      --AND       LowerDeckInnerHeight                              = COALESCE(@LowerDeckInnerHeight,LowerDeckInnerHeight)
      --AND       UpperDeckInnerLength                              = COALESCE(@UpperDeckInnerLength,UpperDeckInnerLength)
      --AND       UpperDeckInnerWidth                               = COALESCE(@UpperDeckInnerWidth,UpperDeckInnerWidth)
      --AND       UpperDeckInnerHeight                              = COALESCE(@UpperDeckInnerHeight,UpperDeckInnerHeight)
      --AND       LowerDeckOuterLength                              = COALESCE(@LowerDeckOuterLength,LowerDeckOuterLength)
      --AND       LowerDeckOuterWidth                               = COALESCE(@LowerDeckOuterWidth,LowerDeckOuterWidth)
      --AND       LowerDeckOuterHeight                              = COALESCE(@LowerDeckOuterHeight,LowerDeckOuterHeight)
      --AND       UpperDeckOuterLength                              = COALESCE(@UpperDeckOuterLength,UpperDeckOuterLength)
      --AND       UpperDeckOuterWidth                               = COALESCE(@UpperDeckOuterWidth,UpperDeckOuterWidth)
      --AND       UpperDeckOuterHeight                              = COALESCE(@UpperDeckOuterHeight,UpperDeckOuterHeight)
      --AND       UpperPortionInnerLength                           = COALESCE(@UpperPortionInnerLength,UpperPortionInnerLength)
      --AND       UpperPortionInnerwidth                            = COALESCE(@UpperPortionInnerwidth,UpperPortionInnerwidth)
      --AND       UpperPortionInnerHeight                           = COALESCE(@UpperPortionInnerHeight,UpperPortionInnerHeight)
      --AND       LowerPortionInnerLength                           = COALESCE(@LowerPortionInnerLength,LowerPortionInnerLength)
      --AND       LowerPortionInnerWidth                            = COALESCE(@LowerPortionInnerWidth,LowerPortionInnerWidth)
      --AND       LowerPortionInnerHeight                           = COALESCE(@LowerPortionInnerHeight,LowerPortionInnerHeight)
      --AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
      --AND       TareWeight                                        = COALESCE(@TareWeight,TareWeight)
      --AND       TareWeightUnit                                    = COALESCE(@TareWeightUnit,TareWeightUnit)
      --AND       CubicCapacity                                     = COALESCE(@CubicCapacity,CubicCapacity)
      --AND       COALESCE(CubicCapacityUnit,'X')                   = COALESCE(@CubicCapacityUnit,COALESCE(CubicCapacityUnit,'X'))
      --AND       PayLoadWeight                                     = COALESCE(@PayLoadWeight,PayLoadWeight)
      --AND       COALESCE(PayLoadWeightUnit,'X')                   = COALESCE(@PayLoadWeightUnit,COALESCE(PayLoadWeightUnit,'X'))
      --AND       COALESCE(IsActive,0)                              = COALESCE(@IsActive,COALESCE(IsActive,0))
      --AND       COALESCE(DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(DateCreated,GETDATE()))
      --AND       COALESCE(DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(DateModified,GETDATE()))
      --AND       COALESCE(CreatedByUserID,0)                       = COALESCE(@CreatedByUserID,COALESCE(CreatedByUserID,0))
      --AND       COALESCE(ModifiedByUserID,0)                      = COALESCE(@ModifiedByUserID,COALESCE(ModifiedByUserID,0))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_ContainerType------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_Customer]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Customer                                                                                                                     ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Wednesday, 24 Oct 2018 09:03:35:117                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Customer](@Action_Type                    numeric(10),
                              @p_Success                      bit             = 1    OUTPUT,
                              @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                              @CustomerID                     bigint          = NULL OUTPUT, 
                              @CustomerName                   varchar(50)     = NULL,
                              @CustomerCode                   varchar(50)     = NULL,
                              @CustomerAdd                    varchar(50)     = NULL,
                              @Description                    varchar(50)     = NULL,
                              @CustomerContact1               varchar(50)     = NULL,
                              @CustomerContact2               varchar(50)     = NULL,
                              @CustomerEmail                  varchar(50)     = NULL,
                              @WebAdd                         varchar(50)     = NULL,
                            --  @Customerlogo                   image(2147483647) = NULL,
                              @GroupID                        bigint          = NULL,
                              @DateCreated                    datetime        = NULL,
                              @DateModified                   datetime        = NULL,
                              @CreatedByUserID                varchar(50)     = NULL,
                              @ModifiedByUserID               varchar(50)     = NULL,
                              @IsActive                       bit             = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Customer(CustomerName,  CustomerCode,  CustomerAdd,  Description,  CustomerContact1,  CustomerContact2,  CustomerEmail,  WebAdd,    GroupID,  DateCreated,    CreatedByUserID,  ModifiedByUserID,  IsActive)
      VALUES                 (@CustomerName, @CustomerCode, @CustomerAdd, @Description, @CustomerContact1, @CustomerContact2, @CustomerEmail, @WebAdd,  @GroupID, @DateCreated,  @CreatedByUserID, @ModifiedByUserID, @IsActive)

	     SELECT    @Action_Type  AS ActionType, CustomerID, CustomerName, CustomerCode, CustomerAdd, Description, CustomerContact1, CustomerContact2, CustomerEmail, WebAdd,  GroupID, DateCreated, DateModified, CreatedByUserID, ModifiedByUserID, IsActive
       FROM      Customer where IsActive=1;
      SET       @CustomerID                    = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Customer
      SET       CustomerName                   = COALESCE(@CustomerName,CustomerName),
                CustomerCode                   = COALESCE(@CustomerCode,CustomerCode),
                CustomerAdd                    = COALESCE(@CustomerAdd,CustomerAdd),
                Description                    = COALESCE(@Description,Description),
                CustomerContact1               = COALESCE(@CustomerContact1,CustomerContact1),
                CustomerContact2               = COALESCE(@CustomerContact2,CustomerContact2),
                CustomerEmail                  = COALESCE(@CustomerEmail,CustomerEmail),
                WebAdd                         = COALESCE(@WebAdd,WebAdd),
              --  Customerlogo                   = COALESCE(@Customerlogo,Customerlogo),
                GroupID                        = COALESCE(@GroupID,GroupID),
                --DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified),
                CreatedByUserID                = COALESCE(@CreatedByUserID,CreatedByUserID),
                ModifiedByUserID               = COALESCE(@ModifiedByUserID,ModifiedByUserID),
                IsActive                       = COALESCE(@IsActive,IsActive)
                
      WHERE     CustomerID                     = @CustomerID;

	   SELECT    @Action_Type  AS ActionType, CustomerID, CustomerName, CustomerCode, CustomerAdd, Description, CustomerContact1, CustomerContact2, CustomerEmail, WebAdd,  GroupID, DateCreated, DateModified, CreatedByUserID, ModifiedByUserID, IsActive
       FROM      Customer where IsActive=1;
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      update   Customer set IsActive=0
      WHERE     CustomerID                     = @CustomerID;

	   SELECT    @Action_Type  AS ActionType, CustomerID, CustomerName, CustomerCode, CustomerAdd, Description, CustomerContact1, CustomerContact2, CustomerEmail, WebAdd,  GroupID, DateCreated, DateModified, CreatedByUserID, ModifiedByUserID, IsActive
       FROM      Customer where IsActive=1;
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, CustomerID, CustomerName, CustomerCode, CustomerAdd, Description, CustomerContact1, CustomerContact2, CustomerEmail, WebAdd,  GroupID, DateCreated, DateModified, CreatedByUserID, ModifiedByUserID, IsActive
      FROM      Customer
      WHERE    
	-- CustomerID                                        = COALESCE(@CustomerID,CustomerID)
      --AND       COALESCE(CustomerName,'X')                        = COALESCE(@CustomerName,COALESCE(CustomerName,'X'))
      --AND       COALESCE(CustomerCode,'X')                        = COALESCE(@CustomerCode,COALESCE(CustomerCode,'X'))
      --AND       COALESCE(CustomerAdd,'X')                         = COALESCE(@CustomerAdd,COALESCE(CustomerAdd,'X'))
      --AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
      --AND       COALESCE(CustomerContact1,'X')                    = COALESCE(@CustomerContact1,COALESCE(CustomerContact1,'X'))
      --AND       COALESCE(CustomerContact2,'X')                    = COALESCE(@CustomerContact2,COALESCE(CustomerContact2,'X'))
      --AND       COALESCE(CustomerEmail,'X')                       = COALESCE(@CustomerEmail,COALESCE(CustomerEmail,'X'))
    -- AND       COALESCE(WebAdd,'X')                              = COALESCE(@WebAdd,COALESCE(WebAdd,'X'))
      --AND       Customerlogo                                      = COALESCE(@Customerlogo,Customerlogo)
      --AND       COALESCE(GroupID,0)                               = COALESCE(@GroupID,COALESCE(GroupID,0))
      --AND       COALESCE(DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(DateCreated,GETDATE()))
      --AND       COALESCE(DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(DateModified,GETDATE()))
      --AND       COALESCE(CreatedByUserID,'X')                     = COALESCE(@CreatedByUserID,COALESCE(CreatedByUserID,'X'))
      --AND       COALESCE(ModifiedByUserID,'X')                    = COALESCE(@ModifiedByUserID,COALESCE(ModifiedByUserID,'X'))
             COALESCE(IsActive,0)                              = COALESCE(@IsActive,COALESCE(IsActive,0))

	   SET     @p_Success = 1
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Customer-----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_CustomerBillSummary]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_CustomerBillSummary]

(
@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
							 @CompanyCode					nvarchar(5),
							 @DateFrom						date,
							 @DateTo						date,
							 @BillNoFrom					nvarchar(5) =null,
							 @BillNoTo						nvarchar(5) =null
)
AS 
BEGIN
DECLARE @query nvarchar(max)
DECLARE @WHERECLAUSE NVARCHAR(2000)=''
IF @CompanyCode is not null 
BEGIN
 SET @WHERECLAUSE = ' CompanyCode  = '''+@CompanyCode +'''' 
 END
IF  @BillNoFrom is not null  AND @BillNoTo is not null
	SET @WHERECLAUSE = @WHERECLAUSE + '  AND  CAST(BillNo as bigint) >= CAST('''+@BillNoFrom + ''' as nvarchar)   AND  CAST(BillNo as bigint) <= CAST('''+@BillNoTo + ''' as nvarchar)'


IF  @DateFrom is not null AND @DateTo is not null
	SET @WHERECLAUSE = @WHERECLAUSE + ' AND  BillDate between '''+ CONVERT(varchar, @DateFrom, 23) + ''' and '''+ CONVERT(varchar, @DateTo, 23) +''''

SET @QUERY= 'SELECT * FROM (SELECT InvoiceDate ''BillDate'', dbo.udf_GetNumeric(BillCode) ''BillNo'',InvoiceTotalAmount,C.CompanyName,C.CompanyCode FROM Invoices INNER JOIN Company C on Invoices.CompanyId= C.CompanyID and LEFT(BillCode, CHARINDEX(''-'', BillCode) -1)=c.CompanyCode) result
WHERE    '+ @WHERECLAUSE + ' order by BillNo'


print @query
EXEC(@query)
END


GO
/****** Object:  StoredProcedure [dbo].[usp_CustomerProfile]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_CustomerProfile                                                                                                              ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Saturday, 04 May 2019 12:27:11:907                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_CustomerProfile](@Action_Type                    numeric(10),
                                     @p_Success                      bit             = 1    OUTPUT,
                                     @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                     @ProfileId                      bigint          = NULL OUTPUT, 
                                     @CustomerName                   nvarchar(50)    = NULL,
                                     @CustomerCode                   nvarchar(50)    = NULL,
                                     @CustomerId                     bigint          = NULL,
                                     @OwnCompanyId                   bigint          = NULL,
                                     @PaymentTerm                    nvarchar(50)    = NULL,
                                     @CreditTerm                     nvarchar(50)    = NULL,
                                     @InvoiceFormat                  nvarchar(250)   = NULL,
									 @isHide						 bit			 = NULL,
                                     @CreatedDate                    date            = NULL,
									 @IsAdditionalCharges			 bit			=NULL,
									 @IsLaborCharges				 bit			=NULL,
                                     @ModifiedDate                   date            = NULL,
                                     @CreatedBy                      bigint          = NULL,
                                     @ModifiedBy                     bigint          = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO CustomerProfile(CustomerName,  CustomerCode,  CustomerId,  OwnCompanyId,  PaymentTerm,  CreditTerm,  InvoiceFormat,isHide , CreatedDate,  ModifiedDate,  CreatedBy,  ModifiedBy,IsAdditionalCharges,IsLaborCharges)
      VALUES                        (@CustomerName, @CustomerCode, @CustomerId, @OwnCompanyId, @PaymentTerm, @CreditTerm, @InvoiceFormat,@isHide , @CreatedDate, @ModifiedDate, @CreatedBy, @ModifiedBy,@IsAdditionalCharges,@IsLaborCharges)

      SET       @ProfileId                     = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    CustomerProfile
      SET       CustomerName                   = COALESCE(@CustomerName,CustomerName),
                CustomerCode                   = COALESCE(@CustomerCode,CustomerCode),
                CustomerId                     = COALESCE(@CustomerId,CustomerId),
                OwnCompanyId                   = COALESCE(@OwnCompanyId,OwnCompanyId),
                PaymentTerm                    = COALESCE(@PaymentTerm,PaymentTerm),
                CreditTerm                     = COALESCE(@CreditTerm,CreditTerm),
                InvoiceFormat                  = COALESCE(@InvoiceFormat,InvoiceFormat),
				isHide						   = COALESCE(@isHide,isHide),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
				IsAdditionalCharges                     = COALESCE(@IsAdditionalCharges,IsAdditionalCharges),
				IsLaborCharges                     = COALESCE(@IsLaborCharges,IsLaborCharges)
                
      WHERE     ProfileId                      = @ProfileId
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    CustomerProfile
      WHERE     ProfileId                      = @ProfileId
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
     -- SELECT    @Action_Type  AS ActionType, ProfileId, CustomerName, CustomerCode, CustomerId, OwnCompanyId, PaymentTerm, CreditTerm, InvoiceFormat, CreatedDate, ModifiedDate, CreatedBy, ModifiedBy
     -- FROM      CustomerProfile

	    SELECT @Action_Type  AS ActionType, CP.*,OWNC.CompanyName 'OwnCompany',OWNC.CompanyCode 'OwnCompanyCode',C.CompanyName 'CompanyName',C.CompanyCode 'CompanyCode' FROM CUSTOMERPROFILE CP
  INNER JOIN OwnCompany OWNC on CP.OwnCompanyId=OWNC.CompanyID
  INNER JOIN Company C on CP.CustomerId=C.CompanyID
      WHERE     ProfileId                                         = COALESCE(@ProfileId,ProfileId)
      --AND       COALESCE(CustomerName,'X')                        = COALESCE(@CustomerName,COALESCE(CustomerName,'X'))
      --AND       COALESCE(CustomerCode,'X')                        = COALESCE(@CustomerCode,COALESCE(CustomerCode,'X'))
      --AND       COALESCE(CustomerId,0)                            = COALESCE(@CustomerId,COALESCE(CustomerId,0))
      --AND       COALESCE(OwnCompanyId,0)                          = COALESCE(@OwnCompanyId,COALESCE(OwnCompanyId,0))
      --AND       COALESCE(PaymentTerm,'X')                         = COALESCE(@PaymentTerm,COALESCE(PaymentTerm,'X'))
      --AND       COALESCE(CreditTerm,'X')                          = COALESCE(@CreditTerm,COALESCE(CreditTerm,'X'))
      --AND       COALESCE(InvoiceFormat,'X')                       = COALESCE(@InvoiceFormat,COALESCE(InvoiceFormat,'X'))
      --AND       COALESCE(CP.CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CP.CreatedDate,GETDATE()))
      --AND       COALESCE(CP.ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(CP.ModifiedDate,GETDATE()))
      --AND       COALESCE(CP.CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CP.CreatedBy,0))
      --AND       COALESCE(CP.ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(CP.ModifiedBy,0))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_CustomerProfile----------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------





GO
/****** Object:  StoredProcedure [dbo].[usp_CustomerProfileDetail]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_CustomerProfileDetail                                                           ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  Aneel Kumar Lalwani                                                               ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Monday, 06 May 2019 12:58:57:977                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_CustomerProfileDetail](@Action_Type                    numeric(10),
                                           @p_Success                      bit             = 1    OUTPUT,
                                           @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                           @ProfileDetail                  bigint          = NULL OUTPUT, 
                                           @ProfileId                      bigint          = NULL,
                                           @ProductCode                    nvarchar(50)    = NULL,
                                           @ProductId                      bigint          = NULL,
                                           @LocationFrom                   bigint          = NULL,
                                           @LocationTo                     bigint          = NULL,
                                           @RateType                       nvarchar(50)       = NULL,
                                           @DoorStepRate                   bigint          = NULL,
                                           @Total                          float(53)       = NULL,
                                           @Active                         bigint          = NULL,
                                           @CreatedDate                    datetime            = NULL,
                                           @ModifiedDate                   datetime            = NULL,
                                           @CreatedBy                      bigint          = NULL,
                                           @ModifiedBy                     bigint          = NULL,
										   @Rate float=0.00,
										   @WeightPerUnit float=0.00,
										   @AdditionCharges float=null,
										   @LabourCharges float=null)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO CustomerProfileDetail(ProfileId,  ProductCode,  ProductId,  LocationFrom,  LocationTo,  RateType,  DoorStepRate,  Total,  Active,  CreatedDate,  ModifiedDate,  CreatedBy,  ModifiedBy,Rate,WeightPerUnit,AdditionCharges,LabourCharges)
      VALUES                              (@ProfileId, @ProductCode, @ProductId, @LocationFrom, @LocationTo, @RateType, @DoorStepRate, @Total, @Active, @CreatedDate, @ModifiedDate, @CreatedBy, @ModifiedBy,@Rate,@WeightPerUnit,@AdditionCharges,@LabourCharges)

      SET       @ProfileDetail                 = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    CustomerProfileDetail
      SET       ProfileId                      = COALESCE(@ProfileId,ProfileId),
                ProductCode                    = COALESCE(@ProductCode,ProductCode),
                ProductId                      = COALESCE(@ProductId,ProductId),
                LocationFrom                   = COALESCE(@LocationFrom,LocationFrom),
                LocationTo                     = COALESCE(@LocationTo,LocationTo),
                RateType                       = COALESCE(@RateType,RateType),
                DoorStepRate                   = COALESCE(@DoorStepRate,DoorStepRate),
                Total                          = COALESCE(@Total,Total),
                Active                         = COALESCE(@Active,Active),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
				Rate                     = COALESCE(@Rate,Rate),
				WeightPerUnit=  COALESCE(@WeightPerUnit,WeightPerUnit),
				AdditionCharges=  COALESCE(@AdditionCharges,AdditionCharges),
				LabourCharges=  COALESCE(@LabourCharges,LabourCharges)
                
                
      WHERE     ProfileDetail                  = @ProfileDetail
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    CustomerProfileDetail
      WHERE     ProfileDetail                  = @ProfileDetail
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
   
	  
	    SELECT    @Action_Type  AS ActionType, C1.CityName 'LocationFromName',C2.CityName 'LocationToName',P.Name 'ProductName',pt.PackageTypeName,p.Code,CP.CustomerId, CPD.* FROM CUSTOMERPROFILE CP
	  INNER JOIN CUSTOMERPROFILEDETAIL  CPD on CP.ProfileId=CPD.ProfileId
	  inner join City C1 on CPD.LocationFrom=C1.CityID
	  inner join City C2 on CPD.LocationTo=C2.CityID
	  inner join Product P on CPD.ProductId = P.ID
	  inner join Company C  on CP.CustomerId = C.CompanyID
	  left join PackageType PT on P.PackageTypeID=pt.PackageTypeID
   
  WHERE 
 
	 COALESCE(CPD.ProfileId,0)                             = COALESCE(@ProfileId,COALESCE(CPD.ProfileId,0))
	 AND
	 COALESCE(CPD.ProductId,0)                             = COALESCE(@ProductId,COALESCE(CPD.ProductId,0))
	-- and  COALESCE(CP.CustomerId,0)                             = COALESCE(@ProductId,COALESCE(CP.CustomerId,0))
	AND  COALESCE(CPD.LocationFrom,0)                             = COALESCE(@LocationFrom,COALESCE(CPD.LocationFrom,0))
	AND  COALESCE(CPD.LocationTo,0)                             = COALESCE(@LocationTo,COALESCE(CPD.LocationTo,0))
	
	
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_CustomerProfileDetail----------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_CustomerProfileDetail_audit]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[usp_CustomerProfileDetail_audit]( @Action_Type                    numeric(10),
                                           @p_Success                      bit             = 1    OUTPUT,
                                           @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                           @ProfileDetailID                      bigint          = NULL)
										   AS
										   BEGIN
										   SELECt UserAccounts.UserName, C1.CityName 'LocationFromName',C2.CityName 'LocationToName',P.Name 'ProductName',p.Code,CP.CustomerId, CPD.* FROM CUSTOMERPROFILE CP
	  INNER JOIN CUSTOMERPROFILEDETAIL_Audit  CPD on CP.ProfileId=CPD.ProfileId
	  inner join City C1 on CPD.LocationFrom=C1.CityID
	  inner join City C2 on CPD.LocationTo=C2.CityID
	  inner join Product P on CPD.ProductId = P.ID
	  inner join Company C  on CP.CustomerId = C.CompanyID
	  inner join UserAccounts on ISNULL(CPD.ModifiedBy,CPD.CreatedBy)=UserAccounts.UserID
	  WHERE CPD.ProfileDetail=@ProfileDetailID
	  Order by AuditDateTime desc
										   END


GO
/****** Object:  StoredProcedure [dbo].[usp_Department]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Department                                                                                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Saturday, 16 Feb 2019 23:35:26:437                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Department](@Action_Type                    numeric(10),
                                @p_Success                      bit             = 1    OUTPUT,
                                @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                @DepartID                       bigint          = NULL OUTPUT, 
                                @DepartCode                     varchar(50)     = NULL,
                                @DepartName                     varchar(50)     = NULL,
                                @Contact                        varchar(50)     = NULL,
                                @ContactOther                   varchar(50)     = NULL,
                                @EmailAdd                       varchar(50)     = NULL,
                                @WebAdd                         varchar(50)     = NULL,
                                @Address                        varchar(50)     = NULL,
                                @CustomerID                     bigint          = NULL,
                                @DateCreated                    datetime        = NULL,
                                @DateModified                   datetime        = NULL,
                                @CreatedByUserID                bigint          = NULL,
                                @ModifiedByUser                 bigint          = NULL,
                                @Description                    varchar(50)     = NULL,
                                @IsActive                       bit             = NULL,
                                @GROUPID                        bigint          = NULL,
                                @COMPANYID                      bigint          = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Department(DepartCode,  DepartName,  Contact,  ContactOther,  EmailAdd,  WebAdd,  Address,  CustomerID,  DateCreated,  DateModified,  CreatedByUserID,  ModifiedByUser,  Description,  IsActive,  GROUPID,  COMPANYID)
      VALUES                   (@DepartCode, @DepartName, @Contact, @ContactOther, @EmailAdd, @WebAdd, @Address, @CustomerID, @DateCreated, @DateModified, @CreatedByUserID, @ModifiedByUser, @Description, @IsActive, @GROUPID, @COMPANYID)

      SET       @DepartID                      = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Department
      SET       DepartCode                     = COALESCE(@DepartCode,DepartCode),
                DepartName                     = COALESCE(@DepartName,DepartName),
                Contact                        = COALESCE(@Contact,Contact),
                ContactOther                   = COALESCE(@ContactOther,ContactOther),
                EmailAdd                       = COALESCE(@EmailAdd,EmailAdd),
                WebAdd                         = COALESCE(@WebAdd,WebAdd),
                Address                        = COALESCE(@Address,Address),
                CustomerID                     = COALESCE(@CustomerID,CustomerID),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified),
                CreatedByUserID                = COALESCE(@CreatedByUserID,CreatedByUserID),
                ModifiedByUser                 = COALESCE(@ModifiedByUser,ModifiedByUser),
                Description                    = COALESCE(@Description,Description),
                IsActive                       = COALESCE(@IsActive,IsActive),
                GROUPID                        = COALESCE(@GROUPID,GROUPID),
                COMPANYID                      = COALESCE(@COMPANYID,COMPANYID)
                
      WHERE     DepartID                       = @DepartID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Department
      WHERE     DepartID                       = @DepartID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
   SELECT @Action_Type  AS ActionType, D.*,G.GroupName,C.CompanyName FROM Department D
 INNER JOIN GROUPS G  on D.GROUPID =G.GroupID
 INNER JOIN  COMPANY C on D.companyid=C.CompanyID
      WHERE     DepartID                                          = COALESCE(@DepartID,DepartID)
      AND       COALESCE(DepartCode,'X')                          = COALESCE(@DepartCode,COALESCE(DepartCode,'X'))
      AND       COALESCE(DepartName,'X')                          = COALESCE(@DepartName,COALESCE(DepartName,'X'))
      AND       COALESCE(D.Contact,'X')                            = COALESCE(@Contact,COALESCE(D.Contact,'X'))
      AND       COALESCE(D.ContactOther,'X')                        = COALESCE(@ContactOther,COALESCE(D.ContactOther,'X'))
      AND       COALESCE(D.EmailAdd,'X')                            = COALESCE(@EmailAdd,COALESCE(D.EmailAdd,'X'))
      AND       COALESCE(D.WebAdd,'X')                              = COALESCE(@WebAdd,COALESCE(D.WebAdd,'X'))
      AND       COALESCE(D.Address,'X')                             = COALESCE(@Address,COALESCE(D.Address,'X'))
      AND       COALESCE(CustomerID,0)                            = COALESCE(@CustomerID,COALESCE(CustomerID,0))
      AND       COALESCE(D.DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(D.DateCreated,GETDATE()))
      AND       COALESCE(D.DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(D.DateModified,GETDATE()))
      AND       COALESCE(D.CreatedByUserID,0)                       = COALESCE(@CreatedByUserID,COALESCE(D.CreatedByUserID,0))
      AND       COALESCE(D.ModifiedByUser,0)                        = COALESCE(@ModifiedByUser,COALESCE(D.ModifiedByUser,0))
      AND       COALESCE(D.Description,'X')                         = COALESCE(@Description,COALESCE(D.Description,'X'))
      AND       COALESCE(D.IsActive,0)                              = COALESCE(@IsActive,COALESCE(D.IsActive,0))
      AND       D.GROUPID                                           = COALESCE(@GROUPID,D.GROUPID)
      AND       D.COMPANYID                                         = COALESCE(@COMPANYID,D.COMPANYID)
	  END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Department---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------



GO
/****** Object:  StoredProcedure [dbo].[usp_DepartmentPerson]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_DepartmentPerson                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦ ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Saturday, 01 Dec 2018 19:59:12:920                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_DepartmentPerson](@Action_Type                    numeric(10),
                                      @p_Success                      bit             = 1    OUTPUT,
                                      @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                      @PersonalID                     bigint          = NULL OUTPUT, 
                                      @Code                           nvarchar(50)    = NULL,
                                      @Name                           nvarchar(50)    = NULL,
                                      @Email                          nvarchar(50)    = NULL,
                                      @BusinessEmail                  nvarchar(50)    = NULL,
                                      @GroupID                        bigint          = NULL,
                                      @CompanyID                      bigint          = NULL,
                                      @DepartmentID                   bigint          = NULL,
                                      @Designation                    nvarchar(50)    = NULL,
                                      @Cell                           nvarchar(50)    = NULL,
                                      @PhoneNo                        nvarchar(50)    = NULL,
                                      @OtherContact                   nvarchar(50)    = NULL,
                                      @AddressOffice                  nvarchar(255)   = NULL,
                                      @AddressOther                   nvarchar(255)   = NULL,
                                      @Description                    nvarchar(255)   = NULL,
                                      @IsIndividual                   bit             = NULL,
                                      @Active                         bit             = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO DepartmentPerson(Code,  Name,  Email,  BusinessEmail,  GroupID,  CompanyID,  DepartmentID,  Designation,  Cell,  PhoneNo,  OtherContact,  AddressOffice,  AddressOther,  Description,  IsIndividual,  Active)
      VALUES                         (@Code, @Name, @Email, @BusinessEmail, @GroupID, @CompanyID, @DepartmentID, @Designation, @Cell, @PhoneNo, @OtherContact, @AddressOffice, @AddressOther, @Description, @IsIndividual, @Active)

      SET       @PersonalID                    = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    DepartmentPerson
      SET       Code                           = COALESCE(@Code,Code),
                Name                           = COALESCE(@Name,Name),
                Email                          = COALESCE(@Email,Email),
                BusinessEmail                  = COALESCE(@BusinessEmail,BusinessEmail),
                GroupID                        = COALESCE(@GroupID,GroupID),
                CompanyID                      = COALESCE(@CompanyID,CompanyID),
                DepartmentID                   = COALESCE(@DepartmentID,DepartmentID),
                Designation                    = COALESCE(@Designation,Designation),
                Cell                           = COALESCE(@Cell,Cell),
                PhoneNo                        = COALESCE(@PhoneNo,PhoneNo),
                OtherContact                   = COALESCE(@OtherContact,OtherContact),
                AddressOffice                  = COALESCE(@AddressOffice,AddressOffice),
                AddressOther                   = COALESCE(@AddressOther,AddressOther),
                Description                    = COALESCE(@Description,Description),
                IsIndividual                   = COALESCE(@IsIndividual,IsIndividual),
                Active                         = COALESCE(@Active,Active)
                
      WHERE     PersonalID                     = @PersonalID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    DepartmentPerson
      WHERE     PersonalID                     = @PersonalID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
     SELECT P.*,G.GroupName,C.CompanyName,D.DepartName  FROM DepartmentPerson P
	LEFT JOIN GROUPS G ON P.GroupID=G.GroupID
	LEFT JOIN COMPANY C ON P.CompanyID=C.CompanyID
	LEFT JOIN Department D ON P.DepartmentID=D.DepartID
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_DepartmentPerson---------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_DocumentType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_DocumentType                                                                                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Tuesday, 19 Mar 2019 12:56:08:670                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_DocumentType](@Action_Type                    numeric(10),
                                  @p_Success                      bit             = 1    OUTPUT,
                                  @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                  @DocumentTypeID                 bigint          = NULL OUTPUT, 
                                  @Code                           nvarchar(50)    = NULL,
                                  @Name                           nvarchar(50)    = NULL,
                                  @Description                    nvarchar(100)   = NULL,
                                  @isActive                       bit             = NULL,
                                  @CreatedByID                    bigint          = NULL,
                                  @ModifiedByID                   bigint          = NULL,
                                  @DateCreated                    datetime        = NULL,
                                  @DateModified                   datetime        = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO DocumentType(Code,  Name,  Description,  isActive,  CreatedByID,  ModifiedByID,  DateCreated,  DateModified)
      VALUES                     (@Code, @Name, @Description, @isActive, @CreatedByID, @ModifiedByID, @DateCreated, @DateModified)

      SET       @DocumentTypeID                = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    DocumentType
      SET       Code                           = COALESCE(@Code,Code),
                Name                           = COALESCE(@Name,Name),
                Description                    = COALESCE(@Description,Description),
                isActive                       = COALESCE(@isActive,isActive),
                CreatedByID                    = COALESCE(@CreatedByID,CreatedByID),
                ModifiedByID                   = COALESCE(@ModifiedByID,ModifiedByID),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified)
                
      WHERE     DocumentTypeID                 = @DocumentTypeID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    DocumentType
      WHERE     DocumentTypeID                 = @DocumentTypeID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, DocumentTypeID, Code, Name, Description, isActive, CreatedByID, ModifiedByID, DateCreated, DateModified
      FROM      DocumentType
      WHERE     DocumentTypeID                                    = COALESCE(@DocumentTypeID,DocumentTypeID)
      AND       COALESCE(Code,'X')                                = COALESCE(@Code,COALESCE(Code,'X'))
      AND       COALESCE(Name,'X')                                = COALESCE(@Name,COALESCE(Name,'X'))
      AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
      AND       COALESCE(isActive,0)                              = COALESCE(@isActive,COALESCE(isActive,0))
      AND       COALESCE(CreatedByID,0)                           = COALESCE(@CreatedByID,COALESCE(CreatedByID,0))
      AND       COALESCE(ModifiedByID,0)                          = COALESCE(@ModifiedByID,COALESCE(ModifiedByID,0))
      AND       COALESCE(DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(DateCreated,GETDATE()))
      AND       COALESCE(DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(DateModified,GETDATE()))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_DocumentType-------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_Driver]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Driver                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦ ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Thursday, 13 Dec 2018 10:12:18:663                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Driver](@Action_Type                    numeric(10),
                            @p_Success                      bit             = 1    OUTPUT,
                            @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                            @ID                             bigint          = NULL OUTPUT, 
                            @Code                           nvarchar(50)    = NULL,
                            @Name                           nvarchar(50)    = NULL,
                            @FatherName                     nvarchar(50)    = NULL,
                            @Type                           nvarchar(50)    = NULL,
                            @DateOfBirth                    datetime        = NULL,
                            @Gender                         nvarchar(50)    = NULL,
                            @BloodGroup                     nvarchar(50)    = NULL,
                            @CellNo                         bigint          = NULL,
                            @OtherContact                   bigint          = NULL,
                            @HomeNo                         bigint          = NULL,
                            @Address                        nvarchar(200)   = NULL,
                            @NIC                            bigint          = NULL,
                            @IdentityMark                   nvarchar(50)    = NULL,
                            @NICIssueDate                   datetime        = NULL,
                            @NICExpiryDate                  datetime        = NULL,
                            @LicenseNo                      nvarchar(50)    = NULL,
                            @LicenseCategory                nvarchar(50)    = NULL,
                            @LicenseIssueDate               datetime        = NULL,
                            @LicenseExpiryDate              datetime        = NULL,
                            @LicenseIssuingAuthority        nvarchar(50)    = NULL,
                            @LicenseStatus                  nvarchar(50)    = NULL,
                            @EmergencyContactName           nvarchar(50)    = NULL,
                            @EmergencyContactNo             bigint          = NULL,
                            @ContactRelation                nvarchar(50)    = NULL,
                            @Description                    nvarchar(250)   = NULL,
                            @Active                         bit             = NULL,
                            @CreatedBy                      bigint          = NULL,
                            @CreatedDate                    datetime        = NULL,
                            @ModifiedBy                     bigint          = NULL,
                            @ModifiedDate                   datetime        = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Driver(Code,  Name,  FatherName,  Type,  DateOfBirth,  Gender,  BloodGroup,  CellNo,  OtherContact,  HomeNo,  Address,  NIC,  IdentityMark,  NICIssueDate,  NICExpiryDate,  LicenseNo,  LicenseCategory,  LicenseIssueDate,  LicenseExpiryDate,  LicenseIssuingAuthority,  LicenseStatus,  EmergencyContactName,  EmergencyContactNo,  ContactRelation,  Description,  Active,  CreatedBy,  CreatedDate,  ModifiedBy,  ModifiedDate)
      VALUES               (@Code, @Name, @FatherName, @Type, @DateOfBirth, @Gender, @BloodGroup, @CellNo, @OtherContact, @HomeNo, @Address, @NIC, @IdentityMark, @NICIssueDate, @NICExpiryDate, @LicenseNo, @LicenseCategory, @LicenseIssueDate, @LicenseExpiryDate, @LicenseIssuingAuthority, @LicenseStatus, @EmergencyContactName, @EmergencyContactNo, @ContactRelation, @Description, @Active, @CreatedBy, @CreatedDate, @ModifiedBy, @ModifiedDate)

      SET       @ID                            = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Driver
      SET       Code                           = COALESCE(@Code,Code),
                Name                           = COALESCE(@Name,Name),
                FatherName                     = COALESCE(@FatherName,FatherName),
                Type                           = COALESCE(@Type,Type),
                DateOfBirth                    = COALESCE(@DateOfBirth,DateOfBirth),
                Gender                         = COALESCE(@Gender,Gender),
                BloodGroup                     = COALESCE(@BloodGroup,BloodGroup),
                CellNo                         = COALESCE(@CellNo,CellNo),
                OtherContact                   = COALESCE(@OtherContact,OtherContact),
                HomeNo                         = COALESCE(@HomeNo,HomeNo),
                Address                        = COALESCE(@Address,Address),
                NIC                            = COALESCE(@NIC,NIC),
                IdentityMark                   = COALESCE(@IdentityMark,IdentityMark),
                NICIssueDate                   = COALESCE(@NICIssueDate,NICIssueDate),
                NICExpiryDate                  = COALESCE(@NICExpiryDate,NICExpiryDate),
                LicenseNo                      = COALESCE(@LicenseNo,LicenseNo),
                LicenseCategory                = COALESCE(@LicenseCategory,LicenseCategory),
                LicenseIssueDate               = COALESCE(@LicenseIssueDate,LicenseIssueDate),
                LicenseExpiryDate              = COALESCE(@LicenseExpiryDate,LicenseExpiryDate),
                LicenseIssuingAuthority        = COALESCE(@LicenseIssuingAuthority,LicenseIssuingAuthority),
                LicenseStatus                  = COALESCE(@LicenseStatus,LicenseStatus),
                EmergencyContactName           = COALESCE(@EmergencyContactName,EmergencyContactName),
                EmergencyContactNo             = COALESCE(@EmergencyContactNo,EmergencyContactNo),
                ContactRelation                = COALESCE(@ContactRelation,ContactRelation),
                Description                    = COALESCE(@Description,Description),
                Active                         = COALESCE(@Active,Active),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate)
                
      WHERE     ID                             = @ID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Driver
      WHERE     ID                             = @ID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, ID, Code, Name, FatherName, Type, DateOfBirth, Gender, BloodGroup, CellNo, OtherContact, HomeNo, Address, NIC, IdentityMark, NICIssueDate, NICExpiryDate, LicenseNo, LicenseCategory, LicenseIssueDate, LicenseExpiryDate, LicenseIssuingAuthority, LicenseStatus, EmergencyContactName, EmergencyContactNo, ContactRelation, Description, Active, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
      FROM      Driver
      WHERE     ID                                                = COALESCE(@ID,ID)
      AND       COALESCE(Code,'X')                                = COALESCE(@Code,COALESCE(Code,'X'))
      AND       COALESCE(Name,'X')                                = COALESCE(@Name,COALESCE(Name,'X'))
      AND       COALESCE(FatherName,'X')                          = COALESCE(@FatherName,COALESCE(FatherName,'X'))
      AND       COALESCE(Type,'X')                                = COALESCE(@Type,COALESCE(Type,'X'))
      AND       COALESCE(DateOfBirth,GETDATE())                   = COALESCE(@DateOfBirth,COALESCE(DateOfBirth,GETDATE()))
      AND       COALESCE(Gender,'X')                              = COALESCE(@Gender,COALESCE(Gender,'X'))
      AND       COALESCE(BloodGroup,'X')                          = COALESCE(@BloodGroup,COALESCE(BloodGroup,'X'))
      AND       COALESCE(CellNo,0)                                = COALESCE(@CellNo,COALESCE(CellNo,0))
      AND       COALESCE(OtherContact,0)                          = COALESCE(@OtherContact,COALESCE(OtherContact,0))
      AND       COALESCE(HomeNo,0)                                = COALESCE(@HomeNo,COALESCE(HomeNo,0))
      AND       COALESCE(Address,'X')                             = COALESCE(@Address,COALESCE(Address,'X'))
      AND       COALESCE(NIC,0)                                   = COALESCE(@NIC,COALESCE(NIC,0))
      AND       COALESCE(IdentityMark,'X')                        = COALESCE(@IdentityMark,COALESCE(IdentityMark,'X'))
      AND       COALESCE(NICIssueDate,GETDATE())                  = COALESCE(@NICIssueDate,COALESCE(NICIssueDate,GETDATE()))
      AND       COALESCE(NICExpiryDate,GETDATE())                 = COALESCE(@NICExpiryDate,COALESCE(NICExpiryDate,GETDATE()))
      AND       COALESCE(LicenseNo,'X')                           = COALESCE(@LicenseNo,COALESCE(LicenseNo,'X'))
      AND       COALESCE(LicenseCategory,'X')                     = COALESCE(@LicenseCategory,COALESCE(LicenseCategory,'X'))
      AND       COALESCE(LicenseIssueDate,GETDATE())              = COALESCE(@LicenseIssueDate,COALESCE(LicenseIssueDate,GETDATE()))
      AND       COALESCE(LicenseExpiryDate,GETDATE())             = COALESCE(@LicenseExpiryDate,COALESCE(LicenseExpiryDate,GETDATE()))
      AND       COALESCE(LicenseIssuingAuthority,'X')             = COALESCE(@LicenseIssuingAuthority,COALESCE(LicenseIssuingAuthority,'X'))
      AND       COALESCE(LicenseStatus,'X')                       = COALESCE(@LicenseStatus,COALESCE(LicenseStatus,'X'))
      AND       COALESCE(EmergencyContactName,'X')                = COALESCE(@EmergencyContactName,COALESCE(EmergencyContactName,'X'))
      AND       COALESCE(EmergencyContactNo,0)                    = COALESCE(@EmergencyContactNo,COALESCE(EmergencyContactNo,0))
      AND       COALESCE(ContactRelation,'X')                     = COALESCE(@ContactRelation,COALESCE(ContactRelation,'X'))
      AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
      AND       COALESCE(Active,0)                                = COALESCE(@Active,COALESCE(Active,0))
      AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
      AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Driver-------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_DriverChallan]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_DriverChallan                                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  Kamran Athar Janweri                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Wednesday, 15 May 2019 13:09:59:863                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_DriverChallan](@Action_Type                    numeric(10),
                                   @p_Success                      bit             = 1    OUTPUT,
                                   @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                   @ChallanId                      bigint          = NULL OUTPUT, 
                                   @BiltyNos                       nvarchar(1000)  = NULL,
                                   @ChallanNo                      nvarchar(10)    = NULL,
                                   @ChallanDate                    datetime        = NULL,
                                   @VehicleId                      bigint          = NULL,
                                   @DriverId                       bigint          = NULL,
                                   @Mobile                         nvarchar(50)    = NULL,
                                   @BrokerId                       bigint          = NULL,
                                   @CreatedDate                    datetime        = NULL,
                                   @CreadtedBy                     bigint          = NULL,
                                   @ModifiedBy                     bigint          = NULL,
                                   @ModifiedDate                   datetime        = NULL,
								   @DriverName						nvarchar(50)  =null,
								   @VehicleNo						nvarchar(50)  =null)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO DriverChallan(BiltyNos,  ChallanNo,  ChallanDate,  VehicleId,  DriverId,  Mobile,  BrokerId,  CreatedDate,  CreadtedBy,  ModifiedBy,  ModifiedDate,DriverName,VehicleNo)
      VALUES                      (@BiltyNos, [dbo].[ChallanGenerator](''), @ChallanDate, 0, 0, @Mobile, @BrokerId, @CreatedDate, @CreadtedBy, @ModifiedBy, @ModifiedDate,@DriverName,@VehicleNo)

      SET       @ChallanId                     = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    DriverChallan
      SET       BiltyNos                       = COALESCE(@BiltyNos,BiltyNos),
                ChallanNo                      = COALESCE(@ChallanNo,ChallanNo),
                ChallanDate                    = COALESCE(@ChallanDate,ChallanDate),
               -- VehicleId                      = COALESCE(@VehicleId,VehicleId),
                --DriverId                       = COALESCE(@DriverId,DriverId),
                Mobile                         = COALESCE(@Mobile,Mobile),
                BrokerId                       = COALESCE(@BrokerId,BrokerId),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                CreadtedBy                     = COALESCE(@CreadtedBy,CreadtedBy),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate)
                ,DriverName =   COALESCE(@DriverName,DriverName)
				,VehicleNo =  COALESCE(@VehicleNo,VehicleNo)
      WHERE     ChallanId                      = @ChallanId
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    DriverChallan
      WHERE     ChallanId                      = @ChallanId
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, ISNULL(D.Name,DC.DriverName) 'DriverName',ISNULL(D.CellNo,'000') 'DriverNo',ISNULL(B.Name,'') 'BrokerName',ISNULL(V.RegNo,DC.VehicleNo) VehicleCode  , DC.*
      FROM      DriverChallan DC
	  LEFT JOIN Driver D on DC.DriverId=D.ID
	  LEFT JOIN Brokers B on DC.BrokerId=B.ID
	  LEFT JOIN Vehicle V on DC.VehicleId=V.VehicleID 
      WHERE     DC.ChallanId                                         = COALESCE(@ChallanId,DC.ChallanId)
      --AND       COALESCE(BiltyNos,'X')                            = COALESCE(@BiltyNos,COALESCE(BiltyNos,'X'))
      --AND       COALESCE(ChallanNo,'X')                           = COALESCE(@ChallanNo,COALESCE(ChallanNo,'X'))
      --AND       COALESCE(ChallanDate,GETDATE())                   = COALESCE(@ChallanDate,COALESCE(ChallanDate,GETDATE()))
      --AND       COALESCE(VehicleId,0)                             = COALESCE(@VehicleId,COALESCE(VehicleId,0))
      --AND       COALESCE(DriverId,0)                              = COALESCE(@DriverId,COALESCE(DriverId,0))
      --AND       COALESCE(Mobile,'X')                              = COALESCE(@Mobile,COALESCE(Mobile,'X'))
      --AND       COALESCE(BrokerId,0)                              = COALESCE(@BrokerId,COALESCE(BrokerId,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(CreadtedBy,0)                            = COALESCE(@CreadtedBy,COALESCE(CreadtedBy,0))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_DriverChallan------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------





GO
/****** Object:  StoredProcedure [dbo].[usp_DriverChallan_1]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_DriverChallan                                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  Kamran Athar Janweri                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Wednesday, 15 May 2019 13:09:59:863                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_DriverChallan_1](@Action_Type                    numeric(10),
                                   @p_Success                      bit             = 1    OUTPUT,
                                   @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                   @ChallanId                      bigint          = NULL OUTPUT, 
                                   @BiltyNos                       nvarchar(1000)  = NULL,
                                   @ChallanNo                      nvarchar(10)    = NULL,
                                   @ChallanDate                    datetime        = NULL,
                                   @VehicleId                      bigint          = NULL,
                                   @DriverId                       bigint          = NULL,
                                   @Mobile                         nvarchar(50)    = NULL,
                                   @BrokerId                       bigint          = NULL,
                                   @CreatedDate                    datetime        = NULL,
                                   @CreadtedBy                     bigint          = NULL,
                                   @ModifiedBy                     bigint          = NULL,
                                   @ModifiedDate                   datetime        = NULL,
								   @DriverName						nvarchar(50)  =null,
								   @VehicleNo						nvarchar(50)  =null)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO DriverChallan(BiltyNos,  ChallanNo,  ChallanDate,  VehicleId,  DriverId,  Mobile,  BrokerId,  CreatedDate,  CreadtedBy,  ModifiedBy,  ModifiedDate,DriverName,VehicleNo)
      VALUES                      (@BiltyNos, [dbo].[ChallanGenerator](''), @ChallanDate, @VehicleId, @DriverId, @Mobile, @BrokerId, @CreatedDate, @CreadtedBy, @ModifiedBy, @ModifiedDate,@DriverName,@VehicleNo)

      SET       @ChallanId                     = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    DriverChallan
      SET       BiltyNos                       = COALESCE(@BiltyNos,BiltyNos),
                ChallanNo                      = COALESCE(@ChallanNo,ChallanNo),
                ChallanDate                    = COALESCE(@ChallanDate,ChallanDate),
                VehicleId                      = COALESCE(@VehicleId,VehicleId),
                DriverId                       = COALESCE(@DriverId,DriverId),
                Mobile                         = COALESCE(@Mobile,Mobile),
                BrokerId                       = COALESCE(@BrokerId,BrokerId),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                CreadtedBy                     = COALESCE(@CreadtedBy,CreadtedBy),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate)
                
      WHERE     ChallanId                      = @ChallanId
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    DriverChallan
      WHERE     ChallanId                      = @ChallanId
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, ISNULL(D.Name,DC.DriverName) 'DriverName',ISNULL(D.CellNo,'000') 'DriverNo',ISNULL(B.Name,'') 'BrokerName',ISNULL(V.VehicleCode,DC.VehicleNo) VehicleCode  , DC.*
      FROM      DriverChallan DC
	  LEFT JOIN Driver D on DC.DriverId=D.ID
	  LEFT JOIN Brokers B on DC.BrokerId=B.ID
	  LEFT JOIN Vehicle V on DC.VehicleId=V.VehicleID 
      WHERE     DC.ChallanId                                         = COALESCE(@ChallanId,DC.ChallanId)
      --AND       COALESCE(BiltyNos,'X')                            = COALESCE(@BiltyNos,COALESCE(BiltyNos,'X'))
      --AND       COALESCE(ChallanNo,'X')                           = COALESCE(@ChallanNo,COALESCE(ChallanNo,'X'))
      --AND       COALESCE(ChallanDate,GETDATE())                   = COALESCE(@ChallanDate,COALESCE(ChallanDate,GETDATE()))
      --AND       COALESCE(VehicleId,0)                             = COALESCE(@VehicleId,COALESCE(VehicleId,0))
      --AND       COALESCE(DriverId,0)                              = COALESCE(@DriverId,COALESCE(DriverId,0))
      --AND       COALESCE(Mobile,'X')                              = COALESCE(@Mobile,COALESCE(Mobile,'X'))
      --AND       COALESCE(BrokerId,0)                              = COALESCE(@BrokerId,COALESCE(BrokerId,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(CreadtedBy,0)                            = COALESCE(@CreadtedBy,COALESCE(CreadtedBy,0))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_DriverChallan------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------





GO
/****** Object:  StoredProcedure [dbo].[usp_ExpensesType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_ExpensesType                                                                                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Wednesday, 31 Oct 2018 09:38:08:093                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_ExpensesType](@Action_Type                    numeric(10),
                                  @p_Success                      bit             = 1    OUTPUT,
                                  @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                  @ExpensesTypeID                 bigint          = NULL OUTPUT, 
                                  @ExpensesTypeName               varchar(50)     = NULL,
                                  @ExpensesTypeCode               varchar(50)     = NULL,
                                  @DateCreated                    datetime        = NULL,
                                  @DateModified                   datetime        = NULL,
                                  @CreatedByUserID                bigint          = NULL,
                                  @ModifiedByUserID               bigint          = NULL,
                                  @Remarks                        varchar(500)    = NULL,
                                  @IsActive                       bit             = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO ExpensesType(ExpensesTypeName,  ExpensesTypeCode,  DateCreated,  DateModified,  CreatedByUserID,  ModifiedByUserID,  Remarks,  IsActive)
      VALUES                     (@ExpensesTypeName, @ExpensesTypeCode, @DateCreated, @DateModified, @CreatedByUserID, @ModifiedByUserID, @Remarks, @IsActive)

      SET       @ExpensesTypeID                = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    ExpensesType
      SET       ExpensesTypeName               = COALESCE(@ExpensesTypeName,ExpensesTypeName),
                ExpensesTypeCode               = COALESCE(@ExpensesTypeCode,ExpensesTypeCode),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified),
                CreatedByUserID                = COALESCE(@CreatedByUserID,CreatedByUserID),
                ModifiedByUserID               = COALESCE(@ModifiedByUserID,ModifiedByUserID),
                Remarks                        = COALESCE(@Remarks,Remarks),
                IsActive                       = COALESCE(@IsActive,IsActive)
                
      WHERE     ExpensesTypeID                 = @ExpensesTypeID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    ExpensesType
      WHERE     ExpensesTypeID                 = @ExpensesTypeID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, ExpensesTypeID, ExpensesTypeName, ExpensesTypeCode, DateCreated, DateModified, CreatedByUserID, ModifiedByUserID, Remarks, IsActive
      FROM      ExpensesType
      WHERE     ExpensesTypeID                                    = COALESCE(@ExpensesTypeID,ExpensesTypeID)
      AND       COALESCE(ExpensesTypeName,'X')                    = COALESCE(@ExpensesTypeName,COALESCE(ExpensesTypeName,'X'))
      AND       COALESCE(ExpensesTypeCode,'X')                    = COALESCE(@ExpensesTypeCode,COALESCE(ExpensesTypeCode,'X'))
      AND       COALESCE(DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(DateCreated,GETDATE()))
      AND       COALESCE(DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(DateModified,GETDATE()))
      AND       COALESCE(CreatedByUserID,0)                       = COALESCE(@CreatedByUserID,COALESCE(CreatedByUserID,0))
      AND       COALESCE(ModifiedByUserID,0)                      = COALESCE(@ModifiedByUserID,COALESCE(ModifiedByUserID,0))
      AND       COALESCE(Remarks,'X')                             = COALESCE(@Remarks,COALESCE(Remarks,'X'))
      AND       COALESCE(IsActive,0)                              = COALESCE(@IsActive,COALESCE(IsActive,0))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_ExpensesType-------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_FreightType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_FreightType                                                                                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Wednesday, 31 Oct 2018 09:19:30:040                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_FreightType](@Action_Type                    numeric(10),
                                 @p_Success                      bit             = 1    OUTPUT,
                                 @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                 @FreightTypeID                  bigint          = NULL OUTPUT, 
                                 @FreightTypeCode                varchar(50)     = NULL,
                                 @FreightTypeName                varchar(50)     = NULL,
                                 @Description                    varchar(500)    = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO FreightType(FreightTypeCode,  FreightTypeName,  Description)
      VALUES                    (@FreightTypeCode, @FreightTypeName, @Description)

      SET       @FreightTypeID                 = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    FreightType
      SET       FreightTypeCode                = COALESCE(@FreightTypeCode,FreightTypeCode),
                FreightTypeName                = COALESCE(@FreightTypeName,FreightTypeName),
                Description                    = COALESCE(@Description,Description)
                
      WHERE     FreightTypeID                  = @FreightTypeID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    FreightType
      WHERE     FreightTypeID                  = @FreightTypeID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, FreightTypeID, FreightTypeCode, FreightTypeName, Description
      FROM      FreightType
      WHERE     FreightTypeID                                     = COALESCE(@FreightTypeID,FreightTypeID)
      AND       COALESCE(FreightTypeCode,'X')                     = COALESCE(@FreightTypeCode,COALESCE(FreightTypeCode,'X'))
      AND       COALESCE(FreightTypeName,'X')                     = COALESCE(@FreightTypeName,COALESCE(FreightTypeName,'X'))
      AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_FreightType--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_Get_Error_Info]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Get_Error_Info](@p_Error_Message                varchar(MAX)    = NULL OUTPUT)
AS
BEGIN
  --SELECT         ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE() as ErrorState, ERROR_PROCEDURE() as ErrorProcedure, ERROR_LINE() as ErrorLine, ERROR_MESSAGE() as ErrorMessage;

  SELECT         @p_Error_Message = 'Error Number: '     + CAST(ERROR_NUMBER()   AS VARCHAR(50))+'. '+
                                    'Error Severity: '   + CAST(ERROR_SEVERITY() AS VARCHAR(50))+'. '+
                                    'Error State: '      + CAST(ERROR_STATE()    AS VARCHAR(50))+'. '+
                                    'In SP: '            + ERROR_PROCEDURE()                    +'. '+
                                    'At Line: '          + CAST(ERROR_LINE()     AS VARCHAR(50))+'. '+
                                    'Message: '          + ERROR_MESSAGE();
    
  INSERT INTO   dbo.SQLError([ErrorDateTime],[SQLString],[SQLError],[ErrorOrigin])
  VALUES       (GETDATE(),'SP Name '+ERROR_PROCEDURE()+' Line No. '+CAST(ERROR_LINE() AS VARCHAR(50)),@p_Error_Message,'DB');
END



GO
/****** Object:  StoredProcedure [dbo].[usp_getAllCompanyByGroupId]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_getAllCompanyByGroupId] 
	-- Add the parameters for the stored procedure here
	@GROUPID int ,
	@Action_Type int output,
	@p_Success bit	output,
	@p_Error_Message nvarchar output
AS
BEGIN
	
	SELECT c.CompanyName,C.CompanyID,C.CompanyCode,c.CompanyID AS 'COMPANYID',G.GroupID,G.GroupCode,G.GroupName FROM OWNGROUPS G
	--CROSS APPLY dbo.splitstring(G.CompanyAccess, ',') AS htvf
	INNER JOIN OWNCompany C on G.GroupID=C.GroupID 
	where  G.GroupID = @GROUPID and C.Active=1
	ORDER BY C.COMPANYNAME 

	
END



GO
/****** Object:  StoredProcedure [dbo].[usp_getBiltiesByChallanID]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_getBiltiesByChallanID] (
@ChallanId bigint = null)
AS
BEGIN 

SELECT CITYPICK.CityName PICKLOACTION,CITYDROP.CityName DROPLOCATION,CITYDROP.CityName 'DropCity',ISNULL(ST.Name,OrderLocations.DropLocationAddress) 'Station' ,TABLEA.* FROM (SELECT OD.OrderDetailId, O.CustomerCompany CustomerPerson,od.BiltyNoDate 'BiltyDate',
od.BiltyNo,ST.ShipmentType,OD.da_no AS DA,PT.name 'ItemName',
OP.Quantity,OP.UnitWeight 'Weight',E.ExpensesTypeName
,CAST (ISNULL(OD.LocalFreight,0) as bigint) AS LocalFreight
,OD.Freight
 AS Freight
 FROM [dbo].[Order] O
INNER JOIN OrderDetail OD on O.OrderID=OD.OrderID 
inner join ShipmentType ST on od.ShipmentTypeId=ST.ShipmentType_ID
left join OrderExpenses OE on OD.OrderDetailId=OE.OrderDetailId 
left join ExpensesType E on OE.ExpenseTypeId=E.ExpensesTypeID --and UPPER(E.ExpensesTypeName)='LOCAL FREIGHT'
inner join OrderPackageTypes OP on OD.OrderDetailId=OP.OrderDetailId
inner join Product PT on OP.ItemID=PT.ID
left join   OrderDocument ODoc on OD.OrderDetailId=ODoc.OrderDetailId
inner join DriverChallan DC on OD.ChallanNo=DC.ChallanNo
WHERE DC.ChallanId=@ChallanId
) AS TABLEA
INNER JOIN OrderLocations  On  TABLEA.OrderDetailId=OrderLocations.OrderDetailId
inner join City AS CITYPICK on OrderLocations.PickupLocationId=CITYPICK.CityID 
inner join City AS CITYDROP on OrderLocations.DropLocationId=CITYDROP.CityID
left join Stations AS ST on OrderLocations.StationTo=ST.ID




END





GO
/****** Object:  StoredProcedure [dbo].[usp_GetBiltyPDFExpenses]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC  [dbo].[usp_GetBiltyPDFExpenses](
@Action_Type                    numeric(10),
                                   @p_Success                      bit             = 1    OUTPUT,
                                   @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
								   @OrderDetailID nvarchar(4000)=null)
AS
BEGIN
DECLARE @query nvarchar(max)
print REPLACE(@OrderDetailID,'''','')
SET @query='SELECT OrderExpenseId, OrderDetailId, OrderExpenses.ExpenseTypeId,ExpensesType.ExpensesTypeName, Amount, CreatedBy, CreatedDate, ModifiedDate, ModifiedBy
      FROM      OrderExpenses
	  INNER JOIN ExpensesType on OrderExpenses.ExpenseTypeId=ExpensesType.ExpensesTypeID
	  WHERE  OrderDetailId    in ('+@OrderDetailID+')'

	   --print @query
 exec (@query)
END



GO
/****** Object:  StoredProcedure [dbo].[usp_GetChallanList]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE  PROCEDURE [dbo].[usp_GetChallanList](
 @Action_Type                    numeric(10),
 @p_Success                      bit             = 1    OUTPUT,
                           @p_Error_Message     varchar(MAX)    = NULL OUTPUT,
						   @BiltyNo nvarchar(50) = NULL,
						   @DateFrom  datetime =NULL ,
						   @DateTo  datetime = NULL ,
						   @CustomerCode nvarchar(50) = NULL,
						   @CustomerName nvarchar(150) = NULL,
						   @GeneralSearch nvarchar(150) =NULL
 )
AS 
BEGIN

   select DC.ChallanId, ISNULL(CITY.CityName,OL.DropLocationAddress) 'DropStation', C.CompanyName 'CustomerName',C.CompanyCODE 'CustomerCode', od.BiltyNo,od.BiltyNoDate,DC.ChallanNo ,ISNULL(V.RegNo,DC.VehicleNo) VehicleCode,ISNULL(D.Name,DC.DriverName) AS 'DriverName',D.CODE as 'DriverCode',DC.Mobile AS 'MobileNo',
  CASE WHEN OD.ParentId=0 THEN 'FULL BILTY' ELSE'HALF BILTY'END AS BiltyType,DC.ChallanDate,DC.CreatedDate,DC.ModifiedDate
  
   from OrderDetail OD
  INNER JOIN  Company C ON OD.CustomerCode=C.CompanyCode 
  INNER JOIN DriverChallan DC ON OD.ChallanNo=DC.ChallanNo
  LEFT JOIN Vehicle V ON DC.VehicleId=V.VehicleID
  LEFT JOIN DRIVER D ON DC.DRIVERID=D.ID
  INNER JOIN OrderLocations OL on OD.OrderDetailId=OL.OrderDetailId
  LEFT JOIN Stations DropStation  on OL.StationTo=DropStation.ID
  
  INNER JOIN CITY on OL.DropLocationId=City.CityID
  where 
  C.CompanyCode = COALESCE(@CustomerCode,C.CompanyCode)
  AND DC.ChallanDate BETWEEN @DateFrom and @DateTo
  AND OD.BiltyNo = COALESCE(@BiltyNo,OD.BiltyNo)
  AND C.CompanyName = COALESCE(@CustomerName,C.CompanyName)
  AND 
  (
  DC.VehicleNo = COALESCE(@GeneralSearch, DC.VehicleNo)
  OR
  DC.ChallanNo = COALESCE(@GeneralSearch, DC.ChallanNo)
  )
  order by dc.ChallanId desc
END





GO
/****** Object:  StoredProcedure [dbo].[usp_GetChallanReport]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_GetChallanReport](
@BiltyNo nvarchar(4000) =null
)
AS 

BEGIN
DECLARE @query nvarchar(max)
SET @query ='SELECT DISTINCT ISNULL(S.Name,OL.DropLocationAddress) ''Transportor'',ISNULL(S.ContactNo,'''') AS ContactNumber,ISNULL(S.SecondaryContactNo,'''') AS SecondaryContactNumber ,  PROD.Name ''ProductName'',  od.BiltyNo,OD.DA_No,OL.ReceiverName ReceiverCompany,O.CustomerCompany, PICKUP.CityName ''Pickup'',DROPED.CityName ''Drop'',OPT.Quantity,OPT.UnitWeight,OD.LocalFreight,CPD.DoorStepRate,OD.Freight,CP.PaymentTerm,OD.NetWeight
from [dbo].[Order] O
left JOIN  [dbo].[OrderDetail] OD ON O.OrderID=OD.OrderID
left JOIN [DBO].[OrderPackageTypes] OPT ON OD.OrderDetailId=OPT.OrderDetailId
left JOIN [DBO].[Product] PROD ON OPT.ItemId=PROD.ID
left JOIN [DBO].[CustomerProfile] CP ON O.CustomerCompanyId=CP.CustomerId
left JOIN [DBO].[CustomerProfileDetail] CPD ON CP.ProfileId=CPD.ProfileId and  OPT.ProfileDetailId=CPD.ProfileDetail


INNER JOIN [DBO].[ORDERLOCATIONS] OL ON OD.OrderDetailId=OL.OrderDetailId AND OL.PickupLocationId=CPD.LocationFrom AND OL.DropLocationId=CPD.LocationTo
INNER JOIN [DBO].[City] PICKUP ON CPD.LocationFrom=PICKUP.CityID
INNER JOIN [DBO].[CITY] DROPED ON CPD.LocationTo=DROPED.CityID
LEFT join [DBO].[Stations] S ON OL.StationTo=S.ID

WHERE 
od.BiltyNo in ('+@BiltyNo+')';

exec (@query)
END



GO
/****** Object:  StoredProcedure [dbo].[usp_GetChallanReport1]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_GetChallanReport1](
@BiltyNo nvarchar(250) =null
)
AS 

BEGIN
DECLARE @query nvarchar(max)
SET @query ='SELECT DISTINCT ISNULL(S.Name,OL.DropLocationAddress) ''Transportor'' ,  PROD.Name ''ProductName'',  od.BiltyNo,OD.DA_No,OL.ReceiverName ReceiverCompany,O.CustomerCompany, PICKUP.CityName ''Pickup'',DROPED.CityName ''Drop'',OPT.Quantity,OPT.UnitWeight,OD.LocalFreight,CPD.DoorStepRate,OD.Freight,CP.PaymentTerm,OD.NetWeight
from [dbo].[Order] O
left JOIN  [dbo].[OrderDetail] OD ON O.OrderID=OD.OrderID
left JOIN [DBO].[OrderPackageTypes] OPT ON OD.OrderDetailId=OPT.OrderDetailId
left JOIN [DBO].[Product] PROD ON OPT.ItemId=PROD.ID
left JOIN [DBO].[CustomerProfile] CP ON O.CustomerCompanyId=CP.CustomerId
left JOIN [DBO].[CustomerProfileDetail] CPD ON CP.ProfileId=CPD.ProfileId


INNER JOIN [DBO].[ORDERLOCATIONS] OL ON OD.OrderDetailId=OL.OrderDetailId AND OL.PickupLocationId=CPD.LocationFrom AND OL.DropLocationId=CPD.LocationTo
INNER JOIN [DBO].[City] PICKUP ON CPD.LocationFrom=PICKUP.CityID
INNER JOIN [DBO].[CITY] DROPED ON CPD.LocationTo=DROPED.CityID
LEFT join [DBO].[Stations] S ON OL.StationTo=S.ID

WHERE 
od.BiltyNo in ('+@BiltyNo+')';

exec (@query)
END


GO
/****** Object:  StoredProcedure [dbo].[usp_GetCityByCustomerCode]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[usp_GetCityByCustomerCode](@CustomerCode nvarchar(50))
AS 
BEGIN

SELECT distinct  CITY.* FROM CITY

INNER JOIN CustomerProfileDetail on City.CityID=CustomerProfileDetail.LocationTo
INNER JOIN CustomerProfile CP on CustomerProfileDetail.ProfileId=CP.ProfileId

WHERE
CP.CustomerCode=@CustomerCode
END


GO
/****** Object:  StoredProcedure [dbo].[usp_GetCompanyName]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_GetCompanyName](
@Action_Type                    numeric(10),
 @p_Success                      bit             = 1    OUTPUT,
                           @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                           @OrderId                         int             = NULL OUTPUT
)
AS
BEGIN

 SELECT  OC.CompanyName,ISNULL(OC.Description,'') AS Description,OC.Address1,OC.Address2 FROM [BiltySystem2021].[dbo].[Order] O
 INNER JOIN [BiltySystem2021].[dbo].[CustomerProfile] CP on O.CustomerCompanyId=CP.CustomerId
 INNER JOIN [BiltySystem2021].[dbo].[OwnCompany] OC on CP.OwnCompanyId=oc.CompanyID
 WHERE O.OrderID=@OrderId
 END
 



GO
/****** Object:  StoredProcedure [dbo].[usp_GetCustomerInfo]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetCustomerInfo](
@GROUPID BIGINT ,
@COMPANYID BIGINT ,
@DEPARTMENTID BIGINT,
@search nvarchar(50)=null 	)
AS 
BEGIN

SELECT G.GroupID,G.GroupCode,G.GroupName,C.CompanyID,C.CompanyCode,C.CompanyName ,D.DepartID,D.DepartCode,D.DepartName,
isnull(DP.PersonalID,0) PersonalID ,
DP.Name,DP.Code,DP.Cell
FROM GROUPS G
left JOIN COMPANY C ON G.GroupID=C.GroupID
left JOIN DEPARTMENT D ON C.CompanyID=D.COMPANYID
LEFT JOIN DEPARTMENTPERSON DP ON D.DepartID=DP.DepartmentID
WHERE G.IsActive=1 
--and DP.GroupID=@GROUPID and DP.CompanyID =@COMPANYID and DP.DepartmentID=@DEPARTMENTID 
and (

UPPER(G.GroupCode) like '%'+@search+'%'
OR UPPER(G.GroupName) like '%'+@search+'%'
OR UPPER(C.CompanyCode) like '%'+@search+'%'
OR UPPER(C.CompanyName) like '%'+@search+'%'
OR UPPER(D.DepartCode) like '%'+@search+'%'
OR UPPER(D.DepartName) like '%'+@search+'%'
or UPPER(DP.Name) like '%'+@search+'%'
or UPPER(DP.Code) like  '%'+@search+'%'
or UPPER(DP.Cell) like  '%'+@search+'%'
)
END





GO
/****** Object:  StoredProcedure [dbo].[usp_GetOrderForInvoice]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_GetOrderForInvoice] (
@DateFrom datetime,
@DateTo datetime,
@BiltyNo nvarchar(11) = null,
@CityFrom bigint =null,
@CityTo bigint =null,
@CustomerId bigint,
@BiltyFrom bigint =null,
@BiltyTo bigint =null)
AS
BEGIN 

DECLARE @QUERY NVARCHAR(MAX)
DECLARE @WHERECLAUSE NVARCHAR(2000)=''
IF @BiltyFrom is not null OR @BiltyTo is not null OR @DateFrom is not null OR @DateTo is not null OR @CustomerId is not null
SET @WHERECLAUSE = ' WHERE OD.ParentId in (0,1) and  OD.InvoiceNo is null  '
IF @BiltyFrom is not null
	SET @WHERECLAUSE = @WHERECLAUSE + ' AND  CAST(REPLACE(SUBSTRING(OD.BiltyNo, CHARINDEX(''-'', OD.BiltyNo) + 1, LEN(OD.BiltyNo)), '' '','''') as bigint) >= ' + CAST(@BiltyFrom as varchar)+'';
IF @BiltyTo is not null
	SET @WHERECLAUSE = @WHERECLAUSE + ' AND  CAST(REPLACE(SUBSTRING(OD.BiltyNo, CHARINDEX(''-'', OD.BiltyNo) + 1, LEN(OD.BiltyNo)),'' '','''') as bigint) <= ' + CAST( @BiltyTo as varchar)+'';
IF  @DateFrom is not null AND @DateTo is not null
	SET @WHERECLAUSE = @WHERECLAUSE + ' AND  OD.BiltyNoDate between '''+ CONVERT(varchar, @DateFrom, 23) + ''' and '''+ CONVERT(varchar, @DateTo, 23) +''''
SET @QUERY= 'SELECT DISTINCT CITYPICK.CityName PICKLOACTION,CITYDROP.CityName DROPLOCATION,CITYDROP.CityName ''DropCity'',ISNULL(ST.Name,OrderLocations.DropLocationAddress) ''Station'' ,TABLEA.* FROM (SELECT OD.OrderDetailId, O.CustomerCompany CustomerPerson,od.BiltyNoDate ''BiltyDate'',
od.BiltyNo,ST.ShipmentType,OD.da_no AS DA,ISNULL(PT.name,'' '') ''ItemName'',
ISNULL(OP.Quantity,0) Quantity,ISNULL(OP.UnitWeight,0) ''Weight'',CAST (ISNULL(OD.LocalFreight,0) as bigint) AS LocalFreight
,OD.Freight
 AS Freight
 FROM [dbo].[Order] O
INNER JOIN OrderDetail OD on O.OrderID=OD.OrderID 
inner join ShipmentType ST on od.ShipmentTypeId=ST.ShipmentType_ID
left join OrderExpenses OE on OD.OrderDetailId=OE.OrderDetailId
LEFT join OrderPackageTypes OP on OD.OrderDetailId=OP.OrderDetailId
LEFT join Product PT on OP.ItemID=PT.ID
left join   OrderDocument ODoc on OD.OrderDetailId=ODoc.OrderDetailId
'+@WHERECLAUSE+'

 

 AND O.CustomerCompanyId = '''+CAST(@CustomerId as varchar)+'''

 
) AS TABLEA
INNER JOIN OrderLocations  On  TABLEA.OrderDetailId=OrderLocations.OrderDetailId
inner join City AS CITYPICK on OrderLocations.PickupLocationId=CITYPICK.CityID 
inner join City AS CITYDROP on OrderLocations.DropLocationId=CITYDROP.CityID
left join Stations AS ST on OrderLocations.StationTo=ST.ID
ORDER by  BiltyNo' 


EXECUTE( @QUERY)








--SELECT CITYPICK.CityName PICKLOACTION,CITYDROP.CityName DROPLOCATION,CITYDROP.CityName 'DropCity',ISNULL(ST.Name,OrderLocations.DropLocationAddress) 'Station' ,TABLEA.* FROM (SELECT OD.OrderDetailId, O.CustomerCompany CustomerPerson,od.BiltyNoDate 'BiltyDate',
--od.BiltyNo,ST.ShipmentType,OD.da_no AS DA,ISNULL(PT.name,' ') 'ItemName',
--ISNULL(OP.Quantity,0) Quantity,ISNULL(OP.UnitWeight,0) 'Weight',CAST (ISNULL(OD.LocalFreight,0) as bigint) AS LocalFreight
--,OD.Freight
-- AS Freight
-- FROM [dbo].[Order] O
--INNER JOIN OrderDetail OD on O.OrderID=OD.OrderID 
--inner join ShipmentType ST on od.ShipmentTypeId=ST.ShipmentType_ID
--left join OrderExpenses OE on OD.OrderDetailId=OE.OrderDetailId
--LEFT join OrderPackageTypes OP on OD.OrderDetailId=OP.OrderDetailId
--LEFT join Product PT on OP.ItemID=PT.ID
--left join   OrderDocument ODoc on OD.OrderDetailId=ODoc.OrderDetailId
--WHERE
--OD.InvoiceNo is null and
-- O.CustomerCompanyId =@CustomerId
-- and 
-- OD.BiltyNoDate between @DateFrom and @DateTo
--) AS TABLEA
--INNER JOIN OrderLocations  On  TABLEA.OrderDetailId=OrderLocations.OrderDetailId
--inner join City AS CITYPICK on OrderLocations.PickupLocationId=CITYPICK.CityID 
--inner join City AS CITYDROP on OrderLocations.DropLocationId=CITYDROP.CityID
--left join Stations AS ST on OrderLocations.StationTo=ST.ID
--ORDER by  BiltyNo 
----WHERE
-- --OrderLocations.PickupLocationId=COALESCE(@CityTo,OrderLocations.PickupLocationId) 
-- --OR 
-- --OrderLocations.DropLocationId=COALESCE(@CityTo,OrderLocations.DropLocationId)


END







GO
/****** Object:  StoredProcedure [dbo].[usp_GetOrderPackageByOrderId]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_GetOrderPackageByOrderId](
@Action_Type                    numeric(10),
@p_Success                      bit             = 1    OUTPUT,
@p_Error_Message                varchar(MAX)    = NULL OUTPUT,
@OrderId                 bigint          = NULL ,
@OrderDetailId                 bigint          = NULL 
)
AS
BEGIN
SELECT
  Master.ActionType,
  Master.ItemName,
  Master.PackageTypeId,
  Master.PackageTypeName,
  Master.ItemId,
  SUM(Master.Quantity - ISNULL(Child.Qunatity,0)) Quantity,
  Master.UnitWeight,
  Master.UnitFreight,
 -- 0 ModifiedBy,
  ISNULL(Master.RateType, '') RateType,
  ISNULL(Master.WeightPerUnit, '0') WeightPerUnit,
  ISNULL(Master.ProfileDetailId, '0') ProfileDetailId,
  ROUND(SUM(Master.AdditionalCharges - ISNULL(Child.AdditionalCharges,0)),0) AdditionalCharges,
  ROUND(SUM(Master.LabourCharges - ISNULL(Child.LabourCharges,0)),0) LabourCharges
  --ROUND(SUM(Master.AdditionalCharges - Child.AdditionalCharges),0) AdditionalCharges,
  --ROUND(SUM(Master.LabourCharges - Child.LabourCharges),0) LabourCharges
  
FROM (SELECT
  'MASTER' AS ActionType,
  Product.Name 'ItemName',
  OrderPackageTypes.PackageTypeId,
  PackageType.PackageTypeName,
  OrderPackageTypes.ItemId,
  SUM(Quantity) Quantity,
  OrderPackageTypes.UnitWeight,
  OrderPackageTypes.UnitFreight,
 -- OrderPackageTypes.ModifiedBy,
  ISNULL(CPD.RateType, '') RateType,
  --ISNULL(CPD.WeightPerUnit, '0') WeightPerUnit,
  ISNULL(OrderPackageTypes.UnitWeight, '0') WeightPerUnit,
  ISNULL(OrderPackageTypes.ProfileDetailId, '0') ProfileDetailId,
   OrderPackageTypes.AdditionalCharges,
  OrderPackageTypes.LabourCharges
FROM OrderPackageTypes
INNER JOIN OrderDetail
  ON OrderPackageTypes.OrderDetailId = OrderDetail.OrderDetailId
INNER JOIN [dbo].[Order]
  ON OrderDetail.OrderID = [dbo].[Order].OrderID
INNER JOIN PackageType
  ON OrderPackageTypes.PackageTypeId = PackageType.PackageTypeID
INNER JOIN Product
  ON OrderPackageTypes.ItemId = Product.ID
INNER JOIN CustomerProfileDetail CPD
  ON OrderPackageTypes.ItemId = CPD.ProductId
  AND OrderPackageTypes.ProfileDetailId = cpd.ProfileDetail
INNER JOIN OrderLocations Pick
  ON OrderPackageTypes.OrderDetailId = Pick.OrderDetailId
  AND Pick.PickupLocationId = cpd.LocationFrom
  AND Pick.DropLocationId = CPD.LocationTo
WHERE
[dbo].[Order].OrderID=@OrderId and
OrderDetail.OrderDetailId =@OrderDetailId and
ParentId in (0,1)
GROUP BY Product.Name,
         OrderPackageTypes.PackageTypeId,
         PackageType.PackageTypeName,
         OrderPackageTypes.ItemId,
         OrderPackageTypes.UnitWeight,
         OrderPackageTypes.UnitFreight,
   --      OrderPackageTypes.ModifiedBy,
         CPD.RateType,
         CPD.WeightPerUnit,
         OrderPackageTypes.ProfileDetailId,
		 OrderPackageTypes.AdditionalCharges,
		 OrderPackageTypes.LabourCharges) AS Master

LEFT JOIN (SELECT
  'CHILD' AS ActionType,
  Product.Name 'ItemName',
  OrderPackageTypes.PackageTypeId,
  PackageType.PackageTypeName,
  OrderPackageTypes.ItemId,
  SUM(Quantity) Qunatity,
  OrderPackageTypes.UnitWeight,
  OrderPackageTypes.UnitFreight,
  --OrderPackageTypes.ModifiedBy,
  ISNULL(CPD.RateType, '') RateType,
  ISNULL(CPD.WeightPerUnit, '0') WeightPerUnit,
  ISNULL(OrderPackageTypes.ProfileDetailId, '0') ProfileDetailId,
  ROUND(SUM(OrderPackageTypes.AdditionalCharges),0) AdditionalCharges,
  ROUND(SUM(OrderPackageTypes.LabourCharges),0) LabourCharges
FROM OrderPackageTypes
INNER JOIN OrderDetail
  ON OrderPackageTypes.OrderDetailId = OrderDetail.OrderDetailId
INNER JOIN [dbo].[Order]
  ON OrderDetail.OrderID = [dbo].[Order].OrderID
INNER JOIN PackageType
  ON OrderPackageTypes.PackageTypeId = PackageType.PackageTypeID
INNER JOIN Product
  ON OrderPackageTypes.ItemId = Product.ID
INNER JOIN CustomerProfileDetail CPD
  ON OrderPackageTypes.ItemId = CPD.ProductId
  AND OrderPackageTypes.ProfileDetailId = cpd.ProfileDetail
INNER JOIN OrderLocations Pick
  ON OrderPackageTypes.OrderDetailId = Pick.OrderDetailId
  AND Pick.PickupLocationId = cpd.LocationFrom
  AND Pick.DropLocationId = CPD.LocationTo
WHERE
[dbo].[Order].OrderID=@OrderId and
--OrderDetail.OrderDetailId =@OrderDetailId and
--ParentId not in (1,0)
ParentId =@OrderDetailId
GROUP BY Product.Name,
         OrderPackageTypes.PackageTypeId,
         PackageType.PackageTypeName,
         OrderPackageTypes.ItemId,
         OrderPackageTypes.UnitWeight,
         OrderPackageTypes.UnitFreight,
    --     OrderPackageTypes.ModifiedBy,
         CPD.RateType,
         CPD.WeightPerUnit,
         OrderPackageTypes.ProfileDetailId
		 ) AS Child
  ON Master.ItemId = Child.ItemId


GROUP BY Master.ActionType,
         Master.ItemName,
         Master.PackageTypeId,
         Master.PackageTypeName,
         Master.ItemId,
         Master.UnitWeight,
         Master.UnitFreight,
         --ModifiedBy,
         Master.RateType,
         Master.WeightPerUnit,
         Master.ProfileDetailId
END




GO
/****** Object:  StoredProcedure [dbo].[usp_GetVehicleWeightReport]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_GetVehicleWeightReport](
@BiltyNo nvarchar(MAX) = null)
AS
Declare @Query nvarchar(MAX) ='';
BEGIN 

print @BiltyNo
SET @Query ='SELECT OD.BiltyNoDate,OD.BiltyNo,SUM(OPT.Quantity) QTY,OD.NetWeight,OD.Freight ''Amount''
,OrderLocations.ReceiverName,C.CityName as ''Station'' FROM OrderDetail OD
INNER JOIN [Order]  ON  OD.OrderId = [Order].orderid
INNER JOIN OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
inner join ShipmentType ST on od.ShipmentTypeId=ST.ShipmentType_ID
LEFT JOIN [OrderLocations] OL on OD.OrderDetailId=OL.OrderDetailId
LEFT JOIN [City] C on OL.DropLocationId=C.CityID
INNER JOIN OrderLocations  On  OD.OrderDetailId=OrderLocations.OrderDetailId
WHERE OD.BiltyNo in ('+@BiltyNo+')
GROUP by OD.BiltyNoDate,OD.BiltyNo,[ORder].CustomerCompany,C.CityName,OD.NetWeight,OD.Freight,OrderLocations.ReceiverName'
EXEC(@Query)
--SELECT OD.BiltyNoDate,OD.BiltyNo,SUM(OPT.Quantity) QTY,OD.NetWeight,OD.Freight 'Amount'
--,OrderLocations.ReceiverName,'' as 'Station' FROM OrderDetail OD
--INNER JOIN [Order]  ON  OD.OrderId = [Order].orderid
--INNER JOIN OrderPackageTypes OPT on OD.OrderDetailId=OPT.OrderDetailId
--inner join ShipmentType ST on od.ShipmentTypeId=ST.ShipmentType_ID
--INNER JOIN OrderLocations  On  OD.OrderDetailId=OrderLocations.OrderDetailId
--WHERE OD.BiltyNo in (@BiltyNo)
--GROUP by OD.BiltyNoDate,OD.BiltyNo,[ORder].CustomerCompany,OD.NetWeight,OD.Freight,OrderLocations.ReceiverName
END


GO
/****** Object:  StoredProcedure [dbo].[usp_Groups]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Groups                                                                                                                       ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Saturday, 16 Feb 2019 23:40:00:623                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Groups](@Action_Type                    numeric(10),
                            @p_Success                      bit             = 1    OUTPUT,
                            @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                            @GroupID                        bigint          = NULL OUTPUT, 
                            @GroupCode                      varchar(50)     = NULL,
                            @GroupName                      varchar(50)     = NULL,
                            @Contact                        varchar(50)     = NULL,
                            @ContactOther                   varchar(50)     = NULL,
                            @EmailAdd                       varchar(50)     = NULL,
                            @WebAdd                         varchar(50)     = NULL,
                            @Address                        varchar(50)     = NULL,
                          --  @Logo                           image(2147483647) = NULL,
                            @DateCreated                    datetime        = NULL,
                            @DateModified                   datetime        = NULL,
                            @CreatedByUserID                bigint          = NULL,
                            @ModifiedByUserID               bigint          = NULL,
                            @Description                    varchar(50)     = NULL,
                            @IsActive                       bit             = NULL,
                            @CompanyAccess                  varchar(50)     = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Groups(GroupCode,  GroupName,  Contact,  ContactOther,  EmailAdd,  WebAdd,  Address,    DateCreated,  DateModified,  CreatedByUserID,  ModifiedByUserID,  Description,  IsActive,  CompanyAccess)
      VALUES               (@GroupCode, @GroupName, @Contact, @ContactOther, @EmailAdd, @WebAdd, @Address,  @DateCreated, @DateModified, @CreatedByUserID, @ModifiedByUserID, @Description, @IsActive, @CompanyAccess)

      SET       @GroupID                       = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Groups
      SET       GroupCode                      = COALESCE(@GroupCode,GroupCode),
                GroupName                      = COALESCE(@GroupName,GroupName),
                Contact                        = COALESCE(@Contact,Contact),
                ContactOther                   = COALESCE(@ContactOther,ContactOther),
                EmailAdd                       = COALESCE(@EmailAdd,EmailAdd),
                WebAdd                         = COALESCE(@WebAdd,WebAdd),
                Address                        = COALESCE(@Address,Address),
              --  Logo                           = COALESCE(@Logo,Logo),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified),
                CreatedByUserID                = COALESCE(@CreatedByUserID,CreatedByUserID),
                ModifiedByUserID               = COALESCE(@ModifiedByUserID,ModifiedByUserID),
                Description                    = COALESCE(@Description,Description),
                IsActive                       = COALESCE(@IsActive,IsActive),
                CompanyAccess                  = COALESCE(@CompanyAccess,CompanyAccess)
                
      WHERE     GroupID                        = @GroupID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Groups
      WHERE     GroupID                        = @GroupID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, GroupID, GroupCode, GroupName, Contact, ContactOther, EmailAdd, WebAdd, Address, Logo, DateCreated, DateModified, CreatedByUserID, ModifiedByUserID, Description, IsActive, CompanyAccess
      FROM      Groups
      WHERE     GroupID                                           = COALESCE(@GroupID,GroupID)
      AND       COALESCE(GroupCode,'X')                           = COALESCE(@GroupCode,COALESCE(GroupCode,'X'))
      AND       COALESCE(GroupName,'X')                           = COALESCE(@GroupName,COALESCE(GroupName,'X'))
      AND       COALESCE(Contact,'X')                             = COALESCE(@Contact,COALESCE(Contact,'X'))
      AND       COALESCE(ContactOther,'X')                        = COALESCE(@ContactOther,COALESCE(ContactOther,'X'))
      AND       COALESCE(EmailAdd,'X')                            = COALESCE(@EmailAdd,COALESCE(EmailAdd,'X'))
      AND       COALESCE(WebAdd,'X')                              = COALESCE(@WebAdd,COALESCE(WebAdd,'X'))
      AND       COALESCE(Address,'X')                             = COALESCE(@Address,COALESCE(Address,'X'))
    --  AND       Logo                                              = COALESCE(@Logo,Logo)
      AND       COALESCE(DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(DateCreated,GETDATE()))
      AND       COALESCE(DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(DateModified,GETDATE()))
      AND       COALESCE(CreatedByUserID,0)                       = COALESCE(@CreatedByUserID,COALESCE(CreatedByUserID,0))
      AND       COALESCE(ModifiedByUserID,0)                      = COALESCE(@ModifiedByUserID,COALESCE(ModifiedByUserID,0))
      AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
      AND       COALESCE(IsActive,0)                              = COALESCE(@IsActive,COALESCE(IsActive,0))
      AND       COALESCE(CompanyAccess,'X')                       = COALESCE(@CompanyAccess,COALESCE(CompanyAccess,'X'))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Groups-------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------



GO
/****** Object:  StoredProcedure [dbo].[usp_InquiryAndOrders]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_InquiryAndOrders                                                                                                             ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Thursday, 27 Dec 2018 10:59:30:470                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_InquiryAndOrders](@Action_Type                    numeric(10),
                                      @p_Success                      bit             = 1    OUTPUT,
                                      @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                      @Order_ID                       bigint          = NULL OUTPUT, 
                                      @OrderDate                      datetime        = NULL,
                                      @CustomerID                     bigint          = NULL,
                                      @IsForward                      bit             = NULL,
                                      @Department                     int             = NULL,
                                      @IsResponseBackToCustomer       bit             = NULL,
                                      @IsInquiryToOrder               bit             = NULL,
                                      @IsComplete                     bit             = NULL,
                                      @CreatedBy                      bigint          = NULL,
                                      @ModifiedBy                     bigint          = NULL,
                                      @CreatedDate                    datetime        = NULL,
                                      @ModifiedDate                   datetime        = NULL,
                                      @CompanyId                      int             = NULL,
                                      @GroupID                        int             = NULL,
                                      @DepartmentID                   int             = NULL,
                                      @ExistingCustomer               bit             = NULL,
                                      @CustomerGroupId                nchar(10)       = NULL,
                                      @CustomerGroupCode              nvarchar(50)    = NULL,
                                      @CustomerGroup                  nvarchar(150)   = NULL,
                                      @CustomerCompanyId              bigint          = NULL,
                                      @CustomerCompany                nvarchar(150)   = NULL,
                                      @CustomerCompanyCode            nvarchar(50)    = NULL,
                                      @CustomerDepartmentId           bigint          = NULL,
                                      @CustomerDepartment             nvarchar(150)   = NULL,
                                      @CustomerDepartmentCode         nvarchar(50)    = NULL,
                                      @CustomerPersonId               bigint          = NULL,
                                      @CustomerPerson                 nvarchar(150)   = NULL,
                                      @CustomerPersonCode             nvarchar(50)    = NULL,
                                      @CustomerContact                nvarchar(50)    = NULL,
                                      @ExistingRefference             bigint          = NULL,
                                      @RefferenceGroupId              bigint          = NULL,
                                      @RefferenceGroupCode            nvarchar(50)    = NULL,
                                      @RefferenceGroup                nvarchar(50)    = NULL,
                                      @RefferenceCompanyId            bigint          = NULL,
                                      @RefferenceCompany              nvarchar(50)    = NULL,
                                      @RefferenceCompanyCode          nvarchar(50)    = NULL,
                                      @RefferenceDepartmentId         bigint          = NULL,
                                      @RefferenceDepartment           nvarchar(50)    = NULL,
                                      @RefferenceDepartmentCode       nvarchar(50)    = NULL,
                                      @RefferencePersonId             bigint          = NULL,
                                      @RefferencePerson               nvarchar(50)    = NULL,
                                      @RefferencePersonCode           nvarchar(50)    = NULL,
                                      @RefferenceContact              nvarchar(50)    = NULL,
									  @ExistingReceiver               bigint          = NULL,
                                      @ReceiverGroupId                bigint          = NULL,
                                      @ReceiverGroupCode              nvarchar(50)    = NULL,
                                      @ReceiverGroup                  nvarchar(50)    = NULL,
                                      @ReceiverCompanyId              bigint          = NULL,
                                      @ReceiverCompany                nvarchar(50)    = NULL,
                                      @ReceiverCompanyCode            nvarchar(50)    = NULL,
                                      @ReceiverDepartmentId           bigint          = NULL,
                                      @ReceiverDepartment             nvarchar(50)    = NULL,
                                      @ReceiverDepartmentCode         nvarchar(50)    = NULL,
                                      @ReceiverPersonId               bigint          = NULL,
                                      @ReceiverPerson                 nvarchar(50)    = NULL,
                                      @ReceiverPersonCode             nvarchar(50)    = NULL,
                                      @ReceiverContact                nvarchar(50)    = NULL,
                                      @ExistingBillTo                 bigint          = NULL,
                                      @BillToGroupId                  bigint          = NULL,
                                      @BillToGroupCode                nvarchar(50)    = NULL,
                                      @BillToGroup                    nvarchar(50)    = NULL,
                                      @BillToCompanyId                bigint          = NULL,
                                      @BillToCompany                  nvarchar(50)    = NULL,
                                      @BillToCompanyCode              nvarchar(50)    = NULL,
                                      @BillToDepartmentId             bigint          = NULL,
                                      @BillToDepartment               nvarchar(50)    = NULL,
                                      @BillToDepartmentCode           nvarchar(50)    = NULL,
                                      @BillToPersonId                 bigint          = NULL,
                                      @BillToPerson                   nvarchar(50)    = NULL,
                                      @BillToPersonCode               nvarchar(50)    = NULL,
                                      @BillToContact                  nvarchar(50)    = NULL,
                                      @IsCommunicatewithCustomer      bit             = NULL,
                                      @Status                         nvarchar(50)    = NULL,
                                      @OrderCompleted                 bit             = NULL,
                                      @Active                         bit             = NULL,
                                      @AssessmentReponse              bit             = NULL,
                                      @OrderPlacment                  bit             =null,  
									  @ManualBiltyNo                  nvarchar(50)    = NULL,
                                      @ManualBiltyDate                datetime        = NULL,
									  @BiltyNo						nvarchar(15)=NULL	)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO InquiryAndOrders(OrderDate,  CustomerID,  IsForward,  Department,  IsResponseBackToCustomer,  IsInquiryToOrder,  IsComplete,  CreatedBy,  ModifiedBy,  CreatedDate,  ModifiedDate,  CompanyId,  GroupID,  DepartmentID,  ExistingCustomer,  CustomerGroupId,  CustomerGroupCode,  CustomerGroup,  CustomerCompanyId,  CustomerCompany,  CustomerCompanyCode,  CustomerDepartmentId,  CustomerDepartment,  CustomerDepartmentCode,  CustomerPersonId,  CustomerPerson,  CustomerPersonCode,  CustomerContact,  ExistingRefference,  RefferenceGroupId,  RefferenceGroupCode,  RefferenceGroup,  RefferenceCompanyId,  RefferenceCompany,  RefferenceCompanyCode,  RefferenceDepartmentId,  RefferenceDepartment,  RefferenceDepartmentCode,  RefferencePersonId,  RefferencePerson,  RefferencePersonCode,  RefferenceContact,ExistingReceiver,  ReceiverGroupId,  ReceiverGroupCode,  ReceiverGroup,  ReceiverCompanyId,  ReceiverCompany,  ReceiverCompanyCode,  ReceiverDepartmentId,  ReceiverDepartment,  ReceiverDepartmentCode,  ReceiverPersonId,  ReceiverPerson,  ReceiverPersonCode,  ReceiverContact,  ExistingBillTo,  BillToGroupId,  BillToGroupCode,  BillToGroup,  BillToCompanyId,  BillToCompany,  BillToCompanyCode,  BillToDepartmentId,  BillToDepartment,  BillToDepartmentCode,  BillToPersonId,  BillToPerson,  BillToPersonCode,  BillToContact,  IsCommunicatewithCustomer,  Status,  OrderCompleted,  Active,  AssessmentReponse,  OrderPlacment, ManualBiltyNo,  ManualBiltyDate)
      VALUES                         (@OrderDate, @CustomerID, @IsForward, @Department, @IsResponseBackToCustomer, @IsInquiryToOrder, @IsComplete, @CreatedBy, @ModifiedBy, @CreatedDate, @ModifiedDate, @CompanyId, @GroupID, @DepartmentID, @ExistingCustomer, @CustomerGroupId, @CustomerGroupCode, @CustomerGroup, @CustomerCompanyId, @CustomerCompany, @CustomerCompanyCode, @CustomerDepartmentId, @CustomerDepartment, @CustomerDepartmentCode, @CustomerPersonId, @CustomerPerson, @CustomerPersonCode, @CustomerContact, @ExistingRefference, @RefferenceGroupId, @RefferenceGroupCode, @RefferenceGroup, @RefferenceCompanyId, @RefferenceCompany, @RefferenceCompanyCode, @RefferenceDepartmentId, @RefferenceDepartment, @RefferenceDepartmentCode, @RefferencePersonId, @RefferencePerson, @RefferencePersonCode, @RefferenceContact, @ExistingReceiver, @ReceiverGroupId, @ReceiverGroupCode, @ReceiverGroup, @ReceiverCompanyId, @ReceiverCompany, @ReceiverCompanyCode, @ReceiverDepartmentId, @ReceiverDepartment, @ReceiverDepartmentCode, @ReceiverPersonId, @ReceiverPerson, @ReceiverPersonCode, @ReceiverContact, @ExistingBillTo, @BillToGroupId, @BillToGroupCode, @BillToGroup, @BillToCompanyId, @BillToCompany, @BillToCompanyCode, @BillToDepartmentId, @BillToDepartment, @BillToDepartmentCode, @BillToPersonId, @BillToPerson, @BillToPersonCode, @BillToContact, @IsCommunicatewithCustomer, @Status, @OrderCompleted, @Active, @AssessmentReponse, @OrderPlacment,@ManualBiltyNo, @ManualBiltyDate)

      SET       @Order_ID                      = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    InquiryAndOrders
      SET       OrderDate                      = COALESCE(@OrderDate,OrderDate),
                CustomerID                     = COALESCE(@CustomerID,CustomerID),
                IsForward                      = COALESCE(@IsForward,IsForward),
                Department                     = COALESCE(@Department,Department),
                IsResponseBackToCustomer       = COALESCE(@IsResponseBackToCustomer,IsResponseBackToCustomer),
                IsInquiryToOrder               = COALESCE(@IsInquiryToOrder,IsInquiryToOrder),
                IsComplete                     = COALESCE(@IsComplete,IsComplete),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                CompanyId                      = COALESCE(@CompanyId,CompanyId),
                GroupID                        = COALESCE(@GroupID,GroupID),
                DepartmentID                   = COALESCE(@DepartmentID,DepartmentID),
                ExistingCustomer               = COALESCE(@ExistingCustomer,ExistingCustomer),
                CustomerGroupId                = COALESCE(@CustomerGroupId,CustomerGroupId),
                CustomerGroupCode              = COALESCE(@CustomerGroupCode,CustomerGroupCode),
                CustomerGroup                  = COALESCE(@CustomerGroup,CustomerGroup),
                CustomerCompanyId              = COALESCE(@CustomerCompanyId,CustomerCompanyId),
                CustomerCompany                = COALESCE(@CustomerCompany,CustomerCompany),
                CustomerCompanyCode            = COALESCE(@CustomerCompanyCode,CustomerCompanyCode),
                CustomerDepartmentId           = COALESCE(@CustomerDepartmentId,CustomerDepartmentId),
                CustomerDepartment             = COALESCE(@CustomerDepartment,CustomerDepartment),
                CustomerDepartmentCode         = COALESCE(@CustomerDepartmentCode,CustomerDepartmentCode),
                CustomerPersonId               = COALESCE(@CustomerPersonId,CustomerPersonId),
                CustomerPerson                 = COALESCE(@CustomerPerson,CustomerPerson),
                CustomerPersonCode             = COALESCE(@CustomerPersonCode,CustomerPersonCode),
                CustomerContact                = COALESCE(@CustomerContact,CustomerContact),
                ExistingRefference             = COALESCE(@ExistingRefference,ExistingRefference),
                RefferenceGroupId              = COALESCE(@RefferenceGroupId,RefferenceGroupId),
                RefferenceGroupCode            = COALESCE(@RefferenceGroupCode,RefferenceGroupCode),
                RefferenceGroup                = COALESCE(@RefferenceGroup,RefferenceGroup),
                RefferenceCompanyId            = COALESCE(@RefferenceCompanyId,RefferenceCompanyId),
                RefferenceCompany              = COALESCE(@RefferenceCompany,RefferenceCompany),
                RefferenceCompanyCode          = COALESCE(@RefferenceCompanyCode,RefferenceCompanyCode),
                RefferenceDepartmentId         = COALESCE(@RefferenceDepartmentId,RefferenceDepartmentId),
                RefferenceDepartment           = COALESCE(@RefferenceDepartment,RefferenceDepartment),
                RefferenceDepartmentCode       = COALESCE(@RefferenceDepartmentCode,RefferenceDepartmentCode),
                RefferencePersonId             = COALESCE(@RefferencePersonId,RefferencePersonId),
                RefferencePerson               = COALESCE(@RefferencePerson,RefferencePerson),
                RefferencePersonCode           = COALESCE(@RefferencePersonCode,RefferencePersonCode),
                RefferenceContact              = COALESCE(@RefferenceContact,RefferenceContact),
				 ExistingReceiver               = COALESCE(@ExistingReceiver,ExistingReceiver),
                ReceiverGroupId                = COALESCE(@ReceiverGroupId,ReceiverGroupId),
                ReceiverGroupCode              = COALESCE(@ReceiverGroupCode,ReceiverGroupCode),
                ReceiverGroup                  = COALESCE(@ReceiverGroup,ReceiverGroup),
                ReceiverCompanyId              = COALESCE(@ReceiverCompanyId,ReceiverCompanyId),
                ReceiverCompany                = COALESCE(@ReceiverCompany,ReceiverCompany),
                ReceiverCompanyCode            = COALESCE(@ReceiverCompanyCode,ReceiverCompanyCode),
                ReceiverDepartmentId           = COALESCE(@ReceiverDepartmentId,ReceiverDepartmentId),
                ReceiverDepartment             = COALESCE(@ReceiverDepartment,ReceiverDepartment),
                ReceiverDepartmentCode         = COALESCE(@ReceiverDepartmentCode,ReceiverDepartmentCode),
                ReceiverPersonId               = COALESCE(@ReceiverPersonId,ReceiverPersonId),
                ReceiverPerson                 = COALESCE(@ReceiverPerson,ReceiverPerson),
                ReceiverPersonCode             = COALESCE(@ReceiverPersonCode,ReceiverPersonCode),
                ReceiverContact                = COALESCE(@ReceiverContact,ReceiverContact),
                ExistingBillTo                 = COALESCE(@ExistingBillTo,ExistingBillTo),
                BillToGroupId                  = COALESCE(@BillToGroupId,BillToGroupId),
                BillToGroupCode                = COALESCE(@BillToGroupCode,BillToGroupCode),
                BillToGroup                    = COALESCE(@BillToGroup,BillToGroup),
                BillToCompanyId                = COALESCE(@BillToCompanyId,BillToCompanyId),
                BillToCompany                  = COALESCE(@BillToCompany,BillToCompany),
                BillToCompanyCode              = COALESCE(@BillToCompanyCode,BillToCompanyCode),
                BillToDepartmentId             = COALESCE(@BillToDepartmentId,BillToDepartmentId),
                BillToDepartment               = COALESCE(@BillToDepartment,BillToDepartment),
                BillToDepartmentCode           = COALESCE(@BillToDepartmentCode,BillToDepartmentCode),
                BillToPersonId                 = COALESCE(@BillToPersonId,BillToPersonId),
                BillToPerson                   = COALESCE(@BillToPerson,BillToPerson),
                BillToPersonCode               = COALESCE(@BillToPersonCode,BillToPersonCode),
                BillToContact                  = COALESCE(@BillToContact,BillToContact),
                IsCommunicatewithCustomer      = COALESCE(@IsCommunicatewithCustomer,IsCommunicatewithCustomer),
                Status                         = COALESCE(@Status,Status),
                OrderCompleted                 = COALESCE(@OrderCompleted,OrderCompleted),
                Active                         = COALESCE(@Active,Active),
                AssessmentReponse              = COALESCE(@AssessmentReponse,AssessmentReponse),
                OrderPlacment                  = COALESCE(@OrderPlacment,OrderPlacment),
				ManualBiltyNo                  = COALESCE(@ManualBiltyNo,ManualBiltyNo),
                ManualBiltyDate                = COALESCE(@ManualBiltyDate,ManualBiltyDate)
                
      WHERE     Order_ID                       = @Order_ID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    InquiryAndOrders
      WHERE     Order_ID                       = @Order_ID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, Order_ID, OrderDate, CustomerID, IsForward, Department, IsResponseBackToCustomer, IsInquiryToOrder, IsComplete, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, CompanyId, GroupID, DepartmentID, ExistingCustomer, CustomerGroupId, CustomerGroupCode, CustomerGroup, CustomerCompanyId, CustomerCompany, CustomerCompanyCode, CustomerDepartmentId, CustomerDepartment, CustomerDepartmentCode, CustomerPersonId, CustomerPerson, CustomerPersonCode, CustomerContact, ExistingRefference, RefferenceGroupId, RefferenceGroupCode, RefferenceGroup, RefferenceCompanyId, RefferenceCompany, RefferenceCompanyCode, RefferenceDepartmentId, RefferenceDepartment, RefferenceDepartmentCode, RefferencePersonId, RefferencePerson, RefferencePersonCode, RefferenceContact, ReceiverGroupId, ReceiverGroupCode, ReceiverGroup, ReceiverCompanyId, ReceiverCompany, ReceiverCompanyCode, ReceiverDepartmentId, ReceiverDepartment, ReceiverDepartmentCode, ReceiverPersonId, ReceiverPerson, ReceiverPersonCode, ReceiverContact, ExistingBillTo, BillToGroupId, BillToGroupCode, BillToGroup, BillToCompanyId, BillToCompany, BillToCompanyCode, BillToDepartmentId, BillToDepartment, BillToDepartmentCode, BillToPersonId, BillToPerson, BillToPersonCode, BillToContact,  IsCommunicatewithCustomer, Status, OrderCompleted, Active, AssessmentReponse, OrderPlacment,BiltyNo,ManualBiltyNo, ManualBiltyDate
      FROM      InquiryAndOrders
      WHERE     Order_ID                                          = COALESCE(@Order_ID,Order_ID)
	   
  AND       COALESCE(IsForward,0)                             = COALESCE(@IsForward,COALESCE(IsForward,0))

 AND       COALESCE(CompanyId,0)                             = COALESCE(@CompanyId,COALESCE(CompanyId,0))
      --AND       OrderDate                                         = COALESCE(@OrderDate,OrderDate)
      --AND       CustomerID                                        = COALESCE(@CustomerID,CustomerID)
      AND       COALESCE(IsForward,0)                             = COALESCE(@IsForward,COALESCE(IsForward,0))
      --AND       COALESCE(Department,0)                            = COALESCE(@Department,COALESCE(Department,0))
      AND       COALESCE(IsResponseBackToCustomer,0)              = COALESCE(@IsResponseBackToCustomer,COALESCE(IsResponseBackToCustomer,0))
      AND       COALESCE(IsInquiryToOrder,0)                      = COALESCE(@IsInquiryToOrder,COALESCE(IsInquiryToOrder,0))
      --AND       COALESCE(IsComplete,0)                            = COALESCE(@IsComplete,COALESCE(IsComplete,0))
      --AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
      AND       COALESCE(CompanyId,0)                             = COALESCE(@CompanyId,COALESCE(CompanyId,0))
      AND       COALESCE(GroupID,0)                               = COALESCE(@GroupID,COALESCE(GroupID,0))
      AND       COALESCE(DepartmentID,0)                          = COALESCE(@DepartmentID,COALESCE(DepartmentID,0))
      --AND       COALESCE(ExistingCustomer,0)                      = COALESCE(@ExistingCustomer,COALESCE(ExistingCustomer,0))
      --AND       CustomerGroupId                                   = COALESCE(@CustomerGroupId,CustomerGroupId)
      --AND       COALESCE(CustomerGroupCode,'X')                   = COALESCE(@CustomerGroupCode,COALESCE(CustomerGroupCode,'X'))
      --AND       COALESCE(CustomerGroup,'X')                       = COALESCE(@CustomerGroup,COALESCE(CustomerGroup,'X'))
      --AND       COALESCE(CustomerCompanyId,0)                     = COALESCE(@CustomerCompanyId,COALESCE(CustomerCompanyId,0))
      --AND       COALESCE(CustomerCompany,'X')                     = COALESCE(@CustomerCompany,COALESCE(CustomerCompany,'X'))
      --AND       COALESCE(CustomerCompanyCode,'X')                 = COALESCE(@CustomerCompanyCode,COALESCE(CustomerCompanyCode,'X'))
      --AND       COALESCE(CustomerDepartmentId,0)                  = COALESCE(@CustomerDepartmentId,COALESCE(CustomerDepartmentId,0))
      --AND       COALESCE(CustomerDepartment,'X')                  = COALESCE(@CustomerDepartment,COALESCE(CustomerDepartment,'X'))
      --AND       COALESCE(CustomerDepartmentCode,'X')              = COALESCE(@CustomerDepartmentCode,COALESCE(CustomerDepartmentCode,'X'))
      --AND       COALESCE(CustomerPersonId,0)                      = COALESCE(@CustomerPersonId,COALESCE(CustomerPersonId,0))
      --AND       COALESCE(CustomerPerson,'X')                      = COALESCE(@CustomerPerson,COALESCE(CustomerPerson,'X'))
      --AND       COALESCE(CustomerPersonCode,'X')                  = COALESCE(@CustomerPersonCode,COALESCE(CustomerPersonCode,'X'))
      --AND       COALESCE(CustomerContact,'X')                     = COALESCE(@CustomerContact,COALESCE(CustomerContact,'X'))
      --AND       COALESCE(ExistingRefference,0)                    = COALESCE(@ExistingRefference,COALESCE(ExistingRefference,0))
      --AND       COALESCE(RefferenceGroupId,0)                     = COALESCE(@RefferenceGroupId,COALESCE(RefferenceGroupId,0))
      --AND       COALESCE(RefferenceGroupCode,'X')                 = COALESCE(@RefferenceGroupCode,COALESCE(RefferenceGroupCode,'X'))
      --AND       COALESCE(RefferenceGroup,'X')                     = COALESCE(@RefferenceGroup,COALESCE(RefferenceGroup,'X'))
      --AND       COALESCE(RefferenceCompanyId,0)                   = COALESCE(@RefferenceCompanyId,COALESCE(RefferenceCompanyId,0))
      --AND       COALESCE(RefferenceCompany,'X')                   = COALESCE(@RefferenceCompany,COALESCE(RefferenceCompany,'X'))
      --AND       COALESCE(RefferenceCompanyCode,'X')               = COALESCE(@RefferenceCompanyCode,COALESCE(RefferenceCompanyCode,'X'))
      --AND       COALESCE(RefferenceDepartmentId,0)                = COALESCE(@RefferenceDepartmentId,COALESCE(RefferenceDepartmentId,0))
      --AND       COALESCE(RefferenceDepartment,'X')                = COALESCE(@RefferenceDepartment,COALESCE(RefferenceDepartment,'X'))
      --AND       COALESCE(RefferenceDepartmentCode,'X')            = COALESCE(@RefferenceDepartmentCode,COALESCE(RefferenceDepartmentCode,'X'))
      --AND       COALESCE(RefferencePersonId,0)                    = COALESCE(@RefferencePersonId,COALESCE(RefferencePersonId,0))
      --AND       COALESCE(RefferencePerson,'X')                    = COALESCE(@RefferencePerson,COALESCE(RefferencePerson,'X'))
      --AND       COALESCE(RefferencePersonCode,'X')                = COALESCE(@RefferencePersonCode,COALESCE(RefferencePersonCode,'X'))
      --AND       COALESCE(RefferenceContact,'X')                   = COALESCE(@RefferenceContact,COALESCE(RefferenceContact,'X'))
      --AND       COALESCE(IsCommunicatewithCustomer,0)             = COALESCE(@IsCommunicatewithCustomer,COALESCE(IsCommunicatewithCustomer,0))
      --AND       COALESCE(Status,'X')                              = COALESCE(@Status,COALESCE(Status,'X'))
      --AND       COALESCE(OrderCompleted,0)                        = COALESCE(@OrderCompleted,COALESCE(OrderCompleted,0))
      AND       COALESCE(Active,0)                                = COALESCE(@Active,COALESCE(Active,0))
      --AND       COALESCE(AssessmentReponse,0)                     = COALESCE(@AssessmentReponse,COALESCE(AssessmentReponse,0))
      --AND       OrderPlacment                                     = COALESCE(@OrderPlacment,OrderPlacment)
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    BEGIN
	   SELECT    @Action_Type  AS ActionType, Order_ID, OrderDate, CustomerID, IsForward, Department, IsResponseBackToCustomer, IsInquiryToOrder, IsComplete, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, CompanyId, GroupID, DepartmentID, ExistingCustomer, CustomerGroupId, CustomerGroupCode, CustomerGroup, CustomerCompanyId, CustomerCompany, CustomerCompanyCode, CustomerDepartmentId, CustomerDepartment, CustomerDepartmentCode, CustomerPersonId, CustomerPerson, CustomerPersonCode, CustomerContact, ExistingRefference, RefferenceGroupId, RefferenceGroupCode, RefferenceGroup, RefferenceCompanyId, RefferenceCompany, RefferenceCompanyCode, RefferenceDepartmentId, RefferenceDepartment, RefferenceDepartmentCode, RefferencePersonId, RefferencePerson, RefferencePersonCode, RefferenceContact, IsCommunicatewithCustomer, Status, OrderCompleted, Active, AssessmentReponse, OrderPlacment,BiltyNo
      FROM      InquiryAndOrders
	   WHERE     
	           COALESCE(CompanyId,0)                             = COALESCE(@CompanyId,COALESCE(CompanyId,0))
      AND       COALESCE(GroupID,0)                               = COALESCE(@GroupID,COALESCE(GroupID,0))
      AND       COALESCE(DepartmentID,0)                          = COALESCE(@DepartmentID,COALESCE(DepartmentID,0))                                    
	  END
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_InquiryAndOrders---------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_InquiryAndOrdersDetail]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_InquiryAndOrdersDetail                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦ ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Friday, 14 Dec 2018 23:52:41:427                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_InquiryAndOrdersDetail](@Action_Type                    numeric(10),
                                            @p_Success                      bit             = 1    OUTPUT,
                                            @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                            @ImportExportID                 bigint          = NULL OUTPUT, 
                                            @ShipmentTypeId                 int             = NULL,
                                            @OrderDetail_ID                 bigint          = NULL,
                                            @ContainerTypeID                bigint       = NULL,
                                            @ContainerTypeQuantity          bigint          = NULL,
                                            @TotalWeight                    float(53)       = NULL,
                                            @ContainerPickupLocationID      bigint          = NULL,
                                            @ContainerPickupAddress         nvarchar(150)   = NULL,
                                            @ExportCargoPickLocationID      bigint          = NULL,
                                            @ExportCargoPickAddress         nvarchar(150)   = NULL,
                                            @ContainerDropOfLocationID      bigint          = NULL,
                                            @ContainerDropOfAddress         nvarchar(150)   = NULL,
                                            @ImportContainerDropOption      nvarchar(50)    = NULL,
                                            @Dispatch_Date                  datetime        = NULL,
                                            @ShippingLine                   nvarchar(50)    = NULL,
                                            @ContainerTerminalOrYeard       nvarchar(50)    = NULL,
                                            @BillingType                    nvarchar(50)    = NULL,
                                            @Status                         nvarchar(50)    = NULL,
                                            @VehicleID                      bigint          = NULL,
                                            @DriverID                       bigint          = NULL,
                                            @BrokerID                       bigint          = NULL,
                                            @CreatedDate                    datetime        = NULL,
                                            @ModifiedDate                   datetime        = NULL,
                                            @CreatedBy                      bigint          = NULL,
                                            @ModifiedBy                     bigint          = NULL,
                                            @VehicleTypeId                  int             = NULL,
                                            @VehicleTypeQuantity            int             = NULL,
                                            @ContainerToVehicle             nvarchar(50)    = NULL,
                                            @LoadingUnloadingLocationType   nvarchar(50)    = NULL,
                                            @LoadingUnloadingExpenseTypeId  int             = NULL,
                                            @LoadingUnloadingExpenseTypeQty int             = NULL,
                                            @LoadingUnloadingExpenseTypeCapacity nvarchar(50)    = NULL,
                                            @OtherExpenseTypeId             int             = NULL,
                                            @OtherExpenseTypeQty            int             = NULL,
                                            @OtherExpenseTypeCapacity       nvarchar(50)    = NULL,
                                            @PackageTypeID                  int             = NULL,
                                            @Length                         float(53)       = NULL,
                                            @Width                          float(53)       = NULL,
                                            @Height                         float(53)       = NULL,
                                            @LoadQuantityWise               float(53)       = NULL,
                                            @LoadWeightWise                 float(53)       = NULL,
                                            @Expenses_on_Consignment        float(53)       = NULL,
                                            @Profit                         float(53)       = NULL,
                                            @Other_Charges                  float(53)       = NULL,
                                            @Tax                            float(53)       = NULL,
                                            @Total                          float(53)       = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO InquiryAndOrdersDetail(ShipmentTypeId,  OrderDetail_ID,  ContainerTypeID,  ContainerTypeQuantity,  TotalWeight,  ContainerPickupLocationID,  ContainerPickupAddress,  ExportCargoPickLocationID,  ExportCargoPickAddress,  ContainerDropOfLocationID,  ContainerDropOfAddress,  ImportContainerDropOption,  Dispatch_Date,  ShippingLine,  ContainerTerminalOrYeard,  BillingType,  Status,  VehicleID,  DriverID,  BrokerID,  CreatedDate,  ModifiedDate,  CreatedBy,  ModifiedBy,  VehicleTypeId,  VehicleTypeQuantity,  ContainerToVehicle,  LoadingUnloadingLocationType,  LoadingUnloadingExpenseTypeId,  LoadingUnloadingExpenseTypeQty,  LoadingUnloadingExpenseTypeCapacity,  OtherExpenseTypeId,  OtherExpenseTypeQty,  OtherExpenseTypeCapacity,  PackageTypeID,  Length,  Width,  Height,  LoadQuantityWise,  LoadWeightWise,  Expenses_on_Consignment,  Profit,  Other_Charges,  Tax,  Total)
      VALUES                               (@ShipmentTypeId, @OrderDetail_ID, @ContainerTypeID, @ContainerTypeQuantity, @TotalWeight, @ContainerPickupLocationID, @ContainerPickupAddress, @ExportCargoPickLocationID, @ExportCargoPickAddress, @ContainerDropOfLocationID, @ContainerDropOfAddress, @ImportContainerDropOption, @Dispatch_Date, @ShippingLine, @ContainerTerminalOrYeard, @BillingType, @Status, @VehicleID, @DriverID, @BrokerID, @CreatedDate, @ModifiedDate, @CreatedBy, @ModifiedBy, @VehicleTypeId, @VehicleTypeQuantity, @ContainerToVehicle, @LoadingUnloadingLocationType, @LoadingUnloadingExpenseTypeId, @LoadingUnloadingExpenseTypeQty, @LoadingUnloadingExpenseTypeCapacity, @OtherExpenseTypeId, @OtherExpenseTypeQty, @OtherExpenseTypeCapacity, @PackageTypeID, @Length, @Width, @Height, @LoadQuantityWise, @LoadWeightWise, @Expenses_on_Consignment, @Profit, @Other_Charges, @Tax, @Total)

      SET       @ImportExportID                = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    InquiryAndOrdersDetail
      SET       ShipmentTypeId                 = COALESCE(@ShipmentTypeId,ShipmentTypeId),
                OrderDetail_ID                 = COALESCE(@OrderDetail_ID,OrderDetail_ID),
                ContainerTypeID                = COALESCE(@ContainerTypeID,ContainerTypeID),
                ContainerTypeQuantity          = COALESCE(@ContainerTypeQuantity,ContainerTypeQuantity),
                TotalWeight                    = COALESCE(@TotalWeight,TotalWeight),
                ContainerPickupLocationID      = COALESCE(@ContainerPickupLocationID,ContainerPickupLocationID),
                ContainerPickupAddress         = COALESCE(@ContainerPickupAddress,ContainerPickupAddress),
                ExportCargoPickLocationID      = COALESCE(@ExportCargoPickLocationID,ExportCargoPickLocationID),
                ExportCargoPickAddress         = COALESCE(@ExportCargoPickAddress,ExportCargoPickAddress),
                ContainerDropOfLocationID      = COALESCE(@ContainerDropOfLocationID,ContainerDropOfLocationID),
                ContainerDropOfAddress         = COALESCE(@ContainerDropOfAddress,ContainerDropOfAddress),
                ImportContainerDropOption      = COALESCE(@ImportContainerDropOption,ImportContainerDropOption),
                Dispatch_Date                  = COALESCE(@Dispatch_Date,Dispatch_Date),
                ShippingLine                   = COALESCE(@ShippingLine,ShippingLine),
                ContainerTerminalOrYeard       = COALESCE(@ContainerTerminalOrYeard,ContainerTerminalOrYeard),
                BillingType                    = COALESCE(@BillingType,BillingType),
                Status                         = COALESCE(@Status,Status),
                VehicleID                      = COALESCE(@VehicleID,VehicleID),
                DriverID                       = COALESCE(@DriverID,DriverID),
                BrokerID                       = COALESCE(@BrokerID,BrokerID),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                VehicleTypeId                  = COALESCE(@VehicleTypeId,VehicleTypeId),
                VehicleTypeQuantity            = COALESCE(@VehicleTypeQuantity,VehicleTypeQuantity),
                ContainerToVehicle             = COALESCE(@ContainerToVehicle,ContainerToVehicle),
                LoadingUnloadingLocationType   = COALESCE(@LoadingUnloadingLocationType,LoadingUnloadingLocationType),
                LoadingUnloadingExpenseTypeId  = COALESCE(@LoadingUnloadingExpenseTypeId,LoadingUnloadingExpenseTypeId),
                LoadingUnloadingExpenseTypeQty = COALESCE(@LoadingUnloadingExpenseTypeQty,LoadingUnloadingExpenseTypeQty),
                LoadingUnloadingExpenseTypeCapacity= COALESCE(@LoadingUnloadingExpenseTypeCapacity,LoadingUnloadingExpenseTypeCapacity),
                OtherExpenseTypeId             = COALESCE(@OtherExpenseTypeId,OtherExpenseTypeId),
                OtherExpenseTypeQty            = COALESCE(@OtherExpenseTypeQty,OtherExpenseTypeQty),
                OtherExpenseTypeCapacity       = COALESCE(@OtherExpenseTypeCapacity,OtherExpenseTypeCapacity),
                PackageTypeID                  = COALESCE(@PackageTypeID,PackageTypeID),
                Length                         = COALESCE(@Length,Length),
                Width                          = COALESCE(@Width,Width),
                Height                         = COALESCE(@Height,Height),
                LoadQuantityWise               = COALESCE(@LoadQuantityWise,LoadQuantityWise),
                LoadWeightWise                 = COALESCE(@LoadWeightWise,LoadWeightWise),
                Expenses_on_Consignment        = COALESCE(@Expenses_on_Consignment,Expenses_on_Consignment),
                Profit                         = COALESCE(@Profit,Profit),
                Other_Charges                  = COALESCE(@Other_Charges,Other_Charges),
                Tax                            = COALESCE(@Tax,Tax),
                Total                          = COALESCE(@Total,Total)
                
      WHERE     ImportExportID                 = @ImportExportID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    InquiryAndOrdersDetail
      WHERE     ImportExportID                 = @ImportExportID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
     SELECT    ''  AS ActionType, isnull(ST.ShipmentType,pack.PackageTypeCode+'-'+Pack.PackageTypeName) ShipmentType,
		   CPICK.PickDropLocationName AS 'CONTAINER_PICKLOCATION',   CDROP.PickDropLocationName  AS 'CONTAINER_DROPLOCATION',	
		   	   ECARGO.PickDropLocationName AS 'EXPORT_CARGOPICKLOCATION',isnull(CT.ContainerType,pack.PackageTypeCode+'-'+Pack.PackageTypeName) ContainerType, VT.VehicleTypeCode,VT.VehicleTypeName,
			   LoadUnloadET1.ExpensesTypeName,LoadUnloadET1.ExpensesTypeCode,
			   OtherET1.ExpensesTypeName AS 'OtherExpensesTypeName',OtherET1.ExpensesTypeCode AS 'OtherExpensesTypeCode',S.StatusName,S.Color,

		   ACEI.*	
      FROM      InquiryAndOrdersDetail  ACEI
	  INNER JOIN Status S on ACEI.Status=S.StatusCode
	  INNER JOIN InquiryAndOrders Ord on ACEI.OrderDetail_ID=Ord.Order_ID
	  LEFT JOIN PickDropLocation CPICK ON ACEI.ContainerPickupLocationID=CPICK.PickDropID
	  LEFT JOIN PickDropLocation CDROP ON ACEI.ContainerDropOfLocationID=CDROP.PickDropID
	  LEFT JOIN PickDropLocation ECARGO ON ACEI.ExportCargoPickLocationID=ECARGO.PickDropID
	  LEFT JOIN ShipmentType ST ON ACEI.ShipmentTypeId=ST.SHIPMENTTYPE_ID
	  LEFT JOIN ContainerType CT on ACEI.ContainerTypeID=CT.ContainerTypeID
	  Left join VehicleType VT on ACEI.VehicleTypeID=VT.VehicleTypeID
	  LEFT JOIN ExpensesType LoadUnloadET1 on ACEI.LoadingUnloadingExpenseTypeId=LoadUnloadET1.ExpensesTypeID
	  LEFT JOIN ExpensesType OtherET1 on ACEI.LoadingUnloadingExpenseTypeId=OtherET1.ExpensesTypeID
	  LEFT JOIN PackageType Pack on ACEI.PackageTypeId=pack.PackageTypeID
	  
	 -- where ACEI.ORDERDETAIL_id=1  
      WHERE     ACEI.ImportExportID                                    = COALESCE(@ImportExportID,ACEI.ImportExportID)
      AND       ACEI.ShipmentTypeId                                    = COALESCE(@ShipmentTypeId,ACEI.ShipmentTypeId)
      AND       ACEI.OrderDetail_ID                                    = COALESCE(@OrderDetail_ID,ACEI.OrderDetail_ID)
      AND       ACEI.ContainerTypeID                                   = COALESCE(@ContainerTypeID,ACEI.ContainerTypeID)
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_InquiryAndOrdersDetail---------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_InvoiceExpenseType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_InvoiceExpenseType                                                                                                           ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Wednesday, 04 Mar 2020 00:26:20:530                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_InvoiceExpenseType](@Action_Type                    numeric(10),
                                        @p_Success                      bit             = 1    OUTPUT,
                                        @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                        @InvoiceExpenseTypeId           bigint          = NULL OUTPUT, 
                                        @Name                           nvarchar(50)    = NULL,
                                        @Active                         bit             = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO InvoiceExpenseType(Name,  Active)
      VALUES                           (@Name, @Active)

      SET       @InvoiceExpenseTypeId          = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    InvoiceExpenseType
      SET       Name                           = COALESCE(@Name,Name),
                Active                         = COALESCE(@Active,Active)
                
      WHERE     InvoiceExpenseTypeId           = @InvoiceExpenseTypeId
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    InvoiceExpenseType
      WHERE     InvoiceExpenseTypeId           = @InvoiceExpenseTypeId
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, InvoiceExpenseTypeId, Name, Active
      FROM      InvoiceExpenseType
      WHERE     InvoiceExpenseTypeId                              = COALESCE(@InvoiceExpenseTypeId,InvoiceExpenseTypeId)
      AND       COALESCE(Name,'X')                                = COALESCE(@Name,COALESCE(Name,'X'))
      AND       COALESCE(Active,0)                                = COALESCE(@Active,COALESCE(Active,0))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_InvoiceExpenseType-------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[usp_Invoices]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Invoices                                                                                                                     ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Saturday, 07 Sep 2019 12:57:30:180                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Invoices](@Action_Type                    numeric(10),
                              @p_Success                      bit             = 1    OUTPUT,
                              @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                              @InvoiceNo                      bigint          = NULL OUTPUT, 
                              @ReportId                       int             = NULL,
                              @CompanyId                      bigint          = NULL,
                              @DateFrom                       date            = NULL,
                              @DateTo                         date            = NULL,
                              @InvoiceDate                    date            = NULL,
                              @DateCreated                    datetime        = NULL,
                              @CreatedBy                      bigint          = NULL,
                              @DateModified                   datetime        = NULL,
                              @ModifiedBy                     bigint          = NULL,
							  @Expenses			  nvarchar		  = 0,
							  @ExpensesAmount				  bigint		  = 0,
							  @SaleTax						  float			  = 0.0,
							  @InvoiceTotalAmount bigint =0)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Invoices(ReportId,  CompanyId,  DateFrom,  DateTo,  InvoiceDate,  DateCreated,  CreatedBy,  DateModified,  ModifiedBy,Expenses,ExpensesAmount,SaleTax,InvoiceTotalAmount	)
      VALUES                 (@ReportId, @CompanyId, @DateFrom, @DateTo, @InvoiceDate, @DateCreated, @CreatedBy, @DateModified, @ModifiedBy,@Expenses,@ExpensesAmount,@SaleTax,@InvoiceTotalAmount	)

      SET       @InvoiceNo                     = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Invoices
      SET       ReportId                       = COALESCE(@ReportId,ReportId),
                CompanyId                      = COALESCE(@CompanyId,CompanyId),
                DateFrom                       = COALESCE(@DateFrom,DateFrom),
                DateTo                         = COALESCE(@DateTo,DateTo),
                InvoiceDate                    = COALESCE(@InvoiceDate,InvoiceDate),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                DateModified                   = COALESCE(@DateModified,DateModified),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy)
                
      WHERE     InvoiceNo                      = @InvoiceNo
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Invoices
      WHERE     InvoiceNo                      = @InvoiceNo
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, InvoiceNo,ReportsType.ReportName,Company.CompanyName, Invoices.ReportId, Invoices.CompanyId, DateFrom, DateTo, InvoiceDate, DateCreated, Invoices.CreatedBy, Invoices.DateModified, ISNULL(Invoices.ModifiedBy,0)'ModifiedBy',BiltyNo,BillCode,Invoices.Expenses,Invoices.ExpensesAmount,
	  Invoices.SaleTax,Invoices.InvoiceTotalAmount
      FROM      Invoices
	  Inner join ReportsType on Invoices.ReportId=ReportsType.ReportId
	  INNER JOIN Company on Invoices.CompanyId=Company.CompanyID
      WHERE     InvoiceNo                                         = COALESCE(@InvoiceNo,InvoiceNo)
      AND       COALESCE(Invoices.ReportId,0)                              = COALESCE(@ReportId,COALESCE(Invoices.ReportId,0))
      AND       COALESCE(Invoices.CompanyId,0)                             = COALESCE(@CompanyId,COALESCE(Invoices.CompanyId,0))
      --AND       COALESCE(DateFrom,GETDATE())                      = COALESCE(@DateFrom,COALESCE(DateFrom,GETDATE()))
      --AND       COALESCE(DateTo,GETDATE())                        = COALESCE(@DateTo,COALESCE(DateTo,GETDATE()))
      --AND       COALESCE(InvoiceDate,GETDATE())                   = COALESCE(@InvoiceDate,COALESCE(InvoiceDate,GETDATE()))
      --AND       COALESCE(Invoices.DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(Invoices.DateCreated,GETDATE()))
      --AND       COALESCE(Invoices.CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(Invoices.CreatedBy,0))
      --AND       COALESCE(Invoices.DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(Invoices.DateModified,GETDATE()))
      --AND       COALESCE(Invoices.ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(Invoices.ModifiedBy,0))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Invoices-----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_Item]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Item                                                                                                                         ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Monday, 18 Feb 2019 22:43:34:207                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Item](@Action_Type                    numeric(10),
                          @p_Success                      bit             = 1    OUTPUT,
                          @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                          @ItemID                         bigint          = NULL OUTPUT, 
                          @ItemCode                       varchar(50)     = NULL,
                          @ItemName                       varchar(50)     = NULL,
                          @weight                         decimal(6)      = NULL,
                          @DateCreated                    datetime        = NULL,
                          @DateModified                   datetime        = NULL,
                          @CreatedByUserID                bigint          = NULL,
                          @ModifiedByUserID               bigint          = NULL,
                          @IsActive                       bit             = NULL,
                          @Description                    varchar(500)    = NULL,
                          @IsGeneralItem                  bit             = NULL,
                          @OwnerID                        bigint          = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Item(ItemCode,  ItemName,  weight,  DateCreated,  DateModified,  CreatedByUserID,  ModifiedByUserID,  IsActive,  Description,  IsGeneralItem,  OwnerID)
      VALUES             (@ItemCode, @ItemName, @weight, @DateCreated, @DateModified, @CreatedByUserID, @ModifiedByUserID, @IsActive, @Description, @IsGeneralItem, @OwnerID)

      SET       @ItemID                        = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Item
      SET       ItemCode                       = COALESCE(@ItemCode,ItemCode),
                ItemName                       = COALESCE(@ItemName,ItemName),
                weight                         = COALESCE(@weight,weight),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified),
                CreatedByUserID                = COALESCE(@CreatedByUserID,CreatedByUserID),
                ModifiedByUserID               = COALESCE(@ModifiedByUserID,ModifiedByUserID),
                IsActive                       = COALESCE(@IsActive,IsActive),
                Description                    = COALESCE(@Description,Description),
                IsGeneralItem                  = COALESCE(@IsGeneralItem,IsGeneralItem),
                OwnerID                        = COALESCE(@OwnerID,OwnerID)
                
      WHERE     ItemID                         = @ItemID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Item
      WHERE     ItemID                         = @ItemID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, ItemID, ItemCode, ItemName, weight, DateCreated, DateModified, CreatedByUserID, ModifiedByUserID, IsActive, Description, IsGeneralItem, OwnerID
      FROM      Item
      WHERE     ItemID                                            = COALESCE(@ItemID,ItemID)
      --AND       COALESCE(ItemCode,'X')                            = COALESCE(@ItemCode,COALESCE(ItemCode,'X'))
      --AND       COALESCE(ItemName,'X')                            = COALESCE(@ItemName,COALESCE(ItemName,'X'))
      --AND       weight                                            = COALESCE(@weight,weight)
      --AND       COALESCE(DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(DateCreated,GETDATE()))
      --AND       COALESCE(DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(DateModified,GETDATE()))
      --AND       COALESCE(CreatedByUserID,0)                       = COALESCE(@CreatedByUserID,COALESCE(CreatedByUserID,0))
      --AND       COALESCE(ModifiedByUserID,0)                      = COALESCE(@ModifiedByUserID,COALESCE(ModifiedByUserID,0))
      --AND       COALESCE(IsActive,0)                              = COALESCE(@IsActive,COALESCE(IsActive,0))
      --AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
      AND       COALESCE(IsGeneralItem,0)                         = COALESCE(@IsGeneralItem,COALESCE(IsGeneralItem,0))
      AND       COALESCE(OwnerID,0)                               = COALESCE(@OwnerID,COALESCE(OwnerID,0))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Item---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_LocalFreightReport]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_LocalFreightReport]

(
@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
							 @CompanyCode					nvarchar(5),
							 @DateFrom						date,
							 @DateTo						date,
							 @BillNoFrom					nvarchar(5) =null,
							 @BillNoTo						nvarchar(5) =null
)
AS 
BEGIN
DECLARE @query nvarchar(max)
DECLARE @WHERECLAUSE NVARCHAR(2000)=''
IF @CompanyCode is not null
SET @WHERECLAUSE = ' CUSTOMERCODE = '''+@CompanyCode +'''' 


IF  @BillNoFrom is not null  AND @BillNoTo is not null  AND @WHERECLAUSE =''  
	SET @WHERECLAUSE = @WHERECLAUSE + '    Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) >= CAST('''+@BillNoFrom + ''' as nvarchar)   AND  Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) <= CAST('''+@BillNoTo + ''' as nvarchar)'
IF  @BillNoFrom is not null  AND @BillNoTo is not null AND @WHERECLAUSE is not null AND @WHERECLAUSE<>''  
	SET @WHERECLAUSE = @WHERECLAUSE + '  AND  Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) >= CAST('''+@BillNoFrom + ''' as nvarchar)   AND  Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) <= CAST('''+@BillNoTo + ''' as nvarchar)'


IF  @DateFrom is not null AND @DateTo is not null   AND @WHERECLAUSE =''
	SET @WHERECLAUSE = @WHERECLAUSE + '   BiltyNoDate between '''+ CONVERT(varchar, @DateFrom, 23) + ''' and '''+ CONVERT(varchar, @DateTo, 23) +''''
IF  @DateFrom is not null AND @DateTo is not null AND @WHERECLAUSE is not null AND @WHERECLAUSE<>''
	SET @WHERECLAUSE = @WHERECLAUSE + ' AND  BiltyNoDate between '''+ CONVERT(varchar, @DateFrom, 23) + ''' and '''+ CONVERT(varchar, @DateTo, 23) +''''

SET @query ='
SELECT BiltyNoDate, BiltyNo,ManualBiltyNo,DA_No, Quantity,Destination, localFreight From 
(SELECT distinct  Cast([dbo].udf_GetNumeric(OD.BiltyNo) as bigint) BiltyRange, OD.BiltyNoDate,  OD.BiltyNo,ISNULL(OD.ManualBiltyNo,'''') ManualBiltyNo,ISNULL(OD.DA_No,'''') DA_No,CITYDROP.CityName Destination,SUM(OP.Quantity) Quantity,LocalFreight
,OD.OrderDetailId FROM OrderDetail OD
inner join OrderPackageTypes OP on OD.OrderDetailId=OP.OrderDetailId
INNER JOIN OrderLocations  On  OD.OrderDetailId=OrderLocations.OrderDetailId
inner join City AS CITYPICK on OrderLocations.PickupLocationId=CITYPICK.CityID 
inner join City AS CITYDROP on OrderLocations.DropLocationId=CITYDROP.CityID
left join Stations AS ST on OrderLocations.StationTo=ST.ID

WHERE  LocalFreight <> 0 and StatusID <> 5 and ParentId <=1 and '+@WHERECLAUSE+' 
GROUP by OD.BiltyNo,OD.BiltyNoDate,  OD.BiltyNo,OD.ManualBiltyNo,CITYDROP.CityName,OD.DA_No,OD.OrderDetailId,LocalFreight
) as tbl

order by tbl.orderdetailid ,tbl.BiltyNoDate, tbl.BiltyNo
'
print @query
EXEC(@query)
		 END 
GO
/****** Object:  StoredProcedure [dbo].[usp_LocationType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_LocationType                                                                                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Wednesday, 31 Oct 2018 09:18:58:060                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_LocationType](@Action_Type                    numeric(10),
                                  @p_Success                      bit             = 1    OUTPUT,
                                  @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                  @LocationTypeID                 bigint          = NULL OUTPUT, 
                                  @LocationTypeName               varchar(50)     = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO LocationType(LocationTypeName)
      VALUES                     (@LocationTypeName)

      SET       @LocationTypeID                = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    LocationType
      SET       LocationTypeName               = COALESCE(@LocationTypeName,LocationTypeName)
                
      WHERE     LocationTypeID                 = @LocationTypeID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    LocationType
      WHERE     LocationTypeID                 = @LocationTypeID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, LocationTypeID, LocationTypeName
      FROM      LocationType
      WHERE     LocationTypeID                                    = COALESCE(@LocationTypeID,LocationTypeID)
      AND       COALESCE(LocationTypeName,'X')                    = COALESCE(@LocationTypeName,COALESCE(LocationTypeName,'X'))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_LocationType-------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_MCBBranches]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_MCBBranches                                                                                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Thursday, 10 Oct 2019 12:02:19:673                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_MCBBranches](@Action_Type                    numeric(10),
                                 @p_Success                      bit             = 1    OUTPUT,
                                 @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                 @ID                             bigint          = NULL OUTPUT, 
                                 @BR_CODE                        varchar(10)     = NULL,
                                 @BranchName                     nvarchar(250)   = NULL,
                                 @ContactNo                      varchar(50)     = NULL,
                                 @EmailId                        varchar(50)     = NULL,
                                 @Active                         bit             = NULL,
                                 @CreatedBy                      bigint          = NULL,
                                 @CreatedDate                    datetime        = NULL,
                                 @ModifiedBy                     bigint          = NULL,
                                 @ModifiedDate                   datetime        = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO MCBBranches(BR_CODE,  BranchName,  ContactNo,  EmailId,  Active,  CreatedBy,  CreatedDate,  ModifiedBy,  ModifiedDate)
      VALUES                    (@BR_CODE, @BranchName, @ContactNo, @EmailId, @Active, @CreatedBy, @CreatedDate, @ModifiedBy, @ModifiedDate)

      SET       @ID                            = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    MCBBranches
      SET       BR_CODE                        = COALESCE(@BR_CODE,BR_CODE),
                BranchName                     = COALESCE(@BranchName,BranchName),
                ContactNo                      = COALESCE(@ContactNo,ContactNo),
                EmailId                        = COALESCE(@EmailId,EmailId),
                Active                         = COALESCE(@Active,Active),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate)
                
      WHERE     ID                             = @ID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    MCBBranches
      WHERE     ID                             = @ID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, ID, BR_CODE, BranchName, ContactNo, EmailId, Active, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
      FROM      MCBBranches
     order by BranchName 
    END
ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT    @Action_Type  AS ActionType, ID, BR_CODE, BranchName, ContactNo, EmailId, Active, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
      FROM      MCBBranches
	  WHERE
	  UPPER(BR_CODE) LIKE '%'+@BR_CODE+'%'
	  OR UPPER(BranchName) like '%'+@BranchName+'%'
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_MCBBranches--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------



GO
/****** Object:  StoredProcedure [dbo].[usp_Menu]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Menu                                                                                                                         ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Sunday, 20 Jan 2019 13:15:00:740                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Menu](@Action_Type                    numeric(10),
                          @p_Success                      bit             = 1    OUTPUT,
                          @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                          @MenuID                         bigint          = NULL OUTPUT, 
                          @MenuName                       nvarchar(50)    = NULL,
                          @Description                    nvarchar(50)    = NULL,
                          @Active                         bit             = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Menu(MenuName,  Description,  Active)
      VALUES             (@MenuName, @Description, @Active)

      SET       @MenuID                        = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Menu
      SET       MenuName                       = COALESCE(@MenuName,MenuName),
                Description                    = COALESCE(@Description,Description),
                Active                         = COALESCE(@Active,Active)
                
      WHERE     MenuID                         = @MenuID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Menu
      WHERE     MenuID                         = @MenuID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, MenuID, MenuName, Description, Active
      FROM      Menu
      WHERE     MenuID                                            = COALESCE(@MenuID,MenuID)
      AND       MenuName                                          = COALESCE(@MenuName,MenuName)
      AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
      AND       Active                                            = COALESCE(@Active,Active)
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Menu---------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_NavMenu]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_NavMenu                                                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Sunday, 20 Jan 2019 13:02:01:170                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_NavMenu](@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                             @FormID                         bigint          = NULL OUTPUT, 
                             @FormName                       nvarchar(100)    = NULL,
                             @Url                            nvarchar(200)    = NULL,
                             @Active                         bit             = NULL,
                             @icon                           nvarchar(150)   = NULL,
                             @CreatedBy                      bigint          = NULL,
                             @ModifiedBy                     bigint          = NULL,
                             @CreatedDate                    datetime        = NULL,
                             @ModifiedDate                   datetime        = NULL,
                             @MenuID                         bigint          = NULL,
                             @formTarget                     nvarchar(100)    = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO NavMenu(FormName,  Url,  Active,  icon,  CreatedBy,  ModifiedBy,  CreatedDate,  ModifiedDate,  MenuID,  formTarget)
      VALUES                (@FormName, @Url, @Active, @icon, @CreatedBy, @ModifiedBy, @CreatedDate, @ModifiedDate, @MenuID, @formTarget)

      SET       @FormID                        = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    NavMenu
      SET       FormName                       = COALESCE(@FormName,FormName),
                Url                            = COALESCE(@Url,Url),
                Active                         = COALESCE(@Active,Active),
                icon                           = COALESCE(@icon,icon),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                MenuID                         = COALESCE(@MenuID,MenuID),
                formTarget                     = COALESCE(@formTarget,formTarget)
                
      WHERE     FormID                         = @FormID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    NavMenu
      WHERE     FormID                         = @FormID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, MENU.MenuName,FormID, FormName, Url, NavMenu.Active, icon, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, NavMenu.MenuID, formTarget
	  
	  --SELECT * from MENU
   FROM      NavMenu
	  INNER JOIN MENU on NAVMENU.MENUID=MENU.MenuID
      WHERE     FormID                                            = COALESCE(@FormID,FormID)
      AND       FormName                                          = COALESCE(@FormName,FormName)
      AND       Url                                               = COALESCE(@Url,Url)
      AND       NavMenu.Active                                            = COALESCE(@Active,NavMenu.Active)
      AND       COALESCE(icon,'X')                                = COALESCE(@icon,COALESCE(icon,'X'))
      AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
      AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
      AND       NavMenu.MenuID                                            = COALESCE(@MenuID,NavMenu.MenuID)
      AND       COALESCE(formTarget,'X')                          = COALESCE(@formTarget,COALESCE(formTarget,'X'))
	  AND NavMenu.Active=1
	  ORDER BY MenuName
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1

	 
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_NavMenu------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_Order]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_InquiryAndOrders                                                                                                             ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Thursday, 27 Dec 2018 10:59:30:470                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Order](@Action_Type                    numeric(10),
                                      @p_Success                      bit             = 1    OUTPUT,
                                      @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                      @OrderID                       bigint          = NULL OUTPUT, 
                                      @OrderDate                      datetime        = NULL,
                                      @CustomerID                     bigint          = NULL,
                                      @IsForward                      bit             = NULL,
                                      @Department                     int             = NULL,
                                      @IsResponseBackToCustomer       bit             = NULL,
                                      @IsInquiryToOrder               bit             = NULL,
                                      @IsComplete                     bit             = NULL,
                                      @CreatedBy                      bigint          = NULL,
                                      @ModifiedBy                     bigint          = NULL,
                                      @CreatedDate                    datetime        = NULL,
                                      @ModifiedDate                   datetime        = NULL,
                                      @CompanyId                      int             = NULL,
                                      @GroupID                        int             = NULL,
                                      @DepartmentID                   int             = NULL,
                                      @ExistingCustomer               bit             = NULL,
                                      @CustomerGroupId                nchar(10)       = NULL,
                                      @CustomerGroupCode              nvarchar(50)    = NULL,
                                      @CustomerGroup                  nvarchar(150)   = NULL,
                                      @CustomerCompanyId              bigint          = NULL,
                                      @CustomerCompany                nvarchar(150)   = NULL,
                                      @CustomerCompanyCode            nvarchar(50)    = NULL,
                                      @CustomerDepartmentId           bigint          = NULL,
                                      @CustomerDepartment             nvarchar(150)   = NULL,
                                      @CustomerDepartmentCode         nvarchar(50)    = NULL,
                                      @CustomerPersonId               bigint          = NULL,
                                      @CustomerPerson                 nvarchar(150)   = NULL,
                                      @CustomerPersonCode             nvarchar(50)    = NULL,
                                      @CustomerContact                nvarchar(50)    = NULL,
                                      @ExistingRefference             bigint          = NULL,
                                      @RefferenceGroupId              bigint          = NULL,
                                      @RefferenceGroupCode            nvarchar(50)    = NULL,
                                      @RefferenceGroup                nvarchar(50)    = NULL,
                                      @RefferenceCompanyId            bigint          = NULL,
                                      @RefferenceCompany              nvarchar(50)    = NULL,
                                      @RefferenceCompanyCode          nvarchar(50)    = NULL,
                                      @RefferenceDepartmentId         bigint          = NULL,
                                      @RefferenceDepartment           nvarchar(50)    = NULL,
                                      @RefferenceDepartmentCode       nvarchar(50)    = NULL,
                                      @RefferencePersonId             bigint          = NULL,
                                      @RefferencePerson               nvarchar(50)    = NULL,
                                      @RefferencePersonCode           nvarchar(50)    = NULL,
                                      @RefferenceContact              nvarchar(50)    = NULL,
									  @ExistingReceiver               bigint          = NULL,
                                      @ReceiverGroupId                bigint          = NULL,
                                      @ReceiverGroupCode              nvarchar(50)    = NULL,
                                      @ReceiverGroup                  nvarchar(50)    = NULL,
                                      @ReceiverCompanyId              bigint          = NULL,
                                      @ReceiverCompany                nvarchar(50)    = NULL,
                                      @ReceiverCompanyCode            nvarchar(50)    = NULL,
                                      @ReceiverDepartmentId           bigint          = NULL,
                                      @ReceiverDepartment             nvarchar(50)    = NULL,
                                      @ReceiverDepartmentCode         nvarchar(50)    = NULL,
                                      @ReceiverPersonId               bigint          = NULL,
                                      @ReceiverPerson                 nvarchar(50)    = NULL,
                                      @ReceiverPersonCode             nvarchar(50)    = NULL,
                                      @ReceiverContact                nvarchar(50)    = NULL,
                                      @ExistingBillTo                 bigint          = NULL,
                                      @BillToGroupId                  bigint          = NULL,
                                      @BillToGroupCode                nvarchar(50)    = NULL,
                                      @BillToGroup                    nvarchar(50)    = NULL,
                                      @BillToCompanyId                bigint          = NULL,
                                      @BillToCompany                  nvarchar(50)    = NULL,
                                      @BillToCompanyCode              nvarchar(50)    = NULL,
                                      @BillToDepartmentId             bigint          = NULL,
                                      @BillToDepartment               nvarchar(50)    = NULL,
                                      @BillToDepartmentCode           nvarchar(50)    = NULL,
                                      @BillToPersonId                 bigint          = NULL,
                                      @BillToPerson                   nvarchar(50)    = NULL,
                                      @BillToPersonCode               nvarchar(50)    = NULL,
                                      @BillToContact                  nvarchar(50)    = NULL,
                                      @ChallanNo      nvarchar(50)             = NULL,
                                      @Status                         nvarchar(50)    = NULL,
                                      @OrderCompleted                 bit             = NULL,
                                      @Active                         bit             = NULL,
                                      @ChallanDate              datetime             = NULL,
                                      @OrderPlacment                  bit             =null,  
									  @ManualBiltyNo                  nvarchar(50)    = NULL,
                                      @ManualBiltyDate                datetime        = NULL,
									  @BiltyNo						nvarchar(15)=NULL,
									  @PartBilty						bit=0	)
AS
BEGIN
BEGIN TRANSACTION
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO [dbo].[Order](OrderDate,  CustomerID,  IsForward,  Department,  IsResponseBackToCustomer,  IsInquiryToOrder,  IsComplete,  CreatedBy,  ModifiedBy,  CreatedDate,  ModifiedDate,  CompanyId,  GroupID,  DepartmentID,  ExistingCustomer,  CustomerGroupId,  CustomerGroupCode,  CustomerGroup,  CustomerCompanyId,  CustomerCompany,  CustomerCompanyCode,  CustomerDepartmentId,  CustomerDepartment,  CustomerDepartmentCode,  CustomerPersonId,  CustomerPerson,  CustomerPersonCode,  CustomerContact,  ExistingRefference,  RefferenceGroupId,  RefferenceGroupCode,  RefferenceGroup,  RefferenceCompanyId,  RefferenceCompany,  RefferenceCompanyCode,  RefferenceDepartmentId,  RefferenceDepartment,  RefferenceDepartmentCode,  RefferencePersonId,  RefferencePerson,  RefferencePersonCode,  RefferenceContact,ExistingReceiver,  ReceiverGroupId,  ReceiverGroupCode,  ReceiverGroup,  ReceiverCompanyId,  ReceiverCompany,  ReceiverCompanyCode,  ReceiverDepartmentId,  ReceiverDepartment,  ReceiverDepartmentCode,  ReceiverPersonId,  ReceiverPerson,  ReceiverPersonCode,  ReceiverContact,  ExistingBillTo,  BillToGroupId,  BillToGroupCode,  BillToGroup,  BillToCompanyId,  BillToCompany,  BillToCompanyCode,  BillToDepartmentId,  BillToDepartment,  BillToDepartmentCode,  BillToPersonId,  BillToPerson,  BillToPersonCode,  BillToContact,  ChallanNo,  Status,  OrderCompleted,  Active,  ChallanDate,  OrderPlacment, ManualBiltyNo,  ManualBiltyDate,PartBilty)
      VALUES                         (@OrderDate, @CustomerID, @IsForward, @Department, @IsResponseBackToCustomer, @IsInquiryToOrder, @IsComplete, @CreatedBy, @ModifiedBy, @CreatedDate, @ModifiedDate, @CompanyId, @GroupID, @DepartmentID, @ExistingCustomer, @CustomerGroupId, @CustomerGroupCode, @CustomerGroup, @CustomerCompanyId, @CustomerCompany, @CustomerCompanyCode, @CustomerDepartmentId, @CustomerDepartment, @CustomerDepartmentCode, @CustomerPersonId, @CustomerPerson, @CustomerPersonCode, @CustomerContact, @ExistingRefference, @RefferenceGroupId, @RefferenceGroupCode, @RefferenceGroup, @RefferenceCompanyId, @RefferenceCompany, @RefferenceCompanyCode, @RefferenceDepartmentId, @RefferenceDepartment, @RefferenceDepartmentCode, @RefferencePersonId, @RefferencePerson, @RefferencePersonCode, @RefferenceContact, @ExistingReceiver, @ReceiverGroupId, @ReceiverGroupCode, @ReceiverGroup, @ReceiverCompanyId, @ReceiverCompany, @ReceiverCompanyCode, @ReceiverDepartmentId, @ReceiverDepartment, @ReceiverDepartmentCode, @ReceiverPersonId, @ReceiverPerson, @ReceiverPersonCode, @ReceiverContact, @ExistingBillTo, @BillToGroupId, @BillToGroupCode, @BillToGroup, @BillToCompanyId, @BillToCompany, @BillToCompanyCode, @BillToDepartmentId, @BillToDepartment, @BillToDepartmentCode, @BillToPersonId, @BillToPerson, @BillToPersonCode, @BillToContact, @ChallanNo, @Status, @OrderCompleted, @Active, @ChallanDate, @OrderPlacment,@ManualBiltyNo, @ManualBiltyDate,@PartBilty)

      SET       @OrderID                      = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    [dbo].[Order]
      SET       OrderDate                      = COALESCE(@OrderDate,OrderDate),
                CustomerID                     = COALESCE(@CustomerID,CustomerID),
                IsForward                      = COALESCE(@IsForward,IsForward),
                Department                     = COALESCE(@Department,Department),
                IsResponseBackToCustomer       = COALESCE(@IsResponseBackToCustomer,IsResponseBackToCustomer),
                IsInquiryToOrder               = COALESCE(@IsInquiryToOrder,IsInquiryToOrder),
                IsComplete                     = COALESCE(@IsComplete,IsComplete),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                CompanyId                      = COALESCE(@CompanyId,CompanyId),
                GroupID                        = COALESCE(@GroupID,GroupID),
                DepartmentID                   = COALESCE(@DepartmentID,DepartmentID),
                ExistingCustomer               = COALESCE(@ExistingCustomer,ExistingCustomer),
                CustomerGroupId                = COALESCE(@CustomerGroupId,CustomerGroupId),
                CustomerGroupCode              = COALESCE(@CustomerGroupCode,CustomerGroupCode),
                CustomerGroup                  = COALESCE(@CustomerGroup,CustomerGroup),
                CustomerCompanyId              = COALESCE(@CustomerCompanyId,CustomerCompanyId),
                CustomerCompany                = COALESCE(@CustomerCompany,CustomerCompany),
                CustomerCompanyCode            = COALESCE(@CustomerCompanyCode,CustomerCompanyCode),
                CustomerDepartmentId           = COALESCE(@CustomerDepartmentId,CustomerDepartmentId),
                CustomerDepartment             = COALESCE(@CustomerDepartment,CustomerDepartment),
                CustomerDepartmentCode         = COALESCE(@CustomerDepartmentCode,CustomerDepartmentCode),
                CustomerPersonId               = COALESCE(@CustomerPersonId,CustomerPersonId),
                CustomerPerson                 = COALESCE(@CustomerPerson,CustomerPerson),
                CustomerPersonCode             = COALESCE(@CustomerPersonCode,CustomerPersonCode),
                CustomerContact                = COALESCE(@CustomerContact,CustomerContact),
                ExistingRefference             = COALESCE(@ExistingRefference,ExistingRefference),
                RefferenceGroupId              = COALESCE(@RefferenceGroupId,RefferenceGroupId),
                RefferenceGroupCode            = COALESCE(@RefferenceGroupCode,RefferenceGroupCode),
                RefferenceGroup                = COALESCE(@RefferenceGroup,RefferenceGroup),
                RefferenceCompanyId            = COALESCE(@RefferenceCompanyId,RefferenceCompanyId),
                RefferenceCompany              = COALESCE(@RefferenceCompany,RefferenceCompany),
                RefferenceCompanyCode          = COALESCE(@RefferenceCompanyCode,RefferenceCompanyCode),
                RefferenceDepartmentId         = COALESCE(@RefferenceDepartmentId,RefferenceDepartmentId),
                RefferenceDepartment           = COALESCE(@RefferenceDepartment,RefferenceDepartment),
                RefferenceDepartmentCode       = COALESCE(@RefferenceDepartmentCode,RefferenceDepartmentCode),
                RefferencePersonId             = COALESCE(@RefferencePersonId,RefferencePersonId),
                RefferencePerson               = COALESCE(@RefferencePerson,RefferencePerson),
                RefferencePersonCode           = COALESCE(@RefferencePersonCode,RefferencePersonCode),
                RefferenceContact              = COALESCE(@RefferenceContact,RefferenceContact),
				 ExistingReceiver               = COALESCE(@ExistingReceiver,ExistingReceiver),
                ReceiverGroupId                = COALESCE(@ReceiverGroupId,ReceiverGroupId),
                ReceiverGroupCode              = COALESCE(@ReceiverGroupCode,ReceiverGroupCode),
                ReceiverGroup                  = COALESCE(@ReceiverGroup,ReceiverGroup),
                ReceiverCompanyId              = COALESCE(@ReceiverCompanyId,ReceiverCompanyId),
                ReceiverCompany                = COALESCE(@ReceiverCompany,ReceiverCompany),
                ReceiverCompanyCode            = COALESCE(@ReceiverCompanyCode,ReceiverCompanyCode),
                ReceiverDepartmentId           = COALESCE(@ReceiverDepartmentId,ReceiverDepartmentId),
                ReceiverDepartment             = COALESCE(@ReceiverDepartment,ReceiverDepartment),
                ReceiverDepartmentCode         = COALESCE(@ReceiverDepartmentCode,ReceiverDepartmentCode),
                ReceiverPersonId               = COALESCE(@ReceiverPersonId,ReceiverPersonId),
                ReceiverPerson                 = COALESCE(@ReceiverPerson,ReceiverPerson),
                ReceiverPersonCode             = COALESCE(@ReceiverPersonCode,ReceiverPersonCode),
                ReceiverContact                = COALESCE(@ReceiverContact,ReceiverContact),
                ExistingBillTo                 = COALESCE(@ExistingBillTo,ExistingBillTo),
                BillToGroupId                  = COALESCE(@BillToGroupId,BillToGroupId),
                BillToGroupCode                = COALESCE(@BillToGroupCode,BillToGroupCode),
                BillToGroup                    = COALESCE(@BillToGroup,BillToGroup),
                BillToCompanyId                = COALESCE(@BillToCompanyId,BillToCompanyId),
                BillToCompany                  = COALESCE(@BillToCompany,BillToCompany),
                BillToCompanyCode              = COALESCE(@BillToCompanyCode,BillToCompanyCode),
                BillToDepartmentId             = COALESCE(@BillToDepartmentId,BillToDepartmentId),
                BillToDepartment               = COALESCE(@BillToDepartment,BillToDepartment),
                BillToDepartmentCode           = COALESCE(@BillToDepartmentCode,BillToDepartmentCode),
                BillToPersonId                 = COALESCE(@BillToPersonId,BillToPersonId),
                BillToPerson                   = COALESCE(@BillToPerson,BillToPerson),
                BillToPersonCode               = COALESCE(@BillToPersonCode,BillToPersonCode),
                BillToContact                  = COALESCE(@BillToContact,BillToContact),
                @ChallanNo      = COALESCE(@ChallanNo,ChallanNo),
                Status                         = COALESCE(@Status,Status),
                OrderCompleted                 = COALESCE(@OrderCompleted,OrderCompleted),
                Active                         = COALESCE(@Active,Active),
                @ChallanDate              = COALESCE(@ChallanDate,ChallanDate),
                OrderPlacment                  = COALESCE(@OrderPlacment,OrderPlacment),
				ManualBiltyNo                  = COALESCE(@ManualBiltyNo,ManualBiltyNo),
                ManualBiltyDate                = COALESCE(@ManualBiltyDate,ManualBiltyDate),
				PartBilty                = COALESCE(@PartBilty,PartBilty)
                
      WHERE     OrderID                       = @OrderID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    [dbo].[Order]
      WHERE     OrderID                       = @OrderID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      --SELECT    @Action_Type  AS ActionType, OrderID, OrderDate, CustomerID, IsForward, Department, IsResponseBackToCustomer, IsInquiryToOrder, IsComplete, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, CompanyId, GroupID, DepartmentID, ExistingCustomer, CustomerGroupId, CustomerGroupCode, CustomerGroup, CustomerCompanyId, CustomerCompany, CustomerCompanyCode, CustomerDepartmentId, CustomerDepartment, CustomerDepartmentCode, CustomerPersonId, CustomerPerson, CustomerPersonCode, CustomerContact, ExistingRefference, RefferenceGroupId, RefferenceGroupCode, RefferenceGroup, RefferenceCompanyId, RefferenceCompany, RefferenceCompanyCode, RefferenceDepartmentId, RefferenceDepartment, RefferenceDepartmentCode, RefferencePersonId, RefferencePerson, RefferencePersonCode, RefferenceContact, ReceiverGroupId, ReceiverGroupCode, ReceiverGroup, ReceiverCompanyId, ReceiverCompany, ReceiverCompanyCode, ReceiverDepartmentId, ReceiverDepartment, ReceiverDepartmentCode, ReceiverPersonId, ReceiverPerson, ReceiverPersonCode, ReceiverContact, ExistingBillTo, BillToGroupId, BillToGroupCode, BillToGroup, BillToCompanyId, BillToCompany, BillToCompanyCode, BillToDepartmentId, BillToDepartment, BillToDepartmentCode, BillToPersonId, BillToPerson, BillToPersonCode, BillToContact,  ChallanNo, Status, OrderCompleted, Active, ChallanDate, OrderPlacment,BiltyNo,ManualBiltyNo, ManualBiltyDate,PartBilty
      --FROM      [dbo].[Order]
      --WHERE     OrderID                                          = COALESCE(@OrderID,OrderID)
	    SELECT    @Action_Type  AS ActionType, OrderID, OrderDate, [dbo].[Order].CustomerID, IsForward, Department, IsResponseBackToCustomer, IsInquiryToOrder, IsComplete, [dbo].[Order].CreatedBy, [dbo].[Order].ModifiedBy, 
	  [dbo].[Order].CreatedDate, [dbo].[Order].ModifiedDate, CompanyId, GroupID, DepartmentID, ExistingCustomer, CustomerGroupId, CustomerGroupCode, CustomerGroup, CustomerCompanyId,
	   CASE
	   When CP.isHide  = 1 Then ''		
		ELSE   CustomerCompany
		END	AS   CustomerCompany, 
		CustomerCompanyCode, CustomerDepartmentId, CustomerDepartment, CustomerDepartmentCode, CustomerPersonId, CustomerPerson,
	    CustomerPersonCode, CustomerContact, ExistingRefference, RefferenceGroupId, RefferenceGroupCode, RefferenceGroup, RefferenceCompanyId, 
		RefferenceCompany, RefferenceCompanyCode, RefferenceDepartmentId, RefferenceDepartment, RefferenceDepartmentCode, RefferencePersonId,
		 RefferencePerson, RefferencePersonCode, RefferenceContact, ReceiverGroupId, ReceiverGroupCode, ReceiverGroup, ReceiverCompanyId, 
		 ReceiverCompany, ReceiverCompanyCode, ReceiverDepartmentId, ReceiverDepartment, ReceiverDepartmentCode, ReceiverPersonId, 
		 ReceiverPerson, ReceiverPersonCode, ReceiverContact, ExistingBillTo, BillToGroupId, BillToGroupCode, BillToGroup, BillToCompanyId,
		  BillToCompany, BillToCompanyCode, BillToDepartmentId, BillToDepartment, BillToDepartmentCode, BillToPersonId, BillToPerson, 
		  BillToPersonCode, BillToContact,  ChallanNo, Status, OrderCompleted, Active, ChallanDate, OrderPlacment,BiltyNo,ManualBiltyNo,
		   ManualBiltyDate,PartBilty
      FROM      [dbo].[Order]
	  INNER join CustomerProfile CP on [dbo].[Order].customercompanyid=cp.CustomerId
	  WHERE     OrderID                                          = COALESCE(@OrderID,OrderID)
  AND       COALESCE(IsForward,0)                             = COALESCE(@IsForward,COALESCE(IsForward,0))

 AND       COALESCE(CompanyId,0)                             = COALESCE(@CompanyId,COALESCE(CompanyId,0))
      --AND       OrderDate                                         = COALESCE(@OrderDate,OrderDate)
      --AND       CustomerID                                        = COALESCE(@CustomerID,CustomerID)
      AND       COALESCE(IsForward,0)                             = COALESCE(@IsForward,COALESCE(IsForward,0))
      --AND       COALESCE(Department,0)                            = COALESCE(@Department,COALESCE(Department,0))
      AND       COALESCE(IsResponseBackToCustomer,0)              = COALESCE(@IsResponseBackToCustomer,COALESCE(IsResponseBackToCustomer,0))
      AND       COALESCE(IsInquiryToOrder,0)                      = COALESCE(@IsInquiryToOrder,COALESCE(IsInquiryToOrder,0))
      --AND       COALESCE(IsComplete,0)                            = COALESCE(@IsComplete,COALESCE(IsComplete,0))
      --AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
      AND       COALESCE(CompanyId,0)                             = COALESCE(@CompanyId,COALESCE(CompanyId,0))
      AND       COALESCE(GroupID,0)                               = COALESCE(@GroupID,COALESCE(GroupID,0))
      AND       COALESCE(DepartmentID,0)                          = COALESCE(@DepartmentID,COALESCE(DepartmentID,0))
      --AND       COALESCE(ExistingCustomer,0)                      = COALESCE(@ExistingCustomer,COALESCE(ExistingCustomer,0))
      --AND       CustomerGroupId                                   = COALESCE(@CustomerGroupId,CustomerGroupId)
      --AND       COALESCE(CustomerGroupCode,'X')                   = COALESCE(@CustomerGroupCode,COALESCE(CustomerGroupCode,'X'))
      --AND       COALESCE(CustomerGroup,'X')                       = COALESCE(@CustomerGroup,COALESCE(CustomerGroup,'X'))
      --AND       COALESCE(CustomerCompanyId,0)                     = COALESCE(@CustomerCompanyId,COALESCE(CustomerCompanyId,0))
      --AND       COALESCE(CustomerCompany,'X')                     = COALESCE(@CustomerCompany,COALESCE(CustomerCompany,'X'))
      --AND       COALESCE(CustomerCompanyCode,'X')                 = COALESCE(@CustomerCompanyCode,COALESCE(CustomerCompanyCode,'X'))
      --AND       COALESCE(CustomerDepartmentId,0)                  = COALESCE(@CustomerDepartmentId,COALESCE(CustomerDepartmentId,0))
      --AND       COALESCE(CustomerDepartment,'X')                  = COALESCE(@CustomerDepartment,COALESCE(CustomerDepartment,'X'))
      --AND       COALESCE(CustomerDepartmentCode,'X')              = COALESCE(@CustomerDepartmentCode,COALESCE(CustomerDepartmentCode,'X'))
      --AND       COALESCE(CustomerPersonId,0)                      = COALESCE(@CustomerPersonId,COALESCE(CustomerPersonId,0))
      --AND       COALESCE(CustomerPerson,'X')                      = COALESCE(@CustomerPerson,COALESCE(CustomerPerson,'X'))
      --AND       COALESCE(CustomerPersonCode,'X')                  = COALESCE(@CustomerPersonCode,COALESCE(CustomerPersonCode,'X'))
      --AND       COALESCE(CustomerContact,'X')                     = COALESCE(@CustomerContact,COALESCE(CustomerContact,'X'))
      --AND       COALESCE(ExistingRefference,0)                    = COALESCE(@ExistingRefference,COALESCE(ExistingRefference,0))
      --AND       COALESCE(RefferenceGroupId,0)                     = COALESCE(@RefferenceGroupId,COALESCE(RefferenceGroupId,0))
      --AND       COALESCE(RefferenceGroupCode,'X')                 = COALESCE(@RefferenceGroupCode,COALESCE(RefferenceGroupCode,'X'))
      --AND       COALESCE(RefferenceGroup,'X')                     = COALESCE(@RefferenceGroup,COALESCE(RefferenceGroup,'X'))
      --AND       COALESCE(RefferenceCompanyId,0)                   = COALESCE(@RefferenceCompanyId,COALESCE(RefferenceCompanyId,0))
      --AND       COALESCE(RefferenceCompany,'X')                   = COALESCE(@RefferenceCompany,COALESCE(RefferenceCompany,'X'))
      --AND       COALESCE(RefferenceCompanyCode,'X')               = COALESCE(@RefferenceCompanyCode,COALESCE(RefferenceCompanyCode,'X'))
      --AND       COALESCE(RefferenceDepartmentId,0)                = COALESCE(@RefferenceDepartmentId,COALESCE(RefferenceDepartmentId,0))
      --AND       COALESCE(RefferenceDepartment,'X')                = COALESCE(@RefferenceDepartment,COALESCE(RefferenceDepartment,'X'))
      --AND       COALESCE(RefferenceDepartmentCode,'X')            = COALESCE(@RefferenceDepartmentCode,COALESCE(RefferenceDepartmentCode,'X'))
      --AND       COALESCE(RefferencePersonId,0)                    = COALESCE(@RefferencePersonId,COALESCE(RefferencePersonId,0))
      --AND       COALESCE(RefferencePerson,'X')                    = COALESCE(@RefferencePerson,COALESCE(RefferencePerson,'X'))
      --AND       COALESCE(RefferencePersonCode,'X')                = COALESCE(@RefferencePersonCode,COALESCE(RefferencePersonCode,'X'))
      --AND       COALESCE(RefferenceContact,'X')                   = COALESCE(@RefferenceContact,COALESCE(RefferenceContact,'X'))
      --AND       COALESCE(IsCommunicatewithCustomer,0)             = COALESCE(@IsCommunicatewithCustomer,COALESCE(IsCommunicatewithCustomer,0))
      --AND       COALESCE(Status,'X')                              = COALESCE(@Status,COALESCE(Status,'X'))
      --AND       COALESCE(OrderCompleted,0)                        = COALESCE(@OrderCompleted,COALESCE(OrderCompleted,0))
      AND       COALESCE(Active,0)                                = COALESCE(@Active,COALESCE(Active,0))
      --AND       COALESCE(AssessmentReponse,0)                     = COALESCE(@AssessmentReponse,COALESCE(AssessmentReponse,0))
      --AND       OrderPlacment                                     = COALESCE(@OrderPlacment,OrderPlacment)
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    BEGIN
	   SELECT    @Action_Type  AS ActionType, OrderID, OrderDate, CustomerID, IsForward, Department, IsResponseBackToCustomer, IsInquiryToOrder, IsComplete, CreatedBy, ModifiedBy, CreatedDate, ModifiedDate, CompanyId, GroupID, DepartmentID, ExistingCustomer, CustomerGroupId, CustomerGroupCode, CustomerGroup, CustomerCompanyId, CustomerCompany, CustomerCompanyCode, CustomerDepartmentId, CustomerDepartment, CustomerDepartmentCode, CustomerPersonId, CustomerPerson, CustomerPersonCode, CustomerContact, ExistingRefference, RefferenceGroupId, RefferenceGroupCode, RefferenceGroup, RefferenceCompanyId, RefferenceCompany, RefferenceCompanyCode, RefferenceDepartmentId, RefferenceDepartment, RefferenceDepartmentCode, RefferencePersonId, RefferencePerson, RefferencePersonCode, RefferenceContact, ChallanNo, Status, OrderCompleted, Active, ChallanDate, OrderPlacment,BiltyNo,ReceiverGroupId, ReceiverGroupCode, ReceiverGroup, ReceiverCompanyId, ReceiverCompany, ReceiverCompanyCode, ReceiverDepartmentId, ReceiverDepartment, ReceiverDepartmentCode, ReceiverPersonId, ReceiverPerson, ReceiverPersonCode, ReceiverContact, ExistingBillTo, BillToGroupId, BillToGroupCode, BillToGroup, BillToCompanyId, BillToCompany, BillToCompanyCode, BillToDepartmentId, BillToDepartment, BillToDepartmentCode, BillToPersonId, BillToPerson, BillToPersonCode, BillToContact
      FROM      [dbo].[Order]
	   WHERE     
	           COALESCE(CompanyId,0)                             = COALESCE(@CompanyId,COALESCE(CompanyId,0))
      AND       COALESCE(GroupID,0)                               = COALESCE(@GroupID,COALESCE(GroupID,0))
      AND       COALESCE(DepartmentID,0)                          = COALESCE(@DepartmentID,COALESCE(DepartmentID,0))                                    
	  END
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
  COMMIT
END
------------------------------------------End of Procedure: usp_InquiryAndOrders---------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------





GO
/****** Object:  StoredProcedure [dbo].[usp_OrderDetail]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_OrderDetail                                                                                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Wednesday, 27 Mar 2019 12:21:35:543                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_OrderDetail](@Action_Type                    numeric(10),
                                 @p_Success                      bit             = 1    OUTPUT,
                                 @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                 @OrderDetailId                  bigint          = NULL OUTPUT, 
                                 @OrderID                        bigint          = NULL,
                                 @BiltyNo                        nvarchar(50)    = NULL,
                                 @BiltyNoDate                    datetime        = NULL,
                                 @ManualBiltyNo                  nvarchar(50)    = NULL,
                                 @ManualBiltyDate                datetime        = NULL,
                                 @CustomerCode                   nvarchar(50)    = NULL,
                                 @PaymentType                    nvarchar(50)    = NULL,
                                 @ShipmentTypeId                 int             = NULL,
                                 @VehicleTypeId                  int             = NULL,
                                 @BrokerId                       int             = NULL,
                                 @BrokerName                     nvarchar(100)   = NULL,
                                 @BrokerContactNo                nvarchar(50)    = NULL,
                                 @AdditionalWeight               float(53)       = NULL,
                                 @NetWeight                      float(53)       = NULL,
                                 @TotalExpenses                  float(53)       = NULL,
                                 @FreightTypeId                  int             = NULL,
                                 @FreightTypeQty                 int             = NULL,
                                 @Freight                        float          = NULL,
                                 @ParentId                       bigint          = NULL,
                                 @CreatedDate                    datetime        = NULL,
                                 @CreatedBy                      bigint          = NULL,
                                 @ModifiedDate                   datetime        = NULL,
                                 @ModifiedBy                     bigint          = NULL,
								 @LocalFreight					 bigint			 = NULL,
								 @DA_NO					 nvarchar(50)			 = NULL,
								 @Remarks				 nvarchar(250)           =NULL,
								 @ChallanNo				 nvarchar(10)=null,
								 @ChallanDate			 datetime=null,@AdditionalFreight float=null,
								 @StatusID bigint = null)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO OrderDetail(OrderID,  BiltyNo,  BiltyNoDate,  ManualBiltyNo,  ManualBiltyDate,  CustomerCode,  PaymentType,  ShipmentTypeId,  VehicleTypeId,  BrokerId,  BrokerName,  BrokerContactNo,  AdditionalWeight,  NetWeight,  TotalExpenses,  FreightTypeId,  FreightTypeQty,  Freight,  ParentId,  CreatedDate,  CreatedBy,  ModifiedDate,  ModifiedBy,LocalFreight,DA_NO,Remarks,ChallanNo,ChallanDate,AdditionalFreight,StatusID)
      VALUES                    (@OrderID,dbo.ManualBiltyGenerator(@CustomerCode) , @BiltyNoDate, @ManualBiltyNo, @ManualBiltyDate, @CustomerCode, @PaymentType, @ShipmentTypeId, @VehicleTypeId, @BrokerId, @BrokerName, @BrokerContactNo, @AdditionalWeight, @NetWeight, @TotalExpenses, @FreightTypeId, @FreightTypeQty, @Freight, @ParentId, @CreatedDate, @CreatedBy, @ModifiedDate, @ModifiedBy,@LocalFreight,@DA_NO,@Remarks,@ChallanNo,@ChallanDate,@AdditionalFreight,@StatusID)

      SET       @OrderDetailId                 = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    OrderDetail
      SET       OrderID                        = COALESCE(@OrderID,OrderID),
                BiltyNo                        = COALESCE(@BiltyNo,BiltyNo),
                BiltyNoDate                    = COALESCE(@BiltyNoDate,BiltyNoDate),
                ManualBiltyNo                  = COALESCE(@ManualBiltyNo,ManualBiltyNo),
                ManualBiltyDate                = COALESCE(@ManualBiltyDate,ManualBiltyDate),
                CustomerCode                   = COALESCE(@CustomerCode,CustomerCode),
                PaymentType                    = COALESCE(@PaymentType,PaymentType),
                ShipmentTypeId                 = COALESCE(@ShipmentTypeId,ShipmentTypeId),
                VehicleTypeId                  = COALESCE(@VehicleTypeId,VehicleTypeId),
                BrokerId                       = COALESCE(@BrokerId,BrokerId),
                BrokerName                     = COALESCE(@BrokerName,BrokerName),
                BrokerContactNo                = COALESCE(@BrokerContactNo,BrokerContactNo),
                AdditionalWeight               = COALESCE(@AdditionalWeight,AdditionalWeight),
                NetWeight                      = COALESCE(@NetWeight,NetWeight),
                TotalExpenses                  = COALESCE(@TotalExpenses,TotalExpenses),
                FreightTypeId                  = COALESCE(@FreightTypeId,FreightTypeId),
                FreightTypeQty                 = COALESCE(@FreightTypeQty,FreightTypeQty),
                Freight                        = COALESCE(@Freight,Freight),
                ParentId                       = COALESCE(@ParentId,ParentId),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
				localFreight                     = COALESCE(@LocalFreight,localFreight),
				DA_NO						   = COALESCE(@DA_NO,DA_NO),
				Remarks						   =COALESCE(@Remarks,Remarks),
				AdditionalFreight						   =COALESCE(@AdditionalFreight,AdditionalFreight),
				StatusID						   =COALESCE(@StatusID,StatusID)
				
                
      WHERE     OrderDetailId                  = @OrderDetailId
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    OrderDetail
      WHERE     OrderDetailId                  = @OrderDetailId
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT distinct   @Action_Type  AS ActionType,ST.ShipmentType,FT.FreightTypeName,VT.VehicleTypeName, OrderDetailId, OrderDetail.OrderID, OrderDetail.BiltyNo, BiltyNoDate, OrderDetail.ManualBiltyNo, OrderDetail.ManualBiltyDate, OrderDetail.CustomerCode, ISNULL(CP.PaymentTerm,PaymentType) PaymentType , ShipmentTypeId, OrderDetail.VehicleTypeId, BrokerId, BrokerName, BrokerContactNo, AdditionalWeight, NetWeight, TotalExpenses, OrderDetail.FreightTypeId, FreightTypeQty, Freight, ParentId, OrderDetail.CreatedDate, OrderDetail.CreatedBy, OrderDetail.ModifiedDate, OrderDetail.ModifiedBy,LocalFreight,DA_No,ISNULL(Remarks,'') Remarks,OrderDetail.ChallanDate,OrderDetail.ChallanNo,AdditionalFreight,StatusID
      FROM      OrderDetail
	  INNER JOIN [order] O on [OrderDetail].orderid= O.orderid 
	    LEFT JOIN ShipmentType ST ON OrderDetail.ShipmentTypeId=ST.SHIPMENTTYPE_ID
		LEFT JOIN FreightType FT ON OrderDetail.FreightTypeId=FT.FreightTypeID
		LEFT JOIN VehicleType VT ON OrderDetail.VehicleTypeId=VT.VehicleTypeID
		LEFT join CustomerProfile CP on O.customercompanyid=cp.CustomerId
		
		
      WHERE     OrderDetailId                                     = ISNULL(@OrderDetailId,'0')
      AND       OrderDetail.OrderID                                           = COALESCE(@OrderID,OrderDetail.OrderID)
	  AND PaymentTerm is not null
      --AND       COALESCE(BiltyNo,'X')                             = COALESCE(@BiltyNo,COALESCE(BiltyNo,'X'))
      --AND       COALESCE(BiltyNoDate,GETDATE())                   = COALESCE(@BiltyNoDate,COALESCE(BiltyNoDate,GETDATE()))
      --AND       COALESCE(ManualBiltyNo,'X')                       = COALESCE(@ManualBiltyNo,COALESCE(ManualBiltyNo,'X'))
      --AND       COALESCE(ManualBiltyDate,GETDATE())               = COALESCE(@ManualBiltyDate,COALESCE(ManualBiltyDate,GETDATE()))
      --AND       COALESCE(CustomerCode,'X')                        = COALESCE(@CustomerCode,COALESCE(CustomerCode,'X'))
      --AND       COALESCE(PaymentType,'X')                         = COALESCE(@PaymentType,COALESCE(PaymentType,'X'))
      --AND       ShipmentTypeId                                    = COALESCE(@ShipmentTypeId,ShipmentTypeId)
      --AND       COALESCE(VehicleTypeId,0)                         = COALESCE(@VehicleTypeId,COALESCE(VehicleTypeId,0))
      --AND       COALESCE(BrokerId,0)                              = COALESCE(@BrokerId,COALESCE(BrokerId,0))
      --AND       COALESCE(BrokerName,'X')                          = COALESCE(@BrokerName,COALESCE(BrokerName,'X'))
      --AND       COALESCE(BrokerContactNo,'X')                     = COALESCE(@BrokerContactNo,COALESCE(BrokerContactNo,'X'))
      --AND       AdditionalWeight                                  = COALESCE(@AdditionalWeight,AdditionalWeight)
      --AND       NetWeight                                         = COALESCE(@NetWeight,NetWeight)
      --AND       TotalExpenses                                     = COALESCE(@TotalExpenses,TotalExpenses)
      --AND       COALESCE(FreightTypeId,0)                         = COALESCE(@FreightTypeId,COALESCE(FreightTypeId,0))
      --AND       COALESCE(FreightTypeQty,0)                        = COALESCE(@FreightTypeQty,COALESCE(FreightTypeQty,0))
      --AND       COALESCE(Freight,0)                               = COALESCE(@Freight,COALESCE(Freight,0))
      --AND       COALESCE(ParentId,0)                              = COALESCE(@ParentId,COALESCE(ParentId,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_OrderDetail--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------





GO
/****** Object:  StoredProcedure [dbo].[usp_OrderDetailItem]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_OrderDetailItem                                                                                                              ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Monday, 18 Feb 2019 22:38:35:463                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_OrderDetailItem](@Action_Type                    numeric(10),
                                     @p_Success                      bit             = 1    OUTPUT,
                                     @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                     @OrderDetailItemID              bigint          = NULL OUTPUT, 
                                     @OrderDetailID                  bigint          = NULL,
                                     @ItemId                         bigint          = NULL,
                                     @ItemQty                        int             = NULL,
                                     @Weight                         float(53)       = NULL,
                                     @Unit                           nvarchar(50)    = NULL,
                                     @CreatedBy                      bigint          = NULL,
                                     @CreadtedDate                   datetime        = NULL,
                                     @ModifiedBy                     bigint          = NULL,
                                     @ModifiedDate                   datetime        = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO OrderDetailItem(OrderDetailID,  ItemId,  ItemQty,  Weight,  Unit,  CreatedBy,  CreadtedDate,  ModifiedBy,  ModifiedDate)
      VALUES                        (@OrderDetailID, @ItemId, @ItemQty, @Weight, @Unit, @CreatedBy, @CreadtedDate, @ModifiedBy, @ModifiedDate)

      SET       @OrderDetailItemID             = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    OrderDetailItem
      SET       OrderDetailID                  = COALESCE(@OrderDetailID,OrderDetailID),
                ItemId                         = COALESCE(@ItemId,ItemId),
                ItemQty                        = COALESCE(@ItemQty,ItemQty),
                Weight                         = COALESCE(@Weight,Weight),
                Unit                           = COALESCE(@Unit,Unit),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                CreadtedDate                   = COALESCE(@CreadtedDate,CreadtedDate),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate)
                
      WHERE     OrderDetailItemID              = @OrderDetailItemID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    OrderDetailItem
      WHERE     OrderDetailItemID              = @OrderDetailItemID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, OrderDetailItemID, OrderDetailID, OrderDetailItem.ItemId,I.ItemCode,I.ItemName, ItemQty, OrderDetailItem.Weight, Unit, CreatedBy, CreadtedDate, ModifiedBy, ModifiedDate
      FROM      OrderDetailItem
	  INNER JOIN Item AS I on  OrderDetailItem.ItemId=I.ItemID
      WHERE     OrderDetailItemID                                 = COALESCE(@OrderDetailItemID,OrderDetailItemID)
      AND       COALESCE(OrderDetailID,0)                         = COALESCE(@OrderDetailID,COALESCE(OrderDetailID,0))
      AND       COALESCE(OrderDetailItem.ItemId,0)                                = COALESCE(@ItemId,COALESCE(OrderDetailItem.ItemId,0))
      AND       COALESCE(ItemQty,0)                               = COALESCE(@ItemQty,COALESCE(ItemQty,0))
      AND       OrderDetailItem.Weight                                            = COALESCE(@Weight,OrderDetailItem.Weight)
      AND       COALESCE(Unit,'X')                                = COALESCE(@Unit,COALESCE(Unit,'X'))
      AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      AND       COALESCE(CreadtedDate,GETDATE())                  = COALESCE(@CreadtedDate,COALESCE(CreadtedDate,GETDATE()))
      AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
      AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_OrderDetailItem----------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_OrderDocument]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_OrderDocument                                                                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Monday, 25 Mar 2019 12:02:25:537                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_OrderDocument](@Action_Type                    numeric(10),
                                   @p_Success                      bit             = 1    OUTPUT,
                                   @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                   @OrderDocumentId                bigint          = NULL OUTPUT, 
                                   @OrderDetailId                  bigint          = NULL,
                                   @DocumentTypeId                 bigint          = NULL,
                                   @DocumentNo                     nvarchar(150)   = NULL,
                                   @Attachment                     nvarchar(250)   = NULL,
                                   @CreatedBy                      bigint          = NULL,
                                   @CreatedDate                    datetime        = NULL,
                                   @ModifiedDate                   datetime        = NULL,
                                   @ModifiedBy                     bigint          = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO OrderDocument(OrderDetailId,  DocumentTypeId,  DocumentNo,  Attachment,  CreatedBy,  CreatedDate,  ModifiedDate,  ModifiedBy)
      VALUES                      (@OrderDetailId, @DocumentTypeId, @DocumentNo, @Attachment, @CreatedBy, @CreatedDate, @ModifiedDate, @ModifiedBy)

      SET       @OrderDocumentId               = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    OrderDocument
      SET       OrderDetailId                  = COALESCE(@OrderDetailId,OrderDetailId),
                DocumentTypeId                 = COALESCE(@DocumentTypeId,DocumentTypeId),
                DocumentNo                     = COALESCE(@DocumentNo,DocumentNo),
                Attachment                     = COALESCE(@Attachment,Attachment),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy)
                
      WHERE     OrderDocumentId                = @OrderDocumentId
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    OrderDocument
      WHERE     OrderDocumentId                = @OrderDocumentId
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, OrderDocumentId, OrderDetailId, OD.DocumentTypeId, DocumentNo,DT.Name, Attachment, CreatedBy, CreatedDate, ModifiedDate, ModifiedBy
      FROM      OrderDocument OD
	  INNER JOIN DocumentType DT on OD.DocumentTypeId=DT.DocumentTypeID
      WHERE     OrderDocumentId                                   = COALESCE(@OrderDocumentId,OrderDocumentId)
      AND       OrderDetailId                                     = COALESCE(@OrderDetailId,OrderDetailId)
      --AND       COALESCE(DocumentTypeId,0)                        = COALESCE(@DocumentTypeId,COALESCE(DocumentTypeId,0))
      --AND       COALESCE(DocumentNo,'X')                          = COALESCE(@DocumentNo,COALESCE(DocumentNo,'X'))
      --AND       COALESCE(Attachment,'X')                          = COALESCE(@Attachment,COALESCE(Attachment,'X'))
      --AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_OrderDocument------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_OrderExpenses]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_OrderExpenses                                                                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Monday, 25 Mar 2019 12:10:43:610                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_OrderExpenses](@Action_Type                    numeric(10),
                                   @p_Success                      bit             = 1    OUTPUT,
                                   @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                   @OrderExpenseId                 bigint          = NULL OUTPUT, 
                                   @OrderDetailId                  bigint          = NULL,
                                   @ExpenseTypeId                  bigint          = NULL,
                                   @Amount                         float(53)       = NULL,
                                   @CreatedBy                      bigint          = NULL,
                                   @CreatedDate                    datetime        = NULL,
                                   @ModifiedDate                   datetime        = NULL,
                                   @ModifiedBy                     bigint          = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO OrderExpenses(OrderDetailId,  ExpenseTypeId,  Amount,  CreatedBy,  CreatedDate,  ModifiedDate,  ModifiedBy)
      VALUES                      (@OrderDetailId, @ExpenseTypeId, @Amount, @CreatedBy, @CreatedDate, @ModifiedDate, @ModifiedBy)

      SET       @OrderExpenseId                = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    OrderExpenses
      SET       OrderDetailId                  = COALESCE(@OrderDetailId,OrderDetailId),
                ExpenseTypeId                  = COALESCE(@ExpenseTypeId,ExpenseTypeId),
                Amount                         = COALESCE(@Amount,Amount),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy)
                
      WHERE     OrderExpenseId                 = @OrderExpenseId
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    OrderExpenses
      WHERE     OrderExpenseId                 = @OrderExpenseId
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, OrderExpenseId, OrderDetailId, OrderExpenses.ExpenseTypeId,ExpensesType.ExpensesTypeName, Amount, CreatedBy, CreatedDate, ModifiedDate, ModifiedBy
      FROM      OrderExpenses
	  INNER JOIN ExpensesType on OrderExpenses.ExpenseTypeId=ExpensesType.ExpensesTypeID
      WHERE     OrderExpenseId                                    = COALESCE(@OrderExpenseId,OrderExpenseId)
      AND       OrderDetailId                                     = COALESCE(@OrderDetailId,OrderDetailId)
      --AND       ExpenseTypeId                                     = COALESCE(@ExpenseTypeId,ExpenseTypeId)
      --AND       Amount                                            = COALESCE(@Amount,Amount)
      --AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_OrderExpenses------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_OrderLocations]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_OrderLocations                                                                                                               ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Saturday, 06 Apr 2019 11:39:07:500                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_OrderLocations](@Action_Type                    numeric(10),
                                    @p_Success                      bit             = 1    OUTPUT,
                                    @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                    @LocationId                     bigint          = NULL OUTPUT, 
                                    @OrderDetailId                  bigint          = NULL,
                                    @PickupLocationId               bigint          = NULL,
                                    @PickupLocationAddress          nvarchar(250)   = NULL,
                                    @DropLocationId                 bigint          = NULL,
                                    @DropLocationAddress            nvarchar(250)   = NULL,
                                    @CreatedBy                      bigint          = NULL,
                                    @CreatedDate                    datetime        = NULL,
                                    @ModifiedBy                     bigint          = NULL,
                                    @ModifiedDate                   datetime        = NULL,
                                    @StationFrom                    bigint          = NULL,
                                    @StationTo                      bigint          = NULL,
                                    @DeliveryType                   nvarchar(50)    = NULL,
									@ReceiverName                   nvarchar(150)    = NULL,
									@ReceiverAddress                   nvarchar(250)    = NULL,
									@ReceiverContact                   varchar(50)    = NULL
									)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO OrderLocations(OrderDetailId,  PickupLocationId,  PickupLocationAddress,  DropLocationId,  DropLocationAddress,  CreatedBy,  CreatedDate,  ModifiedBy,  ModifiedDate,  StationFrom,  StationTo,  DeliveryType,ReceiverName,ReceiverAddress,ReceiverContact)
      VALUES                       (@OrderDetailId, @PickupLocationId, @PickupLocationAddress, @DropLocationId, @DropLocationAddress, @CreatedBy, @CreatedDate, @ModifiedBy, @ModifiedDate, @StationFrom, @StationTo, @DeliveryType,@ReceiverName,@ReceiverAddress,@ReceiverContact)

      SET       @LocationId                    = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    OrderLocations
      SET       OrderDetailId                  = COALESCE(@OrderDetailId,OrderDetailId),
                PickupLocationId               = COALESCE(@PickupLocationId,PickupLocationId),
                PickupLocationAddress          = COALESCE(@PickupLocationAddress,PickupLocationAddress),
                DropLocationId                 = COALESCE(@DropLocationId,DropLocationId),
                DropLocationAddress            = COALESCE(@DropLocationAddress,DropLocationAddress),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                StationFrom                    = COALESCE(@StationFrom,StationFrom),
                StationTo                      = COALESCE(@StationTo,StationTo),
                DeliveryType                   = COALESCE(@DeliveryType,DeliveryType),
				ReceiverName	                  = COALESCE(@ReceiverName,ReceiverName),
				ReceiverAddress                   = COALESCE(@ReceiverAddress,ReceiverAddress),
				ReceiverContact                   = COALESCE(@ReceiverContact,ReceiverContact)
                
      WHERE     LocationId                     = @LocationId
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    OrderLocations
      WHERE     LocationId                     = @LocationId
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
     SELECT    @Action_Type  AS ActionType, OL.*,PC.CityName AS PickupLocation,DC.CityName as DropLocation,S1.Name AS 'StationPick',ISNULL(S2.Name,OL.DropLocationAddress	) AS 'StationDrop'
	 ,ISNULL(S2.ContactNo,'') AS ContactNumber,ISNULL(S2.SecondaryContactNo,'') AS SecondaryContactNumber FROM      OrderLocations AS OL
	  INNER JOIN City AS PC on OL.PickupLocationId=PC.CityID
	  INNER JOIN City AS DC on OL.DropLocationId=DC.CityID
	  left join Stations S1 on OL.StationFrom=S1.ID
	  left join Stations S2 on OL.StationTo=S2.ID
	  
     
      WHERE     LocationId                                        = COALESCE(@LocationId,LocationId)
      AND       OrderDetailId                                     = COALESCE(@OrderDetailId,OrderDetailId)
      --AND       PickupLocationId                                  = COALESCE(@PickupLocationId,PickupLocationId)
      --AND       COALESCE(PickupLocationAddress,'X')               = COALESCE(@PickupLocationAddress,COALESCE(PickupLocationAddress,'X'))
      --AND       DropLocationId                                    = COALESCE(@DropLocationId,DropLocationId)
      --AND       COALESCE(DropLocationAddress,'X')                 = COALESCE(@DropLocationAddress,COALESCE(DropLocationAddress,'X'))
      --AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_OrderLocations-----------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------





GO
/****** Object:  StoredProcedure [dbo].[usp_OrderPackageTypes]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_OrderPackageTypes                                                                                                            ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Monday, 25 Mar 2019 12:08:33:743                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_OrderPackageTypes](@Action_Type                    numeric(10),
                                       @p_Success                      bit             = 1    OUTPUT,
                                       @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                       @OrderPackageId                 bigint          = NULL OUTPUT, 
                                       @OrderDetailId                  bigint          = NULL,
                                       @PackageTypeId                  bigint          = NULL,
                                       @ItemId                         bigint          = NULL,
                                       @Quantity                       bigint          = NULL,
                                       @UnitWeight                         float(53)       = NULL,
									   @UnitFreight                         float(53)       = NULL,
                                       @CreatedBy                      bigint          = NULL,
                                       @CreatedDate                    datetime        = NULL,
                                       @ModifiedDate                   datetime        = NULL,
                                       @ModifiedBy                     bigint          = NULL,
									   @RateType    nvarchar(20)=null,
									   @ProfileDetailId bigint=0,
									   @AdditionalCharges float=0.0,
									   @LabourCharges float =0.0,
									   @DC_NO nvarchar(20) = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO OrderPackageTypes(OrderDetailId,  PackageTypeId,  ItemId,  Quantity,  UnitWeight,UnitFreight,  CreatedBy,  CreatedDate,  ModifiedDate,  ModifiedBy,RateType,ProfileDetailId,AdditionalCharges,LabourCharges,DC_NO)
      VALUES                          (@OrderDetailId, @PackageTypeId, @ItemId, @Quantity, @UnitWeight,@UnitFreight, @CreatedBy, @CreatedDate, @ModifiedDate, @ModifiedBy,@RateType,@ProfileDetailId,@AdditionalCharges,@LabourCharges,@DC_NO)

      SET       @OrderPackageId                = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    OrderPackageTypes
      SET       OrderDetailId                  = COALESCE(@OrderDetailId,OrderDetailId),
                PackageTypeId                  = COALESCE(@PackageTypeId,PackageTypeId),
                ItemId                         = COALESCE(@ItemId,ItemId),
                Quantity                       = COALESCE(@Quantity,Quantity),
                UnitWeight                         = COALESCE(@UnitWeight,UnitWeight),
				UnitFreight                         = COALESCE(@UnitFreight,UnitFreight),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
				RateType                     = COALESCE(@RateType,RateType),
				ProfileDetailId                     = COALESCE(@ProfileDetailId,ProfileDetailId),
				AdditionalCharges                     = COALESCE(@AdditionalCharges,AdditionalCharges),
				LabourCharges                     = COALESCE(@LabourCharges,LabourCharges),
				DC_NO                     = COALESCE(@DC_NO,DC_NO)
                
      WHERE     OrderPackageId                 = @OrderPackageId
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    OrderPackageTypes
      WHERE     OrderPackageId                 = @OrderPackageId
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
       SELECT    @Action_Type  AS ActionType, OrderPackageId, OrderPackageTypes.OrderDetailId,Product.Name 'ItemName', OrderPackageTypes.PackageTypeId,PackageType.PackageTypeName, OrderPackageTypes.ItemId, Quantity, OrderPackageTypes.UnitWeight,OrderPackageTypes.UnitFreight, OrderPackageTypes.CreatedBy, OrderPackageTypes.CreatedDate,OrderPackageTypes.ModifiedDate, OrderPackageTypes.ModifiedBy,ISNULL(CPD.RateType,'') RateType,ISNULL(CPD.WeightPerUnit,'1') WeightPerUnit,ISNULL(OrderPackageTypes.ProfileDetailId,'0') ProfileDetailId,
	   ISNULL(OrderPackageTypes.AdditionalCharges,0) AdditionalCharges,ISNULL(OrderPackageTypes.LabourCharges,0) LabourCharges,ISNULL(OrderPackageTypes.DC_NO,'') DC_NO
      FROM      OrderPackageTypes
	
	  INNER JOIN PackageType on OrderPackageTypes.PackageTypeId=PackageType.PackageTypeID
	  INNER JOIN Product on OrderPackageTypes.ItemId=Product.ID
	  INNER JOIN CustomerProfileDetail CPD on OrderPackageTypes.ItemId=CPD.ProductId AND  (OrderPackageTypes.ProfileDetailId=cpd.ProfileDetail AND OrderPackageTypes.ProfileDetailId is not null)
	  INNER JOIN OrderLocations Pick on OrderPackageTypes.OrderDetailId=Pick.OrderDetailId 
	  and Pick.PickupLocationId=cpd.LocationFrom and Pick.DropLocationId=CPD.LocationTo
	  
      WHERE     
	 -- CPD.WeightPerUnit is not null and
	  --OrderPackageId                                    = COALESCE(@OrderPackageId,OrderPackageId)
      --AND 
	        OrderPackageTypes.OrderDetailId                                     = COALESCE(@OrderDetailId,OrderPackageTypes.OrderDetailId)
      --AND       PackageTypeId                                     = COALESCE(@PackageTypeId,PackageTypeId)
      --AND       ItemId                                            = COALESCE(@ItemId,ItemId)
      --AND       COALESCE(Quantity,0)                              = COALESCE(@Quantity,COALESCE(Quantity,0))
      --AND       Weight                                            = COALESCE(@Weight,Weight)
      --AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_OrderPackageTypes--------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_Organization]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Organization](@Action_Type                    nvarchar(10),
@p_Success int=1 output,
                                  @p_Error_Message nvarchar(max)=null output,
									@p_OrganizationID bigint	=0 output,
                                     @UserName                    nvarchar(50)     = NULL,
                                     @password             nvarchar(50)    = NULL,
                                     @Code                   nvarchar(50)    = NULL,
                                     @Address                     nvarchar(250)     = NULL,
                                     @Active                       bit     = 0,
									 @OrganizationID bigint =0
									 
                                    
----End Added by Aamir
									 )
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 'INSERT' ------------------------> Insert Record
    BEGIN
      INSERT    INTO Organization(UserName,password,Code,Address,Active,CreatedDate,CreatedBy)
	  --Changed by Aamir on 13/05/2015 to save the 1 in Is_Active, system date in Created_date and NULL in Modified by & Modified date
      VALUES                        (@UserName,@password,@Code,@Address,@Active,GETDATE(),0)
	  --Old Code
      --VALUES                        (@Bank_Branch, @Bank_Branch_Detail, @Bank_Address, @Bank_Phone, @Bank_Fax, @Bank_Contact_Person, @Contact_Person_Designation, @Is_Active, @Created_Date, @Created_By, @Modified_Date, @Modified_By, @Audit_Id, @User_IP, @Site_Id)
	  --End Changed by Aamir

     -- SET       @p_OrganizationID                = @@IDENTITY
	  SELECT    *
      FROM      Organization
	 
    END

  ELSE IF  @Action_Type = 'UPDATE' ------------------------> Update Record
    BEGIN
      UPDATE    Organization
      SET       
				Code                    = COALESCE(@Code,Code),
                UserName             = COALESCE(@UserName,UserName),
                password                   = COALESCE(@password,password),
                Address                     = COALESCE(@Address,Address),
               
                Active                      = COALESCE(@Active,Active),
               
                ModifiedDate                  = GETDATE(),
                Modifiedby                    = 0
             
      WHERE     OrganizationID                 = @OrganizationID

	    SELECT    *      FROM      Organization
    END
  ELSE IF  @Action_Type = 'DELETE' ------------------------> Delete Record
    BEGIN
      DELETE    Organization
      WHERE     OrganizationID                 = @OrganizationID
    END

  ELSE IF  @Action_Type = 'SELECT' ------------------------> Select Record
    BEGIN
      SELECT    *
      FROM      Organization
     -- WHERE     Code                                    = COALESCE(@Code,Code)
	 -- AND		UserName											  = COALESCE(@UserName,UserName)
    
     --4 AND       Active                                         = COALESCE(@Active,Active)
     

	
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END









GO
/****** Object:  StoredProcedure [dbo].[usp_OwnCompany]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_OwnCompany                                                                                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Tuesday, 05 Feb 2019 12:28:18:957                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_OwnCompany](@Action_Type                    numeric(10),
                                @p_Success                      bit             = 1    OUTPUT,
                                @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                @CompanyID                      bigint          = NULL OUTPUT, 
                                @CompanyCode                    nvarchar(15)    = NULL,
                                @CompanyName                    nvarchar(100)   = NULL,
                                @CompanyEmail                   nvarchar(50)    = NULL,
                                @CompanyWebSite                 nvarchar(50)    = NULL,
                                @CreatedBy                      bigint          = NULL,
                                @ModifiedBy                     bigint          = NULL,
                                @Active                         bit             = NULL,
                                @CreatedDate                    date            = NULL,
                                @ModifiedDate                   date            = NULL,
                                @Contact                        varchar(50)     = NULL,
                                @OtherContact                   nvarchar(50)    = NULL,
                                @Description                    nvarchar(255)   = NULL,
                                @GroupID                        bigint          = NULL,
								@Address1						nvarchar(250)=null,
								@Address2						nvarchar(250)=null,
								@NTN							nvarchar(10) = null)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO OwnCompany(CompanyCode,  CompanyName,  CompanyEmail,  CompanyWebSite,  CreatedBy,  ModifiedBy,  Active,  CreatedDate,  ModifiedDate,  Contact,  OtherContact,  Description,  GroupID,Address1,Address2,NTN)
      VALUES                   (@CompanyCode, @CompanyName, @CompanyEmail, @CompanyWebSite, @CreatedBy, @ModifiedBy, @Active, @CreatedDate, @ModifiedDate, @Contact, @OtherContact, @Description, @GroupID,@Address1,@Address2,@NTN)

      SET       @CompanyID                     = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    OwnCompany
      SET       CompanyCode                    = COALESCE(@CompanyCode,CompanyCode),
                CompanyName                    = COALESCE(@CompanyName,CompanyName),
                CompanyEmail                   = COALESCE(@CompanyEmail,CompanyEmail),
                CompanyWebSite                 = COALESCE(@CompanyWebSite,CompanyWebSite),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                Active                         = COALESCE(@Active,Active),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                Contact                        = COALESCE(@Contact,Contact),
                OtherContact                   = COALESCE(@OtherContact,OtherContact),
                Description                    = COALESCE(@Description,Description),
                GroupID                        = COALESCE(@GroupID,GroupID),
				 Address1                        = COALESCE(@Address1,Address1),
				  Address2                        = COALESCE(@Address2,Address2),
				  NTN                        = COALESCE(@NTN,NTN)
                
      WHERE     CompanyID                      = @CompanyID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    OwnCompany
      WHERE     CompanyID                      = @CompanyID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, C.*,G.GroupName,G.GroupCode
      FROM      OwnCompany C
	  LEFT JOIN OWNGROUPS G on C.GroupID=G.GroupID
      WHERE     CompanyID                                         = COALESCE(@CompanyID,CompanyID)
      --AND       COALESCE(CompanyCode,'X')                         = COALESCE(@CompanyCode,COALESCE(CompanyCode,'X'))
      --AND       COALESCE(CompanyName,'X')                         = COALESCE(@CompanyName,COALESCE(CompanyName,'X'))
      --AND       COALESCE(CompanyEmail,'X')                        = COALESCE(@CompanyEmail,COALESCE(CompanyEmail,'X'))
      --AND       COALESCE(CompanyWebSite,'X')                      = COALESCE(@CompanyWebSite,COALESCE(CompanyWebSite,'X'))
      --AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
      --AND       COALESCE(Active,0)                                = COALESCE(@Active,COALESCE(Active,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
      --AND       COALESCE(C.Contact,'X')                             = COALESCE(@Contact,COALESCE(C.Contact,'X'))
      --AND       COALESCE(OtherContact,'X')                        = COALESCE(@OtherContact,COALESCE(OtherContact,'X'))
      --AND       COALESCE(C.Description,'X')                         = COALESCE(@Description,COALESCE(C.Description,'X'))
      AND       C.GroupID                                           = COALESCE(@GroupID,C.GroupID)
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_OwnCompany---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------






GO
/****** Object:  StoredProcedure [dbo].[usp_OwnDepartment]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_OwnDepartment                                                                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Tuesday, 05 Feb 2019 12:35:19:410                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_OwnDepartment](@Action_Type                    numeric(10),
                                   @p_Success                      bit             = 1    OUTPUT,
                                   @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                   @DepartID                       bigint          = NULL OUTPUT, 
                                   @DepartCode                     varchar(50)     = NULL,
                                   @DepartName                     varchar(50)     = NULL,
                                   @Contact                       varchar(50)     = NULL,
                                   @ContactOther                   varchar(50)     = NULL,
                                   @EmailAdd                       varchar(50)     = NULL,
                                   @WebAdd                         varchar(50)     = NULL,
                                   @Address                        varchar(50)     = NULL,
                                   @CustomerID                     bigint          = NULL,
                                   @DateCreated                    datetime        = NULL,
                                   @DateModified                   datetime        = NULL,
                                   @CreatedByUserID                bigint          = NULL,
                                   @ModifiedByUser                 bigint          = NULL,
                                   @Description                    varchar(50)     = NULL,
                                   @IsActive                       bit             = NULL,
                                   @GROUPID                        bigint          = NULL,
                                   @COMPANYID                      bigint          = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO OwnDepartment(DepartCode,  DepartName,  Contact,  ContactOther,  EmailAdd,  WebAdd,  Address,  CustomerID,  DateCreated,  DateModified,  CreatedByUserID,  ModifiedByUser,  Description,  IsActive,  GROUPID,  COMPANYID)
      VALUES                      (@DepartCode, @DepartName, @Contact, @ContactOther, @EmailAdd, @WebAdd, @Address, @CustomerID, @DateCreated, @DateModified, @CreatedByUserID, @ModifiedByUser, @Description, @IsActive, @GROUPID, @COMPANYID)

      SET       @DepartID                      = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    OwnDepartment
      SET       DepartCode                     = COALESCE(@DepartCode,DepartCode),
                DepartName                     = COALESCE(@DepartName,DepartName),
                Contact                       = COALESCE(@Contact,Contact),
                ContactOther                   = COALESCE(@ContactOther,ContactOther),
                EmailAdd                       = COALESCE(@EmailAdd,EmailAdd),
                WebAdd                         = COALESCE(@WebAdd,WebAdd),
                Address                        = COALESCE(@Address,Address),
                CustomerID                     = COALESCE(@CustomerID,CustomerID),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified),
                CreatedByUserID                = COALESCE(@CreatedByUserID,CreatedByUserID),
                ModifiedByUser                 = COALESCE(@ModifiedByUser,ModifiedByUser),
                Description                    = COALESCE(@Description,Description),
                IsActive                       = COALESCE(@IsActive,IsActive),
                GROUPID                        = COALESCE(@GROUPID,GROUPID),
                COMPANYID                      = COALESCE(@COMPANYID,COMPANYID)
                
      WHERE     DepartID                       = @DepartID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    OwnDepartment
      WHERE     DepartID                       = @DepartID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
     -- SELECT    @Action_Type  AS ActionType, DepartID, DepartCode, DepartName, Contact as Contact, ContactOther, EmailAdd, WebAdd, Address, CustomerID, DateCreated, DateModified, CreatedByUserID, ModifiedByUser, Description, IsActive, GROUPID, COMPANYID
     -- FROM      OwnDepartment

	  SELECT @Action_Type  AS ActionType, D.*,G.GroupName,C.CompanyName FROM OwnDepartment D
 INNER JOIN OWNGROUPS G  on D.GROUPID =G.GroupID
 INNER JOIN  OWNCOMPANY C on D.companyid=C.CompanyID
      WHERE     DepartID                                          = COALESCE(@DepartID,DepartID)
      AND       COALESCE(DepartCode,'X')                          = COALESCE(@DepartCode,COALESCE(DepartCode,'X'))
      AND       COALESCE(DepartName,'X')                          = COALESCE(@DepartName,COALESCE(DepartName,'X'))
      AND       COALESCE(D.Contact,'X')                            = COALESCE(@Contact,COALESCE(D.Contact,'X'))
      AND       COALESCE(D.ContactOther,'X')                        = COALESCE(@ContactOther,COALESCE(D.ContactOther,'X'))
      AND       COALESCE(D.EmailAdd,'X')                            = COALESCE(@EmailAdd,COALESCE(D.EmailAdd,'X'))
      AND       COALESCE(D.WebAdd,'X')                              = COALESCE(@WebAdd,COALESCE(D.WebAdd,'X'))
      AND       COALESCE(D.Address,'X')                             = COALESCE(@Address,COALESCE(D.Address,'X'))
      AND       COALESCE(CustomerID,0)                            = COALESCE(@CustomerID,COALESCE(CustomerID,0))
      AND       COALESCE(D.DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(D.DateCreated,GETDATE()))
      AND       COALESCE(D.DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(D.DateModified,GETDATE()))
      AND       COALESCE(D.CreatedByUserID,0)                       = COALESCE(@CreatedByUserID,COALESCE(D.CreatedByUserID,0))
      AND       COALESCE(D.ModifiedByUser,0)                        = COALESCE(@ModifiedByUser,COALESCE(D.ModifiedByUser,0))
      AND       COALESCE(D.Description,'X')                         = COALESCE(@Description,COALESCE(D.Description,'X'))
      AND       COALESCE(D.IsActive,0)                              = COALESCE(@IsActive,COALESCE(D.IsActive,0))
      AND       D.GROUPID                                           = COALESCE(@GROUPID,D.GROUPID)
      AND       D.COMPANYID                                         = COALESCE(@COMPANYID,D.COMPANYID)
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_OwnDepartment------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_OwnGroups]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_OwnGroups                                                                                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Tuesday, 05 Feb 2019 12:29:59:987                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_OwnGroups](@Action_Type                    numeric(10),
                               @p_Success                      bit             = 1    OUTPUT,
                               @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                               @GroupID                        bigint          = NULL OUTPUT, 
                               @GroupCode                      varchar(50)     = NULL,
                               @GroupName                      varchar(50)     = NULL,
                               @Contact                      varchar(50)     = NULL,
                               @ContactOther                   varchar(50)     = NULL,
                               @EmailAdd                       varchar(50)     = NULL,
                               @WebAdd                         varchar(50)     = NULL,
                               @Address                        varchar(50)     = NULL,
                               --@Logo                           n(2147) = NULL,
                               @DateCreated                    datetime        = NULL,
                               @DateModified                   datetime        = NULL,
                               @CreatedByUserID                bigint          = NULL,
                               @ModifiedByUserID               bigint          = NULL,
                               @Description                    varchar(50)     = NULL,
                               @IsActive                       bit             = NULL,
                               @CompanyAccess                  varchar(50)     = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO OwnGroups(GroupCode,  GroupName,  Contact,  ContactOther,  EmailAdd,  WebAdd,  Address,    DateCreated,  DateModified,  CreatedByUserID,  ModifiedByUserID,  Description,  IsActive,  CompanyAccess)
      VALUES                  (@GroupCode, @GroupName, @Contact, @ContactOther, @EmailAdd, @WebAdd, @Address,  @DateCreated, @DateModified, @CreatedByUserID, @ModifiedByUserID, @Description, @IsActive, @CompanyAccess)

      SET       @GroupID                       = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    OwnGroups
      SET       GroupCode                      = COALESCE(@GroupCode,GroupCode),
                GroupName                      = COALESCE(@GroupName,GroupName),
                Contact                       = COALESCE(@Contact,Contact),
                ContactOther                   = COALESCE(@ContactOther,ContactOther),
                EmailAdd                       = COALESCE(@EmailAdd,EmailAdd),
                WebAdd                         = COALESCE(@WebAdd,WebAdd),
                Address                        = COALESCE(@Address,Address),
               -- Logo                           = COALESCE(@Logo,Logo),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified),
                CreatedByUserID                = COALESCE(@CreatedByUserID,CreatedByUserID),
                ModifiedByUserID               = COALESCE(@ModifiedByUserID,ModifiedByUserID),
                Description                    = COALESCE(@Description,Description),
                IsActive                       = COALESCE(@IsActive,IsActive),
                CompanyAccess                  = COALESCE(@CompanyAccess,CompanyAccess)
                
      WHERE     GroupID                        = @GroupID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    OwnGroups
      WHERE     GroupID                        = @GroupID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, GroupID, GroupCode, GroupName, Contact, ContactOther, EmailAdd, WebAdd, Address,  DateCreated, DateModified, CreatedByUserID, ModifiedByUserID, Description, IsActive, CompanyAccess
      FROM      OwnGroups
      WHERE     GroupID                                           = COALESCE(@GroupID,GroupID)
	  and IsActive=1
      --AND       COALESCE(GroupCode,'X')                           = COALESCE(@GroupCode,COALESCE(GroupCode,'X'))
      --AND       COALESCE(GroupName,'X')                           = COALESCE(@GroupName,COALESCE(GroupName,'X'))
      --AND       COALESCE(Contact,'X')                            = COALESCE(@Contact,COALESCE(Contact,'X'))
      --AND       COALESCE(ContactOther,'X')                        = COALESCE(@ContactOther,COALESCE(ContactOther,'X'))
      --AND       COALESCE(EmailAdd,'X')                            = COALESCE(@EmailAdd,COALESCE(EmailAdd,'X'))
      --AND       COALESCE(WebAdd,'X')                              = COALESCE(@WebAdd,COALESCE(WebAdd,'X'))
      --AND       COALESCE(Address,'X')                             = COALESCE(@Address,COALESCE(Address,'X'))
      ----AND       Logo                                              = COALESCE(@Logo,Logo)
      --AND       COALESCE(DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(DateCreated,GETDATE()))
      --AND       COALESCE(DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(DateModified,GETDATE()))
      --AND       COALESCE(CreatedByUserID,0)                       = COALESCE(@CreatedByUserID,COALESCE(CreatedByUserID,0))
      --AND       COALESCE(ModifiedByUserID,0)                      = COALESCE(@ModifiedByUserID,COALESCE(ModifiedByUserID,0))
      --AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
      --AND       COALESCE(IsActive,0)                              = COALESCE(@IsActive,COALESCE(IsActive,0))
      --AND       COALESCE(CompanyAccess,'X')                       = COALESCE(@CompanyAccess,COALESCE(CompanyAccess,'X'))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_OwnGroups----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_OwnOrganization]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_OwnOrganization                                                                                                              ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Tuesday, 05 Feb 2019 12:28:02:030                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_OwnOrganization](@Action_Type                    numeric(10),
                                     @p_Success                      bit             = 1    OUTPUT,
                                     @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                     @OrganizationID                 bigint          = NULL OUTPUT, 
                                     @UserName                       nvarchar(50)    = NULL,
                                     @password                       nvarchar(50)    = NULL,
                                     @Code                           nvarchar(50)    = NULL,
                                     @Address                        nvarchar(250)   = NULL,
                                     @Active                         bit             = NULL,
                                     @CreatedBy                      bigint          = NULL,
                                     @Modifiedby                     bigint          = NULL,
                                     @CreatedDate                    datetime        = NULL,
                                     @ModifiedDate                   datetime        = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO OwnOrganization(UserName,  password,  Code,  Address,  Active,  CreatedBy,  Modifiedby,  CreatedDate,  ModifiedDate)
      VALUES                        (@UserName, @password, @Code, @Address, @Active, @CreatedBy, @Modifiedby, @CreatedDate, @ModifiedDate)

      SET       @OrganizationID                = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    OwnOrganization
      SET       UserName                       = COALESCE(@UserName,UserName),
                password                       = COALESCE(@password,password),
                Code                           = COALESCE(@Code,Code),
                Address                        = COALESCE(@Address,Address),
                Active                         = COALESCE(@Active,Active),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                Modifiedby                     = COALESCE(@Modifiedby,Modifiedby),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate)
                
      WHERE     OrganizationID                 = @OrganizationID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    OwnOrganization
      WHERE     OrganizationID                 = @OrganizationID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, OrganizationID, UserName, password, Code, Address, Active, CreatedBy, Modifiedby, CreatedDate, ModifiedDate
      FROM      OwnOrganization
      WHERE     OrganizationID                                    = COALESCE(@OrganizationID,OrganizationID)
      AND       COALESCE(UserName,'X')                            = COALESCE(@UserName,COALESCE(UserName,'X'))
      AND       COALESCE(password,'X')                            = COALESCE(@password,COALESCE(password,'X'))
      AND       COALESCE(Code,'X')                                = COALESCE(@Code,COALESCE(Code,'X'))
      AND       COALESCE(Address,'X')                             = COALESCE(@Address,COALESCE(Address,'X'))
      AND       COALESCE(Active,0)                                = COALESCE(@Active,COALESCE(Active,0))
      AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      AND       COALESCE(Modifiedby,0)                            = COALESCE(@Modifiedby,COALESCE(Modifiedby,0))
      AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_OwnOrganization----------------------------------------------


GO
/****** Object:  StoredProcedure [dbo].[usp_PackageType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_PackageType                                                                                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Friday, 23 Nov 2018 15:36:27:647                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_PackageType](@Action_Type                    numeric(10),
                                 @p_Success                      bit             = 1    OUTPUT,
                                 @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                 @PackageTypeID                  bigint          = NULL OUTPUT, 
                                 @PackageTypeCode                varchar(50)     = NULL,
                                 @PackageTypeName                varchar(50)     = NULL,
                                 @Length                         float(53)       = NULL,
                                 @Width                          float(53)       = NULL,
                                 @Height                         float(53)       = NULL,
                                 @DimensionUnit                  varchar(10)     = NULL,
                                 @Weight                         float(53)       = NULL,
                                 @WeightUnit                     varchar(10)     = NULL,
                                 @DateCreated                    datetime        = NULL,
                                 @DateModified                   datetime        = NULL,
                                 @CreatedByUserID                bigint          = NULL,
                                 @ModifiedByUserID               bigint          = NULL,
                                 @IsActive                       bit             = NULL,
                                 @IsMaster                       bit             = NULL,
                                 @Description                    varchar(500)    = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO PackageType(PackageTypeCode,  PackageTypeName,  Length,  Width,  Height,  DimensionUnit,  Weight,  WeightUnit,  DateCreated,  DateModified,  CreatedByUserID,  ModifiedByUserID,  IsActive,  IsMaster,  Description)
      VALUES                    (@PackageTypeCode, @PackageTypeName, @Length, @Width, @Height, @DimensionUnit, @Weight, @WeightUnit, @DateCreated, @DateModified, @CreatedByUserID, @ModifiedByUserID, @IsActive, @IsMaster, @Description)

      SET       @PackageTypeID                 = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    PackageType
      SET       PackageTypeCode                = COALESCE(@PackageTypeCode,PackageTypeCode),
                PackageTypeName                = COALESCE(@PackageTypeName,PackageTypeName),
                Length                         = COALESCE(@Length,Length),
                Width                          = COALESCE(@Width,Width),
                Height                         = COALESCE(@Height,Height),
                DimensionUnit                  = COALESCE(@DimensionUnit,DimensionUnit),
                Weight                         = COALESCE(@Weight,Weight),
                WeightUnit                     = COALESCE(@WeightUnit,WeightUnit),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified),
                CreatedByUserID                = COALESCE(@CreatedByUserID,CreatedByUserID),
                ModifiedByUserID               = COALESCE(@ModifiedByUserID,ModifiedByUserID),
                IsActive                       = COALESCE(@IsActive,IsActive),
                IsMaster                       = COALESCE(@IsMaster,IsMaster),
                Description                    = COALESCE(@Description,Description)
                
      WHERE     PackageTypeID                  = @PackageTypeID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    PackageType
      WHERE     PackageTypeID                  = @PackageTypeID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, PackageTypeID, PackageTypeCode, PackageTypeName, Length, Width, Height, DimensionUnit, Weight, WeightUnit, DateCreated, DateModified, CreatedByUserID, ModifiedByUserID, IsActive, IsMaster, Description
      FROM      PackageType
      WHERE     PackageTypeID                                     = COALESCE(@PackageTypeID,PackageTypeID)
      AND       COALESCE(PackageTypeCode,'X')                     = COALESCE(@PackageTypeCode,COALESCE(PackageTypeCode,'X'))
      AND       COALESCE(PackageTypeName,'X')                     = COALESCE(@PackageTypeName,COALESCE(PackageTypeName,'X'))
      AND       Length                                            = COALESCE(@Length,Length)
      AND       Width                                             = COALESCE(@Width,Width)
      AND       Height                                            = COALESCE(@Height,Height)
      AND       COALESCE(DimensionUnit,'X')                       = COALESCE(@DimensionUnit,COALESCE(DimensionUnit,'X'))
      AND       Weight                                            = COALESCE(@Weight,Weight)
      AND       COALESCE(WeightUnit,'X')                          = COALESCE(@WeightUnit,COALESCE(WeightUnit,'X'))
      AND       COALESCE(DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(DateCreated,GETDATE()))
      AND       COALESCE(DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(DateModified,GETDATE()))
      AND       COALESCE(CreatedByUserID,0)                       = COALESCE(@CreatedByUserID,COALESCE(CreatedByUserID,0))
      AND       COALESCE(ModifiedByUserID,0)                      = COALESCE(@ModifiedByUserID,COALESCE(ModifiedByUserID,0))
      AND       COALESCE(IsActive,0)                              = COALESCE(@IsActive,COALESCE(IsActive,0))
      AND       COALESCE(IsMaster,0)                              = COALESCE(@IsMaster,COALESCE(IsMaster,0))
      AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
	  order by PackageTypeName
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_PackageType--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_Part_Category]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Part_Category                                                                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Thursday, 18 Oct 2018 23:34:33:343                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Part_Category](@Action_Type                    numeric(10),
                                   @p_Success                      bit             = 1    OUTPUT,
                                   @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                   @PartsCategoryID                int             = NULL OUTPUT, 
                                   @Parts_CategoryCode             nvarchar(10)    = NULL,
                                   @Parts_CategoryName             nvarchar(50)    = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Part_Category(Parts_CategoryCode,  Parts_CategoryName)
      VALUES                      (@Parts_CategoryCode, @Parts_CategoryName)

      SET       @PartsCategoryID               = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Part_Category
      SET       Parts_CategoryCode             = COALESCE(@Parts_CategoryCode,Parts_CategoryCode),
                Parts_CategoryName             = COALESCE(@Parts_CategoryName,Parts_CategoryName)
                
      WHERE     PartsCategoryID                = @PartsCategoryID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Part_Category
      WHERE     PartsCategoryID                = @PartsCategoryID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, PartsCategoryID, Parts_CategoryCode, Parts_CategoryName
      FROM      Part_Category
      WHERE     PartsCategoryID                                   = COALESCE(@PartsCategoryID,PartsCategoryID)
      AND       Parts_CategoryCode                                = COALESCE(@Parts_CategoryCode,Parts_CategoryCode)
      AND       Parts_CategoryName                                = COALESCE(@Parts_CategoryName,Parts_CategoryName)
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Part_Category------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_PartOrderDetail]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_OrderDetail                                                                                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Wednesday, 27 Mar 2019 12:21:35:543                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_PartOrderDetail](@Action_Type                    numeric(10),
                                 @p_Success                      bit             = 1    OUTPUT,
                                 @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                 @OrderDetailId                  bigint          = NULL OUTPUT, 
                                 @OrderID                        bigint          = NULL,
                                 @BiltyNo                        nvarchar(50)    = NULL,
                                 @BiltyNoDate                    datetime        = NULL,
                                 @ManualBiltyNo                  nvarchar(50)    = NULL,
                                 @ManualBiltyDate                datetime        = NULL,
                                 @CustomerCode                   nvarchar(50)    = NULL,
                                 @PaymentType                    nvarchar(50)    = NULL,
                                 @ShipmentTypeId                 int             = NULL,
                                 @VehicleTypeId                  int             = NULL,
                                 @BrokerId                       int             = NULL,
                                 @BrokerName                     nvarchar(100)   = NULL,
                                 @BrokerContactNo                nvarchar(50)    = NULL,
                                 @AdditionalWeight               float(53)       = NULL,
                                 @NetWeight                      float(53)       = NULL,
                                 @TotalExpenses                  float(53)       = NULL,
                                 @FreightTypeId                  int             = NULL,
                                 @FreightTypeQty                 int             = NULL,
                                 @Freight                        float          = NULL,
                                 @ParentId                       bigint          = NULL,
                                 @CreatedDate                    datetime        = NULL,
                                 @CreatedBy                      bigint          = NULL,
                                 @ModifiedDate                   datetime        = NULL,
                                 @ModifiedBy                     bigint          = NULL,
								 @LocalFreight					 bigint			 = NULL,
								 @DA_NO					 nvarchar(50)			 = NULL,
								 @Remarks				 nvarchar(250)           =NULL,
								 @ChallanNo				 nvarchar(10)=null,
								 @ChallanDate			 datetime=null,@AdditionalFreight float=null,
								 @StatusID bigint =null)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO OrderDetail(OrderID,  BiltyNo,  BiltyNoDate,  ManualBiltyNo,  ManualBiltyDate,  CustomerCode,  PaymentType,  ShipmentTypeId,  VehicleTypeId,  BrokerId,  BrokerName,  BrokerContactNo,  AdditionalWeight,  NetWeight,  TotalExpenses,  FreightTypeId,  FreightTypeQty,  Freight,  ParentId,  CreatedDate,  CreatedBy,  ModifiedDate,  ModifiedBy,LocalFreight,DA_NO,Remarks,ChallanNo,ChallanDate,AdditionalFreight,StatusID)
      VALUES                    (@OrderID,dbo.PartManualBiltyGenerator(@CustomerCode,@ParentId,@BiltyNo) , @BiltyNoDate, @ManualBiltyNo, @ManualBiltyDate, @CustomerCode, @PaymentType, @ShipmentTypeId, @VehicleTypeId, @BrokerId, @BrokerName, @BrokerContactNo, @AdditionalWeight, @NetWeight, @TotalExpenses, @FreightTypeId, @FreightTypeQty, @Freight, @ParentId, @CreatedDate, @CreatedBy, @ModifiedDate, @ModifiedBy,@LocalFreight,@DA_NO,@Remarks,@ChallanNo,@ChallanDate,@AdditionalFreight,@StatusID)

      SET       @OrderDetailId                 = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    OrderDetail
      SET       OrderID                        = COALESCE(@OrderID,OrderID),
                BiltyNo                        = COALESCE(@BiltyNo,BiltyNo),
                BiltyNoDate                    = COALESCE(@BiltyNoDate,BiltyNoDate),
                ManualBiltyNo                  = COALESCE(@ManualBiltyNo,ManualBiltyNo),
                ManualBiltyDate                = COALESCE(@ManualBiltyDate,ManualBiltyDate),
                CustomerCode                   = COALESCE(@CustomerCode,CustomerCode),
                PaymentType                    = COALESCE(@PaymentType,PaymentType),
                ShipmentTypeId                 = COALESCE(@ShipmentTypeId,ShipmentTypeId),
                VehicleTypeId                  = COALESCE(@VehicleTypeId,VehicleTypeId),
                BrokerId                       = COALESCE(@BrokerId,BrokerId),
                BrokerName                     = COALESCE(@BrokerName,BrokerName),
                BrokerContactNo                = COALESCE(@BrokerContactNo,BrokerContactNo),
                AdditionalWeight               = COALESCE(@AdditionalWeight,AdditionalWeight),
                NetWeight                      = COALESCE(@NetWeight,NetWeight),
                TotalExpenses                  = COALESCE(@TotalExpenses,TotalExpenses),
                FreightTypeId                  = COALESCE(@FreightTypeId,FreightTypeId),
                FreightTypeQty                 = COALESCE(@FreightTypeQty,FreightTypeQty),
                Freight                        = COALESCE(@Freight,Freight),
                ParentId                       = COALESCE(@ParentId,ParentId),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
				localFreight                     = COALESCE(@LocalFreight,localFreight),
				DA_NO						   = COALESCE(@DA_NO,DA_NO),
				Remarks						   =COALESCE(@Remarks,Remarks),
				AdditionalFreight						   =COALESCE(@AdditionalFreight,AdditionalFreight)
				
                
      WHERE     OrderDetailId                  = @OrderDetailId
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    OrderDetail
      WHERE     OrderDetailId                  = @OrderDetailId
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType,ST.ShipmentType,FT.FreightTypeName,VT.VehicleTypeName, OrderDetailId, OrderID, BiltyNo, BiltyNoDate, ManualBiltyNo, ManualBiltyDate, CustomerCode, PaymentType, ShipmentTypeId, OrderDetail.VehicleTypeId, BrokerId, BrokerName, BrokerContactNo, AdditionalWeight, NetWeight, TotalExpenses, OrderDetail.FreightTypeId, FreightTypeQty, Freight, ParentId, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy,LocalFreight,DA_No,Remarks,ChallanDate,ChallanNo,AdditionalFreight,StatusID
      FROM      OrderDetail
	    LEFT JOIN ShipmentType ST ON OrderDetail.ShipmentTypeId=ST.SHIPMENTTYPE_ID
		LEFT JOIN FreightType FT ON OrderDetail.FreightTypeId=FT.FreightTypeID
		LEFT JOIN VehicleType VT ON OrderDetail.VehicleTypeId=VT.VehicleTypeID
		
      WHERE     OrderDetailId                                     = COALESCE(@OrderDetailId,OrderDetailId)
      AND       OrderID                                           = COALESCE(@OrderID,OrderID)
      --AND       COALESCE(BiltyNo,'X')                             = COALESCE(@BiltyNo,COALESCE(BiltyNo,'X'))
      --AND       COALESCE(BiltyNoDate,GETDATE())                   = COALESCE(@BiltyNoDate,COALESCE(BiltyNoDate,GETDATE()))
      --AND       COALESCE(ManualBiltyNo,'X')                       = COALESCE(@ManualBiltyNo,COALESCE(ManualBiltyNo,'X'))
      --AND       COALESCE(ManualBiltyDate,GETDATE())               = COALESCE(@ManualBiltyDate,COALESCE(ManualBiltyDate,GETDATE()))
      --AND       COALESCE(CustomerCode,'X')                        = COALESCE(@CustomerCode,COALESCE(CustomerCode,'X'))
      --AND       COALESCE(PaymentType,'X')                         = COALESCE(@PaymentType,COALESCE(PaymentType,'X'))
      --AND       ShipmentTypeId                                    = COALESCE(@ShipmentTypeId,ShipmentTypeId)
      --AND       COALESCE(VehicleTypeId,0)                         = COALESCE(@VehicleTypeId,COALESCE(VehicleTypeId,0))
      --AND       COALESCE(BrokerId,0)                              = COALESCE(@BrokerId,COALESCE(BrokerId,0))
      --AND       COALESCE(BrokerName,'X')                          = COALESCE(@BrokerName,COALESCE(BrokerName,'X'))
      --AND       COALESCE(BrokerContactNo,'X')                     = COALESCE(@BrokerContactNo,COALESCE(BrokerContactNo,'X'))
      --AND       AdditionalWeight                                  = COALESCE(@AdditionalWeight,AdditionalWeight)
      --AND       NetWeight                                         = COALESCE(@NetWeight,NetWeight)
      --AND       TotalExpenses                                     = COALESCE(@TotalExpenses,TotalExpenses)
      --AND       COALESCE(FreightTypeId,0)                         = COALESCE(@FreightTypeId,COALESCE(FreightTypeId,0))
      --AND       COALESCE(FreightTypeQty,0)                        = COALESCE(@FreightTypeQty,COALESCE(FreightTypeQty,0))
      --AND       COALESCE(Freight,0)                               = COALESCE(@Freight,COALESCE(Freight,0))
      --AND       COALESCE(ParentId,0)                              = COALESCE(@ParentId,COALESCE(ParentId,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_OrderDetail--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------



GO
/****** Object:  StoredProcedure [dbo].[usp_Parts]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Parts                                                                                                                        ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Thursday, 18 Oct 2018 23:34:01:660                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Parts](@Action_Type                    numeric(10),
                           @p_Success                      bit             = 1    OUTPUT,
                           @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                           @PartID                         int             = NULL OUTPUT, 
                           @PartsCategoryID                int             = NULL,
                           @PartsCode                      nvarchar(50)    = NULL,
                           @EstimatedCost                  float(53)       = NULL,
                           @EstimatedLifeInDay             int             = NULL,
                           @EstimatedRunningInKM           float(53)       = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Parts(PartsCategoryID,  PartsCode,  EstimatedCost,  EstimatedLifeInDay,  EstimatedRunningInKM)
      VALUES              (@PartsCategoryID, @PartsCode, @EstimatedCost, @EstimatedLifeInDay, @EstimatedRunningInKM)

      SET       @PartID                        = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Parts
      SET       PartsCategoryID                = COALESCE(@PartsCategoryID,PartsCategoryID),
                PartsCode                      = COALESCE(@PartsCode,PartsCode),
                EstimatedCost                  = COALESCE(@EstimatedCost,EstimatedCost),
                EstimatedLifeInDay             = COALESCE(@EstimatedLifeInDay,EstimatedLifeInDay),
                EstimatedRunningInKM           = COALESCE(@EstimatedRunningInKM,EstimatedRunningInKM)
                
      WHERE     PartID                         = @PartID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Parts
      WHERE     PartID                         = @PartID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, PartID, PartsCategoryID, PartsCode, EstimatedCost, EstimatedLifeInDay, EstimatedRunningInKM
      FROM      Parts
      WHERE     PartID                                            = COALESCE(@PartID,PartID)
      AND       PartsCategoryID                                   = COALESCE(@PartsCategoryID,PartsCategoryID)
      AND       PartsCode                                         = COALESCE(@PartsCode,PartsCode)
      AND       EstimatedCost                                     = COALESCE(@EstimatedCost,EstimatedCost)
      AND       COALESCE(EstimatedLifeInDay,0)                    = COALESCE(@EstimatedLifeInDay,COALESCE(EstimatedLifeInDay,0))
      AND       EstimatedRunningInKM                              = COALESCE(@EstimatedRunningInKM,EstimatedRunningInKM)
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Parts--------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_PickDropLocation]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_PickDropLocation                                                                                                             ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Tuesday, 31 Dec 2019 01:03:31:233                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_PickDropLocation](@Action_Type                    numeric(10),
                                      @p_Success                      bit             = 1    OUTPUT,
                                      @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                      @PickDropID                     bigint          = NULL OUTPUT, 
                                      @PickDropCode                   varchar(50)     = NULL,
                                      @AreaID                         bigint          = NULL,
                                      @Address                        varchar(50)     = NULL,
                                      @ProvinceID                     bigint          = NULL,
                                      @LocationTypeID                 bigint          = NULL,
                                      @OwnerID                        bigint          = NULL,
                                      @DateCreated                    datetime        = NULL,
                                      @DateModified                   datetime        = NULL,
                                      @CreatedByUserID                bigint          = NULL,
                                      @ModifiedByUserID               bigint          = NULL,
                                      @IsActive                       bit             = NULL,
                                      @Description                    varchar(500)    = NULL,
                                      @PickDropLocationName           varchar(100)    = NULL,
                                      @IsPort                         bit             = NULL,
                                      @LAT                            varchar(50)     = NULL,
                                      @LON                            varchar(50)     = NULL,
                                      @CityID                         bigint          = NULL,
                                      @RegionID                       bigint          = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO PickDropLocation(PickDropCode,  AreaID,  Address,  ProvinceID,  LocationTypeID,  OwnerID,  DateCreated,  DateModified,  CreatedByUserID,  ModifiedByUserID,  IsActive,  Description,  PickDropLocationName,  IsPort,  LAT,  LON,  CityID,  RegionID)
      VALUES                         (@PickDropCode, @AreaID, @Address, @ProvinceID, @LocationTypeID, @OwnerID, @DateCreated, @DateModified, @CreatedByUserID, @ModifiedByUserID, @IsActive, @Description, @PickDropLocationName, @IsPort, @LAT, @LON, @CityID, @RegionID)

      SET       @PickDropID                    = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    PickDropLocation
      SET       PickDropCode                   = COALESCE(@PickDropCode,PickDropCode),
                AreaID                         = COALESCE(@AreaID,AreaID),
                Address                        = COALESCE(@Address,Address),
                ProvinceID                     = COALESCE(@ProvinceID,ProvinceID),
                LocationTypeID                 = COALESCE(@LocationTypeID,LocationTypeID),
                OwnerID                        = COALESCE(@OwnerID,OwnerID),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified),
                CreatedByUserID                = COALESCE(@CreatedByUserID,CreatedByUserID),
                ModifiedByUserID               = COALESCE(@ModifiedByUserID,ModifiedByUserID),
                IsActive                       = COALESCE(@IsActive,IsActive),
                Description                    = COALESCE(@Description,Description),
                PickDropLocationName           = COALESCE(@PickDropLocationName,PickDropLocationName),
                IsPort                         = COALESCE(@IsPort,IsPort),
                LAT                            = COALESCE(@LAT,LAT),
                LON                            = COALESCE(@LON,LON),
                CityID                         = COALESCE(@CityID,CityID),
                RegionID                       = COALESCE(@RegionID,RegionID)
                
      WHERE     PickDropID                     = @PickDropID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    PickDropLocation
      WHERE     PickDropID                     = @PickDropID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, PickDropID, PickDropCode, AreaID, Address, ProvinceID, LocationTypeID, OwnerID, DateCreated, DateModified, CreatedByUserID, ModifiedByUserID, IsActive, Description, PickDropLocationName, IsPort, LAT, LON, CityID, RegionID
      FROM      PickDropLocation
      WHERE     PickDropID                                        = COALESCE(@PickDropID,PickDropID)
      AND       COALESCE(PickDropCode,'X')                        = COALESCE(@PickDropCode,COALESCE(PickDropCode,'X'))
      AND       COALESCE(AreaID,0)                                = COALESCE(@AreaID,COALESCE(AreaID,0))
      AND       COALESCE(Address,'X')                             = COALESCE(@Address,COALESCE(Address,'X'))
      AND       COALESCE(ProvinceID,0)                            = COALESCE(@ProvinceID,COALESCE(ProvinceID,0))
      AND       COALESCE(LocationTypeID,0)                        = COALESCE(@LocationTypeID,COALESCE(LocationTypeID,0))
      AND       COALESCE(OwnerID,0)                               = COALESCE(@OwnerID,COALESCE(OwnerID,0))
      AND       COALESCE(DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(DateCreated,GETDATE()))
      AND       COALESCE(DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(DateModified,GETDATE()))
      AND       COALESCE(CreatedByUserID,0)                       = COALESCE(@CreatedByUserID,COALESCE(CreatedByUserID,0))
      AND       COALESCE(ModifiedByUserID,0)                      = COALESCE(@ModifiedByUserID,COALESCE(ModifiedByUserID,0))
      AND       COALESCE(IsActive,0)                              = COALESCE(@IsActive,COALESCE(IsActive,0))
      AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
      AND       COALESCE(PickDropLocationName,'X')                = COALESCE(@PickDropLocationName,COALESCE(PickDropLocationName,'X'))
      AND       COALESCE(IsPort,0)                                = COALESCE(@IsPort,COALESCE(IsPort,0))
      AND       COALESCE(LAT,'X')                                 = COALESCE(@LAT,COALESCE(LAT,'X'))
      AND       COALESCE(LON,'X')                                 = COALESCE(@LON,COALESCE(LON,'X'))
      AND       COALESCE(CityID,0)                                = COALESCE(@CityID,COALESCE(CityID,0))
      AND       COALESCE(RegionID,0)                              = COALESCE(@RegionID,COALESCE(RegionID,0))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_PickDropLocation---------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[usp_Product]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Product                                                                         ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  Kamran Athar Janweri                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Friday, 10 May 2019 16:06:17:423                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Product](@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                             @ID                             bigint          = NULL OUTPUT, 
                             @Code                           nvarchar(50)    = NULL,
                             @Name                           nvarchar(50)    = NULL,
                             @PackageTypeId                  bigint          = NULL,
                             @Category                       nvarchar(50)    = NULL,
                             @Gener                          nvarchar(50)    = NULL,
                             @Nature                         nvarchar(50)    = NULL,
                             @DimensionUnit                  nvarchar(50)    = NULL,
                             @Weight                         float(53)       = NULL,
                             @Description                    nvarchar(200)   = NULL,
                             @Status                         bit             = NULL,
                             @CreatedBy                      bigint          = NULL,
                             @CreatedDate                    datetime        = NULL,
                             @ModifiedBy                     bigint          = NULL,
                             @ModifiedDate                   datetime        = NULL,
                             @Width                          float(53)       = NULL,
                             @Height                         float(53)       = NULL,
                             @Unit                           float(53)       = NULL,
                             @Volume                         float(53)       = NULL,
                             @Length                         float(53)       = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Product(Code,  Name,  PackageTypeId,  Category,  Gener,  Nature,  DimensionUnit,  Weight,  Description,  Status,  CreatedBy,  CreatedDate,  ModifiedBy,  ModifiedDate,  Width,  Height,  Unit,  Volume,  Length)
      VALUES                ([dbo].[GetNextProductCode](), @Name, @PackageTypeId, @Category, @Gener, @Nature, @DimensionUnit, @Weight, @Description, @Status, @CreatedBy, @CreatedDate, @ModifiedBy, @ModifiedDate, @Width, @Height, @Unit, @Volume, @Length)

      SET       @ID                            = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Product
      SET       --Code                           = COALESCE(@Code,Code),
                Name                           = COALESCE(@Name,Name),
                PackageTypeId                  = COALESCE(@PackageTypeId,PackageTypeId),
                Category                       = COALESCE(@Category,Category),
                Gener                          = COALESCE(@Gener,Gener),
                Nature                         = COALESCE(@Nature,Nature),
                DimensionUnit                  = COALESCE(@DimensionUnit,DimensionUnit),
                Weight                         = COALESCE(@Weight,Weight),
                Description                    = COALESCE(@Description,Description),
                Status                         = COALESCE(@Status,Status),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
                Width                          = COALESCE(@Width,Width),
                Height                         = COALESCE(@Height,Height),
                Unit                           = COALESCE(@Unit,Unit),
                Volume                         = COALESCE(@Volume,Volume),
                Length                         = COALESCE(@Length,Length)
                
      WHERE     ID                             = @ID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Product
      WHERE     ID                             = @ID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, P.*,PackageType.PackageTypeName
      FROM      Product P
	  left JOIN PackageType on P.PackageTypeID=PackageType.PackageTypeID 
	  order by  Id    desc
      --WHERE     ID                                                = COALESCE(@ID,ID)
      --AND       COALESCE(Code,'X')                                = COALESCE(@Code,COALESCE(Code,'X'))
      --AND       COALESCE(Name,'X')                                = COALESCE(@Name,COALESCE(Name,'X'))
      --AND       COALESCE(PackageTypeId,0)                         = COALESCE(@PackageTypeId,COALESCE(PackageTypeId,0))
      --AND       COALESCE(Category,'X')                            = COALESCE(@Category,COALESCE(Category,'X'))
      --AND       COALESCE(Gener,'X')                               = COALESCE(@Gener,COALESCE(Gener,'X'))
      --AND       COALESCE(Nature,'X')                              = COALESCE(@Nature,COALESCE(Nature,'X'))
      --AND       COALESCE(DimensionUnit,'X')                       = COALESCE(@DimensionUnit,COALESCE(DimensionUnit,'X'))
      --AND       Weight                                            = COALESCE(@Weight,Weight)
      --AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
      --AND       COALESCE(Status,0)                                = COALESCE(@Status,COALESCE(Status,0))
      --AND       COALESCE(CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(CreatedBy,0))
      --AND       COALESCE(CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(CreatedDate,GETDATE()))
      --AND       COALESCE(ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(ModifiedBy,0))
      --AND       COALESCE(ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(ModifiedDate,GETDATE()))
      --AND       Width                                             = COALESCE(@Width,Width)
      --AND       Height                                            = COALESCE(@Height,Height)
      --AND       Unit                                              = COALESCE(@Unit,Unit)
      --AND       Volume                                            = COALESCE(@Volume,Volume)
      --AND       Length                                            = COALESCE(@Length,Length)
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Product------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_ReportsType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_ReportsType                                                                                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Saturday, 07 Sep 2019 12:52:58:103                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_ReportsType](@Action_Type                    numeric(10),
                                 @p_Success                      bit             = 1    OUTPUT,
                                 @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                 @ReportId                       int             = NULL OUTPUT, 
                                 @ReportName                     nvarchar(50)    = NULL,
                                 @Active                         bit             = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO ReportsType(ReportName,  Active)
      VALUES                    (@ReportName, @Active)

      SET       @ReportId                      = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    ReportsType
      SET       ReportName                     = COALESCE(@ReportName,ReportName),
                Active                         = COALESCE(@Active,Active)
                
      WHERE     ReportId                       = @ReportId
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    ReportsType
      WHERE     ReportId                       = @ReportId
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, ReportId, ReportName, Active
      FROM      ReportsType
      WHERE     ReportId                                          = COALESCE(@ReportId,ReportId)
      AND       COALESCE(ReportName,'X')                          = COALESCE(@ReportName,COALESCE(ReportName,'X'))
      AND       COALESCE(Active,0)                                = COALESCE(@Active,COALESCE(Active,0))

	  Order By ReportName 
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_ReportsType--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_RoleBaseFormRight]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_RoleBaseFormRight                                                                                                            ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Wednesday, 01 Jan 2020 12:28:11:310                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_RoleBaseFormRight](@Action_Type                    numeric(10),
                                       @p_Success                      bit             = 1    OUTPUT,
                                       @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                       @Id                             bigint          = NULL OUTPUT, 
                                       @FormId                         bigint          = NULL,
                                       @RoleId                         bigint          = NULL,
                                       @Active                         bit             = NULL,
                                       @CreatedBy                      bigint          = NULL,
                                       @ModifiedBy                     bigint          = NULL,
                                       @CreatedDate                    datetime        = NULL,
                                       @ModifiedDate                   datetime        = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO RoleBaseFormRight(FormId,  RoleId,  Active,  CreatedBy,  ModifiedBy,  CreatedDate,  ModifiedDate)
      VALUES                          (@FormId, @RoleId, @Active, @CreatedBy, @ModifiedBy, @CreatedDate, @ModifiedDate)

      SET       @Id                            = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    RoleBaseFormRight
      SET       FormId                         = COALESCE(@FormId,FormId),
                RoleId                         = COALESCE(@RoleId,RoleId),
                Active                         = COALESCE(@Active,Active),
                CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),
                ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),
                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate)
                
      WHERE     Id                             = @Id
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    RoleBaseFormRight
      WHERE     Id                             = @Id
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, RB.*,Role.RoleName,NavMenu.FormName,NavMenu.Url
      FROM      RoleBaseFormRight AS RB
	  LEFT JOIN Role on RB.RoleId=Role.RoleID
	  LEFT JOIN NavMenu on RB.FormId= NavMenu.FormID
      WHERE     RB.Id                                                = COALESCE(@Id,RB.Id)
      AND       RB.FormId                                            = COALESCE(@FormId,RB.FormId)
      AND       RB.RoleId                                            = COALESCE(@RoleId,RB.RoleId)
      AND       RB.Active                                            = COALESCE(@Active,RB.Active)
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_RoleBaseFormRight--------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[usp_SearchBiltiesNotBilled]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_SearchBiltiesNotBilled](
@BiltyNo nvarchar(9) =null,
@DateFrom date=null,
@DateTo date=null,
@CustomerCode nvarchar(4)=null,
@CustomerName  nvarchar(50)=null,
@ManualBiltyNo nvarchar(100) =null,
@DA_NO nvarchar(100) =null
)
AS
BEGIN
SELECT 
OrderDetailId,ParentId,OrderID,	BiltyNo,BiltyNoDate,PaymentTerm,CustomerName,CustomerCode,CityName,	ReceiverName,Freight,
CreatedDate,ModifiedDate,
ChallanNo,ChallanDate,SUM(Quantity) Quantity,PartBilty,ManualBiltyNo,DA_NO,VehicleCode,NetWeight,AdditionalWeight,LocalFreight	
 FROM (
	SELECT distinct OPT.ItemId, OD.OrderDetailId,OD.ParentId, O.OrderID,OD.BiltyNo,OD.BiltyNoDate,CP.PaymentTerm,CP.CustomerName,
	CP.CustomerCode,C.CityName,OL.ReceiverName,OD.Freight,OD.CreatedDate,OD.ModifiedDate,ISNULL(OD.ChallanNo,0) 'ChallanNo' ,
	ISNULL(OD.ChallanDate,'2019-01-01') ChallanDate,OPT.Quantity Quantity,O.PartBilty,isnull(OD.ManualBiltyNo,'') ManualBiltyNo,ISNULL(OD.DA_No ,'') as DA_NO,
	ISNULL(V.RegNo,DC.VehicleNo) AS 'VehicleCode',ISNULL(OD.NetWeight,0) 'NetWeight',OD.AdditionalWeight,
	ISNULL(OD.LocalFreight,0) LocalFreight FROM [dbo].[Order] O

	INNER JOIN [OrderDetail] OD ON O.OrderID=OD.Orderid
	INNER JOIN [CustomerProfile] CP  ON O.CustomerCompanyId=CP.CustomerId   
	LEFT JOIN [OrderLocations] OL on OD.OrderDetailId=OL.OrderDetailId
	
	left JOIN [OrderPackageTypes] OPT on OD.OrderDetailId=OPT.OrderDetailId and OPT.ProfileDetailId is not null
	LEFT JOIN [City] C on OL.DropLocationId=C.CityID
	LEFT JOIN DriverChallan DC on OD.ChallanNo = DC.ChallanNo
	LEFT JOIN  Vehicle V on DC.VehicleId = v.VehicleID

WHERE 
CP.OwnCompanyId <>0 and OD.InvoiceNo is null and 
OD.BiltyNoDate BETWEEN @DateFrom and @DateTo
AND 
OD.BiltyNo= COALESCE(@BiltyNo,OD.BiltyNo)
AND 
ISNULL(OD.ManualBiltyNo,'') = (CASE WHEN @ManualBiltyNo is null THEN ISNULL(OD.ManualBiltyNo,'') 
                        
                        ELSE @ManualBiltyNo END)

AND 
ISNULL(OD.DA_No,'') = (CASE WHEN @DA_NO is null THEN ISNULL(OD.DA_No,'') 
                        
                        ELSE @DA_NO END)

AND CP.CustomerCode = COALESCE(@CustomerCode,CP.CustomerCode)
AND CP.CustomerName                                = COALESCE(@CustomerName,CP.CustomerName)
--AND (OD.ManualBiltyNo = COALESCE(@GeneralSearch,OD.ManualBiltyNo)
--OR OD.DA_No = COALESCE(@GeneralSearch,OD.DA_No)
--)




) AS tbl
--WHERE UPPER(tbl.PaymentTerm) ='PAID'

-- (
-- 
--
--
--)
GROUP by OrderDetailId,ParentId,OrderID,BiltyNo,BiltyNoDate,CustomerName,CustomerCode,CityName,ReceiverName,Freight,ChallanNo,ChallanDate,CreatedDate,
ModifiedDate,PaymentTerm,PartBilty,ManualBiltyNo,DA_No,VehicleCode,NetWeight,AdditionalWeight,LocalFreight
order by BiltyNoDate 
END









GO
/****** Object:  StoredProcedure [dbo].[usp_SearchBroker]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  CREATE PROCEDURE [dbo].[usp_SearchBroker](@SEARCH nvarchar(200))
  AS
  BEGIN

  SELECT  ID,CODE,NAME,PHONE,NIC,DESCRIPTION FROM BROKERS
  WHERE
  ISACTIVE=1 
  AND (UPPER(CODE) like '%'+UPPER(@SEARCH)+'%'
  OR UPPER(NAME)  like '%'+UPPER(@SEARCH)+'%'
  OR UPPER(PHONE)  like '%'+UPPER(@SEARCH)+'%'
  OR UPPER(NIC) like '%'+UPPER(@SEARCH)+'%')

  END



GO
/****** Object:  StoredProcedure [dbo].[usp_SearchChallanList]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE  PROCEDURE [dbo].[usp_SearchChallanList](

@StationFrom bigint=0,
@StationTo	 bigint=0,
@DateFrom    datetime=null,
@DateTo		 datetime=null,
@VehicleId   nvarchar(10)=null
	)
AS 
BEGIN
   select DropStation.Name 'DropStation', C.CompanyName 'CustomerName',C.CompanyCODE 'CustomerCode', od.BiltyNo,od.BiltyNoDate,DC.ChallanNo,ISNULL(V.VehicleCode,DC.VehicleNo) VehicleCode,ISNULL(D.Name,DC.DriverName) AS 'DriverName',D.CODE as 'DriverCode',DC.Mobile AS 'MobileNo',
  CASE WHEN OD.ParentId=0 THEN 'FULL BILTY' ELSE'HALF BILTY'END AS BiltyType,DC.ChallanDate,DC.CreatedDate,DC.ModifiedDate
  
   from OrderDetail OD
  INNER JOIN  Company C ON OD.CustomerCode=C.CompanyCode
  
  INNER JOIN DriverChallan DC ON OD.ChallanNo=DC.ChallanNo
  LEFT JOIN Vehicle V ON DC.VehicleId=V.VehicleID
  LEFT JOIN DRIVER D ON DC.DRIVERID=D.ID
  INNER JOIN OrderLocations OL on OD.OrderDetailId=OL.OrderDetailId
  INNER JOIN Stations DropStation  on OL.StationTo=DropStation.ID
  order by dc.ChallanId desc
END





GO
/****** Object:  StoredProcedure [dbo].[usp_SearchCompany]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_SearchCompany](@search nvarchar(max))
AS 
BEGIN
SELECT  C.CompanyID,C.CompanyCode,C.CompanyName,CP.PaymentTerm,OC.CompanyName AS OwnCompany FROM Company C
inner join CustomerProfile CP on C.CompanyID=CP.CustomerId
inner join OwnCompany OC on CP.OwnCompanyId=OC.CompanyID

WHERE 
UPPER(C.CompanyName) like '%'+@search+'%'
OR C.CompanyCode like '%'+@search+'%'
OR UPPER(OC.CompanyName) like '%'+@search+'%'
END



GO
/****** Object:  StoredProcedure [dbo].[usp_SearchDriver]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE  PROCEDURE [dbo].[usp_SearchDriver](

@Search nvarchar(50)=null 	)
AS 
BEGIN

 SELECT  CODE,NAME,CELLNO,NIC, NICIssueDATE,NICExpiryDate,LicenseNo,LicenseCategory,LicenseIssueDate,LicenseExpiryDate,LicenseStatus,ID from driver
  WHERE Active=1 and (
  CODE like '%'+@Search+'%'
  OR NAME like '%'+@Search+'%'
  OR CELLNO like '%'+@Search+'%'
  OR NIC like '%'+@Search+'%'
  OR LicenseNo like '%'+@Search+'%'
  OR LicenseCategory like '%'+@Search+'%'
  OR LicenseStatus like '%'+@Search+'%' )

END



GO
/****** Object:  StoredProcedure [dbo].[usp_SearchManualBilty]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_SearchManualBilty](
@BiltyNo nvarchar(9) =null,
@DateFrom date=null,
@DateTo date=null,
@CustomerCode nvarchar(4)=null,
@CustomerName  nvarchar(50)=null,
@ManualBiltyNo nvarchar(100) =null,
@DA_NO nvarchar(100) =null
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT 
OrderDetailId,ParentId,OrderID,	BiltyNo,BiltyNoDate,PaymentTerm,CustomerName,CustomerCode,CityName,	ReceiverName,Freight,
CreatedDate,ModifiedDate,
ChallanNo,ChallanDate,SUM(Quantity) Quantity,PartBilty,ManualBiltyNo,DA_NO,VehicleCode,NetWeight,AdditionalWeight,LocalFreight	,CustomerId
 FROM (
	SELECT distinct OPT.ItemId, OD.OrderDetailId,OD.ParentId, O.OrderID,OD.BiltyNo,OD.BiltyNoDate,CP.PaymentTerm,CP.CustomerName,
	CP.CustomerCode,CP.CustomerId,C.CityName,OL.ReceiverName,OD.Freight,OD.CreatedDate,OD.ModifiedDate,ISNULL(OD.ChallanNo,0) 'ChallanNo' ,
	ISNULL(DC.ChallanDate,'') ChallanDate,OPT.Quantity Quantity,O.PartBilty,
	
	CASE  WHEN StatusID = 5 THEN 'CANCEL'  ELSE isnull(OD.ManualBiltyNo,'') END AS ManualBiltyNo,
	CASE  WHEN statusid = 5 THEN 'CANCEL'  ELSE ISNULL(OD.DA_No ,'') END AS DA_NO,
	
	ISNULL(V.RegNo,DC.VehicleNo) AS 'VehicleCode',ISNULL(OD.NetWeight,0) 'NetWeight',OD.AdditionalWeight,
	ISNULL(OD.LocalFreight,0) LocalFreight FROM [dbo].[Order] O

	INNER JOIN [OrderDetail] OD ON O.OrderID=OD.Orderid
	INNER JOIN [CustomerProfile] CP  ON O.CustomerCompanyId=CP.CustomerId
	LEFT JOIN [OrderLocations] OL on OD.OrderDetailId=OL.OrderDetailId
	
	left JOIN [OrderPackageTypes] OPT on OD.OrderDetailId=OPT.OrderDetailId and OPT.ProfileDetailId is not null
	LEFT JOIN [City] C on OL.DropLocationId=C.CityID
	LEFT JOIN DriverChallan DC on OD.ChallanNo = DC.ChallanNo
	LEFT JOIN  Vehicle V on DC.VehicleId = v.VehicleID

WHERE 
CP.OwnCompanyId <>0 and
OD.BiltyNoDate BETWEEN @DateFrom and @DateTo
AND 
(OD.BiltyNo= COALESCE(@BiltyNo,OD.BiltyNo)
OR 
OD.DA_No = @BiltyNo)
AND 
ISNULL(OD.ManualBiltyNo,'') = (CASE WHEN @ManualBiltyNo is null THEN ISNULL(OD.ManualBiltyNo,'') 
                        
                        ELSE @ManualBiltyNo END)

AND 
ISNULL(OD.DA_No,'') = (CASE WHEN @DA_NO is null THEN ISNULL(OD.DA_No,'') 
                        
                        ELSE @DA_NO END)

AND CP.CustomerCode = COALESCE(@CustomerCode,CP.CustomerCode)
AND CP.CustomerName                                = COALESCE(@CustomerName,CP.CustomerName)
--AND (OD.ManualBiltyNo = COALESCE(@GeneralSearch,OD.ManualBiltyNo)
--OR OD.DA_No = COALESCE(@GeneralSearch,OD.DA_No)
--)




) AS tbl
-- (
-- 
--
--
--)
GROUP by OrderDetailId,ParentId,OrderID,BiltyNo,BiltyNoDate,CustomerName,CustomerCode,CityName,ReceiverName,Freight,ChallanNo,ChallanDate,CreatedDate,
ModifiedDate,PaymentTerm,PartBilty,ManualBiltyNo,DA_No,VehicleCode,NetWeight,AdditionalWeight,LocalFreight,CustomerId
order by BiltyNoDate desc
END








GO
/****** Object:  StoredProcedure [dbo].[usp_SearchManualBilty_1]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_SearchManualBilty_1](
@BiltyNo nvarchar(9) =null,
@DateFrom date=null,
@DateTo date=null,
@CustomerCode nvarchar(4)=null,
@CustomerName  nvarchar(50)=null,
@GeneralSearch nvarchar(100) =null)
AS
BEGIN
SELECT 
OrderDetailId,ParentId,OrderID,	BiltyNo,BiltyNoDate,PaymentTerm,CustomerName,CustomerCode,CityName,	ReceiverName,Freight,
CreatedDate,ModifiedDate,
ChallanNo,ChallanDate,SUM(Quantity) Quantity,PartBilty,ManualBiltyNo,DA_NO,VehicleCode,NetWeight,AdditionalWeight,LocalFreight	
 FROM (
	SELECT distinct OPT.ItemId, OD.OrderDetailId,OD.ParentId, O.OrderID,OD.BiltyNo,OD.BiltyNoDate,CP.PaymentTerm,CP.CustomerName,
	CP.CustomerCode,C.CityName,OL.ReceiverName,OD.Freight,OD.CreatedDate,OD.ModifiedDate,ISNULL(OD.ChallanNo,0) 'ChallanNo' ,
	ISNULL(OD.ChallanDate,'2019-01-01') ChallanDate,OPT.Quantity Quantity,O.PartBilty,OD.ManualBiltyNo,ISNULL(OD.DA_No ,'') as DA_NO,
	ISNULL(V.VehicleCode,DC.VehicleNo) AS 'VehicleCode',ISNULL(OD.NetWeight,0) 'NetWeight',OD.AdditionalWeight,
	ISNULL(OD.LocalFreight,0) LocalFreight FROM [dbo].[Order] O

	INNER JOIN [OrderDetail] OD ON O.OrderID=OD.Orderid
	INNER JOIN [CustomerProfile] CP  ON O.CustomerCompanyId=CP.CustomerId
	LEFT JOIN [OrderLocations] OL on OD.OrderDetailId=OL.OrderDetailId
	
	left JOIN [OrderPackageTypes] OPT on OD.OrderDetailId=OPT.OrderDetailId and OPT.ProfileDetailId is not null
	LEFT JOIN [City] C on OL.DropLocationId=C.CityID
	LEFT JOIN DriverChallan DC on OD.ChallanNo = DC.ChallanNo
	LEFT JOIN  Vehicle V on DC.VehicleId = v.VehicleID

WHERE 
CP.OwnCompanyId <>0 and
OD.BiltyNoDate BETWEEN @DateFrom and @DateTo
AND 
OD.BiltyNo= COALESCE(@BiltyNo,OD.BiltyNo)
AND CP.CustomerCode = COALESCE(@CustomerCode,CP.CustomerCode)
AND CP.CustomerName                                = COALESCE(@CustomerName,CP.CustomerName)
--AND (OD.ManualBiltyNo = COALESCE(@GeneralSearch,OD.ManualBiltyNo)
--OR OD.DA_No = COALESCE(@GeneralSearch,OD.DA_No)
--)




) AS tbl
-- (
-- 
--
--
--)
GROUP by OrderDetailId,ParentId,OrderID,BiltyNo,BiltyNoDate,CustomerName,CustomerCode,CityName,ReceiverName,Freight,ChallanNo,ChallanDate,CreatedDate,
ModifiedDate,PaymentTerm,PartBilty,ManualBiltyNo,DA_No,VehicleCode,NetWeight,AdditionalWeight,LocalFreight
order by BiltyNoDate desc
END








GO
/****** Object:  StoredProcedure [dbo].[usp_SearchManualBilty_Backup]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_SearchManualBilty_Backup](
@BiltyNo nvarchar(9) =null,
@DateFrom date=null,
@DateTo date=null,
@CustomerCode nvarchar(4)=null,
@CustomerName  nvarchar(50)=null)
AS
BEGIN

SELECT OD.OrderDetailId,OD.ParentId, O.OrderID,OD.BiltyNo,OD.BiltyNoDate,CP.PaymentTerm,CP.CustomerName,CP.CustomerCode,C.CityName,OL.ReceiverName,OD.Freight,OD.CreatedDate,OD.ModifiedDate,ISNULL(OD.ChallanNo,0) 'ChallanNo' ,ISNULL(OD.ChallanDate,'2019-01-01') ChallanDate,ISNULL(SUM(OPT.Quantity),0) Quantity,O.PartBilty,OD.ManualBiltyNo,ISNULL(OD.DA_No ,'') as DA_NO,ISNULL(V.VehicleCode,DC.VehicleNo) AS 'VehicleCode',ISNULL(OD.NetWeight,0) 'NetWeight',OD.AdditionalWeight,ISNULL(OD.LocalFreight,0) LocalFreight FROM [dbo].[Order] O

INNER JOIN [OrderDetail] OD ON O.OrderID=OD.Orderid
INNER JOIN [CustomerProfile] CP  ON O.CustomerCompanyId=CP.CustomerId
LEFT JOIN [OrderLocations] OL on OD.OrderDetailId=OL.OrderDetailId
left JOIN [OrderPackageTypes] OPT on OD.OrderDetailId=OPT.OrderDetailId and OPT.ProfileDetailId is not null
LEFT JOIN [City] C on OL.DropLocationId=C.CityID
LEFT JOIN DriverChallan DC on OD.ChallanNo = DC.ChallanNo
LEFT JOIN  Vehicle V on DC.VehicleId = v.VehicleID
--LEFT join MCBBranches MCB on OL.ReceiverName=MCB.BranchName

WHERE 
CP.OwnCompanyId <>0 and
OD.BiltyNoDate BETWEEN @DateFrom and @DateTo
AND 
OD.BiltyNo= COALESCE(@BiltyNo,OD.BiltyNo)
AND CP.CustomerCode = COALESCE(@CustomerCode,CP.CustomerCode)
AND CP.CustomerName                                = COALESCE(@CustomerName,CP.CustomerName)
-- (
-- 
--
--
--)
GROUP by OD.OrderDetailId,OD.ParentId,O.OrderID,OD.BiltyNo,OD.BiltyNoDate,CP.CustomerName,CP.CustomerCode,C.CityName,OL.ReceiverName,OD.Freight,OD.ChallanNo,OD.ChallanDate,OD.CreatedDate,OD.ModifiedDate,CP.PaymentTerm,O.PartBilty,OD.ManualBiltyNo,OD.DA_No,V.VehicleCode,DC.VehicleNo,OD.NetWeight,OD.AdditionalWeight,OD.LocalFreight

order by OD.BiltyNoDate desc
END







GO
/****** Object:  StoredProcedure [dbo].[usp_SearchProduct]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_SearchProduct](
@Search nvarchar(100) =null,

@CompanyCode nvarchar(10) =null,
@LocationFrom  bigint=null,
@LocationTo  bigint=null)
AS
BEGIN

SELECT PROD.ID,PROD.Name,PROD.Code,PT.PackageTypeName,PROD.PackageTypeId,CPD.Rate,CPD.DoorStepRate,cp.CustomerCode,CPD.RateType,CPD.WeightPerUnit,CPD.ProfileDetail,ISNULL(CPD.AdditionCharges,0) AdditionCharges,ISNULL(CPD.LabourCharges ,0) LabourCharges
FROM PRODUCT PROD
inner join PackageType PT on PROD.PackageTypeId=PT.PackageTypeId
inner join CustomerProfileDetail CPD on PROD.ID= CPD.ProductId
inner join CustomerProfile CP on CPD.ProfileId=CP.ProfileId

WHERE 
(
UPPER(PROD.Name) like '%'+@Search+'%'
OR UPPER(PROD.Code) like '%'+@Search+'%'
OR UPPER(PT.PackageTypeName) like '%'+@Search+'%'
)
AND 
UPPER(cp.CustomerCode)=UPPER(@CompanyCode)
--AND CPD.LocationFrom=COALESCE(@LocationFrom,CPD.LocationFrom)
AND CPD.LocationTo=COALESCE(@LocationTo,CPD.LocationTo)
order by PROD.Name 
END





GO
/****** Object:  StoredProcedure [dbo].[usp_SearchVehicle]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_SearchVehicle](@Search as nvarchar(1000))
  AS 
  BEGIN

  SELECT VEHICLEID,REGNO,ENGINENO,LENGTH,WIDTH,HEIGHT,VEHICLETYPEID,VEHICLEMODEL,VEHICLECOLOR,BODYTYPE FROM VEHICLE

  WHERE ISACTIVE=1 and (
  
  REGNO LIKE '%'+@Search+'%' OR
  BODYTYPE LIKE '%'+@Search+'%' OR
  VEHICLEMODEL LIKE '%'+@Search+'%' 
  
  )
  ORDER BY VEHICLECODE
  END



GO
/****** Object:  StoredProcedure [dbo].[usp_ShipmentType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_ShipmentType                                                                                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Wednesday, 31 Oct 2018 09:20:06:680                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_ShipmentType](@Action_Type                    numeric(10),
                                  @p_Success                      bit             = 1    OUTPUT,
                                  @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                  @ShipmentType_ID                int             = NULL OUTPUT, 
                                  @ShipmentTypeDetail             nvarchar(150)   = NULL,
                                  @ShipmentType                   nvarchar(50)    = NULL,
                                  @Active                         bit             = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO ShipmentType(ShipmentTypeDetail,  ShipmentType,  Active)
      VALUES                     (@ShipmentTypeDetail, @ShipmentType, @Active)

      SET       @ShipmentType_ID               = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    ShipmentType
      SET       ShipmentTypeDetail             = COALESCE(@ShipmentTypeDetail,ShipmentTypeDetail),
                ShipmentType                   = COALESCE(@ShipmentType,ShipmentType),
                Active                         = COALESCE(@Active,Active)
                
      WHERE     ShipmentType_ID                = @ShipmentType_ID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    ShipmentType
      WHERE     ShipmentType_ID                = @ShipmentType_ID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, ShipmentType_ID, ShipmentTypeDetail, ShipmentType, Active
      FROM      ShipmentType
      WHERE     ShipmentType_ID                                   = COALESCE(@ShipmentType_ID,ShipmentType_ID)
     -- AND       COALESCE(ShipmentTypeDetail,'X')                  = COALESCE(@ShipmentTypeDetail,COALESCE(ShipmentTypeDetail,'X'))
      --AND       COALESCE(ShipmentType,'X')                        = COALESCE(@ShipmentType,COALESCE(ShipmentType,'X'))
      AND       COALESCE(Active,0)                                = 1
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_ShipmentType-------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_Stations]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Stations                                                                                                                     ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Tuesday, 02 Apr 2019 12:21:30:513                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Stations](@Action_Type                    numeric(10),
                              @p_Success                      bit             = 1    OUTPUT,
                              @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                              @ID                             bigint          = NULL OUTPUT, 
                              @Code                           nvarchar(50)    = NULL,
                              @Name                           nvarchar(50)    = NULL,
                              @CityID                         bigint          = NULL,
                              @ContactPerson                  nvarchar(50)    = NULL,
                              @SecondaryContactPerson         nvarchar(50)    = NULL,
                              @ContactNo                      bigint          = NULL,
                              @SecondaryContactNo             bigint          = NULL,
                              @Address                        nvarchar(100)   = NULL,
                              @Description                    nvarchar(100)   = NULL,
                              @isActive                       bit             = NULL,
                              @CreatedByID                    bigint          = NULL,
                              @ModifiedByID                   bigint          = NULL,
                              @DateCreated                    datetime        = NULL,
                              @DateModified                   datetime        = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Stations(Code,  Name,  CityID,  ContactPerson,  SecondaryContactPerson,  ContactNo,  SecondaryContactNo,  Address,  Description,  isActive,  CreatedByID,  ModifiedByID,  DateCreated,  DateModified)
      VALUES                 (@Code, @Name, @CityID, @ContactPerson, @SecondaryContactPerson, @ContactNo, @SecondaryContactNo, @Address, @Description, @isActive, @CreatedByID, @ModifiedByID, @DateCreated, @DateModified)

      SET       @ID                            = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Stations
      SET       Code                           = COALESCE(@Code,Code),
                Name                           = COALESCE(@Name,Name),
                CityID                         = COALESCE(@CityID,CityID),
                ContactPerson                  = COALESCE(@ContactPerson,ContactPerson),
                SecondaryContactPerson         = COALESCE(@SecondaryContactPerson,SecondaryContactPerson),
                ContactNo                      = COALESCE(@ContactNo,ContactNo),
                SecondaryContactNo             = COALESCE(@SecondaryContactNo,SecondaryContactNo),
                Address                        = COALESCE(@Address,Address),
                Description                    = COALESCE(@Description,Description),
                isActive                       = COALESCE(@isActive,isActive),
                CreatedByID                    = COALESCE(@CreatedByID,CreatedByID),
                ModifiedByID                   = COALESCE(@ModifiedByID,ModifiedByID),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified)
                
      WHERE     ID                             = @ID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Stations
      WHERE     ID                             = @ID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, Stations.*,City.CityName

      FROM      Stations
	  inner join City on Stations.cityid = City.CityID
      WHERE     ID                                                = COALESCE(@ID,ID)
      AND       COALESCE(Code,'X')                                = COALESCE(@Code,COALESCE(Code,'X'))
      AND       COALESCE(Name,'X')                                = COALESCE(@Name,COALESCE(Name,'X'))
      AND       COALESCE(Stations.CityID,0)                                = COALESCE(@CityID,COALESCE(Stations.CityID,0))
     
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Stations-----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_Status]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Status                                                                                                                       ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Tuesday, 01 Dec 2020 11:00:51:867                                                   ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Status](@Action_Type                    numeric(10),
                            @p_Success                      bit             = 1    OUTPUT,
                            @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                            @StatusID                       int             = NULL OUTPUT, 
                            @StatusCode                     nvarchar(10)    = NULL,
                            @StatusName                     nvarchar(50)    = NULL,
                            @Color                          nvarchar(20)    = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Status(StatusCode,  StatusName,  Color)
      VALUES               (@StatusCode, @StatusName, @Color)

      SET       @StatusID                      = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Status
      SET       StatusCode                     = COALESCE(@StatusCode,StatusCode),
                StatusName                     = COALESCE(@StatusName,StatusName),
                Color                          = COALESCE(@Color,Color)
                
      WHERE     StatusID                       = @StatusID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Status
      WHERE     StatusID                       = @StatusID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, StatusID, StatusCode, StatusName, Color
      FROM      Status
      WHERE     StatusID                                          = COALESCE(@StatusID,StatusID)
      AND       StatusCode                                        = COALESCE(@StatusCode,StatusCode)
      AND       StatusName                                        = COALESCE(@StatusName,StatusName)
      AND       COALESCE(Color,'X')                               = COALESCE(@Color,COALESCE(Color,'X'))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Status-------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  StoredProcedure [dbo].[usp_StockNotTransited]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_StockNotTransited](
@BiltyNo nvarchar(9) =null,
@DateFrom date=null,
@DateTo date=null,
@CustomerCode nvarchar(4)=null,
@CustomerName  nvarchar(50)=null,
@ManualBiltyNo nvarchar(100) =null,
@DA_NO nvarchar(100) =null
)
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT 
OrderDetailId,ParentId,OrderID,	BiltyNo,BiltyNoDate,PaymentTerm,CustomerName,CustomerCode,CityName,	ReceiverName,Freight,
CreatedDate,ModifiedDate,
ChallanNo,ChallanDate,SUM(ISNULL(Quantity,0)) Quantity,PartBilty,ManualBiltyNo,DA_NO,VehicleCode,NetWeight,AdditionalWeight,LocalFreight	
 FROM (
	SELECT distinct OPT.ItemId, OD.OrderDetailId,OD.ParentId, O.OrderID,OD.BiltyNo,OD.BiltyNoDate,CP.PaymentTerm,CP.CustomerName,
	CP.CustomerCode,C.CityName,OL.ReceiverName,OD.Freight,OD.CreatedDate,OD.ModifiedDate,ISNULL(OD.ChallanNo,0) 'ChallanNo' ,
	ISNULL(DC.ChallanDate,'') ChallanDate,OPT.Quantity Quantity,O.PartBilty,isnull(OD.ManualBiltyNo,'') ManualBiltyNo,ISNULL(OD.DA_No ,'') as DA_NO,
	ISNULL(V.RegNo,DC.VehicleNo) AS 'VehicleCode',ISNULL(OD.NetWeight,0) 'NetWeight',OD.AdditionalWeight,
	ISNULL(OD.LocalFreight,0) LocalFreight FROM [dbo].[Order] O

	INNER JOIN [OrderDetail] OD ON O.OrderID=OD.Orderid
	INNER JOIN [CustomerProfile] CP  ON O.CustomerCompanyId=CP.CustomerId
	LEFT JOIN [OrderLocations] OL on OD.OrderDetailId=OL.OrderDetailId
	
	left JOIN [OrderPackageTypes] OPT on OD.OrderDetailId=OPT.OrderDetailId and OPT.ProfileDetailId is not null
	LEFT JOIN [City] C on OL.DropLocationId=C.CityID
	LEFT JOIN DriverChallan DC on OD.ChallanNo = DC.ChallanNo
	LEFT JOIN  Vehicle V on DC.VehicleId = v.VehicleID

WHERE OD.statusID <>5 and 
(OD.ParentId<2 and  OD.ChallanNo is null OR OD.ParentId >1  and OD.ChallanNo is not null) and 
CP.OwnCompanyId <>0 and
OD.BiltyNoDate BETWEEN @DateFrom and @DateTo
AND 
OD.BiltyNo= COALESCE(@BiltyNo,OD.BiltyNo)
AND 
ISNULL(OD.ManualBiltyNo,'') = (CASE WHEN @ManualBiltyNo is null THEN ISNULL(OD.ManualBiltyNo,'') 
                        
                        ELSE @ManualBiltyNo END)

AND 
ISNULL(OD.DA_No,'') = (CASE WHEN @DA_NO is null THEN ISNULL(OD.DA_No,'') 
                        
                        ELSE @DA_NO END)

AND CP.CustomerCode = COALESCE(@CustomerCode,CP.CustomerCode)
AND CP.CustomerName                                = COALESCE(@CustomerName,CP.CustomerName)
--AND (OD.ManualBiltyNo = COALESCE(@GeneralSearch,OD.ManualBiltyNo)
--OR OD.DA_No = COALESCE(@GeneralSearch,OD.DA_No)
--)




) AS tbl
-- (
-- 
--
--
--)
GROUP by OrderDetailId,ParentId,OrderID,BiltyNo,BiltyNoDate,CustomerName,CustomerCode,CityName,ReceiverName,Freight,ChallanNo,ChallanDate,CreatedDate,
ModifiedDate,PaymentTerm,PartBilty,ManualBiltyNo,DA_No,VehicleCode,NetWeight,AdditionalWeight,LocalFreight
order by BiltyNoDate ASC
END








GO
/****** Object:  StoredProcedure [dbo].[usp_UserAccounts]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_UserAccounts                                                                                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Friday, 02 Nov 2018 09:33:05:983                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_UserAccounts](@Action_Type                    numeric(10),
                                  @p_Success                      bit             = 1    OUTPUT,
                                  @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                  @UserID                         bigint          = NULL OUTPUT, 
                                  @UserName                       nvarchar(50)    = NULL,
                                  @UserPassword                   nvarchar(50)    = NULL,
                                  @GroupID                        bigint          = NULL,
                                  @CompanyID                      bigint          = NULL,
                                  @DepartmentID                   bigint          = NULL,
                                  @Active                         bit             = NULL,
                                  @CreatedBy                      bigint          = NULL,
                                  @CreatedDate                    datetime        = NULL,
                                  @ModifiedBy                     bigint          = NULL,
                                  @ModifiedDate                   datetime        = NULL,
                                  @DesignationID                  int             = 0,
                                  @RoleID                         int             = 0)
AS
BEGIN
 BEGIN TRY
  
 DECLARE @RecordCount INT
 SET @RecordCount= (SELECT COUNT (*) FROM UserAccounts U
inner join Groups G on U.GroupID=G.GroupID inner join Role R on U.RoleID=R.RoleID left join Company C on U.CompanyID=C.CompanyID
Left join Department D on U.DepartmentID=D.DepartID
where UPPER(U.UserName)=UPPER(@UserName) and  U.GroupID=@GroupID and U.CompanyID=@CompanyID and U.DepartmentID=@DepartmentID
)
IF @RecordCount >0
BEGIN
SET @p_Error_Message='Record already exists'
SET @p_Success = 0
END




  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
		  IF @RecordCount =0
				 BEGIN
				  INSERT    INTO UserAccounts(UserName,  UserPassword,  GroupID,  CompanyID,  DepartmentID,  Active,  CreatedBy,  CreatedDate,    DesignationID,  RoleID)
				  VALUES                     (@UserName, @UserPassword, @GroupID, @CompanyID, @DepartmentID, @Active, @CreatedBy, @CreatedDate,  @DesignationID, @RoleID)

				  SET       @UserID                        = @@IDENTITY
				   SET       @p_Success                    = 1
				  END
    END

  ELSE
   IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
	 IF @RecordCount =1 OR @RecordCount=0
				 BEGIN
				  UPDATE    UserAccounts
				  SET       UserName                       = COALESCE(@UserName,UserName),                UserPassword                   = COALESCE(@UserPassword,UserPassword),
							GroupID                        = COALESCE(@GroupID,GroupID),                CompanyID                      = COALESCE(@CompanyID,CompanyID),
							DepartmentID                   = COALESCE(@DepartmentID,DepartmentID),             Active                         = COALESCE(@Active,Active),
							CreatedBy                      = COALESCE(@CreatedBy,CreatedBy),                CreatedDate                    = COALESCE(@CreatedDate,CreatedDate),
							ModifiedBy                     = COALESCE(@ModifiedBy,ModifiedBy),                ModifiedDate                   = COALESCE(@ModifiedDate,ModifiedDate),
							DesignationID                  = COALESCE(@DesignationID,DesignationID),      
							RoleID                         = COALESCE(@RoleID,RoleID)
                
				  WHERE     UserID                         = @UserID
				 SET       @p_Success                    = 1    END
 END
  ELSE 
  IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      UPDATE    UserAccounts SET Active=0
      WHERE     UserID                         = @UserID
 SET       @p_Success                    = 1    END

  ELSE
   IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType,  ISNULL(G.GroupCode,'') AS GroupCode,ISNULL(G.GroupName,'') AS GroupName,ISNULL(C.CompanyCode,'') AS CompanyCode,ISNULL(C.CompanyName,'') AS CompanyName, 
		ISNULL(Dpt.DepartCode,'') AS DepartCode,ISNULL(Dpt.DepartName,'') AS DepartName, R.RoleName,D.DesignationName,U.* FROM UserAccounts U
		inner join OwnGroups G on U.GroupID=G.GroupID
		inner join Role R on U.RoleID=R.RoleID
		INNER JOIN Designation D on U.DesignationID=D.DesignationId
		left join OwnCompany C on U.CompanyID=C.CompanyID
		Left join OwnDepartment Dpt on U.DepartmentID=Dpt.DepartID
      WHERE  
	  --   U.UserID                                            = COALESCE(@UserID,UserID)
    --  AND 
	        U.UserName                                          = COALESCE(@UserName,UserName)
      AND       U.UserPassword                                      = COALESCE(@UserPassword,UserPassword)
      --AND       U.GroupID                                           = COALESCE(@GroupID,U.GroupID)
      --AND       COALESCE(U.CompanyID,0)                             = COALESCE(@CompanyID,COALESCE(U.CompanyID,0))
      --AND       COALESCE(U.DepartmentID,0)                          = COALESCE(@DepartmentID,COALESCE(U.DepartmentID,0))
      --AND       COALESCE(U.Active,0)                                = 1
      --AND       COALESCE(U.CreatedBy,0)                             = COALESCE(@CreatedBy,COALESCE(U.CreatedBy,0))
      --AND       COALESCE(U.CreatedDate,GETDATE())                   = COALESCE(@CreatedDate,COALESCE(U.CreatedDate,GETDATE()))
      --AND       COALESCE(U.ModifiedBy,0)                            = COALESCE(@ModifiedBy,COALESCE(U.ModifiedBy,0))
      --AND       COALESCE(U.ModifiedDate,GETDATE())                  = COALESCE(@ModifiedDate,COALESCE(U.ModifiedDate,GETDATE()))
      --AND       U.DesignationID                                     = COALESCE(@DesignationID,U.DesignationID)
      --AND       U.RoleID                                            = COALESCE(@RoleID,U.RoleID)
	  SET @p_Success=0
    END

	 ELSE
   IF  @Action_Type = 106 ------------------------> Select LOGIN CASE
    BEGIN
      SELECT    @Action_Type  AS ActionType,  ISNULL(G.GroupCode,'') AS GroupCode,ISNULL(G.GroupName,'') AS GroupName,ISNULL(C.CompanyCode,'') AS CompanyCode,ISNULL(C.CompanyName,'') AS CompanyName, 
		ISNULL(Dpt.DepartCode,'') AS DepartCode,ISNULL(Dpt.DepartName,'') AS DepartName, R.RoleName,D.DesignationName,U.* FROM UserAccounts U
		inner join OwnGroups G on U.GroupID=G.GroupID
		inner join Role R on U.RoleID=R.RoleID
		INNER JOIN Designation D on U.DesignationID=D.DesignationId
		left join OwnCompany C on U.CompanyID=C.CompanyID
		Left join OwnDepartment Dpt on U.DepartmentID=Dpt.DepartID
      WHERE   
	   
	      U.UserName                                          = COALESCE(@UserName,UserName)
      AND       U.UserPassword                                      = COALESCE(@UserPassword,UserPassword)
    	  SET @p_Success=0
		  SET @p_Error_Message='EXIST'
    END
  ELSE 
  IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1

	 IF @p_Success =1 OR @p_Error_Message='Record already exists' --SELECT AFTER CRUD OPERATION
	 BEGIN
	 SET @UserID=0
			  SELECT    @Action_Type  AS ActionType,  ISNULL(G.GroupCode,'') AS GroupCode,ISNULL(G.GroupName,'') AS GroupName,ISNULL(C.CompanyCode,'') AS CompanyCode,ISNULL(C.CompanyName,'') AS CompanyName, 
				ISNULL(Dpt.DepartCode,'') AS DepartCode,ISNULL(Dpt.DepartName,'') AS DepartName, R.RoleName,D.DesignationName,U.* FROM UserAccounts U
				inner join OwnGroups G on U.GroupID=G.GroupID
				inner join Role R on U.RoleID=R.RoleID
				INNER JOIN Designation D on U.DesignationID=D.DesignationId
				left join OwnCompany C on U.CompanyID=C.CompanyID
				Left join OwnDepartment Dpt on U.DepartmentID=Dpt.DepartID
			  WHERE    
			  U.Active=1
	 END
  END TRY
 
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
   
END
------------------------------------------End of Procedure: usp_UserAccounts-------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_Vehicle]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_Vehicle                                                                         ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  Kamran Athar Janweri                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Wednesday, 15 May 2019 12:31:07:577                                                 ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_Vehicle](@Action_Type                    numeric(10),
                             @p_Success                      bit             = 1    OUTPUT,
                             @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                             @VehicleID                      bigint          = NULL OUTPUT, 
                             @VehicleCode                    varchar(50)     = NULL,
                             @RegNo                          varchar(50)     = NULL,
                             @ChasisNo                       varchar(50)     = NULL,
                             @EngineNo                       varchar(50)     = NULL,
                             @Length                         float(53)       = NULL,
                             @Width                          float(53)       = NULL,
                             @Height                         float(53)       = NULL,
                             @DimensionUnitType              varchar(50)     = NULL,
                             @VehicleTypeID                  bigint          = NULL,
                             @Type                           varchar(50)     = NULL,
                             @VehicleModel                   varchar(50)     = NULL,
                             @VehicleColor                   varchar(50)     = NULL,
                             @BodyType                       varchar(50)     = NULL,
                             @ManufacturingYear              varchar(50)     = NULL,
                             @ManufacturerName               varchar(50)     = NULL,
                             @Picture                        varchar(50) = NULL,
                             @PurchasingDate                 datetime        = NULL,
                             @PurchasingAmount               bigint          = NULL,
                             @PurchaseFromName               varchar(50)     = NULL,
                             @PurchaseFromDetail             varchar(200)    = NULL,
                             @OwnerName                      varchar(50)     = NULL,
                             @OwnerContact                   varchar(50)     = NULL,
                             @OwnerNIC                       varchar(50)     = NULL,
                             @DateCreated                    datetime        = NULL,
                             @DateModified                   datetime        = NULL,
                             @CreatedByUserID                bigint          = NULL,
                             @ModifiedByUserID               bigint          = NULL,
                             @IsActive                       bit             = NULL,
                             @Description                    varchar(500)    = NULL,
                             @IsOwnVehicle                   bit             = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO Vehicle(VehicleCode,  RegNo,  ChasisNo,  EngineNo,  Length,  Width,  Height,  DimensionUnitType,  VehicleTypeID,  Type,  VehicleModel,  VehicleColor,  BodyType,  ManufacturingYear,  ManufacturerName,  Picture,  PurchasingDate,  PurchasingAmount,  PurchaseFromName,  PurchaseFromDetail,  OwnerName,  OwnerContact,  OwnerNIC,  DateCreated,  DateModified,  CreatedByUserID,  ModifiedByUserID,  IsActive,  Description,  IsOwnVehicle)
      VALUES                (@VehicleCode, @RegNo, @ChasisNo, @EngineNo, @Length, @Width, @Height, @DimensionUnitType, @VehicleTypeID, @Type, @VehicleModel, @VehicleColor, @BodyType, @ManufacturingYear, @ManufacturerName, @Picture, @PurchasingDate, @PurchasingAmount, @PurchaseFromName, @PurchaseFromDetail, @OwnerName, @OwnerContact, @OwnerNIC, @DateCreated, @DateModified, @CreatedByUserID, @ModifiedByUserID, @IsActive, @Description, @IsOwnVehicle)

      SET       @VehicleID                     = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    Vehicle
      SET       VehicleCode                    = COALESCE(@VehicleCode,VehicleCode),
                RegNo                          = COALESCE(@RegNo,RegNo),
                ChasisNo                       = COALESCE(@ChasisNo,ChasisNo),
                EngineNo                       = COALESCE(@EngineNo,EngineNo),
                Length                         = COALESCE(@Length,Length),
                Width                          = COALESCE(@Width,Width),
                Height                         = COALESCE(@Height,Height),
                DimensionUnitType              = COALESCE(@DimensionUnitType,DimensionUnitType),
                VehicleTypeID                  = COALESCE(@VehicleTypeID,VehicleTypeID),
                Type                           = COALESCE(@Type,Type),
                VehicleModel                   = COALESCE(@VehicleModel,VehicleModel),
                VehicleColor                   = COALESCE(@VehicleColor,VehicleColor),
                BodyType                       = COALESCE(@BodyType,BodyType),
                ManufacturingYear              = COALESCE(@ManufacturingYear,ManufacturingYear),
                ManufacturerName               = COALESCE(@ManufacturerName,ManufacturerName),
              --  Picture                        = COALESCE(@Picture,Picture),
                PurchasingDate                 = COALESCE(@PurchasingDate,PurchasingDate),
                PurchasingAmount               = COALESCE(@PurchasingAmount,PurchasingAmount),
                PurchaseFromName               = COALESCE(@PurchaseFromName,PurchaseFromName),
                PurchaseFromDetail             = COALESCE(@PurchaseFromDetail,PurchaseFromDetail),
                OwnerName                      = COALESCE(@OwnerName,OwnerName),
                OwnerContact                   = COALESCE(@OwnerContact,OwnerContact),
                OwnerNIC                       = COALESCE(@OwnerNIC,OwnerNIC),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified),
                CreatedByUserID                = COALESCE(@CreatedByUserID,CreatedByUserID),
                ModifiedByUserID               = COALESCE(@ModifiedByUserID,ModifiedByUserID),
                IsActive                       = COALESCE(@IsActive,IsActive),
                Description                    = COALESCE(@Description,Description),
                IsOwnVehicle                   = COALESCE(@IsOwnVehicle,IsOwnVehicle)
                
      WHERE     VehicleID                      = @VehicleID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    Vehicle
      WHERE     VehicleID                      = @VehicleID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, V.*,VehicleType.VehicleTypeName
      FROM      Vehicle V
	  left join VehicleType on V.VehicleTypeID= VehicleType.VehicleTypeID
	  order by VehicleCode 
      --WHERE     VehicleID                                         = COALESCE(@VehicleID,VehicleID)
      --AND       COALESCE(VehicleCode,'X')                         = COALESCE(@VehicleCode,COALESCE(VehicleCode,'X'))
      --AND       COALESCE(RegNo,'X')                               = COALESCE(@RegNo,COALESCE(RegNo,'X'))
      --AND       COALESCE(ChasisNo,'X')                            = COALESCE(@ChasisNo,COALESCE(ChasisNo,'X'))
      --AND       COALESCE(EngineNo,'X')                            = COALESCE(@EngineNo,COALESCE(EngineNo,'X'))
      --AND       Length                                            = COALESCE(@Length,Length)
      --AND       Width                                             = COALESCE(@Width,Width)
      --AND       Height                                            = COALESCE(@Height,Height)
      --AND       COALESCE(DimensionUnitType,'X')                   = COALESCE(@DimensionUnitType,COALESCE(DimensionUnitType,'X'))
      --AND       VehicleTypeID                                     = COALESCE(@VehicleTypeID,VehicleTypeID)
      --AND       COALESCE(Type,'X')                                = COALESCE(@Type,COALESCE(Type,'X'))
      --AND       COALESCE(VehicleModel,'X')                        = COALESCE(@VehicleModel,COALESCE(VehicleModel,'X'))
      --AND       COALESCE(VehicleColor,'X')                        = COALESCE(@VehicleColor,COALESCE(VehicleColor,'X'))
      --AND       COALESCE(BodyType,'X')                            = COALESCE(@BodyType,COALESCE(BodyType,'X'))
      --AND       COALESCE(ManufacturingYear,'X')                   = COALESCE(@ManufacturingYear,COALESCE(ManufacturingYear,'X'))
      --AND       COALESCE(ManufacturerName,'X')                    = COALESCE(@ManufacturerName,COALESCE(ManufacturerName,'X'))
      --AND       Picture                                           = COALESCE(@Picture,Picture)
      --AND       COALESCE(PurchasingDate,GETDATE())                = COALESCE(@PurchasingDate,COALESCE(PurchasingDate,GETDATE()))
      --AND       COALESCE(PurchasingAmount,0)                      = COALESCE(@PurchasingAmount,COALESCE(PurchasingAmount,0))
      --AND       COALESCE(PurchaseFromName,'X')                    = COALESCE(@PurchaseFromName,COALESCE(PurchaseFromName,'X'))
      --AND       COALESCE(PurchaseFromDetail,'X')                  = COALESCE(@PurchaseFromDetail,COALESCE(PurchaseFromDetail,'X'))
      --AND       COALESCE(OwnerName,'X')                           = COALESCE(@OwnerName,COALESCE(OwnerName,'X'))
      --AND       COALESCE(OwnerContact,'X')                        = COALESCE(@OwnerContact,COALESCE(OwnerContact,'X'))
      --AND       COALESCE(OwnerNIC,'X')                            = COALESCE(@OwnerNIC,COALESCE(OwnerNIC,'X'))
      --AND       COALESCE(DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(DateCreated,GETDATE()))
      --AND       COALESCE(DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(DateModified,GETDATE()))
      --AND       COALESCE(CreatedByUserID,0)                       = COALESCE(@CreatedByUserID,COALESCE(CreatedByUserID,0))
      --AND       COALESCE(ModifiedByUserID,0)                      = COALESCE(@ModifiedByUserID,COALESCE(ModifiedByUserID,0))
      --AND       COALESCE(IsActive,0)                              = COALESCE(@IsActive,COALESCE(IsActive,0))
      --AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
      --AND       COALESCE(IsOwnVehicle,0)                          = COALESCE(@IsOwnVehicle,COALESCE(IsOwnVehicle,0))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_Vehicle------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[usp_VehicleType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       /*-------------------------------------------------------------------------------------------------------+
       ¦ Company         ¦  UNION COOP                                                                          ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Procedure       ¦  usp_VehicleType                                                                                                                  ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Description     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Created By      ¦  ANEEL LALWANI                                                                ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Created    ¦  Sunday, 03 Mar 2019 00:01:03:730                                                    ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Modified By     ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Date Modified   ¦                                                                                      ¦
       ¦-----------------+--------------------------------------------------------------------------------------¦
       ¦ Details         ¦                                                                                      ¦
       +-------------------------------------------------------------------------------------------------------*/
       
CREATE PROCEDURE [dbo].[usp_VehicleType](@Action_Type                    numeric(10),
                                 @p_Success                      bit             = 1    OUTPUT,
                                 @p_Error_Message                varchar(MAX)    = NULL OUTPUT,
                                 @VehicleTypeID                  bigint          = NULL OUTPUT, 
                                 @VehicleTypeCode                varchar(50)     = NULL,
                                 @VehicleTypeName                varchar(50)     = NULL,
                                 @DimensionUnitType              varchar(50)     = NULL,
                                 @LowerDeckInnerLength           float(53)       = NULL,
                                 @LowerDeckInnerWidth            float(53)       = NULL,
                                 @LowerDeckInnerHeight           float(53)       = NULL,
                                 @UpperDeckInnerLength           float(53)       = NULL,
                                 @UpperDeckInnerWidth            float(53)       = NULL,
                                 @UpperDeckInnerHeight           float(53)       = NULL,
                                 @LowerDeckOuterLength           float(53)       = NULL,
                                 @LowerDeckOuterWidth            float(53)       = NULL,
                                 @LowerDeckOuterHeight           float(53)       = NULL,
                                 @UpperDeckOuterLength           float(53)       = NULL,
                                 @UpperDeckOuterWidth            float(53)       = NULL,
                                 @UpperDeckOuterHeight           float(53)       = NULL,
                                 @UpperPortionInnerLength        float(53)       = NULL,
                                 @UpperPortionInnerwidth         float(53)       = NULL,
                                 @UpperPortionInnerHeight        float(53)       = NULL,
                                 @LowerPortionInnerLength        float(53)       = NULL,
                                 @LowerPortionInnerWidth         float(53)       = NULL,
                                 @LowerPortionInnerHeight        float(53)       = NULL,
                                 @PermisibleHeight               float(53)       = NULL,
                                 @PermisibleLength               float(53)       = NULL,
                                 @DateCreated                    datetime        = NULL,
                                 @DateModified                   datetime        = NULL,
                                 @CreatedByUserID                bigint          = NULL,
                                 @ModifiedByUserID               bigint          = NULL,
                                 @IsActive                       bit             = NULL,
                                 @Description                    varchar(500)    = NULL)
AS
BEGIN
 BEGIN TRY
  IF       @Action_Type = 101 ------------------------> Insert Record
    BEGIN
      INSERT    INTO VehicleType(VehicleTypeCode,  VehicleTypeName,  DimensionUnitType,  LowerDeckInnerLength,  LowerDeckInnerWidth,  LowerDeckInnerHeight,  UpperDeckInnerLength,  UpperDeckInnerWidth,  UpperDeckInnerHeight,  LowerDeckOuterLength,  LowerDeckOuterWidth,  LowerDeckOuterHeight,  UpperDeckOuterLength,  UpperDeckOuterWidth,  UpperDeckOuterHeight,  UpperPortionInnerLength,  UpperPortionInnerwidth,  UpperPortionInnerHeight,  LowerPortionInnerLength,  LowerPortionInnerWidth,  LowerPortionInnerHeight,  PermisibleHeight,  PermisibleLength,  DateCreated,  DateModified,  CreatedByUserID,  ModifiedByUserID,  IsActive,  Description)
      VALUES                    ([dbo].[GetNextVehicleTypeCode](), @VehicleTypeName, @DimensionUnitType, @LowerDeckInnerLength, @LowerDeckInnerWidth, @LowerDeckInnerHeight, @UpperDeckInnerLength, @UpperDeckInnerWidth, @UpperDeckInnerHeight, @LowerDeckOuterLength, @LowerDeckOuterWidth, @LowerDeckOuterHeight, @UpperDeckOuterLength, @UpperDeckOuterWidth, @UpperDeckOuterHeight, @UpperPortionInnerLength, @UpperPortionInnerwidth, @UpperPortionInnerHeight, @LowerPortionInnerLength, @LowerPortionInnerWidth, @LowerPortionInnerHeight, @PermisibleHeight, @PermisibleLength, @DateCreated, @DateModified, @CreatedByUserID, @ModifiedByUserID, @IsActive, @Description)

      SET       @VehicleTypeID                 = @@IDENTITY SET       @p_Success                    = 1
    END

  ELSE IF  @Action_Type = 102 ------------------------> Update Record
    BEGIN
      UPDATE    VehicleType
      SET      -- VehicleTypeCode                = COALESCE(@VehicleTypeCode,VehicleTypeCode),
                VehicleTypeName                = COALESCE(@VehicleTypeName,VehicleTypeName),
                DimensionUnitType              = COALESCE(@DimensionUnitType,DimensionUnitType),
                LowerDeckInnerLength           = COALESCE(@LowerDeckInnerLength,LowerDeckInnerLength),
                LowerDeckInnerWidth            = COALESCE(@LowerDeckInnerWidth,LowerDeckInnerWidth),
                LowerDeckInnerHeight           = COALESCE(@LowerDeckInnerHeight,LowerDeckInnerHeight),
                UpperDeckInnerLength           = COALESCE(@UpperDeckInnerLength,UpperDeckInnerLength),
                UpperDeckInnerWidth            = COALESCE(@UpperDeckInnerWidth,UpperDeckInnerWidth),
                UpperDeckInnerHeight           = COALESCE(@UpperDeckInnerHeight,UpperDeckInnerHeight),
                LowerDeckOuterLength           = COALESCE(@LowerDeckOuterLength,LowerDeckOuterLength),
                LowerDeckOuterWidth            = COALESCE(@LowerDeckOuterWidth,LowerDeckOuterWidth),
                LowerDeckOuterHeight           = COALESCE(@LowerDeckOuterHeight,LowerDeckOuterHeight),
                UpperDeckOuterLength           = COALESCE(@UpperDeckOuterLength,UpperDeckOuterLength),
                UpperDeckOuterWidth            = COALESCE(@UpperDeckOuterWidth,UpperDeckOuterWidth),
                UpperDeckOuterHeight           = COALESCE(@UpperDeckOuterHeight,UpperDeckOuterHeight),
                UpperPortionInnerLength        = COALESCE(@UpperPortionInnerLength,UpperPortionInnerLength),
                UpperPortionInnerwidth         = COALESCE(@UpperPortionInnerwidth,UpperPortionInnerwidth),
                UpperPortionInnerHeight        = COALESCE(@UpperPortionInnerHeight,UpperPortionInnerHeight),
                LowerPortionInnerLength        = COALESCE(@LowerPortionInnerLength,LowerPortionInnerLength),
                LowerPortionInnerWidth         = COALESCE(@LowerPortionInnerWidth,LowerPortionInnerWidth),
                LowerPortionInnerHeight        = COALESCE(@LowerPortionInnerHeight,LowerPortionInnerHeight),
                PermisibleHeight               = COALESCE(@PermisibleHeight,PermisibleHeight),
                PermisibleLength               = COALESCE(@PermisibleLength,PermisibleLength),
                DateCreated                    = COALESCE(@DateCreated,DateCreated),
                DateModified                   = COALESCE(@DateModified,DateModified),
                CreatedByUserID                = COALESCE(@CreatedByUserID,CreatedByUserID),
                ModifiedByUserID               = COALESCE(@ModifiedByUserID,ModifiedByUserID),
                IsActive                       = COALESCE(@IsActive,IsActive),
                Description                    = COALESCE(@Description,Description)
                
      WHERE     VehicleTypeID                  = @VehicleTypeID
 SET       @p_Success                    = 1    END
  ELSE IF  @Action_Type = 103 ------------------------> Delete Record
    BEGIN
      DELETE    VehicleType
      WHERE     VehicleTypeID                  = @VehicleTypeID
 SET       @p_Success                    = 1    END

  ELSE IF  @Action_Type = 104 ------------------------> Select Record
    BEGIN
      SELECT    @Action_Type  AS ActionType, VehicleTypeID, VehicleTypeCode, VehicleTypeName, DimensionUnitType, LowerDeckInnerLength, LowerDeckInnerWidth, LowerDeckInnerHeight, UpperDeckInnerLength, UpperDeckInnerWidth, UpperDeckInnerHeight, LowerDeckOuterLength, LowerDeckOuterWidth, LowerDeckOuterHeight, UpperDeckOuterLength, UpperDeckOuterWidth, UpperDeckOuterHeight, UpperPortionInnerLength, UpperPortionInnerwidth, UpperPortionInnerHeight, LowerPortionInnerLength, LowerPortionInnerWidth, LowerPortionInnerHeight, PermisibleHeight, PermisibleLength, DateCreated, DateModified, CreatedByUserID, ModifiedByUserID, IsActive, Description
      FROM      VehicleType
      WHERE     VehicleTypeID                                     = COALESCE(@VehicleTypeID,VehicleTypeID)
      --AND       COALESCE(VehicleTypeCode,'X')                     = COALESCE(@VehicleTypeCode,COALESCE(VehicleTypeCode,'X'))
      --AND       COALESCE(VehicleTypeName,'X')                     = COALESCE(@VehicleTypeName,COALESCE(VehicleTypeName,'X'))
      --AND       COALESCE(DimensionUnitType,'X')                   = COALESCE(@DimensionUnitType,COALESCE(DimensionUnitType,'X'))
      --AND       LowerDeckInnerLength                              = COALESCE(@LowerDeckInnerLength,LowerDeckInnerLength)
      --AND       LowerDeckInnerWidth                               = COALESCE(@LowerDeckInnerWidth,LowerDeckInnerWidth)
      --AND       LowerDeckInnerHeight                              = COALESCE(@LowerDeckInnerHeight,LowerDeckInnerHeight)
      --AND       UpperDeckInnerLength                              = COALESCE(@UpperDeckInnerLength,UpperDeckInnerLength)
      --AND       UpperDeckInnerWidth                               = COALESCE(@UpperDeckInnerWidth,UpperDeckInnerWidth)
      --AND       UpperDeckInnerHeight                              = COALESCE(@UpperDeckInnerHeight,UpperDeckInnerHeight)
      --AND       LowerDeckOuterLength                              = COALESCE(@LowerDeckOuterLength,LowerDeckOuterLength)
      --AND       LowerDeckOuterWidth                               = COALESCE(@LowerDeckOuterWidth,LowerDeckOuterWidth)
      --AND       LowerDeckOuterHeight                              = COALESCE(@LowerDeckOuterHeight,LowerDeckOuterHeight)
      --AND       UpperDeckOuterLength                              = COALESCE(@UpperDeckOuterLength,UpperDeckOuterLength)
      --AND       UpperDeckOuterWidth                               = COALESCE(@UpperDeckOuterWidth,UpperDeckOuterWidth)
      --AND       UpperDeckOuterHeight                              = COALESCE(@UpperDeckOuterHeight,UpperDeckOuterHeight)
      --AND       UpperPortionInnerLength                           = COALESCE(@UpperPortionInnerLength,UpperPortionInnerLength)
      --AND       UpperPortionInnerwidth                            = COALESCE(@UpperPortionInnerwidth,UpperPortionInnerwidth)
      --AND       UpperPortionInnerHeight                           = COALESCE(@UpperPortionInnerHeight,UpperPortionInnerHeight)
      --AND       LowerPortionInnerLength                           = COALESCE(@LowerPortionInnerLength,LowerPortionInnerLength)
      --AND       LowerPortionInnerWidth                            = COALESCE(@LowerPortionInnerWidth,LowerPortionInnerWidth)
      --AND       LowerPortionInnerHeight                           = COALESCE(@LowerPortionInnerHeight,LowerPortionInnerHeight)
      --AND       PermisibleHeight                                  = COALESCE(@PermisibleHeight,PermisibleHeight)
      --AND       PermisibleLength                                  = COALESCE(@PermisibleLength,PermisibleLength)
      --AND       COALESCE(DateCreated,GETDATE())                   = COALESCE(@DateCreated,COALESCE(DateCreated,GETDATE()))
      --AND       COALESCE(DateModified,GETDATE())                  = COALESCE(@DateModified,COALESCE(DateModified,GETDATE()))
      --AND       COALESCE(CreatedByUserID,0)                       = COALESCE(@CreatedByUserID,COALESCE(CreatedByUserID,0))
      --AND       COALESCE(ModifiedByUserID,0)                      = COALESCE(@ModifiedByUserID,COALESCE(ModifiedByUserID,0))
      --AND       COALESCE(IsActive,0)                              = COALESCE(@IsActive,COALESCE(IsActive,0))
      --AND       COALESCE(Description,'X')                         = COALESCE(@Description,COALESCE(Description,'X'))
    END
  ELSE IF  @Action_Type = 105 ------------------------> Select Paging
    SELECT 1
  END TRY
  BEGIN CATCH
    EXECUTE usp_Get_Error_Info @p_Error_Message = @p_Error_Message OUTPUT
    SET     @p_Success = 0
  END CATCH
END
------------------------------------------End of Procedure: usp_VehicleType--------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------




GO
/****** Object:  StoredProcedure [dbo].[Vehicle_GetAllVehicle]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Naveed>
-- Create date: <29062012>
-- Modified date: <()>
-- Description:	<This stored procedure gets all records from Vehicle table>
-- =============================================
CREATE PROCEDURE		[dbo].[Vehicle_GetAllVehicle]
	
AS
BEGIN
	
	SELECT	v.[VehicleID],
		v.[VehicleCode],
		v.[RegNo],
		(SELECT  CASE WHEN MAX(OH.Odometer) 
			IS NULL THEN '0' ELSE MAX(OH.Odometer) END 
			from OdometerHistory OH 
			where OH.VehicleID=V.VehicleID)AS Odometer,
		v.[ChasisNo],
		v.[EngineNo],
		v.[length],
		v.[width],
		v.Height,
		v.DimensionUnitType,
		v.VehicleTypeID,
		vt.Name as VehicleType,
		v.[VehicleModel],
		v.[VehicleColor],
		v.[bodyType],
		v.[manufacturingYear],
		v.[manufacturerName],
		v.[picture],
		v.[purchasingDate],
		v.[purchasingAmount],
		v.[purchaseFromName],
		v.[purchaseFromDetail],
		v.[OwnerName],
		v.[OwnerContact],
		v.[OwnerNIC],
		v.DateCreated ,v.DateModified , v.CreatedByUserID ,v.ModifiedByUserID,
		v.IsActive,
		v.[Description],
		v.IsOwnVehicle
	
	FROM		Vehicle v
	
	JOIN	VehicleTypes	AS	VT	
		ON		VT.ID	=	v.VehicleTypeID
	
	
END




GO
/****** Object:  StoredProcedure [dbo].[Vehicle_GetAllVehicleByVehicleTypeID]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Fayyaz Ali>
-- Create date: <30062012>
-- Description:	<Through this Procedure we get Vehicle By VehicleID
-- =============================================
CREATE PROCEDURE  [dbo].[Vehicle_GetAllVehicleByVehicleTypeID]
(
@VehicleTypeID	bigint
)
 
AS
BEGIN
	
	SELECT
	
	v.[VehicleID],
	v.[VehicleCode],
	v.[RegNo],
	(SELECT  CASE WHEN MAX(OH.Odometer) IS NULL THEN '0' ELSE MAX(OH.Odometer) END from OdometerHistory OH where OH.VehicleID=V.VehicleID)AS Odometer,
	v.[ChasisNo],
    v.[EngineNo],
    v.[length],
    v.[width],
    v.VehicleTypeID,
    vt.VehicleTypeName as VehicleType,
    v.[VehicleModel],
    v.[VehicleColor],
    v.[bodyType],
    v.[manufacturingYear],
    v.[manufacturerName],
    v.[picture],
    v.[purchasingDate],
    v.[purchasingAmount],
    v.[purchaseFromName],
    v.[purchaseFromDetail],
    v.[OwnerName],
    v.[OwnerContact],
    v.[OwnerNIC],
	v.DateCreated ,v.DateModified , v.CreatedByUserID ,v.ModifiedByUserID,
	v.IsActive,v.[Description]
	
	FROM		Vehicle v
	
	JOIN VehicleType AS VT ON
	VT.VehicleTypeID=v.VehicleTypeID
	
	WHERE	v.VehicleTypeID	=	@VehicleTypeID
END




GO
/****** Object:  StoredProcedure [dbo].[Vehicle_GetAllVehiclesIDsAndRegNo]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Kashif>
-- Create date: <08112012>
-- Modified date: <()>
-- Description:	<This stored procedure gets all vehicles id and Names>
-- =============================================
CREATE PROCEDURE		[dbo].[Vehicle_GetAllVehiclesIDsAndRegNo]
	
AS
BEGIN
	
	SELECT	0	as	VehicleID,	'- Select -'	as	RegNo,
			'- Select -'	as	bodyType,'- Select -'	as	VehicleTypeName,
			'- Select -'	as	IsOwnVehicle
	
	UNION
	
	SELECT	v.VehicleID	as	VehicleID,v.RegNo	as	RegNo,
			v.bodyType	as	bodyType,vt.VehicleTypeName	as	VehicleTypeName,
			(CASE v.IsOwnVehicle	WHEN	1	THEN	'True'	ELSE	'False'	END)	as	IsOwnVehicle
  	
	FROM		Vehicle v
	
	join VehicleType vt on
	vt.VehicleTypeID=v.VehicleTypeID
	
	ORDER	BY	VehicleID,	RegNo
	
	
	
END




GO
/****** Object:  StoredProcedure [dbo].[Vehicle_GetVehicleByIsOwnVehicle]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Saqib Muneer>
-- Create date: <29 March 2013 04:21 PM>
-- Description:	<Get Vehicles By IsOwnVehicle True/False>
-- =============================================
CREATE PROCEDURE [dbo].[Vehicle_GetVehicleByIsOwnVehicle]
(
	@IsOwnVehicle		bit
)
AS
BEGIN

	SELECT	0	as	VehicleID,	'- Select -'	as	RegNo,
			'- Select -'	as	bodyType,'- Select -'	as	VehicleTypeName,
			'- Select -'	as	IsOwnVehicle
	
	UNION
	
	SELECT	v.VehicleID	as	VehicleID,v.RegNo	as	RegNo,
			v.bodyType	as	bodyType,vt.VehicleTypeName	as	VehicleTypeName,
			(CASE v.IsOwnVehicle	WHEN	1	THEN	'True'	ELSE	'False'	END)	as	IsOwnVehicle
  	
	FROM		Vehicle v
	
	join VehicleType vt on
	vt.VehicleTypeID=v.VehicleTypeID
	
	WHERE	v.IsOwnVehicle	=	@IsOwnVehicle
	
	ORDER	BY	VehicleID,	RegNo
	
END




GO
/****** Object:  StoredProcedure [dbo].[Vehicle_GetVehicleByRegNo]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Kashif Usman>
-- Create date: <13-Mar-2013>
-- Description:	<Through this Procedure we get Vehicle By RegNo
-- =============================================
CREATE PROCEDURE  [dbo].[Vehicle_GetVehicleByRegNo]
(
@RegNo	varchar(50)
)
 
AS
BEGIN
	
	SELECT		*
    	
	FROM		Vehicle
	
	WHERE		RegNo	=	@RegNo
	
END




GO
/****** Object:  StoredProcedure [dbo].[Vehicle_GetVehicleByVehicleID]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Fayyaz Ali>
-- Create date: <30062012>
-- Description:	<Through this Procedure we get Vehicle By VehicleID
-- =============================================
CREATE PROCEDURE  [dbo].[Vehicle_GetVehicleByVehicleID]
(
@VehicleID	bigint
)
 
AS
BEGIN
	
	SELECT
	v.[VehicleID],
	v.[VehicleCode],
	v.[RegNo],
    v.[ChasisNo],
    v.[EngineNo],
    v.[length],
    v.[width],
    v.Height,
    v.DimensionUnitType,
    v.VehicleTypeID,
    vt.VehicleTypeName as VehicleType,
    v.[VehicleModel],
    v.[VehicleColor],
    v.[bodyType],
    v.[manufacturingYear],
    v.[manufacturerName],
    v.[picture],
    v.[purchasingDate],
    v.[purchasingAmount],
    v.[purchaseFromName],
    v.[purchaseFromDetail],
    v.[OwnerName],
    v.[OwnerContact],
    v.[OwnerNIC],
	v.DateCreated ,v.DateModified , v.CreatedByUserID ,v.ModifiedByUserID,
	v.IsActive,v.[Description],
	v.IsOwnVehicle
	
	FROM		Vehicle v
	
	JOIN VehicleType AS VT ON
	VT.VehicleTypeID=v.VehicleTypeID
	
	WHERE	v.VehicleID	=	@VehicleID
END




GO
/****** Object:  StoredProcedure [dbo].[Vehicle_GetVehiclesByVehicleType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Saqib Muneer>
-- Create date: <18th March 2013 03:23 PM>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Vehicle_GetVehiclesByVehicleType]
(
	@VehicleType	varchar(50)
)
AS
BEGIN
	
	SELECT	0	as	VehicleID,	'- Select -'	as	RegNo,
			'- Select -'	as	bodyType,'- Select -'	as	VehicleTypeName,
			'- Select -'	as	IsOwnVehicle
	
	UNION
	
	SELECT	v.VehicleID	as	VehicleID,v.RegNo	as	RegNo,
			v.bodyType	as	bodyType,vt.VehicleTypeName	as	VehicleTypeName,
			(CASE v.IsOwnVehicle	WHEN	1	THEN	'True'	ELSE	'False'	END)	as	IsOwnVehicle
  	
	FROM		Vehicle v
	
	INNER	JOIN	VehicleType	vt
		ON		v.VehicleTypeID	=	vt.VehicleTypeID
		
	WHERE		vt.VehicleTypeName	=	@VehicleType
	
	ORDER	BY	VehicleID,	RegNo
	
END




GO
/****** Object:  StoredProcedure [dbo].[Vehicle_GetVehiclesByVehicleTypeAndIsOwnVehicle]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Saqib Muneer>
-- Create date: <30 March 2013 01:50 PM>
-- Description:	<Get Vehicles By Vehicle Type and IsOwnVehicle True/False>
-- =============================================
CREATE PROCEDURE [dbo].[Vehicle_GetVehiclesByVehicleTypeAndIsOwnVehicle]
(
	@VehicleType	varchar(50),
	@IsOwnVehicle	bit
)
AS
BEGIN
	
	SELECT	0	as	VehicleID,	'- Select -'	as	RegNo,
			'- Select -'	as	bodyType,'- Select -'	as	VehicleTypeName,
			'- Select -'	as	IsOwnVehicle
	
	UNION
	
	SELECT	v.VehicleID	as	VehicleID,v.RegNo	as	RegNo,
			v.bodyType	as	bodyType,vt.VehicleTypeName	as	VehicleTypeName,
			(CASE v.IsOwnVehicle	WHEN	1	THEN	'True'	ELSE	'False'	END)	as	IsOwnVehicle
  	
	FROM		Vehicle v
	
	INNER	JOIN	VehicleType	vt
		ON		v.VehicleTypeID	=	vt.VehicleTypeID
		
	WHERE		vt.VehicleTypeName	=	@VehicleType	AND
				v.IsOwnVehicle		=	@IsOwnVehicle
	
	ORDER	BY	VehicleID,	RegNo
	
END




GO
/****** Object:  StoredProcedure [dbo].[Vehicle_GetVehicleWithDetailByRegNo]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Saqib Muneer>
-- Create date: <21 May 2013 02:15 PM>
-- Description:	<Get Vehicle with Detail by Vehicle Reg No>
-- =============================================
CREATE PROCEDURE [dbo].[Vehicle_GetVehicleWithDetailByRegNo]
(
	@VehicleRegNo		varchar(50)
)
AS
BEGIN
	
	SELECT			*
	
	FROM			Vehicle		v
	
	INNER	JOIN	VehicleType		vt
		ON			v.VehicleTypeID		=		vt.VehicleTypeID
		
	WHERE		v.RegNo		=		@VehicleRegNo
	
END




GO
/****** Object:  StoredProcedure [dbo].[Vehicle_InsertVehicle]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Saqib Muneer>
-- Create date: <16 August 2013 03:45 PM>
-- Modify date: <()>
-- Description:	<Insert Vehicle>
-- =============================================
CREATE PROCEDURE [dbo].[Vehicle_InsertVehicle]
(
	@VehicleCode		varchar(50),
	@RegNo				varchar(50),
	@ChasisNo			varchar(50),
	@EngineNo			varchar(50),
	@length				float,
	@width				float,
	@Height				float,
	@DimensionUnitType	varchar(50),
	@VehicleTypeID		bigint,
	@VehicleModel		varchar(50),
	@VehicleColor		varchar(50),
	@bodyType			varchar(50),
	@manufacturingYear	varchar(50),
	@manufacturerName	varchar(50),
	@purchasingDate		datetime,
	@purchasingAmount	int,
	@purchaseFromName	varchar(50),
	@purchaseFromDetail	varchar(50),
	@DateCreated		datetime,
	@CreatedByUserID	bigint,
	@IsActive			bit,
	@Description		varchar(500),
	@OwnerName			varchar(50),
	@OwnerContact		varchar(50),
	@OwnerNIC			varchar(50),
	@IsOwnVehicle		bit
)

AS
BEGIN

	INSERT INTO		Vehicle
	(
		
	   [VehicleCode]
      ,[RegNo]
      ,[ChasisNo]
      ,[EngineNo]
      ,[length]
      ,[width]
      ,Height
      ,DimensionUnitType
      ,VehicleTypeID
      ,[VehicleModel]
      ,[VehicleColor]
      ,[bodyType]
      ,[manufacturingYear]
      ,[manufacturerName]
      ,[purchasingDate]
      ,[purchasingAmount]
      ,[purchaseFromName]
      ,[purchaseFromDetail]
      ,[OwnerName]
      ,[OwnerContact]
      ,[OwnerNIC]
      ,[DateCreated]
      ,[CreatedByUserID]
      ,[IsActive]
      ,[Description],
		IsOwnVehicle
	)
	VALUES
	(
		@VehicleCode,		
		@RegNo,				
		@ChasisNo,			
		@EngineNo,			
		@length,				
		@width,
		@Height,
		@DimensionUnitType,
		@VehicleTypeID,				
		@VehicleModel,		
		@VehicleColor,		
		@bodyType,			
		@manufacturingYear,	
		@manufacturerName,	
		@purchasingDate,		
		@purchasingAmount,	
		@purchaseFromName,	
		@purchaseFromDetail,	
		@OwnerName,			
		@OwnerContact,		
		@OwnerNIC,		
		@DateCreated,		
		@CreatedByUserID,	
		@IsActive,			
		@Description,
		@IsOwnVehicle			
	)
	
	SELECT		@@IDENTITY		AS		'ID'
	
END




GO
/****** Object:  StoredProcedure [dbo].[Vehicle_UpdateVehicle]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Naveed>
-- Create date: <03072012>
-- Modify date: <()>
-- Description:	<Update VehicleCode, VehicleTypeID, RegNo, ChasisNo, EngineNo, VehicleModel, VehicleColor, OwnerID,
--				BelongsTo, DateModified, ModifiedByUserID, IsActive, Description,
--				OwnerName, OwnerContact, DriverName and DriverContact in Vehicle table>
-- =============================================
CREATE PROCEDURE [dbo].[Vehicle_UpdateVehicle]
(


	@VehicleID			bigint,
	@VehicleCode		varchar(50),
	@RegNo				varchar(50),
	@ChasisNo			varchar(50),
	@EngineNo			varchar(50),
	@length				float,
	@width				float,
	@Height				float,
	@DimensionUnitType	varchar(50),
	@VehicleTypeID		bigint,
	@VehicleModel		varchar(50),
	@VehicleColor		varchar(50),
	@bodyType			varchar(50),
	@manufacturingYear	varchar(50),
	@manufacturerName	varchar(50),
	@purchasingDate		datetime,
	@purchasingAmount	int,
	@purchaseFromName	varchar(50),
	@purchaseFromDetail	varchar(50),
	@DateModified		datetime,
	@ModifiedByUserID	bigint,
	@IsActive			bit,
	@Description		varchar(500),
	@OwnerName			varchar(50),
	@OwnerContact		varchar(50),
	@OwnerNIC			varchar(50),
	@IsOwnVehicle		bit
)

AS
BEGIN

	UPDATE		Vehicle
	
	SET		VehicleCode			=	@VehicleCode,
			RegNo				=	@RegNo,
			ChasisNo			=	@ChasisNo,
			EngineNo			=	@EngineNo,
			[length]			=	@length,
			width				=	@width,
			Height				=	@Height,
			DimensionUnitType	=	@DimensionUnitType,
			VehicleTypeID		=	@VehicleTypeID,
			VehicleModel		=	@VehicleModel,
			VehicleColor		=	@VehicleColor,
			bodyType			=	@bodyType,
			manufacturingYear	=	@manufacturingYear,
			manufacturerName	=	@manufacturerName,
			purchasingDate		=	@purchasingDate,
			purchasingAmount	=	@purchasingAmount,
			purchaseFromName	=	@purchaseFromName,
			purchaseFromDetail	=	@purchaseFromDetail,
			DateModified		=	@DateModified,
			ModifiedByUserID	=	@ModifiedByUserID,
			IsActive			=	@IsActive,
			[Description]		=	@Description,
			OwnerName			=	@OwnerName,
			OwnerContact		=	@OwnerContact,
			OwnerNIC			=	@OwnerNIC,
			IsOwnVehicle		=	@IsOwnVehicle
	
	WHERE	VehicleID		=	@VehicleID
	
	SELECT		@@ROWCOUNT		AS		'ROWCNT'
	
END




GO
/****** Object:  StoredProcedure [dbo].[Vehicle_UpdateVehicleType]    Script Date: 5/10/2021 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Saqib Muneer>
-- Create date: <31 March 2013 06:16 PM>
-- Description:	<Update Vehicle Type for Vehicle>
-- =============================================
CREATE PROCEDURE [dbo].[Vehicle_UpdateVehicleType]
(
	@VehicleID		bigint,
	@VehicleTypeID	bigint
)
AS
BEGIN
	
	Update		Vehicle
	
	SET			VehicleTypeID		=		@VehicleTypeID
	
	WHERE		VehicleID			=		@VehicleID
	
	SELECT		@@ROWCOUNT		AS		'ROWCNT'
	
END




GO
