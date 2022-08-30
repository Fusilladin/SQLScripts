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

EXECUTE sp_helpindex tblEmployee

-- unique index if used to enforce uniqueness of Id/PK

INSERT INTO tblEmployee(
	id, [Name], Salary, Gender, City
	)
VALUES
	(3,'John',45000,'Male','New York'),
	(1,'Sam',25000,'Male','London'),
	(4,'Sara',55000,'Female','Tokyo'),
	(5,'Todd',31000,'Male','Toronto'),
	(2,'Pam',65000,'Female','Sydney');

SELECT * FROM tblEmployee

-- Clustered index reoders the data by the clustered index key 

CREATE CLUSTERED INDEX IX_tblEmployee_Gender_Salary
ON tblEmployee(Gender DESC, Salary ASC)

-- you cannot create a clustered index when there already is one, must drop the cix first

DROP INDEX tblEmployee.PK__tblEmplo__3214EC073C68B5BB

CREATE NONCLUSTERED INDEX IX_tblEmployee_Name
ON tblEmployee([Name])

-- Always rearrange Clustered IX for optimizing speed
-- Typically add Non-Clusterd IX for the most common columns used for WHERE clauses







1