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

,model_curated_marketing_transaction as (
 select t.*
 ,case when interaction_datetime <= order_datetime then True
 else false
 end is_user_completed_purchase_after_interacting
 ,ifnull(date_diff('min',interaction_datetime,order_datetime),0) as diff_interact_order_min
 from trans_with_act t
 --and business_date between start_date and end_date
 )
 
 --insert into model_curated_marketing_transaction
 select *
 from model_curated_marketing_transaction