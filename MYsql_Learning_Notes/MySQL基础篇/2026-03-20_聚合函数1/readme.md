SQL 聚合函数学习笔记

常用聚合函数
AVG, SUM: 只能用于数值型字段。计算时会自动忽略 NULL 值。
MAX, MIN: 可用于数值、字符串、日期。同样忽略 NULL。
COUNT: 
  COUNT(*): 统计所有行（包含 NULL），效率最高，推荐永远用这个。
  COUNT(字段): 只统计该字段非 NULL 的行数。

分组查询 (GROUP BY)
作用: 将数据按指定字段分类，配合聚合函数使用。
重要规则: 
  SELECT 后面的非聚合字段，必须出现在 GROUP BY 后面。
  GROUP BY 要写在 WHERE 之后，ORDER BY 之前。
WITH ROLLUP: 在分组基础上增加一行“总计”，但用了它就不能再用 ORDER BY。

过滤条件：WHERE vs HAVING
WHERE: 
  在分组前过滤原始数据。
  不能使用聚合函数（如 AVG, COUNT）。
  效率高，优先使用。
HAVING: 
  在分组后过滤统计结果。
  可以使用聚合函数。
  只有当过滤条件涉及聚合函数时才必须用它。

执行顺序口诀
从数据库执行的角度看，顺序是：
FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY -> LIMIT

简单记: 先过滤原始数据 (WHERE)，再分组 (GROUP BY)，最后过滤分组结果 (HAVING)。