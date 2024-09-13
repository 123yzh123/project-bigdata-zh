# ======================================================================
#                   todo：1. 订单明细表：order_detail（增量，历史）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/order_detail_inc/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    order_id,
    sku_id,
    sku_name,
    img_url,
    order_price,
    sku_num,
    create_time,
    source_type,
    source_id,
    split_total_amount,
    split_activity_amount,
    split_coupon_amount
FROM order_detail
WHERE date_format(create_time, '%Y-%m-%d') <= '2024-06-18' AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 2. 订单明细优惠券关联表：order_detail_coupon  （增量、历史）

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/order_detail_coupon_inc/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    order_id,
    order_detail_id,
    coupon_id,
    coupon_use_id,
    sku_id,
    create_time
FROM order_detail_coupon
WHERE date_format(create_time, '%Y-%m-%d') <= '2024-06-18' AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 3. 订单表：order_info  （增量、历史）

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/order_info_inc/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    consignee,
    consignee_tel,
    total_amount,
    order_status,
    user_id,
    payment_way,
    delivery_address,
    order_comment,
    out_trade_no,
    trade_body,
    create_time,
    operate_time,
    expire_time,
    process_status,
    tracking_no,
    parent_order_id,
    img_url,
    province_id,
    activity_reduce_amount,
    coupon_reduce_amount,
    original_total_amount,
    feight_fee,
    feight_fee_reduce,
    refundable_time
FROM order_info
WHERE date_format(create_time, '%Y-%m-%d') <= '2024-06-18' AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 4. 订单状态流水表：order_status_log （增量、历史）

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/order_status_log_inc/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    order_id,
    order_status,
    operate_time
FROM order_status_log
WHERE date_format(operate_time, '%Y-%m-%d') <= '2024-06-18' AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 5.加购表：cart_info

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/cart_info_inc/2024-06-18 \
--delete-target-dir \
--query "SELECT
    id,
    user_id,
    sku_id,
    cart_price,
    sku_num,
    img_url,
    sku_name,
    is_checked,
    create_time,
    operate_time,
    is_ordered,
    order_time,
    source_type,
    source_id
FROM cart_info
WHERE date_format(create_time, '%Y-%m-%d') <= '2024-06-18' AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'