-- Final Project
-- Create New Order Script
-- M. Barry
-- IS380
-- Spring 2020

-- This program creates a new order for a customer
-- It prompts the user for part number, supplier code, and quantity to order
-- If no errors and order is placed.

-- SEQUENCE
-- CREATE SEQUENCE ORDERNUMBER
-- START WITH 1010;

-- Set environment variables
SET FEEDBACK OFF
SET HEADING OFF
SET VERIFY OFF

PROMPT
PROMPT
PROMPT ********** Create New Order **********
PROMPT 
SELECT 'Date: ', TO_CHAR(SYSDATE, 'MM/DD/YYYY') FROM DUAL;
PROMPT

-- CUSTOMER DATA ENTRY FOR PART

-- Initialize variables for part
DEFINE v_part_desc = 'Part does not exist.'
DEFINE v_part_qtyonhand = 'NA'

-- Promopt user for part number
ACCEPT v_part_num NUMBER FORMAT 999 PROMPT 'Enter Part Number (format 999): '

-- Create part info.sql file to define the following variables:
-- PART_DESCRIPTION and PART_QTYONHAND.

--Stop displaying info on screen
SET TERMOUT OFF
SPOOL c:\db\partinfo.sql

SELECT	'DEFINE v_part_desc = ' || '''' || PART_DESCRIPTION || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_part_qtyonhand = ' || '''' || PART_QTYONHAND || '''' 
FROM PART
WHERE PART_NUM = &v_part_num;

SPOOL OFF

-- Run spooled script and show output on screen
START c:\db\partinfo.sql
SET TERMOUT ON

-- Display found data to the user
PROMPT Part Description: &v_part_desc
PROMPT Quantity in stock: &v_part_qtyonhand
PROMPT

-- CUSTOMER DATA ENTRY FOR SUPPLIER

-- Initialize variables for supplier
DEFINE v_sup_address = 'Supplier Not Found'
DEFINE v_sup_city = 'NA'
DEFINE v_sup_state = 'NA'
DEFINE v_sup_zip = 'NA'
DEFINE v_sup_phone = 'NA'
DEFINE v_sup_areacode = 'NA'

-- Prompt user for supplier code
ACCEPT v_sup_code NUMBER FORMAT 999 PROMPT 'Enter Supplier Code (format 999): '

-- Create supplierinfo.sql file to define following variables:
-- SUPPLIER_ADDRESS, SUPPLIER_CITY, SUPPLIER_CITY, SUPPLIER_STATE, 
-- SUPPLIER_ZIP, AND SUPPLIER_PHONE, SUPPLIER_AREACODE

-- Stop displaying info on screen
SET TERMOUT OFF
SPOOL c:\db\supplierinfo.sql

SELECT	'DEFINE v_sup_address = ' || '''' || SUPPLIER_ADDRESS || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_sup_city = ' || '''' || SUPPLIER_CITY || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_sup_state = ' || '''' || SUPPLIER_STATE || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_sup_zip = ' || '''' || SUPPLIER_ZIP || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_sup_phone = ' || '''' || SUPPLIER_PHONE || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_sup_areacode = ' || '''' || SUPPLIER_AREACODE || '''' 
FROM SUPPLIER
WHERE SUPPLIER_CODE = &v_sup_code;

SPOOL OFF

-- Run spooled script and show output on screen
START c:\db\supplierinfo.sql
SET TERMOUT ON

-- Display found data
PROMPT Address: &v_sup_address
PROMPT City, State, Zip: &v_sup_city, &v_sup_state &v_sup_zip
PROMPT Phone: (&v_sup_areacode) &v_sup_phone
PROMPT

-- Get quantity for order from user
ACCEPT v_ord_qty NUMBER FORMAT 999 PROMPT 'Enter Quantity to Order: '

-- Create order 
INSERT INTO ORD (ORD_NUM, PART_NUM, SUPPLIER_CODE, ORD_QTY, ORD_DATE)
VALUES (ORDERNUMBER.NEXTVAL, &v_part_num, &v_sup_code, &v_ord_qty, TRUNC(SYSDATE));

-- FEEDBACK

SET TERMOUT OFF
SET ECHO OFF

SPOOL c:\db\ordnum.sql
SELECT 'DEFINE v_ord_num =' || ORDERNUMBER.CURRVAL
FROM DUAL;
SPOOL OFF

START c:\db\ordnum.sql
SET TERMOUT ON

-- NEW ORDER SUCCESFULLY CREATED. INFORM CUSTOMER

SELECT 'Your order has been placed. Order number is: ' || ORD_NUM
FROM ORD
WHERE ORD_NUM = &v_ord_num;

-- RESET ENVIRONMENT 

SET FEEDBACK ON
SET HEADING ON
SET VERIFY ON

