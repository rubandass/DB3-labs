/*
Using Transact-SQL : Exercises
------------------------------------------------------------

/*
Exercises for section 8 : INSERT

*In all exercises, write the answer statement and then execute it.


e8.1	Write a statement to create 2 new papers: IN338 and IN238 Extraspecial Topic 

		INSERT Paper(PaperID, PaperName)
		VALUES ('IN338', 'Web4'), ('IN238', 'DB4')

e8.2	Create a new user (yourself)
		Write statements that will add three enrolments for you
		in papers you have completed (Add extra papers if required).

		INSERT PaperInstance (PaperID, SemesterID)
		VALUES ('IN610', '2019S2')

		INSERT Person (PersonID, GivenName, FamilyName, FullName )
		VALUES ( '112', 'Rubandass', 'Jhondass', 'Rubandass Jhondass')

		INSERT Enrolment (PaperID, SemesterID, PersonID)
		VALUES ('IN605', '2019S2', '112'), ('IN610', '2019S2', '112'), ('IN612', '2019S2', '112')


e8.3	Imagine that every paper on the database will run in 2021.
		Write the statements that will create all the necessary paper instances. You will need to add the Semester
		This can be done using a subselect or a left outer join.

		INSERT Semester (SemesterID, StartDate, EndDate)
		VALUES ('2021S1', '02-feb-2021', '02-jun-2021')

		INSERT PaperInstance (PaperID, SemesterID)
		SELECT DISTINCT pa.PaperID, '2021S1' AS SemesterID from Paper pa
		LEFT JOIN PaperInstance i on pa.PaperId = i.PaperID
		

e8.4	Imagine a strange path-of-study requirement: in semester 2020S2
		Find all people who are currently enrolled in IN605 and not enrolled in IN612 and enrol them in IN238.
		Write a statement to create the correct paper instance for IN238.
		Write a statement that will find all people enrolled in IN605 (semester 2019S2)
		but	not enrolled in IN612 (semester 2019S2) and 
		will create IN238 (semester 2020S1) enrolments for them. Build it up one step at a time.
		
		1. create paper, semester and paper instance data
		2. Find IN605/2019S2 enrolments that are not in IN612
		3. insert new enrolments

		INSERT Semester (SemesterID, StartDate, EndDate)
		VALUES ('2020S1', '19-feb-2021', '04-jun-2020')

		INSERT PaperInstance (PaperID, SemesterID)
		VALUES ('IN238', '2020S1')

		INSERT Enrolment (PaperID, SemesterID, PersonID)
		SELECT 'IN238' AS PaperID, '2020S1' AS SemesterID, PersonID FROM Enrolment
		WHERE PersonID NOT IN
		(SELECT PersonID FROM Enrolment
		WHERE PaperID = 'IN612') AND PaperID = 'IN605' AND SemesterID = '2019S2'
