/*# Unit 10 Assignment - SQL -- Alice Yu

### Create these queries to develop greater fluency in SQL, an important database language. */

-- * 1a. Display the first and last names of all actors from the table `actor`.
use sakila;
SELECT * FROM ACTOR;
SELECT FIRST_NAME, LAST_NAME FROM ACTOR;

-- * 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

SELECT CONCAT(UPPER(FIRST_NAME)," ", UPPER(LAST_NAME)) FROM ACTOR;

-- * 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT * FROM ACTOR;
SELECT ACTOR_ID, FIRST_NAME, LAST_NAME FROM ACTOR
WHERE UPPER(FIRST_NAME) = "JOE";

-- * 2b. Find all actors whose last name contain the letters `GEN`:
SELECT * FROM ACTOR WHERE UPPER(LAST_NAME) LIKE "%GEN%";

-- * 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT * FROM ACTOR WHERE UPPER(lAST_NAME) LIKE "%LI%" ORDER BY 3,2;

-- * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China: */

SELECT COUNTRY_ID, COUNTRY FROM COUNTRY WHERE UPPER(COUNTRY) IN ("AFGHANISTAN", "BANGLADESH", "CHINA");

-- * 3a. You want to keep a description of each actor. 
-- You don't think you will be performing queries on a description, 
-- so create a column in the table `actor` named `description` and use the data type `BLOB`
-- (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE ACTOR
ADD COLUMN DESCRIPTION BLOB;
SELECT * FROM ACTOR;

-- * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE ACTOR
DROP COLUMN DESCRIPTION;

-- * 4a. List the last names of actors, as well as how many actors have that last name.
SELECT LAST_NAME, COUNT(*) FROM ACTOR GROUP BY LAST_NAME;

-- * 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors.
SELECT LAST_NAME, COUNT(*) 
FROM ACTOR 
GROUP BY LAST_NAME
HAVING COUNT(*) >1;

-- * 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
SELECT * FROM ACTOR WHERE UPPER(FIRST_NAME) = "GROUCHO" AND UPPER(LAST_NAME) = "WILLIAMS";
UPDATE ACTOR SET FIRST_NAME = "HARPO" WHERE ACTOR_ID = "172";
COMMIT;

-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
-- It turns out that `GROUCHO` was the correct name after all! 
-- In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
SELECT * FROM ACTOR WHERE FIRST_NAME = "HARPO";
UPDATE ACTOR SET FIRST_NAME = "GROUCHO" WHERE FIRST_NAME = "HARPO";
COMMIT;

-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
DESCRIBE SAKILA.ADDRESS;
SELECT `table_schema` 
FROM `information_schema`.`tables` 
WHERE `table_name` = 'address';

-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
-- Use the tables `staff` and `address`:
SELECT S.FIRST_NAME, S.LAST_NAME, A.ADDRESS, A.ADDRESS2, A.DISTRICT, A.CITY_ID
FROM STAFF S
JOIN ADDRESS A
ON S.ADDRESS_ID = A.ADDRESS_ID;

-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT * FROM STAFF;
SELECT * FROM PAYMENT;
SELECT S.STAFF_ID, FIRST_NAME, LAST_NAME, SUM(P.AMOUNT)
FROM STAFF S
JOIN PAYMENT P
ON S.STAFF_ID = P.STAFF_ID
GROUP BY S.STAFF_ID, FIRST_NAME, LAST_NAME;

-- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT * FROM FILM_ACTOR;
SELECT * FROM FILM;
SELECT * FROM ACTOR;

SELECT TITLE, COUNT(A.ACTOR_ID) FROM FILM F
JOIN FILM_ACTOR FA
ON F.FILM_ID = FA.FILM_ID
JOIN ACTOR A
ON A.ACTOR_ID = FA.ACTOR_ID
GROUP BY TITLE;

-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT * FROM INVENTORY;
SELECT COUNT(*) FROM INVENTORY I
JOIN FILM F
ON I.FILM_ID = F.FILM_ID
WHERE UPPER(F.TITLE) = "HUNCHBACK IMPOSSIBLE"; -- 6

-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT * FROM PAYMENT;
SELECT * FROM CUSTOMER; 

SELECT FIRST_NAME, LAST_NAME, SUM(AMOUNT)  FROM PAYMENT P
JOIN CUSTOMER C
ON P.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY FIRST_NAME, LAST_NAME
ORDER BY LAST_NAME;

-- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
-- films starting with the letters `K` and `Q` have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT DISTINCT TITLE FROM FILM F
JOIN LANGUAGE L
ON F.LANGUAGE_ID = L.LANGUAGE_ID
WHERE UPPER(L.NAME) = "ENGLISH"
AND F.TITLE LIKE ("K%") OR F.TITLE LIKE ("Q%");

-- * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT DISTINCT FIRST_NAME, LAST_NAME FROM FILM F
JOIN FILM_ACTOR FA
ON F.FILM_ID = FA.FILM_ID
JOIN ACTOR A
ON FA.ACTOR_ID = A.ACTOR_ID
WHERE UPPER(F.TITLE) = "ALONE TRIP";

-- * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and 
-- email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT FIRST_NAME, LAST_NAME, C.EMAIL
FROM CUSTOMER C
JOIN ADDRESS A
ON C.ADDRESS_ID = A.ADDRESS_ID
JOIN CITY CC
ON CC.CITY_ID = A.CITY_ID
JOIN COUNTRY CCC
ON CCC.COUNTRY_ID = CC.COUNTRY_ID
WHERE UPPER(CCC.COUNTRY) = "CANADA";

-- * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as _family_ films.
SELECT DISTINCT NAME FROM CATEGORY;
SELECT * FROM FILM;
SELECT DISTINCT F.TITLE FROM FILM F
JOIN FILM_CATEGORY FC 
ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C
ON C.CATEGORY_ID = FC.CATEGORY_ID
WHERE UPPER(C.NAME) = "FAMILY";

-- * 7e. Display the most frequently rented movies in descending order.
SELECT F.TITLE, COUNT(TITLE) FREQ
FROM RENTAL R
JOIN INVENTORY I
ON R.INVENTORY_ID = I.INVENTORY_ID
JOIN FILM F
ON F.FILM_ID = I.FILM_ID
GROUP BY F.TITLE
ORDER BY FREQ DESC
LIMIT 5; -- BUCKET BROTHERHOOD / 34

SELECT * FROM RENTAL R;
SELECT * FROM INVENTORY;
SELECT * FROM FILM;

-- * 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT * FROM PAYMENT;
SELECT * FROM RENTAL;
SELECT * FROM STAFF;

SELECT S.STORE_ID, SUM(P.AMOUNT) FROM STAFF S
JOIN PAYMENT P
ON P.STAFF_ID = S.STAFF_ID
WHERE S.STORE_ID = "1"; -- 33,498.47

SELECT S.STORE_ID, SUM(P.AMOUNT) FROM STAFF S
JOIN PAYMENT P
ON P.STAFF_ID = S.STAFF_ID
WHERE S.STORE_ID = "2"; -- 33,927.04 

SELECT S.STORE_ID, SUM(P.AMOUNT) FROM STAFF S
JOIN PAYMENT P
ON P.STAFF_ID = S.STAFF_ID
GROUP BY S.STORE_ID; 

-- * 7g. Write a query to display for each store its store ID, city, and country.
SELECT * FROM STORE S;
SELECT * FROM CITY C;
SELECT * FROM COUNTRY CC;
SELECT * FROM ADDRESS;

SELECT S.STORE_ID, C.CITY, CC.COUNTRY FROM STORE S
JOIN ADDRESS A
ON S.ADDRESS_ID = A.ADDRESS_ID
JOIN CITY C
ON A.CITY_ID = C.CITY_ID
JOIN COUNTRY CC
ON CC.COUNTRY_ID = C.COUNTRY_ID;

-- * 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to 
-- use the following tables: category, film_category, inventory, payment, and rental.)
SELECT * FROM CATEGORY; -- HAS NAME, CATEGORY_ID
SELECT * FROM FILM_CATEGORY; -- HAS FILM_ID, CATEGORY_ID 
SELECT * FROM INVENTORY; -- HAS INVENTORY_ID, FILM_ID, STORE_ID
SELECT * FROM PAYMENT; -- HAS PAYMENT_ID, CUSTOMER_ID, STAFF_ID, RENTAL_ID, AMOUNT
SELECT * FROM RENTAL; -- HAS RENTAL_ID, INVENTORY_ID, CUSTOMER_ID

SELECT C.NAME, SUM(P.AMOUNT) FROM CATEGORY C
JOIN FILM_CATEGORY FC
ON C.CATEGORY_ID = FC.CATEGORY_ID
JOIN INVENTORY I
ON I.FILM_ID = FC.FILM_ID
JOIN RENTAL R
ON R.INVENTORY_ID = I.INVENTORY_ID
JOIN PAYMENT P
ON P.RENTAL_ID = R.RENTAL_ID
GROUP BY C.NAME
ORDER BY SUM(P.AMOUNT) DESC
LIMIT 5;

-- * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
-- Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW TOP_FIVE_BY_REV AS
SELECT C.NAME, SUM(P.AMOUNT) FROM CATEGORY C
JOIN FILM_CATEGORY FC
ON C.CATEGORY_ID = FC.CATEGORY_ID
JOIN INVENTORY I
ON I.FILM_ID = FC.FILM_ID
JOIN RENTAL R
ON R.INVENTORY_ID = I.INVENTORY_ID
JOIN PAYMENT P
ON P.RENTAL_ID = R.RENTAL_ID
GROUP BY C.NAME
ORDER BY SUM(P.AMOUNT) DESC
LIMIT 5;

-- * 8b. How would you display the view that you created in 8a?
SELECT * FROM TOP_FIVE_BY_REV;

-- * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW TOP_FIVE_BY_REV;

