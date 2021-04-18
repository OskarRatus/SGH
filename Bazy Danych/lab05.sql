--Ćwiczenia05:
-- 1. zbuduj raport zawierający numer departamentu oraz maks.pensję pracowników w każdym z tych departamentów
-- 2. zbuduj raport zawierający stanowisko pracy oraz liczbę pracowników na każdym z owych stanowisk
-- 3. który manager ma więcej, niż dwóch podwładnych ?
-- 4. jakie są najwcześniejsze daty zatrudnienia w poszczególnych departamentach
-- 5. zbuduj raport zawierający rok i miesiąc zatrudnienia oraz liczbę pracowników zatrudnionych w ramach tego roku i miesiąca, ich maksymalną, minimalną oraz średnią pensję

-- Zadanie domowe
-- 1. zbuduj raport zawierający nr departamentu, stanowisko pracy oraz maks. pensję pracowników w ramach departamentu i stanowiska pracy
SELECT department_id, job_id, max(salary)
FROM employees
GROUP BY department_id, job_id
ORDER BY department_id DESC;

-- 2. który departament ma średnią pensję niższą, niż 4000 ?
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
HAVING AVG(salary) < 4000;

-- 3. zbuduj raport zawierający zestawienie liczby pracowników oraz ich średniej pensji ze względu na procent prowizji ze sprzedaży,
   przy założeniu, że grupa pracowników bez prowizji powinna mieć w kolumnie jej odpowiadającej wartość 0
SELECT COUNT( *), AVG( salary), nvl( commission_pct, 0) as commission_pct
FROM employees
GROUP BY commission_pct;