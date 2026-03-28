--Write a single query which shows the average salary of employees for each department	
SELECT dno, AVG(salary)
FROM employee
GROUP BY dno;		    

--(5) Show the project numbers and total hours for all projects whose total hours are more than 200 hours.

SELECT pnumber, SUM(hours)
FROM project,works_on
WHERE pnumber=pno
GROUP BY pnumber
HAVING SUM(hours)>200;		    


--(6)show the project numbers, names and total hours for the projects if their total hours
--are larger than 200 hours. Compare your query with the query written in the previous
--exercise.


SELECT pnumber,pname, SUM(hours)totalhours
FROM project,works_on
WHERE pnumber=pno
GROUP BY pnumber
HAVING SUM(hours)>200;		    


--(7)Show the department number, department name and average salary of all employees
--who work in the department if the average salary is greater than $60,000.
SELECT dno,dname, AVG(salary)
FROM employee,department
WHERE dno = dnumber
GROUP BY dno,dnumber
HAVING AVG(salary) > 60000;		


--8) List the employees who work on at least one project.
SELECT DISTINCT fname,lname
FROM employee NATURAL JOIN works_on;

--(9) List the projects which at least one employee works on.
SELECT distinct pname,pnumber FROM project
WHERE EXISTS (SELECT 1 FROM works_on where pno=pnumber AND ssn IS not null);

SELECT pname, pnumber
FROM project p
WHERE EXISTS (
    SELECT 1
    FROM works_on w
    WHERE w.pno = p.pnumber
);


--10) List all the employees, and the project numbers of the projects they work on if any.

SELECT e.fname,e.lname,w.pno
FROM employee e LEFT OUTER JOIN works_on w on e.ssn= w.ssn;
--
--(11) List all the projects, and the SSNs of the employees who work on the projects if
--any.
SELECT p.pnumber,w.ssn 
FROM project p LEFT OUTER JOIN works_on w on p.pnumber=w.pno;




(12) How many hours have been spent working on the most time-consuming project?

SELECT MAX(t.time_consumed)
FROM (
    SELECT pno,SUM(hours) time_consumed
    FROM works_on
    GROUP BY pno
)t;


--(13) Find the highest paid employee of each department, and show their first and last
--names, department numbers and salaries.

SELECT fname,lname,salary
FROM employee e
WHERE salary = 
    (SELECT MAX(salary)
    FROM employee
    WHERE e.dno = dno);


--(14) List the first and last names of employees who work in departments with more than
--one location

SELECT fname, lname, dno
FROM employee e
WHERE e.dno in
(SELECT dnumber
FROM dept_location
GROUP BY dnumber HAVING count(*) > 1);


--(15) List the names of all departments that have at least one employee whose salary is
--less than 50000.
SELECT DISTINCT dname
FROM department d
WHERE EXISTS(SELECT 1 
FROM employee 
WHERE d.dnumber=dno AND salary > 50000);


(16) List the first and last names of employees who work in departments with more than
one location.
SELECT fname, lname, dno
FROM employee e
WHERE EXISTS
(SELECT dnumber
FROM dept_location
WHERE e.dno = dnumber
GROUP BY dnumber HAVING count(*) > 1);
--
--(17) List the first and last names of employees who have a higher salary than their
--supervisor.

SELECT fname, lname
FROM employee e
WHERE salary >
(SELECT salary
FROM employee
WHERE e.superssn = ssn);


--(18) Which employee(s) has/have contributed the most hours to projects run by depart-
--ments they do not belong to? List the first and last name(s) of the employee(s).
SELECT s2.fname,s2.lname FROM(SELECT fname,lname,SUM(hours) sum_hours FROM
(SELECT * from employee NATURAL JOIN works_on w INNER JOIN project p ON p.pnumber=w.pno) c
WHERE dno!=dnum
GROUP BY dno,fname,lname)s2
WHERE s2.sum_hours = (SELECT max(s1.sum_hours) FROM (SELECT * from employee NATURAL JOIN works_on w INNER JOIN project p ON p.pnumber=w.pno) c
WHERE dno!=dnum
GROUP BY dno,fname,lname)s1);


SELECT s2.fname, s2.lname
FROM (
    SELECT e.fname, e.lname, SUM(w.hours) AS sum_hours, e.dno
    FROM employee e
    JOIN works_on w ON e.ssn = w.ssn
    JOIN project p ON w.pno = p.pnumber
    WHERE e.dno != p.dnum
    GROUP BY e.dno, e.fname, e.lname
) s2
WHERE s2.sum_hours = (
    SELECT MAX(s1.sum_hours)
    FROM (
        SELECT e.fname, e.lname, SUM(w.hours) AS sum_hours
        FROM employee e
        JOIN works_on w ON e.ssn = w.ssn
        JOIN project p ON w.pno = p.pnumber
        WHERE e.dno != p.dnum
        GROUP BY e.dno, e.fname, e.lname
    ) s1
);

WITH emp_hours AS (
    SELECT e.fname, e.lname, e.dno, SUM(w.hours) AS sum_hours
    FROM employee e
    JOIN works_on w ON e.ssn = w.ssn
    JOIN project p ON w.pno = p.pnumber
    WHERE e.dno <> p.dnum
    GROUP BY e.dno, e.fname, e.lname
)
SELECT fname, lname
FROM emp_hours
WHERE sum_hours = (
    SELECT MAX(sum_hours)
    FROM emp_hours
);