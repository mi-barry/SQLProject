-- Final Project
-- Update Part Script
-- M. Barry
-- IS380
-- Spring 2020

-- Set environment variables
SET FEEDBACK OFF
SET HEADING OFF
SET VERIFY OFF

PROMPT
PROMPT
PROMPT ********** Update Part Information **********
PROMPT 

-- Initialize varoables for part
DEFINE v_error = 'PART NUMBER NOT FOUND!!! Rerun the program!!!'

DEFINE v_part_desc = 'NA'
DEFINE v_part_qtyonhand = 'NA'

-- Prompt user for part number to update
ACCEPT v_part_num NUMBER FORMAT 999 PROMPT 'Enter Part Number to Update (format 999): '
PROMPT

-- Create updpartinfo.sql to define the following variables
-- PART_DESCRIPTION and PART_QTYONHAND

-- STOP DISPLAYING INFO ON SCREEN
SET TERMOUT OFF
SPOOL c:\db\updpartinfo.sql

SELECT	'DEFINE v_error = ''Part  Number Found. Below is the current information: ''' || CHR(13) || CHR(10) || 
	'DEFINE v_part_desc = ' || '''' || PART_DESCRIPTION || '''' || CHR(13) || CHR(10) ||
	'DEFINE v_part_qtyonhand = ' || '''' || PART_QTYONHAND || '''' 
FROM PART
WHERE PART_NUM = &v_part_num;

SPOOL OFF

-- Run spooled script and show output on screen
START c:\db\updpartinfo.sql
SET TERMOUT ON

-- Display data found to user
PROMPT &v_error
PROMPT Part Description	  : &v_part_desc
PROMPT Current Inventory Quantity: &v_part_qtyonhand
PROMPT

-- Verify what user wants to do and pause for decision
PROMPT ** Verify part information:				**
PROMPT ** If you do not wish to update OR Part NOT FOUND,      **
PROMPT **	Press [CRTL] [C] twice to ABORT 	        **
PROMPT ** If you wish to continue and update, press [ENTER]    **
PAUSE

-- Get new description
PROMPT Type New Description of press [ENTER] to accept current description
ACCEPT v_new_part_desc CHAR PROMPT '(Current Description: &v_part_desc): ' DEFAULT '&v_part_desc'
PROMPT

-- Get new quantity
PROMPT Type New Quantity or press [ENTER] to accept Current Inventory Quantity
ACCEPT v_new_part_qtyonhand NUMBER PROMPT '(Current Inventory Quantity: &v_part_qtyonhand): ' DEFAULT '&v_part_qtyonhand'
PROMPT

-- Update the part
UPDATE PART
SET PART_DESCRIPTION = '&v_new_part_desc',
    PART_QTYONHAND = '&v_new_part_qtyonhand'
WHERE PART_NUM = &v_part_num;

-- Display result to user
PROMPT Updated Part Number Information:
SELECT	'Part Number               : ' || PART_NUM, 
	'Part Description          : ' || PART_DESCRIPTION,
	'Current Inventory Quantity: ' || PART_QTYONHAND
FROM PART
WHERE PART_NUM = &v_part_num;

-- Save changes and reset environment
COMMIT;
SET FEEDBACK OFF
SET HEADING OFF
SET VERIFY OFF





