### Fleet Management Team
  * **Driver Performance Report**  
    * **Business Objective:** Assess the effectiveness and reliability of delivery drivers to support workforce evaluation and operational optimization.  
    * **Required Insight:**  
    
      * Number of tasks assigned vs completed by each driver.  
      /*select driver_id
		,sum(case when is_created is true then 1 else 0 end) no_of_task, sum(case when is_completed is true then 1 else 0 end) no_of_completed
		from report_driver_performance_report a
		group by driver_id*/

      * Responsiveness in accepting jobs.  
      /*select driver_id,avg(time_start_to_accepted_min)
		from report_driver_performance_report a
		group by driver_id*/

      * Average time taken to complete a delivery.       
		/*select avg(time_start_to_finised_min)
		from report_driver_performance_report a*/

      * Frequency of late or delayed deliveries.  
      /*select sum(case when is_late_delivery is true then 1 else 0 end) no_of_late_deli
		from report_driver_performance_report*/

      * Feedback provided by customers for each driver.  
      /*select a.driver_id,a.ticket_id
		,a.issue_type
		,a.issue_sub_type
		from  report_driver_performance_report a
		where a.issue_type is not null */

      * Optional: Compare performance across vehicle types or geographic zones.     
		/*select vehicle_type,region
		,sum(case when is_created is true then 1 else 0 end) no_of_task, sum(case when is_completed is true then 1 else 0 end) no_of_completed
		from report_driver_performance_report a
		group by vehicle_type,region*/
      
  * **Delivery Zone Heatmap Report**  
    * **Business Objective:** Monitor delivery efficiency and driver supply-demand issues by geographical zones. Help with driver placement, promotions, or resource planning.  
    * **Required Insight:**  
    
      * Total volume of deliveries requested in each zone.  
      /*select delivery_zone,count(order_id)
		from report_delivery_zone_heatmap_report b
		group by delivery_zone*/

      * Completion rates within each area.  
      /*select delivery_zone, sum(case when is_completed is true then 1 else 0 end)/sum(case when is_created is true then 1 else 0 end) complete_rate
		from report_delivery_zone_heatmap_report b
		group by delivery_zone*/

      * Average delivery time in different areas or cities.  
      /*select delivery_zone,avg(time_start_to_finised_min)
		from report_delivery_zone_heatmap_report b
		where is_completed =true
		group by delivery_zone*/

      * Areas with high job rejection or cancellation due to unavailable drivers.  
      /*select delivery_zone,sum(case when is_failed is true then 1 else 0 end) as no_of_failed,sum(case when is_canceled is true then 1 else 0 end) as no_of_canceled
		from report_delivery_zone_heatmap_report
		group by delivery_zone*/
      
      * Ratio of drivers available to delivery requests (supply vs demand tension).  
      * Delivery speed vs customer expectations per zone.  
      
      
  * **Driver Incentive Impact Report**  
    * **Business Objective:** Measure whether incentive programs for drivers (e.g., bonuses) lead to improved performance or just higher costs.  
    * **Required Insight:**  
      * Driver participation in each incentive program.  
      * Volume of completed deliveries during incentive periods.  
      * Change in delivery times and acceptance rates while incentives are active.  
      * Driver satisfaction and feedback (if collected).  
      * Bonus amount paid out to each driver.  
      * Revenue generated or operational efficiency gains from these programs.

-- create model
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

-- create report
,report_driver_performance_report as (
select a.*
,issue_type
,issue_sub_type
,channel
,status
,csat_score
,compensation_amount
,join_date
,vehicle_type
,region
,active_status
,driver_rating
,bonus_tier
,ticket_id
from model_curated_driver_transaction a
left join support_tickets l
on a.order_id = l.order_id
left join drivers_master d
on a.driver_id = d.driver_id
)


