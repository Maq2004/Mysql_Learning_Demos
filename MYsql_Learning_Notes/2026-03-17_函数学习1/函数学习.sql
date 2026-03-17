-- 查询员工薪资（salary），返回其四舍五入到整数、向下取整、二进制表示、随机数种子为10时的随机值。写出SQL。
-- 四舍五入到整数
SELECT ROUND(salary) FROM employees ;

-- 截断 向下取整是floor（）
 SELECT TRUNCATE(salary,0) FROM employees;
 -- 二进制
SELECT BIN(salary) FROM employees;
-- 随机种子数为10
SELECT RAND(10) FROM DUAL;


-- 查询员工姓名（last_name），要求：全部转大写 
-- 截取前3个字符
-- 在姓名前后各填充2个“*”
-- 去掉前后空格（虽然姓名通常没有，但要演示 TRIM）
-- 写出SQL，并用 CONCAT_WS 拼接成 “姓名: XXX” 格式。
-- 
SELECT UPPER(last_name) FROM employees;

SELECT LEFT(last_name, 3) FROM employees;

SELECT CONCAT('**',last_name,'**') FROM employees;

SELECT TRIM(last_name) FROM employees;

-- 查询当前系统日期、时间、日期时间、UNIX时间戳，并把当前时间戳转换为普通日期格式。写出SQL（用 NOW()、CURDATE()、CURTIME()、UNIX_TIMESTAMP()、FROM_UNIXTIME()）。



SELECT 
    CURDATE() AS '日期', 
    CURTIME() AS '时间', 
    NOW() AS '日期时间', 
    UNIX_TIMESTAMP() AS '时间戳', 
    FROM_UNIXTIME(UNIX_TIMESTAMP()) AS '解析回日期';


-- 查询所有员工的入职日期（hire_date），计算：
-- 入职多少天（用 DATEDIFF）
-- 入职多少年（用 TIMESTAMPDIFF 或 YEAR）
-- 入职满1年的员工（hire_date + 1年仍小于今天）
-- 写出SQL。
	
	SELECT 
    last_name,
    DATEDIFF(NOW(), hire_date) AS "入职天数", 
    TIMESTAMPDIFF(YEAR, hire_date, NOW()) AS "入职年数" 
FROM employees
WHERE TIMESTAMPDIFF(YEAR, hire_date, NOW()) >= 1; -- 满1年的员工


-- 把员工入职日期（hire_date）格式化为 “2026年03月17日 星期三” 格式，并把字符串 “2026-03-17” 解析回日期类型。写出 DATE_FORMAT 和 STR_TO_DATE 的SQL。

SELECT DATE_FORMAT(hire_date, '%Y年%m月%d日 %W') FROM employees;
SELECT STR_TO_DATE('2026-03-17', '%Y-%m-%d') FROM DUAL;


-- 查询员工薪资（salary），用 CASE WHEN 实现：
-- =15000 → “高薪”
-- =10000 → “潜力股”
-- =8000 → “普通”
-- 其余 → “草根”
-- 并用 IF 函数实现同样的效果（二选一）。

SELECT last_name,salary , CASE WHEN salary > 15000 
	THEN '高薪'
	WHEN salary > 10000
	THEN '潜力'
	WHEN salary > 8000
	THEN '普通'
	ELSE '草根'
END AS "描述"
FROM employees;


-- 查询员工信息（last_name、salary、hire_date），要求：
-- 薪资四舍五入到整数
-- 入职日期格式化为 “YYYY-MM-DD 星期X”
-- 用 CASE 判断薪资等级
-- 用 CONCAT 拼接成一句话：“XXX 的薪资是 XXX 元，入职日期是 XXX（星期X），等级为 XXX”

SELECT
	last_name,
	ROUND( salary ),
	DATE_FORMAT( hire_date, '%Y-%m-%d日  星期%W' ),
CASE
		
		WHEN salary > 15000 THEN
		'高薪' 
		WHEN salary > 10000 THEN
		'潜力股' 
		WHEN salary > 8000 THEN
		'普通' ELSE ' 草根' 
	END AS "等级",
	CONCAT( last_name, "薪资是 ", salary, " ， 入职日期是", hire_date, "等级为：", j.grade_level ) 
FROM
	employees
	JOIN job_grades j ON employees.salary BETWEEN j.lowest_sal 
	AND highest_sal;





