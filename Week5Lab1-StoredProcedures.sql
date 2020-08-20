/*
Using Transact-SQL : Exercises
------------------------------------------------------------

Exercises for section 12 : STORED PROCEDURE

*In all exercises, write the answer statement and then execute it.



e12.1		Create a SP that returns the people with a family name that 
			starts with a vowel [A,E,I,O,U]. List the PersonID and the FullName.

			CREATE PROCEDURE getPersonListStartsVowel
			AS
			SELECT PersonID, FullName FROM Person
			WHERE FamilyName LIKE '[AEIOU]%'
			GO
			EXEC getPersonListStartsVowel
			

e12.2		Create a SP that accepts a semesterID parameter and returns the papers that
			have enrolments in that semester. List the PaperID and PaperName.

			CREATE PROCEDURE getPapersFromSemester(@SemesterID nvarchar(10))
			AS
				SELECT DISTINCT p.PaperID, p.PaperName FROM Enrolment e
				JOIN Paper p on e.PaperID = p.PaperID
				WHERE SemesterID = @SemesterID
			GO
			EXEC getPapersFromSemester '2019S2'


e12.3		Modify the SP of 12.2 so that the parameter is optional.
			If the user	does not supply a parameter value default to the current semester.
			If there is no current semester default to the most recent semester.

			CREATE OR ALTER PROCEDURE getPapersFromSemester(@SemesterID nvarchar(10) = NULL)
			AS
			BEGIN
				IF @SemesterID IS NULL
					SET @SemesterID = (SELECT DISTINCT TOP 1 WITH TIES e.SemesterID FROM Enrolment e
						JOIN Semester s ON e.SemesterID = s.SemesterID
						WHERE s.StartDate <= GETDATE() AND s.EndDate >= GETDATE()
						ORDER BY e.SemesterID)
				IF @SemesterID IS NULL
					SET @SemesterID = (SELECT DISTINCT TOP 1 WITH TIES e.SemesterID FROM Enrolment e
						JOIN Semester s ON e.SemesterID = s.SemesterID
						WHERE s.StartDate <= GETDATE()
						ORDER BY e.SemesterID DESC)

				SELECT DISTINCT p.PaperID, p.PaperName FROM Enrolment e
				JOIN Paper p on e.PaperID = p.PaperID
				WHERE SemesterID = @SemesterID
			END
			GO
			EXEC getPapersFromSemester '2019S2'

e12.4		Create a SP that creates a new semester record. the user must supply all
			appropriate input parameters.

			CREATE PROCEDURE insertSemester(@SemesterID nvarchar(10), @StartDate datetime, @EndDate datetime)
			AS
			BEGIN
				INSERT Semester (SemesterID, StartDate, EndDate)
				VALUES (@SemesterID, @StartDate, @EndDate)
			END
			GO
			EXEC insertSemester '2020S2', '19-July-2020', '25-Nov-2020'
