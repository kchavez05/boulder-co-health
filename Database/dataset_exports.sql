/*
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

--create 
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
	avg(sub.violations_count) over (partition by sub.facility_id) avg_violations_count
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
		count(v.violation_code) over (partition by v.inspection_id) violations_count
	from facilities f
		join ratings r
			on f.facility_id = r.facility_id
		join violations v
			on f.facility_id = v.facility_id
	) sub
order by 1
;

select distinct 'v'||violation_code||' varchar ,' from violations order by 1;

select * from violations;

select distinct
	facility_id,
	max(case when coalesce(violation_code,0::varchar) = '01A' then 1 else 0 end) over (partition by facility_id)
from violations;
*/

create view binary_violations as
select *
from crosstab(
$$
	select
		facility_id,
		violation_code,
		case when coalesce(count(distinct inspection_id),0) > 0 then 1 else 0 end
	from violations
	group by
		facility_id,
		violation_code
	order by 1
$$,
$$
	select distinct violation_code
	from violations
	order by 1
$$
)
as
	(facility_id varchar,
	v01A varchar ,
	v01B varchar ,
	v01C varchar ,
	v01D varchar ,
	v01E varchar ,
	v01F varchar ,
	v02B varchar ,
	v02C varchar ,
	v02D varchar ,
	v02E varchar ,
	v02F varchar ,
	v02G varchar ,
	v03A varchar ,
	v03B varchar ,
	v03C varchar ,
	v03D varchar ,
	v03E varchar ,
	v03F varchar ,
	v03G varchar ,
	v04A varchar ,
	v04B varchar ,
	v04C varchar ,
	v05A varchar ,
	v05B varchar ,
	v05C varchar ,
	v05D varchar ,
	v06A varchar ,
	v06B varchar ,
	v06C varchar ,
	v07A varchar ,
	v07B varchar ,
	v07C varchar ,
	v08A varchar ,
	v08B varchar ,
	v08C varchar ,
	v09A varchar ,
	v09B varchar ,
	v10A varchar ,
	v10B varchar ,
	v10C varchar ,
	v11A varchar ,
	v11B varchar ,
	v11C varchar ,
	v12A varchar ,
	v12B varchar ,
	v12C varchar ,
	v12D varchar ,
	v13A varchar ,
	v13B varchar ,
	v13C varchar ,
	v14A varchar ,
	v14B varchar ,
	v14C varchar ,
	v14D varchar ,
	v14E varchar ,
	v14F varchar ,
	v14G varchar ,
	v14I varchar ,
	v15A varchar ,
	v15B varchar ,
	vFC01 varchar ,
	vFC02 varchar ,
	vFC03 varchar ,
	vFC05 varchar ,
	vFC06 varchar ,
	vFC08 varchar ,
	vFC09 varchar ,
	vFC10 varchar ,
	vFC11 varchar ,
	vFC13 varchar ,
	vFC14 varchar ,
	vFC15 varchar ,
	vFC16 varchar ,
	vFC18 varchar ,
	vFC19 varchar ,
	vFC20 varchar ,
	vFC21 varchar ,
	vFC22 varchar ,
	vFC23 varchar ,
	vFC24 varchar ,
	vFC25 varchar ,
	vFC27 varchar ,
	vFC28 varchar ,
	vFC29 varchar ,
	vFC33 varchar ,
	vFC35 varchar ,
	vFC36 varchar ,
	vFC37 varchar ,
	vFC38 varchar ,
	vFC39 varchar ,
	vFC40 varchar ,
	vFC41 varchar ,
	vFC42 varchar ,
	vFC43 varchar ,
	vFC45 varchar ,
	vFC47 varchar ,
	vFC48 varchar ,
	vFC49 varchar ,
	vFC50 varchar ,
	vFC51 varchar ,
	vFC52 varchar ,
	vFC55 varchar ,
	vFC56 varchar 
)
;

create view violations_count as
select *
from crosstab(
$$
	select
		facility_id,
		violation_code,
		count(distinct inspection_id))
	from violations
	group by
		facility_id,
		violation_code
	order by 1
$$,
$$
	select distinct violation_code
	from violations
	order by 1
$$
)
as
	(facility_id varchar,
	v01A varchar ,
	v01B varchar ,
	v01C varchar ,
	v01D varchar ,
	v01E varchar ,
	v01F varchar ,
	v02B varchar ,
	v02C varchar ,
	v02D varchar ,
	v02E varchar ,
	v02F varchar ,
	v02G varchar ,
	v03A varchar ,
	v03B varchar ,
	v03C varchar ,
	v03D varchar ,
	v03E varchar ,
	v03F varchar ,
	v03G varchar ,
	v04A varchar ,
	v04B varchar ,
	v04C varchar ,
	v05A varchar ,
	v05B varchar ,
	v05C varchar ,
	v05D varchar ,
	v06A varchar ,
	v06B varchar ,
	v06C varchar ,
	v07A varchar ,
	v07B varchar ,
	v07C varchar ,
	v08A varchar ,
	v08B varchar ,
	v08C varchar ,
	v09A varchar ,
	v09B varchar ,
	v10A varchar ,
	v10B varchar ,
	v10C varchar ,
	v11A varchar ,
	v11B varchar ,
	v11C varchar ,
	v12A varchar ,
	v12B varchar ,
	v12C varchar ,
	v12D varchar ,
	v13A varchar ,
	v13B varchar ,
	v13C varchar ,
	v14A varchar ,
	v14B varchar ,
	v14C varchar ,
	v14D varchar ,
	v14E varchar ,
	v14F varchar ,
	v14G varchar ,
	v14I varchar ,
	v15A varchar ,
	v15B varchar ,
	vFC01 varchar ,
	vFC02 varchar ,
	vFC03 varchar ,
	vFC05 varchar ,
	vFC06 varchar ,
	vFC08 varchar ,
	vFC09 varchar ,
	vFC10 varchar ,
	vFC11 varchar ,
	vFC13 varchar ,
	vFC14 varchar ,
	vFC15 varchar ,
	vFC16 varchar ,
	vFC18 varchar ,
	vFC19 varchar ,
	vFC20 varchar ,
	vFC21 varchar ,
	vFC22 varchar ,
	vFC23 varchar ,
	vFC24 varchar ,
	vFC25 varchar ,
	vFC27 varchar ,
	vFC28 varchar ,
	vFC29 varchar ,
	vFC33 varchar ,
	vFC35 varchar ,
	vFC36 varchar ,
	vFC37 varchar ,
	vFC38 varchar ,
	vFC39 varchar ,
	vFC40 varchar ,
	vFC41 varchar ,
	vFC42 varchar ,
	vFC43 varchar ,
	vFC45 varchar ,
	vFC47 varchar ,
	vFC48 varchar ,
	vFC49 varchar ,
	vFC50 varchar ,
	vFC51 varchar ,
	vFC52 varchar ,
	vFC55 varchar ,
	vFC56 varchar 
)
;
