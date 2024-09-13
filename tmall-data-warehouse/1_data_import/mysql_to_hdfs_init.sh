#!/bin/bash

# 定义变量
APP=gmall
# 定义变量，表示命令
CMD=/opt/module/sqoop/bin/sqoop

# 获取同步数据日期参数值
if [ -n "$2" ] ;then
  do_date=$2
else
  echo "请传入日期参数"
  exit
fi

# 定义函数，类似方法，不需要显示指定参数个数类型：第1个参数为表名称，第2个参数为SQL语句
import_data(){
  ${CMD} import \
  --connect jdbc:mysql://node101:3306/${APP} \
  --username root \
  --password 123456 \
  --target-dir /origin_data/${APP}/$1/${do_date} \
  --delete-target-dir \
  --query "$2 AND \$CONDITIONS" \
  --num-mappers 1 \
  --fields-terminated-by '\t' \
  --compress \
  --compression-codec gzip \
  --null-string '\\N' \
  --null-non-string '\\N'
}

#  ======================================== 针对每个表，调用定义函数，同步数据 ========================================
# todo 首日同步表：base_dic
import_base_dic(){
  import_data base_dic_full "SELECT
                          dic_code,
                          dic_name,
                          parent_code,
                          create_time,
                          operate_time
                        FROM base_dic
                        WHERE 1 = 1"
}

# todo 首日同步表：order_detail
import_order_detail(){
  import_data order_detail_inc "SELECT
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
                          WHERE date_format(create_time, '%Y-%m-%d') <= '${do_date}'"
}

# todo 首日同步表：order_info
import_order_info(){
  import_data order_info_inc "SELECT
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
                        WHERE date_format(create_time, '%Y-%m-%d') <= '${do_date}'"
}

# todo 首日同步表：order_detail_coupon
import_order_detail_coupon(){
  import_data order_detail_coupon_inc "SELECT
    id,
    order_id,
    order_detail_id,
    coupon_id,
    coupon_use_id,
    sku_id,
    create_time
FROM order_detail_coupon
WHERE date_format(create_time, '%Y-%m-%d') <= '${do_date}'"
}

# todo 首日同步表：order_status_log
import_order_status_log(){
  import_data order_status_log_inc "SELECT
        id,
        order_id,
        order_status,
        operate_time
FROM order_status_log
WHERE date_format(operate_time, '%Y-%m-%d') <= '${do_date}'"
}

# todo 首日同步表：cart_info
import_cart_info(){
  import_data cart_info_inc "SELECT
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
WHERE date_format(create_time, '%Y-%m-%d') <= '${do_date}'"
}

# todo 首日同步表：coupon_info
import_coupon_info(){
  import_data coupon_info_full "SELECT
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
WHERE 1 = 1"
}

# todo 首日同步表：coupon_range
import_coupon_range(){
  import_data coupon_range_full "SELECT
        id,
        coupon_id,
        range_type,
        range_id
FROM coupon_range
WHERE 1 = 1"
}

# todo 首日同步表：coupon_use
import_coupon_use(){
  import_data coupon_use_full "SELECT
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
WHERE 1 = 1"
}

# todo 首日同步表：sku_attr_value
import_sku_attr_value(){
  import_data sku_attr_value_full "SELECT
        id,
        attr_id,
        value_id,
        sku_id,
        attr_name,
        value_name,
FROM sku_attr_value
WHERE 1 = 1"
}

# todo 首日同步表：sku_info
import_sku_info(){
  import_data sku_info_full "SELECT
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
WHERE 1 = 1"
}

# todo 首日同步表：sku_sale_attr_value
import_sku_sale_attr_value(){
  import_data sku_sale_attr_value_full "SELECT
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
FROM sku_sale_attr_value
WHERE 1 = 1"
}

# todo 首日同步表：spu_info
import_spu_info(){
  import_data spu_info_full "SELECT
        id,
        spu_name,
        description,
        category3_id,
        tm_id
FROM spu_info
WHERE 1 = 1"
}

# todo 首日同步表：spu_image
import_spu_image(){
  import_data spu_image_full "SELECT
        id,
        spu_id,
        img_name,
        img_url
FROM spu_image
WHERE 1 = 1"
}

# todo 首日同步表：spu_poster
import_spu_poster(){
  import_data spu_poster_full "SELECT
        id,
        spu_id,
        img_name,
        img_url,
        create_time,
        update_time,
        is_deleted
FROM spu_poster
WHERE 1 = 1"
}

# todo 首日同步表：spu_sale_attr
import_spu_sale_attr(){
  import_data spu_sale_attr_full "SELECT
        id,
        spu_id,
        base_sale_attr_id,
        sale_attr_name
FROM spu_sale_attr
WHERE 1 = 1"
}

# todo 首日同步表：spu_sale_attr_value
import_spu_sale_attr_value(){
  import_data spu_sale_attr_value_full "SELECT
        id,
        spu_id,
        base_sale_attr_id,
        sale_attr_value_name,
        sale_attr_name
FROM spu_sale_attr_value
WHERE 1 = 1"
}

# todo 首日同步表：sku_image
import_sku_image(){
  import_data sku_image_full "SELECT
        id,
        sku_id,
        img_name,
        img_url,
        spu_img_id,
        is_default
FROM sku_image
WHERE 1 = 1"
}

# 条件判断，依据执行脚本传递第1个参数值，确定同步导入哪个表数据，或同步导入所有表数据
case $1 in
  "base_dic")
    import_base_dic
;;
  "order_detail")
    import_order_detail
;;
  "order_info")
    import_order_info
;;
  "order_detail_coupon")
    import_order_detail_coupon
;;
  "order_status_log")
    import_order_status_log
;;
  "cart_info")
    import_cart_info
;;
  "coupon_info")
    import_coupon_info
;;
  "coupon_range")
    import_coupon_range
;;
  "coupon_use")
    import_coupon_use
;;
  "sku_attr_value")
    import_sku_attr_value
;;
  "sku_info")
    import_sku_info
;;
  "sku_sale_attr_value")
    import_sku_sale_attr_value
;;
  "spu_info")
    import_spu_info
;;
  "spu_image")
    import_spu_image
;;
  "spu_poster")
    import_spu_poster
;;
  "spu_sale_attr")
    import_spu_sale_attr
;;
  "spu_sale_attr_value")
    import_spu_sale_attr_value
;;
  "sku_image")
    import_sku_image
;;
  "all")
    import_base_dic
    import_order_detail
    import_order_info
    import_order_detail_coupon
    import_order_status_log
    import_cart_info
    import_coupon_info
    import_coupon_range
    import_coupon_use
    import_sku_attr_value
    import_sku_info
    import_sku_sale_attr_value
    import_spu_info
    import_spu_image
    import_spu_poster
    import_spu_sale_attr
    import_spu_sale_attr_value
    import_sku_image
;;
esac

#
# chmod u+x mysql_to_hdfs_init.sh
# sh mysql_to_hdfs_init.sh base_dic 2024-03-25
#         $0                  $1        $2
#
# 同步所有表
# sh mysql_to_hdfs_init.sh all 2024-03-31
# 同步某一张表
# sh mysql_to_hdfs_init.sh order_detail 2024-03-31
#


