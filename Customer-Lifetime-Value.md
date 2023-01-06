# Customer-Lifetime-Value
Customer Lifetime Value (LTV) refers to the projected revenue that a business earns from one customer. It estimates the money a company will gain throughout a customer’s lifetime. In addition, it determines how much they should invest in retaining a single customer. 
Since LTV is a long-term concept, it is necessary to understand that not all customers are equally important. As You may heard about 80-20 principle, which says that our 80% profit comes from 20% of customers. We have to discover those 20% customers and our business will be in good hands. It based on their spending habbits, the duration between orders and the purchasing behaviours. Therefore, the company focuses on certain targeted customers more than others. The customer lifetime value prediction helps in getting the most profitable customers. In addition, it helps identify the potential audience that will increase its future cash flows.  
Customer lifetime value depends on the pre-existing data and future behavior of customer

How to Calculate Customer Lifetime Value?
there are many methods to calculate customer lifetime value and some of them are correct. In my analysis, I tried to get the best strategy to calculate LTV. To calculate it, we need some of the measures as given below":
### 1.Average Purchase Frequency

This is the average number of transactions a customer makes over a given time period.

Purchase frequency can be calculated by dividing the average number of purchases by the average number of customers.

For example, in the calculation of avg purchase frequency, first of all converted order_date column into required format. After that I used group_by on month and customers and count the total number of distinct orders placed by customer within certain month and makes it equals to n_transactions. In the end, simply taken the mean of n_transactions which gives me the average of it.

### 2.Average Purchase Value

It is the average value of the customers' transactions. It means how much customer spent in your business in specific duration of time.

Using my dataset, first I multiplied the Unit Price with Quantity to find the total amount of each transaction. Then, I used the group by and summarize function to find purchase values for each customer. And lastly, I found the mean of all customers' purchase values.

### 3.Calculation of Customer Lifespan

This metric provides the average period of time a customer remains your customer. It starts from when they first make a purchase up until their last transaction with your business.
To calculate the lifespan of customers, divide 1 by churn rate.

** The Churn rate ** is the rate at which customers stop doing business with an entity. It gives you insight into how many customers you may be losing in a given time period. Knowing how to calculate churn rate enables you to understand the financial health of a business and implement changes to help it grow.
** The Retention rate ** which states that it is a metric that measures the number of users still using your product or service after a given period of time.

-  I calculated the ** monthly active customers** . In this, I simply count the distinct customers with the group_by on month which gave me the monthly active customers.
-  I calculated the ** new customers per month ** . For this, first used **min_rank** window function which is used to rank the top values based on rank. I used it to find the new customers in every new month. Used the min_rank function on order_date function with the group_by on customers. Then I filtered the rank=1 to get the first orders of new customers with group_by on month. In the end, count the distinct customers.
-  Merged the above two dataframes based on the same column month
-  After that I calculate the retention rate. Then subtract retention rate from 1 to get the churn rate.

### 4.Customer Acquisition Cost(CAC)
We have already discussed it that it is the average amount you spend on acquiring a customer, and includes everything from marketing and advertising.

### General Formula to calculate CLV

Once we have the above information, calculating CLV is easy. Just multiply the values calculted above:


### CLV = (Average Purchase Value × Average Purchase Frequency × Average Customer Lifespan) – CAC 


If our CLV is negative then customers are costing you more to serve than customers are making you in revenue, so we can actively work to stop selling to those customers.
