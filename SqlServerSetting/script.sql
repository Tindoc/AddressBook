USE [master]
GO
/****** Object:  Database [AddressList]    Script Date: 2019/8/22 16:58:26 ******/
CREATE DATABASE [AddressList]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AddressList', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AddressList.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AddressList_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\AddressList_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [AddressList] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AddressList].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AddressList] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AddressList] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AddressList] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AddressList] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AddressList] SET ARITHABORT OFF 
GO
ALTER DATABASE [AddressList] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AddressList] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AddressList] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AddressList] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AddressList] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AddressList] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AddressList] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AddressList] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AddressList] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AddressList] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AddressList] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AddressList] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AddressList] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AddressList] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AddressList] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AddressList] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AddressList] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AddressList] SET RECOVERY FULL 
GO
ALTER DATABASE [AddressList] SET  MULTI_USER 
GO
ALTER DATABASE [AddressList] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AddressList] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AddressList] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AddressList] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AddressList] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'AddressList', N'ON'
GO
ALTER DATABASE [AddressList] SET QUERY_STORE = OFF
GO
USE [AddressList]
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 2019/8/22 16:58:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contact](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Phone] [varchar](11) NULL,
	[Email] [nvarchar](50) NULL,
	[QQ] [varchar](20) NULL,
	[WorkUnit] [nvarchar](200) NULL,
	[OfficePhone] [varchar](20) NULL,
	[HomeAddress] [nvarchar](200) NULL,
	[HomePhone] [varchar](20) NULL,
	[Memo] [nvarchar](200) NULL,
	[GroupId] [int] NOT NULL,
 CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContactGroup]    Script Date: 2019/8/22 16:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContactGroup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](50) NOT NULL,
	[Memo] [nvarchar](200) NULL,
 CONSTRAINT [PK_ContactGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 2019/8/22 16:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserName] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
USE [master]
GO
ALTER DATABASE [AddressList] SET  READ_WRITE 
GO
/* Insert Data to [dbo].[User] */
use [AddressList]
GO
INSERT INTO [dbo].[User] (UserName, Password) VALUES ('admin', 'admin')
GO
/* Create stored procedure */
use [AddressList]
GO
CREATE Procedure [dbo].[GetContactListByName] /* 根据联系人姓名获取联系人信息 */
@Name nvarchar(50)
As
begin
    select Contact.Id,Contact.Name,Phone,Email,QQ,GroupName from
    Contact,ContactGroup where  Contact.GroupId=ContactGroup.Id 
    and Name like '%'+@Name+'%' order by Contact.Id desc
end

GO
use [AddressList]
GO
CREATE Procedure [dbo].[GetContactListByPhone] /* 根据联系人手机获取联系人信息 */
@Phone nvarchar(11)
As
begin
    select Contact.Id,Contact.Name,Phone,Email,QQ,GroupName from
    Contact,ContactGroup where  Contact.GroupId=ContactGroup.Id 
    and Phone like '%'+@Phone+'%' order by Contact.Id desc
end

GO
use [AddressList]
GO
CREATE Procedure [dbo].[GetAllContactGroup] /* 获取所有分组信息 */
As
begin
    select * from ContactGroup
end

GO
use [AddressList]
GO
CREATE PROCEDURE [dbo].[InsertContact] /* 新增联系人*/
@Name nvarchar(50),
@Phone varchar(11),
@Email nvarchar(50),
@QQ varchar(20),
@WorkUnit nvarchar(200),
@OfficePhone varchar(20),
@HomeAddress nvarchar(200),
@HomePhone varchar(20),
@Memo nvarchar(200),
@GroupId int
AS
begin
    insert into Contact values (@Name,@Phone,@Email,@QQ,@WorkUnit,@OfficePhone,@HomeAddress,@HomePhone,@Memo,@GroupId)
end

GO
use [AddressList]
GO
CREATE Procedure [dbo].[DeleteCOntactById] /* 通过编号删除联系人 */
@Id int
AS
begin
    delete from Contact where Id=@Id
end

GO
use [AddressList]
GO
CREATE Procedure [dbo].[GetContactById]
@Id int
AS
begin
    select * from Contact where id=@Id
end

GO
use [AddressList]
GO
CREATE Procedure [dbo].[UpdateContact] /* 修改联系人信息 */
@Name nvarchar(50),
@Phone varchar(11),
@Email nvarchar(50),
@QQ varchar(20),
@WorkUnit nvarchar(200),
@OfficePhone varchar(20),
@HomeAddress nvarchar(200),
@HomePhone varchar(20),
@Memo nvarchar(200),
@GroupId int,
@Id int
AS
begin
    update Contact set Name=@Name,Phone=@Phone,Email=@Email,QQ=@QQ,WorkUnit=@WorkUnit,OfficePhone=@OfficePhone,HomeAddress=@HomeAddress,HomePhone=@HomePhone,Memo=@Memo,GroupId=@GroupId where Id=@Id
end

GO
use [AddressList]
GO
CREATE Procedure [dbo].[GetGroupById]   /* 根据分组编号获取分组信息 */
@GroupName nvarchar(50) OUTPUT,
@Memo nvarchar(200) OUTPUT,
@id int
AS
begin
    select @GroupName=GroupName,@Memo=Memo from ContactGroup where id=@id
    if @@Error<>0
    return -1
    else
    return 0
end