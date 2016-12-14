/*
Use this migration script to make data changes only. You must commit any additive schema changes first.
Schema changes and migration scripts are deployed in the order they're committed.
*/

update t set Region=r.RegionDescription
from Territories t
join Region r
	on t.RegionID=r.RegionID;
