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


	