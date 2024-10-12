
/*
ODS层的设计要点如下：
（1）ODS层的表结构设计依托于从业务系统同步过来的数据结构。
（2）ODS层要保存全部历史数据，故其压缩格式应选择压缩比较高的，此处选择gzip。
（3）ODS层表名的命名规范为：ods_表名_单分区增量全量标识（inc/full）。
*/

-- 数据库
CREATE DATABASE IF NOT EXISTS ad_ods ;
USE ad_ods ;


-- todo 8.1 广告信息表
DROP TABLE IF EXISTS ad_ods.ods_ads_info_full;
CREATE EXTERNAL TABLE IF NOT EXISTS ad_ods.ods_ads_info_full
(
    id           STRING COMMENT '广告编号',
    product_id   STRING COMMENT '产品id',
    material_id  STRING COMMENT '素材id',
    group_id     STRING COMMENT '广告组id',
    ad_name      STRING COMMENT '广告名称',
    material_url STRING COMMENT '素材地址'
) PARTITIONED BY (`dt` STRING)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION 'hdfs://node101:8020/warehouse/ad_ods/ods_ads_info_full';


-- todo 8.2 推广平台表
DROP TABLE IF EXISTS ad_ods.ods_platform_info_full;
CREATE EXTERNAL TABLE IF NOT EXISTS ad_ods.ods_platform_info_full
(
    id               STRING COMMENT '平台id',
    platform_name_en STRING COMMENT '平台名称(英文)',
    platform_name_zh STRING COMMENT '平台名称(中文)'
) PARTITIONED BY (`dt` STRING)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION 'hdfs://node101:8020/warehouse/ad_ods/ods_platform_info_full';


-- todo 8.3 产品表
DROP TABLE IF EXISTS ad_ods.ods_product_info_full;
CREATE EXTERNAL TABLE IF NOT EXISTS ad_ods.ods_product_info_full
(
    id    STRING COMMENT '产品id',
    name  STRING COMMENT '产品名称',
    price decimal(16, 2) comment '产品价格'
) PARTITIONED BY (`dt` STRING)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION 'hdfs://node101:8020/warehouse/ad_ods/ods_product_info_full';


-- todo 8.4 广告投放表
DROP TABLE IF EXISTS ad_ods.ods_ads_platform_full;
CREATE EXTERNAL TABLE IF NOT EXISTS ad_ods.ods_ads_platform_full
(
    id          STRING COMMENT '编号',
    ad_id       STRING COMMENT '广告id',
    platform_id STRING COMMENT '平台id',
    create_time STRING COMMENT '创建时间',
    cancel_time STRING COMMENT '取消时间'
) PARTITIONED BY (`dt` STRING)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION 'hdfs://node101:8020/warehouse/ad_ods/ods_ads_platform_full';


-- todo 8.5 日志服务器列表
DROP TABLE IF EXISTS ad_ods.ods_server_host_full;
CREATE EXTERNAL TABLE IF NOT EXISTS ad_ods.ods_server_host_full
(
    id   STRING comment '编号',
    ipv4 STRING comment 'ipv4地址'
) PARTITIONED BY (`dt` STRING)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION 'hdfs://node101:8020/warehouse/ad_ods/ods_server_host_full';


-- todo 8.6 广告监测日志表
DROP TABLE IF EXISTS ad_ods.ods_ad_log_inc;
CREATE EXTERNAL TABLE IF NOT EXISTS ad_ods.ods_ad_log_inc
(
    time_local     STRING COMMENT '日志服务器收到的请求的时间',
    request_method STRING COMMENT 'HTTP请求方法',
    request_uri    STRING COMMENT '请求路径',
    status         STRING COMMENT '日志服务器相应状态',
    server_addr    STRING COMMENT '日志服务器自身ip'
) PARTITIONED BY (`dt` STRING)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\u0001'
    LOCATION 'hdfs://node101:8020/warehouse/ad_ods/ods_ad_log_inc';

