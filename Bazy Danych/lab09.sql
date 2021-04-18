--Ćwiczenia09:
SELECT *
FROM employees;


--1. napisz zapytanie zwracające stanowisko pracy (job_id z EMPLOYEES), naswisko, imię i pensje wszystkich pracowników zarabiających mniej, niż wynosi średnia pensja na ich stanowiskach

SELECT e.job_id, e.last_name, e.first_name, e.salary
FROM employees e
WHERE salary < (SELECT avg(salary)
                FROM employees
                WHERE job_id = e.job_id);


--2. napisz zapytanie zwracające nazwę departamentu, nazwiska, imiona i pensje wszystkich pracowników z pensją większą, niż średnia w ich departamentach

SELECT e.department_id, e.last_name, e.first_name, e.salary
FROM employees e
WHERE e.salary > (SELECT AVG(salary)
                FROM employees
                WHERE department_id = e.department_id);


--3. napisz zapytanie zwracające nazwisko i imię szefa oraz podwładnych, którzy zarabiają mniej, niż średnia pensja wszystkich podwładnych danego szefa

select m.last_name, m.first_name, e.last_name, e.first_name, e.salary
from employees m, employees e
where m.employee_id = e.manager_id and e.salary > ( select avg(salary)
                                                    from employees
                                                    where manager_id = e.manager_id );


--4. napisz zapytanie zwracające nazwiska i imiona czterech ostatnio zatrudnionych pracowników.

SELECT e.last_name, e.first_name
FROM employees e
WHERE 4 > (SELECT COUNT(*)
           FROM employees
           WHERE hire_date > e.hire_date);


--5. napisz polecenie odczytujące rok zatrudnienia oraz nazwiska pracowników zarabiających poniżej średniej dla pracowników zatrudnionych w danym roku

-- TODO
SELECT e.hire_date, e.last_name
FROM employees e
WHERE salary < (SELECT AVG(salary)
                FROM employees
                WHERE hire_date = e.hire_date);


--Zadanie domowe

--1. Napisz zapytanie zwracające nr departamentu oraz liczbę pracowników w nim zatrudnionych dla trzech największych departamentów (trzech zatrudniających największą liczbę pracowników)

--2. Napisz zapytanie zwracające nr stawki płacowej oraz nazwiska, imona i pensje pracowników zarabiających więcej, niż średnia pensja w ramach danej stawki

--3. Polecenie nr 5 rozszerz o kolumnę zawierającą średnią pensję dla pracowników z danego departamentu