CREATE TABLE [dbo].[Customers_HIST]
(
[Customers_HIST_PK] [numeric] (18, 0) NOT NULL IDENTITY(1, 1),
[EVENT_TYPE] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EVENT_DATE] [datetime] NOT NULL,
[CustomerID] [nchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CompanyName] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactName] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactTitle] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Region] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostalCode] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [nvarchar] (24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[FakeAlias] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customers_HIST] ADD CONSTRAINT [PK_Customers_HIST] PRIMARY KEY CLUSTERED  ([Customers_HIST_PK]) ON [PRIMARY]
GO
