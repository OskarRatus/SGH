--Ćwiczenia07:
SELECT *
FROM departments;

--1. Zbuduj zapytanie zwracające następujące informacje o pracownikach oraz o ich przełożonych:
--   a) nazwisko, imię, data zatrudnienia oraz pensja
--   b) Wydrukuj informacje tylko o tych pracownikach, którzy zostali zatrudnieni przed swoimi przełożonymi

SELECT e.first_name, e.last_name, e.salary, e.hire_date, m.first_name, m.last_name, m.salary, m.hire_date
FROM employees e, employees m
WHERE (e.manager_id = m.employee_id) and (e.hire_date < m.hire_date);


--2. Zbuduj zapytanie, które wyświetla informację o nazwie departamentu, nazwiskach i imionach pracowników w nich zatrudnionych.
--   Uwzględnij w raporcie dane o pracownikach zatrudnionych w nieistniejących departamentach

SELECT d.department_name, e.last_name, e.first_name
FROM departments d, employees e
WHERE d.department_id = e.department_id(+);


--3. Zbuduj zapytanie, które wyświetla numer stawki płacowej oraz średnią pensję pracowników mieszczących się w niej
DESC job_grades;

SELECT j.grade_level, AVG(e.salary)
FROM job_grades j, employees e
WHERE e.salary BETWEEN j.lowest_sal AND j.highest_sal
GROUP BY j.grade_level;


--4. Zbuduj zapytanie, które wyświetla nazwiska i imiona przełożonych oraz maks. i min. pensję ich podwładnych

SELECT m.last_name, MIN(e.salary), MAX(e.salary)
FROM employees e, employees m
WHERE m.employee_id=e.manager_id
GROUP BY m.last_name;


--5. Zbuduj zapytanie, które wyświetla miasto, numer stawki płacowej oraz liczbę pracowników w ramach owego miasta i stawki

SELECT l.city, j.grade_level, COUNT(*)
FROM locations l, job_grades j, employees e, departments d
WHERE (l.location_id=d.location_id) AND (d.department_id=e.department_id) AND (e.salary BETWEEN j.lowest_sal AND j.highest_sal)
GROUP BY l.city, j.grade_level
ORDER BY j.grade_level;


--6. Zbuduj zapytanie, które zwróci nazwisko szefa, nazwisko podwładnego oraz nazwisko podwładnego owego podwładnego

SELECT c.last_name, m.last_name, e.last_name
FROM employees c, employees m, employees e
WHERE (c.employee_id=m.manager_id) AND (m.employee_id=e.manager_id);


--Zadanie domowe

--1. Zbuduj zapytanie, które zwraca nastepujące dane
--   nazwisko, imię, pensję i stawkę placową przełożonego 
--   nazwisko, imię, pensję i stawkę placową jego podwładnych

SELECT m.last_name, m.first_name, j.grade_level, e.last_name, e.first_name, k.grade_level
FROM employees m, employees e, job_grades j, job_grades k
WHERE ( m.employee_id=e.manager_id) AND ( m.salary BETWEEN j.lowest_sal AND j.highest_sal) AND ( e.salary BETWEEN k.lowest_sal AND k.highest_sal);


--2. Zbuduj zapytanie zwracające nastepujące informacje:
--   a) nazwisko i imię przełożonego,
--   b) nr stawki płacowej oraz średnią pensję podwładnych w ramach przełożonego i stawki placowej
  
SELECT m.last_name, j.grade_level, AVG(e.salary)
FROM employees m, employees e, job_grades j
WHERE ( m.employee_id=e.manager_id) AND ( e.salary BETWEEN j.lowest_sal AND j.highest_sal) 
GROUP BY m.last_name, j.grade_level
ORDER BY j.grade_level DESC;

--3. Zbuduj zapytanie, które zwróci rok zatrudnienia pracowników oraz liczbę departamentów, w których zostali zatrudnieni pracownicy w danym roku




