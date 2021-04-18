--Ćwiczenia08:
SELECT *
FROM departments;

--1. Napisz zapytanie, które zwraca informacje (nazwę departamentu, nazwiska, imiona, daty zatrudnienia i pensje zatrudnionych w nim pracowników) pracowników, którzy zarabiają najwięcej 
--   w swoich własnych departamentach

SELECT d.department_name, e.last_name, e.first_name, e.salary
   FROM employees e, departments d
   WHERE (d.department_id, e.salary) IN (select department_id, max(salary)
                                     from employees 
                                     group by department_id);


2. Który pracownik został zatrudniony jako ostatni w całej firmie

SELECT e.last_name
FROM employees e
WHERE e.hire_date IN (SELECT MAX(hire_date) FROM employees);


3. Zbuduj zapytanie, które zwraca listę pracowników zatrudnionych jako pierwsi na swoich stanowiskach pracy

SELECT e.last_name
FROM employees e
WHERE (job_id, hire_date) IN (SELECT job_id, MIN(hire_date) FROM employees GROUP BY job_id);


4. Zbuduj zapytanie zwracające listę pracowników zarabiających najwięcej w ramach swoich stawek płacowych

SELECT e.last_name
FROM employees e, job_grades j
WHERE (j.grade_level, e.salary) IN (SELECT j.grade_level, MAX(e.salary)
                                    FROM employees e, job_grades j 
                                    WHERE e.salary BETWEEN  j.lowest_sal AND j.highest_sal
                                    GROUP BY j.grade_level)

;



5. napisz polecenie odczytujące nazwę departamentu szefa oraz nazwę departamentu podwładnego
   uwzględnij jedynie te sytuacje, w których nazwa departamentu szefa jest inna, niż podwładnego

SELECT e.department_name, m.department_name
FROM departments e, departments m
WHERE (e.department_id, m.department_id) IN (
SELECT e.department_id, m.department_id
FROM employees m, employees e
WHERE e.manager_id=m.employee_id AND e.department_id <> m.department_id);


6. napisz polecenie odczytujące miasto, nazwę departamentu
   uwzględnij zarówno miasta bez departamentów, jak i departamenty bez miast

SELECT l.city, d.department_name
FROM locations l, departments d
WHERE l.location_id = d.location_id(+)
UNION
SELECT l.city, d.department_name 
FROM locations l, departments d
WHERE l.location_id(+) = d.location_id;


Zadanie domowe
1. Zbuduj zapytanie zwracające listę pracowników zarabiających najmniej w ramach swoich departamentów i swoich stanowisk pracy

2. Kto i kiedy został zatrudniony jako pierwszy w całej firmie

3. Napisz polecenie odczytujące miasto oraz nazwisko, imię oraz pensję osoby zarabiającej najwięcej w danym mieście


