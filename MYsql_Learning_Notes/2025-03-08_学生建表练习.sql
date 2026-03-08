-- 2026-03-08 MySQL 基础练习 - 学生表
-- 作者：Maq2004
-- 说明：创建数据库、表、插入数据、简单查询

-- 1. 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS school CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. 切换数据库
USE school;

-- 3. 删除旧表（可选，测试用）
DROP TABLE IF EXISTS students;

-- 4. 创建学生表
CREATE TABLE students (
    id         INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键自增',
    name       VARCHAR(50) NOT NULL COMMENT '姓名',
    age        INT CHECK (age >= 16 AND age <= 60) COMMENT '年龄',
    gender     ENUM('男', '女', '其他') DEFAULT '男' COMMENT '性别',
    score      DECIMAL(5,2) DEFAULT 0.00 COMMENT '成绩',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生信息表';

-- 5. 插入测试数据
INSERT INTO students (name, age, gender, score) VALUES
('张三', 20, '男', 88.50),
('李四', 19, '女', 92.00),
('王五', 21, '男', 76.75),
('赵六', 18, '其他', 65.00),
('孙七', 22, '男', 95.25);

-- 6. 查询练习
SELECT * FROM students;
SELECT name, score FROM students WHERE age >= 20 ORDER BY score DESC;
SELECT COUNT(*) AS total, AVG(score) AS avg_score FROM students;