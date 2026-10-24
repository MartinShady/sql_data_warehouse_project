
create or alter procedure bronze.load_bronze as 
begin 
  declare @start_time datetime , @end_time  datetime;
  begin try 
        -- crm table inserting 
        print('==========================')
        print('loading bronze layer')
        print('==========================')
    
        print('-----------------------------')
        print('load crm tables')
        print('-----------------------------');

        
        -------------------------------------------------
        -- the first duration to  inserting data in table
        -------------------------------------------------
        set @start_time = getdate();

        if object_id('bronze.crm_cust_info','U') is not null
             truncate table bronze.crm_cust_info
        bulk insert bronze.crm_cust_info
        from'C:\Users\DELL\Desktop\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        with(
            firstrow=2,
            fieldterminator=',',
            tablock

        )
        set @end_time=GETDATE()
        print'total time of loadin crm_cust_info table is '+ cast(datediff(MILLISECOND,@start_time,@end_time)as nvarchar)+ ' ms'
        
        -------------------------------------------------
        -- the second duration to  inserting data in table
        -------------------------------------------------
         set @start_time = getdate();
        if object_id('bronze.crm_prd_info','U') is not null
             truncate table bronze.crm_prd_info
        bulk insert bronze.crm_prd_info
        from'C:\Users\DELL\Desktop\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        with(
            firstrow=2,
            fieldterminator=',',
            tablock

        )
        set @end_time=GETDATE()
        print'total time of loadin crm_prd_info table is '+ cast(datediff(MILLISECOND,@start_time,@end_time)as nvarchar)+ ' ms'

        
        -------------------------------------------------
        -- the threed duration to  inserting data in table
        -------------------------------------------------

        set @start_time = getdate();
        if object_id('bronze.crm_sales_details','U') is not null
             truncate table [bronze].[crm_sales_details]
        bulk insert [bronze].[crm_sales_details]
        from'C:\Users\DELL\Desktop\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        with(
            firstrow=2,
            fieldterminator=',',
            tablock

        )
        set @end_time=GETDATE()
        print'total time of loadin crm_sales_details table is '+ cast(datediff(MILLISECOND,@start_time,@end_time)as nvarchar)+ ' ms'

        -- erp table inserting
        -------------------------------------------------
        -- the first duration to  inserting data in table
        -------------------------------------------------
        print('-----------------------------')
        print('load erp tables')
        print('-----------------------------')
        set @start_time = getdate();
        if object_id('bronze.erp_CUST_AZ12','U') is not null
             truncate table [bronze].[erp_CUST_AZ12]
        bulk insert [bronze].[erp_CUST_AZ12]
        from'C:\Users\DELL\Desktop\SQL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        with(
            firstrow=2,
            fieldterminator=',',
            tablock
        )
        set @end_time=GETDATE()
        print'total time of loadin erp_CIST_AZ12 table is '+ cast(datediff(MILLISECOND,@start_time,@end_time)as nvarchar)+ ' ms'


      
        -------------------------------------------------
        -- the second duration to  inserting data in table
        -------------------------------------------------
         set @start_time = getdate();
        if object_id('bronze.erp_LOG_A101','U') is not null
             truncate table bronze.erp_LOG_A101
        bulk insert bronze.erp_LOG_A101
        from'C:\Users\DELL\Desktop\SQL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        with(
            firstrow=2,
            fieldterminator=',',
            tablock
        )
        set @end_time=GETDATE()
        print'total time of loadin erp_LOG_A101 table is '+ cast(datediff(MILLISECOND,@start_time,@end_time)as nvarchar)+ ' ms'

        
        -------------------------------------------------
        -- the threed duration to  inserting data in table
        -------------------------------------------------
         set @start_time = getdate();

        if object_id('bronze.erp_PX_CAT_G1V2','U') is not null
             truncate table bronze.erp_PX_CAT_G1V2
        bulk insert bronze.erp_PX_CAT_G1V2
        from'C:\Users\DELL\Desktop\SQL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        with(
            firstrow=2,
            fieldterminator=',',
            tablock
        )
        set @end_time=GETDATE()
        print'total time of loadin erp_PX_CAT_G1V2 table is '+ cast(datediff(MILLISECOND,@start_time,@end_time)as nvarchar)+ ' ms'


  end try 
     begin catch 
         print '========================='
         print 'error occured during loading bronze layer'
         print 'error message'+error_message()
         print 'error message'+ cast (error_number() as nvarchar)
         print 'error message'+ cast (error_state() as nvarchar)
         print'========================='
     end catch


end
