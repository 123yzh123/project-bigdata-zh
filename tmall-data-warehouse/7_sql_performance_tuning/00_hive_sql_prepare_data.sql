

-- todo 数据库
DROP DATABASE IF EXISTS hive_optimize;
CREATE DATABASE IF NOT EXISTS hive_optimize;

-- ===================================================================================
-- todo 1. 省份信息表(34条数据)
-- ===================================================================================
-- 创建表
DROP TABLE IF EXISTS hive_optimize.province_info;
CREATE TABLE hive_optimize.province_info(
    id            STRING COMMENT '省份id',
    province_name STRING COMMENT '省份名称'
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
-- 加载数据，首先将数据文件上传hdfs根目录，再执行加载数据
LOAD DATA INPATH '/province_info.txt' OVERWRITE INTO TABLE hive_optimize.province_info ;
-- 测试
SELECT * FROM hive_optimize.province_info LIMIT 10;


-- ===================================================================================
-- todo 2.  商品信息表(100w条数据)
-- ===================================================================================
DROP TABLE IF EXISTS hive_optimize.product_info;
CREATE TABLE hive_optimize.product_info(
    id           STRING COMMENT '商品id',
    product_name STRING COMMENT '商品名称',
    price        DECIMAL(16, 2) COMMENT '价格',
    category_id  STRING COMMENT '分类id'
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';
-- 加载数据，首先将数据文件上传hdfs根目录，再执行加载数据
LOAD DATA INPATH '/product_info.txt' OVERWRITE INTO TABLE hive_optimize.product_info ;
-- 测试
SELECT * FROM hive_optimize.product_info LIMIT 10;


-- ===================================================================================
-- todo 3. 订单表(2000w条数据)
-- ===================================================================================
DROP TABLE IF EXISTS hive_optimize.order_detail;
CREATE TABLE hive_optimize.order_detail(
    id           STRING COMMENT '订单id',
    user_id      STRING COMMENT '用户id',
    product_id   STRING COMMENT '商品id',
    province_id  STRING COMMENT '省份id',
    create_time  STRING COMMENT '下单时间',
    product_num  INT COMMENT '商品件数',
    total_amount DECIMAL(16, 2) COMMENT '下单金额'
)
    PARTITIONED BY (dt STRING)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

-- 加载数据，首先将数据文件上传hdfs根目录，再执行加载数据
LOAD DATA INPATH '/order_detail.txt'
    OVERWRITE INTO TABLE hive_optimize.order_detail PARTITION(dt='2024-07-01');
-- 测试
SELECT * FROM hive_optimize.order_detail WHERE dt = '2024-07-01' LIMIT 10;


-- ===================================================================================
-- todo 4. 支付表(600w条数据)
-- ===================================================================================
-- 创建表
DROP TABLE IF EXISTS hive_optimize.payment_detail;
CREATE TABLE hive_optimize.payment_detail(
    id              STRING COMMENT '支付id',
    order_detail_id STRING COMMENT '订单明细id',
    user_id         STRING COMMENT '用户id',
    payment_time    STRING COMMENT '支付时间',
    total_amount    DECIMAL(16, 2) COMMENT '支付金额'
)
PARTITIONED BY (dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

-- 加载数据，首先将数据文件上传hdfs根目录，再执行加载数据
LOAD DATA INPATH '/payment_detail.txt'
    OVERWRITE INTO TABLE hive_optimize.payment_detail PARTITION(dt='2024-07-01') ;
-- 测试
SELECT * FROM hive_optimize.payment_detail WHERE dt = '2024-07-01' LIMIT 10;



