CREATE DATABASE dbtest1;

USE dbtest1;


-- =============================================
-- 1. 整数类型 + 显示宽度 + ZEROFILL + UNSIGNED
-- 题目：整数类型的5种类型、显示宽度M、ZEROFILL（自动加UNSIGNED）、显示宽度不影响实际存储范围
-- =============================================

CREATE TABLE test_int (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    f1          TINYINT,                    -- 默认有符号
    f2          SMALLINT(6),
    f3          INT(5) ZEROFILL,            -- ZEROFILL 会自动添加 UNSIGNED
    f4          BIGINT UNSIGNED             -- 无符号整数
);

INSERT INTO test_int(f1, f2, f3, f4) 
VALUES 
    (127, 32767, 123, 4294967295),
    (-128, -32768, 1, 0),
    (999, 99999, 123456, 10000000000);   -- 超过显示宽度也不影响存储

SELECT * FROM test_int;
SELECT f3 FROM test_int;                 -- 查看 ZEROFILL 左补0效果
DESC test_int;                           -- 查看实际列定义


-- =============================================
-- 2. 浮点数 vs 定点数精度对比（最重要）
-- 题目：浮点数(FLOAT/DOUBLE)存在二进制精度误差，定点数(DECIMAL)精准无误差
-- =============================================

CREATE TABLE test_float_decimal (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    f_float    FLOAT,
    f_double   DOUBLE,
    f_dec      DECIMAL(10,2)          -- 推荐用于金额等高精度场景
);

INSERT INTO test_float_decimal(f_float, f_double, f_dec)
VALUES 
    (0.47, 0.47, 0.47),
    (0.44, 0.44, 0.44),
    (0.19, 0.19, 0.19);

-- 测试精度误差
SELECT 
    SUM(f_float)   AS sum_float,
    SUM(f_double)  AS sum_double,
    SUM(f_dec)     AS sum_decimal,
    SUM(f_dec) = 1.10 AS is_exact
FROM test_float_decimal;


-- =============================================
-- 3. DECIMAL 的使用规范
-- 题目：DECIMAL(M,D) 中 M 是总位数，D 是小数位，适合高精度场景（如金额）
-- =============================================

CREATE TABLE test_decimal (
    order_id   INT PRIMARY KEY,
    amount     DECIMAL(12,2) NOT NULL,   -- 支持最大 9999999999.99
    price      DECIMAL(8,2)
);

INSERT INTO test_decimal VALUES 
    (1, 12345678.99, 9999.99),
    (2, 0.01, 0.00);

-- 超出精度测试（会报错或四舍五入）
-- INSERT INTO test_decimal VALUES (3, 999999999999.99, 10000.00);


-- =============================================
-- 4. BIT 类型
-- 题目：BIT(M) 用于存储二进制位，可用 BIN()、HEX()、+0 查看十进制值
-- =============================================

CREATE TABLE test_bit (
    id    INT PRIMARY KEY,
    flag  BIT(8),
    opt   BIT(5)
);

INSERT INTO test_bit VALUES 
    (1, b'00000001', 23),     -- 23 的二进制是 10111
    (2, 1, 31);

SELECT 
    flag,
    BIN(flag)  AS bin_flag,
    HEX(flag)  AS hex_flag,
    flag + 0   AS decimal_value
FROM test_bit;


-- =============================================
-- 5. 日期时间类型全面对比
-- 题目：YEAR、DATE、TIME、DATETIME、TIMESTAMP 的区别及推荐使用
-- =============================================

CREATE TABLE test_datetime (
    id            INT PRIMARY KEY AUTO_INCREMENT,
    create_year   YEAR,
    create_date   DATE,
    create_time   TIME,
    dt            DATETIME,                    -- 实际开发中最常用
    ts            TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO test_datetime(create_year, create_date, create_time, dt) 
VALUES 
    ('2025', '2025-03-31', '14:30:25', '2025-03-31 14:30:25'),
    ('45', '69-10-01', '2 12:30', NOW());   

SELECT * FROM test_datetime;

-- 测试 TIMESTAMP 时区特性（重要区别）
SET time_zone = '+08:00';
SELECT dt, ts FROM test_datetime;

SET time_zone = '+09:00';
SELECT dt, ts FROM test_datetime;   -- TIMESTAMP 会随时区变化，DATETIME 不变


-- =============================================
-- 6. CHAR vs VARCHAR 的区别与空格处理
-- 题目：CHAR 固定长度（自动补空格，检索时自动去掉空格），VARCHAR 可变长度（保留尾部空格）
-- =============================================

CREATE TABLE test_char_varchar (
    id     INT PRIMARY KEY,
    c1     CHAR(5),
    v1     VARCHAR(5)
);

INSERT INTO test_char_varchar VALUES 
    (1, 'a', 'a'),
    (2, 'abc  ', 'abc  ');   -- CHAR 会自动补空格，VARCHAR 保留输入的空格

SELECT 
    c1, 
    CHAR_LENGTH(c1) AS char_len,
    v1,
    CHAR_LENGTH(v1) AS varchar_len,
    CONCAT(c1, ' *') AS char_concat,
    CONCAT(v1, ' *') AS varchar_concat
FROM test_char_varchar;


-- =============================================
-- 7. ENUM 类型（枚举）
-- 题目：ENUM 只能选择一个值，支持按索引插入，忽略大小写
-- =============================================

CREATE TABLE test_enum (
    id      INT PRIMARY KEY,
    season  ENUM('春', '夏', '秋', '冬', 'unknown')
);

INSERT INTO test_enum VALUES 
    (1, '春'),
    (2, '秋'),
    (3, 'UNKNOW'),     -- 忽略大小写
    (4, 1),            -- 按索引插入（1代表'春'）
    (5, 3);            -- 3代表'秋'

-- 错误示例
-- INSERT INTO test_enum VALUES (6, 'ab');   -- 会报 Data truncated

SELECT * FROM test_enum;


-- =============================================
-- 8. SET 类型（集合）
-- 题目：SET 可以同时选择多个值，重复值会自动去重
-- =============================================

CREATE TABLE test_set (
    id     INT PRIMARY KEY,
    hobby  SET('吃饭', '睡觉', '打游戏', '写代码', '运动')
);

INSERT INTO test_set VALUES 
    (1, '睡觉,打游戏'),
    (2, '吃饭,睡觉,吃饭'),        -- 重复的'吃饭'会自动去重
    (3, '睡觉,写代码,吃饭');

SELECT * FROM test_set;

-- 错误示例
-- INSERT INTO test_set VALUES (4, '睡觉,唱歌');   -- 不存在的成员会报错


-- =============================================
-- 9. TEXT 类型
-- 题目：TEXT 系列不能做主键，不支持默认值，适合存储较长文本
-- =============================================

CREATE TABLE test_text (
    id       INT PRIMARY KEY,
    content  TEXT NOT NULL               -- TEXT 类型不能设置 DEFAULT 值
);

INSERT INTO test_text(content) VALUES 
    ('这是很长的一段文本内容，可以存储几万字符...'),
    ('atguigu   ');                    -- 尾部空格会被保留

SELECT CHAR_LENGTH(content) FROM test_text;


-- =============================================
-- 10. BLOB 类型（实际开发中的推荐做法）
-- 题目：BLOB 存二进制大对象，实际项目中推荐只存文件路径而非二进制内容
-- =============================================

CREATE TABLE test_blob (
    id   INT PRIMARY KEY,
    img  MEDIUMBLOB                     -- 不推荐直接存图片
);

-- 实际开发中推荐的做法：
CREATE TABLE test_image (
    id           INT PRIMARY KEY,
    image_path   VARCHAR(255) NOT NULL,   -- 推荐：只存文件路径
    upload_time  DATETIME DEFAULT CURRENT_TIMESTAMP
);


-- =============================================
-- 11. JSON 类型（MySQL 5.7+）
-- 题目：JSON 类型支持 -> 和 ->> 提取数据
-- =============================================

CREATE TABLE test_json (
    id    INT PRIMARY KEY,
    info  JSON
);

INSERT INTO test_json VALUES 
    (1, '{"name": "songhk", "age": 18, "address": {"province": "beijing", "city": "beijing"}}');

-- 使用 -> 和 ->> 提取 JSON 数据
SELECT 
    info->'$.name' AS name,                    -- 带引号
    info->'$.age' AS age,
    info->'$.address.province' AS province,
    info->>'$.address.city' AS city            -- ->> 去掉双引号
FROM test_json;


-- =============================================
-- 12. TIMESTAMP vs DATETIME 完整对比
-- 题目：TIMESTAMP 与 DATETIME 的范围、存储方式、时区行为区别
-- =============================================

CREATE TABLE test_time_compare (
    id    INT PRIMARY KEY,
    dt    DATETIME DEFAULT CURRENT_TIMESTAMP,
    ts    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO test_time_compare(id) VALUES (1);

SELECT * FROM test_time_compare;

-- 修改时区观察两者行为差异（核心考点）
SET time_zone = '+00:00';
SELECT dt, ts FROM test_time_compare;

SET time_zone = '+08:00';
SELECT dt, ts FROM test_time_compare;   -- TIMESTAMP 会自动转换，DATETIME 保持不变




=
-- 
--    MySQL 支持哪些主要数据类型类别？     
-- 整数类型、浮点类型、定点数类型、位类型、日期时间类型、文本字符串类型、枚举类型、集合类型、二进制字符串类型、JSON 类型、空间数据类型。
-- 


--    常见的 MySQL 关键字及其含义有哪些？     
-- NULL：允许为空  
-- NOT NULL：不允许为空  
-- DEFAULT：默认值  
-- PRIMARY KEY：主键  
-- AUTO_INCREMENT：自动递增（用于整数）  
-- UNSIGNED：无符号  
-- CHARACTER SET：指定字符集
-- 


--    MySQL 有哪 5 种整数类型？各自字节数和取值范围？     
-- TINYINT（1字节）：有符号 -128~127，无符号 0~255  
-- SMALLINT（2字节）：有符号 -32768~32767，无符号 0~65535  
-- MEDIUMINT（3字节）：有符号 -8388608~8388607，无符号 0~16777215  
-- INT（4字节）：有符号 -2147483648~2147483647，无符号 0~4294967295  
-- BIGINT（8字节）：有符号超大范围，无符号 0~18446744073709551615
-- 


--    整数类型的可选属性 M、UNSIGNED、ZEROFILL 的作用？     

-- M：显示宽度，仅配合 ZEROFILL 有意义，从 MySQL 8.0.17 开始不推荐  
-- UNSIGNED：无符号，最小值为 0  
-- ZEROFILL：左边补 0，同时自动添加 UNSIGNED
-- 


--    整数类型选择的核心原则是什么？     
-- 先确保取值范围足够大避免溢出，再考虑节省存储空间。实际中最常用 INT，超大数值用 BIGINT。


--    FLOAT 和 DOUBLE 的主要区别？     
-- FLOAT：单精度，占 4 字节  
-- DOUBLE：双精度，占 8 字节，取值范围更大，精度更高

-- 
--    为什么浮点数计算会出现精度误差？如何避免？     
-- 浮点数用二进制存储，大部分小数无法精确表示。  
-- 解决方法：使用 DECIMAL 定点数类型。
-- 

--    DECIMAL 类型有什么特点？     
-- 以字符串形式内部存储，绝对精准无误差。  
-- 格式 DECIMAL(M,D)，M 为总位数，D 为小数位，适合金额等高精度场景。


-- 
--    浮点数与定点数如何对比选择？     
-- 浮点数（FLOAT/DOUBLE）：取值范围大，但不精准，适合科学计算。  
-- 定点数（DECIMAL）：精准无误差，取值范围较小，适合金融、金额计算。


-- 
--    BIT 类型的作用和使用方式？     
-- 用于存储二进制值，M 范围 1~64。  
-- 查询时可用 BIN()、HEX() 或 +0 转为十进制查看。


-- 
--    MySQL 支持哪 5 种日期时间类型？各自主要用途？     
-- YEAR：存储年份  
-- DATE：存储年月日  
-- TIME：存储时分秒（可表示时间间隔）  
-- DATETIME：存储年月日时分秒（最常用）  
-- TIMESTAMP：存储带时区的年月日时分秒
-- 


--    DATETIME 和 TIMESTAMP 的核心区别？     
-- DATETIME：范围大（1000~9999），不受时区影响，存什么显示什么。  
-- TIMESTAMP：范围小（1970~2038），底层存毫秒值，会根据当前时区自动转换显示。


-- 
--    实际开发中日期时间类型如何选择？     
-- 最常用 DATETIME（完整、范围大、使用方便）。  
-- 注册时间等有时使用时间戳便于计算，但文档推荐优先 DATETIME。


-- 
--    CHAR 和 VARCHAR 的主要区别及适用场景？     
-- CHAR：固定长度，自动补空格，检索时自动去除尾部空格，适合短固定内容（如门牌号、UUID）。  
-- VARCHAR：可变长度，保留尾部空格，更节省空间，适合大多数可变字符串。
-- 


--    TEXT 类型有哪几种？共同特点是什么？     
-- TINYTEXT、TEXT、MEDIUMTEXT、LONGTEXT。  
-- 特点：按实际长度存储，不能做主键，不支持默认值，适合较长文本。
-- 


--    ENUM 和 SET 的区别？     
-- ENUM：枚举，只能选择一个值。  
-- SET：集合，可以同时选择多个值（最多 64 个成员）。
-- 


--    BINARY、VARBINARY 和 BLOB 类型的使用建议？     
-- BINARY/VARBINARY：存储二进制字符串。  
-- BLOB：存储二进制大对象（如图片、视频）。  
-- 实际开发中推荐只将文件路径存入数据库，而非直接存 BLOB 内容，避免碎片和传输问题。
-- 


--    JSON 类型有什么特点？     
-- MySQL 5.7 开始支持，8.x 版本优化更好。  
-- 支持 -> 和 ->> 语法提取 JSON 内部数据。
-- 


--    文档中最重要的开发经验有哪些？     
-- 高精度场景（如金额）必须使用 DECIMAL。  
-- 日期时间首选 DATETIME。  
-- 短固定字符串用 CHAR，长可变字符串用 VARCHAR。  
-- TEXT/BLOB 字段建议单独拆表，减少主表碎片。  
-- 选择数据类型时，优先保证可靠性，再考虑节省存储空间。
-- 