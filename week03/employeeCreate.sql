
-- Delete the existing tables (if any) in the employee database
drop table if exists works_on cascade;
drop table if exists dept_location cascade;
drop table if exists department cascade;
drop table if exists project cascade;
drop table if exists employee cascade;

-- Create the employee database for Lab 2

-- Create the department table
create table department (
  dname        varchar(30) not null,
  dnumber      integer     primary key,
  mgrssn       integer,
  mgrstartdate date
);

-- Create the dept_location table (depends on department)
create table dept_location (
  dnumber   integer,
  dlocation varchar(30),
  primary key (dnumber, dlocation),
  foreign key (dnumber) references department(dnumber)
);

-- Create the employee table (depends on department)
create table employee (
  fname      varchar(25)   not null,
  minit      char(1),
  lname      varchar(25)   not null,
  ssn        integer       primary key,
  bdate      date          not null,
  address    varchar(200),
  salary     decimal(12,2) not null,
  superssn   integer,
  dno        integer,
  foreign key (dno) references department(dnumber)
);

-- Create the project table
create table project (
  pname     varchar(30) not null,
  pnumber   integer     primary key,
  plocation varchar(30) not null,
  dnum      integer     not null,
  foreign key (dnum) references department(dnumber)
);

-- Create the works_on table
create table works_on (
  ssn        integer  not null,
  pno        integer,
  hours      integer,
  primary key (ssn, pno),
  foreign key (ssn) references employee(ssn),
  foreign key (pno) references project(pnumber)
);

-- Insert sample data

-- Departments
insert into department (dname, dnumber, mgrssn, mgrstartdate)
values ('Information Technology', 1000, 20765, '01/01/07');

insert into department (dname, dnumber, mgrssn, mgrstartdate)
values ('Administration', 1001, 20915, '29/02/04');

insert into department (dname, dnumber, mgrssn, mgrstartdate)
values ('Finance', 1007, 21287, '07/06/05');

-- Department locations 
insert into dept_location (dnumber,dlocation)
values (1000, 'Canberra');

insert into dept_location (dnumber,dlocation)
values (1000, 'Sydney');

insert into dept_location (dnumber,dlocation)
values (1001, 'Canberra');

insert into dept_location (dnumber,dlocation)
values (1007, 'Canberra');

insert into dept_location (dnumber,dlocation)
values (1007, 'Sydney');


-- Employees without a middle initial
insert into employee (fname, lname, ssn, bdate, address, salary, superssn, dno)
values (
    'Michio',
    'Morishima',
    20118,
    '18/07/1973',
    '79 Macpherson St, Turner',
    52107,
    21286,
    1000
);

insert into employee (fname, lname, ssn, bdate, address, salary, superssn, dno)
values (
    'John',
    'Backus',
    20766,
    '03/12/1984',
    '25 Burns St, Yarralumla',
    46789,
    21287,
    1007
);

insert into employee (fname, lname, ssn, bdate, address, salary, superssn, dno)
values (
    'Gramsci',
    'Antonio',
    20876,
    '22/01/1991',
    '27 Garibaldi St, Ashfield, NSW',
    71569,
    20915,
    1001
);

insert into employee (fname, lname, ssn, bdate, address, salary, superssn, dno)
values (
    'Ada',
    'Lovelace',
    21286,
    '10/12/1985',
    '17 Ainslie Ave, Reid, ACT',
    62107,
    21286,
    1000
);

insert into employee (fname, lname, ssn, bdate, address, salary, superssn, dno)
values (
    'Milton',
    'Friedman',
    29057,
    '31/07/1972',
    '75 Wakefield Ave, Ainslie',
    37764,
    21287,
    1007
);

-- Employees with a middle initial
insert into employee
       (fname, minit, lname, ssn, bdate, address, salary, superssn, dno)
values (
    'Edsger',
    'W',
    'Dijkstra',
    20765,
    '11/05/1980',
    '192 Wattle St, O''Connor ACT',
    73567,
    20766,
    1000
);

insert into employee
       (fname, minit, lname, ssn, bdate, address, salary, superssn, dno)
values (
    'Grace',
    'M',
    'Hopper',
    20864,
    '09/12/1976',
    '45 Cobol St, Parramatta, NSW',
    78563,
    21286,
    1000
);

insert into employee
       (fname, minit, lname, ssn, bdate, address, salary, superssn, dno)
values (
    'Frederick',
    'W',
    'Taylor',
    20915,
    '20/03/1986',
    '14 Blackett St, Downer, ACT',
    56098,
    20915,
    1001
);

insert into employee
       (fname, minit, lname, ssn, bdate, address, salary, superssn, dno)
values (
    'John',
    'M',
    'Keynes',
    21287,
    '05/06/1983',
    '94 Earle St, Lyneham, ACT',
    73567,
    21287,
    1007
);


-- Projects
insert into project (pname, pnumber, plocation, dnum)
values ('Difference Engine', 9000, 'Canberra', 1000);

insert into project (pname, pnumber, plocation, dnum)
values ('Red tape is Fun', 9001, 'Canberra', 1001);

insert into project (pname, pnumber, plocation, dnum)
values ('Object Oriented COBOL', 9002, 'Sydney', 1000);

-- Who works on what
insert into works_on (ssn, pno, hours)
values (20765, 9000, 100);

insert into works_on (ssn, pno, hours)
values (20765, 9001, 500);

insert into works_on (ssn, pno, hours)
values (20864, 9002, 50);

insert into works_on (ssn, pno, hours)
values (20915, 9000, 250);
