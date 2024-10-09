package net.bwie.gmall.udf;

import org.apache.hadoop.hive.ql.exec.Description;
import org.apache.hadoop.hive.ql.exec.UDF;

/**
 * 自定义UDF函数，将字符串中单词转换为小写: HELLO，输出hello
 */
@Description(name = "string_lower",
	value = "_FUNC_(a) - Returns str with all characters changed to lowercase.")
public class StringLowerUDF extends UDF {

	/**
	 * 定义evaluate方法，实现数据处理
	 */
	public String evaluate (final String str) {
		if (str == null) {
			return null;
		}
		return str.toLowerCase();
	}

}
