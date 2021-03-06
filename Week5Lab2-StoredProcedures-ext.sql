/****** Script for SelectTopNRows command from SSMS  

SELECT TOP (1000) [PaperID]
      ,[SemesterID]
      ,[PersonID]
  FROM [IN705_202002_jhonr1].[dbo].[Enrolment]
  
  Week 3 labs are due on Friday 21 August

 13.1 Develop a stored procedure [EnrolmentCount] that accepts a paperID
		and a semesterID and calculates the number of enrolments in the 
		relevant paper instance. It returns the enrolment count as an
		output parameter.

		CREATE PROCEDURE EnrolmentCount
		(	@PaperID nvarchar(10), 
			@SemesterID nvarchar(10), 
			@EnrolmentCount int OUTPUT	)
		AS
		BEGIN
			SET @EnrolmentCount = (	SELECT SUM(Count) FROM
									(SELECT PaperID, SemesterID, COUNT(*) as Count FROM Enrolment
									WHERE PaperID = @PaperID AND SemesterID = @SemesterID
									GROUP BY PaperID, SemesterID) AS EC	)
		END

		GO
		DECLARE @ec int
		EXEC EnrolmentCount 'IN510', '2019S1', @ec OUTPUT
		PRINT('-----------------------------')
		PRINT('Enrolment Count = ' + CAST(@ec AS NVARCHAR))
		PRINT('-----------------------------')
	
		
13.2	Re-develop stored procedure [EnrolmentCount] so that semesterID
		is optional and defaults to the current semester. If there is no
		current semester, it chooses the most recent semester. 

		CREATE OR ALTER PROCEDURE EnrolmentCount
		(	@PaperID nvarchar(10), 
			@SemesterID nvarchar(10) = NULL, 
			@EnrolmentCount int OUTPUT	)
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
			SET @EnrolmentCount = (	SELECT SUM(Count) FROM
								(SELECT PaperID, SemesterID, COUNT(*) as Count FROM Enrolment
								WHERE PaperID = @PaperID AND SemesterID = @SemesterID
								GROUP BY PaperID, SemesterID) AS EC	)
		END
		GO


13.3  Write the script you will need to test 13.2 hint: you may have to cast your output.

		DECLARE @ec int
		EXEC EnrolmentCount @PaperID = 'IN511', @EnrolmentCount = @ec OUTPUT
		PRINT('-----------------------------')
		PRINT('Enrolment Count = ' + CAST(@ec AS NVARCHAR))
		PRINT('-----------------------------')

*/