with order_log as (
select order_id,case when sum(is_created) = 1 then true else false end is_created
,case when sum(is_completed) = 1 then true else false end is_completed
,case when sum(is_failed) = 1 then true else false end is_failed
,case when sum(is_canceled) = 1 then true else false end is_canceled
from (
		select order_id
		,case when lower(status) = 'created' then 1 else 0 end is_created
		,case when lower(status) = 'completed' then 1 else 0 end is_completed
		,case when lower(status) =  'failed' then 1 else 0 end is_failed
		,case when lower(status) =  'canceled' then 1 else 0 end is_canceled
		from order_log_incentive_sessions_order_status_logs
		) a
group by order_id
)
,order_log_start_time as (
select order_id
,case when lower(status) = 'created' then status_datetime else null end created_datetime
from order_log_incentive_sessions_order_status_logs
where case when lower(status) = 'created' then status_datetime else null end is not null
group by order_id,case when lower(status) = 'created' then status_datetime else null end
)
,order_log_end_time as (
select order_id
,case when lower(status) in  ('completed','failed','canceled') then status_datetime else null end finised_datetime
from order_log_incentive_sessions_order_status_logs
where case when lower(status)  in  ('completed','failed','canceled')  then status_datetime else null end is not null
group by order_id,case when lower(status) in  ('completed','failed','canceled') then status_datetime else null end
)
,order_log_accepted_time as (
select order_id
,case when lower(status) = 'accepted' then status_datetime else null end accepted_datetime
from order_log_incentive_sessions_order_status_logs
where case when lower(status)  = 'accepted'  then status_datetime else null end is not null
group by order_id,case when lower(status)  = 'accepted' then status_datetime else null end
)
, unique_driver_log as (
select distinct a.order_id
,case when updated_by = 'system' then b.driver_id else updated_by end updated_by
from order_log_incentive_sessions_order_status_logs a
left join order_transactions b
on a.order_id = b.order_id
where upper(case when updated_by = 'system' then b.driver_id else updated_by end) like 'DRV%'
)

, model_curated_driver_transaction as (
select l.*
,updated_by as driver_id
,created_datetime
,accepted_datetime
,finised_datetime
,ifnull(date_diff('min',created_datetime,finised_datetime),0) as time_start_to_finised_min
,ifnull(date_diff('min',created_datetime,accepted_datetime),0) as time_start_to_accepted_min
,is_late_delivery
,delivery_distance_km
,delivery_zone
from order_log l
left join unique_driver_log u
on l.order_id = u.order_id
left join order_log_start_time st
on l.order_id = st.order_id
left join order_log_end_time en
on l.order_id = en.order_id
left join order_log_accepted_time ac
on l.order_id = ac.order_id
left join order_transactions o
on l.order_id = o.order_id
where updated_by is not null
)

--insert into model_curated_driver_transaction
select *
from model_curated_driver_transaction