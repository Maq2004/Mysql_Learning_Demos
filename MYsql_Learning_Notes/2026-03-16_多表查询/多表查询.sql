SELECT last_name , department_name FROM employees , departments WHERE employees.department_id = departments.department_id;



SELECT e.last_name , d.department_name 
FROM employees e , departments d
 WHERE e.department_id = d.department_id;
 
 -- SQL99写法
 
 SELECT e.last_name , d.department_name
 FROM employees e
 JOIN departments d 
 ON e.department_id = d.department_id;
 
 



SELECT e.last_name , d.department_name ,l.city
 FROM employees e ,departments d , locations l 
 WHERE e.department_id = d.department_id 
 AND d.location_id = l.location_id ;
 
 -- SQL99 写法
 SELECT e.last_name , d.department_name , l.city
 FROM employees e JOIN departments d 
 ON e.department_id = d.department_id
 JOIN locations l 
 ON d.location_id = l.location_id;
 
 

-- 非等值查询，employees表中的列工资应该在job_grades表中的最高工资和最低工资之间

SELECT e.last_name , e.salary , j.grade_level
 FROM employees e , job_grades j 
 WHERE e.salary BETWEEN j.lowest_sal
	AND j.highest_sal 
	ORDER BY e.salary ASC ;

-- 如何查询不在最高工资和最低工资之间的人？


-- 自连接和非自连接
-- 当table1和table2本质上是同一张表，只是用取别名的方式虚拟成两张表以代表不同的意义。然后两个表再进行内连接，外连接等查询

SELECT CONCAT(workers.last_name , ' works for ',managers.last_name ) FROM employees workers, employees managers WHERE workers.manager_id = managers.employee_id;

-- 查询出last_name为 ‘Chen’ 的员工的 manager 的信息

SELECT workers.employee_id AS "工号", workers.last_name AS "员工" , managers.last_name AS "领导" 
FROM employees workers, employees managers
 WHERE workers.manager_id = managers.employee_id
	AND workers.last_name LIKE 'Chen';


-- 外连接，分为左外连接和右外连接，两个表在连接过程中除了返回满足条件的行意外，还返回左（右）表中不满足条件的行，这种成为左连接或者右连接，即没有匹配的行的时候，结果表中相对应的列是空（NULL）

-- 如果是左外连接，则连接条件中左边的表也称为主表，右边的表称为从表。（也就是如果从表的列没有和主表的列相对应的值，那么从表的那一行返回null）
-- 如果是右外连接，则连接条件中右边的表也称为主表，左边的表称为从表
-- LEFT JOIN 和 RIGHT JOIN 只存在于 SQL99 及以后的标准中，在 SQL92 中不存在，只能用 (+) 表示。
-- 在 SQL92 中采用（+）代表从表所在的位置。即左或右外连接中，(+) 表示哪个是从表。

-- 左外连接

SELECT e.last_name , e.department_id , d.department_name
FROM employees e 
LEFT OUTER JOIN departments d 
ON e.department_id = d.department_id


-- 右外连接

SELECT e.last_name , e.department_id , d.department_name
FROM employees e 
RIGHT JOIN departments d 
ON (e.department_id = d.department_id);


-- 满外连接
-- 满外连接的返回结果就是左右表的匹配上的数据+左表没匹配上的数据和右表没匹配上的数据

-- SQL99是支持满外连接的。使用FULL JOIN 或 FULL OUTER JOIN来实现。
-- 需要注意的是，MySQL不支持FULL JOIN，但是可以用 LEFT JOIN UNION RIGHT join代替。

-- UNION操作符
-- UNION 操作符返回两个查询的结果集的并集，去除重复记录。
-- UNION ALL操作符返回两个查询的结果集的丙级，不去除重复记录

-- 查询部门编号>90 或邮箱包含'a'的员工，用UNION和UNION ALL分别写
SELECT last_name FROM employees WHERE department_id > 90 
UNION ALL
SELECT last_name FROM employees WHERE email LIKE '%a%';



-- 右外连接- 内连接
SELECT e.last_name , e.department_id , d.department_name
FROM employees e 
RIGHT JOIN departments d 
ON (e.department_id = d.department_id)
WHERE e.department_id IS NULL;




-- 1. 如果不写任何连接条件，查询员工姓名和部门名称会得到多少行？写出正确SQL（用WHERE或JOIN...ON），并说明为什么必须加连接条件。
SELECT last_name FROM employees ;
SELECT department_name FROM departments;

--  查询员工姓名得出107条数据，查询部门名称得到27条数数据，由于笛卡尔积的性质，则一共会得到27*107条数据，因为员工姓名的每一条数据都会对应上部门名称的所有数据，而员工姓名有107条，部门名称有27条，所以得出107*27；

-- 正确答案

SELECT e.last_name , d.department_name
FROM employees e , departments d
WHERE e.department_id = d.department_id;

-- 使用JOIN……ON写法
SELECT e.last_name , d.department_name
FROM employees e 
JOIN departments d
ON e.department_id = d.department_id;


-- 2.查询所有员工的 last_name、department_name 和 city（需要连接3张表：employees、departments、locations）。用 JOIN...ON 写出SQL

SELECT e.last_name , d.department_name , l.city 
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN locations l
ON d.location_id = l.location_id;
 
 
 -- 3. 查询所有员工（包括没有部门的员工）的姓名和部门名称。没有部门的员工让 department_name 显示为 NULL。
 
 SELECT e.employee_id,e.last_name ,d.department_name
 FROM employees e
 LEFT JOIN departments d
 ON e.department_id = d.department_id;
 
 
-- 4.查询所有部门（包括没有员工的部门）的部门名称和员工姓名。没有员工的部门让 last_name 显示为 NULL。


 SELECT e.employee_id,e.last_name ,d.department_name
 FROM employees e
 RIGHT JOIN departments d
 ON e.department_id = d.department_id;
 
-- 5.查询每个员工的上级信息，格式为“XXX works for XXX”（如 Kochhar works for King）。用自连接 + 别名（worker 和 manager）写出SQL。

SELECT CONCAT(works.last_name,' works for ',managers.last_name) 
FROM employees works
JOIN employees managers
ON works.manager_id = managers.employee_id;

-- 6.查询员工姓名、薪资和薪资等级（grade_level），条件是员工薪资落在 job_grades 表的 lowest_sal 和 highest_sal 之间。

SELECT e.last_name , e.salary ,j.grade_level
FROM employees e 
JOIN job_grades j
ON e.salary 
BETWEEN j.lowest_sal AND j.highest_sal
ORDER BY j.grade_level ASC;



-- 7. 查询员工姓名、部门名称和岗位标题（job_title），同时满足：员工部门编号 = 部门表编号 并且 员工岗位ID = jobs表job_id。

SELECT e.last_name , d.department_name , j.job_title
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN jobs j
ON e.job_id = j.job_id;


-- 8.查询 department_id > 90 的员工姓名 或者 email 包含字母 'a' 的员工姓名。用 UNION 写出（去重）。

SELECT last_name FROM employees WHERE department_id >90
UNION
SELECT last_name FROM employees WHERE email LIKE '%a%';

-- 9.同上题，用 UNION ALL 写出。对比 UNION 和 UNION ALL 的结果行数有什么不同？哪个效率更高？

SELECT last_name FROM employees WHERE department_id >90
UNION ALL
SELECT last_name FROM employees WHERE email LIKE '%a%';

-- 使用UNION ALL代表不去重，不去重的速度更快因为是一步走，而去重是先查出来然后呢再去去重，两步走

-- 10.查询只有员工但没有对应部门的记录（即部门表中不存在的 department_id）。用 LEFT JOIN + WHERE ... IS NULL 写出。

 SELECT e.employee_id,e.last_name ,d.department_name
 FROM employees e
 LEFT JOIN departments d
 ON e.department_id = d.department_id
 WHERE d.department_name IS NULL;
 
 
 
 -- 11.查询员工的 last_name、department_name、city、country_name（需要连接 employees、departments、locations、countries 四张表）。用 JOIN...ON 写出SQL，并按国家名称升序排序。
 SELECT e.last_name , d.department_name , l.city , c.country_name
 FROM employees e
 JOIN departments d
 ON e.department_id = d.department_id
 JOIN locations l
 ON d.location_id = l.location_id
 JOIN countries c
 ON l.country_id = c.country_id
 ORDER BY c.country_name ASC;
 
 -- 12.查询每个员工的上级姓名，格式为“XXX works for YYY”。要求：即使没有上级（manager_id 为 NULL）的员工也要显示出来（上级姓名显示 NULL）。用自连接 + LEFT JOIN 写出。
 
SELECT works.last_name AS '员工' , managers.last_name AS '领导' ,CONCAT(works.last_name,' works for ',managers.last_name) 
FROM employees works
LEFT JOIN employees managers
ON works.manager_id = managers.employee_id;

-- 13.UNION 模拟满外连接（MySQL不支持FULL JOIN）查询所有员工和所有部门的信息：匹配上的员工和部门显示一次只有员工没有部门的记录也显示只有部门没有员工的记录也显示用 LEFT JOIN + UNION + RIGHT JOIN 的方式写出完整SQL。

SELECT e.last_name , d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
UNION
SELECT e.last_name , d.department_name
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id
WHERE e.department_id IS NULL;


-- 14.查询员工姓名、薪资、薪资等级（grade_level）、部门名称。条件：薪资落在 job_grades 的 lowest_sal 和 highest_sal 之间 并且 员工属于部门表。按薪资降序排序。

SELECT e.last_name ,e.salary ,j.grade_level,d.department_name
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
JOIN job_grades j
ON e.salary BETWEEN j.lowest_sal AND j.highest_sal
ORDER BY e.salary DESC;

-- 15.写出三条SQL（可以分开写）：
-- A：左表独有部分（只有员工，没有对应部门）
-- B：右表独有部分（只有部门，没有对应员工）
-- C：内连接部分（员工和部门都匹配上的）
-- 最后用 UNION ALL 把这三部分合并成一张结果表（字段统一为：last_name、department_name、type），并给 type 列标记 “员工独有”、“部门独有”、“都有”


SELECT e.last_name, d.department_name, '员工独有' AS type
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE d.department_id IS NULL

UNION ALL

-- B：部门独有（右表独有）
SELECT e.last_name, d.department_name, '部门独有' AS type
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id
WHERE e.department_id IS NULL
 
UNION ALL

SELECT e.last_name, d.department_name, '都有' AS type
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

