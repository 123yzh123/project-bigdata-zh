

/*
（1）DWD层的设计依据是维度建模理论，该层存储维度模型的事实表。
（2）DWD层的数据存储格式为orc列式存储+snappy压缩。
（3）DWD层表名的命名规范为dwd_数据域_表名_单分区增量全量标识（inc/full）
*/

-- 数据库
CREATE DATABASE IF NOT EXISTS ad_dwd ;
USE ad_dwd ;


-- todo 1 广告事件事实表
DROP TABLE IF EXISTS ad_dwd.dwd_ad_event_inc;
CREATE EXTERNAL TABLE IF NOT EXISTS ad_dwd.dwd_ad_event_inc
(
    event_time             BIGINT COMMENT '事件时间',
    event_type             STRING COMMENT '事件类型',
    ad_id                  STRING COMMENT '广告id',
    ad_name                STRING COMMENT '广告名称',
    ad_product_id          STRING COMMENT '广告商品id',
    ad_product_name        STRING COMMENT '广告商品名称',
    ad_product_price       DECIMAL(16, 2) COMMENT '广告商品价格',
    ad_material_id         STRING COMMENT '广告素材id',
    ad_material_url        STRING COMMENT '广告素材地址',
    ad_group_id            STRING COMMENT '广告组id',
    platform_id            STRING COMMENT '推广平台id',
    platform_name_en       STRING COMMENT '推广平台名称(英文)',
    platform_name_zh       STRING COMMENT '推广平台名称(中文)',
    client_country         STRING COMMENT '客户端所处国家',
    client_area            STRING COMMENT '客户端所处地区',
    client_province        STRING COMMENT '客户端所处省份',
    client_city            STRING COMMENT '客户端所处城市',
    client_ip              STRING COMMENT '客户端ip地址',
    client_device_id       STRING COMMENT '客户端设备id',
    client_os_type         STRING COMMENT '客户端操作系统类型',
    client_os_version      STRING COMMENT '客户端操作系统版本',
    client_browser_type    STRING COMMENT '客户端浏览器类型',
    client_browser_version STRING COMMENT '客户端浏览器版本',
    client_user_agent      STRING COMMENT '客户端UA',
    is_invalid_traffic     BOOLEAN COMMENT '是否是异常流量'
) PARTITIONED BY (`dt` STRING)
    STORED AS ORC
    LOCATION '/warehouse/ad_dwd/dwd_ad_event_inc/'
    TBLPROPERTIES ('orc.compress' = 'snappy');

