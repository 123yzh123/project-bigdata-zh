/*
node103启动Clickhouse服务
    [bwie@node103 ~]$ sudo systemctl status clickhouse-server
    [bwie@node103 ~]$ ps -ef | grep clickhouse

node103启动Clickhouse客户端
    [bwie@node103 ~]$ clickhouse-client -m -u default -h node103 --port 9000
    node103 :)
    node103 :) quit ;
*/

-- 1 创建database
CREATE DATABASE IF NOT EXISTS ad_report;
USE ad_report;


-- 2 创建table
DROP TABLE IF EXISTS ad_report.dwd_ad_event_inc;
CREATE TABLE IF NOT EXISTS ad_report.dwd_ad_event_inc
(
    event_time             Int64 COMMENT '事件时间',
    event_type             String COMMENT '事件类型',
    ad_id                  String COMMENT '广告id',
    ad_name                String COMMENT '广告名称',
    ad_product_id          String COMMENT '广告产品id',
    ad_product_name        String COMMENT '广告产品名称',
    ad_product_price       Decimal(16, 2) COMMENT '广告产品价格',
    ad_material_id         String COMMENT '广告素材id',
    ad_material_url        String COMMENT '广告素材url',
    ad_group_id            String COMMENT '广告组id',
    platform_id            String COMMENT '推广平台id',
    platform_name_en       String COMMENT '推广平台名称(英文)',
    platform_name_zh       String COMMENT '推广平台名称(中文)',
    client_country         String COMMENT '客户端所处国家',
    client_area            String COMMENT '客户端所处地区',
    client_province        String COMMENT '客户端所处省份',
    client_city            String COMMENT '客户端所处城市',
    client_ip              String COMMENT '客户端ip地址',
    client_device_id       String COMMENT '客户端设备id',
    client_os_type         String COMMENT '客户端操作系统类型',
    client_os_version      String COMMENT '客户端操作系统版本',
    client_browser_type    String COMMENT '客户端浏览器类型',
    client_browser_version String COMMENT '客户端浏览器版本',
    client_user_agent      String COMMENT '客户端UA',
    is_invalid_traffic     UInt8 COMMENT '是否是异常流量'
) ENGINE = MergeTree()
      ORDER BY (event_time, ad_name, event_type, client_province, client_city, client_os_type,
                client_browser_type, is_invalid_traffic);


-- 查询数据
SELECT * FROM ad_report.dwd_ad_event_inc LIMIT 10 ;



