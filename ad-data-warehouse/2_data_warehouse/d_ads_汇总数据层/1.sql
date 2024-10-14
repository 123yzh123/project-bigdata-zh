-- 使用数据库
USE ad_dim ;

-- todo 1 各省市-广告统计
INSERT OVERWRITE TABLE ad_ads.ads_ad_stats_by_province
SELECT
    dt
     ,ad_id
     ,ad_name
     ,client_province
     ,client_city
     ,`if`(is_invalid_traffic, '正常', '异常') AS traffic_type
     ,sum(`if`(event_type='impression',1,0)) AS impression_count
     ,sum(`if`(event_type='click',1,0)) AS click_count
     ,round(sum(`if`(event_type='click',1,0))/sum(`if`(event_type='impression',1,0)),2) AS click_rate
FROM ad_dwd.dwd_ad_event_inc
WHERE dt='2024-10-04'
GROUP BY dt, ad_id, ad_name, client_province, client_city, is_invalid_traffic;

-- SHOW PARTITIONS ad_ads.ads_ad_stats_by_province;
SELECT * FROM ad_ads.ads_ad_stats_by_province WHERE dt = '2024-10-04';

-- todo 2 各广告平台-广告统计
INSERT OVERWRITE TABLE ad_ads.ads_ad_stats_by_platform
SELECT
    dt
     , ad_id
     , ad_name
     , platform_id
     , platform_name_zh
     , `if`(is_invalid_traffic, '正常', '异常') AS traffic_type
     , sum(`if`(event_type='impression',1,0)) AS impression_count
     , sum(`if`(event_type='click',1,0)) AS click_count
     , round(sum(`if`(event_type='click',1,0))/sum(`if`(event_type='impression',1,0)),2) AS click_rate
FROM ad_dwd.dwd_ad_event_inc
WHERE dt='2024-10-04'
GROUP BY dt, ad_id, ad_name, platform_id, platform_name_zh, is_invalid_traffic;

-- SHOW PARTITIONS ad_ads.ads_ad_stats_by_platform;
SELECT * FROM ad_ads.ads_ad_stats_by_platform WHERE dt = '2024-10-04';

-- todo 3 各操作系统-广告统计
INSERT OVERWRITE TABLE ad_ads.ads_ad_stats_by_os
SELECT
    dt
     , ad_id
     , ad_name
     , client_os_type
     , `if`(is_invalid_traffic, '正常', '异常') AS traffic_type
     , sum(`if`(event_type='impression',1,0)) AS impression_count
     , sum(`if`(event_type='click',1,0)) AS click_count
FROM ad_dwd.dwd_ad_event_inc
WHERE dt='2024-10-04'
GROUP BY dt, ad_id, ad_name, client_os_type, is_invalid_traffic
;

-- SHOW PARTITIONS ad_ads.ads_ad_stats_by_os;
SELECT * FROM ad_ads.ads_ad_stats_by_os WHERE dt = '2024-10-04';

-- todo 各小时-广告统计
INSERT OVERWRITE TABLE ad_ads.ads_ad_stats_by_hour
SELECT
    dt
     , ad_id
     , ad_name
     , hour(from_unixtime(event_time/1000,'yyyy-MM-dd HH:mm:ss')) AS pre_hour
     , `if`(is_invalid_traffic, '正常', '异常') AS traffic_type
     , sum(`if`(event_type='impression',1,0)) AS impression_count
     , sum(`if`(event_type='click',1,0)) AS click_count
FROM ad_dwd.dwd_ad_event_inc
WHERE dt='2024-10-04'
GROUP BY dt, ad_id, ad_name, hour(from_unixtime(event_time/1000,'yyyy-MM-dd HH:mm:ss')), is_invalid_traffic
;

-- SHOW PARTITIONS ad_ads.ads_ad_stats_by_hour;
SELECT * FROM ad_ads.ads_ad_stats_by_hour WHERE dt = '2024-10-04';