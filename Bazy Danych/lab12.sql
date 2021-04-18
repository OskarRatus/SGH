-- Ćwiczenia 12
SELECT * 
FROM employees;

-- Zadania
--1. przy użyciu składni ANSI 99 zbuduj raport, który zawieera nazwę departamentu, nazwiska i imiona wszystkich pracownikóœ w nim pracujących, wraz z ich pensjami
--   Wyłącz z listy departamenty z id większymi, niż 80

SELECT employees.last_name, employees.first_name, employees.salary, departments.department_name
FROM employees
INNER JOIN departments ON
employees.Department_ID = departments.Department_ID
WHERE employees.department_id > 80;


--2. przy użyciu składni ANSI 99, zbuduj raport, który zawiera nazwę departamentu oraz średnią pensję wszystkich jego pracowników.
--   z listy wyłącz departamenty, które zatrudniają więcej, niż 2 pracownikówes

SELECT d.department_name, AVG(e.salary)
FROM employees e 
INNER JOIN departments d ON
e.department_id = d.department_id
WHERE 2 > ( SELECT count(*) FROM employees GROUP BY department_id)
GROUP BY department_name;


--3. przy użyciu składni ANSI 99, zbuduj raport, który zawiera nazwy departamentów oraz nazwiska w nim zatrudnionych pracownikóe
--   raport powienien zaiwerać zarówno dane o departamentach bez pracowników, jak i o pracownikach bez departamentów
   
SELECT d.department_name, e.last_name
FROM employees e FULL OUTER JOIN departments d ON
e.department_id = d.department_id;


--Zadanie domowe
--1 Przy użyciu składni ANSI 99 zbuduj raport, który zawiera nazwę miasta (tabela LOCATIONS) oraz nazwę departamentów.
--  Uwzględnij zarówno miasta bez departamentów, jak i departamenty bez miast

SELECT l.city, d.department_name
FROM locations l FULL OUTER JOIN departments d ON
d.location_id = l.location_id;


--2. Przy użyciu składni ANSI 99 zbuduj raport, który zawierać będzie 
--   - nazwisko pracownika
--   - jego pensję
--   - datę zatrudnienia
--   - kolumnę 'przedział pensji' zbudowaną wg następujących reguł
--     - jeśli pracownik zarabia mniej, niż 5000 - kolumna ta powinna zawierać napis 'NISKA'
--     - jeśli pracownik zarabia pomiędzy 5000 a 10000 - kolumna ta powinna zawierać napis 'SREDNIA'
-     - jeśli pracownik zarabia pow. 10000 - kolumna ta powinna zawierać napis 'WYSOKA'

SELECT 
	last_name, 
	salary, 
	hire_date, 
	CASE 
		WHEN salary < 5000
		 THEN 'NISKA'
		WHEN salary >= 5000 AND salary <= 10000
		 THEN 'SREDNIA'
		WHEN salary > 10000
		 THEN 'WYSOKA'
	END przedzial_pensji
FROM employees;










