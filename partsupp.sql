-- Final Project
-- Parts Supplier Report
-- M. Barry
-- IS380
-- Spring 2020

SET LINESIZE 92;
SET PAGESIZE 120;

TTITLE CENTER "          -------- Parts Inventory Level and Supplier Reprot -------- Page:" SQL.PNO SKIP 3;

COLUMN PART_NUM HEADING "Part|No."
COLUMN PART_DESCRIPTION HEADING "Description"
COLUMN PART_QTYONHAND HEADING "Qty In|Stock"
COLUMN SUPPLIER_NAME HEADING "Supplier|Name"
COLUMN SUPPLIER_CODE HEADING "Supplier|Code"

BREAK ON PART_NUM ON PART_DESCRIPTION ON PART_QTYONHAND SKIP 1

SELECT P.PART_NUM, P.PART_DESCRIPTION, P.PART_QTYONHAND, S.SUPPLIER_CODE, S.SUPPLIER_NAME, '(' || SUPPLIER_AREACODE || ') ' || S.SUPPLIER_PHONE "Supplier Phone"
FROM PART P, SUPPLIER S, SUPPPART R
WHERE S.SUPPLIER_CODE = R.SUPPLIER_CODE AND R.PART_NUM = P.PART_NUM
ORDER BY P.PART_NUM, S.SUPPLIER_CODE;