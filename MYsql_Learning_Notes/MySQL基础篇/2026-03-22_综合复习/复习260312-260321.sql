

-- 查询 employees 表中所有的 department_id，要求去除重复值。
SELECT DISTINCT department_id FROM employees;

-- 筛选特定员工：查询 salary 在 8000 到 15000 之间，且 job_id 包含 'MAN' 的员工信息。
SELECT job_id, salary FROM employees WHERE salary BETWEEN 8000 AND 15000 AND job_id LIKE '%MAN%';

-- 空值处理：查询没有上级经理（manager_id 为 NULL）的员工姓名和部门ID。

SELECT last_name , employee_id FROM employees WHERE manager_id IS NULL;

-- 将员工的 first_name 和 last_name 拼接成一个字符串，中间用逗号分隔，并将结果全部转换为大写。
SELECT UPPER(CONCAT(first_name,',',last_name)) FROM employees; 

-- 查询入职日期在 '2005-01-01' 之后的员工，并计算他们截止今天的入职天数（使用 DATEDIFF）。
SELECT last_name ,DATEDIFF(NOW(),hire_date) FROM employees WHERE hire_date > '2005-01-01';

-- 查询员工姓名和薪水，将薪水格式化为带有千分位符且保留2位小数的字符串（例如：9,000.00）

-- SELECT last_name, CONCAT(ROUND(salary/1000 ,0), ',' , ROUND(salary MOD 1000,3)) FROM employees;
SELECT last_name, FORMAT(salary,2) FROM employees;

-- 根据 job_id 对员工进行评级：
-- 'AD_PRES' -> 'A'
-- 'ST_MAN' -> 'B'
-- 'IT_PROG' -> 'C'
-- 'SA_REP' -> 'D'
-- 其他 -> 'E'
-- 显示 last_name, job_id 和评级。




SELECT last_name , job_id , CASE job_id
	WHEN 'AD_PRES' THEN 'A'
	WHEN 'ST_MAN' THEN 'B'
  WHEN  'IT_PROG' THEN 'C'
	WHEN 'SA_REP' THEN 'D'
	ELSE 'E'
END '等级'
 FROM employees; 



-- 内连接：查询每个员工的姓名 (last_name) 及其所在的部门名称 (department_name)。

	SELECT e.last_name , d.department_name FROM employees e JOIN departments d ON e.department_id = d.department_id;
	




-- 多表连接：查询员工的姓名、部门名称以及部门所在的城市 (city)。（涉及 employees, departments, locations 三表）

SELECT
	e.last_name,
	d.department_name,
	l.city 
FROM
	employees e
	JOIN departments d ON e.department_id = d.department_id
	JOIN locations l ON d.location_id = l.location_id;





-- 左外连接：查询所有部门的名称以及该部门下的员工姓名。即使部门下没有员工，部门名称也要显示（员工姓名为 NULL）。

SELECT department_name,last_name FROM departments d LEFT JOIN employees e ON d.department_id = e.department_id;


-- 自连接：查询员工 "Chen" 的上级经理的姓名。（提示：employees 表自连接，通过 manager_id 关联）
SELECT
	worker.last_name '员工',
	manager.last_name '领导' 
FROM
	employees worker
	JOIN employees manager ON worker.manager_id = manager.employee_id 
	WHERE
	worker.last_name LIKE "%Chen%";
	



-- UNION 应用：查询部门编号 > 90 的员工信息，或者邮箱中包含字母 'a' 的员工信息（使用 UNION 实现）。

SELECT last_name  FROM employees WHERE department_id > 90
UNION
SELECT last_name FROM employees WHERE email LIKE '%a%';

-- 
-- 基础聚合：计算公司员工的最高工资、最低工资、平均工资和工资总和。


SELECT MAX(salary) , MIN(salary),AVG(salary),SUM(salary) FROM employees;


-- 分组统计：查询每个部门 (department_id) 的平均工资，并按平均工资从高到低排序。

SELECT department_id , AVG(salary) FROM employees GROUP BY department_id ORDER BY AVG(salary) DESC; 


-- 分组过滤：查询哪些部门的平均工资高于 8000？显示部门ID和平均工资。

SELECT department_id ,AVG(salary) FROM employees GROUP BY department_id HAVING AVG(salary) > 8000;



-- 复杂分组：查询每个部门 (department_id) 中不同职位 (job_id) 的最高工资，并只显示那些最高工资大于 10000 的记录。


SELECT department_id , job_id , MAX(salary) FROM employees GROUP BY department_id , job_id HAVING MAX(salary) > 10000;


-- ROLLUP 应用：查询每个部门的员工人数，并在最后增加一行显示总员工数。

SELECT department_id , COUNT(department_id) FROM employees GROUP BY department_id WITH ROLLUP;



-- 执行顺序陷阱：以下 SQL 语句哪里错了？为什么？
-- sql
-- 
-- 编辑

SELECT department_id, AVG(salary)
FROM employees
WHERE AVG(salary) > 8000
GROUP BY department_id;

WHERE语句中不能使用聚合函数作为条件




