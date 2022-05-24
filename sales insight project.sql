-- exploring customer table

select * from customers;

select count(distinct(custmer_name))
from customers;

select customer_type, count(customer_type)
from customers
group by customer_type;

-- exploring date table

select * from date;

select count(date)
from date;

select count(distinct(date))
FROM date;

select month_name, count(month_name)
from date
group by month_name;

select count(distinct(year))
from date;
-- exploring market table

select * from markets
order by zone;

-- New York and Paris don't have a zone because not in India, we can get rid of those rows

select zone, count(zone)
from markets
group by zone;

select * from markets
where markets_name = 'New York';

delete from markets
where markets_name = 'New York';

select * 
from markets 
where markets_code='Mark999';

delete from markets
where markets_code='Mark999';

-- exploring products table

select * from products;

select distinct(product_code)
from products;

select product_type, count(product_type)
from products
group by product_type;

-- exploring trasactions

select * from transactions;

select count(*)
from transactions;

select customer_code, sum(profit_margin)
from transactions
group by 1;
-- total profit margin per customer, cus018 is the only negative profit margin

select customer_code, avg(profit_margin_percentage)
from transactions
group by 1;

select distinct(market_code)
from transactions;

select year(order_date)
from transactions;

alter table transactions add order_date_year int;

update transactions
set order_date_year = year(order_date);
-- ^ parsing the year out

select count(*) from transactions
where order_date_year =2020;

select order_date_year, avg(profit_margin_percentage)
from transactions
group by 1;

select order_date_year, sum(profit_margin)
from transactions
group by 1;
-- from 2019 to 2020 total profit margin decreased by almost 8 million

select * from transactions;

select currency, count(currency)
from transactions
group by currency;
-- ^ there's 2 values that are in USD that needs to be converted to INR

select * from transactions
where currency = 'USD';

update transactions
set sales_amount = 19378
where sales_qty = 36 and profit_margin_percentage = 0.17 and profit_margin = 3187.5 and currency = 'USD';

update transactions
set sales_amount = 38756
where sales_qty = 59 and currency = 'USD';

update transactions
set currency = 'INR';


select customer_code,sales_amount, count(sales_amount)
from transactions
group by 1,2
order by 1;

select distinct(order_date), count(order_date)
from transactions
group by 1
order by 1;

select * 
from transactions 
where order_date = '2017-10-04';

select *
from transactions
where sales_amount= (select max(sales_amount) from transactions);

select * from transactions
order by sales_amount desc;

select distinct(currency)
from transactions;

-- joining all of the tables

select * from transactions;
select * from products;
select * from markets;
select * from date;
select * from customers;

select *
from transactions t
join products p on p.product_code=t.product_code
join markets m on m.markets_code=t.market_code
join date d on d.date = t.order_date
join customers c on c.customer_code=t.customer_code;

select t.customer_code,custmer_name,customer_type, t.market_code, markets_name, zone,t.product_code, product_type, sales_qty, cost_price, sales_amount, currency, 
profit_margin, profit_margin_percentage,order_date, month_name, order_date_year
from transactions t
join products p on p.product_code=t.product_code
join markets m on m.markets_code=t.market_code
join date d on d.date = t.order_date
join customers c on c.customer_code=t.customer_code;




