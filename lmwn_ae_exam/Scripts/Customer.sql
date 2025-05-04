 ### Customer Service Team  
  * **Complaint Summary Dashboard**  
    * **Business Objective:** Get a high-level overview of all customer complaints across the platform to prioritize problem areas and improve response processes.  
    * **Required Insight:**  
    
      * Total number of issues reported during a period.  
      /*select count(ticket_id) as total_issue
    	from report_complaint_summary_dashboard*/

      * Most common categories of complaints.       
    	/*select  issue_type,issue_sub_type,count(ticket_id) as total_issue
    	from report_complaint_summary_dashboard
    	group by issue_type,issue_sub_type
    	order by total_issue desc*/
    
      * Time taken on average to resolve an issue.  
        /*select avg(time_opend_to_resolved_min)
   	 	from report_complaint_summary_dashboard
   	 	where status = 'resolved'*/

      * Volume of unresolved or escalated tickets.           
	     /*select count(ticket_id) as total_unresolved_issue
	    from report_complaint_summary_dashboard
	    where status <> 'resolved'*/
    
      * Compensation or refunds issued as part of complaint resolution. 
         /*select sum(compensation_amount)
    	from report_complaint_summary_dashboard*/

      * Trends over time in volume or resolution time.  
	    /*select business_date,count(ticket_id) as total_issue,avg(time_opend_to_resolved_min)
	    from report_complaint_summary_dashboard
	    group by business_date*/
      
  * **Driver-Related Complaints Report**  
    * **Business Objective:** Identify behavioral or performance issues related to drivers and determine if certain drivers require further training or intervention.  
    * **Required Insight:**  
    
      * Frequency of complaints tied to specific drivers.  
        /*select driver_id,issue_Type,issue_sub_type,count(order_id) as total_issue
	    from report_driver_related_complaints_report
	    where  is_order_has_complaint is true
	    group by driver_id,issue_Type,issue_sub_type*/
   
      * Type of issues raised (e.g., lateness, unprofessional conduct).  
	    /*select issue_sub_type,count(driver_id) as total_issue
	    from report_driver_related_complaints_report
	    where  is_order_has_complaint is true
	    group by issue_sub_type*/
    
      * Time required to resolve driver-related cases.  
	    /*select issue_Type,avg(time_opend_to_resolved_min)
	    from report_driver_related_complaints_report
	    where issue_Type = 'rider'
	    and is_order_has_complaint is true
	    group by issue_Type*/
	    
      * Customer satisfaction scores following complaint resolution.  
       /*select avg(csat_score)
	    from report_driver_related_complaints_report
	    where is_order_has_complaint is true*/

      * Ratio of complaints to total orders handled by each driver.  
      /*select driver_id
	    ,sum(case when is_order_has_complaint is true then 1 else 0 end) comp
	    ,count(order_id) total_order
	    ,(sum(case when is_order_has_complaint is true then 1 else 0 end)/count(order_id))*100 percent_ratio_comp
	    from report_driver_related_complaints_report
	    group by driver_id*/
      * Driver ratings before and after complaints. 
      
  * **Restaurant Quality Complaint Report**  
    * **Business Objective:** Monitor the quality of food and service provided by partner restaurants and ensure they align with platform standards.  
    * **Required Insight:**  
      * Volume of complaints linked to individual restaurants.  
      * Nature of issues raised (e.g., food quality, wrong items, missing items).  
      * Time to resolve restaurant-related issues.  
      * Total customer compensation linked to each restaurant.  
      * Ratio of complaints to total orders from the restaurant.  
      * Impact on repeat purchase behavior from customers after such issues.
      
      
    with report_complaint_summary_dashboard as 
    (
    select datetrunc('day', opened_datetime) as business_date 
    ,a.*
    ,ifnull(date_diff('min',opened_datetime,resolved_datetime),0) as time_opend_to_resolved_min
    from support_tickets a 
)
    
    ,report_driver_related_complaints_report as
    (
    select a.*
    ,issue_type
    ,issue_sub_type
    ,channel
    ,status
    ,csat_score
    ,compensation_amount
    ,resolved_by_agent_id
    ,opened_datetime
    ,resolved_datetime
    ,ifnull(date_diff('min',opened_datetime,resolved_datetime),0) as time_opend_to_resolved_min
    ,case when b.order_id is not null then true else false end as is_order_has_complaint
    from model_curated_driver_transaction a 
    left join  support_tickets b
    on a.order_id = b.order_id
    )
    
    ,report_restaurant_quality_complaint_report as
    (
    select b.*
    ,name as restaurant_name
    ,ifnull(date_diff('min',opened_datetime,resolved_datetime),0) as time_opend_to_resolved_min
    ,case when b.order_id is not null then true else false end as is_order_has_complaint
    from  support_tickets b
    left join  restaurants_master r
    on b.restaurant_id = r.restaurant_id
    )
   
    
    select * --restaurant_id,restaurant_name,count(order_id)
    from report_restaurant_quality_complaint_report
    where is_order_has_complaint is true
