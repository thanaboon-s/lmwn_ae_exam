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
      /*select restaurant_id,restaurant_name,count(order_id)
	    from report_restaurant_quality_complaint_report
	    where is_order_has_complaint is true
	    group by restaurant_id,restaurant_name*/
      * Nature of issues raised (e.g., food quality, wrong items, missing items). 
       /*select restaurant_id
	    ,restaurant_name
	    ,issue_type
	    ,issue_sub_type
	    ,count(order_id)
	    from report_restaurant_quality_complaint_report
	    where is_order_has_complaint is true
	    and issue_type = 'food'
	    group by restaurant_id,restaurant_name,issue_type
	    ,issue_sub_type*/
      
      * Time to resolve restaurant-related issues.  
      * Total customer compensation linked to each restaurant. 
      /*   select restaurant_id,restaurant_name,sum(compensation_amount) total_compensation_amount,count(distinct customer_id) as total_customer
		    from report_restaurant_quality_complaint_report
			group by restaurant_id,restaurant_name */
      * Ratio of complaints to total orders from the restaurant.  
      /*    select count(order_id) total_orders
		    ,sum(case when is_order_has_complaint is true then 1
		    else 0 end) as total_complaint
		    ,sum(case when is_order_has_complaint is true then 1
		    else 0 end) / count(order_id) ratio
		    from report_restaurant_quality_complaint_report*/
      * Impact on repeat purchase behavior from customers after such issues.
      /*  select case when is_still_repeat_order is false then 'Not purchased'
		    else 'Still repeat order' end as Customer_behavior
		    ,count(distinct customer_id)
		    from report_restaurant_quality_complaint_report
		    where latest_complained_datetime not null
		    group by case when is_still_repeat_order is false then 'Not purchased'
		    else 'Still repeat order' end*/
      
 
   
    
	
