with trans_with_act AS (
select datetrunc('day', order_datetime) as business_date 
,t.order_id
,t.customer_id
,t.restaurant_id
,t.driver_id 
,campaign_id
,order_datetime
,pickup_datetime
,delivery_datetime
,order_status
,delivery_zone
,total_amount,payment_method 
,is_late_delivery
,delivery_distance_km 
,interaction_datetime
,event_type
,platform
,device_type
,ad_cost 
from order_transactions t
left join campaign_interactions cin
on t.order_id = cin.order_id 
)
,model_curated_active_after_purchase as (
 select customer_id
 ,min(order_datetime) min_order_datetime
 ,max(order_datetime) max_order_datetime
 ,ifnull(date_diff('day',min(order_datetime),max(order_datetime)),0) day_of_active
 from trans_with_act
 group by customer_id
)

--insert into model_curated_active_after_purchase
select *
from model_curated_active_after_purchase