

-- 创建数据库
CREATE DATABASE IF NOT EXISTS gmall_ods ;
USE gmall_ods ;

-- 1创建表
DROP TABLE IF EXISTS gmall_ods.ods_base_dic_full;
CREATE EXTERNAL TABLE gmall_ods.ods_base_dic_full
(
    `dic_code`     STRING COMMENT '编号',
    `dic_name`     STRING COMMENT '编码名称',
    `parent_code`  STRING COMMENT '父编码',
    `create_time`  STRING COMMENT '创建日期',
    `operate_time` STRING COMMENT '操作日期'
) COMMENT '编码字典表'
    PARTITIONED BY (`dt` STRING)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    STORED AS TEXTFILE
    LOCATION 'hdfs://node101:8020/warehouse/gmall_ods/ods_base_dic_full/';


-- 2加载数据：base_dic（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/base_dic_full/2024-10-07'
    OVERWRITE INTO TABLE gmall_ods.ods_base_dic_full PARTITION (dt = '2024-10-07');

-- 显示分区数目
SHOW PARTITIONS gmall_ods.ods_base_dic_full ;
-- 查询分区表数据，where过滤日期，limit限制条目数
SELECT * FROM gmall_ods.ods_base_dic_full WHERE dt = '2024-10-07' LIMIT 10 ;

