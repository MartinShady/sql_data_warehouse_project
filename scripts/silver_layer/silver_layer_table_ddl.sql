/*
================================================================
DDL Script : create Silver tables
================================================================
script purpose:
       this script create tables in the 'Silver' schema, dropping existing tables
        if they already exists.
        run this script to re-defin the ddl structure of 'Silver ' tables

*/
if object_id('silver.crm_cust_info','U') is not null 
   drop table silver.crm_cust_info

create table silver.crm_cust_info(
cst_id int ,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_marital_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date,
dwh_create_date datetime2 default getdate()
);

if object_id('silver.crm_prd_info','U') is not null 
    drop table silver.crm_prd_info

create table silver.crm_prd_info(
prd_id int ,
cat_id   nvarchar(50),
prd_key  nvarchar(50),
prd_name nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt DATE,
prd_end_dt   DATE,
dwh_create_date datetime2 default getdate()
)

if object_id('silver.crm_sales_details','U') is not null 
   drop table silver.crm_sales_details
create table silver.crm_sales_details(
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id int,
sls_order_dt date,
sls_ship_dt date ,
sls_due_dt date,
sls_sales int,
sls_quantity int,
sls_price int,
dwh_create_date datetime2 default getdate()
)
-- erp filles to tables
if object_id('silver.erp_CUST_AZ12','U') is not null 
drop table silver.erp_CUST_AZ12
create table silver.erp_CUST_AZ12 (
CID nvarchar(50),
BDATE date,
GEN nvarchar(50),
dwh_create_date datetime2 default getdate()
)
if object_id('silver.erp_LOG_A101','U') is not null 
    drop table silver.erp_LOG_A101

create table silver.erp_LOG_A101(
CID nvarchar(50),
CNTRY nvarchar(50),
dwh_create_date datetime2 default getdate()
)
if object_id('silver.erp_PX_CAT_G1V2','U') is not null 
   drop table silver.erp_PX_CAT_G1V2

create table silver.erp_PX_CAT_G1V2(
ID nvarchar(50),
CAT nvarchar(50),
SUBCAT nvarchar(50) ,
MAINTENANCE nvarchar(10),
dwh_create_date datetime2 default getdate()
)
