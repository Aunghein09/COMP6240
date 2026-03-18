
-- Show the first and last names of the employee with ssn 20766 
select fname,
       lname
  from employee
 where ssn = 20766;


-- List the surnames and ssn's of the employees born before 1980
select lname,
       ssn
  from employee
 where bdate < '1/1/1980';


-- What projects are the Administration department working on?
select pname
  from project,
       department
 where dnum = dnumber
   and dname = 'Administration';


-- List the highest salary from each department along with the department name.
select dname,
       max(salary)
  from department, employee
 where dnumber = dno
 group by dname;
