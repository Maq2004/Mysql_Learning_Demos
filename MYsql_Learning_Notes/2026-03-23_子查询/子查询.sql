  
	
	SELECT e2.last_name , e2.salary
	FROM employees e1 , employees e2
	WHERE e2.salary > e1.salary
	AND e1.last_name = 'Abel';
	
	-- ：查询工资大于149号员工工资的员工的信
	
SELECT
	last_name,
	salary 
FROM
	employees 
WHERE
	salary > ( SELECT salary FROM employees WHERE employee_id = 149 );
	
	-- 返回job_id与141号员工相同，salary比143号员工多的员工姓名，job_id和工资
SELECT
	last_name,
	job_id,
	salary 
FROM
	employees 
WHERE
	job_id = ( SELECT job_id FROM employees WHERE employee_id = 141 ) 
	AND
	 salary > (SELECT salary FROM	employees 	WHERE	employee_id = 143);
	
	
	-- 返回公司工资最少的员工的last_name,job_id和salary
	
SELECT
	last_name,
	job_id,
	salary 
FROM
	employees 
WHERE
	salary = ( SELECT MIN( salary ) FROM employees );
	
	
-- 	-- 查询与141号或者 174 号员工的manager_id和department_id相同的其他员工的employee_id， manager_id，department_id
	
SELECT
	last_name,
	employee_id,
	manager_id,
	department_id 
FROM
	employees 
WHERE
	(
	(
			department_id = ( SELECT department_id FROM employees WHERE employee_id = 141 ) 
			AND manager_id = ( SELECT manager_id FROM employees WHERE employee_id = 141 )
			) 
		OR 
		(
			department_id = ( SELECT department_id FROM employees WHERE employee_id = 174) 
		AND manager_id = ( SELECT manager_id FROM employees WHERE employee_id = 174 )
		
		)
		) 
	AND employee_id NOT IN ( 141, 174 );
	
	
	-- 查询最低工资大于50号部门最低工资的部门id和其最低工资
	
SELECT
	department_id,
	MIN( salary ) 
FROM
	employees 
GROUP BY
	department_id 
HAVING
	MIN( salary ) > ( SELECT MIN( salary ) FROM employees WHERE department_id = 50 );

-- 显式员工的employee_id,last_name和location。其中，若员工department_id与location_id为1800的department_id相同，则location为’Canada’，其余则为’USA’。

SELECT employee_id , last_name , CASE WHEN department_id = (SELECT department_id FROM departments WHERE location_id = 1800) THEN
		'Canada'
	ELSE
		'USA'
END AS "Location" FROM employees;


-- 第二种写法

SELECT employee_id , last_name , CASE department_id WHEN  (SELECT department_id FROM departments WHERE location_id = 1800) THEN
		'Canada'
	ELSE
		'USA'
END AS "Location" FROM employees;


-- 返回其它job_id中比job_id为‘IT_PROG’部门任一工资都低的员工的员工号、姓名、job_id以及 salary

SELECT
	employee_id,
	last_name,
	job_id,
	salary 
FROM
	employees 
WHERE
	job_id <> 'IT_PROG' 
	AND salary < ANY ( SELECT salary FROM employees WHERE job_id = 'IT_PROG' );

-- 返回其它job_id中比job_id为‘IT_PROG’部门所有工资都低的员工的员工号、姓名、job_id以及 salary


SELECT
	employee_id,
	last_name,
	job_id,
	salary 
FROM
	employees 
WHERE
	job_id <> 'IT_PROG' 
	AND salary < ALL ( SELECT salary FROM employees WHERE job_id = 'IT_PROG' );
	
	
	-- 查询平均工资最低的部门Id
SELECT
	department_id 
FROM
	employees 
GROUP BY
	department_id 
HAVING
	AVG( salary ) <= ALL (SELECT AVG( salary ) FROM	employees GROUP BY department_id)
	
	-- 方法二 
SELECT
	department_id 
FROM
	employees 
GROUP BY
	department_id 
HAVING
	AVG( salary ) = (
						SELECT
							MIN( avg_sal ) 
						FROM
							( SELECT AVG( salary ) avg_sal FROM employees GROUP BY department_id ) dept_avg_sal 
	)
	
	
	-- 查询所有工资高于其所在部门平均工资的员工姓名（last_name）、部门ID和工资
	
SELECT e1.last_name, e1.department_id, e1.salary
 FROM employees e1
	WHERE 
	salary > ( 
						SELECT AVG( salary ) 
						FROM employees e2 
						WHERE e2.department_id = e1.department_id 
	);
	
	-- 查询每个部门中工资最低的员工姓名、部门ID和工资（如果有多个并列最低，全部列出）。
	
	
SELECT
	e1.last_name,
	e1.department_id,
	e1.salary 
FROM
	employees e1 
WHERE
	salary = (
						SELECT
							MIN( salary ) 
						FROM
							employees e2 
						WHERE
						e2.department_id = e1.department_id
	);
	
	

	
	
	
	-- 查询那些工资高于其所在职位（job_id）所有其他员工工资的员工（即：每个职位中工资最高的员工）。
	
	SELECT e1.job_id,e1.last_name , e1.salary FROM employees e1 WHERE salary = (SELECT MAX(salary) FROM employees e2 WHERE e2.job_id = e1.job_id);
	
	
	
	-- 查询没有下属的员工。
	
	
	SELECT e1.last_name FROM employees e1 WHERE NOT EXISTS( SELECT manager_id FROM employees e2 WHERE e2.manager_id = e1.employee_id );
	
-- 查询每个员工的工资在其所在部门中的排名（不使用窗口函数！）。要求返回：last_name, department_id, salary, rank（排名从1开始，工资越高排名越靠前）


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	