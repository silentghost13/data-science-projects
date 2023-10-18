# Analyze Data in a Model Car Database with MySQL Workbench

## Project overview:
This project invites you to assume the role of an entry-level data analyst at the fictional Mint Classics Company.  
The project is to analyze data in a relational database to support inventory-related business decisions, specifically the closure of a storage facility.

## Demonstrated skills:
1. Business understanding: To provide relevant solutions, I will thoroughly analyze the Mint Classics relational database and business processes.
2. Data analysis: I will use SQL to extract and analyze relevant data from the Mint Classics relational database to support inventory-related business decisions.
3. Decision-making: I will formulate data-driven recommendations to support inventory-related business decisions.

## Tools used:
1. MySQL Workbench: This tool is used to import databases, run SQL queries, and analyze data.
2. GitHub: The project and reports will be uploaded to GitHub to showcase my portfolio.

## Task 1 - Import the Classic Model Car Relational Database
I will import the Mint Classics relational database using MySQL Workbench. This task involves downloading an SQL file containing the script to create and populate the database, and then importing this script into MySQL Workbench. After the import is complete, I will verify that the database has been successfully imported.  
Schema:
![alt text](https://github.com/silentghost13/portfolio-projects/blob/main/Analyze%20Data%20in%20a%20Model%20Car%20Database%20with%20MySQL%20Workbench/Images/0.%20Database%20Schema.png "Database Schema")

## Task 2 - Familiarization with the Mint Classics Database and Business Processes
I will thoroughly analyze the Mint Classics database structure and data organization within each table.  
I will use an Entity-Relationship Diagram (ERD) to understand the relationships between tables, and I will explore the table contents to gain a deeper understanding of the business data.  
ERD Diagram:
![alt text](https://github.com/silentghost13/portfolio-projects/blob/main/Analyze%20Data%20in%20a%20Model%20Car%20Database%20with%20MySQL%20Workbench/Images/0.%20EER%20Diagram.png "ERD Diagram")

## Task 3 - Analyze the business problem and identify the affected tables.
I will investigate the business issue of closing one of Mint Classics' storage facilities.  
I will identify the relevant tables in the database and utilize SQL queries to retrieve the necessary data.

**Areas of analysis in this project:**
1. Identify products with high inventory but low sales and develop strategies to optimize inventory levels for these products.
![alt text](https://github.com/silentghost13/portfolio-projects/blob/main/Analyze%20Data%20in%20a%20Model%20Car%20Database%20with%20MySQL%20Workbench/Images/1.%20Inventory%20Optimization.png "Inventory Optimization")  
This query retrieves data from the “mintclassics.products” table and order details from the “mintclassics.orderdetails” table. It then groups the data by product code, product name, and the quantity of the product available in stock. Next, the query calculates the total quantity of the product ordered by combining data from both tables.

Subsequently, the query calculates the difference between the quantity of the product available in stock and the total quantity ordered, labeling this result as “inventoryShortage.” Finally, the query selects only those products that have a shortage in stock (inventory shortage) with the condition that the difference must be greater than 0, and it sorts the results from largest to smallest based on the inventory shortage.

In other words, this query is used to find products with quantities less than what was ordered (inventory shortage) and sort them by the extent of their shortages.  
![alt text](https://github.com/silentghost13/portfolio-projects/blob/main/Analyze%20Data%20in%20a%20Model%20Car%20Database%20with%20MySQL%20Workbench/Images/1.%20Result%20limited%20to%2010%20rows.png "Result 1")

2. Assess the need for all currently used warehouses and review warehouses with low or inactive inventory for potential closure.
![alt text](https://github.com/silentghost13/portfolio-projects/blob/main/Analyze%20Data%20in%20a%20Model%20Car%20Database%20with%20MySQL%20Workbench/Images/2.%20Warehouse%20Review%20-%20Total%20Inventory%20Product.png "Warehouse Review - Total Inventory Product")  
This query is used to retrieve the total inventory (totalInventory) of each product in each warehouse. The query performs a join between the “mintclassics.products” (products) table and the “mintclassics.warehouses” (warehouses) table based on the warehouse code (warehouseCode).

After the join, the data is grouped (GROUP BY) by product name (productName) and warehouse name (warehouseName). Then, the query calculates the total quantity of products available in stock (quantityInStock) for each combination of product and warehouse. The results of this calculation are stored in the “totalInventory” column.

The query’s results are then sorted (ORDER BY) in ascending order (from smallest to largest) based on totalInventory, resulting in a list of product-warehouse combinations with the lowest total inventory at the top.

In other words, this query helps you see the total inventory of each product in each warehouse and sorts it from the smallest to the largest.  
![alt text](https://github.com/silentghost13/portfolio-projects/blob/main/Analyze%20Data%20in%20a%20Model%20Car%20Database%20with%20MySQL%20Workbench/Images/2.%20Result%20limited%20to%2010%20rows%20(Product).png "Result 2 Product")  
![alt text](https://github.com/silentghost13/portfolio-projects/blob/main/Analyze%20Data%20in%20a%20Model%20Car%20Database%20with%20MySQL%20Workbench/Images/2.%20Warehouse%20Review%20-%20Total%20Inventory%20Warehouse.png "Warehouse Review - Total Inventory Warehouse")  
This query is intended to retrieve the total inventory data (totalInventory) for each warehouse in the “mintclassics.warehouses” table. The query performs a left join between the “mintclassics.warehouses” (warehouses) table and the “mintclassics.products” (products) table based on the warehouse code (warehouseCode).

After the join, the data is grouped (GROUP BY) by warehouse code (warehouseCode) and warehouse name (warehouseName). Then, the query calculates the total quantity of products available in stock (quantityInStock) for each warehouse. The results of this calculation are stored in the “totalInventory” column.

The query results are then sorted (ORDER BY) in descending order (from largest to smallest) based on totalInventory, resulting in a list of warehouses with the highest total inventory at the top.

In other words, this query helps you view the total inventory for each warehouse and sorts it from highest to lowest.
![alt text](https://github.com/silentghost13/portfolio-projects/blob/main/Analyze%20Data%20in%20a%20Model%20Car%20Database%20with%20MySQL%20Workbench/Images/2.%20Result%20limited%20to%2010%20rows%20(Warehouse).png "Result 2 Warehouse")

4. Analyze the relationship between product prices and sales levels, and develop recommendations for price adjustments to impact sales.
5. Identify the customers who contribute the most to sales and develop strategies to focus sales efforts on these valuable customers.
6. Develop metrics to evaluate sales employee performance using sales data.
7. Analyze customer payment trends to identify credit risks and develop cash flow management strategies.
8. Compare the performance of various product lines to identify the most successful products and those that need improvement or removal.
9. Evaluate the company's credit policies and identify customers with credit issues that need to be addressed.

## Task 4 - Developing Actionable Solutions to Business Challenges
**Summary of Recommendations to Address Inventory-Related Business Issues**  
Based on the data analysis conducted using SQL queries, the following recommendations are made to address the inventory-related business problems identified:

1. **Inventory Optimization**  
Reduce the inventory of products with high inventory but low sales.  
This can be achieved by either reducing the quantity ordered for these products or evaluating the actual demand for them.
Reducing inventory will help in lowering storage costs and optimizing resource allocation.

2. **Warehouse Review**  
Conduct further reviews of warehouses with a low or inactive inventory.
Consider closing or consolidating inefficient or inactive warehouses.  
This will reduce warehouse rental costs and optimize inventory allocation.

3. **Product Pricing Evaluation**  
Carefully review product prices.  
Consider adjusting the prices of specific products with low sales.  
Price reductions can enhance the attractiveness of these products to customers and boost sales.

4. **Customer Analysis**  
Focus sales efforts on valuable customers who contribute significantly to sales.  
Provide special incentives to these customers and consider offering products that align with their preferences.

5. **Employee Performance Evaluation**  
Evaluate sales employee performance using sales data.  
Reward employees who have achieved or exceeded sales targets with incentives.  
Identify employees who may need improvement and provide necessary training or support.

6. **Payment Analysis**  
Monitor payments regularly to identify customers with poor payment trends.  
Take follow-up actions to mitigate credit risks.  
Manage cash flow carefully to ensure optimal liquidity.

7. **Product Line Review**  
Review the performance of various product lines. Further evaluate products with less success.  
Consider product improvements or, if necessary, discontinuation of inefficient products. This will help in enhancing the profitability of the product portfolio.

8. **Credit Policy Evaluation**  
Conduct a thorough evaluation of the company's credit policies.  
Identify customers with credit issues and consider providing solutions or making changes in credit policies to reduce credit risk.

By implementing these recommendations and utilizing data analysis, the company can optimize its operations, improve profitability, and provide better customer service.

## Task 5 - Crafting Conclusions and Recommendations with SQL Support
The final task is to compile conclusions and recommendations based on the data analysis conducted using SQL queries. This will involve summarizing the key findings and providing actionable insights to address the business problems identified. I will explain the steps taken and the rationale behind my decisions, and I will include the SQL queries that support my findings.

By completing all of these tasks, I have gained valuable experience in data analysis and the use of SQL to solve business problems. 

**Disclaimer:** This project is for educational purposes only. I learned about this project from [Munzir Arsyuddin](https://github.com/pondokmunzir/Analyze-Data-in-a-Model-Car-Database-with-MySQL-Workbench).





