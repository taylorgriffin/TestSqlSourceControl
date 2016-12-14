/*
Use this migration script to make data changes only. You must commit any additive schema changes first.
Schema changes and migration scripts are deployed in the order they're committed.
*/

update e set RegionID = t.RegionID
from Employees e
join EmployeeTerritories et
	on et.EmployeeID=e.EmployeeID
join Territories t
	on t.TerritoryID=et.TerritoryID
