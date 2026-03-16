USE atguigudb;

-- 1. 年薪计算
SELECT employee_id, last_name, salary * 12 AS "年薪" FROM employees;

-- 2. 加法与字符串转换
SELECT '100' + 50;
SELECT last_name + 100 FROM employees LIMIT 5;

-- 3. <=> 与 = 的区别
SELECT last_name FROM employees WHERE commission_pct = 0.30;
SELECT last_name FROM employees WHERE commission_pct <=> 0.30;
SELECT last_name FROM employees WHERE commission_pct <=> NULL;

-- 4. 四种空值判断（正确写法）
SELECT last_name, salary FROM employees WHERE commission_pct IS NULL;
SELECT last_name, salary FROM employees WHERE ISNULL(commission_pct);
SELECT last_name, salary FROM employees WHERE commission_pct <=> NULL;
-- 注意：下面这句永远返回空（错误写法）
-- SELECT last_name FROM employees WHERE commission_pct = NULL;

-- 5. BETWEEN AND
SELECT last_name, salary, job_id FROM employees WHERE salary BETWEEN 8000 AND 12000;
SELECT last_name, salary, job_id FROM employees WHERE salary NOT BETWEEN 9000 AND 12000;

-- 6. IN 和 NOT IN（已修正值）
SELECT last_name, job_id FROM employees WHERE job_id IN ('IT_PROG', 'SA_REP');
SELECT last_name, job_id, department_id FROM employees WHERE department_id NOT IN (50, 80, 90);

-- 7. LIKE 模糊查询
SELECT last_name FROM employees WHERE last_name LIKE '_o%';
SELECT first_name, salary FROM employees WHERE first_name LIKE 'S%';

-- 8. AND 和 OR（推荐现代写法）
SELECT last_name, job_title, salary 
FROM employees e 
JOIN jobs j ON e.job_id = j.job_id 
WHERE salary >= 10000 AND job_title LIKE '%MAN%';

SELECT last_name, job_title, salary 
FROM employees e 
JOIN jobs j ON e.job_id = j.job_id 
WHERE salary >= 10000 OR job_title LIKE '%MAN%';

-- 9. 位运算
SELECT employee_id, employee_id & 1 FROM employees LIMIT 5;

-- 10. 优先级
SELECT last_name, salary * 12 AS "年薪" FROM employees WHERE salary * 12 > 200000;
SELECT last_name, salary * 12 AS "年薪" FROM employees WHERE (salary * 12) > 200000;





-- 查询薪资在 8000~15000 之间（包含边界），且commission_pct 不是 NULL 的员工姓名、薪资、commission_pct。

SELECT last_name , salary,commission_pct FROM employees WHERE salary  BETWEEN 8000 AND 15000  AND   commission_pct IS NOT NULL;


-- 查询 job_id 是 'SA_REP' 或 'IT_PROG'，且 姓氏（last_name）第二个字母是 'o' 或 'a' 的员工姓名、岗位ID、薪资。

SELECT last_name ,job_id , salary FROM employees WHERE job_id IN ('SA_REP','IT_PROG') AND ( last_name LIKE '_o%' OR last_name LIKE  '_a%' ); 


-- 查询满足以下任一条件的员工姓名和薪资：薪资 > 15000 或者 岗位包含 'MAN' 并且 commission_pct 不为 NULL
-- 写出两条SQL：一条不加括号，一条加括号。对比结果是否相同，并解释原因。

SELECT last_name , salary FROM employees JOIN jobs  WHERE salary > 15000 OR job_title LIKE "%MAN%" AND  NOT commission_pct <=> NULL;

SELECT last_name , salary FROM employees JOIN jobs  WHERE (salary > 15000 OR job_title LIKE "%MAN%" )AND  NOT commission_pct <=> NULL;

-- 结果不同的原因是AND和OR的优先级问题，不加括号的话AND的优先级要比OR要高，所以先处理AND



