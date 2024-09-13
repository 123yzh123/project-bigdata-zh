
# ======================================================================
#                   todo：1. 编码字典表：base_dic（每日，全量）
# ======================================================================
/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/base_dic_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  dic_code,
  dic_name,
  parent_code,
  create_time,
  operate_time
FROM base_dic
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'dic_code' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

#hdfs dfs -cat /origin_data/gmall/cart_info/2024-06-18/part* |zcat

# todo 2. 优惠券信息表：coupon_info（全量）

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/coupon_info_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  coupon_name,
  coupon_type,
  condition_amount,
  condition_num,
  activity_id,
  benefit_amount,
  benefit_discount,
  create_time,
  range_type,
  limit_num,
  taken_count,
  start_time,
  end_time,
  operate_time,
  expire_time,
  range_desc
FROM coupon_info
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 2. 商品平台属性表：sku_attr_value（全量）

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/sku_attr_value_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  attr_id,
  value_id,
  sku_id,
  attr_name,
  value_name
FROM sku_attr_value
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 3. SKU销售属性表：sku_sale_attr_value

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/sku_sale_attr_value_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  sku_id,
  spu_id,
  sale_attr_value_id,
  sale_attr_id,
  sale_attr_name,
  sale_attr_value_name
FROM sku_sale_attr_value
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'