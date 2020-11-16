
DECLARE @maximumRows int
DECLARE @currentRow int
DECLARE @_Login nvarchar(100)
DECLARE @_Password nvarchar(100)
DECLARE @_DefaultDatabase nvarchar(100)
DECLARE @ExecLogin nvarchar(1000)

DECLARE @dbFilePath nvarchar(2000) 
DECLARE @dbLogPath nvarchar(2000)
DECLARE @DBName nvarchar(1000)
DECLARE @logicalDataName nvarchar(600) 
DECLARE @logicalLogName nvarchar(600) 
DECLARE @dataFileName nvarchar(600) 
DECLARE @logFileName nvarchar(600)

DECLARE @dataSize nvarchar(500) 
DECLARE @dataMaxSize nvarchar(500) 
DECLARE @dataFileGrowth nvarchar(500) 
DECLARE @logSize nvarchar(500) 
DECLARE @logMaxSize nvarchar(500) 
DECLARE @logFileGrowth nvarchar(500)
DECLARE @exeDataBase nvarchar(4000)
DECLARE @exeUser nvarchar(4000)

--Get the default database name and set to @_DefaultDatabase variable. 
SET @_DefaultDatabase = (
							SELECT default_database_name FROM sys.server_principals
							WHERE name = 'sa'
						)

SET @maximumRows = (select Count(*) from [students].[dbo].[users])
SET @currentRow = 1
SET @dbFilePath = '/var/opt/mssql/data/'
SET @dbLogPath = '/var/opt/mssql/log/'
SET @dataSize = '2 MB'
SET @dataMaxSize = '40 MB'
SET @dataFileGrowth = '2 MB'
SET @logSize = '2 MB'
SET @logMaxSize = '20 MB'
SET @logFileGrowth = '2 MB'

WHILE @currentRow <= @maximumRows
	BEGIN
		
		WITH T1 AS 
		(	SELECT 
			ROW_NUMBER() OVER(ORDER BY UserName) AS RowNumber, UserName, [Password]
			FROM [students].[dbo].[users]
		)
		SELECT @_Login = UserName, @_Password = [Password], @DBName = UserName
		FROM T1
		WHERE RowNumber = @currentRow
		--Creating Logins
		SET @ExecLogin = 'CREATE LOGIN ' + @_Login + ' WITH PASSWORD = ''' + @_Password + ''', DEFAULT_DATABASE = ' + @_DefaultDatabase 
		PRINT (@ExecLogin)
		EXEC (@ExecLogin)

		--Set Database, user creation variable values
		PRINT('Begin create database')
		SET @LogicalDataName=@DBName + '_dat'
		SET @DataFileName= @dbFilePath + @DBName + '.mdf'
		SET @LogicalLogName=@DBName + '_log'
		SET @LogFileName= @dbLogPath + @DBName + '.ldf'
		-- Creating databases
		SET @exeDataBase = 'CREATE DATABASE ' + @DBName + ' ON ('
		+ 'NAME = [' + @LogicalDataName + '], '
		+ 'FILENAME = [' + @DataFileName + '], '
		+ 'SIZE = ' + @DataSize + ', '
		+ 'MAXSIZE = ' + @DataMaxSize + ', '
		+ 'FILEGROWTH = ' + @DataFileGrowth + ') '
		+ 'LOG ON ('
		+ 'NAME = [' + @LogicalLogName + '], '
		+ 'FILENAME = [' + @LogFileName + '], '
		+ 'SIZE = ' + @LogSize + ', '
		+ 'MAXSIZE = ' + @LogMaxSize + ', '
		+ 'FILEGROWTH = ' + @LogFileGrowth + ') ' 
		PRINT('Creating database ' + @DBName)
		PRINT(@exeDataBase)
		EXEC(@exeDataBase)
		--Creating database users
		PRINT('Begin create user')
		SET @exeUser='USE ' + @DBName + ' CREATE USER [' + @_Login + '] FOR LOGIN [' + @_Login + ']'
		PRINT(@exeUser)
		EXEC(@exeUser)
		SET @currentRow += 1;
	END

--For my reference
/*
--Delete logins, databases

DECLARE @currentRow int
DECLARE @_Login nvarchar(100)
DECLARE @exeDropDataBase nvarchar(100)
DECLARE @exeDeleteUser nvarchar(100)
SET @currentRow = 1
WHILE @currentRow <= (select Count(*) from [students].[dbo].[users])
	BEGIN
		WITH T1 AS 
		(	SELECT 
			ROW_NUMBER() OVER(ORDER BY UserName) AS RowNumber, UserName
			FROM users
		)
		SELECT @_Login = UserName
		FROM T1
		WHERE RowNumber = @currentRow
		SET @exeDeleteUser = 'DROP LOGIN ' + @_Login
		SET @exeDropDataBase = 'DROP DATABASE ' + @_Login
		PRINT(@exeDeleteUser)
		EXEC(@exeDeleteUser)
		PRINT(@_Login + ' deleted')
		PRINT(@exeDropDataBase)
		EXEC(@exeDropDataBase)
		PRINT(@_Login + ' database dropped')
		SET @currentRow += 1;
	END
*/