
-- todo 数据倾斜概述
/*
数据倾斜问题，通常是指参与计算的数据分布不均，
    即某个key或者某些key的数据量远超其他key，导致在shuffle阶段，大量相同key的数据被发往同一个Reduce，
    进而导致该Reduce所需的时间远超其他Reduce，成为整个任务的瓶颈。
*/

-- todo count distinct 数据倾斜
/*
    使用distinct和count(full aggreates)，这两个函数产生的mr作业只会产生一个reducer，
    而且哪怕显式指定set mapred.reduce.tasks=100000也是没用的。
*/
-- todo 如果在数据量够大，一般是一亿记录数以上(视各位同学公司的集群规模，计算能力而定)，会选择使用count加group by去进行统计
-- 原始SQL
SELECT count(DISTINCT (bill_no)) AS visit_users
FROM i_usoc_user_info_d
WHERE p_day = '20200408' AND bill_no IS NOT NULL
  AND bill_no != ''
;

-- 优化后SQL
SELECT count(a.bill_no)
FROM (
        SELECT bill_no
        FROM dwfu_hive_db.i_usoc_user_info_d
        WHERE p_day = '20200408'
          AND bill_no IS NOT NULL AND bill_no != ''
        GROUP BY bill_no
    ) a
;

-- =============================================================================================
-- =============================================================================================
-- =============================================================================================

-- todo 启动服务
/*
node101启动
    hdp.sh hdfs
    hdp.sh yarn
    hdp.sh history
    hv.sh start
*/


/*
    order_detail表数据中的province_id字段是存在倾斜的，若不经过优化，通过观察任务的执行过程，是能够看出数据倾斜现象的。
*/
-- todo step1. 原始SQL
SELECT
    count(DISTINCT(province_id)) AS province_count
FROM hive_optimize.order_detail
;

-- todo step2. 优化后
--禁用本地执行
set hive.exec.mode.local.auto=false;
-- b. 省份去重
SELECT
    count(t.province_id) AS province_count
FROM (
    -- a. 省份分组，去重
     SELECT
         province_id
     FROM hive_optimize.order_detail
     GROUP BY province_id
) t
;


