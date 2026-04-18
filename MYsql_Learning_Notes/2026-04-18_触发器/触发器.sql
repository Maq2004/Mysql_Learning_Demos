

/*
	
	触发器是通过时间来触发某个操作，这些事件包括 插入 ，删除 ，修改事件。事件就是指的是用户的动作或者出发某种行为，当数据库执行这些语句的时候，就相当于事件的发生，会自动激活触发器执行相应的操作

*/

/*
	语法：
	CREATE TRIGGER 触发器名称 
	{BEFORE|AFTER} {INSERT|UPDATE|DELETE} ON 表名 
	FOR EACH ROW 
	触发器执行的语句块;
		表名：表示触发器监控的对象。
	BEFORE|AFTER ：表示触发的时间。
	BEFORE 表示在事件之前触发；
	AFTER 表示在事件之后触发。
	
	
	INSERT|UPDATE|DELETE ：表示触发的事件。
	INSERT 表示插入记录时触发；
	UPDATE 表示更新记录时触发；
	DELETE 表示删除记录时触发。
	触发器执行的语句块：可以是单条SQL语句，也可以是由BEGIN…END结构组成的复合语句块。
	
*/

CREATE DATABASE dbtest_04_18;

USE dbtest_04_18;



CREATE TABLE test_trigger (
	id INT PRIMARY KEY AUTO_INCREMENT,
	t_note VARCHAR(30)
);
CREATE TABLE test_trigger_log (
	id INT PRIMARY KEY AUTO_INCREMENT,
	t_log VARCHAR(30)
);




/*

创建名称为before_insert的触发器，向test_trigger数据表插入数据之前，向
test_trigger_log数据表中插入before_insert的日志信息。
*/


CREATE TRIGGER before_insert 
BEFORE INSERT ON test_trigger
FOR EACH ROW
BEGIN
	INSERT INTO test_trigger_log(t_log)
	VALUES('before INSERT ...');
END;

SELECT * FROM test_trigger;
SELECT * FROM test_trigger_log;

INSERT INTO test_trigger(t_note)
VALUES('今天学习触发器');


/*

创建名称为after_insert的触发器，向test_trigger数据表插入数据之后，向test_trigger_log数据表中插
入after_insert的日志信息。

*/

CREATE TRIGGER after_insert
AFTER INSERT ON test_trigger
FOR EACH ROW
BEGIN
	
	INSERT INTO test_trigger_log(t_log)
	VALUES('after INSERT');
	

END;


INSERT INTO test_trigger(t_note)
VALUES ( '测试after_insert' );



/*
	定义触发器“salary_check_trigger”，基于员工表“employees”的INSERT事件，在INSERT之前检查
	将要添加的新员工薪资是否大于他领导的薪资，如果大于领导薪资，则报sqlstate_value为'HY000'的错
	误，从而使得添加失败。

*/

CREATE TABLE emp
AS
SELECT employee_id , last_name ,salary , manager_id FROM atguigudb.employees;

SELECT * FROM emp;


CREATE TRIGGER salary_check_trigger
BEFORE INSERT ON emp
FOR EACH ROW
BEGIN
	
	DECLARE mgr_salary DOUBLE;
	
	-- 首先最起码要知道员工的领导id  NEW.manager_id ;
	-- 其次通过领导id的工号属性查询领导的salary
	
	SELECT salary  INTO mgr_salary FROM emp WHERE employee_id = NEW.manager_id;
	
	IF NEW.salary > mgr_salary THEN
			SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT = '薪资高于领导薪资错误';
	END IF;
END;

DROP TRIGGER  salary_check_trigger;

-- 插入失败，触发触发器
INSERT INTO emp 
VALUES( 300 , 'maaa' , 30000 , 103 );

SELECT * FROM emp;
-- 插入成功
INSERT INTO emp 
VALUES( 301 , 'maaa' , 3000 , 103 );


 -- 查看当前数据库中的所有触发器的定义
 SHOW TRIGGERS;
 -- 查看当前数据库中某个触发器的定义
 SHOW CREATE TRIGGER salary_check_trigger;
 --  删除触发器
DROP TRIGGER  salary_check_trigger;
	/*
	
	
		触发器的优点：
			1.触发器可以确保数据的完整性
			2.触发器可以帮助我们记录日志
			3.触发器可以对当前操作的合法性检查
			
		缺点：
			1.可读性极差
			2.相关数据表结构的变更会导致触发器出问题
			
		注意：
			如果从表被主表通过外键约束中的了ON UPDATE/DELETE CASCADE/SET NULL子句 修改了， 那么基于从表的触发器不会触发
			
	*/
	
	
	
	
	
	
	
	
	
	
	
	
	#1. 复制一张emps表的空表emps_back，只有表结构，不包含任何数据
	#2. 查询emps_back表中的数据
	#4. 验证触发器是否起作用
	#3. 创建触发器emps_insert_trigger，每当向emps表中添加一条记录时，同步将这条记录添加到emps_back表中
	
CREATE TABLE emp_back 
AS
SELECT * FROM emp ;

DELETE FROM emp_back;

SELECT * FROM emp_back;
DESC emp;

CREATE TRIGGER emp_insert_trigger
AFTER INSERT ON emp
FOR EACH ROW
BEGIN
/*
		INSERT INTO emp_back -- 如果先插入 employee_id 为303 的员工， 再插入employee_id 为 301 的员工， 那么这样写会把303插入两次
		SELECT * FROM emp  ORDER BY employee_id DESC LIMIT 0,1;
*/
		INSERT INTO emp_back
		VALUES(NEW.employee_id , NEW.last_name , NEW.salary , NEW.manager_id);
		
	
END;

DROP TRIGGER emp_insert_trigger;


INSERT INTO emp 
VALUES( 303, 'mbbb' , 2000 , 103 );

SELECT * FROM emp_back;
SELECT * FROM emp;

INSERT INTO emp 
VALUES( 302, 'mbbb' , 2000 , 103 );



/*

#1.复制一张emps表的空表emps_back1，只有表结构，不包含任何数据
#2. 查询emps_back1表中的数据
#4. 验证触发器是否起作用
#3. 创建触发器emps_del_trigger，每当向emps表中删除一条记录时，同步将删除的这条记录添加到
emps_back1表中
*/

CREATE TABLE emp_back1 
AS
SELECT * FROM emp WHERE 1 = 2;

SELECT * FROM emp_back1;

CREATE TRIGGER emp_del_trigger
AFTER DELETE ON emp
FOR EACH ROW
BEGIN
/*
		INSERT INTO emp_back -- 如果先插入 employee_id 为303 的员工， 再插入employee_id 为 301 的员工， 那么这样写会把303插入两次
		SELECT * FROM emp  ORDER BY employee_id DESC LIMIT 0,1;
*/
		INSERT INTO emp_back1
		VALUES(OLD.employee_id , OLD.last_name , OLD.salary , OLD.manager_id);
		
	
END;


DELETE FROM emp WHERE employee_id = 103;
SELECT * FROM emp_back1;
