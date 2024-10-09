/*
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
CREATE FUNCTION number_average as 'net.bwie.gmall.udaf.NumberAverageUDAF'
    USING JAR 'hdfs://node101:8020/user/hive/jars/sql-udf.jar.jar';

-- 查看函数文档
DESC FUNCTION number_average;

-- 测试
WITH
    tmp1 AS (
        SELECT 85 AS score, 'zhangsan' AS name
        UNION
        SELECT 80 AS score, 'zhangsan' AS name
        UNION
        SELECT 90 AS score, 'zhangsan' AS name
        UNION
        SELECT 70 AS score, 'lisi' AS name
        UNION
        SELECT 60 AS score, 'lisi' AS name
    )
SELECT
    name
    , number_average(score) AS average_score
FROM tmp1
GROUP BY name
;


-- 删除函数
DROP FUNCTION number_average;


DESC FUNCTION EXTENDED avg;
/*
avg(x) - Returns the mean of a set of numbers
Function class:org.apache.hadoop.hive.ql.udf.generic.GenericUDAFAverage
Function type:BUILTIN
*/
