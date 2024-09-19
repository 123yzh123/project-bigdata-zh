
-- 创建数据库
CREATE DATABASE IF NOT EXISTS gmall;
-- 使用数据库
USE gmall;
-- 不开启自动收集表统计信息
SET hive.stats.autogather=false;


--===========================================
            --todo 日志表数据加载
--============================================


load data inpath '/origin_data/gmall/log/2024-09-11' into table ods_log_inc partition (dt = '2024-09-11');

--显示分区数目
SHOW PARTITIONS gmall.ods_log_inc;
--查询分区表数据，where过滤日期，limit显示条目数
SELECT *
FROM gmall.ods_log_inc
WHERE dt = '2024-09-12'
LIMIT 10;