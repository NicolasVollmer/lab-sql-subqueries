#### Lab | SQL Subqueries 3.03

# NOTE: In class I felt I understood, but tonight I drew a blank on most excercises...Sorry! Will revise tomorrow and hopefully 
# it'll click then.

# 1. How many copies of the film Hunchback Impossible exist in the inventory system?
-- I feel like you wanted a subquery for this, but a join just seemed much simpler
SELECT f.title, COUNT(i.inventory_id) AS 'copies in inventory' FROM sakila.film f
JOIN sakila.inventory i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

# 2. List all films whose length is longer than the average of all the films.
SELECT * FROM sakila.film;

SELECT title, length FROM sakila.film 
WHERE length > (SELECT AVG(length) FROM sakila.film)
ORDER BY length DESC;

# 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM sakila.film
WHERE title = 'alone trip';

select first_name, last_name 
from sakila.actor 
where actor_id = (SELECT actor_id 
	FROM sakila.film_actor
	WHERE film_id = (SELECT film_id 
		FROM sakila.film
		WHERE title = 'alone trip'
        ));
-- been trying several ways but cannot seem to figure this out...

# 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

-- technically, there have been 0 sales since 2006 - not sure how they could come back from that, ever! Especially with Netflix & Co.
select f.title from sakila.film f
JOIN sakila.film_category fc ON f.film_id = fc.film_id
JOIN sakila.category c ON fc.category_id = c.category_id
WHERE c.name = 'family';

# 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

# 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

# 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

# 8. Customers who spent more than the average payments.
SELECT c.last_name, c.first_name
FROM sakila.payment p
INNER JOIN sakila.customer c
ON p.customer_id = c.customer_id
WHERE p.amount > (avg(p.amount) AS 'average')avg1
GROUP BY p.customer_id
ORDER BY c.last_name ASC;

