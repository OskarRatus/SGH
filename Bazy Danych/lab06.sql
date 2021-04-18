--Ćwiczenia06:
SELECT *
FROM employees;

SELECT *
FROM departments;

--1. zbuduj raport zawierający nazwy departamentów, nazwiska, imiona oraz roczne pensje pracujących w nich pracownikach.
   Wyłącz z raportu departamenty o numerach większych, niż 80

SELECT department_id, last_name, first_name, salary
FROM employees
WHERE department_id > 80;


-- 2. Zbuduj raport, który będzie zawierał nazwę departamentu oraz średnią pensję wszystkich zatrudnionych w  nim pracowników
   Wyłącz z raportu departamenty zatrudniające mniej, niż 2 pracowników

SELECT d.department_name, AVG(e.salary)
FROM employees e, departments d
WHERE e.department_id = d.department_id
WHERE count(*)>=2
GROUP BY d.department_name;

-- 3. Napisz polecenie SELECT odczytujące miasto z tablicy LOCATIONS oraz liczbę departamentów w danym mieście

SELECT *
FROM locations;

SELECT l.city, count(l.city)
FROM locations l, departments d
GROUP BY l.city;

-- 4. Napisz polecenie, które zwracać będzie nazwy miast, departamentów w nich zlokalizowanych oraz nazwiska i imiona wszystkich pracowników w poszcz. departamentach.
   Wyłącz z zestawienia departamenty o numerach 10, 20 oraz 30

SELECT l.city, d.department_name, e.last_name, e.first_name
FROM locations l, departments d, employees e
WHERE (l.location_id=d.location_id AND d.department_id=e.department_id) AND (d.department_id NOT IN (10, 20, 30));

-- 5. Napisz polecenie, które zwracać będzie informację o miastach, w których mieszczą się poszczególne departamenty oraz liczbie osób zatrudnionych w tych miastach.
   Wyeliminuj miasta, które zatrudniają mniej, niż dwóch pracowników

SELECT l.city, count(*)
FROM locations l, departments d, employees e
WHERE (l.location_id=d.location_id AND d.department_id=e.department_id)
HAVING count(*)>=3
GROUP BY l.city, d.department_id;


-- Zadanie domowe
-- 1. Napisz polecenie, które zwracać  będzie nazwy departamentów, liczby zatrudnionych w nich pracowników oraz ich maks. i min. pensje

SELECT d.department_name, count(e.salary), MAX(e.salary), MIN(e.salary)
FROM employees e, departments d
WHERE d.department_id=e.department_id
GROUP BY d.department_name;

-- 2. Napisz polecenie, które zwracać będzie stanowiska pracy oraz liczby miast z departamentami, w których pracują osoby na tych stanowiskach pracy

SELECT e.job_id, l.city
FROM employees e, departments d, locations l
WHERE e.department_id=d.department_id AND l.location_id=d.location_id
GROUP BY e.job_id, l.city
ORDER BY e.job_id;



-- 3. Napisz polecenie, które zwracać będzie nazwy deparamentów, lata zatrudnienia poszcz. pracowników oraz liczbę pracowników zatrudnionych w poszcz. latach w ramach departamentu
 
