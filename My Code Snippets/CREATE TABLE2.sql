CREATE TABLE Employees
(
    [ID]      int             NOT NULL    PRIMARY KEY IDENTITY,
    [No]    int,
    [Agent Name] nvarchar(50),
    [Full Name]      nvarchar(50),
    [Accounts] nvarchar(255),
    [Password] nvarchar(255),
    [Recovery 1] nvarchar(255),
    [Source]   nvarchar(255),
    [Date]     date,
    [Date Used]    date,
    [VPS Assignment]    bigint,
    [QC Comment]    nvarchar(255),
	[Status] nvarchar(max),
	[Comments] nvarchar(max),
	[SE] nvarchar(255),
	[SE Status] nvarchar(255),
	[Usage Stance] nvarchar(255),
	[Sent Check] nvarchar(255),
	[SENT] int,
	[Bounce] smallint,
	[Open] nvarchar(255),
	[Subject] nvarchar(10),
	[Template] nvarchar(10),
	[List Source] nvarchar(255)
);


SELECT * FROM dbo.Tracker
