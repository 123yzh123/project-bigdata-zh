-- todo 10. 加购表：cart_info（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/cart_info_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_cart_info_inc PARTITION (dt = '2024-06-18');

--显示分区数目
SHOW PARTITIONS gmall.ods_cart_info_inc;
--查询分区表数据，where过滤日期，limit显示条目数
SELECT *
FROM gmall.ods_cart_info_inc
WHERE dt = '2024-06-18'
LIMIT 10;

-- todo 11.  优惠券表：coupon_info（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/coupon_info_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_coupon_info_full PARTITION (dt = '2024-06-18');

--显示分区数目
SHOW PARTITIONS gmall.ods_coupon_info_full;
--查询分区表数据，where过滤日期，limit显示条目数
SELECT *
FROM gmall.ods_coupon_info_full
WHERE dt = '2024-06-18'
LIMIT 10;


-- todo 12. sku平台属性值关联表：sku_attr_value（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/sku_attr_value_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_sku_attr_value_full PARTITION (dt = '2024-06-18');

--显示分区数目
SHOW PARTITIONS gmall.ods_sku_attr_value_full;
--查询分区表数据，where过滤日期，limit显示条目数
SELECT *
FROM gmall.ods_sku_attr_value_full
WHERE dt = '2024-06-18'
LIMIT 10;


-- todo 13. sku销售属性值：sku_sale_attr_value（每日，全量）
LOAD DATA INPATH '/origin_data/gmall/sku_sale_attr_value_full/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_sku_sale_attr_value_full PARTITION (dt = '2024-06-18');

--显示分区数目
SHOW PARTITIONS gmall.ods_sku_sale_attr_value_full;
--查询分区表数据，where过滤日期，limit显示条目数
SELECT *
FROM gmall.ods_sku_sale_attr_value_full
WHERE dt = '2024-06-18'
LIMIT 10;

-- ==========================================================================
-- ==========================================================================

-- todo 3.订单状态日志表：order_status_log（每日，增量）
LOAD DATA INPATH '/origin_data/gmall/order_status_log_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_order_status_log_inc PARTITION (dt = '2024-06-18');

-- 显示分区数目
SHOW PARTITIONS gmall.ods_order_status_log_inc;
-- 查询分区表数据，where过滤日期，limit限制条目数
SELECT *
FROM gmall.ods_order_status_log_inc
WHERE dt = '2024-06-18'
LIMIT 10;

-- todo 4.订单明细活动关联表：order_detail_activity（每日，增量）
LOAD DATA INPATH '/origin_data/gmall/order_detail_activity_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_order_detail_activity_inc PARTITION (dt = '2024-06-18');

-- 显示分区数目
SHOW PARTITIONS gmall.ods_order_detail_activity_inc;
-- 查询分区表数据，where过滤日期，limit限制条目数
SELECT *
FROM gmall.ods_order_detail_activity_inc
WHERE dt = '2024-06-18'
LIMIT 10;


-- todo 8.订单表：order_info（每日，增量）
LOAD DATA INPATH '/origin_data/gmall/order_info_inc/2024-06-18'
    OVERWRITE INTO TABLE gmall.ods_order_info_inc PARTITION (dt = '2024-06-18');

-- 显示分区数目
SHOW PARTITIONS gmall.ods_order_info_inc;
-- 查询分区表数据，where过滤日期，limit限制条目数
SELECT *
FROM gmall.ods_order_info_inc
WHERE dt = '2024-06-18'
LIMIT 10;