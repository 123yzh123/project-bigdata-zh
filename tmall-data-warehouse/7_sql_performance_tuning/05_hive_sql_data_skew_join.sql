
/*
    未经优化的join操作，默认是使用common join算法，也就是通过一个MapReduce Job完成计算。
        Map端负责读取join操作所需表的数据，并按照关联字段进行分区，通过Shuffle，将其发送到Reduce端，
    相同key的数据在Reduce端完成最终的Join操作。

    todo 如果关联字段的值分布不均，就可能导致大量相同的key进入同一Reduce，从而导致数据倾斜问题。
*/

-- todo 1）map join
/*
    使用map join算法，join操作仅在map端就能完成，没有shuffle操作，没有reduce阶段，自然不会产生reduce端的数据倾斜。

    todo 大表join小表时发生数据倾斜的场景。
*/
--启动Map Join自动转换
set hive.auto.convert.join=true;
--一个Common Join operator转为Map Join operator的判断条件,
--  若该Common Join相关的表中,存在n-1张表的大小总和<=该值,则生成一个Map Join计划,
--  此时可能存在多种n-1张表的组合均满足该条件,则hive会为每种满足条件的组合均生成一个Map Join计划,
--  同时还会保留原有的Common Join计划作为后备(back up)计划,
--  实际运行时,优先执行Map Join计划，若不能执行成功，则启动Common Join后备计划。
set hive.mapjoin.smalltable.filesize=25000000;
--开启无条件转Map Join
set hive.auto.convert.join.noconditionaltask=true;
--无条件转Map Join时的小表之和阈值,若一个Common Join operator相关的表中，
-- 存在n-1张表的大小总和<=该值,此时hive便不会再为每种n-1张表的组合均生成Map Join计划,
-- 同时也不会保留Common Join作为后备计划。而是只生成一个最优的Map Join计划。
set hive.auto.convert.join.noconditionaltask.size=10000000;



-- todo 2）skew join
/*
    skew join的原理是，为倾斜的大key单独启动一个map join任务进行计算，其余key进行正常的common join。

    todo 对参与join的源表大小没有要求，但是对两表中倾斜的key的数据量有要求，要求一张表中的倾斜key的数据量比较小（方便走mapjoin）
*/
--启用skew join优化
set hive.optimize.skewjoin=true;
--触发skew join的阈值，若某个key的行数超过该参数值，则触发
set hive.skewjoin.key=100000;



-- todo 3）调整SQL语句
/*
    倾斜数据的表，key进行打散
    另外一张表，key进行扩容
*/
-- A，B两表均为大表，且其中一张表的数据是倾斜的。
select
    *
from(
    select
        --打散操作
        concat(id,'_',cast(rand()*2 as int)) id
        , value
    from A
)ta
join(
    select
        --扩容操作
        concat(id,'_',0) id,
        value
    from B
    union all
    select
        concat(id,'_',1) id,
        value
    from B
)tb on ta.id=tb.id;



-- =================================================================================================
-- todo order_detail 关联 province_info
-- =================================================================================================
/*
order_detail表中的province_id字段是存在倾斜的，若不经过优化，通过观察任务的执行过程，是能够看出数据倾斜现象的。
*/
SET hive.auto.convert.join = false ;
-- SQL关联
CREATE TABLE tmp0 AS
SELECT
    od.id, user_id, product_id, province_id, create_time, product_num, total_amount,
    pi.province_name
FROM hive_optimize.order_detail od
JOIN hive_optimize.province_info pi ON od.province_id = pi.id;


-- =================================================================================================
-- todo 优化1：map join
--      开启map join以后，mr任务只有map阶段，没有reduce阶段，自然也就不会有数据倾斜发生
-- =================================================================================================
--启用map join
SET hive.auto.convert.join=true;
--关闭skew join
SET hive.optimize.skewjoin=false;
-- SQL关联
CREATE TABLE tmp1 AS
SELECT
    od.id, user_id, product_id, province_id, create_time, product_num, total_amount,
    pi.province_name
FROM hive_optimize.order_detail od
         JOIN hive_optimize.province_info pi ON od.province_id = pi.id;


-- =================================================================================================
-- todo 优化2：skew join
--      开启skew join后，使用explain可以很明显看到执行计划，任务既有common join，又有部分key走了map join。
--      在yarn上最终启动了两个mr任务，而且第二个任务只有map没有reduce阶段，说明第二个任务是对倾斜的key进行了map join
-- =================================================================================================
--启动skew join
SET hive.optimize.skewjoin=true;
--关闭map join
SET hive.auto.convert.join=false;
-- SQL关联
CREATE TABLE tmp2 AS
SELECT
    od.id, user_id, product_id, province_id, create_time, product_num, total_amount,
    pi.province_name
FROM hive_optimize.order_detail od
         JOIN hive_optimize.province_info pi ON od.province_id = pi.id;



-- =================================================================================================
-- todo 优化3：调整SQL语句
--      order_detail 表数据，按照province_id 打散
--      province_info 表数据，按照id 扩容
-- =================================================================================================
--启用map join
SET hive.auto.convert.join=false;
--关闭skew join
SET hive.optimize.skewjoin=false;
-- SQL关联
CREATE TABLE tmp3 AS
SELECT
    od.id, user_id, product_id, province_id, create_time, product_num, total_amount,
    pi.province_name
FROM  (
    -- 1. province_id 打散，加后缀，随机数0-9
    SELECT
        id, user_id, product_id, province_id
        , concat(province_id, '_', cast(rand() * 10 AS int)) AS province_id_new
        , create_time, product_num, total_amount
    FROM hive_optimize.order_detail
) od
JOIN (
    -- 2. id 扩容，加后缀，数字0-9
    SELECT
        concat(id, '_', rnd) AS id_new
        , province_name
    FROM hive_optimize.province_info
        LATERAL VIEW explode(array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)) tmp AS rnd
) pi
ON od.province_id_new = pi.id_new;



