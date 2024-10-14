
-- todo 为方便报表应用使用数据，需将ads各指标的统计结果导出到MySQL数据库中。
--
-- 1 创建数据库  (mysql 连接node103 )
DROP DATABASE IF EXISTS ad_report;
CREATE DATABASE IF NOT EXISTS ad_report DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_general_ci;


use ad_report;
-- 1.各渠道流量统计
DROP TABLE IF EXISTS `ad_report`.`ads_ad_stats_by_province`;
CREATE TABLE `ad_report`.`ads_ad_stats_by_province`
(
    `dt`               DATE           NOT NULL COMMENT '统计日期',
    `ad_id`            VARCHAr(64)    NOT NULL COMMENT '广告ID',
    `ad_name`          VARCHAr(32)    NOT NULL COMMENT '广告名称',
    `client_province`  VARCHAr(16)    NOT NULL COMMENT '省份',
    `client_city`      VARCHAr(16)    NOT NULL COMMENT '城市',
    `traffic_type`     VARCHAr(16)    NOT NULL COMMENT '流量类型：正常或异常',
    `impression_count` BIGINT         DEFAULT NULL COMMENT '广告曝光数',
    `click_count`      BIGINT         DEFAULT NULL COMMENT '广告点击数',
    `click_rate`       DECIMAL(16, 2) DEFAULT NULL COMMENT '广告点击率，计算公式：广告点击数/广告曝光数',
    PRIMARY KEY (`dt`, `ad_id`, `ad_name`, `client_province`, `client_city`, `traffic_type`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT = '各省市广告统计'
  ROW_FORMAT = DYNAMIC;

-- todo 2 各广告平台-广告统计
DROP TABLE IF EXISTS `ad_report`.`ads_ad_stats_by_platform`;
CREATE TABLE `ad_report`.`ads_ad_stats_by_platform`
(
    `dt`               DATE    NOT NULL COMMENT '统计日期',
    `ad_id`            VARCHAr(64)    NOT NULL COMMENT '广告ID',
    `ad_name`          VARCHAr(64)    NOT NULL COMMENT '广告名称',
    `platform_id`      VARCHAr(64)    NOT NULL COMMENT '广告平台ID',
    `platform_name_zh` VARCHAr(64)    NOT NULL COMMENT '广告平台中文名称',
    `traffic_type`     VARCHAr(64)    NOT NULL COMMENT '流量类型：正常或异常',
    `impression_count` BIGINT DEFAULT NULL COMMENT '广告曝光数',
    `click_count`      BIGINT DEFAULT NULL COMMENT '广告点击数',
    `click_rate`       DECIMAL(16, 2) DEFAULT NULL COMMENT '广告点击率，计算公式：广告点击数/广告曝光数'
)ENGINE = InnoDB
 CHARACTER SET = utf8mb4
 COLLATE = utf8mb4_general_ci COMMENT = '各广告平台广告统计'
 ROW_FORMAT = DYNAMIC;


-- todo 3 各操作系统-广告统计
DROP TABLE IF EXISTS `ad_report`.`ads_ad_stats_by_os`;
CREATE TABLE `ad_report`.`ads_ad_stats_by_os`
(
    `dt`               DATE    NOT NULL COMMENT '统计日期',
    `ad_id`            VARCHAr(64)    NOT NULL COMMENT '广告ID',
    `ad_name`          VARCHAr(64)    NOT NULL COMMENT '广告名称',
    `client_os_type`   VARCHAr(64)    NOT NULL COMMENT '操作系统类型',
    `traffic_type`     VARCHAr(64)    NOT NULL COMMENT '流量类型：正常或异常',
    `impression_count` BIGINT DEFAULT NULL COMMENT '广告曝光数',
    `click_count`      BIGINT DEFAULT NULL COMMENT '广告点击数'
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT = '各操作系统广告统计'
  ROW_FORMAT = DYNAMIC;


-- todo 4 各小时-广告统计
DROP TABLE IF EXISTS `ad_report`.`ads_ad_stats_by_hour`;
CREATE TABLE `ad_report`.`ads_ad_stats_by_hour`
(
    `dt`               DATE    NOT NULL COMMENT '统计日期',
    `ad_id`            VARCHAr(64)    NOT NULL COMMENT '广告ID',
    `ad_name`          VARCHAr(64)    NOT NULL COMMENT '广告名称',
    `pre_hour`         VARCHAr(64)    NOT NULL COMMENT '每小时',
    `traffic_type`     VARCHAr(64)    NOT NULL COMMENT '流量类型：正常或异常',
    `impression_count` BIGINT DEFAULT NULL COMMENT '广告曝光数',
    `click_count`      BIGINT DEFAULT NULL COMMENT '广告点击数'
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT = '各小时广告统计'
  ROW_FORMAT = DYNAMIC;



# --使用DataX  将数据导出到mysql的表中  （以上代码已建库建表）
#  ssh node102 "source /etc/profile; python /opt/module/datax/bin/datax.py -p'-Dexportdir=/warehouse/ad_ads/ads_ad_stats_by_hour' /opt/module/datax/job/export.ad_report.ads_ad_stats_by_hour.json"
#  ssh node102 "source /etc/profile; python /opt/module/datax/bin/datax.py -p'-Dexportdir=/warehouse/ad_ads/ads_ad_stats_by_os' /opt/module/datax/job/export.ad_report.ads_ad_stats_by_os.json"
#  ssh node102 "source /etc/profile; python /opt/module/datax/bin/datax.py -p'-Dexportdir=/warehouse/ad_ads/ads_ad_stats_by_platform' /opt/module/datax/job/export.ad_report.ads_ad_stats_by_platform.json"
#  ssh node102 "source /etc/profile; python /opt/module/datax/bin/datax.py -p'-Dexportdir=/warehouse/ad_ads/ads_ad_stats_by_province' /opt/module/datax/job/export.ad_report.ads_ad_stats_by_province.json"



