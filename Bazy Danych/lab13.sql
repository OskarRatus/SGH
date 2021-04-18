--Ćwiczenia13:
SELECT * 
FROM jobs;

--Zadania:
--1. Napisz polecenie odczytujące dane o nazwach tabel, których jesteś właścicielem

SELECT table_name
FROM user_tables;


--2. Utwórz, przy pomocy polecenia CREATE TABLE AS SELECT tabelę, zawierającą nazwę miasta oraz liczbę pracowników zatrudnionych w tym mieście.
--   Sprawdź w stosownej perspektywie słownika danych istnienie tej tabeli

CREATE TABLE nowa_tabela
AS (SELECT l.city AS miasto, count(*) as liczba
    FROM locations l, employees e, departments d
    WHERE e.department_id = d.department_id AND l.location_id = d.location_id
    GROUP BY l.city); 

SELECT table_name
FROM user_tables
WHERE table_name = 'NOWA_TABELA';

--3. Sprawdź, jakimi sekwencjami b. danych dysponujesz

SELECT *
FROM user_sequences;


--4. Napisz polecenie odczytujące
--   nazwę departamentu
--   stanowisko pracy
--   średnią, maks i min. pensję w ramach
--   - nazwy departamentu i stanowiska pracy
--   - nazwy departamentu
--   - łącznie dla wszystkich danych

SELECT d.department_name, e.job_id, AVG(e.salary), MAX(e.salary), MIN(e.salary)
FROM employees e, departments d
WHERE e.department_id = d.department_id
GROUP BY ROLLUP(d.department_name, e.job_id);

--5. Polecenie z pktu 4. rozszerz o podsumowanie po stanowiskach pracy

SELECT d.department_name, e.job_id, AVG(e.salary), MAX(e.salary), MIN(e.salary)
FROM employees e, departments d
WHERE e.department_id = d.department_id
GROUP BY CUBE(d.department_name, e.job_id);

--zadania domowe
--1. Napisz polecenie odczytujące nazwy i polecenia SELECT związane ze wszystkimi perspektywami, których jestes właścicielem

SELECT view_name, text
FROM user_views;

--2. Napisz polecenie odczytujące 
--  nr stawki płacowej, nazwę departamentu, stanowisko pracy oraz maks i min. pensję w ramach
-- nr stawki płacowej, nazwy departamentu i stanowiska pracy
--   - nr stawki płacowej, nazwy departamentu
--   - nr stawki płacowej
--   - łącznie dla wszystkich danych
   
SELECT j.grade_level, d.department_name, e.job_id, MAX(e.salary), MIN(e.salary)
FROM job_grades j, departments d, employees e
WHERE (e.salary BETWEEN j.lowest_sal AND j.highest_sal) AND (d.department_id = e.department_id)
GROUP BY ROLLUP(j.grade_level, d.department_name, e.job_id);

--33 rows returned

3. polecenie z pktu 2 rozszerz o brakujące poziomy agregacji. O ile więcej wierszy wynikowych uzyskałeś?

SELECT j.grade_level, d.department_name, e.job_id, MAX(e.salary), MIN(e.salary)
FROM job_grades j, departments d, employees e
WHERE (e.salary BETWEEN j.lowest_sal AND j.highest_sal) AND (d.department_id = e.department_id)
GROUP BY CUBE(j.grade_level, d.department_name, e.job_id);

-- 79 rows returned
