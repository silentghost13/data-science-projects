# 4. Who are the customers contributing the most to sales? How can sales efforts be focused on these valuable customers?
SELECT
    c.customerNumber,
    c.customerName,
    count(o.orderNumber) AS totalSales
FROM
    mintclassics.customers AS c
JOIN
    mintclassics.orders AS o ON c.customerNumber = o.customerNumber
GROUP BY
    c.customerNumber, c.customerName
order by
	totalSales desc