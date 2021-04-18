-- Zajecia03
SELECT *
FROM employees;

--1. Odczytaj nazwiska, imiona i pensje wszystkich pracowników z departamentu 10 z pensją większą, niż 2000 
SELECT last_name, first_name, salary
FROM employees
WHERE department_id = 10 AND salary > 2000;

--2. Odczytaj id pracowników, nazwiska imiona i pensje wszystkich pracowników zatrudnionych poza departamentem 10 oraz z pensją mniejszą lub równą niż 5000
SELECT employee_id, last_name, first_name, salary
FROM employees
WHERE (NOT department_id = 10) AND (salary <= 5000);

--3. Który pracownik (nazwisko i imię) nie ma managera ?
SELECT *
FROM employees
WHERE manager_id IS NULL;

--4. Odczytaj id, nazwiska, imiona, daty zatrudnienia, pensje i procenty prowizji wszystkich pracowników spoza departamentów 10 i 20, którzy posiadają jakąkolwiek prowizję 
SELECT employee_id, last_name, first_name, hire_date, salary, commission_pct
FROM employees
WHERE (department_id <> 10 OR department_id <> 20) AND (commission_pct IS NOT NULL);

--5. Odczytaj dane pracowników (nazwiska, imiona i stanowiska pracy) wszystkich pracowników, którzy NIE SĄ zatrudnieni na stanowisku CLERK
SELECT last_name, first_name, job_id
FROM employees
WHERE job_id NOT LIKE '%CLERK';


SELECT *
FROM departments;
--6. Odczytaj numery oraz nazwy departamentów, których numery NIE mieszczą się na liście 10, 20, 30 
SELECT department_id, department_name
FROM departments
WHERE NOT (department_id = 10 OR department_id = 20 OR department_id = 30);

SELECT *
FROM job_grades;
--7. Odczytaj stawki płacowe (tabela job_grades) dla których minimalna pensja jest większa lub równa 4000
SELECT grade_level
FROM job_grades
WHERE lowest_sal <= 4000; 

--8. odczytaj Nazwiska, imiona orac roczne dochody pracownikow dla ktorych procent prowizji jest niepusty lub sa zatrudnieni w departamentach 10 lub (miesiecczna pensja + miesiecszna pensja*procent_prowizji)* 12 + bonus
SELECT last_name, first_name, (salary + salary*nvl(commission_pct,0))*12+nvl(bonus,0)
FROM employees
WHERE (commission_pct IS NOT NULL) OR (department_id <> 10);

--9. napisz polecenie, które odczytuje numery i nazwy departamentów wszystkich departamentów z numerami większymi od 10 i mniejszymi od 100
SELECT department_id, department_name
FROM departments
WHERE department_id BETWEEN 10 AND 100;

--10. napisz polecenie odczytujące dane pracowników (nazwisko, imię, data zatrudnienia) tyuch, których nazwiska zaczynają się na S lub imiona kończą się na 'y'
SELECT last_name, first_name, hire_date
FROM employees
WHERE (last_name LIKE 'S%') OR (last_name LIKE '%y');

--11. napisz polecenie odczytujące dane pracowników (nazwiska, imiona, pensje, numery departamentów) z departamentów 10, 20 i 40, których pensje mieszcczą się pomiędzy 2000 a 6000
Zadanie domowe
SELECT *
FROM employees
WHERE (department_id IN (10,20,40)) AND (salary BETWEEN 2000 AND 6000);

12. Który pracownik ma nazwisko składające się z czterech liter i zaczynające się na K
SELECT *
FROM employees
WHERE last_name LIKE 'K___';

13. Odczytaj nazwiska i stanowiska pracy pracowników pracujących w departamencie 50, z pensją powyżej 3000
SELECT last_name, job_id
FROM employees
WHERE (department_id = 50) AND (salary > 3000); 










