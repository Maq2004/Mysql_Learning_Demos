CREATE DATABASE dbtest_04_12;

USE dbtest_04_12;


CREATE TABLE if not exists rewards (
    adventurer_id INT,
    adventurer_name VARCHAR(50),
    task_id INT,
    task_name VARCHAR(100),
    reward_coins INT
);

INSERT INTO rewards (adventurer_id, adventurer_name, task_id, task_name, reward_coins)
VALUES
    (1, 'Alice', 101, 'Dragon Slaying', 500),
    (1, 'Alice', 102, 'Treasure Hunt', 300),
    (1, 'Alice', 103, 'Rescue Mission', 200),
    (2, 'Bob', 101, 'Dragon Slaying', 600),
    (2, 'Bob', 102, 'Treasure Hunt', 400),
    (3, 'Charlie', 103, 'Rescue Mission', 250),
    (4, 'David', 101, 'Dragon Slaying', 450),
    (4, 'David', 102, 'Treasure Hunt', 350),
    (4, 'David', 103, 'Rescue Mission', 150),
    (5, 'Eve', 101, 'Dragon Slaying', 700),
    (5, 'Eve', 102, 'Treasure Hunt', 250);
		
-- 		请你编写一条 SQL 查询语句，依次输出每个冒险者的 id（adventurer_id）、冒险者姓名（adventurer_name）、获得的总金币奖励（total_reward_coins），并按照总金币奖励从高到低排序，其中只列出总金币奖励排名前 3 的冒险者

SELECT * FROM rewards;

SELECT adventurer_id,adventurer_name, SUM(reward_coins) AS total_reward_coins from rewards GROUP BY adventurer_id,adventurer_name LIMIT 0 , 3;







-- 假设有一家魔法学院，里面有许多学员在不同科目上进行学习和考试。请你设计一张名为magic_scores的表格，用于记录每位学员在不同科目中的考试成绩情况。表格字段如下：
-- 
-- student_id：学员ID，唯一标识每位学员。
-- student_name：学员姓名。
-- subject_id：科目ID，唯一标识每个科目。
-- subject_name：科目名称。
-- score：学员在该科目的考试成绩。
-- 请你编写一条 SQL 查询语句，依次输出每位学员的学院 ID（student_id）、学员姓名（student_name）、科目 ID（subject_id）、科目名称（subject_name）、学员在该科目的考试成绩（score）、该学员在每个科目中的成绩排名（score_rank），并将结果按照成绩从高到低进行排序。
-- 

CREATE TABLE IF NOT EXISTS magic_scores(
	student_id INT PRIMARY KEY,
	studnet_name VARCHAR(25),
	subject_id INT UNIQUE,
	subject_name VARCHAR(25),
	score int
);
SELECT
	student_id '学院ID',
	student_name '学院姓名',
	subject_id '科目',
	subject_name '科目名称',
	score,
	RANK() over (
	PARTITION BY subject_id ORDER BY score DESC)
	FROM magic_scores;
	
	
-- 	在神秘的海岛上，有一只传说中的大浪淘鸡，它身躯高大威武，羽毛闪烁着神秘的光芒。岛上的居民都传说大浪淘鸡是海洋之神的化身，它能够操纵海浪，带来平静或狂暴的海洋。为了验证这个传说是否属实，岛上的居民决定对大浪淘鸡进行观测和记录。
-- 
-- 有一张 chicken_observation 的表格，用于记录居民观测大浪淘鸡的信息。表格字段如下：
-- 
-- observation_id：观测记录ID，唯一标识每条观测记录
-- observer_name：观测者姓名
-- observation_date：观测日期
-- observation_location：观测地点
-- wave_intensity：观测到的海浪强度，用整数表示，数值越大，海浪越狂暴
-- 请你编写一条 SQL 查询语句，找出观测地点包含 "大浪淘鸡" 且海浪强度超过 5 的观测记录，并依次输出每位观测者的姓名（observer_name）、观测日期（observation_date）以及观测到的海浪强度（wave_intensity）。
-- 

SELECT
	observer_name,
	observation_date,
	wave_intensity 
FROM
	chicken_observation 
WHERE
	observation_location LIKE '%大浪淘鸡%' 
	AND wave_intensity > 5;
 
--  
--  我们有一个订单明细表 order_items，记录了每个订单中购买的商品信息：
-- 
-- order_id：订单编号
-- product_id：商品编号
-- product_name：商品名称
-- category：商品分类
-- price：商品单价
-- quantity：购买数量
-- order_date：下单日期
-- 任务要求
-- 老板想要知道每个商品分类的销售情况，请你编写SQL查询：
-- 
-- 统计每个商品分类的总销售额（price * quantity 的总和）
-- 统计每个商品分类的总销售数量
-- 按总销售额从高到低排序
-- 返回字段：分类名称（category）、总销售额（total_revenue）、总销售数量（total_quantity）

SELECT
	category,
	SUM( price * quantity ) AS total_revenue,
	SUM( quantity ) AS total_quantity 
FROM
	order_items 
GROUP BY
	category 
ORDER BY
	total_revenue;
 


-- 我们有一个游戏记录表 game_matches，记录了召唤师们的对局信息：
-- 
-- match_id：对局ID
-- player_id：玩家ID
-- player_name：玩家昵称
-- hero_name：使用英雄
-- hero_role：英雄定位（战士、法师、射手、辅助、坦克、刺客）
-- game_result：游戏结果（胜利/失败）

-- kills：击杀数
-- deaths：死亡数
-- assists：助攻数

-- game_duration：游戏时长（分钟）
-- match_date：对局日期
-- 任务要求
-- 运营团队想要了解英雄的表现情况，请你编写SQL查询：
-- 
-- 统计每个英雄定位的胜率（胜利场次/总场次*100）
-- 计算每个英雄定位的平均KDA（(击杀+助攻)/死亡）
-- 统计每个英雄定位的总对局数
-- 只显示对局数大于等于5场的英雄定位
-- 按胜率降序排列
-- 返回字段：英雄定位（hero_role）、胜率（win_rate，保留1位小数，加%符号）、平均KDA（avg_kda，保留2位小数）、总对局数（total_matches）

SELECT hero_role,
  CONCAT(ROUND( SUM(CASE WHEN game_result = '胜利'  THEN 1 ELSE 0 END) / COUNT(*) * 100 , 1) , '%') win_rate,
 ROUND(AVG( (kills + assists) * 1.0 /  CASE WHEN deaths = 0 THEN 1 ELSE deaths END ),2)  avg_kda,
 COUNT(*) total_matches 
FROM
	game_matches
GROUP BY
	hero_role
HAVING
	total_matches >= 5
ORDER BY
	ROUND( SUM(CASE WHEN game_result = '胜利'  THEN 1 ELSE 0 END) / COUNT(*), 1) DESC;
	
	
	CREATE TABLE if not exists game_matches (
    match_id INT PRIMARY KEY,
    player_id INT,
    player_name VARCHAR(50),
    hero_name VARCHAR(50),
    hero_role VARCHAR(20),
    game_result VARCHAR(10),
    kills INT,
    deaths INT,
    assists INT,
    game_duration INT,
    match_date DATE
);

INSERT INTO game_matches (match_id, player_id, player_name, hero_name, hero_role, game_result, kills, deaths, assists, game_duration, match_date) VALUES
-- 战士英雄
(1, 1001, '鱼皮', '亚瑟', '战士', '胜利', 8, 3, 5, 25, '2024-01-01'),
(2, 1002, '小明', '吕布', '战士', '胜利', 12, 4, 3, 28, '2024-01-01'),
(3, 1003, '小红', '花木兰', '战士', '失败', 6, 8, 4, 32, '2024-01-02'),
(4, 1001, '鱼皮', '亚瑟', '战士', '胜利', 10, 2, 8, 22, '2024-01-02'),
(5, 1004, '小刚', '典韦', '战士', '失败', 5, 7, 2, 30, '2024-01-03'),
(6, 1002, '小明', '吕布', '战士', '胜利', 15, 3, 6, 26, '2024-01-03'),
(7, 1005, '小李', '橘右京', '战士', '胜利', 9, 4, 7, 24, '2024-01-04'),

-- 法师英雄
(11, 1003, '小红', '妲己', '法师', '胜利', 7, 2, 12, 23, '2024-01-05'),
(12, 1006, '小王', '王昭君', '法师', '失败', 4, 6, 8, 29, '2024-01-05'),
(13, 1007, '小张', '安琪拉', '法师', '胜利', 11, 3, 9, 21, '2024-01-06'),
(14, 1003, '小红', '妲己', '法师', '胜利', 9, 1, 15, 20, '2024-01-06'),
(15, 1008, '小赵', '诸葛亮', '法师', '失败', 6, 5, 7, 35, '2024-01-07'),
(16, 1006, '小王', '王昭君', '法师', '胜利', 8, 3, 11, 27, '2024-01-07'),

-- 射手英雄
(21, 1009, '小陈', '后羿', '射手', '胜利', 13, 2, 4, 24, '2024-01-08'),
(22, 1010, '小周', '鲁班七号', '射手', '失败', 5, 8, 3, 31, '2024-01-08'),
(23, 1011, '小吴', '孙尚香', '射手', '胜利', 10, 3, 6, 26, '2024-01-09'),
(24, 1009, '小陈', '后羿', '射手', '胜利', 14, 1, 5, 22, '2024-01-09'),
(25, 1012, '小孙', '马可波罗', '射手', '失败', 7, 6, 4, 33, '2024-01-10'),
(26, 1010, '小周', '鲁班七号', '射手', '胜利', 9, 4, 7, 28, '2024-01-10'),

-- 辅助英雄  
(31, 1013, '小钱', '蔡文姬', '辅助', '胜利', 2, 3, 18, 25, '2024-01-11'),
(32, 1014, '小余', '庄周', '辅助', '胜利', 1, 2, 20, 23, '2024-01-11'),
(33, 1015, '小郑', '孙膑', '辅助', '失败', 3, 5, 12, 29, '2024-01-12'),
(34, 1013, '小钱', '蔡文姬', '辅助', '胜利', 0, 4, 16, 27, '2024-01-12'),
(35, 1016, '小何', '瑶', '辅助', '失败', 2, 6, 10, 34, '2024-01-13'),

-- 坦克英雄
(41, 1017, '小沈', '廉颇', '坦克', '胜利', 4, 5, 14, 26, '2024-01-14'),
(42, 1018, '小韩', '项羽', '坦克', '失败', 2, 8, 8, 32, '2024-01-14'),
(43, 1019, '小冯', '白起', '坦克', '胜利', 3, 4, 16, 24, '2024-01-15'),
(44, 1017, '小沈', '廉颇', '坦克', '胜利', 5, 3, 12, 22, '2024-01-15'),
(45, 1020, '小朱', '刘邦', '坦克', '失败', 1, 7, 9, 35, '2024-01-16'),

-- 刺客英雄
(51, 1021, '小卫', '兰陵王', '刺客', '胜利', 16, 4, 2, 21, '2024-01-17'),
(52, 1022, '小蒋', '韩信', '刺客', '失败', 8, 9, 5, 33, '2024-01-17'),
(53, 1023, '小褚', '阿轲', '刺客', '胜利', 14, 3, 4, 19, '2024-01-18'),
(54, 1021, '小卫', '兰陵王', '刺客', '胜利', 18, 2, 1, 18, '2024-01-18'),
(55, 1024, '小魏', '李白', '刺客', '失败', 10, 7, 3, 28, '2024-01-19'); 




-- 窗口函数

 -- 1.  SUM(计算字段名) OVER (PARTITION BY 分组字段名)
-- 按分组字段名分组，算出每个组的 '计算字段名' 字段的和，然后把这个总数重复写在该组的每一行旁边。”
-- 分组后行数不变（这是和 GROUP BY 最大的不同）
-- 同一个组内的每一行，看到的汇总值完全相同
SELECT
	hero_name,
	kills,
	deaths,
	assists,
	SUM( kills ) OVER ( PARTITION BY hero_role ) -- 以 hero_role 分组，将每个组的kills加起来放入每条结果的后面
FROM
	game_matches;






-- 累加求和
-- 2. SUM(计算字段名) OVER (PARTITION BY 分组字段名 ORDER BY 排序字段 排序规则)
-- 当在开窗函数中加入 ORDER BY 时：
-- 
-- 窗口不再是“整个分组一次性计算”
-- 而是变成了从排序后的第一行开始，一行一行累加到当前行
-- 每处理一行，就把当前行的值加到前面所有行的总和上
-- 
-- 这就是为什么加了 ORDER BY 就自动变成累加求和（Cumulative Sum）。
SELECT 
    hero_role,
    match_date,
    player_name,
    hero_name,
    kills,
    -- 每个英雄定位的总击杀数（不累计）
    SUM(kills) OVER (PARTITION BY hero_role) AS total_kills,
    
    -- 按日期累计的击杀数（ORDER BY累加）
    SUM(kills) OVER (PARTITION BY hero_role 
                     ORDER BY match_date) AS leijia_kills
    
FROM game_matches
ORDER BY hero_role, match_date;


SELECT * FROM game_matches;



-- 排名， 但是相同值 的 名次一致
-- 同样，先按组分， 然后以kills 排名 DESC降序， 默认升序
-- RANK() OVER (PARATION BY 分组的列 ORDER BY 排名的列)
SELECT hero_name , hero_role , kills , RANK() OVER (PARTITION BY hero_role ORDER BY kills DESC ) FROM game_matches;


-- 排名， 但是相同值 的 名次不一致，每一行都有一个唯一的行号，从 1 开始连续递增。
-- 同样，先按组分， 然后以kills 排名 DESC降序， 默认升序
-- ROW_NUMBER() OVER (PARATION BY 分组的列 ORDER BY 排名的列)
SELECT hero_name , hero_role , kills , ROW_NUMBER() OVER (PARTITION BY hero_role ORDER BY kills DESC ) FROM game_matches;



--  Lag 和 Lead 的作用是获取在当前行之前或之后的行的值，这两个函数通常在需要比较相邻行数据或进行时间序列分析时非常有用

-- LAG(column_name, offset, default_value) OVER (PARTITION BY partition_column ORDER BY sort_column)
-- column_name：要获取值的列名。
-- offset：表示要向上偏移的行数。例如，offset为1表示获取上一行的值，offset为2表示获取上两行的值，以此类推。
-- default_value：可选参数，用于指定当没有前一行时的默认值。
-- PARTITION BY和ORDER BY子句可选，用于分组和排序数据。

SELECT hero_name , hero_role , kills , LAG(kills , 1 , NULL) OVER (PARTITION BY hero_role ORDER BY kills DESC) -- 意思是上一行的kills值 
FROM game_matches;

-- LEAD同上  LAG(column_name, offset, default_value) OVER (PARTITION BY partition_column ORDER BY sort_column)
-- 但是取的是下一行的值
SELECT hero_name , hero_role , kills , LEAD(kills , 1 , NULL) OVER (PARTITION BY hero_role ORDER BY kills DESC) -- 意思是下一行的kills值 
FROM game_matches;



		