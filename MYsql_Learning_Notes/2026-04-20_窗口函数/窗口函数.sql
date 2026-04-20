
CREATE DATABASE dbtest_04_20;
USE dbtest_04_20;

#1. 创建students数据表，如下
CREATE TABLE students(
		id INT PRIMARY KEY AUTO_INCREMENT,
		student VARCHAR(15),
		points TINYINT
);

#2. 向表中添加数据如下

INSERT INTO students(student,points)
VALUES
('张三',89),
('李四',77),
('王五',88),
('赵六',90),
('孙七',90),
('周八',88);

-- 序号函数

#3. 分别使用RANK()、DENSE_RANK() 和 ROW_NUMBER()函数对学生成绩降序排列情况进行显示

SELECT * FROM students;


SELECT *, RANK() OVER ( ORDER BY points DESC) FROM students; -- 并列排序，分数相同会跳过重复序号 1 1 3

SELECT *, DENSE_RANK() OVER ( ORDER BY points DESC) FROM students;-- 并列排序，分数相同不会跳过重复序号 1 1 2

SELECT *, ROW_NUMBER() OVER ( ORDER BY points DESC) FROM students;-- 顺序排序，给每一行一个序号

SELECT * , RANK() OVER w , DENSE_RANK() OVER w , ROW_NUMBER() OVER w FROM students WINDOW w AS (ORDER BY points DESC);


-- 分布函数

CREATE TABLE goods(
	id INT PRIMARY KEY AUTO_INCREMENT,
	category_id INT,
	category VARCHAR(15),
	NAME VARCHAR(30),
	price DECIMAL(10,2),
	stock INT,
	upper_time DATETIME
);


INSERT INTO goods(category_id,category,NAME,price,stock,upper_time)
VALUES
(1, '女装/女士精品', 'T恤', 39.90, 1000, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '连衣裙', 79.90, 2500, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '卫衣', 89.90, 1500, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '牛仔裤', 89.90, 3500, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '百褶裙', 29.90, 500, '2020-11-10 00:00:00'),
(1, '女装/女士精品', '呢绒外套', 399.90, 1200, '2020-11-10 00:00:00'),
(2, '户外运动', '自行车', 399.90, 1000, '2020-11-10 00:00:00'),
(2, '户外运动', '山地自行车', 1399.90, 2500, '2020-11-10 00:00:00'),
(2, '户外运动', '登山杖', 59.90, 1500, '2020-11-10 00:00:00'),
(2, '户外运动', '骑行装备', 399.90, 3500, '2020-11-10 00:00:00'),
(2, '户外运动', '运动外套', 799.90, 500, '2020-11-10 00:00:00'),
(2, '户外运动', '滑板', 499.90, 1200, '2020-11-10 00:00:00');


-- PERCENT_RANK() 等级制百分比函数

-- (rank - 1) / (rows - 1) rank -- RANK（） 并列排序的序号
 -- rows 总数 count（*）
-- ：计算 goods 数据表中名称为“女装/女士精品”的类别下的商品的PERCENT_RANK值。



 SELECT count(*) over (ORDER BY category_id ),RANK() OVER w AS r,
	PERCENT_RANK() OVER w AS pr,
	id, category_id, category, NAME, price, stock
	FROM goods
WHERE category_id = 1 
 WINDOW w AS (PARTITION BY category_id ORDER BY price DESC);



-- CUME_DIST()函数主要用于查询小于或等于某个值的比例。


--  查询goods数据表中大于或等于当前价格的比例 
SELECT CUME_DIST() OVER (PARTITION BY category_id ORDER BY price ASC ) , id , category_id , NAME , price FROM goods;



-- 因为DESC 是 降序排列， 所以CUME_DIST函数变成了查询 有多少商品的价格 大于等于当前商品的价格呢？
SELECT CUME_DIST() OVER (PARTITION BY category_id ORDER BY price DESC ) , id , category_id , NAME , price FROM goods;



-- 首尾函数 
-- FIRST_VALUE(expr)函数返回第一个expr的值。

 SELECT id, category, NAME, price, stock,FIRST_VALUE(price) OVER w AS 
first_price  FROM goods WINDOW w AS (PARTITION BY category_id ORDER BY price);

-- LAST_VALUE(expr) 返回最后一个expr的值
-- 因为mySQL 的查询是一个循环 ， 所以当出现第一行的时候，最后一个expr的值就是他自己，同理第二行第三行都是相对应行自己。

 SELECT id, category, NAME, price, stock,LAST_VALUE(price) OVER w AS 
last_price  FROM goods WINDOW w AS (PARTITION BY category_id ORDER BY price);


-- NTH_VALUE(expr,n)函数返回第n个expr的值
-- 查询goods数据表中排名第2和第3的价格信息
SELECT id, category, NAME, price,
NTH_VALUE(price,2) OVER w AS second_price, 
NTH_VALUE(price,3) OVER w AS third_price 
FROM goods WINDOW w AS (PARTITION BY category_id ORDER BY price)


-- NTILE(n)函数将分区（PARTITION）中的有序数据分为n个桶，记录桶编号。
-- 举例：将goods表中的商品按照价格分为3组

 SELECT NTILE(3) OVER w AS nt,id, category, NAME,
	price FROM goods WINDOW w AS (PARTITION BY category_id ORDER BY price);


-- LEAD(expr,n)函数返回当前行的后n行的expr的值。
-- 举例：查询goods数据表中后一个商品价格与当前商品价格的差值

SELECT id , category , NAME , price , LEAD(price , 1 ) OVER (PARTITION BY category ORDER BY price DESC) , price -  LEAD(price , 1 ) OVER (PARTITION BY category ORDER BY price DESC) AS DIFF FROM goods;


-- LAG(expr,n)函数返回当前行的前n行的expr的值。
-- 举例：查询goods数据表中前一个商品价格与当前商品价格的差值


SELECT id , category , NAME , price , LAG(price , 1 ) OVER (PARTITION BY category ORDER BY price DESC) , price -  LAG(price , 1 ) OVER (PARTITION BY category ORDER BY price DESC) AS DIFF FROM goods;
