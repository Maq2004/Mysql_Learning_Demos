-- 2026-03-08 第一个 MySQL 练习
-- 目标：创建数据库 + 表 + 插入数据 + 简单查询
-- 作者：mmmm

-- 1. 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS learning_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 2. 切换到这个数据库
USE learning_db;

-- 3. 删除旧表（防止重复运行出错，可选）
DROP TABLE IF EXISTS students;

-- 4. 创建学生表
CREATE TABLE students (
    id         INT PRIMARY KEY AUTO_INCREMENT COMMENT '自增主键',
    name       VARCHAR(50) NOT NULL COMMENT '姓名',
    age        INT NOT NULL CHECK (age >= 16 AND age <= 60) COMMENT '年龄',
    score      DECIMAL(4,1) DEFAULT 0.0 COMMENT '成绩',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE = InnoDB 
  DEFAULT CHARSET = utf8mb4 
  COMMENT = '学生信息表';

-- 5. 插入几条测试数据
INSERT INTO students (name, age, score) VALUES
('张三', 19, 88.5),
('李四', 20, 92.0),
('王五', 18, 76.0),
('赵六', 21, 65.5);

-- 6. 几个简单查询练习
SELECT * FROM students;

SELECT name, age, score 
FROM students 
WHERE age >= 19 
ORDER BY score DESC;

SELECT COUNT(*) AS 总人数, AVG(score) AS 平均分 
FROM students;