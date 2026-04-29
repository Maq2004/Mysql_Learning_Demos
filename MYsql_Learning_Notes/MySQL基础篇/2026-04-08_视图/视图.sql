

CREATE DATABASE detest_04_08;

USE detest_04_08;

-- 为什么需要视图？

-- 视图一方面可以帮我们使用表的一部分而不是所有的表，另一方面也可以针对不同的用户制定不同的查
-- 询视图。比如，针对一个公司的销售人员，我们只想给他看部分数据，而某些特殊的数据，比如采购的
-- 价格，则不会提供给他。再比如，人员薪酬是个敏感的字段，那么只给某个级别以上的人员开放，其他
-- 人的查询视图中则不提供这个字段。
CREATE TABLE emps
AS
SELECT * FROM atguigudb.employees;

CREATE TABLE depts
AS
SELECT * FROM atguigudb.departments;

SHOW TABLES;

SELECT * FROM emps;


-- 创建视图

CREATE VIEW emp_sal
AS
SELECT  employee_id , last_name , salary 
FROM emps ;

CREATE VIEW emp_sal2( eid , ename , esalary )
AS
SELECT  employee_id , last_name , salary 
FROM emps ;

CREATE VIEW emp_sal3
AS
SELECT  employee_id  eid , last_name  ename, salary esal 
FROM emps ;



-- 多表联合创建视图

SELECT * FROM emps;
SELECT * FROM depts;


CREATE VIEW emp_dept 
AS
SELECT e.employee_id , e.last_name , d.department_name , e.department_id 
FROM emps e JOIN depts d 
ON e.department_id = d.department_id



CREATE VIEW dept_sal_avg
AS 
SELECT d.department_id , d.department_name , AVG(salary)
FROM emps e JOIN depts d 
ON e.department_id = d.department_id
GROUP BY department_id , department_name ;


SELECT * FROM depts;

SELECT * FROM emp_dept;
SELECT * FROM dept_sal_avg ORDER BY department_id;

--   利用视图对数据进行格式化

CREATE VIEW emp_depart
AS
SELECT CONCAT(last_name,'(',department_name,')') emp_dept
FROM emps e JOIN depts d 
ON e.department_id = d.department_id;


SELECT * FROM emp_depart;


-- 基于视图创建视图


SHOW TABLES;

SELECT * FROM emp_dept;

SELECT * FROM emp_sal;

CREATE VIEW emp_dept_sal
AS
SELECT  d.department_name , d.last_name , d.department_id , s.salary 
FROM emp_dept d JOIN emp_sal s
ON d.last_name = s.last_name;


SELECT * FROM emp_dept_sal;



-- 查看视图

SHOW TABLES;

-- 查看视图结构

DESC emp_dept_sal;

-- 查看视图信息 ， 存储引擎 ， 版本 ，数据行数 ， 数据大小

SHOW TABLE STATUS LIKE 'emp_dept_sal';

-- 查看视图详细定义信息

SHOW CREATE VIEW emp_dept_sal;


-- 更新视图数据

SHOW TABLES;

SELECT * FROM emp_sal;

UPDATE emp_sal 
SET salary = 20000
WHERE employee_id = 101; -- 修改视图的数据，基表中的数据会跟着更改

SELECT * FROM emps WHERE employee_id = 101;

DELETE FROM emp_sal
WHERE employee_id = 101; -- 同理，删除也是

-- 虽然可以更新视图数据，但总的来说，视图作为虚拟表，主要用于方便查询，不建议更新视图的数据。对视图数据的更改，都是通过对实际数据表里数据的操作来完成的。

-- 删除视图 
DROP VIEW IF EXISTS emp_sal;

-- 修改视图

ALTER VIEW emp_sal
AS
SELECT employee_id, salary FROM emps;



 -- 如果视图c基于视图A和视图B创建，那么删除视图A和B会导致c查询失败，需要手动修改
 
 --  可以将视图视为存储起来的select 语句， select语句中的表不见了，自然会查询失败

