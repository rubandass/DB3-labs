/*
Using Transact-SQL : Exercises
------------------------------------------------------------
Exercises for section 6 Subqueries

e6.1	List the paper with the lowest average enrolment per instance. Ignore all papers with no enrolments.
	Display the paper ID, paper name and average enrolment count.

	select top 1 with ties 
		pa.PaperID, PaperName, [Average Enrolment Count] from Paper as pa
	join 
		(select PaperID, avg(ec) as [Average Enrolment Count] from
		(select PaperID, SemesterID, cast(count(*) as decimal(9,4)) as ec from Enrolment 
		group by PaperID, SemesterID) as e
	group by 
		PaperID) as p on pa.PaperID = p.PaperID 
	order by 
		[Average Enrolment Count]

e6.2	List the paper with the highest average enrolment per instance. 
	Display the paper ID, paper name and average enrolment count.

	select top 1 with ties 
		pa.PaperID, PaperName, Average from Paper as pa
	join 
		(select PaperID, avg([Enrolment Count]) as Average from
		(select PaperID, SemesterID, cast(count(*) as decimal(9,4)) as [Enrolment Count] from Enrolment
	group by 
		PaperID, SemesterID) as e
	group by 
		PaperID) as p on pa.PaperID = p.PaperID 
	order by 
		Average desc

e6.3	For each paper that has a paper instance: list the paper ID, paper name, 
	starting date of the earliest instance, starting date of the most recent instance, 
	the minimum number of enrolments in the instances,
	maximum number of enrolments in the instances and 
	average number of enrolments across all	the instances.

	select
		ec.PaperID, 
		p.PaperName, 
		MIN(s.StartDate) as [Earliest Instance], 
		MAX(s.StartDate) as [Recent Instance], 
		MIN(ec.EnrolmentCount) as [Min Enrolment], 
		MAX(ec.EnrolmentCount) as [Max Enrolment], 
		cast(AVG(ec.EnrolmentCount) as decimal(9,4)) as [Average Enrolment]
	from
		(select PaperID, SemesterID, count(PaperID) as EnrolmentCount from Enrolment
		group by PaperID, SemesterID) as ec
	join
		Paper p on ec.PaperID = p.PaperID
	join
		Semester s on ec.SemesterID = s.SemesterID
	group by 
		ec.PaperID, p.PaperName

e6.4	Which paper attracts people with long names? Find the background statistics 
	to support a hypothesis test: for each paper with enrolments calculate the mean full name length, 
	sample standard deviation full name length & sample size (that is: number of enrolments).

	select
		NL.PaperID, 
		AVG([Name Length]) as Average, 
		STDEV([Name Length]) as SD, 
		COUNT(*) as Enrolments ,
		MAX([Name Length]) as [Max Name Length]
	from 
		(select e.PaperID, len(pe.FullName) as [Name Length] from Enrolment e
		join Person pe on e.PersonID = pe.PersonID) as NL
	group by 
		NL.PaperID
	order by
		[Max Name Length] desc

e6.5	Rank the semesters from the most loaded (that is: the highest number of enrolments) to
	the least loaded. Calculate the ordinal position (1 for first, 2 for second...) of the semester
	in this ranking.

	SELECT 
		SemesterID,
		COUNT(*) as [Enrolment Count], 
		ROW_NUMBER() OVER(ORDER BY count(*) DESC) AS Rank 
	FROM 
		Enrolment
	GROUP BY 
		SemesterID

Exercises for section 7

--Use UNION to solve these tasks. 
--Note that these tasks could possibly be solved by another non-UNION statement.
--Can you also write a non-UNION statement that produces the same result?   

e7.1	In one result, list all the people who enrolled in a paper delivered during 2019 and
	all the people who have enrolled in IN605. 
	The result should have three columns: PersonID, Full Name and the reason the person
	is on the list - either 'enrolled in 2019' or 'enrolled in IN605'

	select 
		PersonID, FullName, 'enrolled in 2019' as Reason from Person
	union
	select 
		e.PersonID, p.FullName, 'enrolled in 2019' from Enrolment e
	join 
		Person p on e.PersonID = p.PersonID
	where 
		SemesterID like '2019%' and PaperID = 'IN605'


	select e.PersonID, p.FullName, 'Enrolled in 2019' as Reason from Enrolment e
	join Person p on e.PersonID = p.PersonID
	where e.SemesterID like '2019%' and e.PaperID = 'IN605'


e7.2	Produce one resultset with two columns. List the all Paper Names and all the Person Full Names in one column.
	In the other column calculate the number of characters in the name.
	Sort the result with the longest name first.

	select
		pp.PaperName, len(pp.PaperName) as [Name Length]
	from
		(select PaperName from Paper pa
		UNION
		select FullName from Person as p) as pp
	order by [Name Length] desc

*/