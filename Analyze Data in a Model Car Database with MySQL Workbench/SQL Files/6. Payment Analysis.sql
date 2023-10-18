# 6. How can customer payment trends be analyzed? What credit risks need to be considered, and how can cash flow be managed?
SELECT
    c.customerNumber,
    c.customerName,
    p.paymentDate,
    p.amount AS paymentAmount
FROM
    mintclassics.customers AS c
LEFT JOIN
    mintclassics.payments AS p ON c.customerNumber = p.customerNumber
order by	
	paymentAmount desc