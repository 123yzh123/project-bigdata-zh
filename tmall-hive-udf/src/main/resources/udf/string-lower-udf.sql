/*
-- 上传jar包
    jar包sql-udf.jar上传到虚拟机中/home/bwei目录下

-- 创建目录
hdfs dfs -mkdir -p /user/hive/jars

-- 上传jar包
hdfs dfs -put /home/bwei/sql-udf.jar.jar /user/hive/jars

-- 如果修改了自定义函数重新生成jar包怎么处理？
-- 只需要替换HDFS路径上的旧jar包，然后重启Hive客户端即可。
*/

-- 创建函数
CREATE FUNCTION string_lower AS 'net.bwie.gmall.udf.StringLowerUDF'
    USING JAR 'hdfs://node101:8020/user/hive/jars/sql-udf.jar.jar';

-- 查看函数文档
DESC FUNCTION string_lower;

-- 测试
SELECT
    'HELLO' as x1
    , string_lower('HELLO') AS lower_x1
;


-- 删除函数
DROP FUNCTION string_lower;


DESC FUNCTION EXTENDED lower;
/*
lower(str) - Returns str with all characters changed to lowercase
Synonyms: lcase
Example:
  > SELECT lower('Facebook') FROM src LIMIT 1;
  'facebook'
Function class:org.apache.hadoop.hive.ql.udf.generic.GenericUDFLower
Function type:BUILTIN

*/
