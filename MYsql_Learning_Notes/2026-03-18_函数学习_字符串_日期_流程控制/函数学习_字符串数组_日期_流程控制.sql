-- 查询员工 last_name 的字符数和字节数（用 CHAR_LENGTH 和 LENGTH），并说明两者在中文姓名场景下可能有什么区别。

SELECT CHAR_LENGTH(last_name),LENGTH(last_name) FROM employees;

SELECT CHAR_LENGTH('maqian'),LENGTH('maqian'),CHAR_LENGTH('马谦'),LENGTH('马谦') FROM DUAL;

-- CHAR_LENGTH 和 LENGTH在查询英文字符串的情况下似乎是一样的，返回字符的个数
-- 而CHAR_LENGTH在查询中文状态下的返回值是我们看到的那样，而LENGTH则是因为底层的原因，返回的存储的字节数，一个中文汉字占据三个字节数在UTF8中

-- 把所有员工的 last_name 全部转成大写和小写，并用 CONCAT 拼接成 “原姓名 → 大写姓名 → 小写姓名” 格式。

SELECT
	UPPER( last_name ) AS '大写',
	LOWER( last_name ) AS '小写',
	CONCAT(
		last_name,'->',
		UPPER( last_name ),'->',
	LOWER( last_name )) 
FROM
	employees;

-- 查询员工 last_name 的前3个字符和后2个字符，并用 CONCAT 拼接成 “前缀-后缀” 格式。
SELECT CONCAT(LEFT(last_name,3),'-',RIGHT(last_name,2)) FROM employees;


-- 把 last_name 用 “*” 在左边填充到长度8，再用 “-” 在右边填充到长度10，写出SQL。
SELECT
	RPAD( LPAD( last_name, 8, '*' ), 10, '-' ) 
FROM
	employees;


-- 空格与TRIM高级用法
-- 对 email 字段做：
-- 去掉前后空格（TRIM）
-- 只去左边空格（LTRIM）
-- 只去右边空格（RTRIM）
-- 去掉所有 “@” 前后的空格（用 TRIM 的高级形式）

SELECT
	TRIM( email ),
	LTRIM( email ),
	RTRIM( email ),
	TRIM( '@' FROM email ) 
FROM
	employees;




-- 把所有员工的 last_name 中出现的字母 “a” 替换成 “*”，并在第2个位置插入 “【】” 两个字符（用 REPLACE 和 INSERT）。

SELECT INSERT
	( REPLACE ( last_name, 'a', '*' ), 2, 2, '【】' ) 
FROM
	employees;



-- 查询 last_name 中字母 “o” 第一次出现的位置（用 LOCATE、INSTR、POSITION 三种写法都写一遍），并返回找不到时的结果（0）。



SELECT LOCATE('o',last_name) FROM employees;

SELECT INSTR(last_name,'o') FROM employees;

SELECT POSITION('o' IN last_name) FROM employees;



-- 把 last_name重复3次，中间用 SPACE(2) 插入两个空格，写出SQL。


SELECT
REPEAT
		( CONCAT_WS( ' ', last_name, SPACE( 2 )), 3 ) 
	FROM
		employees;
		
		
SELECT REPEAT(CONCAT(last_name,SPACE(2)),3) FROM employees;


	

-- 用 STRCMP 比较 “King” 和 “king” 的大小，并把 last_name反转后显示（用 REVERSE）。


SELECT STRCMP('King','king') , REVERSE(last_name) FROM employees;

-- 查询员工信息，要求用字符串函数拼接成一句话：
-- “姓名: [大写last_name]，邮箱前缀: [email去掉@后部分]，长度: [字符数]”
-- （必须用到 UPPER、CONCAT_WS、SUBSTR 或 LOCATE、CHAR_LENGTH）

	SELECT
		CONCAT(
			'姓名：',
			UPPER( last_name ),
			' , 邮箱前缀:',
			LEFT(email,LOCATE('@',email)-1), -- 但是email没有@后缀部分，所以不用这样写，直接写email也是一样的。
			' , 长度:',
		LENGTH( last_name )) 
	FROM
		employees;



SELECT CURDATE(),CURTIME(),NOW(),UTC_DATE(),UTC_TIME() FROM DUAL;


-- UNIX_TIMESTAMP() 以UNIX时间戳的形式返回当前时间
-- FROM_UNIXTIME() 将UNIX时间戳转换为普通格式
		SELECT
			UNIX_TIMESTAMP(),		
			FROM_UNIXTIME(
			UNIX_TIMESTAMP()) ,
			UNIX_TIMESTAMP( '2026-12-04' ),
			UNIX_TIMESTAMP(CURTIME())
	
		FROM
			DUAL;

SELECT YEAR(NOW()) FROM DUAL;
-- DAYNAME() 判断当前时间是周几，但是返回的是英文
-- WEEKDAY() 判断当前时间是周几 ，注意，周一是零，周二是一，返回数字
-- QUARTER() 判断当前日期在第几季度，返回数字
-- WEEK() 判断当前时间是一年中的第几周，返回数字
-- DAYOFWEEK() 判断当前时间是周几，注意和WEEKDAY不同，这里周日是1，周一是2，返回数字
-- 
		SELECT
			DAYNAME(
			NOW()),
			WEEKDAY( '2026-03-18' ),
			QUARTER (NOW()),
			WEEK (NOW()),
			DAYOFWEEK(NOW()),
			
		FROM
			DUAL;



-- 返回指定日期中特定的部分，type指定返回的类型

SELECT EXTRACT(DAY FROM NOW()) FROM DUAL;


SELECT TIME_TO_SEC(NOW()) , SEC_TO_TIME(TIME_TO_SEC(NOW())) FROM DUAL;

-- DATA_ADD( datatime, INTERVAL  expr type ) 返回与给定日期时间相差时间的日期时间
SELECT DATE_ADD(NOW(),INTERVAL -1 YEAR) FROM DUAL;
SELECT DATE_ADD(NOW(),INTERVAL '1_1' YEAR_MONTH) FROM DUAL;

SELECT LAST_DAY(NOW()) FROM DUAL;
SELECT DATEDIFF('2026-10-1',NOW()) FROM DUAL;
SELECT TIMEDIFF('2026-10-1 18:30:10',NOW()) FROM DUAL;












-- 1. 当前系统日期时间 + 时间戳转换
SELECT 
    CURDATE() AS '当前日期(年月日)',
    CURTIME() AS '当前时间(时分秒)',
    NOW() AS '当前日期时间',
    FROM_UNIXTIME(UNIX_TIMESTAMP(NOW())) AS '时间戳转回日期' 
FROM DUAL;

-- 2. hire_date 的时间戳转换
SELECT 
    hire_date,
    UNIX_TIMESTAMP(hire_date) AS 'UNIX时间戳',
    FROM_UNIXTIME(UNIX_TIMESTAMP(hire_date)) AS '转回日期'
FROM employees;

-- 3. 入职天数 + 年数 + 满1年筛选
SELECT 
    last_name,
    DATEDIFF(NOW(), hire_date) AS '入职天数',
    TIMESTAMPDIFF(YEAR, hire_date, NOW()) AS '入职年数'
FROM employees
WHERE DATE_ADD(hire_date, INTERVAL 1 YEAR) < NOW();

-- 4. DATE_ADD / DATE_SUB
SELECT 
    hire_date AS '入职日期',
    DATE_ADD(hire_date, INTERVAL 1 YEAR) AS '入职满1年后',
    DATE_SUB(hire_date, INTERVAL 30 DAY) AS '入职前30天'
FROM employees;

-- 5. TIMEDIFF + ADDTIME（正确写法）
SELECT 
    TIMEDIFF(NOW(), '2026-03-17 09:00:00') AS '与指定时间差',
    ADDTIME(NOW(), '01:30:00') AS '当前时间+1小时30分'
FROM DUAL;

-- 6. DATE_FORMAT（正确格式符）
SELECT 
    hire_date,
    DATE_FORMAT(hire_date, '%Y年%m月%d日 %W') AS '中文格式（星期三）'
FROM employees;

-- 7. STR_TO_DATE（两种格式）
SELECT 
    STR_TO_DATE('2026-03-17', '%Y-%m-%d') AS '标准格式解析',
    STR_TO_DATE('2026年03月17日', '%Y年%m月%d日') AS '中文格式解析'
FROM DUAL;

-- 8. GET_FORMAT
SELECT 
    DATE_FORMAT(NOW(), GET_FORMAT(DATE, 'USA')) AS '美国格式日期'
FROM DUAL;

-- 9. 入职满整年后格式化
SELECT 
    DATE_FORMAT(
        DATE_ADD(hire_date, INTERVAL 1 YEAR), 
        '%Y-%m-%d（星期%W）'
    ) AS '满整年后日期'
FROM employees;

-- 10. 综合拼接（最终推荐版）
SELECT CONCAT(
    '姓名：', last_name, 
    '，入职日期：', DATE_FORMAT(hire_date, '%Y年%m月%d日 %W'),
    '，入职天数：', DATEDIFF(NOW(), hire_date), '天',
    '，入职年数：', TIMESTAMPDIFF(YEAR, hire_date, NOW()), '年'
) AS '员工入职总结'
FROM employees;

-- 
-- 查询部门号为 10,20, 30 的员工信息, 若部门号为 10, 则打印其工资的 1.1 倍, 20 号部门, 则打印其
-- 工资的 1.2 倍, 30 号部门打印其工资的 1.3 倍数。





		SELECT
			last_name,
			department_id,salary,
			CASE department_id 
				WHEN 10 THEN salary * 1.1 
				WHEN 20 THEN salary * 1.2 
				WHEN 30 THEN salary * 1.3 
				ELSE salary
			 END 'REVISE_SALARY'
			FROM
				employees 
			WHERE department_id IN (10,20,30);
			
			
			
			
			
			
			
			
			
			
			
			
			
			
-- 	
-- -- 查询所有员工（employees 表）的 employee_id、last_name、salary，并新增一列 salary_level：如果 salary ≥ 15000，则显示 '高管'
-- 否则显示 '普通员工'



SELECT employee_id ,last_name,salary, IF(salary > 15000,'高管','普通员工') salary_level FROM employees;


-- 查询所有员工的 employee_id、last_name、salary，并计算 年薪（12 * salary * (1 + commission_pct)）。
-- 注意：commission_pct 可能为 NULL，此时应视为 0。
-- 要求：用 IFNULL 处理 commission_pct，使结果正确显示。

SELECT employee_id , last_name ,salary ,(12*salary*(1+IFNULL(commission_pct,0))) '年薪' FROM employees ;



-- 查询员工的 last_name、job_id、salary，并新增一列 revised_salary（调整后工资）：
-- 
-- job_id = 'IT_PROG' → salary * 1.10
-- job_id = 'ST_CLERK' → salary * 1.15
-- job_id = 'SA_REP' → salary * 1.20
-- 其他 job_id → 原 salary 不变
-- 
-- 要求：使用 CASE job_id WHEN ... THEN ... 简单形式。

SELECT
	last_name,
	job_id,
	salary,
CASE
		job_id 
		WHEN 'IT_PROG' THEN
		salary * 1.10 
		WHEN 'ST_CLERK' THEN
		salary * 1.15 
		WHEN 'SA_REP' THEN
		salary * 1.20 ELSE salary 
	END 'REVISED_SALARY' 
FROM
	employees;


-- 查询 部门号为 10、20、30 的员工信息（employee_id、last_name、department_id、salary），并新增一列 adjusted_salary：
-- 
-- department_id = 10 → salary * 1.1
-- department_id = 20 → salary * 1.2
-- department_id = 30 → salary * 1.3
-- 其他部门 → 原 salary


		SELECT
			last_name,
			department_id,salary,
			CASE department_id 
				WHEN 10 THEN salary * 1.1 
				WHEN 20 THEN salary * 1.2 
				WHEN 30 THEN salary * 1.3 
				ELSE salary
			 END 'adjusted_salary'
			FROM
				employees 
			WHERE department_id IN (10,20,30);


-- 查询所有员工的 employee_id、last_name、salary、commission_pct，并新增两列：
-- 
-- bonus_level（使用 IF）：
-- commission_pct > 0.3 → '高绩效'
-- commission_pct > 0.2 → '中绩效'
-- commission_pct ≤ 0.2 或 NULL → '普通'
-- 
-- annual_income（使用 IFNULL）：
-- 年薪 = 12 * salary * (1 + IFNULL(commission_pct, 0))
-- 
-- 要求：一条 SQL 同时使用 IF 和 IFNULL，展示综合能力。


SELECT 
    employee_id,
    last_name,
    salary,
    commission_pct,
    -- 用 IF 实现三层判断（NULL 会自动进入 '普通'）
    IF(commission_pct > 0.3, '高绩效',
        IF(commission_pct > 0.2, '中绩效', '普通')
    ) AS bonus_level,
    12 * salary * (1 + IFNULL(commission_pct, 0)) AS annual_income
FROM employees
ORDER BY annual_income DESC;







