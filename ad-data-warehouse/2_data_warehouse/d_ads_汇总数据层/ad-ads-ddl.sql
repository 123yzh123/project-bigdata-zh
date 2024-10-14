/*
所有表：外部表
（1）ADS层的设计参考指标体系。
（2）ADS层表名的命名规范为：ads_主题名称_指标概述。
（3）ADS层每个表中必须有个日期字段：dt，表示数据统计日期
*/


-- 数据库
CREATE DATABASE IF NOT EXISTS ad_ads ;
USE ad_ads ;


-- todo 1 各省市-广告统计
DROP TABLE IF EXISTS ad_ads.ads_ad_stats_by_province;
CREATE EXTERNAL TABLE IF NOT EXISTS ad_ads.ads_ad_stats_by_province
(
    `dt`               STRING COMMENT '统计日期',
    `ad_id`            STRING COMMENT '广告ID',
    `ad_name`          STRING COMMENT '广告名称',
    `client_province`  STRING COMMENT '省份',
    `client_city`      STRING COMMENT '城市',
    `traffic_type`     STRING COMMENT '流量类型：正常或异常',
    `impression_count` BIGINT COMMENT '广告曝光数',
    `click_count`      BIGINT COMMENT '广告点击数',
    `click_rate`       DECIMAL(16, 2) COMMENT '广告点击率，计算公式：广告点击数/广告曝光数'
) COMMENT '各省市广告统计'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION 'hdfs://node101:8020/warehouse/ad_ads/ads_ad_stats_by_province/';


-- todo 2 各广告平台-广告统计
DROP TABLE IF EXISTS ad_ads.ads_ad_stats_by_platform;
CREATE EXTERNAL TABLE IF NOT EXISTS ad_ads.ads_ad_stats_by_platform
(
    `dt`               STRING COMMENT '统计日期',
    `ad_id`            STRING COMMENT '广告ID',
    `ad_name`          STRING COMMENT '广告名称',
    `platform_id`      STRING COMMENT '广告平台ID',
    `platform_name_zh` STRING COMMENT '广告平台中文名称',
    `traffic_type`     STRING COMMENT '流量类型：正常或异常',
    `impression_count` BIGINT COMMENT '广告曝光数',
    `click_count`      BIGINT COMMENT '广告点击数',
    `click_rate`       DECIMAL(16, 2) COMMENT '广告点击率，计算公式：广告点击数/广告曝光数'
) COMMENT '各广告平台广告统计'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION 'hdfs://node101:8020/warehouse/ad_ads/ads_ad_stats_by_platform/';


-- todo 3 各操作系统-广告统计
DROP TABLE IF EXISTS ad_ads.ads_ad_stats_by_os;
CREATE EXTERNAL TABLE IF NOT EXISTS ad_ads.ads_ad_stats_by_os
(
    `dt`               STRING COMMENT '统计日期',
    `ad_id`            STRING COMMENT '广告ID',
    `ad_name`          STRING COMMENT '广告名称',
    `client_os_type`   STRING COMMENT '操作系统类型',
    `traffic_type`     STRING COMMENT '流量类型：正常或异常',
    `impression_count` BIGINT COMMENT '广告曝光数',
    `click_count`      BIGINT COMMENT '广告点击数'
) COMMENT '各广告平台广告统计'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION 'hdfs://node101:8020/warehouse/ad_ads/ads_ad_stats_by_os/';


-- todo 4 各小时-广告统计
DROP TABLE IF EXISTS ad_ads.ads_ad_stats_by_hour;
CREATE EXTERNAL TABLE IF NOT EXISTS ad_ads.ads_ad_stats_by_hour
(
    `dt`               STRING COMMENT '统计日期',
    `ad_id`            STRING COMMENT '广告ID',
    `ad_name`          STRING COMMENT '广告名称',
    `pre_hour`         STRING COMMENT '每小时',
    `traffic_type`     STRING COMMENT '流量类型：正常或异常',
    `impression_count` BIGINT COMMENT '广告曝光数',
    `click_count`      BIGINT COMMENT '广告点击数'
) COMMENT '各广告平台广告统计'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION 'hdfs://node101:8020/warehouse/ad_ads/ads_ad_stats_by_hour/';
