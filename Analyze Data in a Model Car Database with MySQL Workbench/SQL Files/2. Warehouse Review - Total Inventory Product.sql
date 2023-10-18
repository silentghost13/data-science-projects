# 2. Are all the warehouses currently in use still necessary? How can we review warehouses that have low or inactive inventory?
SELECT
    p.productName,
    w.warehouseName,
    SUM(p.quantityInStock) AS totalInventory
FROM
    mintclassics.products AS p
JOIN
    mintclassics.warehouses AS w ON p.warehouseCode = w.warehouseCode
GROUP BY
    p.productName, w.warehouseName
ORDER BY
    totalInventory asc