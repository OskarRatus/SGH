--Ćwiczenia04:
SELECT * 
FROM employees;

 --   1. wydrukuj nazwiska, imiona wszystkich pracowników z departamentu 10 oraz ich pensje zwiększone o 10% i zaokrąglone do 2 miejsc po przecinku

SELECT last_name, first_name, ROUND( salary*1.1, 2)
FROM employees
WHERE DEPARTMENT_ID= 10;


--   2. wydrukuj nazwiska i imiona wszystkich pracowników zatrudnionych od 1 stycznia 2000 roku

SELECT last_name, first_name
FROM employees
WHERE hire_date > '01-Jan-2000';


-- 3. wydrukuj nazwiska i imiona wszystkich pracowników przekonwertowane do dużych liter.

SELECT UPPER( last_name), UPPER( first_name)
FROM employees;


--   4. wydrukuj nazwiska, imiona, daty zatrudnienia oraz pensje wszystkich pracowników. Daty zatrudnienia powinny zawierać NAZWĘ miesiąca, np. 21-JANUARY-1999

SELECT last_name, first_name, TO_CHAR( hire_date, 'DD-MONTH-YYYY'), salary
FROM employees;


--   5. wydrukuj unikalną listę dni tygodnia, w które byli zatrudniani poszczególni pracownicy z departamentu 20

SELECT DISTINCT TO_CHAR( hire_date, 'DAY')
FROM employees;


--   6. wydukuj nazwiska, imiona oraz inicjały wszystkich pracowników z departamentu 10. Inicjały skonwertuj do małych liter

SELECT last_name, first_name, LOWER( SUBSTR( first_name,1,1) || SUBSTR( last_name,1,1))
FROM employees
WHERE department_id = 10;

-------------------------------------------------------------------------
-- ZADANIE DOMOWE
--   1. zbuduj raport zawierający nast. dane wszystkich pracowników: 
--    numer departamentu, nazwiska i imiona skonwertowane do dużych liter oraz pensje powiększone o 25 procent i zaokrąglone do dwóch miejsc po przecinku

SELECT department_id, UPPER( last_name), UPPER( first_name), ROUND( salary*1.25, 2)
FROM employees;


--   2. zbuduj raport zawierający nazwiska wszystkich pracowników w nazwiskach każde wystąpienie litery K zamień na A

SELECT REPLACE( last_name, 'K', 'A')
FROM employees;
