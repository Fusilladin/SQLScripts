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


















