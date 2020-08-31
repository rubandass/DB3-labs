/*
Using Transact-SQL : Exercises
------------------------------------------------------------
-- Careful of any triggers you may have running from the previous lab.
-- You can list all triggers by querying the sys.triggers view

Exercises for Section 15

		--ENABLE Trigger ALL ON ALL SERVER
		--DISABLE Trigger ALL ON ALL SERVER
		--select * from sys.triggers
		
15.1    Develop a view [BigPaperInstance] that finds the 10 paper instances
		with the most enrolments. Show the paperID, paper name,
		semesterID, start date and end date of the paper instance.

		CREATE VIEW BigPaperInstance
		AS
		SELECT p.*, s.* FROM Paper p
		JOIN 
		(SELECT TOP 10 WITH TIES PaperID, SemesterID FROM Enrolment
		GROUP BY PaperID, SemesterID
		ORDER BY COUNT(*) DESC) AS pi ON p.PaperID = pi.PaperID
		JOIN Semester s ON pi.SemesterID = s.SemesterID


15.2    Develop a view [SmallPaper] that finds the 10 paper instances
		with the least (lowest number of) enrolments. Show the paperID, paper name,
		semesterID, start date and end date of the paper instance.

		CREATE VIEW SmallPaper
		AS
		SELECT p.*, s.* FROM Paper p
		JOIN 
		(SELECT TOP 10 WITH TIES PaperID, SemesterID FROM Enrolment
		GROUP BY PaperID, SemesterID
		ORDER BY COUNT(*) ASC) AS pi ON p.PaperID = pi.PaperID
		JOIN Semester s ON pi.SemesterID = s.SemesterID


15.3	Write a view that lists all the current first year students
-- you will need to have a current semester and some students enrolled

		CREATE VIEW getCurrentFirstYearStudents
		AS
		SELECT p.* FROM Person p
		JOIN 
		(SELECT * FROM Enrolment
		WHERE SemesterID IN
		(SELECT SemesterID FROM Semester
		WHERE StartDate <= GETDATE() AND EndDate >= GETDATE()) AND PaperID LIKE 'IN5%') AS st ON p.PersonID = st.PersonID

***************************************************************************************

		You can reference a Database table even if you are not 
		currently connected to it as long as you use its fully qualified domain name.
		The following two questions are using the countries table in the World Database.
		You can use this to find the FQDN for World using a new query pointed at that Database:

			select
				 @@SERVERNAME [server name],
				 DB_NAME() [database name],
				 SCHEMA_NAME(schema_id) [schema name], 
				 name [table name],
				 object_id,
				 "fully qualified name (FQN)" =
				 concat(QUOTENAME(DB_NAME()), '.', QUOTENAME(SCHEMA_NAME(schema_id)),'.', QUOTENAME(name))
			from sys.tables
			where type = 'U' -- USER_TABLE


15.4    Develop a view [ConsonantCountry] that lists the countries that have a name
		starting with a consonant (b c d f g h j k l m n p q r s t v w x y z).
		Show the code and name of each country.

		ALTER VIEW ConsonantCountry
		AS
		SELECT Code, Name FROM [World].[dbo].[Country]
		WHERE LEFT(Name, 1) NOT LIKE '[aeiou]'
		select * from ConsonantCountry

15.5   Develop a view [RecentlyIndependentCountry] that lists countries that 
		gained their independence within the last 100 years. 
		Make sure the view adjusts the resultset to take account of the date when it is run.

		ALTER VIEW RecentlyIndependentCountry
		AS
		SELECT Name, IndepYear
		FROM [World].[dbo].[country]
		WHERE IndepYear 
		BETWEEN DATEPART(YEAR, DATEADD(YEAR, -100, GETDATE())) 
		AND DATEPART(YEAR, GETDATE())
		select * from RecentlyIndependentCountry

*/