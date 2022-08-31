-- STUDYING INDEXES AND VIEWS 
Create Table accounts (id int identity primary key NOT NULL, num int);
DROP TABLE accounts

SELECT * 
--DELETE *
FROM dbo.accounts


Insert Into accounts
Select Cast(rand(checksum(newid()))*10000000  as int)
GO 1000000

CREATE VIEW vAccounts
WITH SCHEMABINDING
AS
SELECT num,
--SUM(num) AS TotalSold
FROM Test1.dbo.accounts
GROUP BY id;

SELECT vAccounts;


CREATE INDEX IX_accounts_Department
ON accounts (Department ASC)


UPDATE dbo.accounts 
SET Department = 'Philanthropist'
WHERE Department IS NULL

ALTER TABLE dbo.accounts ADD [Department] varchar(255)

SELECT DISTINCT Department FROM accounts
WHERE num IS NOT NULL


CREATE INDEX IX_accounts_num
ON accounts (num ASC)

sp_Helpindex accounts




-- clustered index defines the order of the data in the table 
	-- only one index per table 
	-- Primary Key constraint automatically will create a clustered index on the table // per Id


CREATE TABLE [tblEmployee]
(	
	[Id] int PRIMARY KEY,
	[Name] nvarchar(50),
	[Salary] int, 
	[Gender] nvarchar(10),
	[City] nvarchar(50)
)

DROP TABLE [dbo].[tblEmployee]

EXECUTE sp_helpindex tblEmployee

-- unique index if used to enforce uniqueness of Id/PK

INSERT INTO tblEmployee(
	id, [Name], Salary, Gender, City
	)
VALUES
	 (3,'John',45000,'Male','New York')
	,(1,'Sam',25000,'Male','London')
	,(4,'Sara',55000,'Female','Tokyo')
	,(5,'Todd',31000,'Male','Toronto')
	,(2,'Pam',65000,'Female','Sydney');

SELECT * FROM tblEmployee

-- Clustered index reoders the data by the clustered index key 

CREATE CLUSTERED INDEX IX_tblEmployee_Gender_Salary
ON tblEmployee(Gender DESC, Salary ASC)

-- you cannot create a clustered index when there already is one, must drop the cix first

DROP INDEX tblEmployee.PK__tblEmplo__3214EC0723609462

CREATE NONCLUSTERED INDEX IX_tblEmployee_Name
ON tblEmployee([Name]);

-- Always rearrange Clustered IX for optimizing speed
-- Typically add Non-Clusterd IX for the most common columns used for WHERE clauses

ALTER TABLE tblEmployee
ADD CONSTRAINT UQ_tblEmployee_City
UNIQUE CLUSTERED (City);

DELETE 
FROM tblEmployee;

--------------------
-- Views

CREATE TABLE [tblDepartment]
(	
	[Id] int PRIMARY KEY,
	[Name] nvarchar(50),
	[Salary] int, 
	[Gender] nvarchar(10),
	[DeptName] nvarchar(50)
);

INSERT INTO tblDepartment(
	id, [Name], Salary, Gender, DeptName
	)
VALUES
	 (3,'John',45000,'Male','HR')
	,(1,'Sam',25000,'Male','Payroll')
	,(4,'Sara',55000,'Female','IT')
	,(5,'Todd',31000,'Male','HR')
	,(2,'Pam',65000,'Female','IT');

SELECT * FROM tblDepartment;

CREATE VIEW vWEmployeesByDepartment
AS
SELECT d.Id, d.[Name], d.Salary, d.Gender, d.DeptName, e.city
FROM tblEmployee AS e
JOIN tblDepartment AS d
ON e.Id = d.Id
;

-- the speed of getting this table is much faster 
SELECT * FROM vWEmployeesByDepartment
;

-- a view is nothing more than a stored query // or a virtual tbl
sp_helptext vWEmployeesByDepartment

-- helps non-IT users to simply do a join statement & they an automatically utilize the view 
	-- write the view to join 6 tables, and then use that view to be queried 
	-- use a where clause on it to query whatever they want 
-- make it so that someone can only see employees in their dept 

CREATE VIEW vWITEmployees
AS
SELECT d.Id, d.[Name], d.Salary, d.Gender, d.DeptName, e.City
FROM tblEmployee AS e
JOIN tblDepartment AS d
ON e.Id = d.Id
WHERE [DeptName] = 'IT'
;

SELECT * FROM vWITEmployees

CREATE VIEW vWNonConfidentialData
AS
SELECT d.Id, d.[Name], d.Gender, d.DeptName, e.City
FROM tblEmployee AS e
JOIN tblDepartment AS d
ON e.Id = d.Id
;

SELECT * FROM vWNonConfidentialData

CREATE VIEW vWSummarizedData
AS
SELECT d.DeptName, COUNT(e.id) AS TotalEmployees
FROM tblEmployee AS e
JOIN tblDepartment AS d
ON e.Id = d.Id
GROUP BY DeptName
;

SELECT * FROM vWSummarizedData


-----
--CREATE a view and then update the underlying base table;;

CREATE VIEW vWEmployeesDataexceptSalary
AS
SELECT [Id], [Name], [Gender], [DeptName] 
FROM tblDepartment

SELECT * FROM vWEmployeesDataexceptSalary

UPDATE vWEmployeesDataexceptSalary
SET [Name] = 'Michelle' 
WHERE [Id] = 2

SELECT * FROM tblDepartment

-- as you can see you can update the base table by querying the view 

DELETE 
FROM vWEmployeesDataexceptSalary
WHERE [Id] = 2

-- DELETE statements work as well

INSERT INTO vWEmployeesDataexceptSalary
VALUES (2, 'Mikey', 'Male','IT')

-- views are updateable
-- view is based on 1 base table, but possible to create it using multiple tables

CREATE VIEW vWEmployeesAll
AS
SELECT d.Id, d.[Name], d.Salary, d.Gender, d.DeptName, e.City
FROM tblEmployee AS e
JOIN tblDepartment AS d
ON e.Id = d.Id

SELECT * FROM vWEmployeesAll

UPDATE vWEmployeesAll
SET DeptName = 'IT'
WHERE [Name] = 'John'

SELECT * FROM tblDepartment
SELECT * FROM tblEmployee

-- if the view is based on mutliple tables, then updating things may not occur correctly
	-- must be mindful of that
	-- also can use triggers

-- INDEXED VIEWS

-- create an index on a view it becomes materialized
	-- a typical view by itself by default does not store any data, and is just the SQL query
	-- when you create an index on a view the view then gets materialized and is therfore capable of storing data

CREATE TABLE [tblProductSales]
(	
	 [ProductId] int 
	,[QuantitySold] int
)
;

INSERT INTO tblProductSales(
	ProductId, QuantitySold
	)
VALUES
	 (1,10)
	,(3,23)
	,(4,21)
	,(2,12)
	,(1,13)
	,(3,12)
	,(4,13)
	,(1,11)
	,(2,12)
	,(1,14)
;

SELECT * FROM tblProductSales;

-- creating the view	
-- schemabinding option is necessary if you want to create an index on the view
	-- you wont be able to change the underlying objects in any way that will affect the function/PROC/View
--if aggr function is used // SUM()
	-- it might return NULL, so must utilize SUM(ISNULL((),0))
-- if you use a GROUP BY in the view, then you must also use a COUNT_BIG() Function

CREATE VIEW vWTotalSalesByProduct
WITH SchemaBinding
AS
SELECT [p].[Name],
SUM(ISNULL((s.QuantitySold * p.UnitPrice),0)) AS TotalSales,
COUNT_BIG(*) AS TotalTransactions
FROM dbo.tblProductSales AS s
JOIN dbo.tblProduct AS p
ON p.ProductId = s.ProductId
GROUP BY [p].[Name]
;

SELECT * FROM vWTotalSalesByProduct;

CREATE Unique Clustered Index UIX_vWTotalSalesByProduct_Name
ON vWTotalSalesByPRoduct ([Name]);

--

ALTER View vWEmployeeDetails
AS
SELECT [Id], [Name], [Gender], [DeptName]
FROM tblDepartment
ORDER BY [Id]

SELECT * FROM vWEmployeeDetails
WHERE Gender = 'Male'

-- unable to have a parameterized view
	-- cannot send in params for the view 

-- Inline Table valued function as a replacement for Parameterized views

-- Inline Functions

CREATE function fnEmployeeDetails(@Gender nvarchar(20))
RETURNS TABLE
AS 
RETURN
(SELECT [Id], [Name], [Gender], [DeptName]
	FROM tblDepartment
	WHERE Gender = @Gender)

SELECT * FROM dbo.fnEmployeeDetails('Male')

-- you cannot use parameters in views
-- but using inline functions can be a replacement for that


-- TempTable

CREATE TABLE ##TestTempTable
(Id int, Name nvarchar(20), Gender nvarchar(10))

INSERT INTO ##TestTempTable VALUES(101, 'Martin', 'Male')
INSERT INTO ##TestTempTable VALUES(102, 'Tammy', 'Female')
INSERT INTO ##TestTempTable VALUES(103, 'Pam', 'Female')
INSERT INTO ##TestTempTable VALUES(104, 'James', 'Male')
-- you cannot create a view on a temp table 

SELECT * FROM ##TestTempTable

-- views not allowed on temp tables
CREATE VIEW vWOnTempTable
AS
SELECT Id, Name, Gender
FROM ##TestTempTable










