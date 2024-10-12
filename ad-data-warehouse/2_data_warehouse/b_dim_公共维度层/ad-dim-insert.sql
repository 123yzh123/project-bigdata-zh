

-- 使用数据库
USE ad_dim ;


-- todo 9.1 广告信息维度表
WITH
    ads_data AS (
        SELECT
            id,
            ad_name,
            product_id,
            material_id,
            group_id,
            material_url
        FROM ad_ods.ods_ads_info_full
        WHERE dt = '2024-10-10'
    )
    , product_data AS (
        SELECT
            id,
            name,
            price
        FROM ad_ods.ods_product_info_full
        WHERE dt = '2024-10-10'
    )
INSERT OVERWRITE TABLE ad_dim.dim_ads_info_full PARTITION (dt='2024-10-10')
SELECT
    ads_data.id,
    ad_name,
    product_id,
    name,
    price,
    material_id,
    material_url,
    group_id
FROM ads_data
LEFT JOIN product_data ON ads_data.product_id = product_data.id;

SHOW PARTITIONS ad_dim.dim_ads_info_full ;
SELECT * FROM ad_dim.dim_ads_info_full WHERE dt = '2024-10-10' ;



-- todo 9.2 平台信息维度表
INSERT OVERWRITE TABLE ad_dim.dim_platform_info_full PARTITION (dt = '2024-10-10')
SELECT
    id,
    platform_name_en,
    platform_name_zh
FROM ad_ods.ods_platform_info_full
WHERE dt = '2024-10-10';


SHOW PARTITIONS ad_dim.dim_platform_info_full ;
SELECT * FROM ad_dim.dim_platform_info_full WHERE dt = '2024-10-10' ;
