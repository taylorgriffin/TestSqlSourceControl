CREATE TABLE [dbo].[_zsDataVersion]
(
[ChangeID] [int] NOT NULL IDENTITY(1, 1),
[DateCreated] [datetime] NULL CONSTRAINT [DF___zsDataVe__DateC__5535A963] DEFAULT (getdate()),
[EmpUpdated] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScriptPath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScriptFile] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SQLDeployVersion] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
