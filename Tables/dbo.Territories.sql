CREATE TABLE [dbo].[Territories]
(
[TerritoryID] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TerritoryDescription] [nchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Region] [nchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Territories] ADD CONSTRAINT [PK_Territories] PRIMARY KEY NONCLUSTERED  ([TerritoryID]) ON [PRIMARY]
GO
