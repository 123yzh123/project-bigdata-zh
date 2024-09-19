
-- todo 首日数据加载，开启动态分区
-- 开启动态分区
SET hive.exec.dynamic.partition=true;
-- 非严格模式：允许所有分区都是动态的
SET hive.exec.dynamic.partition.mode=nonstrict;

-- todo 1 交易域-加购-事务事实表
-- （1）首日装载
WITH cart
         AS (SELECT id,
                    user_id,
                    sku_id,
                    create_time,
                    source_id,
                    source_type,
                    sku_num
             FROM gmall.ods_cart_info_inc
             WHERE dt = '2024-06-18'),
     dic AS (SELECT dic_code
                  , dic_name
             FROM gmall.ods_base_dic_full
             WHERE dt = '2024-06-18'
               AND parent_code = '24')
INSERT
OVERWRITE
TABLE
gmall.dwd_trade_cart_add_inc
PARTITION
(
dt
)
SELECT id
     , user_id
     , sku_id
     , date_format(create_time, 'yyyy-MM-dd') AS date_id
     , create_time
     , source_id
     , source_type                            AS source_type_code
     , dic.dic_name                           AS source_type_name
     , sku_num
     , date_format(create_time, 'yyyy-MM-dd') AS dt
FROM cart
         LEFT JOIN dic ON cart.source_type = dic.dic_code;

-- 查询
SHOW PARTITIONS gmall.dwd_trade_cart_add_inc;
SELECT *
FROM gmall.dwd_trade_cart_add_inc
WHERE dt = '2024-06-18'
LIMIT 10;


-- 每日装载
WITH cart AS (SELECT id,
                     user_id,
                     sku_id,
                     if(operate_time IS NOT NULL, operate_time, create_time)                            AS create_time,
                     date_format(if(operate_time IS NOT NULL, operate_time, create_time), 'yyyy-MM-dd') AS date_id,
                     source_id,
                     source_type,
                     sku_num
              FROM gmall.ods_cart_info_inc
              WHERE dt = '2024-06-19'),
     dic AS (SELECT dic_code,
                    dic_name
             FROM gmall.ods_base_dic_full
             WHERE dt = '2024-06-19'
               AND parent_code = '24')
INSERT
OVERWRITE
TABLE
gmall.dwd_trade_cart_add_inc
partition
(
dt = '2024-06-19'
)
SELECT id,
       user_id,
       sku_id,
       date_id,
       create_time,
       source_id,
       source_type,
       dic.dic_name,
       sku_num
FROM cart
         LEFT JOIN dic ON cart.source_type = dic.dic_code;



-- todo 2 交易域-下单-事务事实表
/*
    主表：
        订单明细表 ods_order_detail_inc
    相关表：
        订单信息表ods_order_info_inc
        订单明细活动关联表ods_order_detail_activity_inc
        订单明细优惠关联表ods_order_detail_coupon_inc
        字典表ods_base_dic_full
*/
-- （1）首日装载
WITH
    -- a. 订单明细数据
    detail AS (
        SELECT
            id,
            order_id,
            sku_id,
            create_time,
            source_id,
            source_type,
            sku_num,
            sku_num * order_price AS split_original_amount,
            split_total_amount,
            split_activity_amount,
            split_coupon_amount
        FROM gmall.ods_order_detail_inc
        WHERE dt = '2024-06-18'
    ),
    -- b. 订单数据
    info AS (
        SELECT
            id,
            user_id,
            province_id
        FROM gmall.ods_order_info_inc
        WHERE dt = '2024-06-18'
    ),
    -- c. 订单明细活动关联表
    activity AS (
        SELECT
            order_detail_id,
            activity_id,
            activity_rule_id
        FROM gmall.ods_order_detail_activity_inc
        WHERE dt = '2024-06-18'
    ),
    -- d. 订单明细优惠卷关联表
    coupon AS (
        SELECT
            order_detail_id,
            coupon_id
        FROM gmall.ods_order_detail_coupon_inc
        WHERE dt = '2024-06-18'
    ),
    -- e. 字典数据
    dic AS (
        SELECT
            dic_code,
            dic_name
        FROM gmall.ods_base_dic_full
        WHERE dt = '2024-06-18' AND parent_code = '24'
    )
INSERT OVERWRITE TABLE gmall.dwd_trade_order_detail_inc PARTITION (dt)
-- f. 订单明细表关联订单info、活动activity、优惠卷coupon、字段dic
SELECT
    detail.id,
    order_id,
    user_id,
    sku_id,
    province_id,
    activity_id,
    activity_rule_id,
    coupon_id,
    date_format(create_time, 'yyyy-MM-dd') AS date_id,
    create_time,
    source_id,
    source_type,
    dic_name,
    sku_num,
    split_original_amount,
    split_activity_amount,
    split_coupon_amount,
    split_total_amount,
    -- 表示分区字段值，将来依据此字段值，将数据写入对用分区中
    date_format(create_time,'yyyy-MM-dd') AS dt
FROM detail
         JOIN info ON detail.order_id = info.id
         LEFT JOIN activity ON detail.id = activity.order_detail_id
         LEFT JOIN coupon ON detail.id = coupon.order_detail_id
         LEFT JOIN dic ON detail.source_type = dic.dic_code ;

-- 测试
SHOW PARTITIONS gmall.dwd_trade_order_detail_inc ;
SELECT * FROM gmall.dwd_trade_order_detail_inc WHERE dt = '2024-06-18' LIMIT 10;

-- （2）每日装载
WITH
    -- a. 订单明细数据
    detail AS (
        SELECT
            id,
            order_id,
            sku_id,
            create_time,
            source_id,
            source_type,
            sku_num,
            sku_num * order_price AS split_original_amount,
            split_total_amount,
            split_activity_amount,
            split_coupon_amount
        FROM gmall.ods_order_detail_inc
        WHERE dt = '2024-06-19'
    ),
    -- b. 订单数据
    info AS (
        SELECT
            id,
            user_id,
            province_id
        FROM gmall.ods_order_info_inc
        WHERE dt = '2024-06-19'
    ),
    -- c. 订单明细活动关联表
    activity AS (
        SELECT
            order_detail_id,
            activity_id,
            activity_rule_id
        FROM gmall.ods_order_detail_activity_inc
        WHERE dt = '2024-06-19'
    ),
    -- d. 订单明细优惠卷关联表
    coupon AS (
        SELECT
            order_detail_id,
            coupon_id
        FROM gmall.ods_order_detail_coupon_inc
        WHERE dt = '2024-06-19'
    ),
    -- e. 字典数据
    dic AS (
        SELECT
            dic_code,
            dic_name
        FROM gmall.ods_base_dic_full
        WHERE dt='2024-06-19'
    )
INSERT OVERWRITE TABLE gmall.dwd_trade_order_detail_inc PARTITION (dt = '2024-06-19')
-- f. 订单明细表关联订单info、活动activity、优惠卷coupon、字段dic
SELECT
    info.id,
    order_id,
    user_id,
    sku_id,
    province_id,
    activity_id,
    activity_rule_id,
    coupon_id,
    date_format(create_time, 'yyyy-MM-dd') AS date_id,
    create_time,
    source_id,
    source_type,
    dic_name,
    sku_num,
    split_original_amount,
    split_activity_amount,
    split_coupon_amount,
    split_total_amount
FROM detail
         LEFT JOIN info ON detail.order_id = info.id
         LEFT JOIN activity ON detail.id = activity.order_detail_id
         LEFT JOIN coupon ON detail.id = coupon.order_detail_id
         LEFT JOIN dic ON detail.source_type = dic.dic_code;

-- 测试
SHOW PARTITIONS gmall.dwd_trade_order_detail_inc ;
SELECT * FROM gmall.dwd_trade_order_detail_inc WHERE dt = '2024-06-18' LIMIT 10;


-- todo 3. 交易域-支付成功-事务事实表
-- dwd_trade_pay_detail_suc_inc;
-- （1）首日装载
WITH
    order_detail AS (
        SELECT
            id,
            order_id,
            sku_id,
            source_id,
            source_type,
            CAST(sku_num AS BIGINT) AS sku_num,
            CAST(sku_num * order_price AS DECIMAL(16, 2)) AS split_original_amount,
            split_total_amount,
            split_activity_amount,
            split_coupon_amount
        FROM gmall.ods_order_detail_inc
        WHERE dt = '2024-06-18'
    ),
    payment_info AS (
        SELECT
            user_id,
            order_id,
            payment_type,
            callback_time
        FROM gmall.ods_payment_info_inc
        WHERE dt = '2024-06-18'
    ),
    order_info AS (
        SELECT
            id AS order_id,
            province_id
        FROM gmall.ods_order_info_inc
        WHERE dt = '2024-06-18'
    ),
    order_detail_activity AS (
        SELECT
            order_detail_id,
            activity_id,
            activity_rule_id
        FROM gmall.ods_order_detail_activity_inc
        WHERE dt = '2024-06-18'
    ),
    order_detail_coupon AS (
        SELECT
            order_detail_id,
            coupon_id
        FROM gmall.ods_order_detail_coupon_inc
        WHERE dt = '2024-06-18'
    ),
    base_dic AS (
        SELECT
            dic_code,
            dic_name
        FROM gmall.ods_base_dic_full
        WHERE dt = '2024-06-19'
    )
INSERT OVERWRITE TABLE gmall.dwd_trade_pay_detail_suc_inc PARTITION (dt)
SELECT
    od.id,
    od.order_id,
    pi.user_id,
    od.sku_id,
    oi.province_id,
    act.activity_id,
    act.activity_rule_id,
    cou.coupon_id,
    pi.payment_type,
    pay_dic.dic_name AS payment_type_name,
    DATE_FORMAT(pi.callback_time, 'yyyy-MM-dd') AS date_id,
    pi.callback_time,
    od.source_id,
    od.source_type,
    src_dic.dic_name AS source_type_name,
    od.sku_num,
    od.split_original_amount,
    od.split_activity_amount,
    od.split_coupon_amount,
    od.split_total_amount,
    DATE_FORMAT(pi.callback_time, 'yyyy-MM-dd') AS dt
FROM
    order_detail AS od
        JOIN payment_info AS pi ON od.order_id = pi.order_id
        LEFT JOIN order_info AS oi ON od.order_id = oi.order_id
        LEFT JOIN order_detail_activity AS act ON od.id = act.order_detail_id
        LEFT JOIN order_detail_coupon AS cou ON od.id = cou.order_detail_id
        LEFT JOIN base_dic AS pay_dic ON pi.payment_type = pay_dic.dic_code
        LEFT JOIN base_dic AS src_dic ON od.source_type = src_dic.dic_code;

-- （2）每日装载


-- todo  4 交易域-购物车-周期快照事实表
/*
    直接从ODS层加购表（全量表）获取数据即可
*/
INSERT OVERWRITE TABLE gmall.dwd_trade_cart_full PARTITION(dt = '2024-06-18')
SELECT
    id,
    user_id,
    sku_id,
    sku_name,
    sku_num
FROM gmall.ods_cart_info_inc
WHERE dt = '2024-06-18' and is_ordered = '0';

-- 测试
SHOW PARTITIONS gmall.dwd_trade_cart_full;
SELECT * FROM gmall.dwd_trade_cart_full WHERE dt = '2024-06-18' LIMIT 10 ;


-- todo 5 工具域-优惠券领取-事务事实表 zhou
/*
    直接从优惠卷使用增量表获取数据
*/
-- （1）首日装载
insert overwrite table gmall.dwd_tool_coupon_get_inc partition(dt)
select
    id,
    coupon_id,
    user_id,
    date_format(get_time,'yyyy-MM-dd') date_id,
    get_time,
    date_format(get_time,'yyyy-MM-dd')
from gmall.ods_coupon_use_inc
where dt='2024-06-18';



-- （2）每日装载
insert overwrite table gmall.dwd_tool_coupon_get_inc partition (dt='2024-06-18')
select
    id,
    coupon_id,
    user_id,
    date_format(get_time,'yyyy-MM-dd') date_id,
    get_time
from gmall.ods_coupon_use_inc
where dt='2024-06-18';

-- todo 6 工具域-优惠券使用(下单)-事务事实表 zhou
-- （1）首日装载

insert overwrite table gmall.dwd_tool_coupon_order_inc partition(dt)
select
    id,
    coupon_id,
    user_id,
    order_id,
    date_format(using_time,'yyyy-MM-dd') date_id,
    using_time,
    date_format(using_time,'yyyy-MM-dd')
from gmall.ods_coupon_use_inc
where dt='2024-06-18'
  and using_time is not null;

-- （2）每日装载
insert overwrite table gmall.dwd_tool_coupon_order_inc partition(dt='2024-06-18')
select
    id,
    coupon_id,
    user_id,
    order_id,
    date_format(using_time,'yyyy-MM-dd') date_id,
    using_time
from gmall.ods_coupon_use_inc
where dt='2024-06-18';

-- todo 7 工具域-优惠券使用(支付)-事务事实表
-- （1）首日装载
insert overwrite table gmall.dwd_tool_coupon_pay_inc partition (dt)
select id,
       coupon_id,
       user_id,
       order_id,
       date_format(used_time, 'yyyy-MM-dd') date_id,
       used_time,
       date_format(used_time, 'yyyy-MM-dd')
from gmall.ods_coupon_use_inc
where dt = '2024-06-18'
  and used_time is not null;


-- （2）每日装载
insert overwrite table gmall.dwd_tool_coupon_pay_inc partition (dt = '2024-06-18')
select id,
       coupon_id,
       user_id,
       order_id,
       date_format(used_time, 'yyyy-MM-dd') date_id,
       used_time
from gmall.ods_coupon_use_inc
where dt = '2024-06-18';



-- todo 8 互动域-收藏商品-事务事实表
-- （1）首日装载
WITH
    favor_info AS (
        SELECT
            id,
            user_id,
            sku_id,
            spu_id,
            is_cancel,
            create_time,
            cancel_time
        FROM gmall.ods_favor_info_inc
        WHERE dt='2024-06-18'
    )
INSERT OVERWRITE TABLE gmall.dwd_interaction_favor_add_inc PARTITION(dt)
SELECT
    id,
    user_id,
    sku_id,
    date_format(create_time,'yyyy-MM-dd') date_id,
    create_time,
    date_format(create_time,'yyyy-MM-dd')
FROM favor_info;
-- （2）每日装载



-- todo 9 互动域-评价-事务事实表
-- （1）首日装载
WITH
    comment_info AS (
        SELECT
            id,
            user_id,
            nick_name,
            head_img,
            sku_id,
            spu_id,
            order_id,
            appraise,
            comment_txt,
            create_time,
            operate_time
        FROM gmall.ods_comment_info_inc
        WHERE dt='2024-06-18'
    ),
    base_dic AS (
        SELECT
            dic_code,
            dic_name,
            parent_code,
            create_time,
            operate_time
        FROM gmall.ods_base_dic_full
        WHERE dt='2024-06-18'
    )
insert overwrite table gmall.dwd_interaction_comment_inc partition(dt)
select
    id,
    user_id,
    sku_id,
    order_id,
    date_format(ci.create_time,'yyyy-MM-dd') date_id,
    ci.create_time,
    appraise,
    dic_name,
    date_format(ci.create_time,'yyyy-MM-dd')
FROM
    comment_info AS ci LEFT JOIN base_dic AS dic
                                 ON ci.appraise=dic.dic_code;
-- （2）每日装载




-- todo 18 用户域-用户注册-事务事实表
-- （1）首日装载



-- （2）每日装载


-- todo 19 用户域-用户登录-事务事实表



-- todo 10 流量域-页面浏览-事务事实表
