
-- todo 数据倾斜概述
/*
数据倾斜问题，通常是指参与计算的数据分布不均，
    即某个key或者某些key的数据量远超其他key，导致在shuffle阶段，大量相同key的数据被发往同一个Reduce，
    进而导致该Reduce所需的时间远超其他Reduce，成为整个任务的瓶颈。
*/

-- todo 1. 分组聚合导致的数据倾斜
/*
如果group by分组字段的值分布不均，就可能导致大量相同的key进入同一Reduce，从而导致数据倾斜问题。
*/
-- 1）Map-Side聚合
/*
    开启Map-Side聚合后，数据先在Map端完成部分聚合工作。
    这样一来即便原始数据是倾斜的，经过Map端的初步聚合后，发往Reduce的数据也就不再倾斜了。
    最佳状态下，Map-端聚合能完全屏蔽数据倾斜问题。
*/
--启用map-side聚合
set hive.map.aggr=true;
--用于检测源表数据是否适合进行map-side聚合。
-- 检测的方法是：先对若干条数据进行map-side聚合，若聚合后的条数和聚合前的条数比值小于该值，则认为该表适合进行map-side聚合；
-- 否则，认为该表数据不适合进行map-side聚合，后续数据便不再进行map-side聚合。
set hive.map.aggr.hash.min.reduction=0.5;
--用于检测源表是否适合map-side聚合的条数。
set hive.groupby.mapaggr.checkinterval=100000;
--map-side聚合所用的hash table，占用map task堆内存的最大比例，若超出该值，则会对hash table进行一次flush。
set hive.map.aggr.hash.force.flush.memory.threshold=0.9;


-- 2）Skew-GroupBy优化
/*
    原理是启动两个MR任务，第一个MR按照随机数分区，将数据分散发送到Reduce，完成部分聚合，第二个MR按照分组字段分区，完成最终聚合。
*/
--启用分组聚合数据倾斜优化
set hive.groupby.skewindata=true;


-- todo 启动服务
/*
node101启动
    hdp.sh hdfs
    hdp.sh yarn
    hdp.sh history
    hv.sh start
*/

/*
该表数据中的province_id字段是存在倾斜的，若不经过优化，通过观察任务的执行过程，是能够看出数据倾斜现象的。
*/

-- todo step1. 优化前
-- hive中的map-side聚合是默认开启的，若想看到数据倾斜的现象，需要先将hive.map.aggr参数设置为false。
SET hive.map.aggr = false ;
-- 示例SQL语句
SELECT
    province_id
     , count(1) AS total_count_all
     , sum(total_amount) AS total_amount_all
FROM hive_optimize.order_detail
GROUP BY province_id;

-- todo step2. Map-Side聚合
--启用map-side聚合
set hive.map.aggr=true;
--关闭skew-groupby
set hive.groupby.skewindata=false;
/*
开启map-side聚合后，reduce数据不再倾斜
*/
SELECT
    province_id
     , count(1) AS total_count_all
     , sum(total_amount) AS total_amount_all
FROM hive_optimize.order_detail
GROUP BY province_id;


-- todo step3. Skew-GroupBy优化
--启用skew-groupby
set hive.groupby.skewindata=true;
--关闭map-side聚合
set hive.map.aggr=false;
--禁用本地执行
set hive.exec.mode.local.auto=false;
/*
开启Skew-GroupBy优化后，可以很明显看到该sql执行在yarn上启动了两个mr任务，
    第一个mr打散数据，第二个mr按照打散后的数据进行分组聚合。
*/
SELECT
    province_id
     , count(1) AS total_count_all
     , sum(total_amount) AS total_amount_all
FROM hive_optimize.order_detail
GROUP BY province_id;


-- todo step4. 编写SQL分开倾斜和非倾斜，各自单独处理，再合并优化
--启用skew-groupby
set hive.groupby.skewindata=false;
--关闭map-side聚合
set hive.map.aggr=false;
--禁用本地执行
set hive.exec.mode.local.auto=false;
/*
    使用group by + count，确定province_id = 1 数据严重倾斜
 */
-- todo 第1、倾斜数据
WITH
    --1.1 加后缀, 新key
    t1 AS (
        SELECT
            *
            , concat(province_id, '_', CAST(rand() * 20 AS INT)) AS province_id_new
        FROM hive_optimize.order_detail
        WHERE province_id = 1
    )
    -- 1.2 新key分组聚合
    , t2 AS (
        SELECT
            province_id_new
            , count(1) AS total_count_all
            , sum(total_amount) AS total_amount_all
        FROM t1
        GROUP BY province_id_new
    )
-- 1.3 还原key, 再进行分组聚合
SELECT
    split(province_id_new, '_')[0] AS province_id
     , sum(total_count_all) AS total_count_all
     , sum(total_amount_all) AS total_amount_all
FROM t2
GROUP BY split(province_id_new, '_')[0]

-- todo 第3、合并结果
UNION ALL

-- todo 第2、非倾斜数据
SELECT
    province_id
     , count(1) AS total_count_all
     , sum(total_amount) AS total_amount_all
FROM hive_optimize.order_detail
WHERE province_id != 1
GROUP BY province_id
;


