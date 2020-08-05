/*
Exercises for section 4

delete from PaperInstance where PaperID = 'IN610' -- I populated this table using a cross join so all of the data will match otherwise.
insert into Enrolment values ('IN511', '2019S2', 102);

select * from Paper
select * from PaperInstance
select * from Semester
select * from Person
select * from Enrolment

4.1	List the starting date and ending date of each occasion 
	IN511 Programming 2 has run.

	select s.StartDate, s.EndDate from Semester as s
	join PaperInstance i on s.SemesterID = i.SemesterID
	where i.PaperID = 'IN511'

4.2	List all the full names of the people who have ever enrolled in
	IN511 Programming 2 .
	If a person has enrolled more than once, do not repeat their name.

	select distinct p.FullName from Person as p
	join Enrolment e on p.PersonID = e.PersonID
	where e.PaperID != 'IN511'

4.3	List all the full names of all the people who have never enrolled in a paper
	(according to the data on the database).

	select distinct p.FullName, p.PersonID from Person p
	left join Enrolment e on p.PersonID = e.PersonID
	left join Paper pa on e.PaperID = pa.PaperID
	where e.PaperID IS NULL

4.4	List all the papers that have never been run (according to the data).There are currently none so insert one in order to test the query.
	
	Insert into Paper values ('IN728', 'Programming5')

	select p.PaperID, p.PaperName from Paper p
	left join PaperInstance i on p.PaperID = i.PaperID
	where i.PaperID IS NULL

4.5	List all the semesters, showing semester start date and length in days, in which IN511 has run.

	select s.SemesterID, s.StartDate, datediff(day, s.StartDate, s.EndDate) as [Number of Days] from Semester s
	join PaperInstance i on s.SemesterID = i.SemesterID
	where i.PaperID = 'IN511'

4.6	Develop a statement that returns all people that enrolled in IN511 
	in a semester that started on or between 12-Apr-2018 and 13-Aug-2019.
	Display the full name of each person and the year in which they enrolled. 
	Ensure the people are listed alphabetically according to their family name then given name.

	select * from Person p
	join Enrolment e on p.PersonID = e.PersonID
	join Semester s on e.SemesterID = s.SemesterID
	where e.PaperID = 'IN511' and s.StartDate between '12-apr-2018' and '13-aug-2019'


Exercises for section 5

	select * from Paper
select * from PaperInstance
select * from Semester
select * from Person
select * from Enrolment

5.1	List all the papers that have a paper instance. 
	Display the PaperID and number of instances of the paper.

	select PaperID, count(*) as [Number of instances] from PaperInstance i
	group by PaperID

5.2	How many people, in total over all semesters, have enrolled in each of the papers
	that have been delivered? Display the paper ID, paper name and enrolment count.

	select e.PaperID, p.PaperName, count(*) as [Enrolment Count] from Enrolment e
	join Paper p on e.PaperID = p.PaperID
	join Semester s on e.SemesterID = s.SemesterID
	where s.EndDate < getdate()
	group by e.PaperID, p.PaperName
	
5.3	How many people, in total over all semesters, have enrolled in each of the papers
	listed on the Paper table? Display the paper ID, paper name and enrolment count.

	select e.PaperID, p.PaperName, count(*) as [Enrolment Count] from Enrolment e
	join Paper p on e.PaperID = p.PaperID
	group by e.PaperID, p.PaperName

5.4	List the paper instance with the highest enrolment. 
	Display the paper instance's start date, en
	d date, paper name and enrolment count.

	select top 1 e.PaperID, s.StartDate, s.EndDate, p.PaperName, count(*) as [Enrolment Count] from Enrolment e
	join Paper p on e.PaperID = p.PaperID
	join Semester s on e.SemesterID = s.SemesterID
	group by e.PaperID, p.PaperName, s.StartDate, s.EndDate
	order by count(*) desc

5.5	List all the people who have 3, 4 or 5 enrolments.

	select ta.PersonID, ta.FullName, ta.[Enrolment Count] from
	(select e.PersonID, p.FullName, count(*) as [Enrolment Count] from Enrolment e
	join Person p on e.PersonID = p.PersonID
	group by e.PersonID, p.FullName) as ta
	where [Enrolment Count] between 3 and 5
	order by [Enrolment Count] desc

*/