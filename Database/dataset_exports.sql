
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
		on f.facility_id = r.facility_idstat
;

--create facility view for tableau
drop view tableau_facility_data;
create view tableau_facility_data as
select distinct 
	sub.facility_id,
	sub.facility_name,
	sub.google_lat,
	sub.google_long,
	sub.price_level,
	sub.rating,
	sub.total_ratings,
	sub.avg_inspection_score,
	avg(sub.violations_count) over (partition by sub.facility_id) avg_violations_count,
	inspection_count
from (
	select distinct
		f.facility_id,
		f.facility_name,
		f.google_lat,
		f.google_long,
		f.price_level,
		r.rating,
		r.total_ratings,
		avg(v.inspection_score) over (partition by f.facility_id) avg_inspection_score,
		count(v.violation_code) over (partition by v.inspection_id) violations_count,
		count(v.inspection_id) over (partition by v.facility_id) inspection_count
	from facilities f
		join ratings r
			on f.facility_id = r.facility_id
		join violations v
			on f.facility_id = v.facility_id
	) sub
order by 1
;

select distinct violation_code_norm||' int ,' from violations_norm order by 1;


select distinct
	facility_id,
	max(case when coalesce(violation_code,0::varchar) = '01A' then 1 else 0 end) over (partition by facility_id)
from violations;


select * from violations_norm;

--create pivot table of whether a facility has ever received a particular violation

create table binary_violations_pivot as
select *
from crosstab(
$$
	select
		facility_id,
		violation_code_norm,
		case when coalesce(count(distinct inspection_id),0) > 0 then 1 else 0 end
	from violations_norm
	group by
		facility_id,
		violation_code_norm
	order by 1
$$,
$$
	select distinct violation_code_norm
	from violations_norm
	order by 1
$$
)
as
	(facility_id varchar,
	FC01 int ,
	FC02 int ,
	FC03 int ,
	FC04 int ,
	FC05 int ,
	FC06 int ,
	FC08 int ,
	FC09 int ,
	FC10 int ,
	FC11 int ,
	FC13 int ,
	FC14 int ,
	FC15 int ,
	FC16 int ,
	FC18 int ,
	FC19 int ,
	FC20 int ,
	FC21 int ,
	FC22 int ,
	FC23 int ,
	FC24 int ,
	FC25 int ,
	FC27 int ,
	FC28 int ,
	FC29 int ,
	FC31 int ,
	FC33 int ,
	FC35 int ,
	FC36 int ,
	FC37 int ,
	FC38 int ,
	FC39 int ,
	FC40 int ,
	FC41 int ,
	FC42 int ,
	FC43 int ,
	FC44 int ,
	FC45 int ,
	FC46 int ,
	FC47 int ,
	FC48 int ,
	FC49 int ,
	FC50 int ,
	FC51 int ,
	FC52 int ,
	FC53 int ,
	FC54 int ,
	FC55 int ,
	FC56 int ,
	FC57 int 
)
;

select * from binary_violations_pivot;
select * from violations where violation_code = 'FC12';

--create pivot table of the number of times a facility has received a particular violation
drop table violations_count_pivot;
create table violations_count_pivot as
select *
from crosstab(
$$
	select
		facility_id,
		violation_code_norm,
		count(distinct inspection_id)
	from violations_norm
	group by
		facility_id,
		violation_code_norm
	order by 1
$$,
$$
	select distinct violation_code_norm
	from violations_norm
	order by 1
$$
)
as
	(facility_id varchar,
	FC01 int ,
	FC02 int ,
	FC03 int ,
	FC04 int ,
	FC05 int ,
	FC06 int ,
	FC08 int ,
	FC09 int ,
	FC10 int ,
	FC11 int ,
	FC13 int ,
	FC14 int ,
	FC15 int ,
	FC16 int ,
	FC18 int ,
	FC19 int ,
	FC20 int ,
	FC21 int ,
	FC22 int ,
	FC23 int ,
	FC24 int ,
	FC25 int ,
	FC27 int ,
	FC28 int ,
	FC29 int ,
	FC31 int ,
	FC33 int ,
	FC35 int ,
	FC36 int ,
	FC37 int ,
	FC38 int ,
	FC39 int ,
	FC40 int ,
	FC41 int ,
	FC42 int ,
	FC43 int ,
	FC44 int ,
	FC45 int ,
	FC47 int ,
	FC48 int ,
	FC49 int ,
	FC50 int ,
	FC51 int ,
	FC52 int ,
	FC53 int ,
	FC54 int ,
	FC55 int ,
	FC56 int ,
	FC57 int 
)
;
select distinct violation_category from violations_norm order by 1;

--create pivot table of whether a facility has ever received a violation of a particular category
drop table binary_violation_cats_pivot;
create table binary_violation_cats_pivot as
select *
from crosstab(
$$
	select
		facility_id,
		violation_category,
		case when coalesce(count(distinct violation_category),0) > 0 then 1 else 0 end
	from violations_norm
	group by
		facility_id,
		violation_category
	order by 1
$$,
$$
	select distinct violation_category
	from violations_norm
	order by 1
$$
)
as
	(facility_id varchar,
	 cat_1 int,
	 cat_2 int,
	 cat_3 int,
	 cat_5 int,
	 cat_6 int,
	 cat_7 int,
	 cat_8 int,
	 cat_9 int,
	 cat_10 int,
	 cat_12 int,
	 cat_13 int,
	 cat_14 int)
;

--create pivot table of the number of times a facility has ever received a violation of a particular category
drop table violation_cat_counts_pivot;
create table violation_cat_counts_pivot as
select *
from crosstab(
$$
	select
		facility_id,
		violation_category,
		count(distinct inspection_id)
	from violations_norm
	group by
		facility_id,
		violation_category
	order by 1
$$,
$$
	select distinct violation_category
	from violations_norm
	order by 1
$$
)
as
	(facility_id varchar,
	 cat_1 int,
	 cat_2 int,
	 cat_3 int,
	 cat_5 int,
	 cat_6 int,
	 cat_7 int,
	 cat_8 int,
	 cat_9 int,
	 cat_10 int,
	 cat_12 int,
	 cat_13 int,
	 cat_14 int)
;

select * from violation_cat_counts_pivot;
select distinct
	facility_id,
	count(distinct inspection_id)
from inspections
group by facility_id;

drop table violations_crosswalk_readable;
select distinct
	cw.violation_category,
	cw.vcat_title category_title,
	vn.violation_code new_code,
	vn.violation new_code_title,
	vo.violation_code old_code,
	vo.violation old_code_title
into violations_crosswalk_readable
from violations_crosswalk cw
	join inspection_data vo
		on cw.old_code = vo.violation_code
	join inspection_data vn
		on cw.new_code = vn.violation_code
order by 1,3,5
;






