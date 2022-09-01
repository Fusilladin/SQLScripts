--STORED PROCEDURES NOTES
----
--------------------------


SELECT * FROM tblDepartment

CREATE PROC spGetEmployees
AS 
BEGIN
	SELECT [Name], [Gender] 
	FROM tblDepartment
END

-- just execute the PROC name to do the query
spGetEmployees
EXEC spGetEmployees
Execute spGetEmployees

-- PROC with params
CREATE PROC spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@Department nvarchar(20)
AS
BEGIN
	SELECT [Name], [Gender], [DeptName]
	FROM tblDepartment
	WHERE Gender = @Gender
		AND DeptName = @Department
END

EXEC spGetEmployeesByGenderAndDepartment
-- expects param @gender otherwise get err

EXEC spGetEmployeesByGenderAndDepartment 'Male', 'IT'

EXEC spGetEmployeesByGenderAndDepartment @Department = 'IT', @Gender = 'Male'

--

sp_helptext spGetEmployees

  -- change the PROC cannot use CREATE; use ALTER
ALTER PROC spGetEmployees  
AS   
BEGIN  
 SELECT [Name], [Gender]   
 FROM tblDepartment  
 ORDER BY [Name]
END

EXEC spGetEmployees

DROP PROC --//

-- encrypting a PROC

sp_helptext spGetEmployeesByGenderAndDepartment

ALTER PROC spGetEmployeesByGenderAndDepartment  
@Gender nvarchar(20),  
@Department nvarchar(20)  
WITH encryption
AS  
BEGIN  
 SELECT [Name], [Gender], [DeptName]  
 FROM tblDepartment  
 WHERE Gender = @Gender  
  AND DeptName = @Department  
END

-- "The text for object 'spGetEmployeesByGenderAndDepartment' is encrypted."
-- cannot view the text of the proc but can delete it 

-- creating PROC with output param
-- use OUT or OUTPUT

CREATE PROC spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int OUTPUT
AS
BEGIN
	SELECT @EmployeeCount = COUNT([Id]) 
	FROM dbo.tblDepartment
	WHERE [Gender] = @Gender
END

-- need to DECLARE a var to be able to get the output param
DECLARE @EmployeeTotal int
EXEC spGetEmployeeCountByGender 'Male', @EmployeeTotal OUTPUT
PRINT @EmployeeTotal

-- to see info on the PROC
sp_help spGetEmployeeCountByGender


-- output params or return values

-- CREATE PROC 1 with an OUT param
CREATE PROC spGetTotalCount1
@TotalCount int OUT
AS
BEGIN
	SELECT @TotalCount = COUNT([Id]) 
	FROM tblDepartment
END

DECLARE @Total int
EXEC spGetTotalCount1 @Total OUT
SELECT @Total AS TotalEmployees

-- CREATE PROC 2 without an OUT param // using return values
CREATE PROC spGetTotalCount2
AS
BEGIN
	RETURN (SELECT 
				COUNT([Id]) 
			FROM 
				tblDepartment
)
END

DECLARE @Total int
EXEC @Total = spGetTotalCount2
SELECT @Total AS 'TotalEmployees'

-- CREATE PROC 3 using params and OUT
CREATE PROC spGetNameById1
@Id int,
@Name nvarchar(20) OUT
AS
BEGIN
	SELECT @Name = [Name] 
	FROM tblDepartment 
	WHERE [Id] = @Id
END

DECLARE @Name nvarchar(20)
EXEC spGetNameById1 1, @Name OUT
SELECT AS 'FullName'










