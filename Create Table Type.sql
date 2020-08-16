

/****** Object:  UserDefinedTableType [dbo].[_patienttable]    Script Date: 16/08/2020 10:51:23 PM ******/
CREATE TYPE [dbo].[_patienttable] AS TABLE(
	[Patient] [nvarchar](150) NULL,
	[MRN] [int] NULL,
	[CSN] [int] NULL,
	[Gender] [char](1) NULL,
	[Phone] [varchar](20) NULL,
	[SSN] [varchar](30) NULL,
	[PassportNo] [varchar](20) NULL,
	[LocationCode] [varchar](5) NULL,
	[LocationId] [int] NULL,
	[DOB] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL
)
GO


