
/*
    订单明细表：order_detail 与 支付信息表：payment_detail 相关联join（属于大表关联大表）
*/
CREATE TABLE btj_tmp AS
-- explain formatted
SELECT od.id, od.user_id, product_id, province_id, create_time, product_num, od.total_amount
     , pd.payment_time, pd.total_amount AS pay_total_amount
FROM (
        SELECT id, user_id, product_id, province_id, create_time, product_num, total_amount
        FROM hive_optimize.order_detail
        WHERE dt = '2024-07-01'
    ) od
    LEFT JOIN (
        SELECT id, order_detail_id, user_id, payment_time, total_amount
        FROM hive_optimize.payment_detail
        WHERE dt='2024-07-01'
    ) pd
    ON od.id = pd.order_detail_id;


-- ===================================================================================================
--                                       todo：Bucket Map Join
-- ===================================================================================================
/*
    用于大表join大表的场景
    若能保证参与join的表均为分桶表，且关联字段为分桶字段，且其中一张表的分桶数量是另外一张表分桶数量的整数倍，
    就能保证参与join的两张表的分桶之间具有明确的关联关系，所以就可以在两表的分桶间进行Map Join操作了。
*/
--启用bucket map join优化功能
set hive.optimize.bucketmapjoin = true;

/*
首先需要依据源表创建两个分桶表，order_detail建议分16个bucket，payment_detail建议分8个bucket,注意分桶个数的倍数关系以及分桶字段。
*/
-- ================================ step1. 创建桶表 ================================
--订单表
DROP TABLE IF EXISTS hive_optimize.order_detail_bucketed;
CREATE TABLE hive_optimize.order_detail_bucketed(
    id           STRING COMMENT '订单id',
    user_id      STRING COMMENT '用户id',
    product_id   STRING COMMENT '商品id',
    province_id  STRING COMMENT '省份id',
    create_time  STRING COMMENT '下单时间',
    product_num  INT COMMENT '商品件数',
    total_amount DECIMAL(16, 2) COMMENT '下单金额'
)
CLUSTERED BY (id) INTO 16 BUCKETS
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

--支付表
DROP TABLE IF EXISTS hive_optimize.payment_detail_bucketed;
CREATE TABLE hive_optimize.payment_detail_bucketed(
    id              STRING COMMENT '支付id',
    order_detail_id STRING COMMENT '订单明细id',
    user_id         STRING COMMENT '用户id',
    payment_time    STRING COMMENT '支付时间',
    total_amount    DECIMAL(16, 2) COMMENT '支付金额'
)
CLUSTERED BY (order_detail_id) INTO 8 BUCKETS
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';


-- ================================ step2. 向两个分桶表导入数据 ================================
--订单表
INSERT OVERWRITE TABLE hive_optimize.order_detail_bucketed
SELECT
    id,
    user_id,
    product_id,
    province_id,
    create_time,
    product_num,
    total_amount
FROM hive_optimize.order_detail
WHERE dt='2024-07-01';
-- 查询
SELECT * FROM hive_optimize.order_detail_bucketed LIMIT 10 ;

--分桶表
INSERT OVERWRITE TABLE hive_optimize.payment_detail_bucketed
SELECT
    id,
    order_detail_id,
    user_id,
    payment_time,
    total_amount
FROM hive_optimize.payment_detail
WHERE dt='2024-07-01';
-- 查询
SELECT * FROM hive_optimize.payment_detail_bucketed LIMIT 10 ;

-- ================================ step3. 2个桶表进行关联 ================================
--关闭cbo优化，cbo会导致hint信息被忽略，需将如下参数修改为false
set hive.cbo.enable=false;
--map join hint默认会被忽略(因为已经过时)，需将如下参数修改为false
set hive.ignore.mapjoin.hint=false;
--启用bucket map join优化功能,默认不启用，需将如下参数修改为true
set hive.optimize.bucketmapjoin = true;
--订单明细表与支付表关联join
CREATE TABLE btj_bucket_tmp AS
--EXPLAIN FORMATTED
SELECT od.id, od.user_id, product_id, province_id, create_time, product_num, od.total_amount
     , pd.payment_time, pd.total_amount AS pay_total_amount
FROM hive_optimize.order_detail_bucketed od
LEFT JOIN hive_optimize.payment_detail_bucketed pd ON od.id = pd.order_detail_id
;


-- ===================================================================================================
--                                       todo：Sort Merge Bucket Map Join
-- ===================================================================================================
/*
    Sort Merge Bucket Map Join（简称SMB Map Join）基于Bucket Map Join
        参与join的表均为分桶表，且需保证分桶内的数据是有序的，且分桶字段、排序字段和关联字段为相同字段，
    且其中一张表的分桶数量是另外一张表分桶数量的整数倍。

    Bucket Map Join，两个分桶之间的join实现原理为Hash Join算法；而SMB Map Join，两个分桶之间的join实现原理为Sort Merge Join算法。
        Hash Join的原理相对简单，就是对参与join的一张表构建hash table，然后扫描另外一张表，然后进行逐行匹配。
        Sort Merge Join需要在两张按照关联字段排好序的表中进行.
*/
--启动Sort Merge Bucket Map Join优化
set hive.optimize.bucketmapjoin.sortedmerge=true;
--使用自动转换SMB Join
set hive.auto.convert.sortmerge.join=true;

-- ================================ step1. 依据源表创建两个的有序的分桶表 ================================
/*
order_detail建议分16个bucket，payment_detail建议分8个bucket,注意分桶个数的倍数关系以及分桶字段和排序字段
*/
--订单表
DROP TABLE IF EXISTS hive_optimize.order_detail_sorted_bucketed;
CREATE TABLE hive_optimize.order_detail_sorted_bucketed(
    id           STRING COMMENT '订单id',
    user_id      STRING COMMENT '用户id',
    product_id   STRING COMMENT '商品id',
    province_id  STRING COMMENT '省份id',
    create_time  STRING COMMENT '下单时间',
    product_num  INT COMMENT '商品件数',
    total_amount DECIMAL(16, 2) COMMENT '下单金额'
)
CLUSTERED BY (id) SORTED BY(id) INTO 16 BUCKETS
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

--支付表
DROP TABLE IF EXISTS hive_optimize.payment_detail_sorted_bucketed;
CREATE TABLE hive_optimize.payment_detail_sorted_bucketed(
    id              STRING COMMENT '支付id',
    order_detail_id STRING COMMENT '订单明细id',
    user_id         STRING COMMENT '用户id',
    payment_time    STRING COMMENT '支付时间',
    total_amount    DECIMAL(16, 2) COMMENT '支付金额'
)
CLUSTERED BY (order_detail_id) SORTED BY(order_detail_id) INTO 8 BUCKETS
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';


-- ================================ step2. 向两个分桶表导入数据 ================================
/*
order_detail建议分16个bucket，payment_detail建议分8个bucket,注意分桶个数的倍数关系以及分桶字段和排序字段
*/
--订单表
INSERT OVERWRITE TABLE hive_optimize.order_detail_sorted_bucketed
SELECT
    id,
    user_id,
    product_id,
    province_id,
    create_time,
    product_num,
    total_amount
FROM hive_optimize.order_detail
WHERE dt = '2024-07-01';

--分桶表
INSERT OVERWRITE TABLE hive_optimize.payment_detail_sorted_bucketed
SELECT
    id,
    order_detail_id,
    user_id,
    payment_time,
    total_amount
FROM hive_optimize.payment_detail
WHERE dt = '2024-07-01';


-- ================================ step3. 2个桶表进行关联 ================================
--启动Sort Merge Bucket Map Join优化
set hive.optimize.bucketmapjoin.sortedmerge=true;
--使用自动转换SMB Join
set hive.auto.convert.sortmerge.join=true;
--订单明细表与支付表关联join
CREATE TABLE btj_smb_tmp AS
--EXPLAIN FORMATTED
SELECT od.id, od.user_id, product_id, province_id, create_time, product_num, od.total_amount
     , pd.payment_time, pd.total_amount AS pay_total_amount
FROM hive_optimize.order_detail_sorted_bucketed od
         LEFT JOIN hive_optimize.payment_detail_sorted_bucketed pd ON od.id = pd.order_detail_id
;