USE atguigudb;


CREATE TABLE emp1 (
	id INT,
	emp_name VARCHAR(25),
	hire_date DATE,
	salary DOUBLE(10,2)
);

SELECT * FROM emp1;



INSERT INTO emp1(id,emp_name,hire_date,salary)
VALUES
(1,'maqian','2026-03-07',45000);



INSERT INTO emp1(id,emp_name,hire_date,salary)
VALUES
(2,'fangrunze','2026-03-21',29000),
(3,'wuxinyu','2026-02-21',25000);


INSERT INTO emp1(id,emp_name,hire_date,salary)
SELECT employee_id, last_name,hire_date,salary
FROM employees WHERE department_id IN (50,60);


SET AUTOCOMMIT = FALSE;

UPDATE emp1 SET emp_name = '李小燕' WHERE id = 1;
UPDATE emp1 SET emp_name = '二十五' WHERE id IN (1,2,3);

DELETE FROM emp1 WHERE emp_name = '二十五';

















-- 创建数据库test01_liberary
CREATE DATABASE test01_liberary;

USE test01_liberary;


-- 创建book表
CREATE TABLE IF NOT EXISTS book(
id  INT,
book_name VARCHAR(50),
book_authors VARCHAR(100),
price float(10,2),
pubdate YEAR,
note VARCHAR(100),
num INT
);

-- 插入数据，不指定字段名称插入第一条数据
INSERT INTO book
VALUES( 1 , 'Tal of AAA' , 'Dickes'  , 23 , '1995' , 'novel' , 11);

-- 指定所有字段插入第二条数据
INSERT INTO book ( id , book_name , book_authors , price , pubdate , note , num)
VALUES( 2 , 'EmmaT' , 'Jane lura'  , 35 , '1993' , 'joke' , 22);

-- 尝试插入多条数据
INSERT INTO book ( id , book_name , book_authors , price , pubdate , note , num)
VALUES
( 3 , 'Story of jane' , 'Jane Tim'  , 40 , '2001' , 'novel' , 0),
( 4, 'Lovey Day' , 'George Byron' , 20 , '2005' , 'novel' , 30 ),
( 5 , 'Old land', 'Honore Blade' , 30 , '2010' , 'law' , 0 ),
( 6, 'The Battle' , 'Upton Sara' , 30 , '1999' , 'medicine' , 40 ),
( 7, 'Rose Hood' , ' Richard haggard' , 28 , '2008' , 'cartoon' , 28 );


-- 将所有书的价格都增加5
UPDATE book SET price = price + 5 ;

SELECT * FROM book;


-- 将名称为EmmaT的书的价格改为四十，并将说明改为drama;
UPDATE book SET price = 40 , note = 'drama' WHERE book_name = 'EmmaT';

-- 删除库存为0的记录

DELETE FROM book WHERE num = 0;


-- 统计书名中包含a字母的书
SELECT COUNT(id) FROM book WHERE book_name LIKE '%a%';

-- 统计书名中包含a字母的书的数量和库存总量

SELECT COUNT(id) , SUM(num) FROM book WHERE book_name LIKE '%a%';

-- 找出类型为‘novel’类型的书，按照价格降序排列

SELECT id, price FROM book WHERE note = 'novel' ORDER BY price DESC;

-- 查询图书信息，按照库存降序排列，如果库存数量相同按照note升序排列

SELECT id , book_name , book_authors ,num FROM book ORDER BY num DESC , note ASC;


-- 按照note分类统计书的数量

SELECT   note , COUNT(note) FROM book GROUP BY note ;

-- 按照note分类统计书的库存量，显示库存量超过30本的

SELECT note, SUM(num) FROM book GROUP BY note HAVING SUM(num) > 30;


-- 查询所有图书，每页显示5本，显示第二页

SELECT * FROM book LIMIT 5,10;

-- 按照note分类统计书的库存量，显示库存量最多的

SELECT note , MAX(num) FROM book GROUP BY note;

-- 查询书名达到10个字符的书，不包括里面的空格

SELECT id , book_name FROM book WHERE REPLACE(CHAR_LENGTH(book_name),' ','') > 10;



-- 查询书名和类型，其中note值为novel显示小说，law显示法律，medicine显示医药，cartoon显示卡通，joke显示笑话

SELECT book_name , price ,note ,CASE note
	WHEN 'novel' THEN '小说'
	WHEN 'law' THEN '法律'
	WHEN 'medicine' THEN '医药'
	WHEN 'cartoon' THEN '卡通'
	WHEN 'joke' THEN '笑话'
	ELSE '*'
END '类型' FROM book;


-- 查询书名、库存，其中num值超过30本的，显示滞销，大于0并低于10的，显示畅销，为0的显示需要无货

SELECT book_name , num ,CASE WHEN num >= 30 THEN '滞销'
															WHEN (num > 0 AND num < 10) THEN '畅销'
															WHEN num = 0 THEN '无货'
															ELSE '正常'
															END '销售情况' FROM book;




-- 统计每一种note的库存量，并合计总量
SELECT SUM(num)  FROM book GROUP BY note WITH ROLLUP;
 

-- 统计每一种note的数量，并合计总量
SELECT COUNT(note) FROM book GROUP BY note WITH ROLLUP;

-- 统计库存量前三名的图书

SELECT num FROM book ORDER BY num DESC LIMIT 0,3;

-- 找出最早出版的一本书

SELECT MIN(pubdate) FROM book ;


-- 找出novel中价格最高的一本书
SELECT MAX(price) FROM book WHERE note = 'novel';

-- 找出书名中字数最多的一本书，不含空格
SELECT book_name, REPLACE(CHAR_LENGTH(book_name),' ','') FROM book ORDER BY CHAR_LENGTH(book_name) DESC LIMIT 1 ,1;

