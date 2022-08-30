CREATE TABLE Employees
(
    EmployeeID      int             NOT NULL    PRIMARY KEY IDENTITY,
    EmpFirstName    char(50)        NOT NULL,
    EmpLastName     char(50)        NOT NULL,
    EmpAddress      varchar(50)     NOT NULL,
    EmpCity         char(50)        NOT NULL,
    EmpState        char(2)         NOT NULL,
    EmpZipCode      varchar(10)     NOT NULL,
    EmpPhone        varchar(12)     NOT NULL,
    EmpJobTitle     char(30)        NOT NULL,
    EmployeeType    char(30)        NOT NULL,
    Salary          money           NOT NULL,
    HoursPerWeek    int             NOT NULL
);

