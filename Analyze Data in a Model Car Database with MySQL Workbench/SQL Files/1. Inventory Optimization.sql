# 1. Are there products with high inventory but low sales? How can we optimize the inventory of such products?
SELECT 
    productCode, 
    productName, 
    quantityInStock, 
    totalOrdered, 
    (quantityInStock - totalOrdered) AS inventoryShortage
FROM 
    (
        SELECT 
            p.productCode, 
            p.productName, 
            p.quantityInStock, 
            SUM(od.quantityOrdered) AS totalOrdered
        FROM 
            mintclassics.products AS p
        LEFT JOIN 
            mintclassics.orderdetails AS od ON p.productCode = od.productCode
        GROUP BY 
            p.productCode, 
            p.productName, 
            p.quantityInStock
    ) AS inventory_data
WHERE 
    (quantityInStock - totalOrdered) > 0
ORDER BY 
    inventoryShortage DESC;