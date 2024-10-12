
-- 使用数据库
USE ad_ods ;


-- todo 8.1 广告信息表ods_ads_info_full
LOAD DATA INPATH '/origin_data/ad/ads_full/2024-10-10'
    OVERWRITE INTO TABLE ad_ods.ods_ads_info_full PARTITION (dt = '2024-10-10') ;

SHOW PARTITIONS ad_ods.ods_ads_info_full;
SELECT * FROM ad_ods.ods_ads_info_full WHERE dt = '2024-10-10' ;


-- todo 8.2 推广平台表ods_platform_info_full
LOAD DATA INPATH '/origin_data/ad/platform_info_full/2024-10-10'
    OVERWRITE INTO TABLE ad_ods.ods_platform_info_full PARTITION (dt = '2024-10-10') ;

SHOW PARTITIONS ad_ods.ods_platform_info_full;
SELECT * FROM ad_ods.ods_platform_info_full WHERE dt = '2024-10-10' ;


-- todo 8.3 产品表ods_product_info_full
LOAD DATA INPATH '/origin_data/ad/product_full/2024-10-10'
    OVERWRITE INTO TABLE ad_ods.ods_product_info_full PARTITION (dt = '2024-10-10') ;

SHOW PARTITIONS ad_ods.ods_product_info_full;
SELECT * FROM ad_ods.ods_product_info_full WHERE dt = '2024-10-10' ;


-- todo 8.4 广告投放表ods_ads_platform_full
LOAD DATA INPATH '/origin_data/ad/ads_platform_full/2024-10-10'
    OVERWRITE INTO TABLE ad_ods.ods_ads_platform_full PARTITION (dt = '2024-10-10') ;

SHOW PARTITIONS ad_ods.ods_ads_platform_full;
SELECT * FROM ad_ods.ods_ads_platform_full WHERE dt = '2024-10-10' ;


-- todo 8.5 日志服务器列表ods_server_host_full
LOAD DATA INPATH '/origin_data/ad/server_host_full/2024-10-01'
    OVERWRITE INTO TABLE ad_ods.ods_server_host_full PARTITION (dt = '2024-10-01') ;

SHOW PARTITIONS ad_ods.ods_server_host_full;
SELECT * FROM ad_ods.ods_server_host_full WHERE dt = '2024-10-01' ;


-- todo 8.6 广告监测日志表ods_ad_log_inc
LOAD DATA INPATH '/origin_data/ad/log/2024-10-01'
    OVERWRITE INTO TABLE ad_ods.ods_ad_log_inc PARTITION (dt = '2024-10-01') ;

SHOW PARTITIONS ad_ods.ods_ad_log_inc;
SELECT * FROM ad_ods.ods_ad_log_inc WHERE dt = '2024-10-09' ;


