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

