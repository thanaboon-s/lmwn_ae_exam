with latest_complained_date_by_cust as (
    select customer_id,opened_datetime as latest_complained_date,ticket_id
    from (
    select customer_id,opened_datetime,ticket_id,row_number() OVER (PARTITION BY customer_id ORDER BY opened_datetime desc) rnk
    from support_tickets ) m
    where rnk = 1 )
    
    , latest_order_date_by_cust as (
    select *
    from (
    select *,row_number() OVER (PARTITION BY t.customer_id ORDER BY order_datetime desc) rnk
    from order_transactions t ) t
	where rnk = 1 )
	
	--insert into model_curated_customers_repeat_order
	SELECT cm.customer_id
	,order_datetime as latest_order_datetime
	,latest_complained_date as latest_complained_datetime
	,case when ifnull(date_diff('min',order_datetime,latest_complained_date),0) > 0 then false
	else true end is_still_repeat_order
	from customers_master cm
	left join latest_order_date_by_cust lo
	on cm.customer_id = lo.customer_id
	left join latest_complained_date_by_cust lc
	on cm.customer_id = lc.customer_id