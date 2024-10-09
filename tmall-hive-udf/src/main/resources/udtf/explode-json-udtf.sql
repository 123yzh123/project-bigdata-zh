/*
Hive UDTF 官网：
    https://cwiki.apache.org/confluence/display/Hive/DeveloperGuide+UDTF
-- 上传jar包
    jar包sql-udf-1.0.0.jar上传到虚拟机中/home/bwei目录下

-- 创建目录
hdfs dfs -mkdir -p /user/hive/jars

-- 上传jar包
hdfs dfs -put /home/bwei/sql-udf.jar.jar /user/hive/jars

-- 如果修改了自定义函数重新生成jar包怎么处理？
-- 只需要替换HDFS路径上的旧jar包，然后重启Hive客户端即可。
*/

-- 创建函数
CREATE FUNCTION explode_json_array as 'net.bwie.gmall.udtf.ExplodeJsonArray'
    USING JAR 'hdfs://node101:8020/user/hive/jars/sql-udf.jar.jar';

-- 查看函数文档
DESC FUNCTION explode_json_array;

-- 测试1
WITH t1 AS (
    SELECT '[{"action_id":"get_coupon","item":"3","item_type":"coupon_id","ts":1693553368564}]' AS actions
)
SELECT
    action
FROM t1
LATERAL VIEW explode_json_array(actions) tmp AS action
;

-- 测试2
WITH t2 AS (
    SELECT '[{"display_type":"query","item":"2","item_type":"sku_id","order":1,"pos_id":2},{"display_type":"promotion","item":"33","item_type":"sku_id","order":2,"pos_id":1},{"display_type":"promotion","item":"32","item_type":"sku_id","order":3,"pos_id":2},{"display_type":"promotion","item":"13","item_type":"sku_id","order":4,"pos_id":4},{"display_type":"promotion","item":"2","item_type":"sku_id","order":5,"pos_id":1},{"display_type":"recommend","item":"7","item_type":"sku_id","order":6,"pos_id":1},{"display_type":"query","item":"22","item_type":"sku_id","order":7,"pos_id":2},{"display_type":"promotion","item":"12","item_type":"sku_id","order":8,"pos_id":3},{"display_type":"promotion","item":"22","item_type":"sku_id","order":9,"pos_id":3},{"display_type":"promotion","item":"26","item_type":"sku_id","order":10,"pos_id":1}]' AS displays
)
SELECT
    display
FROM t2
LATERAL VIEW explode_json_array(displays) tmp AS display
;


-- 删除函数
DROP FUNCTION explode_json_array;


