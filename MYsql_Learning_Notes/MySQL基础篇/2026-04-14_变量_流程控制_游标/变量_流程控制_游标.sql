
-- 1. 变量： 系统变量（全局系统变量 GLOBAL ， 会话系统变量SESSION） VS 用户自定义变量

-- 查看系统变量
 -- 全局系统变量
SHOW GLOBAL VARIABLES;
 -- 会话系统变量
SHOW SESSION VARIABLES;

-- 默认是会话系统变量即SESSION
SHOW VARIABLES;
 
 -- 查看满足条件的部分全局系统变量
SHOW  GLOBAL VARIABLES LIKE 'max_join_%';
 
 -- 查看满足条件的部分会话系统变量
 SHOW SESSION VARIABLES LIKE 'character_%';
 
 
 -- 查看指定的全局系统变量
 SELECT @@GLOBAL.max_join_size;
 
 
 -- 查看指定的会话系统变量
 SELECT @@SESSION.character_set_client;
 
 -- 或者
 SELECT @@character_set_client; -- 先去全局系统变量里寻找，再去会话系统变量里寻找
 
 
 -- 修改系统变量的值
 -- 1. 修改Mysql配置文件my.ini （该方法需要重启Mysql服务）
 
 -- 2.在Mysql运行期间，使用set命令重新设置系统变量的值
 
-- 方式1 .
		SELECT @@GLOBAL.max_CONNECTIONS;
		SET @@GLOBAL.max_connections = 161;
		

-- 方式2
		SET GLOBAL max_connections = 162;
		
 
 -- 修改某个会话变量的值
	SET @@SESSION.CHARACTER_set_client = 'gbk';

	SET SESSION CHARACTER_set_client = 'utf8';
	
	
	
	
	-- ----------------------------------------------用户变量-----------------------
	
	CREATE DATABASE dbtest_04_14;
	USE dbtest_04_14;
	
	CREATE TABLE employee 
	AS
	SELECT * FROM atguigudb.employees;
	
	CREATE TABLE departments 
	AS
	SELECT * FROM atguigudb.departments;
	
	SELECT * FROM employee;
	SELECT * FROM departments;
	
	
	/* 用户变量： 会话用户变量 ， 局部变量
		
			会话用户变量： 作用域和会话变量一样， 只对当前连接会话有效
			局部变量：只在BEGIN 和END 语句块中生效，局部变量只能用在存储过程和函数中使用
			*/
		-- 会话用户变量
			-- 变量的定义
			 -- 方式1
			SET @name1 = 'maaaa';
			SET @email := 'maaaa123';
			-- 方式2
				
				SELECT @emp_name := first_name FROM employee WHERE employee_id = 101;
				SELECT last_name INTO @emp_name2 FROM employee WHERE employee_id = 101;
				SELECT @count := COUNT(*) FROM employee;
				
				SELECT @emp_name , @emp_name2 , @count;
	
	
	-- 局部用户变量
	/*
	定义：可以使用
	DECLARE 语句定义一个局部变量
	作用域：仅仅在定义它的 BEGIN ... END 中有效
	位置：只能放在 BEGIN ... END 中，而且只能放在第一句
	
	*/
	
	-- 定义 ， 使用 
			-- 声明局部变量，并分别赋值为employees表中employee_id为102的last_name和salary
				USE dbtest_04_14;
			
			CREATE PROCEDURE set_value()
			BEGIN
				DECLARE emp_lastName VARCHAR(25); -- 定义局部变量
				DECLARE emp_salary DOUBLE(10,2);
				
				SELECT last_name , salary INTO emp_lastName, emp_salary 
				FROM employee
				WHERE employee_id = 102;
				
				SELECT emp_lastName , emp_salary; -- 查询局部变量不需要@前缀，只有会话用户变量才需要@
			END ;
			CALL set_value();
			
			
			
			-- 声明两个变量，求和并且打印 ， 分别使用会话用户变量和局部变量
			-- 1.
			CREATE PROCEDURE add_value()
			BEGIN
				DECLARE num1 , num2 INT DEFAULT 1;
				DECLARE sum INT ;
				SET sum = num1 + num2 ;
				
				SELECT sum;
			END;
			
			CALL add_value();
			
			-- 2.
				
			SET @num1 := 1;
			SET @num2 := 2;
			SET @sum := @num1 + @num2;
			
			SELECT @sum;
			
			
			-- 创建存储过程“different_salary”查询某员工和他领导的薪资差距，并用IN参数emp_id接收员工id，用OUT参数dif_salary输出薪资差距结果。
	
	
	CREATE PROCEDURE different_salary(  IN emp_id INT , OUT dif_salary DOUBLE  )
	BEGIN
		DECLARE mgr_id INT;
		DECLARE mgr_salary DOUBLE(10,2);
		DECLARE emp_salary DOUBLE(10,2);
		
		
		
		-- 先查这个人的领导id 放入 mgr_id
		SELECT manager_id INTO mgr_id FROM employee WHERE employee_id = emp_id;
		-- 再查这个人的工资放入emp_salary
		SELECT salary INTO emp_salary FROM employee WHERE employee_id = emp_id;
		-- 再用mgr_id 查询领导的工资放mgr_salary
		SELECT salary INTO mgr_salary FROM employee WHERE employee_id = mgr_id;
		
		SET dif_salary = mgr_salary - emp_salary;
		
	END;
	
	
	SELECT  employee_id INTO @emp_id FROM employee WHERE last_name = 'Chen';
	
  CALL different_salary(@emp_id,@dif_emp_mgr_salary);
	 
	SELECT @dif_emp_mgr_salary;
	 