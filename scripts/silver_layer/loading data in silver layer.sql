create or alter procedure silver.load_silver as
begin
     declare @start_time datetime , @end_time  datetime,@start_total_time datetime ,@end_total_time datetime;
  begin try 
  set @start_total_time=getdate()
        -- crm table inserting 
        print('==========================')
        print('loading silver layer')
        print('==========================')
    
        print('-----------------------------')
        print('load crm tables')
        print('-----------------------------');
        -- insertin data into first table in crm
        set @start_time = getdate();
        print 'truncating table : silver.crm_cust_info'
        truncate table silver.crm_cust_info
        print 'inserting data into : silver.crm_cust_info'
        insert into silver.crm_cust_info(
               [cst_id]
              ,[cst_key]
              ,[cst_firstname]
              ,[cst_lastname]
              ,[cst_marital_status]
              ,[cst_gndr]
              ,[cst_create_date]
            )
        select 
        cst_id,
        cst_key,
        trim(cst_firstname) as cst_firstname,
        trim(cst_lastname) as cst_lastname,
        case 
	        when upper(trim(cst_marital_status)) ='S' then 'Single'
	        when upper(trim(cst_marital_status))='M' then 'Married'
	        else 'n/a'
        end cst_marital_status,
        case 
	        when upper(trim(cst_gndr)) ='F' then 'Female'
	        when upper(trim(cst_gndr))='M' then 'Male'
	        else 'n/a'
        end cst_gndr,
        cst_create_date
        from(
        select *,
        row_number() over(partition by cst_id order by cst_create_date desc) as last_edit
        from bronze.crm_cust_info
        where cst_id is not null
        )t 
        where  last_edit=1
         set @end_time=GETDATE()
        print'total time of loadin crm_cust_info table is '+ cast(datediff(MILLISECOND,@start_time,@end_time)as nvarchar)+ ' ms'
        
        -- insertin data into second table in crm
        set @start_time = getdate();
        print 'truncating table : silver.crm_prd_info'
        truncate table silver.crm_prd_info
        print 'inserting data into : silver.crm_prd_info'
        insert into silver.crm_prd_info(
              [prd_id]
              ,[cat_id]
              ,[prd_key]
              ,[prd_name]
              ,[prd_cost]
              ,[prd_line]
              ,[prd_start_dt]
              ,[prd_end_dt]
        )
        select 
               [prd_id]
              ,replace(substring(prd_key,1,5) ,'-','_') as cat_id
              ,substring(prd_key,7,len(prd_key)) as prd_key
              ,[prd_name]
              ,isnull(prd_cost,0) as prd_cost
              , 
              case upper(trim(prd_line))
                  when 'M' then 'Mountain'
                  when 'R' then 'Road'
                  when 'S' then 'other Sales'
                  when 'T' then 'Touring'
                  else 'n/a'
              end as prd_line
              ,cast([prd_start_dt] as date) as prd_start_dt
              , cast(lead(prd_start_dt) over (partition  by prd_key order by prd_start_dt)-1  
                  as date
              )as prd_end_dt
        from bronze.crm_prd_info
         set @end_time=GETDATE()
        print'total time of loading silver.crm_prd_info table is '+ cast(datediff(MILLISECOND,@start_time,@end_time)as nvarchar)+ ' ms'
        
        -- insertin data into threed table in crm
        set @start_time = getdate();
        print 'truncating table : silver.crm_sales_details'
        truncate table silver.crm_sales_details
        print 'inserting data into : silver.crm_sales_details'
        insert into silver.crm_sales_details(
               [sls_ord_num]
              ,[sls_prd_key]
              ,[sls_cust_id]
              ,[sls_order_dt]
              ,[sls_ship_dt]
              ,[sls_due_dt]
              ,[sls_sales]
              ,[sls_quantity]
              ,[sls_price]
        )
        select
               [sls_ord_num]
              ,[sls_prd_key]
              ,[sls_cust_id]
              ,case 
                   when [sls_order_dt]=0 or 
                        len(sls_order_dt) !=8 then null
                   else cast(cast([sls_order_dt] as varchar) as date)
                end as sls_order_dt
              ,case 
                   when [sls_ship_dt]=0 or 
                        len([sls_ship_dt]) !=8 then null
                   else cast(cast([sls_ship_dt] as varchar) as date)
               end as sls_ship_dt
              ,case 
                   when [sls_due_dt]=0 or 
                        len([sls_due_dt]) !=8 then null
                   else cast(cast([sls_due_dt] as varchar) as date)
                end as sls_due_dt
               ,case 
                   when sls_sales is null or sls_sales<=0 
                        or sls_sales!= sls_quantity * abs(sls_price)
                   then sls_quantity * abs(sls_price)
                   else sls_sales
                end as sls_sales 
               ,[sls_quantity]
               ,case 
                   when sls_price is null or sls_price<=0
                   then sls_sales/nullif(sls_quantity,0)
                   else sls_price 
               end
        from bronze.crm_sales_details
         set @end_time=GETDATE()
        print'total time of loadin crm_sales_details table is '+ cast(datediff(MILLISECOND,@start_time,@end_time)as nvarchar)+ ' ms'
        
        print'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
        print('==========================')
        print('loading silber layer')
        print('==========================')
    
        print('-----------------------------')
        print('load crm tables')
        print('-----------------------------');
        -- insertin data in first tabel in erp
        set @start_time = getdate();
        print 'truncating table : silver.erp_CUST_AZ12'
        truncate table silver.erp_CUST_AZ12
        print 'inserting data into : silver.erp_CUST_AZ12'
        insert into silver.erp_CUST_AZ12 (cid,bdate,gen)
        select  
            case 
                   when cid like 'NAS%' then substring(cid,4,len(cid))
                   else cid
            end as cid
            ,case 
                   when bdate>getdate() then null
                   else bdate
             end as bdate
            ,case 
                  when upper(trim(gen))in ('F','FEMALE') then 'Female'
                  when upper(trim(gen))in ('M','MALe')  then 'Male'
             end gen
        from bronze.erp_CUST_AZ12
         set @end_time=GETDATE()
        print'total time of loadin silver.erp_CUST_AZ12 table is '+ cast(datediff(MILLISECOND,@start_time,@end_time)as nvarchar)+ ' ms'
        
        -- insertin data into second table in erp 
        set @start_time = getdate();
        
        print 'truncating table : silver.erp_LOG_A101'
        truncate table silver.erp_LOG_A101
        print 'inserting data into : silver.erp_LOG_A101'
        insert into silver.erp_LOG_A101(CID,CNTRY)

        select 
        replace(cid,'-','') cid
        ,case 
             when trim(cntry)='DE' then 'Germany'
             when trim(cntry) in ('US','USA') then 'United States'
             else Trim(cntry)
         end as cntry
        from bronze.erp_LOG_A101
         set @end_time=GETDATE()
        print'total time of loadin silver.erp_LOG_A101 table is '+ cast(datediff(MILLISECOND,@start_time,@end_time)as nvarchar)+ ' ms'
        
        -- insertin threed table in erp 
        set @start_time = getdate();
        print 'truncating table : silver.erp_PX_CAT_G1V2'
        truncate table silver.erp_PX_CAT_G1V2
        print 'inserting data into : silver.erp_PX_CAT_G1V2'
        insert into silver.erp_PX_CAT_G1V2(
               id
              ,cat
              ,subcat
              ,maintenance
        )
        select 
              id
              ,cat
              ,subcat
              ,maintenance
        from bronze.erp_PX_CAT_G1V2
         set @end_time=GETDATE()
        print'total time of loadin silver.erp_PX_CAT_G1V2 table is '+ cast(datediff(MILLISECOND,@start_time,@end_time)as nvarchar)+ ' ms'
        set @end_total_time =getdate()

        print'=================================================================='
        print'total time taken to insertin the data in silver layer '+cast(datediff(MILLISECOND,@start_total_time,@end_total_time)as nvarchar) 
      end try 
      begin catch
       print '========================='
         print 'error occured during loading bronze layer'
         print 'error message'+error_message()
         print 'error message'+ cast (error_number() as nvarchar)
         print 'error message'+ cast (error_state() as nvarchar)
         print'========================='
      end   catch
end
