USE [master]
GO
/****** Object:  Database [PatientDb]    Script Date: 16/08/2020 5:54:02 PM ******/
CREATE DATABASE [PatientDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PatientDb', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\PatientDb.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'PatientDb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\PatientDb_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [PatientDb] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PatientDb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PatientDb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PatientDb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PatientDb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PatientDb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PatientDb] SET ARITHABORT OFF 
GO
ALTER DATABASE [PatientDb] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PatientDb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PatientDb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PatientDb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PatientDb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PatientDb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PatientDb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PatientDb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PatientDb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PatientDb] SET  DISABLE_BROKER 
GO
ALTER DATABASE [PatientDb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PatientDb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PatientDb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PatientDb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PatientDb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PatientDb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PatientDb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PatientDb] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [PatientDb] SET  MULTI_USER 
GO
ALTER DATABASE [PatientDb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PatientDb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PatientDb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PatientDb] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [PatientDb] SET DELAYED_DURABILITY = DISABLED 
GO
USE [PatientDb]
GO



CREATE TABLE [dbo].[PatientTbl](
	[Patient] [nvarchar](150) NULL,
	[MRN] [int] NOT NULL,
	[CSN] [int] NULL,
	[Gender] [char](1) NULL,
	[Phone] [varchar](20) NULL,
	[SSN] [varchar](30) NULL,
	[PassportNo] [varchar](20) NULL,
	[LocationCode] [varchar](5) NULL,
	[LocationId] [int] NULL,
	[DOB] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
 CONSTRAINT [PK_MRN] PRIMARY KEY CLUSTERED 
(
	[MRN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[uspGetPatientDetails]    Script Date: 16/08/2020 5:54:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[uspGetPatientDetails]
(
@Status as int out,
@Message as nvarchar(max) out,
@lang NVARCHAR(MAX) ='en-US',
@SrchText nvarchar(250)=''
)
as
begin
	set nocount on
		set @Status = 0
	set @Message = 'Success'
	select	Patient,MRN,CSN,Case when Gender = 'F' then 'Female' else 'Male' end Gender,
			Phone,SSN,PassportNo,LocationCode,LocationId,DOB,UpdateDateTime
	from	DBO.PatientTbl P with(nolock)

	where
			(
				MRN like  @SrchText 
			)

end
GO
/****** Object:  StoredProcedure [dbo].[uspInsertBulkRow]    Script Date: 16/08/2020 5:54:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[uspInsertBulkRow]
(
@TABLEVARIABLE _PATIENTTABLE READONLY/*Data table passed from service
Contains all rows in a text file*/
)
AS
BEGIN
		INSERT INTO PATIENTTBL(
								PATIENT,MRN,CSN,GENDER,PHONE,SSN,PASSPORTNO,
								LOCATIONCODE,LOCATIONID,DOB,UPDATEDATETIME
							  )
		SELECT					TP.PATIENT,TP.MRN,TP.CSN,TP.GENDER,TP.PHONE,
								TP.SSN,TP.PASSPORTNO,TP.LOCATIONCODE,
								TP.LOCATIONID,TP.DOB,TP.UPDATEDATETIME 
		FROM		@TABLEVARIABLE TP
		LEFT JOIN	PATIENTTBL PT 
		ON			TP.MRN = PT.MRN 
		WHERE		PT.MRN IS NULL  /*left Joining tablevariale with patient table 
										Data will insert id patient table MRN column is null*/


		UPDATE		PT		SET			PT.PATIENT = TP.PATIENT,PT.GENDER=TP.GENDER,
										PT.CSN=TP.CSN,PT.SSN=TP.SSN,PT.PASSPORTNO = TP.PASSPORTNO,
										PT.LOCATIONCODE = TP.LOCATIONCODE,PT.LOCATIONID = TP.LOCATIONID,
										PT.DOB = TP.DOB,PT.UPDATEDATETIME = TP.UPDATEDATETIME 
							FROM		@TABLEVARIABLE TP
							LEFT JOIN	PATIENTTBL PT 
							ON			TP.MRN = PT.MRN 
							WHERE		PT.MRN IS NOT NULL
							/*left Joining tablevariale with patient table 
										Data will insert id patient table MRN column is NOT NULL*/
END
GO

USE [master]
GO
ALTER DATABASE [PatientDb] SET  READ_WRITE 
GO
