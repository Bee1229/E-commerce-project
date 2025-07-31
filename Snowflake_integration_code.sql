CREATE DATABASE E_COMMERCE;
CREATE SCHEMA E_COMMERCE1;

CREATE OR REPLACE STORAGE INTEGRATION aws_s3_integration_e_commerce
type = external_stage
storage_provider = 'S3'
enabled = true
storage_aws_role_arn='arn:aws:iam::400144346141:role/E_commerce_role'
storage_allowed_locations =('s3://e-commerce101/');

SHOW INTEGRATIONS;
drop integration aws_s3_integration;
DESC INTEGRATION aws_s3_integration_e_commerce;

GRANT USAGE ON INTEGRATION aws_s3_integration_e_commerce TO ROLE ACCOUNTADMIN;

CREATE OR REPLACE FILE FORMAT e_commerce_format
type='CSV'
field_delimiter=','
skip_header=1;

CREATE OR REPLACE STAGE e_commerce_stage
storage_integration = aws_s3_integration_e_commerce
file_format='e_commerce_format'
url = 's3://e-commerce101/';

CREATE OR REPLACE TABLE e_commerce_customer(
customer_id String,
name String,
email string
);

COPY INTO e_commerce_customer
FROM @e_commerce_stage/customers.csv
FILE_FORMAT =(format_name = e_commerce_format)
ON_ERROR = 'continue';

select * from e_commerce_customer;

CREATE OR REPLACE TABLE e_commerce_orders(
order_id String,
customer_id string,
order_date timestamp
);

COPY INTO e_commerce_orders
FROM @e_commerce_stage/orders.csv
FILE_FORMAT =(FORMAT_NAME= e_commerce_format)
ON_ERROR = 'continue';

select * from e_commerce_orders;

CREATE OR REPLACE TABLE e_commerce_shipments(
shipment_id string,
order_id string,
status string,
shipped_at timestamp,
delivered_at timestamp
);

COPY INTO e_commerce_shipments
FROM @e_commerce_stage/shipments.csv
FILE_FORMAT =(FORMAT_NAME = e_commerce_format)
ON_ERROR = 'continue';

Select * from e_commerce_shipments;
