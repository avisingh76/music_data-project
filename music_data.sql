-- Music Store Database Analysis Queries

-- Basic data exploration
SELECT * FROM employee;

-- 1. Senior most employee (By level)
SELECT first_name, last_name, levels
FROM employee
ORDER BY levels DESC;

-- 2. Senior most employee (By age)
SELECT first_name, last_name, EXTRACT(YEAR FROM birthdate) AS year_b
FROM employee
ORDER BY year_b;

-- Invoice analysis
SELECT * FROM invoice;

-- 3. Countries with most invoices
SELECT billing_country, COUNT(billing_country) AS no_of_bills
FROM invoice
GROUP BY billing_country
ORDER BY no_of_bills DESC;

-- 4. Top 3 values of total invoice
SELECT total 
FROM invoice
ORDER BY total DESC
LIMIT 3;

-- 5. City and sum total 
SELECT billing_city,
       ROUND(SUM(total)::numeric, 2) AS total_bills_city
FROM invoice
GROUP BY billing_city
ORDER BY total_bills_city DESC;

-- 6. Best customer (customer who spent the most)
SELECT c.customer_id, 
       c.first_name, 
       c.last_name, 
       ROUND(SUM(i.total)::numeric, 2) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;

-- 7. All Rock music listeners (customers who bought Rock tracks)
SELECT DISTINCT first_name, last_name, email
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN 
    (SELECT track_id 
     FROM track
     JOIN genre ON track.genre_id = genre.genre_id
     WHERE genre.name LIKE 'Rock')
ORDER BY email;

--Alternative
SELECT DISTINCT c.first_name, c.last_name, c.email
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.first_name;


-- 8. Artists with most Rock tracks
SELECT a.name AS artist_name, COUNT(*) AS rock_songs
FROM artist a
JOIN album al ON a.artist_id = al.artist_id
JOIN track t ON al.album_id = t.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY a.artist_id, a.name
ORDER BY rock_songs DESC
LIMIT 10;

-- 9. Tracks longer than average length
SELECT name, milliseconds 
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds) AS avg_len 
    FROM track
)
ORDER BY milliseconds DESC;

--10.Most popular genre by country
WITH pop_gen AS
		(SELECT c.country, g.name AS genre, COUNT(*) AS purchases,
		ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(*) DESC) AS row_no
		FROM customer c
		JOIN invoice i ON c.customer_id = i.customer_id
		JOIN invoice_line il ON i.invoice_id = il.invoice_id
		JOIN track t ON il.track_id = t.track_id
		JOIN genre g ON t.genre_id = g.genre_id
		GROUP BY c.country, g.name
		ORDER BY c.country, purchases DESC)
SELECT * 
FROM pop_gen 
WHERE row_no = 1 ;

--11. Top customer by country (highest spending customer in each country)
WITH c_c AS 
		(SELECT c.customer_id, c.first_name, c.last_name,i.billing_country, ROUND(SUM(total)::numeric, 2) AS total_spending,
	     ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS row_no
		 FROM invoice i
		 JOIN customer c ON c.customer_id = i.customer_id
		 GROUP BY 1,2,3,4
		 ORDER BY 4, 5 DESC)
SELECT * 
FROM c_c
WHERE row_no = 1;

--12.Monthly Sales Trend
SELECT EXTRACT(MONTH FROM invoice_date) AS month_s,
       EXTRACT(YEAR FROM invoice_date) AS year_s,
       COUNT(*) AS total_invoices,
       ROUND(SUM(total)::numeric,2) AS monthly_revenue
FROM invoice
GROUP BY 1, 2
ORDER BY 2, 1;