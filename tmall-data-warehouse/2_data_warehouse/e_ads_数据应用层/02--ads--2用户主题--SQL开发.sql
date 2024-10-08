-- =============================================================================
-- todo 2.1 用户变动统计
-- =============================================================================
/*
统计周期	指标	说明
    最近1日	流失用户数	之前活跃过的用户，最近一段时间未活跃，就称为流失用户。
                        此处要求统计7日前（只包含7日前当天）活跃，但最近7日未活跃的用户总数。
                        todo login_date_last = date_sub('2024-09-18', 7)

最近1日	回流用户数	之前的活跃用户，一段时间未活跃（流失），今日又活跃了，就称为回流用户。
                        此处要求统计回流用户总数。
                        todo login_date_last = '2024-09-18'
                             AND
前一天，用户为流式用户  yesterday_login_last_date <= date_sub('2024-09-17', 7)

    `dt`               STRING COMMENT '统计日期',
    `user_churn_count` BIGINT COMMENT '流失用户数',
    `user_back_count`  BIGINT COMMENT '回流用户数'
*/

WITH lose_data AS (
    -- step1. 流失用户数：login_date_last = date_sub('2024-09-18', 7)
    SELECT '2024-09-18'                                                 AS dt
         , sum(`if`(login_date_last = date_sub('2024-09-18', 7), 1, 0)) AS user_churn_count
    FROM gmall.dws_user_user_login_td
    WHERE dt = '2024-09-18')
   , today_active_user AS (
    -- step2-1. 当日活跃用户
    SELECT DISTINCT user_id
    FROM gmall.dws_user_user_login_td
    WHERE dt = '2024-09-18'
      AND login_date_last = '2024-09-18')
   , yesterday_lose_user AS (
    -- step2-2. 以昨日为准：获取流失用户
    SELECT DISTINCT user_id
    FROM gmall.dws_user_user_login_td
    WHERE dt = date_sub('2024-09-18', 1)
      AND login_date_last <= date_sub('2024-09-18', 8))
   , back_data AS (
    -- step2-3. 关联获取回流用户
    SELECT '2024-09-18'       AS dt
         , count(ylu.user_id) AS user_back_count
    FROM yesterday_lose_user ylu
             JOIN today_active_user tau ON ylu.user_id = tau.user_id)
-- step5. 插入数据
INSERT OVERWRITE TABLE gmall.ads_user_change
-- step4. 历史统计
SELECT dt, user_churn_count, user_back_count FROM gmall.ads_user_change
UNION
-- step3. 合并数据
SELECT ld.dt
     , ld.user_churn_count
     , bd.user_back_count
FROM lose_data ld
         JOIN back_data bd ON ld.dt = bd.dt
;


-- =============================================================================
-- todo 2.2 用户留存率
-- =============================================================================
/*
新增留存率具体是指留存用户数与新增用户数的比值，
    例如2020-06-14新增100个用户，1日之后（2020-06-15）这100人中有80个人活跃了，
        那2020-06-14的1日留存数则为80，2020-06-14的1日留存率则为80%。

新增留存分析：每天新增用户中，有多少用户继续活跃。
			新增用户数  2024-04-02	2024-04-03	2024-04-04	2024-04-05	2024-04-06	2024-04-07	2024-04-08
2024-04-01	  100	   1日$30#30%	2日$20#20%  3日$15#15%	4日$10#10%	5日$9#9%		6日$7#7%		7日$4#4%

2024-04-02	  80					1日$20#25%	2日$10#12.5% 3日$8#10%  3日$4#5%

2024-04-03	  200								1日$20#10%	 2日$10#5%


    `dt`              STRING COMMENT '统计日期',
    `create_date`     STRING COMMENT '用户新增日期',
    `retention_day`   INT COMMENT '截至当前日期留存天数',
    `retention_count` BIGINT COMMENT '留存用户数量',
    `new_user_count`  BIGINT COMMENT '新增用户数量',
    `retention_rate`  DECIMAL(16, 2) COMMENT '留存率'
*/

WITH register_data AS (
    -- step1. 当日以前的7日的注册用户
    SELECT date_id AS register_date
         , user_id
    FROM gmall.dwd_user_register_inc
    WHERE dt >= date_sub('2024-09-18', 7)
      AND dt <= date_sub('2024-09-18', 1)
    ORDER BY date_id)
   , login_data AS (
    -- step2. 历史汇总表找出所有用户最后登录日期
    SELECT user_id
    FROM gmall.dws_user_user_login_td
    WHERE dt = '2024-09-18'
      AND login_date_last = '2024-09-18')
   , join_data AS (
    -- step3. 关联
    SELECT rd.user_id
         , rd.register_date
         , ld.user_id AS login_user_id
    FROM register_data rd
             LEFT JOIN login_data ld ON rd.user_id = ld.user_id)
-- step6. 保存数据
INSERT OVERWRITE TABLE gmall.ads_user_retention
-- step5. 历史统计
SELECT dt, create_date, retention_day, retention_count, new_user_count, retention_rate FROM gmall.ads_user_retention
UNION
-- step4. 计算留存用户和留存率
SELECT '2024-09-18'                                                        AS dt
     -- 注册日期，第一次登录日期
     , register_date                                                       AS create_date
     -- 留存天数
     , datediff('2024-09-18', register_date)                               AS retention_day
     -- 留存数：今天登录的用户数
     , sum(if(login_user_id IS NOT NULL, 1, 0))                            AS retention_count
     -- 注册新用户数
     , count(user_id)                                                      AS new_user_count
     -- 留存率 = 留存数 / 总数
     , round(sum(if(login_user_id IS NOT NULL, 1, 0)) / count(user_id), 4) AS retention_rate
FROM join_data
GROUP BY register_date
;



-- =============================================================================
-- todo 2.3 用户新增活跃统计
-- =============================================================================
/*
    统计周期	        指标	        指标说明
    最近1、7、30日	新增用户数	略
                    todo 今日注册用户，统计数量
                        dwd_user_register_inc：date_id = 今日

    最近1、7、30日	活跃用户数	略
                    todo 今日登录用户，统计数量
                        dws_user_user_login_td：login_date_last = 今日

    `dt`                STRING COMMENT '统计日期',
    `recent_days`       BIGINT COMMENT '最近n日,1:最近1日,7:最近7日,30:最近30日',
    `new_user_count`    BIGINT COMMENT '新增用户数',
    `active_user_count` BIGINT COMMENT '活跃用户数'
*/

WITH new_user_data AS (
    -- step1. 最近1\7\30日：新增用户数
    SELECT '2024-09-18'                                                      AS dt
         , recent_days
         , sum(if(date_id >= date_sub('2024-09-18', recent_days - 1), 1, 0)) AS new_user_count
    FROM gmall.dwd_user_register_inc
             LATERAL VIEW explode(array(1, 7, 30)) tmp AS recent_days
    WHERE dt >= date_sub('2024-09-18', 29)
      AND dt <= '2024-09-18'
    GROUP BY recent_days)
   , active_user_data AS (
    -- step2. 最近1\7\30日：活跃用户数
    SELECT '2024-09-18'                                                              AS dt
         , recent_days
         , sum(if(login_date_last >= date_sub('2024-09-18', recent_days - 1), 1, 0)) AS active_user_count
    FROM gmall.dws_user_user_login_td
             LATERAL VIEW explode(array(1, 7, 30)) tmp AS recent_days
    WHERE dt >= date_sub('2024-09-18', 29)
      AND dt <= '2024-09-18'
    GROUP BY recent_days)
-- step5. 插入数据
INSERT OVERWRITE TABLE gmall.ads_user_stats
-- step4. 历史统计
SELECT dt, recent_days, new_user_count, active_user_count FROM gmall.ads_user_stats
UNION
-- step3. 合并新增用户数和活跃用户数
SELECT aud.dt
     , aud.recent_days
     , aud.active_user_count
     , nud.new_user_count
FROM active_user_data aud
         LEFT JOIN new_user_data nud ON aud.dt = nud.dt AND aud.recent_days = nud.recent_days
;


-- ============================ 第1、最近1日：新增用户数 ============================
SELECT '2024-09-18'                            AS dt
     , 1                                       AS recent_days
     , sum(`if`(date_id = '2024-09-18', 1, 0)) AS new_user_count
FROM gmall.dwd_user_register_inc
WHERE dt = '2024-09-18';


-- ============================ 第2、最近1日：活跃用户数 ============================
SELECT '2024-09-18'                                    AS dt
     , 1                                               AS recent_days
     , sum(`if`(login_date_last = '2024-09-18', 1, 0)) AS active_user_count
FROM gmall.dws_user_user_login_td
WHERE dt = '2024-09-18';



-- =============================================================================
-- todo 2.4 用户行为漏斗分析
-- =============================================================================
/*
    该需求要求统计一个完整的购物流程各个阶段的人数，具体说明如下：
    统计周期	        指标	            说明
    最近1、7、30日	首页浏览人数	    略
    最近1、7、30日	商品详情页浏览人数	略
    最近1、7、30日	加购人数	        略
    最近1、7、30日	下单人数	        略
    最近1、7、30日	支付人数	        支付成功人数

    `dt`                STRING COMMENT '统计日期',
    `recent_days`       BIGINT COMMENT '最近天数,1:最近1天,7:最近7天,30:最近30天',
    `home_count`        BIGINT COMMENT '浏览首页人数',
    `good_detail_count` BIGINT COMMENT '浏览商品详情页人数',
    `cart_count`        BIGINT COMMENT '加入购物车人数',
    `order_count`       BIGINT COMMENT '下单人数',
    `payment_count`     BIGINT COMMENT '支付人数'
*/

-- ================================== 优化写法 ==================================

WITH page_stats AS (
    -- a. 浏览首页和商品详情页人数
    SELECT '2024-09-18'                                                                             AS dt
         , recent_days
         -- 浏览首页人数
         , SUM(IF(dt >= date_sub('2024-09-18', recent_days - 1) AND page_id = 'home', 1, 0))        AS home_count
         -- 浏览商品详情页人数
         , SUM(IF(dt >= date_sub('2024-09-18', recent_days - 1) AND page_id = 'good_detail', 1, 0)) AS good_detail_count
    FROM gmall.dws_traffic_page_visitor_page_view_1d
             LATERAL VIEW explode(array(1, 7, 30)) tmp AS recent_days
    WHERE dt >= date_sub('2024-09-18', 29)
      AND dt <= '2024-09-18'
      AND page_id IS NOT NULL
      AND page_id IN ('home', 'good_detail')
    GROUP BY recent_days)
   , cart_stats AS (
    -- b. 加入购物车人数
    SELECT '2024-09-18'                                                                     AS dt
         , recent_days
         , count(DISTINCT IF(dt >= date_sub('2024-09-18', recent_days - 1), user_id, NULL)) AS cart_count
    FROM gmall.dws_trade_user_order_1d
             LATERAL VIEW explode(array(1, 7, 30)) tmp AS recent_days
    WHERE dt >= date_sub('2024-09-18', 29)
      AND dt <= '2024-09-18'
    GROUP BY recent_days)
   , order_stats AS (
    -- c. 下单人数
    SELECT '2024-09-18'                                                                     AS dt
         , recent_days
         , count(DISTINCT IF(dt >= date_sub('2024-09-18', recent_days - 1), user_id, NULL)) AS order_count
    FROM gmall.dws_trade_user_cart_add_1d
             LATERAL VIEW explode(array(1, 7, 30)) tmp AS recent_days
    WHERE dt >= date_sub('2024-09-18', 29)
      AND dt <= '2024-09-18'
    GROUP BY recent_days)
   , payment_stats AS (
    -- d. 支付人数
    SELECT '2024-09-18'                                                                     AS dt
         , recent_days
         , count(DISTINCT IF(dt >= date_sub('2024-09-18', recent_days - 1), user_id, NULL)) AS payment_count
    FROM gmall.dws_trade_user_payment_1d
             LATERAL VIEW explode(array(1, 7, 30)) tmp AS recent_days
    WHERE dt >= date_sub('2024-09-18', 29)
      AND dt <= '2024-09-18'
    GROUP BY recent_days)
-- todo 第5、插入保存
INSERT OVERWRITE TABLE gmall.ads_user_action
-- todo 第4、历史统计
SELECT dt, recent_days, home_count, good_detail_count, cart_count, order_count, payment_count FROM gmall.ads_user_action
UNION
-- e. 合并人数统计
SELECT ps.dt
     , ps.recent_days
     , ps.home_count
     , ps.good_detail_count
     , cs.cart_count
     , os.order_count
     , pms.payment_count
FROM page_stats ps
         LEFT JOIN cart_stats cs ON ps.dt = cs.dt AND ps.recent_days = cs.recent_days
         LEFT JOIN order_stats os ON ps.dt = os.dt AND ps.recent_days = os.recent_days
         LEFT JOIN payment_stats pms ON ps.dt = pms.dt AND ps.recent_days = pms.recent_days
;


-- ================================== 常规写法 ==================================
WITH
   -- todo 第1、最近1日统计
    page_stats_1d AS (
        -- a. 浏览首页和商品详情页人数
        SELECT '2024-09-18'                           AS dt
             , 1                                      AS recent_days
             -- 浏览首页人数
             , SUM(IF(page_id = 'home', 1, 0))        AS home_count
             -- 浏览商品详情页人数
             , SUM(IF(page_id = 'good_detail', 1, 0)) AS good_detail_count
        FROM gmall.dws_traffic_page_visitor_page_view_1d
        WHERE dt = '2024-09-18'
          AND page_id IS NOT NULL
          AND page_id IN ('home', 'good_detail'))
   , cart_stats_1d AS (
    -- b. 加入购物车人数
    SELECT '2024-09-18'   AS dt
         , 1              AS recent_days
         , count(user_id) AS cart_count
    FROM gmall.dws_trade_user_order_1d
    WHERE dt = '2024-09-18')
   , order_stats_1d AS (
    -- c. 下单人数
    SELECT '2024-09-18'   AS dt
         , 1              AS recent_days
         , count(user_id) AS order_count
    FROM gmall.dws_trade_user_cart_add_1d
    WHERE dt = '2024-09-18')
   , payment_stats_1d AS (
    -- d. 支付人数
    SELECT '2024-09-18'   AS dt
         , 1              AS recent_days
         , count(user_id) AS payment_count
    FROM gmall.dws_trade_user_payment_1d
    WHERE dt = '2024-09-18')
   , stats_1d AS (
    -- e. 合并人数统计
    SELECT ps.dt
         , ps.recent_days
         , ps.home_count
         , ps.good_detail_count
         , cs.cart_count
         , os.order_count
         , pms.payment_count
    FROM page_stats_1d ps
             LEFT JOIN cart_stats_1d cs ON ps.dt = cs.dt AND ps.recent_days = cs.recent_days
             LEFT JOIN order_stats_1d os ON ps.dt = os.dt AND ps.recent_days = os.recent_days
             LEFT JOIN payment_stats_1d pms ON ps.dt = pms.dt AND ps.recent_days = pms.recent_days)
   -- todo 第2、最近7日统计
   , page_stats_7d AS (
    -- a. 浏览首页和商品详情页人数
    SELECT '2024-09-18'                           AS dt
         , 7                                      AS recent_days
         -- 浏览首页人数
         , SUM(IF(page_id = 'home', 1, 0))        AS home_count
         -- 浏览商品详情页人数
         , SUM(IF(page_id = 'good_detail', 1, 0)) AS good_detail_count
    FROM gmall.dws_traffic_page_visitor_page_view_1d
    WHERE dt >= date_sub('2024-09-18', 6)
      AND dt <= '2024-09-18'
      AND page_id IS NOT NULL
      AND page_id IN ('home', 'good_detail'))
   , cart_stats_7d AS (
    -- b. 加入购物车人数
    SELECT '2024-09-18'   AS dt
         , 7              AS recent_days
         , count(user_id) AS cart_count
    FROM gmall.dws_trade_user_order_1d
    WHERE dt >= date_sub('2024-09-18', 6)
      AND dt <= '2024-09-18')
   , order_stats_7d AS (
    -- c. 下单人数
    SELECT '2024-09-18'   AS dt
         , 7              AS recent_days
         , count(user_id) AS order_count
    FROM gmall.dws_trade_user_cart_add_1d
    WHERE dt >= date_sub('2024-09-18', 6)
      AND dt <= '2024-09-18')
   , payment_stats_7d AS (
    -- d. 支付人数
    SELECT '2024-09-18'   AS dt
         , 7              AS recent_days
         , count(user_id) AS payment_count
    FROM gmall.dws_trade_user_payment_1d
    WHERE dt >= date_sub('2024-09-18', 6)
      AND dt <= '2024-09-18')
   , stats_7d AS (
    -- e. 合并人数统计
    SELECT ps.dt
         , ps.recent_days
         , ps.home_count
         , ps.good_detail_count
         , cs.cart_count
         , os.order_count
         , pms.payment_count
    FROM page_stats_7d ps
             LEFT JOIN cart_stats_7d cs ON ps.dt = cs.dt AND ps.recent_days = cs.recent_days
             LEFT JOIN order_stats_7d os ON ps.dt = os.dt AND ps.recent_days = os.recent_days
             LEFT JOIN payment_stats_7d pms ON ps.dt = pms.dt AND ps.recent_days = pms.recent_days)
   -- todo 第3、最近30日统计
   , page_stats_30d AS (
    -- a. 浏览首页和商品详情页人数
    SELECT '2024-09-18'                           AS dt
         , 30                                     AS recent_days
         -- 浏览首页人数
         , SUM(IF(page_id = 'home', 1, 0))        AS home_count
         -- 浏览商品详情页人数
         , SUM(IF(page_id = 'good_detail', 1, 0)) AS good_detail_count
    FROM gmall.dws_traffic_page_visitor_page_view_1d
    WHERE dt >= date_sub('2024-09-18', 29)
      AND dt <= '2024-09-18'
      AND page_id IS NOT NULL
      AND page_id IN ('home', 'good_detail'))
   , cart_stats_30d AS (
    -- b. 加入购物车人数
    SELECT '2024-09-18'   AS dt
         , 30             AS recent_days
         , count(user_id) AS cart_count
    FROM gmall.dws_trade_user_order_1d
    WHERE dt >= date_sub('2024-09-18', 29)
      AND dt <= '2024-09-18')
   , order_stats_30d AS (
    -- c. 下单人数
    SELECT '2024-09-18'   AS dt
         , 30             AS recent_days
         , count(user_id) AS order_count
    FROM gmall.dws_trade_user_cart_add_1d
    WHERE dt >= date_sub('2024-09-18', 29)
      AND dt <= '2024-09-18')
   , payment_stats_30d AS (
    -- d. 支付人数
    SELECT '2024-09-18'   AS dt
         , 30             AS recent_days
         , count(user_id) AS payment_count
    FROM gmall.dws_trade_user_payment_1d
    WHERE dt >= date_sub('2024-09-18', 29)
      AND dt <= '2024-09-18')
   , stats_30d AS (
    -- e. 合并人数统计
    SELECT ps.dt
         , ps.recent_days
         , ps.home_count
         , ps.good_detail_count
         , cs.cart_count
         , os.order_count
         , pms.payment_count
    FROM page_stats_30d ps
             LEFT JOIN cart_stats_30d cs ON ps.dt = cs.dt AND ps.recent_days = cs.recent_days
             LEFT JOIN order_stats_30d os ON ps.dt = os.dt AND ps.recent_days = os.recent_days
             LEFT JOIN payment_stats_30d pms ON ps.dt = pms.dt AND ps.recent_days = pms.recent_days)
-- todo 第5、插入保存
INSERT OVERWRITE TABLE
gmall.ads_user_action
-- todo 第4、历史统计
SELECT dt, recent_days, home_count, good_detail_count, cart_count, order_count, payment_count FROM gmall.ads_user_action
UNION
SELECT dt, recent_days, home_count, good_detail_count, cart_count, order_count, payment_count FROM stats_1d
UNION ALL
SELECT dt, recent_days, home_count, good_detail_count, cart_count, order_count, payment_count FROM stats_7d
UNION ALL
SELECT dt, recent_days, home_count, good_detail_count, cart_count, order_count, payment_count FROM stats_30d
;


-- =============================================================================
-- todo 2.5 最近7日内连续3日下单用户数
-- =============================================================================
/*
    `dt`                            STRING COMMENT '统计日期',
    `recent_days`                   BIGINT COMMENT '最近天数,7:最近7天',
    `order_continuously_user_count` BIGINT COMMENT '连续3日下单用户数
*/

WITH tmp1 AS (
    -- step1. 去重
    SELECT user_id,
           date_id
    FROM gmall.dwd_trade_order_detail_inc
    WHERE dt >= date_sub('2024-09-18', 6)
      AND dt <= '2024-09-18'
    GROUP BY user_id, date_id)
   , tmp2 AS (
    -- step2. 序号
    SELECT user_id
         , date_id
         , row_number() over (PARTITION BY user_id ORDER BY date_id) AS rk
    FROM tmp1)
   , tmp3 AS (
    -- step3. 差值
    SELECT user_id
         , date_id
         , rk
         , date_sub(date_id, rk) AS date_diff
    FROM tmp2)
   , tmp4 AS (
    -- step4. 分组、计数
    SELECT user_id
         , date_diff
         , count(*)              AS days
         , collect_list(date_id) AS date_list
    FROM tmp3
    GROUP BY user_id, date_diff)
-- 保存数据
INSERT OVERWRITE TABLE gmall.ads_order_continuously_user_count
-- 历史统计
SELECT dt, recent_days, order_continuously_user_count FROM gmall.ads_order_continuously_user_count
UNION
-- step5. 过滤、去重
SELECT '2024-09-18'            AS dt
     , 7                       AS recent_days
     , count(DISTINCT user_id) AS order_continously_user_count
FROM tmp4
WHERE days >= 3
;


