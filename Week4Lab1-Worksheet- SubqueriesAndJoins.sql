--1.
	SELECT TOP 1 WITH TIES title, price FROM titles
	WHERE price IS NOT NULL
	ORDER BY price ASC

--2.
	SELECT t.title FROM titles t
	JOIN sales s ON t.title_id = s.title_id
	WHERE s.qty > 40

--3.
	SELECT au_id, au_lname, au_fname FROM authors
	WHERE au_id NOT IN
	(
		SELECT au_id FROM titleauthor
	)
	
--4.
	SELECT DISTINCT p.pub_name FROM publishers p
	JOIN titles t ON p.pub_id = t.pub_id
	WHERE t.type = 'business'

--5.
	SELECT a.au_lname, a.au_fname FROM authors a
	JOIN titleauthor ta ON a.au_id = ta.au_id
	JOIN titles t ON ta.title_id = t.title_id
	WHERE t.type = 'popular_comp' 

--6.
	SELECT DISTINCT city FROM authors
	WHERE city IN
	(
		SELECT city FROM publishers
	)

--7.
	SELECT DISTINCT city FROM authors
	WHERE city NOT IN
	(
		SELECT city FROM publishers
	)

--8.
	SELECT title FROM titles
	WHERE ytd_sales IS NULL

--9.
	SELECT t.title, SUM(s.qty) as Sales FROM sales s
	JOIN titles t ON s.title_id = t.title_id
	GROUP BY s.title_id, t.title
	HAVING 
		SUM(s.qty) <
						(
							SELECT AVG(st.Sales) AS Average
							FROM
							(SELECT SUM(qty) as Sales FROM sales s
							JOIN titles t ON s.title_id = t.title_id
							GROUP BY s.title_id
							) AS st
						)
	ORDER BY t.title

--10.
	SELECT p.pub_name, COUNT(*) AS [Books Published] FROM publishers p
	JOIN titles t ON p.pub_id = t.pub_id
	WHERE p.state != 'CA'
	GROUP BY t.pub_id,p.pub_name
	ORDER BY p.pub_name

--11.
	SELECT t.title, COUNT(*) AS [Stores Count] FROM titles t
	JOIN sales s ON t.title_id = s.title_id
	GROUP BY t.title

--12.
	SELECT t.title, st.stor_name, s.qty FROM titles t
	JOIN sales s ON t.title_id = s.title_id
	JOIN stores st ON s.stor_id = st.stor_id
	GROUP BY t.title, s.qty, st.stor_name
	ORDER BY t.title, st.stor_name

--13.
	UPDATE roysched
	SET royalty = royalty + 2
	FROM roysched
	WHERE title_id IN ( SELECT s.title_id FROM titles t
						JOIN sales s ON t.title_id = s.title_id
						GROUP BY s.title_id
						HAVING SUM(qty) > 30	)
						
--14.
	SELECT type FROM
	(	SELECT type, pub_id FROM titles
	GROUP BY type, pub_id	) AS rt
	GROUP BY type
	HAVING COUNT(*) > 1
	