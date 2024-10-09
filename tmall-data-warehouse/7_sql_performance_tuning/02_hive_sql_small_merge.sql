
/*
todo HiveSQL小文件合并优化，分为两个方面，分别是Map端输入的小文件合并，和Reduce端输出的小文件合并。
*/
-- 1. Map端输入文件合并
/*
合并Map端输入的小文件，是指将多个小文件划分到一个切片中，进而由一个Map Task去处理。
目的是防止为单个小文件启动一个Map Task，浪费计算资源。
*/
--可将多个小文件切片，合并为一个切片，进而由一个map任务处理
set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;


-- 2. Reduce输出文件合并
/*
合并Reduce端输出的小文件，是指将多个小文件合并成大文件。
目的是减少HDFS小文件数量。
其原理是根据计算任务输出文件的平均大小进行判断，若符合条件，则单独启动一个额外的任务进行合并。
*/
--开启合并map only任务输出的小文件
set hive.merge.mapfiles=true;
--开启合并map reduce任务输出的小文件
set hive.merge.mapredfiles=true;
--合并后的文件大小
set hive.merge.size.per.task=256000000;
--触发小文件合并任务的阈值，若某计算任务输出的文件平均大小低于该值，则触发合并
set hive.merge.smallfiles.avgsize=16000000;

-- todo 启动服务
/*
node101启动
    hdp.sh hdfs
    hdp.sh yarn
    hdp.sh history
    hv.sh start
*/

-- ==========================================================================================
-- todo 需求，计算各省份：订单用户数、订单数和订单金额总和
-- ==========================================================================================
-- todo step1. 优化前：默认情况下，该sql语句的Reduce端并行度为5（1.09 * 1024 ÷ 256 = 4.36），故最终输出文件个数也为5，均为小文件
-- 结果表1：order_stats_by_province
DROP TABLE IF EXISTS hive_optimize.order_stats_by_province;
CREATE TABLE hive_optimize.order_stats_by_province(
    province_id STRING COMMENT '省份id',
    user_count BIGINT COMMENT '用户数量',
    order_count BIGINT COMMENT '订单数量',
    order_amount DECIMAL(16, 2) COMMENT '订单金额'
) COMMENT '优化测试表：指标统计结果表【各省份订单金额】'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/order_stats_by_province';

-- SQL查询，并保存数据到表中
INSERT OVERWRITE TABLE hive_optimize.order_stats_by_province
SELECT
    province_id
     , count(DISTINCT user_id) AS user_count
     , count(id) AS order_count
     , sum(total_amount) AS order_amount
FROM hive_optimize.order_detail
GROUP BY province_id;

-- 查看HDFS文件系统目录结构
dfs -ls -R /order_stats_by_province ;
/*
-rw-r--r--   3 bwie supergroup         88 2024-02-19 09:34 /order_stats_by_province/000000_0
-rw-r--r--   3 bwie supergroup         88 2024-02-19 09:34 /order_stats_by_province/000001_0
-rw-r--r--   3 bwie supergroup         84 2024-02-19 09:34 /order_stats_by_province/000002_0
-rw-r--r--   3 bwie supergroup         75 2024-02-19 09:34 /order_stats_by_province/000003_0
-rw-r--r--   3 bwie supergroup         91 2024-02-19 09:34 /order_stats_by_province/000004_0
*/

-- todo step2. 启用Hive合并小文件优化
--开启合并map reduce任务输出的小文件
set hive.merge.mapredfiles=true;
--合并后的文件大小
set hive.merge.size.per.task=256000000;
--触发小文件合并任务的阈值，若某计算任务输出的文件平均大小低于该值，则触发合并
set hive.merge.smallfiles.avgsize=16000000;

-- 结果表2
DROP TABLE IF EXISTS hive_optimize.order_stats_by_province_merge;
CREATE TABLE hive_optimize.order_stats_by_province_merge(
    province_id STRING COMMENT '省份id',
    user_count BIGINT COMMENT '用户数量',
    order_count BIGINT COMMENT '订单数量',
    order_amount DECIMAL(16, 2) COMMENT '订单金额'
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/order_stats_by_province_merge';

-- SQL查询，并保存数据到表中
INSERT OVERWRITE TABLE hive_optimize.order_stats_by_province_merge
SELECT
    province_id
    , count(DISTINCT user_id) AS user_count
    , count(id) AS order_count
    , sum(total_amount) AS order_amount
FROM hive_optimize.order_detail
GROUP BY province_id;

-- -- 查看HDFS文件系统目录结构
dfs -ls -R /order_stats_by_province_merge ;
/*
-rw-r--r--   3 bwie supergroup        426 2024-02-19 09:39 /order_stats_by_province_merge/000000_0
*/

