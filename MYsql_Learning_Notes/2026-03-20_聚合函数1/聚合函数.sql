
SELECT COUNT(last_name) , COUNT("12") FROM employees;


SELECT COUNT(commission_pct) FROM employees;



-- 查询全体员工的：平均薪资（保留2位小数）、最高薪资、最低薪资、薪资总和。
-- 查询公司一共有多少人？（三种写法：COUNT(*) / COUNT(1) / COUNT(employee_id)）
-- 查询有提成的人数（commission_pct 不为 null 的记录数）。
-- 查询最早入职的日期 和 最晚入职的日期。
-- 查询 job_id 以 “SA_” 开头的员工的平均薪资（整数）。


SELECT ROUND(AVG(salary),2),MAX(salary),MIN(salary),SUM(salary) FROM employees;

SELECT COUNT(*),COUNT(employee_id),COUNT(1) FROM employees;

SELECT COUNT(commission_pct) FROM employees;

SELECT MIN(hire_date) , MAX(hire_date) FROM employees;

SELECT  AVG(salary) FROM employees WHERE job_id LIKE "SA_%";





-- 按部门（department_id）统计：
-- 每个部门的员工人数
-- 平均薪资（保留2位小数）
-- 薪资总和
-- 结果按平均薪资从高到低排序。

SELECT
	COUNT( department_id ) '部门人数',
	department_id,
	ROUND(	AVG( salary ) ,2) '部门平均工资' ,
	SUM(salary) '部门总工资'
FROM
	employees 
GROUP BY
	department_id
ORDER BY
	AVG( salary ) DESC;
	
	





-- 

-- 统计每个 job_id 出现的次数（人数），只显示人数 ≥ 4 的岗位，按人数降序。
SELECT
	COUNT( job_id ) cnt,
	job_id 
FROM
	employees 
GROUP BY
	job_id 
HAVING
	cnt >= 4 
ORDER BY
	job_id ASC;


-- 按部门统计：
-- 每个部门的最早入职日期
-- 每个部门的最晚入职日期
-- 按部门编号升序排列。

SELECT department_id,
       MIN(hire_date) '最早入职',
       MAX(hire_date) '最晚入职'
FROM employees
GROUP BY department_id
ORDER BY department_id;



-- 1 .查询公司中员工的最高工资、最低工资、平均工资和工资总额。此外，请统计公司中有提成（commission_pct 不为 NULL）的员工人数。


SELECT  MAX(salary) , MIN(salary) , SUM(salary) , COUNT(commission_pct) FROM employees ;

-- 2.查询每个部门（department_id）下，每种职位（job_id）的平均工资。输出结果应包含部门 ID、职位 ID 和平均工资。

SELECT department_id , job_id , AVG(salary) FROM employees GROUP BY department_id , job_id ;

	
-- 3.查询平均工资高于 10,000 的部门，并显示部门 ID 以及该部门的最高工资。

SELECT department_id , MAX(salary) FROM employees GROUP BY department_id HAVING AVG(salary) > 10000;


-- 4.查询公司中非程序员（即 job_id 不包含 IT_PROG）的所有职位中，最高工资大于 5000 的职位名（job_id）及其对应的最高工资。

SELECT job_id ,MAX(salary) FROM employees WHERE job_id NOT LIKE 'IT_PROG' GROUP BY job_id HAVING MAX(salary) >5000;


-- 5.统计各部门（department_id）的员工总数。要求结果中不仅显示每个具体部门的人数，还要在最后一行显示全公司的总人数。
SELECT department_id, COUNT(department_id) FROM employees GROUP BY department_id WITH ROLLUP;

