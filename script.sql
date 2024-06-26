USE [master]
GO
/****** Object:  Database [customer_action]    Script Date: 2024/05/15 12:50:01 ******/
CREATE DATABASE [customer_action]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'customer_action', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\customer_action.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'customer_action_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\customer_action_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [customer_action] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [customer_action].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [customer_action] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [customer_action] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [customer_action] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [customer_action] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [customer_action] SET ARITHABORT OFF 
GO
ALTER DATABASE [customer_action] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [customer_action] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [customer_action] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [customer_action] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [customer_action] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [customer_action] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [customer_action] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [customer_action] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [customer_action] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [customer_action] SET  DISABLE_BROKER 
GO
ALTER DATABASE [customer_action] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [customer_action] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [customer_action] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [customer_action] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [customer_action] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [customer_action] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [customer_action] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [customer_action] SET RECOVERY FULL 
GO
ALTER DATABASE [customer_action] SET  MULTI_USER 
GO
ALTER DATABASE [customer_action] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [customer_action] SET DB_CHAINING OFF 
GO
ALTER DATABASE [customer_action] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [customer_action] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [customer_action] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [customer_action] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'customer_action', N'ON'
GO
ALTER DATABASE [customer_action] SET QUERY_STORE = OFF
GO
USE [customer_action]
GO
/****** Object:  User [u_customer_action]    Script Date: 2024/05/15 12:50:01 ******/
CREATE USER [u_customer_action] FOR LOGIN [u_customer_action] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [u_customer_action]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [u_customer_action]
GO
/****** Object:  Table [dbo].[tbl_company]    Script Date: 2024/05/15 12:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_company](
	[companyID] [int] NOT NULL,
	[company_name] [nvarchar](100) NOT NULL,
	[company_kana] [nvarchar](100) NULL,
	[delete_flag] [bit] NULL,
 CONSTRAINT [PK_tbl_company] PRIMARY KEY CLUSTERED 
(
	[companyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_customer]    Script Date: 2024/05/15 12:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_customer](
	[customerID] [int] NOT NULL,
	[customer_name] [nvarchar](20) NOT NULL,
	[customer_kana] [nvarchar](20) NOT NULL,
	[companyID] [int] NULL,
	[section] [nvarchar](50) NULL,
	[post] [nvarchar](30) NULL,
	[zipcode] [nvarchar](8) NULL,
	[address] [nvarchar](100) NULL,
	[tel] [nvarchar](20) NULL,
	[staffID] [int] NULL,
	[first_action_date] [datetime] NULL,
	[memo] [nvarchar](max) NULL,
	[input_date] [datetime] NULL,
	[input_staff_name] [nvarchar](20) NULL,
	[update_date] [datetime] NULL,
	[update_staff_name] [nvarchar](20) NULL,
	[delete_flag] [bit] NULL,
 CONSTRAINT [PK_tbl_customer] PRIMARY KEY CLUSTERED 
(
	[customerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_staff]    Script Date: 2024/05/15 12:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_staff](
	[staffID] [int] NOT NULL,
	[staff_name] [nvarchar](20) NOT NULL,
	[userID] [nvarchar](10) NULL,
	[password] [nvarchar](10) NULL,
	[admin_flag] [bit] NULL,
	[delete_flag] [bit] NULL,
 CONSTRAINT [PK_tbl_staff] PRIMARY KEY CLUSTERED 
(
	[staffID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_customer_view]    Script Date: 2024/05/15 12:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************/
/* ビューの作成                         */
/****************************************/
CREATE VIEW [dbo].[vw_customer_view]
AS
SELECT                  dbo.tbl_customer.*, ISNULL(dbo.tbl_company.company_name, '') AS company_name, dbo.tbl_company.company_kana, dbo.tbl_staff.staff_name
FROM                     dbo.tbl_customer LEFT OUTER JOIN
                                  dbo.tbl_company ON dbo.tbl_customer.companyID = dbo.tbl_company.companyID LEFT OUTER JOIN
                                  dbo.tbl_staff ON dbo.tbl_customer.staffID = dbo.tbl_staff.staffID
WHERE                   (dbo.tbl_customer.delete_flag = 0)
GO
/****** Object:  View [dbo].[vw_customer_view_test]    Script Date: 2024/05/15 12:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_customer_view_test]
AS
SELECT                      dbo.tbl_customer.customerID, dbo.tbl_customer.customer_name, dbo.tbl_customer.customer_kana, dbo.tbl_customer.companyID, dbo.tbl_customer.section, 
                                      dbo.tbl_customer.post, dbo.tbl_customer.zipcode, dbo.tbl_customer.address, dbo.tbl_customer.tel, dbo.tbl_customer.staffID, dbo.tbl_customer.first_action_date, 
                                      dbo.tbl_customer.memo, dbo.tbl_customer.input_date, dbo.tbl_customer.input_staff_name, dbo.tbl_customer.update_date, dbo.tbl_customer.update_staff_name, 
                                      dbo.tbl_customer.delete_flag, ISNULL(dbo.tbl_company.company_name, '') AS company_name, dbo.tbl_company.company_kana, dbo.tbl_staff.staff_name
FROM                         dbo.tbl_customer LEFT OUTER JOIN
                                      dbo.tbl_staff ON dbo.tbl_customer.staffID = dbo.tbl_staff.staffID LEFT OUTER JOIN
                                      dbo.tbl_company ON dbo.tbl_customer.companyID = dbo.tbl_company.companyID
WHERE                       (dbo.tbl_customer.delete_flag = 0)
GO
/****** Object:  Table [dbo].[tbl_action]    Script Date: 2024/05/15 12:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_action](
	[ID] [int] NOT NULL,
	[customerID] [int] NOT NULL,
	[action_date] [datetime] NOT NULL,
	[action_content] [nvarchar](400) NULL,
	[action_staffID] [int] NULL,
 CONSTRAINT [PK_tbl_action] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_action_view]    Script Date: 2024/05/15 12:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_action_view]
AS
select action_date, st.staff_name, cust.customer_name, comp.company_name, action_content from dbo.tbl_action as act
left join dbo.tbl_customer as cust
on cust.staffID = act.action_staffID
left join dbo.tbl_staff as st
on st.staffID = act.action_staffID
left join dbo.tbl_company as comp
on cust.companyID = comp.companyID
GO
/****** Object:  Table [dbo].[tbl_staff_backup]    Script Date: 2024/05/15 12:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_staff_backup](
	[staffID] [int] NOT NULL,
	[staff_name] [nvarchar](20) NOT NULL,
	[userID] [nvarchar](10) NULL,
	[password] [nvarchar](10) NULL,
	[admin_flag] [bit] NULL,
	[delete_flag] [bit] NULL,
 CONSTRAINT [PK_tbl_staff_backup] PRIMARY KEY CLUSTERED 
(
	[staffID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (1, 22, CAST(N'2018-07-23T00:00:00.000' AS DateTime), N'顧客22_アクション001', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (2, 12, CAST(N'2018-07-23T00:00:00.000' AS DateTime), N'顧客12_アクション001', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (3, 37, CAST(N'2018-07-25T00:00:00.000' AS DateTime), N'顧客37_アクション001', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (4, 14, CAST(N'2018-07-25T00:00:00.000' AS DateTime), N'顧客14_アクション001', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (5, 38, CAST(N'2018-07-25T00:00:00.000' AS DateTime), N'顧客38_アクション001', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (6, 38, CAST(N'2018-07-25T00:00:00.000' AS DateTime), N'顧客38_アクション002', 11)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (7, 7, CAST(N'2018-07-26T00:00:00.000' AS DateTime), N'顧客07_アクション001', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (8, 21, CAST(N'2018-07-27T00:00:00.000' AS DateTime), N'顧客21_アクション001', 9)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (9, 18, CAST(N'2018-07-27T00:00:00.000' AS DateTime), N'顧客18_アクション001', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (10, 14, CAST(N'2018-07-27T00:00:00.000' AS DateTime), N'顧客14_アクション002', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (11, 32, CAST(N'2018-07-28T00:00:00.000' AS DateTime), N'顧客32_アクション001', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (12, 32, CAST(N'2018-07-29T00:00:00.000' AS DateTime), N'顧客32_アクション002', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (13, 13, CAST(N'2018-07-30T00:00:00.000' AS DateTime), N'顧客13_アクション001', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (14, 27, CAST(N'2018-07-30T00:00:00.000' AS DateTime), N'顧客27_アクション001', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (15, 12, CAST(N'2018-07-30T00:00:00.000' AS DateTime), N'顧客12_アクション002', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (16, 27, CAST(N'2018-07-30T00:00:00.000' AS DateTime), N'顧客27_アクション002', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (17, 4, CAST(N'2018-07-30T00:00:00.000' AS DateTime), N'顧客04_アクション001', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (18, 1, CAST(N'2018-07-30T00:00:00.000' AS DateTime), N'顧客01_アクション001', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (19, 27, CAST(N'2018-07-30T00:00:00.000' AS DateTime), N'顧客27_アクション003', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (20, 14, CAST(N'2018-07-31T00:00:00.000' AS DateTime), N'顧客14_アクション003', 16)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (21, 6, CAST(N'2018-07-31T00:00:00.000' AS DateTime), N'顧客06_アクション001', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (22, 9, CAST(N'2018-07-31T00:00:00.000' AS DateTime), N'顧客09_アクション001', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (23, 13, CAST(N'2018-07-31T00:00:00.000' AS DateTime), N'顧客13_アクション002', 16)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (24, 23, CAST(N'2018-07-31T00:00:00.000' AS DateTime), N'顧客23_アクション001', 13)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (25, 24, CAST(N'2018-07-31T00:00:00.000' AS DateTime), N'顧客24_アクション001', 16)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (26, 6, CAST(N'2018-07-31T00:00:00.000' AS DateTime), N'顧客06_アクション002', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (27, 31, CAST(N'2018-08-01T00:00:00.000' AS DateTime), N'顧客31_アクション001', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (28, 9, CAST(N'2018-08-01T00:00:00.000' AS DateTime), N'顧客09_アクション002', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (29, 18, CAST(N'2018-08-01T00:00:00.000' AS DateTime), N'顧客18_アクション002', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (30, 3, CAST(N'2018-08-02T00:00:00.000' AS DateTime), N'顧客03_アクション001', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (31, 9, CAST(N'2018-08-02T00:00:00.000' AS DateTime), N'顧客09_アクション003', 16)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (32, 7, CAST(N'2018-08-03T00:00:00.000' AS DateTime), N'顧客07_アクション002', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (33, 22, CAST(N'2018-08-04T00:00:00.000' AS DateTime), N'顧客22_アクション002', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (34, 10, CAST(N'2018-08-04T00:00:00.000' AS DateTime), N'顧客10_アクション001', 16)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (35, 4, CAST(N'2018-08-05T00:00:00.000' AS DateTime), N'顧客04_アクション002', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (36, 37, CAST(N'2018-08-05T00:00:00.000' AS DateTime), N'顧客37_アクション002', 16)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (37, 28, CAST(N'2018-08-06T00:00:00.000' AS DateTime), N'顧客28_アクション001', 13)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (38, 28, CAST(N'2018-08-06T00:00:00.000' AS DateTime), N'顧客28_アクション002', 16)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (39, 35, CAST(N'2018-08-07T00:00:00.000' AS DateTime), N'顧客35_アクション001', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (40, 29, CAST(N'2018-08-07T00:00:00.000' AS DateTime), N'顧客29_アクション001', 16)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (41, 30, CAST(N'2018-08-09T00:00:00.000' AS DateTime), N'顧客30_アクション001', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (42, 27, CAST(N'2018-08-09T00:00:00.000' AS DateTime), N'顧客27_アクション004', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (43, 27, CAST(N'2018-08-09T00:00:00.000' AS DateTime), N'顧客27_アクション005', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (44, 23, CAST(N'2018-08-09T00:00:00.000' AS DateTime), N'顧客23_アクション002', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (45, 4, CAST(N'2018-08-10T00:00:00.000' AS DateTime), N'顧客04_アクション003', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (46, 14, CAST(N'2018-08-10T00:00:00.000' AS DateTime), N'顧客14_アクション004', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (47, 27, CAST(N'2018-08-10T00:00:00.000' AS DateTime), N'顧客27_アクション006', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (48, 15, CAST(N'2018-08-11T00:00:00.000' AS DateTime), N'顧客15_アクション001', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (49, 15, CAST(N'2018-08-11T00:00:00.000' AS DateTime), N'顧客15_アクション002', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (50, 18, CAST(N'2018-08-12T00:00:00.000' AS DateTime), N'顧客18_アクション003', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (51, 25, CAST(N'2018-08-13T00:00:00.000' AS DateTime), N'顧客25_アクション001', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (52, 33, CAST(N'2018-08-15T00:00:00.000' AS DateTime), N'顧客33_アクション001', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (53, 21, CAST(N'2018-08-15T00:00:00.000' AS DateTime), N'顧客21_アクション002', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (54, 30, CAST(N'2018-08-15T00:00:00.000' AS DateTime), N'顧客30_アクション002', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (55, 2, CAST(N'2018-08-15T00:00:00.000' AS DateTime), N'顧客02_アクション001', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (56, 10, CAST(N'2018-08-15T00:00:00.000' AS DateTime), N'顧客10_アクション002', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (57, 25, CAST(N'2018-08-15T00:00:00.000' AS DateTime), N'顧客25_アクション002', 9)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (58, 37, CAST(N'2018-08-15T00:00:00.000' AS DateTime), N'顧客37_アクション003', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (59, 33, CAST(N'2018-08-15T00:00:00.000' AS DateTime), N'顧客33_アクション002', 16)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (60, 34, CAST(N'2018-08-15T00:00:00.000' AS DateTime), N'顧客34_アクション001', 13)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (61, 10, CAST(N'2018-08-15T00:00:00.000' AS DateTime), N'顧客10_アクション003', 9)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (62, 9, CAST(N'2018-08-15T00:00:00.000' AS DateTime), N'顧客09_アクション004', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (63, 23, CAST(N'2018-08-15T00:00:00.000' AS DateTime), N'顧客23_アクション003', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (64, 9, CAST(N'2018-08-15T00:00:00.000' AS DateTime), N'顧客09_アクション005', 13)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (65, 24, CAST(N'2018-08-18T00:00:00.000' AS DateTime), N'顧客24_アクション002', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (66, 11, CAST(N'2018-08-18T00:00:00.000' AS DateTime), N'顧客11_アクション001', 13)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (67, 34, CAST(N'2018-08-18T00:00:00.000' AS DateTime), N'顧客34_アクション002', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (68, 5, CAST(N'2018-08-18T00:00:00.000' AS DateTime), N'顧客05_アクション001', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (69, 36, CAST(N'2018-08-18T00:00:00.000' AS DateTime), N'顧客36_アクション001', 16)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (70, 4, CAST(N'2018-08-19T00:00:00.000' AS DateTime), N'顧客04_アクション004', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (71, 15, CAST(N'2018-08-20T00:00:00.000' AS DateTime), N'顧客15_アクション003', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (72, 38, CAST(N'2018-08-20T00:00:00.000' AS DateTime), N'顧客38_アクション003', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (73, 2, CAST(N'2018-08-20T00:00:00.000' AS DateTime), N'顧客02_アクション002', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (74, 8, CAST(N'2018-08-21T00:00:00.000' AS DateTime), N'顧客08_アクション001', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (75, 10, CAST(N'2018-08-21T00:00:00.000' AS DateTime), N'顧客10_アクション004', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (76, 26, CAST(N'2018-08-22T00:00:00.000' AS DateTime), N'顧客26_アクション011', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (77, 30, CAST(N'2018-08-22T00:00:00.000' AS DateTime), N'顧客30_アクション003', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (78, 33, CAST(N'2018-08-22T00:00:00.000' AS DateTime), N'顧客33_アクション003', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (79, 9, CAST(N'2018-08-22T00:00:00.000' AS DateTime), N'顧客09_アクション006', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (80, 22, CAST(N'2018-08-23T00:00:00.000' AS DateTime), N'顧客22_アクション003', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (81, 4, CAST(N'2018-08-24T00:00:00.000' AS DateTime), N'顧客04_アクション005', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (82, 11, CAST(N'2018-08-24T00:00:00.000' AS DateTime), N'顧客11_アクション002', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (83, 36, CAST(N'2018-08-25T00:00:00.000' AS DateTime), N'顧客36_アクション002', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (84, 14, CAST(N'2018-08-25T00:00:00.000' AS DateTime), N'顧客14_アクション005', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (85, 13, CAST(N'2018-08-25T00:00:00.000' AS DateTime), N'顧客13_アクション003', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (86, 15, CAST(N'2018-08-25T00:00:00.000' AS DateTime), N'顧客15_アクション004', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (87, 34, CAST(N'2018-08-25T00:00:00.000' AS DateTime), N'顧客34_アクション003', 13)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (88, 16, CAST(N'2018-08-25T00:00:00.000' AS DateTime), N'顧客16_アクション001', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (89, 33, CAST(N'2018-08-26T00:00:00.000' AS DateTime), N'顧客33_アクション004', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (90, 14, CAST(N'2018-08-26T00:00:00.000' AS DateTime), N'顧客14_アクション006', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (91, 35, CAST(N'2018-08-26T00:00:00.000' AS DateTime), N'顧客35_アクション002', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (92, 16, CAST(N'2018-08-27T00:00:00.000' AS DateTime), N'顧客16_アクション002', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (93, 13, CAST(N'2018-08-27T00:00:00.000' AS DateTime), N'顧客13_アクション004', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (94, 16, CAST(N'2018-08-27T00:00:00.000' AS DateTime), N'顧客16_アクション003', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (95, 33, CAST(N'2018-08-28T00:00:00.000' AS DateTime), N'顧客33_アクション005', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (96, 3, CAST(N'2018-08-28T00:00:00.000' AS DateTime), N'顧客03_アクション002', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (97, 8, CAST(N'2018-08-28T00:00:00.000' AS DateTime), N'顧客08_アクション002', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (98, 16, CAST(N'2018-08-29T00:00:00.000' AS DateTime), N'顧客16_アクション004', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (99, 27, CAST(N'2018-08-29T00:00:00.000' AS DateTime), N'顧客27_アクション007', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (100, 19, CAST(N'2018-08-29T00:00:00.000' AS DateTime), N'顧客19_アクション001', 8)
GO
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (101, 21, CAST(N'2018-08-29T00:00:00.000' AS DateTime), N'顧客21_アクション003', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (102, 31, CAST(N'2018-08-29T00:00:00.000' AS DateTime), N'顧客31_アクション002', 11)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (103, 23, CAST(N'2018-08-29T00:00:00.000' AS DateTime), N'顧客23_アクション004', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (104, 8, CAST(N'2018-08-30T00:00:00.000' AS DateTime), N'顧客08_アクション003', 9)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (105, 37, CAST(N'2018-08-30T00:00:00.000' AS DateTime), N'顧客37_アクション004', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (106, 27, CAST(N'2018-08-30T00:00:00.000' AS DateTime), N'顧客27_アクション008', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (107, 32, CAST(N'2018-08-30T00:00:00.000' AS DateTime), N'顧客32_アクション003', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (108, 19, CAST(N'2018-08-30T00:00:00.000' AS DateTime), N'顧客19_アクション002', 13)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (109, 36, CAST(N'2018-08-31T00:00:00.000' AS DateTime), N'顧客36_アクション003', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (110, 17, CAST(N'2018-08-31T00:00:00.000' AS DateTime), N'顧客17_アクション001', 13)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (111, 32, CAST(N'2018-08-31T00:00:00.000' AS DateTime), N'顧客32_アクション004', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (112, 13, CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'顧客13_アクション005', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (113, 34, CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'顧客34_アクション004', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (114, 31, CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'顧客31_アクション003', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (115, 9, CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'顧客09_アクション007', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (116, 32, CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'顧客32_アクション005', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (117, 1, CAST(N'2018-09-02T00:00:00.000' AS DateTime), N'顧客01_アクション002', 11)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (118, 16, CAST(N'2018-09-02T00:00:00.000' AS DateTime), N'顧客16_アクション005', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (119, 28, CAST(N'2018-09-02T00:00:00.000' AS DateTime), N'顧客28_アクション003', 16)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (120, 32, CAST(N'2018-09-02T00:00:00.000' AS DateTime), N'顧客32_アクション006', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (121, 28, CAST(N'2018-09-03T00:00:00.000' AS DateTime), N'顧客28_アクション004', 9)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (122, 10, CAST(N'2018-09-03T00:00:00.000' AS DateTime), N'顧客10_アクション005', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (123, 26, CAST(N'2018-09-04T00:00:00.000' AS DateTime), N'顧客26_アクション012', 11)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (124, 37, CAST(N'2018-09-04T00:00:00.000' AS DateTime), N'顧客37_アクション005', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (125, 27, CAST(N'2018-09-04T00:00:00.000' AS DateTime), N'顧客27_アクション009', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (126, 38, CAST(N'2018-09-05T00:00:00.000' AS DateTime), N'顧客38_アクション004', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (127, 31, CAST(N'2018-09-06T00:00:00.000' AS DateTime), N'顧客31_アクション004', 11)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (128, 29, CAST(N'2018-09-07T00:00:00.000' AS DateTime), N'顧客29_アクション002', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (129, 15, CAST(N'2018-09-07T00:00:00.000' AS DateTime), N'顧客15_アクション005', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (130, 29, CAST(N'2018-09-08T00:00:00.000' AS DateTime), N'顧客29_アクション003', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (131, 8, CAST(N'2018-09-08T00:00:00.000' AS DateTime), N'顧客08_アクション004', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (132, 23, CAST(N'2018-09-08T00:00:00.000' AS DateTime), N'顧客23_アクション005', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (133, 16, CAST(N'2018-09-08T00:00:00.000' AS DateTime), N'顧客16_アクション006', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (134, 25, CAST(N'2018-09-08T00:00:00.000' AS DateTime), N'顧客25_アクション003', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (135, 9, CAST(N'2018-09-08T00:00:00.000' AS DateTime), N'顧客09_アクション008', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (136, 35, CAST(N'2018-09-09T00:00:00.000' AS DateTime), N'顧客35_アクション003', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (137, 25, CAST(N'2018-09-09T00:00:00.000' AS DateTime), N'顧客25_アクション004', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (138, 14, CAST(N'2018-09-09T00:00:00.000' AS DateTime), N'顧客14_アクション007', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (139, 31, CAST(N'2018-09-10T00:00:00.000' AS DateTime), N'顧客31_アクション005', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (140, 2, CAST(N'2018-09-11T00:00:00.000' AS DateTime), N'顧客02_アクション003', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (141, 14, CAST(N'2018-09-11T00:00:00.000' AS DateTime), N'顧客14_アクション008', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (142, 31, CAST(N'2018-09-11T00:00:00.000' AS DateTime), N'顧客31_アクション006', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (143, 36, CAST(N'2018-09-11T00:00:00.000' AS DateTime), N'顧客36_アクション004', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (144, 27, CAST(N'2018-09-12T00:00:00.000' AS DateTime), N'顧客27_アクション010', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (145, 17, CAST(N'2018-09-12T00:00:00.000' AS DateTime), N'顧客17_アクション002', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (146, 21, CAST(N'2018-09-12T00:00:00.000' AS DateTime), N'顧客21_アクション004', 13)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (147, 24, CAST(N'2018-09-12T00:00:00.000' AS DateTime), N'顧客24_アクション003', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (148, 14, CAST(N'2018-09-13T00:00:00.000' AS DateTime), N'顧客14_アクション009', 11)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (149, 9, CAST(N'2018-09-14T00:00:00.000' AS DateTime), N'顧客09_アクション009', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (150, 37, CAST(N'2018-09-14T00:00:00.000' AS DateTime), N'顧客37_アクション006', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (151, 31, CAST(N'2018-09-14T00:00:00.000' AS DateTime), N'顧客31_アクション007', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (152, 12, CAST(N'2018-09-14T00:00:00.000' AS DateTime), N'顧客12_アクション003', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (153, 2, CAST(N'2018-09-14T00:00:00.000' AS DateTime), N'顧客02_アクション004', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (154, 30, CAST(N'2018-09-15T00:00:00.000' AS DateTime), N'顧客30_アクション004', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (155, 24, CAST(N'2018-09-15T00:00:00.000' AS DateTime), N'顧客24_アクション004', 11)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (156, 20, CAST(N'2018-09-15T00:00:00.000' AS DateTime), N'顧客20_アクション001', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (157, 12, CAST(N'2018-09-15T00:00:00.000' AS DateTime), N'顧客12_アクション004', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (158, 30, CAST(N'2018-09-16T00:00:00.000' AS DateTime), N'顧客30_アクション005', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (159, 5, CAST(N'2018-09-16T00:00:00.000' AS DateTime), N'顧客05_アクション002', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (160, 10, CAST(N'2018-09-16T00:00:00.000' AS DateTime), N'顧客10_アクション006', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (161, 20, CAST(N'2018-09-16T00:00:00.000' AS DateTime), N'顧客20_アクション002', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (162, 25, CAST(N'2018-09-17T00:00:00.000' AS DateTime), N'顧客25_アクション005', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (163, 12, CAST(N'2018-09-18T00:00:00.000' AS DateTime), N'顧客12_アクション005', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (164, 7, CAST(N'2018-09-18T00:00:00.000' AS DateTime), N'顧客07_アクション003', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (165, 23, CAST(N'2018-09-19T00:00:00.000' AS DateTime), N'顧客23_アクション006', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (166, 34, CAST(N'2018-09-19T00:00:00.000' AS DateTime), N'顧客34_アクション005', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (167, 37, CAST(N'2018-09-19T00:00:00.000' AS DateTime), N'顧客37_アクション007', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (168, 33, CAST(N'2018-09-20T00:00:00.000' AS DateTime), N'顧客33_アクション006', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (169, 7, CAST(N'2018-09-20T00:00:00.000' AS DateTime), N'顧客07_アクション004', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (170, 1, CAST(N'2018-09-20T00:00:00.000' AS DateTime), N'顧客01_アクション003', 16)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (171, 18, CAST(N'2018-09-20T00:00:00.000' AS DateTime), N'顧客18_アクション004', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (172, 8, CAST(N'2018-09-21T00:00:00.000' AS DateTime), N'顧客08_アクション005', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (173, 10, CAST(N'2018-09-24T00:00:00.000' AS DateTime), N'顧客10_アクション007', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (174, 12, CAST(N'2018-09-24T00:00:00.000' AS DateTime), N'顧客12_アクション006', 9)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (175, 22, CAST(N'2018-09-24T00:00:00.000' AS DateTime), N'顧客22_アクション004', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (176, 32, CAST(N'2018-09-24T00:00:00.000' AS DateTime), N'顧客32_アクション007', 11)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (177, 9, CAST(N'2018-09-25T00:00:00.000' AS DateTime), N'顧客09_アクション010', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (178, 34, CAST(N'2018-09-25T00:00:00.000' AS DateTime), N'顧客34_アクション006', 11)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (179, 19, CAST(N'2018-09-25T00:00:00.000' AS DateTime), N'顧客19_アクション003', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (180, 28, CAST(N'2018-09-25T00:00:00.000' AS DateTime), N'顧客28_アクション005', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (181, 18, CAST(N'2018-09-25T00:00:00.000' AS DateTime), N'顧客18_アクション005', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (182, 27, CAST(N'2018-09-26T00:00:00.000' AS DateTime), N'顧客27_アクション011', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (183, 34, CAST(N'2018-09-28T00:00:00.000' AS DateTime), N'顧客34_アクション007', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (184, 25, CAST(N'2018-09-28T00:00:00.000' AS DateTime), N'顧客25_アクション006', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (185, 10, CAST(N'2018-09-28T00:00:00.000' AS DateTime), N'顧客10_アクション008', 9)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (186, 10, CAST(N'2018-09-28T00:00:00.000' AS DateTime), N'顧客10_アクション009', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (187, 20, CAST(N'2018-09-29T00:00:00.000' AS DateTime), N'顧客20_アクション003', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (188, 4, CAST(N'2018-09-29T00:00:00.000' AS DateTime), N'顧客04_アクション006', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (189, 28, CAST(N'2018-09-29T00:00:00.000' AS DateTime), N'顧客28_アクション006', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (190, 28, CAST(N'2018-09-29T00:00:00.000' AS DateTime), N'顧客28_アクション007', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (191, 15, CAST(N'2018-09-29T00:00:00.000' AS DateTime), N'顧客15_アクション006', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (192, 21, CAST(N'2018-09-30T00:00:00.000' AS DateTime), N'顧客21_アクション005', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (193, 10, CAST(N'2018-09-30T00:00:00.000' AS DateTime), N'顧客10_アクション010', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (194, 24, CAST(N'2018-09-30T00:00:00.000' AS DateTime), N'顧客24_アクション005', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (195, 32, CAST(N'2018-09-30T00:00:00.000' AS DateTime), N'顧客32_アクション008', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (196, 30, CAST(N'2018-09-30T00:00:00.000' AS DateTime), N'顧客30_アクション006', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (197, 2, CAST(N'2018-10-01T00:00:00.000' AS DateTime), N'顧客02_アクション005', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (198, 14, CAST(N'2018-10-01T00:00:00.000' AS DateTime), N'顧客14_アクション010', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (199, 14, CAST(N'2018-10-01T00:00:00.000' AS DateTime), N'顧客14_アクション011', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (200, 18, CAST(N'2018-10-01T00:00:00.000' AS DateTime), N'顧客18_アクション006', 2)
GO
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (201, 7, CAST(N'2018-10-01T00:00:00.000' AS DateTime), N'顧客07_アクション005', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (202, 13, CAST(N'2018-10-01T00:00:00.000' AS DateTime), N'顧客13_アクション006', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (203, 9, CAST(N'2018-10-02T00:00:00.000' AS DateTime), N'顧客09_アクション011', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (204, 36, CAST(N'2018-10-02T00:00:00.000' AS DateTime), N'顧客36_アクション005', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (205, 26, CAST(N'2018-10-02T00:00:00.000' AS DateTime), N'顧客26_アクション013', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (206, 24, CAST(N'2018-10-02T00:00:00.000' AS DateTime), N'顧客24_アクション006', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (207, 19, CAST(N'2018-10-02T00:00:00.000' AS DateTime), N'顧客19_アクション004', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (208, 13, CAST(N'2018-10-03T00:00:00.000' AS DateTime), N'顧客13_アクション007', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (209, 27, CAST(N'2018-10-03T00:00:00.000' AS DateTime), N'顧客27_アクション012', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (210, 19, CAST(N'2018-10-04T00:00:00.000' AS DateTime), N'顧客19_アクション005', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (211, 38, CAST(N'2018-10-04T00:00:00.000' AS DateTime), N'顧客38_アクション005', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (212, 15, CAST(N'2018-10-04T00:00:00.000' AS DateTime), N'顧客15_アクション007', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (213, 12, CAST(N'2018-10-05T00:00:00.000' AS DateTime), N'顧客12_アクション007', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (214, 8, CAST(N'2018-10-06T00:00:00.000' AS DateTime), N'顧客08_アクション006', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (215, 35, CAST(N'2018-10-07T00:00:00.000' AS DateTime), N'顧客35_アクション004', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (216, 15, CAST(N'2018-10-07T00:00:00.000' AS DateTime), N'顧客15_アクション008', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (217, 10, CAST(N'2018-10-08T00:00:00.000' AS DateTime), N'顧客10_アクション011', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (218, 8, CAST(N'2018-10-08T00:00:00.000' AS DateTime), N'顧客08_アクション007', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (219, 16, CAST(N'2018-10-08T00:00:00.000' AS DateTime), N'顧客16_アクション007', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (220, 11, CAST(N'2018-10-09T00:00:00.000' AS DateTime), N'顧客11_アクション003', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (221, 31, CAST(N'2018-10-09T00:00:00.000' AS DateTime), N'顧客31_アクション008', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (222, 16, CAST(N'2018-10-09T00:00:00.000' AS DateTime), N'顧客16_アクション008', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (223, 15, CAST(N'2018-10-09T00:00:00.000' AS DateTime), N'顧客15_アクション009', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (224, 31, CAST(N'2018-10-09T00:00:00.000' AS DateTime), N'顧客31_アクション009', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (225, 25, CAST(N'2018-10-10T00:00:00.000' AS DateTime), N'顧客25_アクション007', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (226, 15, CAST(N'2018-10-10T00:00:00.000' AS DateTime), N'顧客15_アクション010', 13)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (227, 4, CAST(N'2018-10-10T00:00:00.000' AS DateTime), N'顧客04_アクション007', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (228, 4, CAST(N'2018-10-10T00:00:00.000' AS DateTime), N'顧客04_アクション008', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (229, 21, CAST(N'2018-10-10T00:00:00.000' AS DateTime), N'顧客21_アクション006', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (230, 19, CAST(N'2018-10-11T00:00:00.000' AS DateTime), N'顧客19_アクション006', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (231, 10, CAST(N'2018-10-11T00:00:00.000' AS DateTime), N'顧客10_アクション012', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (232, 16, CAST(N'2018-10-11T00:00:00.000' AS DateTime), N'顧客16_アクション009', 11)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (233, 17, CAST(N'2018-10-11T00:00:00.000' AS DateTime), N'顧客17_アクション003', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (234, 5, CAST(N'2018-10-11T00:00:00.000' AS DateTime), N'顧客05_アクション003', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (235, 25, CAST(N'2018-10-11T00:00:00.000' AS DateTime), N'顧客25_アクション008', 13)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (236, 20, CAST(N'2018-10-12T00:00:00.000' AS DateTime), N'顧客20_アクション004', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (237, 25, CAST(N'2018-10-13T00:00:00.000' AS DateTime), N'顧客25_アクション009', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (238, 30, CAST(N'2018-10-13T00:00:00.000' AS DateTime), N'顧客30_アクション007', 11)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (239, 15, CAST(N'2018-10-13T00:00:00.000' AS DateTime), N'顧客15_アクション011', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (240, 38, CAST(N'2018-10-14T00:00:00.000' AS DateTime), N'顧客38_アクション006', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (241, 6, CAST(N'2018-10-14T00:00:00.000' AS DateTime), N'顧客06_アクション003', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (242, 12, CAST(N'2018-10-14T00:00:00.000' AS DateTime), N'顧客12_アクション008', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (243, 32, CAST(N'2018-10-14T00:00:00.000' AS DateTime), N'顧客32_アクション009', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (244, 33, CAST(N'2018-10-15T00:00:00.000' AS DateTime), N'顧客33_アクション007', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (245, 36, CAST(N'2018-10-15T00:00:00.000' AS DateTime), N'顧客36_アクション006', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (246, 11, CAST(N'2018-10-15T00:00:00.000' AS DateTime), N'顧客11_アクション004', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (247, 1, CAST(N'2018-10-20T00:00:00.000' AS DateTime), N'顧客01_アクション004ccccccccccccccccccc', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (248, 34, CAST(N'2018-10-16T00:00:00.000' AS DateTime), N'顧客34_アクション008', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (249, 10, CAST(N'2018-10-16T00:00:00.000' AS DateTime), N'顧客10_アクション013', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (250, 29, CAST(N'2018-10-16T00:00:00.000' AS DateTime), N'顧客29_アクション004', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (251, 8, CAST(N'2018-10-18T00:00:00.000' AS DateTime), N'顧客08_アクション008', 13)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (252, 35, CAST(N'2018-10-18T00:00:00.000' AS DateTime), N'顧客35_アクション005', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (253, 28, CAST(N'2018-10-18T00:00:00.000' AS DateTime), N'顧客28_アクション008', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (254, 14, CAST(N'2018-10-19T00:00:00.000' AS DateTime), N'顧客14_アクション012', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (255, 11, CAST(N'2018-10-19T00:00:00.000' AS DateTime), N'顧客11_アクション005', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (256, 9, CAST(N'2018-10-20T00:00:00.000' AS DateTime), N'顧客09_アクション012', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (257, 9, CAST(N'2018-10-20T00:00:00.000' AS DateTime), N'顧客09_アクション013', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (258, 16, CAST(N'2018-10-20T00:00:00.000' AS DateTime), N'顧客16_アクション010', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (259, 33, CAST(N'2018-10-20T00:00:00.000' AS DateTime), N'顧客33_アクション008', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (260, 7, CAST(N'2018-10-20T00:00:00.000' AS DateTime), N'顧客07_アクション006', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (261, 1, CAST(N'2018-10-21T00:00:00.000' AS DateTime), N'顧客01_アクション005', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (262, 21, CAST(N'2018-10-21T00:00:00.000' AS DateTime), N'顧客21_アクション007', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (263, 27, CAST(N'2018-10-21T00:00:00.000' AS DateTime), N'顧客27_アクション013', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (264, 21, CAST(N'2018-10-22T00:00:00.000' AS DateTime), N'顧客21_アクション008', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (265, 14, CAST(N'2018-10-22T00:00:00.000' AS DateTime), N'顧客14_アクション013', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (266, 30, CAST(N'2018-10-22T00:00:00.000' AS DateTime), N'顧客30_アクション008', 12)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (267, 27, CAST(N'2018-10-22T00:00:00.000' AS DateTime), N'顧客27_アクション014', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (268, 18, CAST(N'2018-10-22T00:00:00.000' AS DateTime), N'顧客18_アクション007', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (269, 1, CAST(N'2018-10-23T00:00:00.000' AS DateTime), N'顧客01_アクション006aaaaaaaaaaaaaaaaaaa', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (270, 35, CAST(N'2018-10-23T00:00:00.000' AS DateTime), N'顧客35_アクション006', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (271, 25, CAST(N'2018-10-23T00:00:00.000' AS DateTime), N'顧客25_アクション010', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (272, 31, CAST(N'2018-10-23T00:00:00.000' AS DateTime), N'顧客31_アクション010', 11)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (273, 26, CAST(N'2018-10-23T00:00:00.000' AS DateTime), N'顧客26_アクション014', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (274, 28, CAST(N'2018-10-23T00:00:00.000' AS DateTime), N'顧客28_アクション009', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (275, 29, CAST(N'2018-10-24T00:00:00.000' AS DateTime), N'顧客29_アクション005', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (276, 31, CAST(N'2018-10-24T00:00:00.000' AS DateTime), N'顧客31_アクション011', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (277, 14, CAST(N'2018-10-24T00:00:00.000' AS DateTime), N'顧客14_アクション014', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (278, 23, CAST(N'2018-10-25T00:00:00.000' AS DateTime), N'顧客23_アクション007', 9)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (279, 13, CAST(N'2018-10-25T00:00:00.000' AS DateTime), N'顧客13_アクション008', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (280, 32, CAST(N'2018-10-25T00:00:00.000' AS DateTime), N'顧客32_アクション010', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (281, 6, CAST(N'2018-10-25T00:00:00.000' AS DateTime), N'顧客06_アクション004', 4)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (282, 30, CAST(N'2018-10-25T00:00:00.000' AS DateTime), N'顧客30_アクション009', 9)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (283, 35, CAST(N'2018-10-25T00:00:00.000' AS DateTime), N'顧客35_アクション007', 11)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (284, 30, CAST(N'2018-10-25T00:00:00.000' AS DateTime), N'顧客30_アクション010', 13)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (285, 5, CAST(N'2018-10-26T00:00:00.000' AS DateTime), N'顧客05_アクション004', 6)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (286, 6, CAST(N'2018-10-26T00:00:00.000' AS DateTime), N'顧客06_アクション005', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (287, 23, CAST(N'2018-10-27T00:00:00.000' AS DateTime), N'顧客23_アクション008', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (288, 28, CAST(N'2018-10-27T00:00:00.000' AS DateTime), N'顧客28_アクション010', 8)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (289, 20, CAST(N'2018-10-27T00:00:00.000' AS DateTime), N'顧客20_アクション005', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (290, 35, CAST(N'2018-10-27T00:00:00.000' AS DateTime), N'顧客35_アクション008', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (291, 33, CAST(N'2018-10-28T00:00:00.000' AS DateTime), N'顧客33_アクション009', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (292, 29, CAST(N'2018-10-28T00:00:00.000' AS DateTime), N'顧客29_アクション006', 7)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (293, 2, CAST(N'2018-10-28T00:00:00.000' AS DateTime), N'顧客02_アクション006', 10)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (294, 17, CAST(N'2018-10-28T00:00:00.000' AS DateTime), N'顧客17_アクション004', 5)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (295, 17, CAST(N'2018-10-28T00:00:00.000' AS DateTime), N'顧客17_アクション005', 16)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (296, 11, CAST(N'2018-10-28T00:00:00.000' AS DateTime), N'顧客11_アクション006', 15)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (297, 10, CAST(N'2018-10-29T00:00:00.000' AS DateTime), N'顧客10_アクション014', 9)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (298, 30, CAST(N'2018-10-29T00:00:00.000' AS DateTime), N'顧客30_アクション011', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (299, 7, CAST(N'2018-10-30T00:00:00.000' AS DateTime), N'顧客07_アクション007', 14)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (300, 37, CAST(N'2018-10-30T00:00:00.000' AS DateTime), N'顧客37_アクション008', 10)
GO
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (301, 1, CAST(N'2024-04-16T00:00:00.000' AS DateTime), N'gggggggggggggggggggggggggggggggggggggg', 3)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (302, 1, CAST(N'2024-04-16T00:00:00.000' AS DateTime), N'qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq', 1)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (303, 1, CAST(N'2024-04-30T00:00:00.000' AS DateTime), N'brrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr', 2)
INSERT [dbo].[tbl_action] ([ID], [customerID], [action_date], [action_content], [action_staffID]) VALUES (304, 41, CAST(N'2024-04-30T00:00:00.000' AS DateTime), N'てｓｓｓｓｓｓｓｓｓｓｓｓｓｓｓｓｓｓｓｓｓｓｓｓ', 2)
GO
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (1, N'株式会社百面相△□', N'ヒャクメンソウ△□', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (2, N'ググッド◎◇株式会社', N'ググッド◎◇', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (3, N'株式会社パル×○', N'パル×○', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (4, N'クレソン●×株式会社', N'クレソン●×', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (5, N'株式会社ABC産業○◎', N'ＡＢＣサンギョウ○◎', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (6, N'ABC電気商会◇○株式会社', N'ＡＢＣデンキショウカイ◇○', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (7, N'アールシーエフ□●開発株式会社', N'アールシーエフ□●カイハツ', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (8, N'株式会社マイクロコンピュータ▼◎', N'マイクロコンピュータ▼◎', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (9, N'株式会社マイクロファイン▼×', N'マイクロファイン▼×', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (10, N'新世紀開発×□株式会社', N'シンセイキカイハツ×□', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (11, N'CIAC□▼株式会社', N'ＣＩＡＣ□▼', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (12, N'株式会社書籍出版△□企画', N'ショセキシュッパン△□キカク', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (13, N'みずかめ◎×株式会社', N'ミズカメ◎×', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (14, N'株式会社富士山電鉄●△', N'フジサンデンテツ●△', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (15, N'ファインビビット△●株式会社', N'ファインビビット△●', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (16, N'ペルソナソフト△×株式会社', N'ペルソナソフト△×', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (17, N'株式会社キャリア支援□◎', N'キャリアシエン□◎', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (18, N'株式会社テラス', N'テラス', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (19, N'株式会社ヤマハ', N'ヤマハ', 0)
INSERT [dbo].[tbl_company] ([companyID], [company_name], [company_kana], [delete_flag]) VALUES (20, N'株式会社本田', N'ホンダ', NULL)
GO
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (1, N'橋本　XX至', N'ハシモト　XXシ', 1, N'アプリケーションソフトウェア事業本部', NULL, N'000-0000', N'東京都千代田区九段南XX-XX-XXX', N'03-0000-1111', 1, CAST(N'2022-04-02T00:00:00.000' AS DateTime), N'・是非とも顧客として獲得したい。
・最重要の顧客
・ご挨拶時、好感触
・テキスト
・ssssssssssssss', CAST(N'2017-01-01T00:00:00.000' AS DateTime), N'古賀', CAST(N'2024-04-30T19:07:33.893' AS DateTime), N'木島', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (2, N'貫井　XX一', N'ヌクイ　XXイチ', 2, N'システムグループ', N'主任', N'000-0000', N'東京都立川市錦町XX-XX-XXX', N'0425-00-1111', 14, CAST(N'2017-05-15T00:00:00.000' AS DateTime), NULL, CAST(N'2017-06-01T00:00:00.000' AS DateTime), N'小川', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'小川', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (3, N'久保山　XX聡', N'クボヤマ', 3, N'システム事業推進部', NULL, N'000-0000', N'東京都文京区本郷XX-XX-XXX', N'03-0000-1111', 1, CAST(N'2017-07-17T00:00:00.000' AS DateTime), NULL, CAST(N'2017-08-01T00:00:00.000' AS DateTime), N'古賀', CAST(N'2024-04-02T10:06:54.157' AS DateTime), N'（ーーー）', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (4, N'山下　XX茂', N'ヤマシタ　XXシゲ', 3, N'システム事業部　システムインテグレーション部', N'取締役', N'000-0000', N'鹿児島県鹿児島市桜ヶ丘XX-XX-XXX', N'099-000-1111', 14, CAST(N'2017-09-17T00:00:00.000' AS DateTime), NULL, CAST(N'2017-10-01T00:00:00.000' AS DateTime), N'小川', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'小川', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (5, N'山下　XX輔', N'ヤマシタ　XXスケ', 9, N'ソリューション事業部', N'部長', N'000-0000', N'東京都千代田区九段北XX-XX-XXX', N'03-0000-1111', 1, CAST(N'2017-12-26T00:00:00.000' AS DateTime), NULL, CAST(N'2018-01-10T00:00:00.000' AS DateTime), N'古賀', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'古賀', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (6, N'田所　XX治', N'タドコロ　XXジ', 15, N'テレマーケティング事業部', NULL, N'000-0000', N'東京都豊島区東XX-XX-XXX', N'03-0000-1111', 9, CAST(N'2017-12-27T00:00:00.000' AS DateTime), NULL, CAST(N'2018-01-11T00:00:00.000' AS DateTime), N'大下', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'大下', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (7, N'若狭　XX悟', N'ワカサ　XXゴ', 15, N'ネットワーク業務部　第６グループ', N'プランナー', N'000-0000', N'東京都千代田区麹町XX-XX-XXX', N'03-0000-1111', 8, CAST(N'2018-06-18T00:00:00.000' AS DateTime), NULL, CAST(N'2018-07-01T00:00:00.000' AS DateTime), N'但馬', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'但馬', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (8, N'大原　XX子', N'オオハラ　XXコ', 17, N'ビジネス推進室', N'部長代理', N'000-0000', N'東京都港区南青山XX-XX-XXX', N'03-0000-1111', 4, CAST(N'2018-07-17T00:00:00.000' AS DateTime), NULL, CAST(N'2018-08-01T00:00:00.000' AS DateTime), N'山本', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'山本', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (9, N'針生　XX一', N'ハリオ　XXイチ', 11, N'マルチメディア事業部', NULL, N'000-0000', N'東京都渋谷区宇田川町XX-XX-XXX', N'03-0000-1111', 11, CAST(N'2018-07-17T00:00:00.000' AS DateTime), NULL, CAST(N'2018-08-01T00:00:00.000' AS DateTime), N'高山', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'高山', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (10, N'青山　XX春', N'アオヤマ　XXハル', 9, N'メディア推進本部', N'専務取締役', N'000-0000', N'東京都渋谷区宇田川町XX-XX-XXX', N'03-0000-1111', 5, CAST(N'2018-07-17T00:00:00.000' AS DateTime), NULL, CAST(N'2018-08-01T00:00:00.000' AS DateTime), N'坂下', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'坂下', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (11, N'富士井　XX雄', N'フジイ　XXオ', 13, N'営業開発部', N'担当部長', N'000-0000', N'東京都豊島区東池袋XX-XX-XXX', N'03-0000-1111', 4, CAST(N'2018-08-18T00:00:00.000' AS DateTime), NULL, CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'山本', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'山本', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (12, N'染井　XX己', N'ソメイ　XXミ', 17, N'営業部', NULL, N'000-0000', N'茨城県水海道市豊岡町乙XX-XX-XXX', N'0297-00-1111', 7, CAST(N'2018-09-17T00:00:00.000' AS DateTime), NULL, CAST(N'2018-10-01T00:00:00.000' AS DateTime), N'香山', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'香山', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (13, N'池内　XX徹', N'イケウチ　XXテツ', 16, N'企画制作部　企画制作課', NULL, N'000-0000', N'東京都渋谷区代々木XX-XX-XXX', N'03-0000-1111', 16, CAST(N'2018-10-18T00:00:00.000' AS DateTime), NULL, CAST(N'2018-11-01T00:00:00.000' AS DateTime), N'坂本', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'坂本', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (14, N'黒澤　XX二', N'クロサワ　XXジ', 12, N'企画調整部', N'室長', N'000-0000', N'東京都港区赤坂XX-XX-XXX', N'03-0000-1111', 2, CAST(N'2018-12-17T00:00:00.000' AS DateTime), NULL, CAST(N'2019-01-01T00:00:00.000' AS DateTime), N'木島', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'木島', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (15, N'西出　XX美', N'ニシイデ　XXミ', 17, N'業務グループ', N'担当課長', N'000-0000', N'東京都中野区江原町XX-XX-XXX', N'03-0000-1111', 16, CAST(N'2019-01-18T00:00:00.000' AS DateTime), NULL, CAST(N'2019-02-01T00:00:00.000' AS DateTime), N'坂本', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'坂本', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (16, N'赤羽橋　XX渉', N'アカバネバシ　XXホ', 9, N'商品企画部', NULL, N'000-0000', N'東京都墨田区文花XX-XX-XXX', N'03-0000-1111', 7, CAST(N'2016-04-18T00:00:00.000' AS DateTime), NULL, CAST(N'2016-05-01T00:00:00.000' AS DateTime), N'香山', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'香山', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (17, N'大期　XX子', N'オオキ　XXコ', 9, N'情報システム部', NULL, N'000-0000', N'東京都港区赤坂XX-XX-XXX', N'03-0000-1111', 1, CAST(N'2016-05-16T00:00:00.000' AS DateTime), NULL, CAST(N'2016-06-01T00:00:00.000' AS DateTime), N'古賀', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'古賀', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (18, N'大田　XX夫', N'オオタ　XXオ', 7, N'新製品開発事業部', NULL, N'000-0000', N'東京都文京区本郷XX-XX-XXX', N'03-0000-1111', 9, CAST(N'2016-05-16T00:00:00.000' AS DateTime), NULL, CAST(N'2016-06-01T00:00:00.000' AS DateTime), N'大下', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'大下', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (19, N'中村　XX視', N'ナカムラ　XXミ', 8, N'人事システム事業推進部', NULL, N'000-0000', N'東京都中央区新川XX-XX-XXX', N'03-0000-1111', 7, CAST(N'2016-11-18T00:00:00.000' AS DateTime), NULL, CAST(N'2016-12-01T00:00:00.000' AS DateTime), N'香山', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'香山', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (20, N'亀田　XX男', N'カメダ　XXオ', 9, N'人事本部　人材課', N'課長補佐', N'000-0000', N'東京都品川区北品川XX-XX-XXX', N'03-0000-1111', 3, CAST(N'2016-11-18T00:00:00.000' AS DateTime), NULL, CAST(N'2016-12-01T00:00:00.000' AS DateTime), N'中川', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'中川', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (21, N'桜貝　XX夫', N'サクラガイ　XXオ', 10, N'生産管理部', NULL, N'000-0000', N'東京都渋谷区広尾XX-XX-XXX', N'03-0000-1111', 7, CAST(N'2016-12-17T00:00:00.000' AS DateTime), NULL, CAST(N'2017-01-01T00:00:00.000' AS DateTime), N'香山', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'香山', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (22, N'松本　XX夫', N'マツモト　XXオ', 5, NULL, N'代表取締役', N'000-0000', N'愛知県稲沢市菱町XX-XX-XXX', N'0587-00-1111', 16, CAST(N'2016-12-17T00:00:00.000' AS DateTime), NULL, CAST(N'2017-01-01T00:00:00.000' AS DateTime), N'坂本', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'坂本', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (23, N'小橋　XX之', N'コバシ　XXユキ', 2, N'第四編集部', NULL, N'000-0000', N'静岡県富士市中央町XX-XX-XXX', N'0545-00-1111', 1, CAST(N'2017-01-18T00:00:00.000' AS DateTime), NULL, CAST(N'2017-02-01T00:00:00.000' AS DateTime), N'古賀', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'古賀', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (24, N'大河原　XX子', N'オオガワラ　XXコ', 15, N'東京営業一部　新宿支店', N'支店長', N'000-0000', N'東京都豊島区池袋XX-XX-XXX', N'03-0000-1111', 14, CAST(N'2017-09-17T00:00:00.000' AS DateTime), NULL, CAST(N'2017-10-01T00:00:00.000' AS DateTime), N'小川', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'小川', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (25, N'材寄　XX毅', N'ザイヨリ　XXキ', 4, N'営業部', NULL, N'000-0000', N'東京都港区北青山XX-XX-XXX', N'03-0000-1111', 1, CAST(N'2017-11-18T00:00:00.000' AS DateTime), NULL, CAST(N'2017-12-01T00:00:00.000' AS DateTime), N'古賀', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'古賀', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (26, N'飯田　XX枝', N'イイダ　XXエ', 17, N'企画制作部　企画制作課', N'課長代理', N'000-0000', N'東京都豊島区東池袋XX-XX-XXX', N'03-0000-1111', 14, CAST(N'2018-06-18T00:00:00.000' AS DateTime), NULL, CAST(N'2018-07-01T00:00:00.000' AS DateTime), N'青島', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'青島', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (27, N'田岡　XX信', N'タオカ　XXノブ', 16, N'企画調整部', NULL, N'000-0000', N'東京都渋谷区笹塚XX-XX-XXX', N'03-0000-1111', 8, CAST(N'2018-11-18T00:00:00.000' AS DateTime), NULL, CAST(N'2018-12-01T00:00:00.000' AS DateTime), N'但馬', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'但馬', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (28, N'諸兄　XX徹', N'モロエ　XXテツ', 11, N'営業部', NULL, N'000-0000', N'東京都千代田区麹町XX-XX-XXX', N'03-0000-1111', 1, CAST(N'2019-01-18T00:00:00.000' AS DateTime), NULL, CAST(N'2019-02-01T00:00:00.000' AS DateTime), N'古賀', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'古賀', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (29, N'百舌　XX則', N'モズ　XXノリ', 16, N'総務部', NULL, N'000-0000', N'石川県能美郡辰口町旭台XX-XX-XXX', N'0761-00-1111', 1, CAST(N'2016-09-17T00:00:00.000' AS DateTime), NULL, CAST(N'2016-10-01T00:00:00.000' AS DateTime), N'古賀', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'古賀', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (30, N'村松　XX子', N'ムラマツ　XXコ', 16, N'総務部', NULL, N'000-0000', N'東京都港区東新橋XX-XX-XXX', N'03-0000-1111', 5, CAST(N'2016-09-17T00:00:00.000' AS DateTime), NULL, CAST(N'2016-10-01T00:00:00.000' AS DateTime), N'坂下', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'坂下', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (31, N'山形　XX雄', N'ヤマガタ　XXオ', 15, N'総務部', NULL, N'000-0000', N'東京都豊島区西池袋XX-XX-XXX', N'03-0000-1111', NULL, CAST(N'2017-06-18T00:00:00.000' AS DateTime), NULL, CAST(N'2017-07-01T00:00:00.000' AS DateTime), N'大下', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'大下', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (32, N'土方　XX美', N'ヒジカタ　XXミ', 12, N'総務部', NULL, N'000-0000', N'東京都渋谷区宇田川町XX-XX-XXX', N'03-0000-1111', 4, CAST(N'2017-09-17T00:00:00.000' AS DateTime), NULL, CAST(N'2017-10-01T00:00:00.000' AS DateTime), N'山本', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'山本', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (33, N'赤阪　XX治', N'アカサカ　XXハル', 11, N'情報システム部', N'部長', N'000-0000', N'神奈川県横浜市中区野毛町XX-XX-XXX', N'045-000-1111', 15, CAST(N'2017-09-17T00:00:00.000' AS DateTime), NULL, CAST(N'2017-10-01T00:00:00.000' AS DateTime), N'韮崎', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'韮崎', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (34, N'金山　XX文', N'カナヤマ　XXフミ', 4, N'情報システム部', NULL, N'000-0000', N'東京都中央区日本橋小船町XX-XX-XXX', N'03-0000-1111', 8, CAST(N'2017-10-18T00:00:00.000' AS DateTime), NULL, CAST(N'2017-11-01T00:00:00.000' AS DateTime), N'但馬', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'但馬', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (35, N'藤木　XX明', N'フジキ　XXアキ', 9, N'情報システム部', N'課長', N'000-0000', N'東京都中野区東中野XX-XX-XXX', N'03-0000-1111', NULL, CAST(N'2017-10-18T00:00:00.000' AS DateTime), NULL, CAST(N'2017-11-01T00:00:00.000' AS DateTime), N'坂本', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'坂本', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (36, N'針生　XX男', N'ハリオ　XXオ', 13, N'営業部', NULL, N'000-0000', N'東京都新宿区西新宿XX-XX-XXX', N'03-0000-1111', 13, CAST(N'2017-11-18T00:00:00.000' AS DateTime), NULL, CAST(N'2017-12-01T00:00:00.000' AS DateTime), N'柳沢', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'柳沢', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (37, N'大石　XX澄', N'オオイシ　XXスミ', 5, N'総務部', NULL, N'000-0000', N'東京都豊島区南池袋XX-XX-XXX', N'03-0000-1111', 16, CAST(N'2017-12-17T00:00:00.000' AS DateTime), NULL, CAST(N'2018-01-01T00:00:00.000' AS DateTime), N'坂本', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'坂本', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (38, N'谷藤　XX行', N'タニフジ　XXユキ', 8, N'企画調整部', NULL, N'000-0000', N'東京都文京区本郷XX-XX-XXX', N'03-0000-1111', 1, CAST(N'2018-01-18T00:00:00.000' AS DateTime), NULL, CAST(N'2018-02-01T00:00:00.000' AS DateTime), N'古賀', CAST(N'2018-09-01T00:00:00.000' AS DateTime), N'古賀', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (39, N'山本', N'ヤマモト', 2, N'営業部', N'課長', N'000-0000', N'東京都千代田区白金0-0-0', N'00-0000-0000', 3, NULL, NULL, CAST(N'2024-04-04T02:17:13.833' AS DateTime), N'（ーーー）', CAST(N'2024-04-04T02:17:13.833' AS DateTime), N'（ーーー）', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (40, N'木村', N'キムラ', 5, N'営業部', N'課長', N'000-0000', N'東京都三鷹市上連雀', N'00-0000-0000', 1, CAST(N'2023-04-02T00:00:00.000' AS DateTime), N'・テキスト
・テキスト', CAST(N'2024-04-11T20:15:20.537' AS DateTime), N'古賀', CAST(N'2024-04-11T20:15:20.537' AS DateTime), N'古賀', 0)
INSERT [dbo].[tbl_customer] ([customerID], [customer_name], [customer_kana], [companyID], [section], [post], [zipcode], [address], [tel], [staffID], [first_action_date], [memo], [input_date], [input_staff_name], [update_date], [update_staff_name], [delete_flag]) VALUES (41, N'久保山　聡', N'クボヤマ　サトル', 18, N'営業部', N'課長', N'000-0000', N'岐阜県下呂', N'00-0000-0000', 2, CAST(N'2024-04-01T00:00:00.000' AS DateTime), N'あああああああああああああああああああああああ
', CAST(N'2024-04-30T19:11:59.160' AS DateTime), N'木島', CAST(N'2024-04-30T19:12:40.867' AS DateTime), N'木島', 0)
GO
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (1, N'古賀', N'koga', N'a0022', 1, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (2, N'木島', N'kijima', N'b2468', 0, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (3, N'中川', N'nakagawa', N'c4429', 0, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (4, N'山本', N'yamamoto', N'b7435', 0, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (5, N'坂下', N'sakasita', N'c7833', 0, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (6, N'小川', N'ogawa', N'b8765', 1, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (7, N'香山', N'kouyama', N'd2389', 0, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (8, N'但馬', N'tajima', N'a2927', 0, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (9, N'大下', N'ooshita', N'a3327', 0, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (10, N'大森', N'oomori', N'b3812', 1, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (11, N'高山', N'takayama', N'b2389', 0, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (12, N'飯島', N'iijima', N'a5644', 1, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (13, N'柳沢', N'yagisita', N'a7196', 0, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (14, N'青島', N'aoshima', N'a0016', 0, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (15, N'韮崎', N'nirasaki', N'b0023', 1, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (16, N'坂本', N'sakamoto', N'b0046', 0, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (17, N'太田', N'oota', N'b0022', 1, 0)
INSERT [dbo].[tbl_staff] ([staffID], [staff_name], [userID], [password], [admin_flag], [delete_flag]) VALUES (18, N'武', N'takeshi', N'c0022', 0, 0)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[31] 4[17] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tbl_customer"
            Begin Extent = 
               Top = 9
               Left = 451
               Bottom = 139
               Right = 639
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbl_company"
            Begin Extent = 
               Top = 21
               Left = 83
               Bottom = 151
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tbl_staff"
            Begin Extent = 
               Top = 76
               Left = 778
               Bottom = 206
               Right = 934
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 2580
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_customer_view_test'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_customer_view_test'
GO
USE [master]
GO
ALTER DATABASE [customer_action] SET  READ_WRITE 
GO
