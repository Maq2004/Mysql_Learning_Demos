-- 创建数据库方法一
CREATE DATABASE maqian;
-- 展示数据库信息 字符集一类
SHOW CREATE DATABASE maqian;
-- 修改创建的数据库的字符集，默认是utf8mb4
ALTER DATABASE maqian CHARACTER SET 'gbk';

-- 创建数据库的方法二：如果不存在创建，存在不创建，不报错
CREATE DATABASE  IF NOT EXISTS maqian;
-- 删除数据库
DROP DATABASE IF EXISTS maqian;
-- 创建表之前要使用数据库
USE maqian;
-- 创建表的方法一
CREATE TABLE emp(
	emp_id INT,
	emp_name VARCHAR(20),
	salary DOUBLE,
	brithday DATE
);
-- 展示表的结构
DESC emp;

-- 创建表和插入数据一起做：
CREATE TABLE dept2
AS
SELECT * FROM dept;

DESC dept2;

SHOW CREATE TABLE dept2;


 SHOW CREATE TABLE dept2\G

USE atguigudb;

-- 创建表和插入数据一起做，创建一个新表，新表的结构和查询字段一致，并且将查询到的数据直接插入
CREATE TABLE dept3 
AS 
SELECT e.employee_id , e.last_name , d.department_id
FROM employees e JOIN departments d
ON e.department_id = d.department_id;


SELECT * FROM dept3;
-- 新增一个列
ALTER TABLE dept3 ADD job_id VARCHAR(15);

-- 修改一个列 可以修改数据类型，长度，默认值，位置。
ALTER TABLE dept3 MODIFY job_id VARCHAR(20);
ALTER TABLE dept3 MODIFY job_id DOUBLE(10,2) DEFAULT 1000;

-- 重命名一个列 , 将job_id 修改为job_id1;
ALTER TABLE dept3 CHANGE job_id job_id1 VARCHAR(30);


-- 删除一个列
ALTER TABLE dept3 DROP COLUMN job_id1;

-- 重命名表

RENAME TABLE dept3 TO dept5;

-- 重命名表方式2

ALTER TABLE dept5 RENAME dept3;

-- 删除表， 当一张数据库中的表没有与其他任何数据表形成关联关系的情况下，可以直接将当前的数据表直接删除
-- 所有的数据和结构都被删除
-- 所有正在运行的相关事物都被删除
-- 所有的相关索引都被删除

DROP TABLE dept3;

-- 清空数据表中的数据
-- TRUNCATE语句不能回滚，而使用DELETE可以回滚(需要将事务自动提交关闭)
TRUNCATE TABLE dept3;

-- 关闭事务自动提交
SET autocommit = FALSE;

DELETE FROM dept3;
SELECT * FROM dept3;

ROLLBACK;

SELECT * FROM dept3;