/*create or replace table model_curated_marketing_transaction 
 (
 business_date date not null,
 order_id VARCHAR(9) not null,
 customer_id VARCHAR(9) not null,
 restaurant_id VARCHAR(7) not null,
 driver_id VARCHAR(6) not null,
 campaign_id VARCHAR(6),
 order_datetime datetime not null,
 pickup_datetime datetime not null,
 delivery_datetime datetime not null,
 order_status VARCHAR(50) not null,
 delivery_zone VARCHAR(50) not null,
 total_amount decimal(18,2) not null,
 payment_method VARCHAR(50) not null,
 is_late_delivery boolean not null,
 delivery_distance_km decimal(18,2) not null,
 interaction_datetime datetime,
 event_type VARCHAR(50),
 platform VARCHAR(50),
 device_type VARCHAR(50),
 ad_cost decimal(18,2),
 is_user_completed_purchase_after_interacting boolean not null,
 diff_interact_order_min int
 /*campaign_name VARCHAR(50),
 start_date date,
 end_date date,
 campaign_type VARCHAR(50),
 objective VARCHAR(50),
 channel VARCHAR(50),
 targeting_strategy VARCHAR(50)*/
 )

/*create or replace table model_curated_active_after_purchase 
 (
 customer_id VARCHAR(9) not null,
 min_order_datetime datetime not null,
 max_order_datetime datetime not null,
 day_of_active int not null
 )*/
 
/* create table model_curated_driver_transaction
(
order_id VARCHAR(9) not null
,is_created boolean not null
,is_completed boolean not null
,is_failed boolean not null
,is_canceled boolean not null
,driver_id VARCHAR(6) not null
,created_datetime datetime 
,accepted_datetime datetime 
,finised_datetime datetime 
,time_start_to_finised_min int not null
,time_start_to_accepted_min int not null
,is_late_delivery boolean not null
,delivery_distance_km decimal(18,2) not null
,delivery_zone VARCHAR(50) not null
)
*/
 
 /*insert into model_curated_marketing_transaction
select *
from model_curated_marketing_transaction*/
 /*insert into model_curated_active_after_purchase
 select *
 from model_curated_active_after_purchase*/
 
/*insert into model_curated_driver_transaction
select *
from model_curated_driver_transaction*/
 
 /*	 create table model_curated_customers_repeat_order
(
customer_id VARCHAR(9) not null
,latest_order_datetime datetime 
,latest_complained_datetime datetime 
,is_still_repeat_order boolean not null
)
*/