

/*
（1）DIM层的设计依据是维度建模理论，该层存储维度模型的维度表。
（2）DIM层的数据存储格式为orc列式存储+snappy压缩。
（3）DIM层表名的命名规范为dim_表名_全量表或者拉链表标识（full/zip）。
*/


-- 数据库
CREATE DATABASE IF NOT EXISTS ad_dim ;
USE ad_dim ;


-- todo 9.1 广告信息维度表
DROP TABLE IF EXISTS ad_dim.dim_ads_info_full;
CREATE EXTERNAL TABLE IF NOT EXISTS ad_dim.dim_ads_info_full
(
    ad_id         STRING COMMENT '广告id',
    ad_name       STRING COMMENT '广告名称',
    product_id    STRING COMMENT '广告产品id',
    product_name  STRING COMMENT '广告产品名称',
    product_price DECIMAL(16, 2) COMMENT '广告产品价格',
    material_id   STRING COMMENT '素材id',
    material_url  STRING COMMENT '物料地址',
    group_id      STRING COMMENT '广告组id'
) PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION 'hdfs://node101:8020/warehouse/ad_dim/dim_ads_info_full'
    TBLPROPERTIES ('orc.compress' = 'snappy');


-- todo 9.2 平台信息维度表
DROP TABLE IF EXISTS ad_dim.dim_platform_info_full;
CREATE EXTERNAL TABLE IF NOT EXISTS ad_dim.dim_platform_info_full
(
    id               STRING COMMENT '平台id',
    platform_name_en STRING COMMENT '平台名称(英文)',
    platform_name_zh STRING COMMENT '平台名称(中文)'
) PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION 'hdfs://node101:8020/warehouse/ad_dim/dim_platform_info_full'
    TBLPROPERTIES ('orc.compress' = 'snappy');





