CREATE TABLE [dbo].[Customers]
(
[CustomerID] [nchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CompanyName] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[Customers_HIST_IUD] ON [dbo].[Customers] FOR INSERT, UPDATE, DELETE 
AS 
BEGIN
    SET  NOCOUNT  ON

    DECLARE @ctx_info INT;
    SELECT @ctx_info = CAST(CAST(CONTEXT_INFO() AS BINARY(4)) AS INT);

    IF @ctx_info IS NOT NULL
    BEGIN
        RETURN;
    END;

    DECLARE @changetype char(1)
    DECLARE @crrntdate datetime

    SET  @crrntdate =getdate()

    BEGIN TRY

        -- to tell the type of transaction (insert, update, or delete) inserted - exist for I and U.  deleted exists for U and d.

        select @changetype = case 
            when (exists (Select 1 from Inserted)) and (not exists (Select 1 from deleted)) then 'I'
            when (not exists(Select 1 from Inserted)) and (exists (Select 1 from deleted)) then 'D'
            else 'U'
        end

        -- get inserted for insert and update -latest version
        if @changetype in ('I','U') 
            BEGIN
                INSERT INTO Customers_HIST 
                    SELECT @changetype
                         , @crrntdate
                         , *
                      FROM Inserted;
            END;
        else
            BEGIN
                INSERT INTO Customers_HIST 
                    SELECT @changetype
                         , @crrntdate
                         , *
                      FROM Deleted;
            END;
    END TRY
    BEGIN CATCH
        DECLARE 
            @nvErr NVARCHAR(MAX)    

        SET @nvErr =   'Error Msg : ' + ERROR_MESSAGE() 
                      + COALESCE(' Error Line : ' + CAST(ERROR_LINE() AS VARCHAR(10)),'')    
                      + COALESCE('. Proc Name : ' + ERROR_PROCEDURE(),'')   

        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK  
        END

        RAISERROR(@nvErr,14,1) 
    END CATCH

END 
GO
ALTER TABLE [dbo].[Customers] ADD CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED  ([CustomerID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [City] ON [dbo].[Customers] ([City]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CompanyName] ON [dbo].[Customers] ([CompanyName]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [PostalCode] ON [dbo].[Customers] ([PostalCode]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Region] ON [dbo].[Customers] ([Region]) ON [PRIMARY]
GO
