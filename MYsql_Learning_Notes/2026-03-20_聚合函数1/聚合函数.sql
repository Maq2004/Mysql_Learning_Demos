
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
	COUNT( department_id ),
	department_id,
	ROUND(	AVG( salary ) ,2)
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




