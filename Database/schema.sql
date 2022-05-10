/*
--create tables

create table if not exists facilities
	(facility_id varchar not null,
	 facility_name varchar not null,
	 facility_address varchar not null,
	 facility_type varchar not null,
	 facility_category varchar not null,
	 google_lat numeric not null,
	 google_long numeric not null,
	 primary key (facility_id)  
	 )
;

create table if not exists ratings
	(facility_id varchar not null,
	 status varchar not null,
	 rating numeric,
	 price_level int,
	 total_ratings int,
	 foreign key (facility_id) references facilities(facility_id)
	 )
;

--import data


--add status column to facilities
alter table facilities 
add column status varchar;

update facilities as f
set status = (select r.status
				from ratings r
				where f.facility_id = r.facility_id)
;

select count(*) from facilities where status is null;

--investigate unwanted facility types/categories
select distinct facility_type, facility_category 
from facilities;

select 
	facility_category, 
	facility_type,
	count(facility_id)
from facilities 
where facility_category not like '%SERVICE%'
	and facility_category not like 'FAST FOOD%'
	and facility_category <> 'MOBILE UNITS'
;

select *
from facilities 
where facility_category not like '%SERVICE%'
	and facility_category not like 'FAST FOOD%'
	and facility_category <> 'MOBILE UNITS'
order by facility_category, facility_type
;

--remove unwanted categories
select *
into not_restaurants
from facilities
where facility_category in ('FOOD BANK','DAY TREATMENT PROGRAM','GROCERY FINISHED FOODS','PRE PACKAGED','RESIDENTIAL FACILITIES','SPECIAL EVENT','TEMPORARY EVENTS')
-- order by facility_category, facility_type
;

select *
into not_restaurant_ratings
from ratings
where facility_id in
	(select facility_id from not_restaurants)
;

delete from ratings
where facility_id in 
	(select facility_id from not_restaurants)
;

delete from facilities
where facility_id in 
	(select facility_id from not_restaurants)
;

commit;


--move price_level column to facilities
alter table facilities
add column price_level int
;

update facilities f
set price_level = (select r.price_level
				   from ratings r
				   where f.facility_id = r.facility_id)
;

select * from facilities 
where price_level is null
;

alter table ratings
drop column status,
drop column price_level
;

commit;


--create table to import inspections data
create table inspection_data
	(facility_id varchar not null,
	 inspection_date date not null,
	 violation_code varchar,
	 violation varchar,
	 violation_points integer,
	 violation_type varchar,
	 violation_status varchar,
	 inspection_score integer)
;

--import inspections data
select * from inspection_data;
select count(*) from inspection_data;

--delete inspections from ineligible facilities
delete from inspection_data
where facility_id not in 
	(select facility_id from facilities)
;

create table inspections as
select distinct
	facility_id,
	inspection_date,
	inspection_score
from inspection_data
;


--create violations table with known 'Out of compliance' violations
select *
into violations
from inspection_data
where violation_status = 'Out'
;

--identify inspections with null inspection statuses but no out statuses
select distinct 
	facility_id, 
	inspection_date,
	violation_points,
	violation_status,
	inspection_score
from inspection_data 
where 
	-- inspection has score > 0
	(facility_id, inspection_date) in
		(select distinct facility_id, inspection_date
		from inspections
		where inspection_score > 0)
	and (violation_status = 'Out' or violation_status is null) 
	-- inspection has a null status violation
	and (facility_id, inspection_date) in
		(select distinct facility_id, inspection_date
		 from inspection_data
		 where violation_status is null)
	-- inspection has no out statuses
	and (facility_id, inspection_date) not in
		(select distinct facility_id, inspection_date
		 from inspection_data
		 where violation_status = 'Out')
;

/* 
if an inspection has null rows and no out rows,
AND the sum of violation points for its null status rows matches inspection score,
all null rows must be out. Insert these to violations table as "out"
*/
insert into violations
	(facility_id,
	 inspection_date,
	 violation_code,
	 violation,
	 violation_points,
	 violation_type,
	 violation_status,
	 inspection_score)
select
	 facility_id,
	 inspection_date,
	 violation_code,
	 violation,
	 violation_points,
	 violation_type,
	 'Out',
	 inspection_score
from
	(select facility_id,
		 inspection_date,
		 violation_code,
		 violation,
		 violation_points,
		 violation_type,
		 inspection_score
	from
		(
		select ins.*,
			sum(violation_points) over (partition by facility_id, inspection_date) sum_violations
		from inspection_data ins
		where 
			-- inspection has score > 0
			(facility_id, inspection_date) in
				(select distinct facility_id, inspection_date
				from inspections
				where inspection_score > 0)
			and (violation_status = 'Out' or violation_status is null) 
			-- inspection has a null status violation
			and (facility_id, inspection_date) in
				(select distinct facility_id, inspection_date
				 from inspection_data
				 where violation_status is null)
			-- inspection has no out statuses
			and (facility_id, inspection_date) not in
				(select distinct facility_id, inspection_date
				 from inspection_data
				 where violation_status = 'Out')
		) sub
	where inspection_score = sum_violations
		 and violation_status is null
	) sub2
;

/* 
if an inspection has null rows and no out rows,
AND the sum of violation points for its null status rows does not match inspection score,
null rows are likely out, but full points were not added to inspection score.
Insert these to violations table as "assumed out"
*/

insert into violations
	(facility_id,
	 inspection_date,
	 violation_code,
	 violation,
	 violation_points,
	 violation_type,
	 violation_status,
	 inspection_score)
select
	 facility_id,
	 inspection_date,
	 violation_code,
	 violation,
	 violation_points,
	 violation_type,
	 'Assumed Out',
	 inspection_score
from
	(select facility_id,
		 inspection_date,
		 violation_code,
		 violation,
		 violation_points,
		 violation_type,
		 inspection_score
	from
		(
		select ins.*,
			sum(violation_points) over (partition by facility_id, inspection_date) sum_violations
		from inspection_data ins
		where 
			-- inspection has score > 0
			(facility_id, inspection_date) in
				(select distinct facility_id, inspection_date
				from inspections
				where inspection_score > 0)
			and (violation_status = 'Out' or violation_status is null) 
			-- inspection has a null status violation
			and (facility_id, inspection_date) in
				(select distinct facility_id, inspection_date
				 from inspection_data
				 where violation_status is null)
			-- inspection has no out statuses
			and (facility_id, inspection_date) not in
				(select distinct facility_id, inspection_date
				 from inspection_data
				 where violation_status = 'Out')
		) sub
	where inspection_score != sum_violations
		 and violation_status is null
	) sub2
;

select *
from violations
order by facility_id, inspection_date desc
;

select count(*) from violations;
*/

--create datasets for machine learning
select distinct
	f.facility_id,
	i.inspection_date,
	i.inspection_score,
	r.rating,
	r.total_ratings
into ml_ratings_vs_ins_scores
from facilities f
	join inspections i
		on f.facility_id = i.facility_id
	join ratings r
		on f.facility_id = r.facility_id
		
	

