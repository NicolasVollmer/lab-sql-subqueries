#### Lab | SQL Subqueries 3.03

use sakila;

# 1. How many copies of the film Hunchback Impossible exist in the inventory system?
-- I feel like you wanted a subquery for this, but a join just seemed much simpler
SELECT f.title, COUNT(i.inventory_id) AS 'copies in inventory' FROM sakila.film f
JOIN sakila.inventory i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

SELECT Amount_of_copies
FROM (SELECT film_id, COUNT(inventory_id) AS Amount_of_copies
	FROM inventory
    GROUP BY film_id
    HAVING film_id = (SELECT film_id
						FROM film
						WHERE title='Hunchback Impossible')) SUB2;

# 2. List all films whose length is longer than the average of all the films.
SELECT * FROM sakila.film;

SELECT title, length FROM sakila.film 
WHERE length > (SELECT AVG(length) FROM sakila.film)
ORDER BY length DESC;

# 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM sakila.film
WHERE title = 'alone trip';

SELECT first_name, last_name 
FROM sakila.actor 
WHERE actor_id IN (SELECT actor_id 
	FROM sakila.film_actor
	WHERE film_id = (SELECT film_id 
		FROM sakila.film
		WHERE title = 'alone trip'
        ));

# 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

-- technically, there have been 0 sales since 2006 - not sure how they could come back from that, ever! Especially with Netflix & Co.
SELECT f.title FROM sakila.film f
JOIN sakila.film_category fc ON f.film_id = fc.film_id
JOIN sakila.category c ON fc.category_id = c.category_id
WHERE c.name = 'family';

SELECT title FROM film
WHERE film_id IN(SELECT film_id
	FROM film_category
    WHERE category_id = (SELECT category_id
		FROM category
        WHERE name = 'Family'));

# 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

#using subqueries
SELECT first_name, last_name, email FROM sakila.customer
WHERE address_id IN (
	SELECT address_id FROM sakila.address 
    WHERE city_id IN (
		SELECT city_id FROM sakila.city
        WHERE country_id = (
			SELECT country_id FROM sakila.country
            WHERE country = 'Canada')));

#using join
SELECT c.first_name, c.last_name, c.email 
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON ct.city_id = a.city_id
JOIN country co ON co.country_id = ct.country_id
WHERE co.country = 'Canada';

# 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa USING (actor_id)
GROUP BY a.actor_id, a.first_name, a.last_name
LIMIT 1;

SELECT film_id, title
FROM film_actor 
LEFT JOIN film  USING (film_id)
WHERE actor_id = (
	SELECT actor_id FROM (
		SELECT actor_id, COUNT(film_id) FROM film_actor
        GROUP BY actor_id
        ORDER BY COUNT(film_id) DESC
        LIMIT 1) sub1);

# 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT customer_id
FROM (
	SELECT customer_id, SUM(amount)
		FROM payment
        GROUP BY customer_id
        ORDER BY SUM(amount) DESC
        LIMIT 1) sub1;

# 8. Customers who spent more than the average payments.
SELECT c.last_name, c.first_name
FROM sakila.payment p
INNER JOIN sakila.customer c
ON p.customer_id = c.customer_id
WHERE p.amount > (avg(p.amount) AS 'average')avg1
GROUP BY p.customer_id
ORDER BY c.last_name ASC;

SELECT customer_id, SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (SELECT AVG(sum) AS average
	FROM(SELECT customer_id, SUM(amount) AS sum
		FROM payment
		GROUP BY customer_id) sub1);