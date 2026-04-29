
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
		
			会话用户变量： 作用域只对当前连接会话有效
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
	 
	 
	 
	 
	 -- ------ 条件和处理程序
	-- 定义条件是事先定义程序执行过程可能遇到的问题
	-- 处理程序就是遇到了问题时候采取的措施，比如存储过程出错
	
	
	-- DECLARE 错误名称 CONDITION FOR 错误码（或错误条件）；
	
	-- MySQL_error_code 和 sqlstate_value 都可以表示MySQL的错误
	-- MySQL_error_code是数值类型错误代码。
	-- sqlstate_value是长度为5的字符串类型错误代码。
	
	--  在ERROR 1418 (HY000)中，1418是MySQL_error_code，'HY000'是sqlstate_value。
		
			-- 定义条件 -- 使用Mysql_error_code
			DECLARE Field_Not_Be_NULL CONDITION FOR 1048;
			-- 使用 salstate_value
			DECLARE Field_Not_Be_NULL CONDITION FOR SQLSTATE '23000';
			
	 
	 
	--  定义"ERROR 1148(42000)"错误，名称为command_not_allowed。
		DECLARE command_not_allowd CONDITION FOR 1148;
		DECLARE command_not_allowd CONDITION FOR SQLSTATE '42000';
		
	 
	 
	 
	 -- 处理程序
	 -- DECLARE 处理方式 HANDLER FOR 错误类型 处理语句
	 
	 -- 处理方式，就是遇到错误后怎么办
	 /*		
				continue 继续执行
				exit 退出
				UNDO 遇到错误后撤回之前的操作
	 */
	 
	 
	-- 错误类型，就是错误代码是什么格式的
	/*
			SQLSTATE '字符型错误码' 就是上面说的长度为5的字符串型的错误代码
			mysql_error_code 就是上面说的数值类型的错误代码
			错误名称  就是上面说的自定义的错误名称
			
			SQLWARNING 就是匹配以01 开头的 字符型的错误代码
			NOT FOUND 就是匹配以02开头的字符型错误代码
			SQLEXCEPTION 就是匹配没被SQLWARRING 和  NOTFOUND捕获的字符型错误代码
	*/
	
		
	 -- 方法1：捕获sqlstate_value 字符型错误代码
	DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET @info = 'NO_SUCH_TABLE';
	 -- 方法2：捕获mysql_error_value 数字型错误代码
	DECLARE CONTINUE HANDLER FOR 1146 SET @info = 'NO_SUCH_TABLE';
	 -- 方法3：先定义条件，再调用
	DECLARE no_such_table CONDITION FOR 1146;
	DECLARE CONTINUE HANDLER FOR NO_SUCH_TABLE SET @info = 'NO_SUCH_TABLE';
	 -- 方法4：使用SQLWARNING
	DECLARE EXIT HANDLER FOR SQLWARNING SET @info = 'ERROR';
	 -- 方法5：使用NOT FOUND
	DECLARE EXIT HANDLER FOR NOT FOUND SET @info = 'NO_SUCH_TABLE';
	 -- 方法6：使用SQLEXCEPTION
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SET @info = 'ERROR';
		 
	 
	 
	 -- 案例实践
-- 	 在存储过程中，定义处理程序，捕获sqlstate_value值，当遇到MySQL_error_code值为1048时，执行
-- CONTINUE操作，并且将@proc_value的值设置为-1。
-- 	
		USE dbtest_04_14;
		
		DESC employee;

	 
	 CREATE PROCEDURE UpdateDataNoCondition()
		BEGIN
				#定义处理程序
				DECLARE CONTINUE HANDLER FOR 1048 SET @proc_value := -1;
				
				SET @x = 1;
				UPDATE employee SET email = NULL WHERE last_name = 'Abel';
				SET @x = 2;
				UPDATE employee SET email = 'aabbel' WHERE last_name = 'Abel';
				SET @x = 3;
		END;
		
		-- 成功调用，再没定义处理程序之前这个存储过程是有错误的
		CALL UpdateDataNoCondition();
		
		-- 查看错误代码
		--     3          -1
		SELECT @x , @proc_value;
		-- 再没有处理程序之前x应该是 1 ，因为处理方式选的是continue 所以继续执行.countries
	 
	 
	 -- 在存储过程中，定义处理程序，捕获sqlstate_value值，当遇到sqlstate_value值为23000时，执行EXIT操作，并且将@proc_value的值设置为-1
	 
	 DESC departments;
	 
	 ALTER TABLE departments
	 ADD CONSTRAINT uk_dept_id UNIQUE(department_id);
	 
	 SET @proc_value := 0;
	 
	 
	 CREATE PROCEDURE InsertDataWithCondition()
	 BEGIN
				
				-- DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET @proc_value := -1;
				DECLARE  DUPLICATE_entry CONDITION FOR SQLSTATE '23000';
				DECLARE EXIT HANDLER FOR  DUPLICATE_entry SET @proc_value := -1;
				
				SET @x = 1;
				INSERT INTO departments(department_name) VALUES('测试');
				SET @x = 2;
				INSERT INTO departments(department_name) VALUES('测试');
				SET @x = 3;
	 END;
	 
	 CALL InsertDataWithCondition();
	 
	 SELECT @x , @proc_value;
	 
	 
	 
	 --  -------------- 流程控制 ---------------------------------
	 
	 -- 分支结构 if
			/*
			IF 表达式1 THEN 操作1
			[ELSEIF 表达式2 THEN 操作2]……
			[ELSE 操作N]
			END IF
			
			1. 不同的表达式对应不同的操作 2.使用在BEGIN END 之中
			*/
			
			/*
			声明存储过程“update_salary_by_eid1”，定义IN参数emp_id，输入员工编号。判断该员工薪资如果低于8000元并且入职时间超过5年，就涨薪500元；否则就不变。
			*/
	 
	 DESC employee;
	 
	 
	 CREATE PROCEDURE update_salary_by_eid1(IN emp_id INT)
	 BEGIN
			
			DECLARE emp_salary DOUBLE;
			DECLARE hire_year DOUBLE;
			
			SELECT salary INTO emp_salary FROM employee WHERE employee_id = emp_id;
			SELECT DATEDIFF(CURDATE(),hire_date)/365 INTO hire_year FROM employee WHERE employee_id = emp_id;
			
			IF emp_salary < 8000 AND hire_year > 5
					THEN UPDATE employee SET salary = salary + 500 WHERE employee_id = emp_id;
			END IF;
			
	 END;
	 
	 DROP PROCEDURE update_salary_by_eid1;
	 
	 
	 SELECT * FROM employee WHERE salary < 8000 AND DATEDIFF(CURDATE(),hire_date)/365 > 5;
	 
	 CALL update_salary_by_eid1(104);
	 
	 
	 /*
	 
	 声明存储过程“update_salary_by_eid2”，定义IN参数emp_id，输入员工编号。判断该员工
	薪资如果低于9000元并且入职时间超过5年，就涨薪500元；否则就涨薪100元。
	 */
	 
	 
	 	CREATE PROCEDURE update_salary_by_eid2(IN emp_id INT)
	 BEGIN
			
			DECLARE emp_salary DOUBLE;
			DECLARE hire_year DOUBLE;
			
			SELECT salary INTO emp_salary FROM employee WHERE employee_id = emp_id;
			SELECT DATEDIFF(CURDATE(),hire_date)/365 INTO hire_year FROM employee WHERE employee_id = emp_id;
			
			IF emp_salary < 9000 AND hire_year > 5
					THEN UPDATE employee SET salary = salary + 500 WHERE employee_id = emp_id;
			ELSE
					UPDATE employee SET salary = salary + 100 WHERE employee_id = emp_id;
			END IF;
			
	 END;
	 	
		SELECT * FROM employee WHERE salary > 9000 AND DATEDIFF(CURDATE(),hire_date)/365 > 5;
	 CALL update_salary_by_eid2(114); -- 涨一百


/*


		声明存储过程“update_salary_by_eid3”，定义IN参数emp_id，输入员工编号。判断该员工
		薪资如果低于9000元，就更新薪资为9000元；薪资如果大于等于9000元且低于10000的，但是奖金
		比例为NULL的，就更新奖金比例为0.01；其他的涨薪100元。
*/

	DESC employee;
	

   CREATE PROCEDURE update_salary_by_eid3(IN emp_id INT)
	 BEGIN
			
			DECLARE emp_salary DOUBLE;
			DECLARE hire_year DOUBLE;
			DECLARE bonus DOUBLE;
			
			SELECT salary INTO emp_salary FROM employee WHERE employee_id = emp_id;
			SELECT DATEDIFF(CURDATE(),hire_date)/365 INTO hire_year FROM employee WHERE employee_id = emp_id;
			SELECT commission_pct INTO bonus FROM employee WHERE employee_id = emp_id;
			
			IF emp_salary < 9000 
					THEN UPDATE employee SET salary = 9000 WHERE employee_id = emp_id;
					
			ELSEIF  emp_salary < 10000 AND  bonus IS NULL
					THEN UPDATE employee SET commission_pct = 0.01 WHERE employee_id = emp_id;
			
			ELSE
					UPDATE employee SET salary = salary + 100  WHERE employee_id = emp_id;
			END IF;
			
	 END;
	 
	 
	 
	 
	 
	 
	 
	 -- 分支结构 case
	 
	 
	 /*
	 情况1：类似于SWITCH
		CASE 表达式
		WHEN 值1 THEN 结果1或语句1(如果是语句，需要加分号) 
		WHEN 值2 THEN 结果2或语句2(如果是语句，需要加分号)
		...
		ELSE 结果n或语句n(如果是语句，需要加分号)
		END [case]（如果是放在begin end中需要加上case，如果放在select后面不需要）
	 
		
	 情况2：类似于多重if
		CASE 
		WHEN 条件1 THEN 结果1或语句1(如果是语句，需要加分号) 
		WHEN 条件2 THEN 结果2或语句2(如果是语句，需要加分号)
		...
		ELSE 结果n或语句n(如果是语句，需要加分号)
		END [case]（如果是放在begin end中需要加上case，如果放在select后面不需要）
	 
	 */
	 
	 /*
	 
	  声明存储过程“update_salary_by_eid4”，定义IN参数emp_id，输入员工编号。判断该员工
		薪资如果低于9000元，就更新薪资为9000元；薪资大于等于9000元且低于10000的，但是奖金比例
		为NULL的，就更新奖金比例为0.01；其他的涨薪100元
	 */
	 
	 CREATE PROCEDURE update_salary_by_eid4(IN emp_id INT)
	 BEGIN
			
			DECLARE emp_salary DOUBLE;
			DECLARE hire_year DOUBLE;
			DECLARE bonus DOUBLE;
			
			SELECT salary INTO emp_salary FROM employee WHERE employee_id = emp_id;
			SELECT DATEDIFF(CURDATE(),hire_date)/365 INTO hire_year FROM employee WHERE employee_id = emp_id;
			SELECT commission_pct INTO bonus FROM employee WHERE employee_id = emp_id;
			
			CASE
			WHEN emp_salary < 9000 
									THEN UPDATE employee SET salary = 9000 WHERE employee_id = emp_id ;
			WHEN emp_salary < 10000 AND bonus IS NULL
									THEN UPDATE employee SET commission_pct = 0.01 WHERE employee_id = emp_id ;
			ELSE
											 UPDATE employee SET salary = salary + 100 WHERE employee_id = emp_id ;
											 
			 END CASE;
			 
	 END;
	 
	 /*
	 
			声明存储过程update_salary_by_eid5，定义IN参数emp_id，输入员工编号。判断该员工的
			入职年限，如果是0年，薪资涨50；如果是1年，薪资涨100；如果是2年，薪资涨200；如果是3年，
			薪资涨300；如果是4年，薪资涨400；其他的涨薪500。
	 
	 */
	 
	 CREATE PROCEDURE update_salary_by_eid5(IN emp_id INT)
	 BEGIN
			
			DECLARE emp_salary DOUBLE;
			DECLARE hire_year DOUBLE;
			DECLARE bonus DOUBLE;
			
			SELECT salary INTO emp_salary FROM employee WHERE employee_id = emp_id;
			SELECT ROUND(DATEDIFF(CURDATE(),hire_date)/365 )INTO hire_year FROM employee WHERE employee_id = emp_id;
			SELECT commission_pct INTO bonus FROM employee WHERE employee_id = emp_id;
			
			CASE hire_year
			WHEN 0
							THEN UPDATE employee SET salary = salary + 50 WHERE employee_id = emp_id ;
			WHEN 1
							THEN UPDATE employee SET salary = salary + 100 WHERE employee_id = emp_id ;
			WHEN 2
						 THEN	UPDATE employee SET salary = salary + 100 WHERE employee_id = emp_id ;
			ELSE
						 UPDATE employee SET salary = salary + 500 WHERE employee_id = emp_id ;
			 END CASE;
			 
	 END;
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 -- 循环结构 loop while REPEAT
	 
	 
	 /*
	 
			循环结构 loop
			[loop_label:] LOOP
			循环执行的语句
			END LOOP [loop_label]
				
			loop_label表示LOOP语句的标注名称，该参数可以省略。
			
	 */
	 
	
	 
	 /*
	  当市场环境变好时，公司为了奖励大家，决定给大家涨工资。声明存储过程
		“update_salary_loop()”，声明OUT参数num，输出循环次数。存储过程中实现循环给大家涨薪，薪资涨为
		原来的1.1倍。直到全公司的平均薪资达到12000结束。并统计循环次数。
	 
	 
	 */
	 
	 CREATE PROCEDURE update_salary_loop( OUT num INT )
	 BEGIN
	 
		 DECLARE count INT DEFAULT 0;
		 DECLARE avg_sal DOUBLE ;
		 
		 SELECT AVG(salary) INTO avg_sal FROM employee;
		 
		 Raise_loop: LOOP
				 IF avg_sal >= 12000
					THEN LEAVE Raise_loop; 
				 END IF;
				
					
				 UPDATE employee SET salary = salary * 1.1 	;
				 SET count = count + 1;
				 
				 SELECT AVG(salary) INTO avg_sal FROM employee;

		END LOOP Raise_loop;

		SET num = count;		
	 
	 END ;
	 
	  
	 
	 CALL update_salary_loop(@num);
	 SELECT AVG(salary) , @num FROM employee;
	 
	 
	 /*
		循环结构while
		
		[while_label:] WHILE 循环条件  DO
		循环体
		END WHILE [while_label];
		
	 
	 while_label为WHILE语句的标注名称；如果循环条件结果为真，WHILE语句内的语句或语句群被执行，直
		至循环条件为假，退出循环
	 */
	 
	 /*
	 市场环境不好时，公司为了渡过难关，决定暂时降低大家的薪资。声明存储过程
	“update_salary_while()”，声明OUT参数num，输出循环次数。存储过程中实现循环给大家降薪，薪资降
	为原来的90%。直到全公司的平均薪资达到5000结束。并统计循环次数。
	 */
	 
	 
	  CREATE PROCEDURE update_salary_while( OUT num INT )
	 BEGIN
	 
		 DECLARE count INT DEFAULT 0;
		 DECLARE avg_sal DOUBLE ;
		 
		 SELECT AVG(salary) INTO avg_sal FROM employee;
		
		WHILE avg_sal >= 5000 DO
				
				UPDATE employee SET salary = salary * 0.9;
				SET count = count +1;
						
				SELECT AVG(salary) INTO avg_sal FROM employee;
		END WHILE;
		
		SET num = count;		
	 
	 END ;
	 
	  
	 
	 CALL update_salary_while(@num);
	 SELECT AVG(salary) , @num FROM employee;
	 
	 
	 
	 
	 
	 
	 /*
		循环结构之REPEAT
		REPEAT语句创建一个带条件判断的循环过程。与WHILE循环不同的是，REPEAT 循环首先会执行一次循
		环，然后在 UNTIL 中进行表达式的判断，如果满足条件就退出，即 END REPEAT；如果条件不满足，则会
		就继续执行循环，直到满足退出条件为止。
		
		类似 do while
		
		[repeat_label:] REPEAT
		循环体的语句
		UNTIL 结束循环的条件表达式
		END REPEAT [repeat_label]
	 
	 */
	 

	 /*
	 	 当市场环境变好时，公司为了奖励大家，决定给大家涨工资。声明存储过程
		“update_salary_repeat()”，声明OUT参数num，输出循环次数。存储过程中实现循环给大家涨薪，薪资涨
		为原来的1.15倍。直到全公司的平均薪资达到13000结束。并统计循环次数
			
	 
	 */
	 
	 
	 
	 	  CREATE PROCEDURE update_salary_REPEAT( OUT num INT )
	 BEGIN
	 
		 DECLARE count INT DEFAULT 0;
		 DECLARE avg_sal DOUBLE ;
		 
		 SELECT AVG(salary) INTO avg_sal FROM employee;
			
			REPEAT
					UPDATE employee SET salary = salary * 1.15;
					SET count = count +1;
					
					SELECT AVG(salary) INTO avg_sal FROM employee;

			UNTIL avg_sal >= 13000 
			END REPEAT;



		SET num = count;		
	 
	 END ;
	 
	  
	 
	 CALL update_salary_REPEAT(@num);
	 SELECT AVG(salary) , @num FROM employee;
	 
	 
	 /*
	 这三种循环都可以省略名称，但如果循环中添加了循环控制语句（LEAVE或ITERATE）则必须添加名
称。 2、 LOOP：一般用于实现简单的"死"循环 WHILE：先判断后执行 REPEAT：先执行后判断，无条件
至少执行一次
	 
	 
	 */
	 
	 
	 
	 
	 
	 
	 
	 
	 -- 跳转语句 LEAVE ITERATE
	 
	 /*
	  LEAVE 既可以离开循环 也可以离开BEGIN.....AND
		近似于Break；
		
	 */
	 /*
	 LEAVE BGEIN
	 
	 创建存储过程 “leave_begin()”，声明INT类型的IN参数num。给BEGIN...END加标记名，并在
	BEGIN...END中使用IF语句判断num参数的值。
	如果num<=0，则使用LEAVE语句退出BEGIN...END；
	如果num=1，则查询“employees”表的平均薪资；
	如果num=2，则查询“employees”表的最低薪资；
	如果num>2，则查询“employees”表的最高薪资。
	 */
	 
	 CREATE PROCEDURE leave_begin( IN num INT )
	  begin_lable:BEGIN
			
			IF num < 0 THEN
				  SET @x = 0;
					LEAVE begin_lable;
					
					 SET @x = 1;
					 SELECT AVG(salary) FROM employee;
			ELSEIF num = 2 THEN
					 SET @x = 2;
					 SELECT MAX(salary) FROM employee;
			END IF;
	 END;
	 
	 DROP PROCEDURE leave_begin;
	 CALL leave_begin(-1)
	 SELECT @x;
	
	 
	 
	 /*
	 
	 当市场环境不好时，公司为了渡过难关，决定暂时降低大家的薪资。声明存储过程“leave_while()”，声明
	OUT参数num，输出循环次数，存储过程中使用WHILE循环给大家降低薪资为原来薪资的90%，直到全公
	司的平均薪资小于等于10000，并统计循环次数。
		 
	 
	 */
	 
	 
	 
	 	  CREATE PROCEDURE leave_while( OUT num INT )
	 BEGIN
	 
				 DECLARE count INT DEFAULT 0;
				 DECLARE avg_sal DOUBLE ;
				 
				 SELECT AVG(salary) INTO avg_sal FROM employee;
				
				while_lable:WHILE TRUE DO
				
				
						IF avg_sal < 10000 THEN
							LEAVE while_lable;
						END IF;
						
						
						
						
						UPDATE employee SET salary = salary * 0.9;
						SET count = count +1;
						SELECT AVG(salary) INTO avg_sal FROM employee;
				
				END WHILE;
				
				SET num = count;		
	 
	 END ;
	 

	 CALL leave_while(@num);
	 SELECT @num;
	 
	 
	 /*
	 
	 跳转语句ITERATE
	 
	 只能用在循环语句（LOOP、REPEAT和WHILE语句）内，表示重新开始循环，将执行顺序
	转到语句段开头处。如果你有面向过程的编程语言的使用经验，可以把 ITERATE 理解为 continue，意
	思为“再次循环”。
	 
	 */
	 
	 /*
	 
	  定义局部变量num，初始值为0。循环结构中执行num + 1操作。
		如果num < 10，则继续执行循环；
		如果num > 15，则退出循环结构
	 
	 */
	 
	 CREATE PROCEDURE test_ITERATE()
	 BEGIN
				DECLARE num INT DEFAULT 0;
				
				test_loop: LOOP
				
						SET num = num+1;
						SET @num1 = @num1 +1;
					IF  num <= 10 THEN
				
						ITERATE test_loop;
          END IF;


					IF num > 15 THEN
						LEAVE test_loop; 
					END IF; 
					
					SELECT '大于十次但是小于十五次，打印这条消息';
				END LOOP test_loop;

			
	 END;
	 
	 
	 DROP PROCEDURE test_ITERATE;
	 SET @num1 = 0;
	 
	 CALL test_ITERATE();
	 SELECT @num1;
	 
	 
	 
	 
	 -- -----------------------------  游标  ------------------------------
	 
	 /*
			当我执行一条SELECT和UPDATE的时候，数据库是一次性找到所有符合条件的数据，然后批量处理，虽然也可以使用WHERE或者HAVING 或者LIMIT来限定结果返回一条指令，但是这是只有一条数据的结果集。而游标提供了一种更灵活的数据行指针，可以定位到表中的某一行数据
	 */
	 /*
	 
		使用步骤：
		声明游标
			DECLARE cursor_name CURSOR FOR select_statement; 
		打开游标	
			OPEN cursor_name
		使用游标 ： 意思是使用当前游标来读取当前行，并将数据保存到自定义变量中，返回的数据必须和变量一一对应，游标自动指向下一行，使用到的自定义变量要在游标定义之前
			FETCH cursor_name INTO var_name [, var_name] ...
			关闭游标： 如果不及时关闭，游标会一直保存到存储过程结束，占用系统资源
				CLOSE cursor_name;
				
	 */
	 
	 
	 
	 
	 /*
	 创建存储过程“get_count_by_limit_total_salary()”，声明IN参数 limit_total_salary，DOUBLE类型；声明
		OUT参数total_count，INT类型。函数的功能可以实现累加薪资最高的几个员工的薪资值，直到薪资总和
		达到limit_total_salary参数的值，返回累加的人数给total_count。
	*/
	 
	CREATE PROCEDURE  get_count_by_limit_total_salary( IN  limit_total_salary DOUBLE , OUT total_count INT)
	BEGIN
			DECLARE emp_sal DOUBLE;
			DECLARE sum_sal DOUBLE DEFAULT 0;
			DECLARE emp_count INT DEFAULT 0;
			
			-- 定义游标
			
			DECLARE cursor_sal CURSOR FOR
			SELECT salary FROM employee ORDER BY salary DESC;
			
			-- 打开游标:
			OPEN cursor_sal;
			
			-- 使用游标
			
			WHILE sum_sal <  limit_total_salary DO
			
					FETCH cursor_sal INTO emp_sal ; -- 将当前行的salary 放入emp_sal 自动指向下一行
					SET sum_sal  = sum_sal + emp_sal;
					SET emp_count = emp_count +1;
	
		END WHILE;

			
			SELECT sum_sal;
			SET total_count = emp_count; 
		
	END;
	 DROP PROCEDURE get_count_by_limit_total_salary;
	 CALL get_count_by_limit_total_salary(200000 , @total_count);
	 
	 SELECT @total_count;
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 