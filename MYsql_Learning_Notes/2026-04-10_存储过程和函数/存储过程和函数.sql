CREATE DATABASE dbtest_04_10;


USE  dbtest_04_10;


CREATE TABLE emps 
AS
SELECT * FROM atguigudb.employees;

CREATE TABLE depts 
AS
SELECT * FROM atguigudb.departments;


-- 创建存储过程

DELIMITER $ -- 因为一般来说  ;  号 是依据命令的结尾，但是因为begin里要有很多 ; 影响判断于是先用 DELIMITER $ ，先代替 ; 的作用, 最后再改回去。
CREATE PROCEDURE select_emps()
BEGIN
	SELECT * FROM emps;
END $
DELIMITER ;

 CALL select_emps;
 
SELECT * FROM emps;


DELIMITER $
CREATE PROCEDURE avg_employee_salary()
BEGIN
  SELECT AVG(salary) FROM emps;

END $
DELIMITER ;

CALL avg_employee_salary;

-- 有返回的存储过程
DELIMITER $
CREATE PROCEDURE show_max_salary( OUT MaxSalary DOUBLE)
BEGIN
	SELECT MAX(salary) INTO MaxSalary FROM emps;
END $
DELIMITER ;

CALL show_max_salary(@MaxSalary);

SELECT @MaxSalary;

-- 有输入的存储过程
DELIMITER $
CREATE PROCEDURE show_someone_salary(IN ename VARCHAR(20))
BEGIN
		SELECT last_name , salary FROM emps WHERE last_name = ename;
END $
DELIMITER $

DESC emps;

SELECT * FROM emps WHERE last_name = 'King';
-- 调用方法1
CALL show_someone_salary('King');
-- 调用方法2
SET @ename := 'King';
CALL show_someone_salary(@ename);

-- 有IN 有OUT 的存储过程

DELIMITER $
CREATE PROCEDURE show_someone_salary2(IN ename VARCHAR(20) , OUT esalary DOUBLE(10,2))
BEGIN
	SELECT salary INTO esalary FROM emps WHERE last_name = ename;
END $
DELIMITER ;

SET @ename2 = 'Chen';
CALL show_someone_salary2(@ename2 , @esalary);
SELECT @esalary;

-- 带INOUT 的

SELECT * FROM emps;


DELIMITER $ --  插入ename 的领导
CREATE PROCEDURE show_mgr_name(INOUT ename VARCHAR(20))
BEGIN

		SELECT last_name INTO ename FROM emps WHERE employee_id = 
					(SELECT manager_id FROM emps WHERE last_name = ename);
 END $
 DELMITER ;
 
 SET @ename = 'Chen';
 CALL show_mgr_name( @ename);
 SELECT @ename;
 