# 8. How can the company’s credit policies be evaluated? Are there any customers with credit issues that need to be addressed?
SELECT
    c.customerNumber,
    c.customerName,
    c.creditLimit,
    SUM(p.amount) AS totalPayments,
    (SUM(p.amount) - c.creditLimit) AS creditLimitDifference
FROM
    mintclassics.customers AS c
LEFT JOIN
    mintclassics.payments AS p ON c.customerNumber = p.customerNumber
GROUP BY
    c.customerNumber, c.creditLimit
HAVING
    SUM(p.amount) < c.creditLimit
ORDER BY
	totalPayments asc