CREATE DATABASE dbtest2 CHARACTER SET 'utf8';

USE dbtest2;


-- 约束的分类
-- 根据约束数据列的限制分为：
-- 		单列数据：每个约束只约束一列
-- 		多列数据： 每个约束可约束多列数据

-- 根据约束的范围作用分为：
-- 		列级约束 ： 只能作用在一个列上，跟在列定义后面
-- 		表级约束	：可以作用在多个列上，不与列一起定义而是单独定义


-- 非空约束
	-- 	： 非空约束只能出现在表对象的列上，只能限制某个单列为非空，不能组合非空
-- 创建表时添加非空约束
CREATE TABLE IF NOT EXISTS test1(
	id  INT NOT NULL,
	name VARCHAR(30)
);

INSERT INTO test1(id,name)
VALUES(1,'maqian'),(2,'xiaobai'); -- 成功，无错


-- 1048 - Column 'id' cannot be null 失败，不允许为空
INSERT INTO test1(id,name)
VALUES(NULL,'runze');


-- 建表后创建非空约束
CREATE TABLE IF NOT EXISTS test2(
	id  INT ,
	name VARCHAR(30)
);

ALTER TABLE test2
MODIFY id INT NOT NULL;

-- 1048 - Column 'id' cannot be null 
INSERT INTO test2(id,name)
VALUES(NULL,'runze');


-- 删除非空约束

ALTER TABLE test1
MODIFY id INT NULL;


-- 唯一性约束 : 用于限制某个列或者字段的值不能重复

-- 同一个表可以有多个唯一约束
-- 唯一约束可以是某一列的值唯一，也可以是多个列组合的值唯一
-- 唯一值约束的值可以为NULL
-- 在创建唯一约束的时候，如果不给唯一约束命名，旧默认和列名相同
-- Mysql会给唯一约束的列上默认创建一个唯一索引

-- 建表的时候添加唯一约束

CREATE TABLE IF NOT EXISTS test3(
	id  INT  UNIQUE,
	name VARCHAR(30)
);


INSERT INTO test3 
VALUES(1,'maqian');

INSERT INTO test3 
VALUES(NULL,'maqian'); -- 唯一值约束可以为NULL

INSERT INTO test3 
VALUES(NULL,'runze'); -- 唯一值约束可以有多个null

SELECT * FROM test3;


-- 1062 - Duplicate entry '1' for key 'test3.id'
INSERT INTO test3 
VALUES(1,'xiaobai');


-- 建表时创建多个列的复合唯一约束：只要这些列的值组合唯一，那么就可以

CREATE TABLE IF NOT EXISTS test4(
	id  INT,
	name VARCHAR(30),
	CONSTRAINT uk_id_name UNIQUE (id , name)
);

INSERT INTO test4 
VALUES(1,'maqian');

INSERT INTO test4 
VALUES(1,'maqian2'); -- 没问题，组合唯一

INSERT INTO test4
VALUES(1,'maqian2');-- 1062 - Duplicate entry '1-maqian2' for key 'test4.uk_id_name'

-- 建表后创建唯一约束

CREATE TABLE IF NOT EXISTS test5(
	id  INT,
	name VARCHAR(30)
);

-- 添加单个列的唯一约束
ALTER TABLE test5
ADD UNIQUE KEY(id);

ALTER TABLE test5
MODIFY name VARCHAR(50) UNIQUE;

-- 添加多个列的唯一约束

ALTER TABLE test5
ADD UNIQUE KEY(id,name);

ALTER TABLE test5
ADD CONSTRAINT uk_name_id  UNIQUE KEY(id,name);


-- 删除唯一约束

-- 首先添加唯一性约束的列会自动创建唯一索引
-- 删除唯一性约束只能通过删除唯一索引的方式删除
-- 删除的时候需要指定唯一索引的名字，唯一索引的名字和唯一约束名一样
-- 如果创建唯一性约束的时候没有指定名字，如果是单列则默认和列名一样，如果是多列，则默认和在（）中排第一个列名相同。也可以自定义唯一索引的名字

SELECT * FROM information_schema.table_constraints WHERE table_name = 'test5'; #查看都有哪些约束

ALTER TABLE test5
DROP INDEX id; -- 删除索引，顺带约束也就没了。但这不是删除列

SHOW INDEX FROM test5;


-- PRIMARY KEY 约束：用于唯一表示表中的一行记录,相当于唯一约束和非空约束的组合

-- 一个表最多只能有一个主键约束，建立主键约束可以在列级别创建，也可以在表级别上创建。

-- 主键约束对应着表中的一列或者多列（复合主键）

-- 如果是多列组合的复合主键约束，那么这些列都不允许为空值，并且组合的值不允许重复。

-- MySQL的主键名总是PRIMARY，就算自己命名了主键约束名也没用。

-- 当创建主键约束时，系统默认会在所在的列或列组合上建立对应的主键索引（能够根据主键查询的，就根据主键查询，效率更高）。如果删除主键约束了，主键约束对应的索引就自动删除了。


-- 需要注意的一点是，不要修改主键字段的值。因为主键是数据记录的唯一标识，如果修改了主键的值，就有可能会破坏数据的完整性。

-- 添加主键约束，在创表时；


CREATE TABLE IF NOT EXISTS test6(
	id  INT PRIMARY KEY,
	name VARCHAR(30)
);

INSERT INTO test6
VALUES(1,'maqian');

INSERT INTO test6
VALUES(NULL,'maqian'); -- 错误，主键不能为空

INSERT INTO test6
VALUES(1,'xiaobai'); -- 错误，主键不能相同

-- 添加复合主键约束，在创表的时候

CREATE TABLE IF NOT EXISTS test7(
	id  INT,
	name VARCHAR(30),
	CONSTRAINT Id_name_pk PRIMARY KEY(id,name)
	
);
INSERT INTO test7
VALUES(1,'maqian');

INSERT INTO test7
VALUES(2,'maqian'); -- 没问题，只要两列的值组合唯一就可以

INSERT INTO test7
VALUES(NULL,'maqian3'); -- 不可以，因为主键是唯一且非空，唯一符合但是不符合非空



-- 创表增加主键约束
CREATE TABLE IF NOT EXISTS test8(
	id  INT,
	name VARCHAR(30)	
);

ALTER TABLE test8
ADD CONSTRAINT id_name_pk PRIMARY KEY(id);

ALTER TABLE test8
ADD PRIMARY KEY(name);


ALTER TABLE test8
ADD PRIMARY KEY(id,name);

-- 删除主键约束

alter table test8 drop primary key;

-- 自增列 ： 某个字段的值自增


-- 一个表最多只能有一个自增长列
-- 当需要产生唯一标识符或顺序值时，可设置自增长

-- 自增长列约束的列必须是键列（主键列，唯一键列）

-- 自增约束的列的数据类型必须是整数类型
-- 如果自增列指定了 0 和 null，会在当前最大值的基础上自增；如果自增列手动指定了具体值，直接赋值为具体值。

-- 创建自增列错误演示
CREATE TABLE IF NOT EXISTS test9(
	id  INT AUTO_INCREMENT,
	name VARCHAR(30)	
); -- 错误，因为自增列一定是唯一约束列或者主键列

-- 正确演示
CREATE TABLE IF NOT EXISTS test9(
	id  INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(30)	
);


-- 建表后指定自增列

CREATE TABLE IF NOT EXISTS test10(
	id  INT,
	name VARCHAR(30)	
);

ALTER TABLE test10 
ADD PRIMARY KEY(id);

ALTER TABLE test10 
MODIFY id INT AUTO_INCREMENT;

-- 删除自增约束


ALTER TABLE test10 
MODIFY id INT;


-- 8.0新特性 自增变量的持久化
CREATE TABLE test11(
id INT PRIMARY KEY AUTO_INCREMENT
);
-- 插入四个值后
INSERT INTO test11
VALUES(0),(0),(0),(0);

SELECT * FROM test11;
-- 删除id为四的值
DELETE FROM test11 WHERE id = 4;
-- 再次插入一个值后按理说应该是四，但实际上是五。在之前的版本重启数据库后再插入值会是四，但是8.0后即使重启后也会是五，因为mysql内部的计数器从内存中转移到了日志中，8.0后重启会把日志中的计数器读出来
INSERT INTO test11 VALUES(0);


-- 检查约束：检查某个字段的值是否符合要求，一般是指的值的范围
-- 在5.7版本以前不支持check约束，但是8.0支持


--  建表时加入check约束
CREATE TABLE test12(
	id INT PRIMARY KEY,
	name VARCHAR(20),
	gender CHAR CHECK ( gender IN ('男','女'))
);

DROP TABLE test12;


INSERT INTO test12 
VALUES(1,'maqian','男');



INSERT INTO test12 
VALUES(1,'maqian','鬼'); -- 错误

CREATE TABLE test13(
	id INT AUTO_INCREMENT,
	name VARCHAR(20),
	age INT CHECK(age > 20),
	PRIMARY KEY(id)
);

INSERT INTO test13 
VALUES(1,'maqian',13); -- 错误



-- DEFAULT约束 :给某个字段设置默认值

-- 创表的时候设置默认值
create table test14(
	id int primary key,
	name varchar(20) not null,
	gender char default '男',
	tel char(11) not null default '' #默认是空字符串
);
-- gender的默认值是男
INSERT INTO test14 (id,name,tel) VALUES (1,'maqian','123456' );

-- 创表后设置默认值
create table test15(
	id int primary key,
	name varchar(20) not null,
	gender char ,
	tel char(11) not null #默认是空字符串
);
-- MODFIY是重写字段，如果你之前有什么非空约束的情况下，在MODFIY中如果不写上去，会把非空约束去掉，同理，MODFIY非空约束的情况下，如果有默认值，不写上去也会被清空
ALTER  TABLE test15 MODIFY gender char DEFAULT '男';
 
-- 删除非空约束
ALTER  TABLE test15 MODIFY gender char;


-- 外键约束

-- 从表的外键列，必须引用/参考主表的主键或唯一约束的列
-- 为什么？因为被依赖/被参考的值必须是唯一的

-- 在创建外键约束时，如果不给外键约束命名，默认名不是列名，而是自动产生一个外键名（例如student_ibfk_1;），也可以指定外键约束名。

-- 创建(CREATE)表时就指定外键约束的话，先创建主表，再创建从表

-- 删表时，先删从表（或先删除外键约束），再删除主表

-- 当主表的记录被从表参照时，主表的记录将不允许删除，如果要删除数据，需要先删除从表中依赖该记录的数据，然后才可以删除主表的数据

-- 在“从表”中指定外键约束，并且一个表可以建立多个外键约束

-- 从表的外键列与主表被参照的列名字可以不相同，但是数据类型必须一样，逻辑意义一致。如果类型不一样，创建子表时，就会出现错误“ERROR 1005 (HY000): Can't createtable'database.tablename'(errno: 150)”。
-- 例如：都是表示部门编号，都是int类型。

-- 当创建外键约束时，系统默认会在所在的列上建立对应的普通索引。但是索引名是外键的约束名。（根据外键查询效率很高）

-- 删除外键约束后，必须手动删除对应的索引




-- 添加外键约束，创表时候


create table dept( #主表
	did int primary key,   -- 部门编号     
	dname varchar(50)      -- 部门名称
);
#部门编号
create table emp(#从表
	eid int primary key,  -- 员工编号
	ename varchar(5),     
	deptid int,-- 员工所在部门
	FOREIGN KEY (deptid) REFERENCES dept(did) -- 意思是 emp表中的deptid（员工所在部门）要被dept表中的（did）约束 
							
);

-- 创表后

create table dept1(
		did int primary key,#部门编号    
		dname varchar(50)   #部门名称  
      
);

create table emp1(
		eid int primary key,#员工编号
		ename varchar(5),   #员工姓名
		deptid int          #员工所在的部门  
);

-- emp1表中的deptid列要被dept1表中的did列约束
ALTER TABLE emp1 ADD FOREIGN KEY(deptid) REFERENCES dept1(did);


-- 注意！主表中约束外键的列一定是带有唯一性约束的列或者主键列


-- 失败，不是主键列/唯一约束列
create table dept2(
		did int ,     -- ！！  
		dname varchar(50)           
);
#部门名称
create table emp2(
		eid int primary key, 
		ename varchar(5),     
		deptid int,             
		foreign key (deptid) references dept(did)
);

-- 注意！主表中约束外键的列 和 从表中被主表中主键约束的列 的数据类型一定要一致

create table dept(
		did int primary key,        
		dname varchar(50)           
);

create table emp(
		eid int primary key,  #员工编号
		ename varchar(5),     
		deptid char,    -- ！！            
		foreign key (deptid) references dept(did)
);


-- 添加，删除，修改

create table dept( #主表
	did int primary key,   -- 部门编号     
	dname varchar(50)      -- 部门名称
);
#部门编号
create table emp(#从表
	eid int primary key,  -- 员工编号
	ename varchar(5),     
	deptid int,-- 员工所在部门
	FOREIGN KEY (deptid) REFERENCES dept(did) -- 意思是 emp表中的deptid（员工所在部门）要被dept表中的（did）约束 
							
);
-- dept（部门表）为主表，emp（员工表）为从表
insert into dept values(1001,'教学部');
insert into dept values(1003, '财务部');

insert into emp values(1,'张三',1001);
insert into emp values(2,'王五',1001);  #添加从表记录成功，在添加这条记录时，要求部门表有1001部门

insert into emp values(2,'李四',1005);#添加从表记录失败，因为主表中没有1005号部门

SELECT * FROM dept;
SELECT * FROM emp;


--  修改从表中的数据
update emp set deptid = 1002 where eid = 1; -- 错误 , 主表中没有1002

update emp set deptid = 1003 where eid = 1; -- 正确，主表中存在1003

-- 修改主表中的数据


update dept set did = 1002 where did = 1001; -- 错误主表中的did 1001 正在约束从表中的李四。所以不能修改
update dept set did = 1002 where did = 1003; -- 正确，主表中的1003 没有约束任何从表的对象

-- 删除

delete from dept where did=1001; -- 失败，该数据正在约束从表中的数据

delete from dept where did=1002;-- 成功， 这个数据没有约束从表中的数据

-- 总结
-- 添加了外键约束后，主表的修改和删除数据受约束
-- 添加了外键约束后，从表的添加和修改数据受约束
-- 在从表上建立外键，要求主表必须存在
-- 删除主表时，要求从表从表先删除，或将从表中外键引用该主表的关系先删除


ALTER TABLE emp ADD FOREIGN KEY(deptid) REFERENCES dept(did);






-- 删除外键约束
-- 1.第一步
SELECT * FROM information_schema.table_constraints WHERE table_name = 'emp';#查看某个表的约束名

ALTER TABLE emp -- 从表名
DROP FOREIGN KEY emp_ibfk_1; -- 外键约束名

-- 2. 第二步
-- 查看索引名和删除索引。（注意，只能手动删除）
SHOW INDEX FROM emp; #查看某个表的索引名

ALTER TABLE emp
 DROP INDEX deptid;