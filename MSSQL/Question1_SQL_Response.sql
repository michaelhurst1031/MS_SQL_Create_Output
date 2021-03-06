USE [master]
GO
/****** Object:  Database [SPOT_TEST]    Script Date: 7/27/2020 2:57:32 PM ******/
CREATE DATABASE [SPOT_TEST]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SPOT_TEST', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS01\MSSQL\DATA\SPOT_TEST.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SPOT_TEST_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS01\MSSQL\DATA\SPOT_TEST_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [SPOT_TEST] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SPOT_TEST].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [SPOT_TEST] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SPOT_TEST] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SPOT_TEST] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SPOT_TEST] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SPOT_TEST] SET ARITHABORT OFF 
GO
ALTER DATABASE [SPOT_TEST] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [SPOT_TEST] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SPOT_TEST] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SPOT_TEST] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SPOT_TEST] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [SPOT_TEST] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SPOT_TEST] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SPOT_TEST] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SPOT_TEST] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SPOT_TEST] SET  DISABLE_BROKER 
GO
ALTER DATABASE [SPOT_TEST] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SPOT_TEST] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [SPOT_TEST] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [SPOT_TEST] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [SPOT_TEST] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SPOT_TEST] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [SPOT_TEST] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [SPOT_TEST] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [SPOT_TEST] SET  MULTI_USER 
GO
ALTER DATABASE [SPOT_TEST] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [SPOT_TEST] SET DB_CHAINING OFF 
GO
ALTER DATABASE [SPOT_TEST] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [SPOT_TEST] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [SPOT_TEST] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [SPOT_TEST] SET QUERY_STORE = OFF
GO
USE [SPOT_TEST]
GO
/****** Object:  UserDefinedFunction [dbo].[age_in_years]    Script Date: 7/27/2020 2:57:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[age_in_years]
(
  @birth_date  datetime
  , @eval_date datetime
)
returns int
as
begin
  /*
  - Calculate the age in fully passed calendar years: it is the diff in years then
    subtract a year if birthday hasn't occurred yet. This means 29 Feb birthdays 
    are observed on 1 Mar on non-leap years.
  - Returns null if either argument is null or @eval_date < @birth_date.
  - Returns 0 until age 1.
  */
  return 
    case
      when @birth_date is null or @eval_date is null then null
      when @birth_date > @eval_date then null
      when @birth_date = @eval_date then 0
      else year(@eval_date) - year(@birth_date)
        - case /* make dates MMDD vs MMDD to check if the eval date is before the birth date*/
            when ((month(@eval_date) * 100) + day(@eval_date)) < ((month(@birth_date) * 100) + day(@birth_date)) then 1
            else 0
          end 
    end
end
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 7/27/2020 2:57:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[EmployeeID] [bigint] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](255) NULL,
	[LastName] [varchar](255) NULL,
	[PositionID] [bigint] NULL,
	[DOB] [datetime] NULL,
	[ReportsTo] [bigint] NULL,
	[IsActive] [int] NOT NULL,
	[EnteredBy] [varchar](255) NOT NULL,
	[EnteredDateTime] [datetime] NOT NULL,
	[UpdatedBy] [varchar](255) NULL,
	[UpdatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Position]    Script Date: 7/27/2020 2:57:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Position](
	[PositionID] [bigint] IDENTITY(1,1) NOT NULL,
	[PositionTitle] [varchar](255) NULL,
 CONSTRAINT [PK_Position] PRIMARY KEY CLUSTERED 
(
	[PositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Employee] ON 

INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [LastName], [PositionID], [DOB], [ReportsTo], [IsActive], [EnteredBy], [EnteredDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (1, N'Bob', N'Boss', NULL, NULL, NULL, 1, N'1', CAST(N'2020-07-27T13:40:34.093' AS DateTime), NULL, NULL)
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [LastName], [PositionID], [DOB], [ReportsTo], [IsActive], [EnteredBy], [EnteredDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (2, N'Daniel', N'Smith', 1, CAST(N'1994-12-01T00:00:00.000' AS DateTime), 1, 1, N'1', CAST(N'2020-07-27T13:57:21.127' AS DateTime), NULL, NULL)
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [LastName], [PositionID], [DOB], [ReportsTo], [IsActive], [EnteredBy], [EnteredDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (3, N'Robert', N'Black', 4, CAST(N'1997-12-01T00:00:00.000' AS DateTime), 2, 1, N'1', CAST(N'2020-07-27T14:01:50.917' AS DateTime), NULL, NULL)
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [LastName], [PositionID], [DOB], [ReportsTo], [IsActive], [EnteredBy], [EnteredDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (4, N'Jenny', N'Richards', 3, CAST(N'1974-12-01T00:00:00.000' AS DateTime), NULL, 1, N'1', CAST(N'2020-07-27T14:03:18.280' AS DateTime), NULL, NULL)
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [LastName], [PositionID], [DOB], [ReportsTo], [IsActive], [EnteredBy], [EnteredDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (5, N'Noah', N'Fritz', 5, CAST(N'1989-12-01T00:00:00.000' AS DateTime), 4, 1, N'1', CAST(N'2020-07-27T14:08:56.370' AS DateTime), NULL, NULL)
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [LastName], [PositionID], [DOB], [ReportsTo], [IsActive], [EnteredBy], [EnteredDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (6, N'David', N'S', 6, CAST(N'1987-12-01T00:00:00.000' AS DateTime), 4, 1, N'1', CAST(N'2020-07-27T14:10:36.327' AS DateTime), NULL, NULL)
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [LastName], [PositionID], [DOB], [ReportsTo], [IsActive], [EnteredBy], [EnteredDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (7, N'Ashley', N'Wells', 5, CAST(N'1994-12-01T00:00:00.000' AS DateTime), 6, 1, N'1', CAST(N'2020-07-27T14:11:36.043' AS DateTime), NULL, NULL)
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [LastName], [PositionID], [DOB], [ReportsTo], [IsActive], [EnteredBy], [EnteredDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (8, N'Ashley', N'Johnson', 7, CAST(N'1994-12-01T00:00:00.000' AS DateTime), NULL, 1, N'1', CAST(N'2020-07-27T14:12:13.610' AS DateTime), NULL, NULL)
INSERT [dbo].[Employee] ([EmployeeID], [FirstName], [LastName], [PositionID], [DOB], [ReportsTo], [IsActive], [EnteredBy], [EnteredDateTime], [UpdatedBy], [UpdatedDateTime]) VALUES (9, N'Mike', N'White', 2, CAST(N'1997-12-01T00:00:00.000' AS DateTime), 1, 1, N'1', CAST(N'2020-07-27T14:35:14.897' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[Employee] OFF
GO
SET IDENTITY_INSERT [dbo].[Position] ON 

INSERT [dbo].[Position] ([PositionID], [PositionTitle]) VALUES (1, N'Engineer')
INSERT [dbo].[Position] ([PositionID], [PositionTitle]) VALUES (2, N'Contractor')
INSERT [dbo].[Position] ([PositionID], [PositionTitle]) VALUES (3, N'CEO')
INSERT [dbo].[Position] ([PositionID], [PositionTitle]) VALUES (4, N'Sales')
INSERT [dbo].[Position] ([PositionID], [PositionTitle]) VALUES (5, N'Assistant')
INSERT [dbo].[Position] ([PositionID], [PositionTitle]) VALUES (6, N'Director')
INSERT [dbo].[Position] ([PositionID], [PositionTitle]) VALUES (7, N'Intern')
SET IDENTITY_INSERT [dbo].[Position] OFF
GO
/****** Object:  StoredProcedure [dbo].[GET_ReportsToInfo]    Script Date: 7/27/2020 2:57:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GET_ReportsToInfo]
AS
BEGIN
	declare @SupervisedDemographics AS TABLE
	(
		ReportsTo varchar(max),
		AgeOfEmployee int,
		TotalEmployee int
	)

	INSERT INTO @SupervisedDemographics (ReportsTo,AgeOfEmployee,TotalEmployee)
	SELECT
		E2.FirstName+' '+E2.LastName,
		dbo.age_in_years(E.DOB,getdate()),
		1
	FROM 
		dbo.Employee E
		INNER JOIN dbo.Employee E2 ON E.ReportsTo=E2.EmployeeID
	WHERE 
		E.ReportsTo IS NOT NULL

	SELECT 
		D.ReportsTo,
		SUM(D.TotalEmployee) AS Members,
		CEILING(AVG(CAST(D.AgeOfEmployee AS decimal(18,2)))) AS Average_Age
	FROM 
		@SupervisedDemographics D
	GROUP BY 
		D.ReportsTo
	ORDER BY 
		D.ReportsTo
END
GO
/****** Object:  StoredProcedure [dbo].[WRITE_EMPLOYEE]    Script Date: 7/27/2020 2:57:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WRITE_EMPLOYEE]	
	@FirstName varchar(255),
	@LastName varchar(255),
	@PositionID bigint,
	@DOB datetime,
	@ReportsTo bigint,
	@ISActive int,
	@UserID int
AS
BEGIN

	INSERT INTO dbo.Employee
	(
		FirstName,
		LastName,
		PositionID,
		DOB,
		ReportsTo,
		IsActive,
		EnteredBy,
		EnteredDateTime
	)
     VALUES
	(
		@FirstName,
		@LastName,
		@PositionID,
		@DOB,
		@ReportsTo,
		@ISActive,
		@UserID,
		getdate()
	)
END
GO
USE [master]
GO
ALTER DATABASE [SPOT_TEST] SET  READ_WRITE 
GO
