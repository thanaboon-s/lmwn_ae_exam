select *
from campaign_master

select *
from 

  * **Campaign Effectiveness Report**  
    * **Business Objective:** Evaluate the performance of advertising campaigns across digital platforms and understand campaign performance in terms of user engagement, cost efficiency, and resulting transactions.  
    * **Required Insight:**  
      * Volume of exposure (e.g., ad impressions) for each campaign across time.  
      * Level of user interaction with the ads (e.g., clicks).  
      * Number of users who completed a purchase after interacting with the ad.  
      * Cost associated with running the campaign.  
      * Total revenue attributed to each campaign.  sum total amount
      * Marketing efficiency metrics (e.g., cost per acquired customer and return on advertising spend).  

with trans_with_act AS (
select t.order_id
,t.customer_id
,t.restaurant_id
,t.driver_id 
,order_datetime
,pickup_datetime
,delivery_datetime
,order_status
,delivery_zone
,total_amount,payment_method 
,is_late_delivery
,delivery_distance_km 
,campaign_id
,interaction_datetime
,event_type
,platform
,device_type,ad_cost 
,is_new_customer
from order_transactions t
left join campaign_interactions cin
on t.order_id = cin.order_id 
)
--85114
 select *
 ,case when interaction_datetime <= order_datetime then True
 else false
 end is_user_completed_purchase_after_interacting
 from trans_with_act
 where lower(order_status) = 'completed'
 
-- create table model_curated_fct_trans_interaction