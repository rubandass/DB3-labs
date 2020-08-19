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

			CREATE PROCEDURE getPapersFromOptionalSemester(@SemesterID nvarchar(10) = NULL)
			AS
			IF @SemesterID IS NULL
				SELECT DISTINCT p.PaperID, p.PaperName FROM Enrolment e
				JOIN Paper p on e.PaperID = p.PaperID
				WHERE SemesterID = @SemesterID OR SemesterID IS NULL
			GO
			EXEC getPapersFromSemester '2019S2'

e12.4		Create a SP that creates a new semester record. the user must supply all
			appropriate input parameters.

		
