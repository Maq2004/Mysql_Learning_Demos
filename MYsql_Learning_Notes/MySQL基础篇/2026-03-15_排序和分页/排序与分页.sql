
USE atguigudb;
SELECT * FROM employees;

-- ORDER BY ,排序关键词，放在最后面。 ASC，升序。DESC，降序;
-- 单列排序：
SELECT last_name , salary FROM employees ORDER BY salary ASC;
SELECT last_name , salary FROM employees ORDER BY salary DESC;

-- 双列排序
--  可以选择不在SELECT 列表中的列排序
SELECT last_name , salary FROM employees ORDER BY salary ,department_id ASC;

-- 排序的时候，先比较第一列，如果第一列相等，则按照第二列的大小排列，如果第一列中所有的值都是唯一的，那么将不对第二列排列
SELECT last_name , salary , department_id FROM employees ORDER BY salary ,department_id ASC;


-- LIMIT ,分页关键词
-- LIMIT [ 位置偏移量 ,] 行数
-- 位置偏移量是指从第几行开始显示,没写默认是从查询到的第一条记录开始，那么位置偏移量就是0
-- 行数就是每页返回多少行

-- 从第1行开始显示，每一页返回十条，即查询前十条记录
SELECT * FROM employees ORDER BY salary ASC LIMIT 0 , 10;

-- 从第6行开始显示，每一页返回十条
SELECT * FROM employees ORDER BY salary ASC LIMIT 5 , 10;

-- 使用LIMIT的好处就是可以减少表的网络传输量，可以提升表的查询效率，如果我们的返回结果只有一条，就告诉SELECT只返回一条，这样SELECT就不用返回整个表


-- 查询所有员工的 last_name 和 salary，按薪资降序排列。别名“月薪”。

SELECT last_name , salary AS "月薪" FROM employees ORDER BY salary DESC;


 -- 查询员工的 last_name、department_id 和年薪（salary*12，别名“年薪”），先按年薪降序，再按姓名升序。
 
 SELECT last_name , department_id , (salary *12) AS "年薪" FROM employees ORDER BY  年薪 DESC ,last_name ASC;
	

-- 查询邮箱中包含 'e' 的员工 last_name、email 和 department_id，先按邮箱长度降序，再按部门号升序。

SELECT last_name , email ,department_id FROM employees WHERE email LIKE "%e%" ORDER BY LENGTH(email) DESC , department_id ASC;

-- 查询薪资不在 8000 到 17000 之间的员工 last_name 和 salary，按薪资降序，显示第21到40条数据。

SELECT last_name , salary FROM employees WHERE salary <8000 OR salary>17000 ORDER BY salary DESC LIMIT 20,20;


-- LIMIT 偏移量理解LIMIT 0,10、LIMIT 10,10、LIMIT 20,10 分别显示第几条到第几条数据？（从第1条开始算）

-- 1.显示第一条到第十条
-- 2.显示第十一条到第二十条
-- 3.显示第二十一条到第三十条



-- 查询 department_id = 50 的员工姓名和薪资，按薪资降序排列。
SELECT last_name , salary FROM employees WHERE department_id = 50 ORDER BY salary DESC;

-- 查询所有员工的 last_name、job_id 和 hire_date，先按入职日期升序，再按姓名降序

SELECT last_name , hire_date FROM employees ORDER BY hire_date ASC , last_name DESC;


-- 查询年薪（salary*12 别名 annual_sal），按别名降序排序是否可以？如果写 ORDER BY annual_sal DESC 和 ORDER BY salary*12 DESC 结果一样吗？

SELECT last_name , salary annual_sal FROM employees ORDER BY salary*12 DESC; 

SELECT last_name , salary annual_sal FROM employees ORDER BY annual_sal DESC;

-- 可以 ，是一样的

 -- 查询邮箱包含 'e' 的员工，按邮箱长度降序显示第11到20条数据。
 SELECT last_name , email FROM employees  WHERE email LIKE "%e%" ORDER BY LENGTH(email) DESC LIMIT 10,10;

-- 执行 SELECT last_name FROM employees ORDER BY salary DESC LIMIT 5,5;这条SQL会显示第几条到第几条？如果把 LIMIT 改成 LIMIT 5 又是什么？

-- 会显示第六条到第十条，改成LIMIT 5 后会显示第一条到第六条
