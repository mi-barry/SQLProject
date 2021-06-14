-- Final Project
-- Receive Order Script
-- M. Barry
-- IS380
-- Spring 2020

-- Set environment variables
SET FEEDBACK OFF
SET HEADING OFF
SET VERIFY OFF

PROMPT
PROMPT
PROMPT ********** Receive Order Screen **********
PROMPT 
SELECT 'Date: ', TO_CHAR(SYSDATE, 'MM/DD/YYYY') FROM DUAL;
PROMPT

-- Initialize variables 
DEFINE v_error = 'ORDER NOT FOUND!!! Rerun the program!!!'

DEFINE v_part_num = 'NA'
DEFINE v_part_desc = 'NA'
DEFINE v_part_qtyonhand = 'NA'

DEFINE v_sup_code = 'NA'
DEFINE v_sup_name = 'NA'

DEFINE v_ord_date = 'NA'
DEFINE v_ord_recdate = 'NA'
DEFINE v_ord_ordqty = 'NA'

DEFINE v_new_qty = 'ERROR'
DEFINE add_qty = 'P.PART_QTYONHAND + O.ORD_QTY'
DEFINE keep_qty = 'P.PART_QTYONHAND'

-- Get order number
ACCEPT v_ord_num NUMBER FORMAT 9999 PROMPT 'Enter Order Number to Receive (format 9999): '

-- Stop displaying info on screen, create file, fetch info
SET TERMOUT OFF

SPOOL c:\db\recinfo.sql

SELECT	'DEFINE v_error = ''Order Found. Verify the following: ''' || CHR(10) || CHR(13) ||
	'DEFINE v_part_num = ' || '''' || P.PART_NUM || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_part_desc = ' || '''' || PART_DESCRIPTION || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_part_qtyonhand = ' || '''' || PART_QTYONHAND || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_sup_code = ' || '''' || S.SUPPLIER_CODE || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_sup_name = ' || '''' || SUPPLIER_NAME || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_ord_date = ' || '''' || ORD_DATE || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_ord_recdate = ' || '''' || ORD_RECDATE || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_ord_ordqty = ' || '''' || ORD_QTY || ''''
FROM ORD O JOIN PART P ON O.PART_NUM = P.PART_NUM JOIN SUPPLIER S ON S.SUPPLIER_CODE = O.SUPPLIER_CODE
WHERE ORD_NUM = &v_ord_num;

SPOOL OFF
START c:\db\recinfo.sql
SET TERMOUT ON

-- Display data to user
PROMPT
PROMPT &v_error
Prompt
PROMPT Part Number       : &v_part_num
PROMPT Part Description  : &v_part_desc
PROMPT Inventory Quantity: &v_part_qtyonhand
PROMPT
PROMPT Supplier Code     : &v_sup_code
PROMPT Supplier Name     : &v_sup_name
PROMPT
PROMPT Date Ordered      : &v_ord_date
PROMPT Date Received     : &v_ord_recdate
PROMPT Quantity Ordered  : &v_ord_ordqty
PROMPT

-- Verify what user wants to do and pause for decision
PROMPT ** Again, verify order information:				  **
PROMPT ** In case ofdiscrepancy (Order not found, Wrong quantity, etc.)  **
PROMPT **	Press [CRTL] [C] twice to ABORT 	        	  **
PROMPT ** If correct, press [ENTER] to continue    			  **
PAUSE

-- Get updated quantity
SET TERMOUT OFF
SPOOL c:\db\updateqty.sql

SELECT 'DEFINE v_new_qty = ' || '''' || CASE 
	WHEN O.ORD_RECDATE IS NULL 
	THEN &add_qty 
	ELSE &keep_qty END || ''''
FROM PART P JOIN ORD O ON O.PART_NUM = P.PART_NUM
WHERE O.ORD_NUM = &v_ord_num;

SPOOL OFF
SET TERMOUT ON
START c:\db\updateqty.sql

-- Update quantity
UPDATE PART
SET PART_QTYONHAND = &v_new_qty
WHERE PART_NUM = (SELECT PART_NUM 
	FROM ORD
	WHERE ORD_NUM = &v_ord_num);

-- Update received date if necesssary
UPDATE ORD 
SET ORD_RECDATE = TRUNC(SYSDATE), ORD_RECQTY = &v_ord_ordqty
WHERE ORD_NUM = &v_ord_num AND ORD_RECDATE IS NULL AND ORD_RECQTY IS NULL;

-- Recieve complete, display info to user
SELECT 'New Quantity in Stock: ' || PART_QTYONHAND
FROM PART P, ORD O
WHERE O.ORD_NUM = &v_ord_num AND P.PART_NUM = O.PART_NUM;

-- Save changes and reset environment
COMMIT;
SET FEEDBACK ON
SET HEADING ON
SET VERIFY ON




