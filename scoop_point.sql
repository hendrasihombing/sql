select
	INITCAP(cas_users.first_name) || ' ' ||INITCAP(cas_users.last_name )as nama_user,
	username as scoop_id,
	sum(point )as total_scoop_point
from
	core_pointprofiles
	JOIN cas_users ON  cas_users.id = core_pointprofiles.user_id
Group by INITCAP(cas_users.first_name) || ' ' ||INITCAP(cas_users.last_name ), username
order by total_scoop_point desc


select * from core_pointprofiles limit 10