package net.bwie.gmall.udtf;

import org.apache.hadoop.hive.ql.exec.Description;
import org.apache.hadoop.hive.ql.exec.UDFArgumentException;
import org.apache.hadoop.hive.ql.metadata.HiveException;
import org.apache.hadoop.hive.ql.udf.generic.GenericUDTF;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspectorFactory;
import org.apache.hadoop.hive.serde2.objectinspector.PrimitiveObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.StructObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.primitive.PrimitiveObjectInspectorFactory;
import org.json.JSONArray;

import java.util.ArrayList;
import java.util.List;

/**
 * 自定义UDTF函数，解析json字符串: [{}, {}, ...]，输出多个 {}、{}、...
 *      https://cwiki.apache.org/confluence/display/Hive/DeveloperGuide+UDTF
 */
@Description(name = "explode_json_array",
	value = "_FUNC_(a) - separates the elements of json array a into multiple json rows.")
public class ExplodeJsonArray extends GenericUDTF {

	@Override
	public StructObjectInspector initialize(ObjectInspector[] argOIs)
		throws UDFArgumentException {
		// 1. 参数合法性检查
		if (argOIs.length != 1) {
			throw new UDFArgumentException("explode_json_array 只需要一个参数");
		}

		// 2. 第一个参数必须为string
		//判断参数是否为基础数据类型
		if (argOIs[0].getCategory() != ObjectInspector.Category.PRIMITIVE) {
			throw new UDFArgumentException("explode_json_array 只接受基础类型参数");
		}
		//将参数对象检查器强转为基础类型对象检查器
		PrimitiveObjectInspector argumentOI = (PrimitiveObjectInspector) argOIs[0];

		//判断参数是否为String类型
		if (argumentOI.getPrimitiveCategory() != PrimitiveObjectInspector.PrimitiveCategory.STRING) {
			throw new UDFArgumentException("explode_json_array 只接受string类型的参数");
		}

		// 3. 定义返回值名称和类型
		List<String> fieldNames = new ArrayList<String>();
		fieldNames.add("items");

		List<ObjectInspector> fieldOIs = new ArrayList<ObjectInspector>();
		fieldOIs.add(PrimitiveObjectInspectorFactory.javaStringObjectInspector);

		return ObjectInspectorFactory.getStandardStructObjectInspector(fieldNames, fieldOIs);
	}

	/**
	 * 实现对数据处理逻辑，并且输出结果：解析JSON Array数组字符串数据，一个个输出解析后json字符串
	 */
	@Override
	public void process(Object[] objects) throws HiveException {
		// 1.获取传入的数据
		String jsonArrayStr = objects[0].toString();
		// 2.将string转换为json数组
		JSONArray jsonArray = new JSONArray(jsonArrayStr);
		// 3.循环一次，取出数组中的一个json，并写出
		for (int index = 0; index < jsonArray.length(); index++) {
			// 获取每个数据
			String jsonStr = jsonArray.getString(index);
			// 输出：发送出去
			forward(new String[]{jsonStr});
		}
	}

	@Override
	public void close() throws HiveException {
	}

}
