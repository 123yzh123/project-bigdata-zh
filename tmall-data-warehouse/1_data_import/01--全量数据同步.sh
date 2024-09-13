
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

# todo 3. 优惠券优惠范围表：coupon_range（全量）

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/coupon_range_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  coupon_id,
  range_type,
  range_id
FROM coupon_range
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 4. 优惠券领用表：coupon_use（全量）

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/coupon_use_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  coupon_id,
  user_id,
  order_id,
  coupon_status,
  create_time,
  get_time,
  using_time,
  used_time,
  expire_time
FROM coupon_use
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 5. SKU平台属性表：sku_attr_value

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

# todo 6. SKU信息表：sku_info

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/sku_info_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  spu_id,
  price,
  sku_name,
  sku_desc,
  weight,
  tm_id,
  category3_id,
  sku_default_img,
  is_sale,
  create_time
FROM sku_info
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 7. SKU销售属性表：sku_sale_attr_value

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

# todo 8. SPU信息表：spu_info

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/spu_info_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  spu_name,
  description,
  category3_id,
  tm_id
FROM spu_info
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 9. SPU照片表：spu_image

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/spu_image_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  spu_id,
  img_name,
  img_url
FROM spu_image
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 10. spu_poster

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/spu_poster_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  spu_id,
  img_name,
  img_url,
  create_time,
  update_time,
  is_deleted
FROM spu_poster
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 11. SPU销售属性表：spu_sale_attr

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/spu_sale_attr_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  spu_id,
  base_sale_attr_id,
  sale_attr_name
FROM spu_sale_attr
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 12.SPU销售属性值表：spu_sale_attr_value

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/spu_sale_attr_value_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  spu_id,
  base_sale_attr_id,
  sale_attr_value_name,
  sale_attr_name
FROM spu_sale_attr_value
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'

# todo 13. SKU照片表：sku_image

/opt/module/sqoop/bin/sqoop import \
--connect jdbc:mysql://node101:3306/gmall \
--username root \
--password 123456 \
--target-dir /origin_data/gmall/sku_image_full/2024-06-18 \
--delete-target-dir \
--query "SELECT
  id,
  sku_id,
  img_name,
  img_url,
  spu_img_id,
  is_default
FROM sku_image
WHERE 1 = 1 AND \$CONDITIONS" \
--num-mappers 1 \
--split-by 'id' \
--fields-terminated-by '\t' \
--compress \
--compression-codec gzip \
--null-string '\\N' \
--null-non-string '\\N'