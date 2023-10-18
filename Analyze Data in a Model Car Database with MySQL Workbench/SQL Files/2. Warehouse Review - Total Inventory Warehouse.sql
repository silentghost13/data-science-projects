# 2. Are all the warehouses currently in use still necessary? How can we review warehouses that have low or inactive inventory?
SELECT 
    w.warehouseCode, 
    w.warehouseName, 
    SUM(p.quantityInStock) AS totalInventory
FROM 
    mintclassics.warehouses AS w
LEFT JOIN 
    mintclassics.products AS p ON w.warehouseCode = p.warehouseCode
GROUP BY 
    w.warehouseCode, 
    w.warehouseName
order by 
	totalInventory desc