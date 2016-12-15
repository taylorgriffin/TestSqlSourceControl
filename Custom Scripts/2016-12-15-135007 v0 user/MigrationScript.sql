/*
This migration script replaces uncommitted changes made to these objects:
Employees
Region
Territories

Use this script to make necessary schema and data changes for these objects only. Schema changes to any other objects won't be deployed.

Schema changes and migration scripts are deployed in the order they're committed.
*/

SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Dropping foreign keys from [dbo].[Territories]'
GO
ALTER TABLE [dbo].[Territories] DROP CONSTRAINT [FK_Territories_Region]
GO
PRINT N'Dropping constraints from [dbo].[Region]'
GO
ALTER TABLE [dbo].[Region] DROP CONSTRAINT [PK_Region]
GO
PRINT N'Refreshing [dbo].[Orders Qry]'
GO
EXEC sp_refreshview N'[dbo].[Orders Qry]'
GO
PRINT N'Refreshing [dbo].[Quarterly Orders]'
GO
EXEC sp_refreshview N'[dbo].[Quarterly Orders]'
GO
PRINT N'Altering [dbo].[Employees]'
GO
ALTER TABLE [dbo].[Employees] ADD
[RegionID] [int] NULL
GO
PRINT N'Refreshing [dbo].[Invoices]'
GO
EXEC sp_refreshview N'[dbo].[Invoices]'
GO
PRINT N'Refreshing [dbo].[Order Details Extended]'
GO
EXEC sp_refreshview N'[dbo].[Order Details Extended]'
GO
PRINT N'Refreshing [dbo].[Order Subtotals]'
GO
EXEC sp_refreshview N'[dbo].[Order Subtotals]'
GO
PRINT N'Refreshing [dbo].[Product Sales for 1997]'
GO
EXEC sp_refreshview N'[dbo].[Product Sales for 1997]'
GO
PRINT N'Refreshing [dbo].[Category Sales for 1997]'
GO
EXEC sp_refreshview N'[dbo].[Category Sales for 1997]'
GO
PRINT N'Refreshing [dbo].[Sales by Category]'
GO
EXEC sp_refreshview N'[dbo].[Sales by Category]'
GO
PRINT N'Refreshing [dbo].[Sales Totals by Amount]'
GO
EXEC sp_refreshview N'[dbo].[Sales Totals by Amount]'
GO
PRINT N'Refreshing [dbo].[Summary of Sales by Quarter]'
GO
EXEC sp_refreshview N'[dbo].[Summary of Sales by Quarter]'
GO
PRINT N'Refreshing [dbo].[Summary of Sales by Year]'
GO
EXEC sp_refreshview N'[dbo].[Summary of Sales by Year]'
GO
PRINT N'Altering [dbo].[Territories]'
GO
ALTER TABLE [dbo].[Territories] ADD
[Region] [nchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO

update t set Region=r.RegionDescription
from Territories t
join Region r
	on t.RegionID=r.RegionID;

update e set RegionID = t.RegionID
from Employees e
join EmployeeTerritories et
	on et.EmployeeID=e.EmployeeID
join Territories t
	on t.TerritoryID=et.TerritoryID

ALTER TABLE [dbo].[Territories] DROP
COLUMN [RegionID]
GO
PRINT N'Dropping [dbo].[Region]'
GO
DROP TABLE [dbo].[Region]
GO
